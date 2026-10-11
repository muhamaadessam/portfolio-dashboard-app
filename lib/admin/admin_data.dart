import 'package:cloud_firestore/cloud_firestore.dart';

class AdminVisitor {
  const AdminVisitor({
    required this.id,
    required this.visits,
    this.firstSeen,
    this.lastSeen,
    this.country,
    this.city,
    this.device,
    this.browser,
    this.os,
    this.source,
  });

  final String id;
  final int visits;
  final DateTime? firstSeen;
  final DateTime? lastSeen;
  final String? country;
  final String? city;
  final String? device;
  final String? browser;
  final String? os;
  final String? source;

  factory AdminVisitor.fromMap(String id, Map<String, dynamic> data) {
    final sourceData = data['source'];
    return AdminVisitor(
      id: id,
      visits: _asInt(data['visits']),
      firstSeen: _asDate(data['firstSeen']),
      lastSeen: _asDate(data['lastSeen']),
      country: _asString(data['country']),
      city: _asString(data['city']),
      device: _asString(data['device']),
      browser: _asString(data['browser']),
      os: _asString(data['os']),
      source: sourceData is Map
          ? _asString(sourceData['utmSource']) ??
                _asString(sourceData['referrer'])
          : _asString(sourceData),
    );
  }
}

class ProjectPerformance {
  const ProjectPerformance({
    required this.id,
    required this.name,
    required this.opens,
    required this.buttons,
  });

  final String id;
  final String name;
  final int opens;
  final Map<String, int> buttons;
}

class DashboardStats {
  const DashboardStats({
    required this.totalVisitors,
    required this.totalVisits,
    required this.cvDownloads,
    required this.events,
    required this.analytics,
    required this.projects,
    required this.visitors,
  });

  final int totalVisitors;
  final int totalVisits;
  final int cvDownloads;
  final Map<String, int> events;
  final Map<String, dynamic> analytics;
  final List<ProjectPerformance> projects;
  final List<AdminVisitor> visitors;
}

int _asInt(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;

String? _asString(Object? value) {
  if (value == null) return null;
  final result = value.toString().trim();
  return result.isEmpty ? null : result;
}

DateTime? _asDate(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  if (value is String) return DateTime.tryParse(value);
  return null;
}

String _analyticsKey(String value) {
  final key = value
      .trim()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return key.isEmpty ? 'unknown' : key.substring(0, key.length > 80 ? 80 : key.length);
}

class AdminData {
  static final _db = FirebaseFirestore.instance;

  static Future<DashboardStats> getDashboardStats() async {
    final snapshots = await Future.wait<dynamic>([
      _db.collection('stats').doc('visitors').get(),
      _db.collection('visitors').get(),
      _db.collection('stats').doc('cv_downloads').get(),
      _db.collection('stats').doc('events').get(),
      _db.collection('stats').doc('project_events').get(),
      _db.collection('projects').get(),
      _db.collection('stats').doc('analytics').get(),
    ]);

    final visitorStats = snapshots[0].data() ?? <String, dynamic>{};
    final legacyUsers = visitorStats['users'];
    final visitorsById = <String, AdminVisitor>{};
    if (legacyUsers is Map) {
      for (final entry in legacyUsers.entries) {
        visitorsById['${entry.key}'] = AdminVisitor(
          id: '${entry.key}',
          visits: _asInt(entry.value),
        );
      }
    }
    for (final visitorDoc in snapshots[1].docs) {
      visitorsById[visitorDoc.id] = AdminVisitor.fromMap(
        visitorDoc.id,
        visitorDoc.data(),
      );
    }
    final visitors = visitorsById.values.toList()
      ..sort((a, b) => b.visits.compareTo(a.visits));

    final rawEvents = snapshots[3].data() ?? <String, dynamic>{};
    final events = <String, int>{
      for (final entry in rawEvents.entries)
        if (entry.value is num) entry.key: (entry.value as num).toInt(),
    };
    final projectEvents = snapshots[4].data() ?? <String, dynamic>{};
    final projectSnapshot =
        snapshots[5] as QuerySnapshot<Map<String, dynamic>>;
    final projects = projectSnapshot.docs.map((doc) {
      final data = doc.data();
      final id = _asString(data['id']) ?? doc.id;
      final name = _asString(data['projectName']) ?? id;
      final key = _analyticsKey(id);
      final prefix = 'project_${key}_button_';
      final buttons = <String, int>{};
      for (final entry in projectEvents.entries) {
        if (entry.key.startsWith(prefix) &&
            !entry.key.startsWith('project_${key}_button_label_') &&
            entry.value is num) {
          final buttonKey = entry.key.substring(prefix.length);
          final label = _asString(projectEvents['project_${key}_button_label_$buttonKey']) ??
              buttonKey.replaceAll('_', ' ');
          buttons[label] = (entry.value as num).toInt();
        }
      }
      final oldKey = _analyticsKey(name);
      final modernOpens = _asInt(projectEvents['project_${key}_opens']);
      return ProjectPerformance(
        id: id,
        name: name,
        opens: modernOpens > 0 ? modernOpens : _asInt(rawEvents['project_click_$oldKey']),
        buttons: buttons,
      );
    }).toList()
      ..sort((a, b) => b.opens.compareTo(a.opens));

    final downloads = snapshots[2].data() ?? <String, dynamic>{};
    return DashboardStats(
      totalVisitors: _asInt(visitorStats['total_visitors']) == 0
          ? visitors.length
          : _asInt(visitorStats['total_visitors']),
      totalVisits: _asInt(visitorStats['total_visites'] ?? visitorStats['total_visits']) == 0
          ? visitors.fold(0, (sum, visitor) => sum + visitor.visits)
          : _asInt(visitorStats['total_visites'] ?? visitorStats['total_visits']),
      cvDownloads: _asInt(downloads['count']),
      events: events,
      analytics: snapshots[6].data() ?? <String, dynamic>{},
      projects: projects,
      visitors: visitors,
    );
  }

  static Future<List<Map<String, dynamic>>> getVisitorEvents(String visitorId) async {
    final snapshot = await _db
        .collection('visitor_events')
        .where('visitorId', isEqualTo: visitorId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  static Future<List<Map<String, dynamic>>> getVisitorSessions(String visitorId) async {
    final snapshot = await _db
        .collection('visitor_sessions')
        .where('visitorId', isEqualTo: visitorId)
        .get();
    final sessions = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    sessions.sort((a, b) =>
        (_asDate(b['startedAt']) ?? DateTime(0)).compareTo(
          _asDate(a['startedAt']) ?? DateTime(0),
        ));
    return sessions;
  }

  static DateTime? date(Object? value) => _asDate(value);
}
