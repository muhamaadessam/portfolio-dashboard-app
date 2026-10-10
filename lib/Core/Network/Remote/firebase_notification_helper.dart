import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:portfolio_app/Core/core.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseNotificationHelper {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? firebaseToken;
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static bool _listenersInitialized = false;

  static Future<void> init(String uid) async {
    try {
      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        await unregisterToken(uid);
        return;
      }

      if (!_listenersInitialized) {
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
        FirebaseMessaging.onMessage.listen(
          (message) => unawaited(_showForegroundMessage(message)),
        );
        _listenersInitialized = true;
      }

      firebaseToken = await firebaseMessaging.getToken();
      await _saveToken(uid, firebaseToken);
      _tokenRefreshSubscription ??= firebaseMessaging.onTokenRefresh.listen(
        (token) => unawaited(_saveToken(uid, token)),
      );
    } catch (error) {
      debugPrint('Could not register FCM notifications: $error');
    }
  }

  static Future<void> _saveToken(String uid, String? token) async {
    if (token == null || FirebaseAuth.instance.currentUser?.uid != uid) return;
    try {
      await FirebaseFirestore.instance
          .collection('config')
          .doc('admin_fcm_device_token')
          .set({
            'uid': uid,
            'token': token,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (error) {
      debugPrint('Could not save FCM token: $error');
    }
  }

  static Future<void> unregisterToken(String uid) async {
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    try {
      await FirebaseFirestore.instance
          .collection('config')
          .doc('admin_fcm_device_token')
          .delete();
    } catch (error) {
      debugPrint('Could not remove FCM token: $error');
    }
  }

  static Future<void> _showForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title;
    final body = notification?.body;
    if (title == null && body == null) return;
    final notificationId =
        (message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch) &
        0x7fffffff;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        LocalNotificationHelper.channelId,
        'Portfolio activity',
        channelDescription:
            'Portfolio visits, CV downloads, and contact messages',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body ?? ''),
      ),
    );

    await LocalNotificationHelper.flutterLocalNotificationsPlugin.show(
      notificationId,
      title ?? 'Portfolio activity',
      body,
      details,
      payload: message.data['telegramLogId']?.toString(),
    );
  }
}
