import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../Core/Network/Remote/firebase_notification_helper.dart';
import '../Core/Notifications/local_notification_helper.dart';
import 'admin_screens.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
    required this.onSignOut,
    required this.adminUid,
  });

  final Future<void> Function() onSignOut;
  final String adminUid;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  StreamSubscription<RemoteMessage>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    unawaited(FirebaseNotificationHelper.init(widget.adminUid));
    LocalNotificationHelper.onNotificationTap = (_) => _showTelegramActivity();
    _notificationTapSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      (_) => _showTelegramActivity(),
    );
    unawaited(
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) _showTelegramActivity();
      }),
    );
  }

  void _showTelegramActivity() {
    if (mounted) setState(() => _selectedIndex = 6);
  }

  @override
  void dispose() {
    unawaited(_notificationTapSubscription?.cancel());
    LocalNotificationHelper.onNotificationTap = null;
    super.dispose();
  }

  static const _sections = [
    ('Overview', Icons.dashboard_outlined),
    ('Visitors', Icons.people_outline),
    ('Projects', Icons.work_outline),
    ('Skills', Icons.psychology_outlined),
    ('Experience', Icons.business_center_outlined),
    ('Messages', Icons.mail_outline),
    ('Telegram activity', Icons.notifications_active_outlined),
  ];

  Widget get _currentSection => switch (_selectedIndex) {
    0 => const AnalyticsScreen(),
    1 => const VisitorsScreen(),
    2 => const ProjectsAdminScreen(),
    3 => const SkillsAdminScreen(),
    4 => const ExperienceAdminScreen(),
    5 => const MessagesAdminScreen(),
    _ => const TelegramAdminScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final section = _sections[_selectedIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(section.$1),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          Navigator.of(context).pop();
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
            child: Text('Portfolio admin'),
          ),
          for (var index = 0; index < _sections.length; index++)
            NavigationDrawerDestination(
              icon: Icon(_sections[index].$2),
              label: Text(_sections[index].$1),
            ),
        ],
      ),
      body: SafeArea(child: _currentSection),
    );
  }
}
