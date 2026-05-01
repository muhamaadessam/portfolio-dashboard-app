import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:portfolio_app/Core/core.dart';

class FirebaseNotificationHelper {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? firebaseToken;

  static init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    firebaseToken = await firebaseMessaging.getToken();
    initPushNotification();
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await LocalNotificationHelper.flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: 'item x');

    debugPrint('message :: ${message.notification!.title}');
    debugPrint('sent');
  }

  static Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    await Firebase.initializeApp();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await LocalNotificationHelper.flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: 'item x');

    // const AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails('1', 'repeating channel name',
    //         channelDescription: 'repeating description');
    //
    // const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    //     DarwinNotificationDetails(threadIdentifier: 'thread_id');
    //
    // const NotificationDetails notificationDetails = NotificationDetails(
    //     android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);
    // await NotificationHelper.flutterLocalNotificationsPlugin.show(
    //     1,
    //     message.notification!.title,
    //     message.notification!.body,
    //     notificationDetails);

    debugPrint('message :: ${message.notification!.title}');
    debugPrint('send');
  }

  static Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
