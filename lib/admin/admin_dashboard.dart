import 'package:flutter/material.dart';

import 'admin_screens.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

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
