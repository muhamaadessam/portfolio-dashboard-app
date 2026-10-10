import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'admin_data.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<DashboardStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = AdminData.getDashboardStats();
  }

  Future<void> _refresh() async {
    final future = AdminData.getDashboardStats();
    setState(() => _stats = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardStats>(
      future: _stats,
      builder: (context, snapshot) {
        if (snapshot.hasError) return _LoadError(message: '${snapshot.error}', onRetry: _refresh);
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data!;
        final eventEntries = stats.events.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Portfolio analytics', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('Visitors, visits, CV downloads, and tracked interactions.'),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 650 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _MetricCard(label: 'Unique visitors', value: stats.totalVisitors),
                      _MetricCard(label: 'Total visits', value: stats.totalVisits),
                      _MetricCard(label: 'CV downloads', value: stats.cvDownloads),
                      _MetricCard(label: 'Page views', value: stats.events['page_view'] ?? 0),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Project performance',
                subtitle: 'Project opens and tracked button clicks.',
                child: stats.projects.isEmpty
                    ? const Text('No project analytics yet.')
                    : Column(
                        children: [
                          for (final project in stats.projects.take(12))
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(project.name),
                              subtitle: project.buttons.isEmpty
                                  ? null
                                  : Text(project.buttons.entries
                                      .map((entry) => '${entry.key}: ${entry.value}')
                                      .join(' · ')),
                              trailing: Text('${project.opens} opens'),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Detailed analytics',
                subtitle: 'Aggregates start with the detailed tracking release.',
                child: Column(
                  children: [
                    _MetricRow(
                      label: 'Tracked sessions',
                      value: _number(stats.analytics['sessions']).toString(),
                    ),
                    _MetricRow(
                      label: 'Average visible time / page',
                      value: '${(_number(stats.analytics['durationMs']) / _number(stats.analytics['pageViews']).clamp(1, 1 << 30) / 1000).round()}s',
                    ),
                    _MetricRow(
                      label: 'Average session scroll depth',
                      value: '${(_number(stats.analytics['scrollDepth']) / _number(stats.analytics['sessions']).clamp(1, 1 << 30)).round()}%',
                    ),
                    const SizedBox(height: 12),
                    for (final entry in [
                      ('Traffic sources', stats.analytics['sources']),
                      ('Referrer hosts', stats.analytics['referrers']),
                      ('Company links', stats.analytics['companies']),
                      ('Countries', stats.analytics['countries']),
                      ('Cities', stats.analytics['cities']),
                      ('Devices', stats.analytics['devices']),
                      ('Browsers', stats.analytics['browsers']),
                      ('Operating systems', stats.analytics['operatingSystems']),
                    ])
                      _RankedAnalytics(title: entry.$1, values: entry.$2),
                    _SectionReach(analytics: stats.analytics),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'All tracked events',
                child: stats.events.isEmpty
                    ? const Text('No events yet.')
                    : Column(children: [
                        for (final entry in eventEntries)
                          _MetricRow(label: _eventLabel(entry.key), value: entry.value.toString()),
                      ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  late Future<DashboardStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = AdminData.getDashboardStats();
  }

  Future<void> _refresh() async {
    final future = AdminData.getDashboardStats();
    setState(() => _stats = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardStats>(
      future: _stats,
      builder: (context, snapshot) {
        if (snapshot.hasError) return _LoadError(message: '${snapshot.error}', onRetry: _refresh);
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final visitors = snapshot.data!.visitors;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: visitors.isEmpty
              ? ListView(children: const [SizedBox(height: 180), Center(child: Text('No visitors recorded yet.'))])
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: visitors.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final visitor = visitors[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                        title: Text('Visitor ${visitor.id}'),
                        subtitle: Text([
                          '${visitor.visits} visits',
                          if (visitor.lastSeen != null) 'Last seen ${_formatDate(visitor.lastSeen)}',
                          if (visitor.city != null || visitor.country != null)
                            [visitor.city, visitor.country].whereType<String>().join(', '),
                          if (visitor.device != null) visitor.device!,
                        ].join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => VisitorDetailScreen(visitor: visitor),
                        )),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class VisitorDetailScreen extends StatefulWidget {
  const VisitorDetailScreen({super.key, required this.visitor});

  final AdminVisitor visitor;

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  late Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)> _details;

  @override
  void initState() {
    super.initState();
    _details = _load();
  }

  Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)> _load() async {
    final events = await AdminData.getVisitorEvents(widget.visitor.id);
    final sessions = await AdminData.getVisitorSessions(widget.visitor.id);
    return (events, sessions);
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _details = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final visitor = widget.visitor;
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor profile')),
      body: FutureBuilder<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.hasError) return _LoadError(message: '${snapshot.error}', onRetry: _refresh);
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!.$1;
          final sessions = snapshot.data!.$2;
          final latestSession = sessions.isEmpty ? <String, dynamic>{} : sessions.first;
          final sessionLocation = [latestSession['city'], latestSession['country']]
              .whereType<String>()
              .where((value) => value.isNotEmpty)
              .join(', ');
          final sessionDevice = [latestSession['device'], latestSession['browser'], latestSession['os']]
              .whereType<String>()
              .where((value) => value.isNotEmpty)
              .join(' · ');
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visitor ${visitor.id}', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('${visitor.visits} visits · ${sessions.length} tracked sessions'),
                        if (visitor.firstSeen != null) Text('First seen: ${_formatDate(visitor.firstSeen)}'),
                        if (visitor.lastSeen != null) Text('Last seen: ${_formatDate(visitor.lastSeen)}'),
                        if (sessionLocation.isNotEmpty || visitor.city != null || visitor.country != null)
                          Text('Location: ${sessionLocation.isNotEmpty ? sessionLocation : [visitor.city, visitor.country].whereType<String>().join(', ')}'),
                        if (sessionDevice.isNotEmpty || visitor.device != null || visitor.browser != null || visitor.os != null)
                          Text('Device: ${sessionDevice.isNotEmpty ? sessionDevice : [visitor.device, visitor.browser, visitor.os].whereType<String>().join(' · ')}'),
                        if (visitor.source != null || latestSession.isNotEmpty)
                          Text('Latest source: ${visitor.source ?? _source(latestSession['source'])}'),
                        if (latestSession['language'] != null) Text('Language: ${latestSession['language']}'),
                        if (latestSession['timezone'] != null) Text('Timezone: ${latestSession['timezone']}'),
                        if (latestSession['screen'] != null) Text('Screen: ${latestSession['screen']}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('What this visitor did', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (events.isEmpty)
                  const Card(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No detailed events yet. Older visits only have counters.'),
                  )),
                for (final event in events)
                  Card(
                    child: ListTile(
                      leading: Icon(_eventIcon('${event['event'] ?? ''}')),
                      title: Text(_eventLabel('${event['event'] ?? 'activity'}')),
                      subtitle: Text([
                        if ('${event['target'] ?? ''}'.isNotEmpty) '${event['target']}',
                        if ('${event['projectName'] ?? ''}'.isNotEmpty && event['projectName'] != event['target']) '${event['projectName']}',
                        if ('${event['button'] ?? ''}'.isNotEmpty) 'Button: ${event['button']}',
                        if ('${event['path'] ?? ''}'.isNotEmpty) '${event['path']}',
                        if (event['durationMs'] != null) 'Visible ${(_number(event['durationMs']) / 1000).round()}s · scroll ${event['scrollDepth'] ?? 0}%',
                        if (AdminData.date(event['timestamp']) != null) _formatDate(AdminData.date(event['timestamp'])),
                        if ('${event['sessionId'] ?? ''}'.isNotEmpty) 'Session ${event['sessionId']}',
                      ].join('\n')),
                      isThreeLine: true,
                    ),
                  ),
                if (events.length == 100)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Showing the latest 100 events.'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TelegramAdminScreen extends StatefulWidget {
  const TelegramAdminScreen({super.key});

  @override
  State<TelegramAdminScreen> createState() => _TelegramAdminScreenState();
}

class _TelegramAdminScreenState extends State<TelegramAdminScreen> {
  String _filter = 'all';
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _logs;

  @override
  void initState() {
    super.initState();
    _logs = _load();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _load() async {
    final result = await FirebaseFirestore.instance
        .collection('telegram_logs')
        .orderBy('createdAt', descending: true)
        .get();
    return result.docs;
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _logs = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      future: _logs,
      builder: (context, snapshot) {
        if (snapshot.hasError) return _LoadError(message: '${snapshot.error}', onRetry: _refresh);
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final logs = snapshot.data!.map((doc) => {'id': doc.id, ...doc.data()}).toList();
        final visitorLogs = logs.where((log) => log['type'] == 'visitor').toList();
        final visitorGroups = <String, List<Map<String, dynamic>>>{};
        for (final log in visitorLogs) {
          final payload = _map(log['payload']);
          final id = '${payload['visitorId'] ?? log['id']}';
          (visitorGroups[id] ??= []).add(log);
        }
        final filtered = logs.where((log) => _filter == 'all' || log['type'] == _filter).toList();
        final visitorItems = <Map<String, dynamic>>[];
        if (_filter == 'all' || _filter == 'visitor') {
          for (final entry in visitorGroups.entries) {
            entry.value.sort((a, b) => _logTime(b).compareTo(_logTime(a)));
            visitorItems.add({
              'kind': 'visitor',
              'visitorId': entry.key,
              'logs': entry.value,
              'latest': entry.value.first,
            });
          }
        }
        final otherItems = filtered
            .where((log) => log['type'] != 'visitor')
            .map((log) => {'kind': 'log', 'log': log})
            .toList();
        final items = [...visitorItems, ...otherItems]
          ..sort((a, b) => _itemTime(b).compareTo(_itemTime(a)));
        final newVisitors = visitorLogs
            .where((log) => _map(log['payload'])['isNewVisitor'] == true)
            .map((log) => _map(log['payload'])['visitorId'])
            .where((id) => id != null)
            .toSet()
            .length;
        final returningVisits = visitorLogs
            .where((log) => _map(log['payload'])['isNewVisitor'] != true)
            .length;
        final cvDownloads = logs.where((log) => log['type'] == 'cv_download').length;
        final contacts = logs.where((log) => log['type'] == 'contact').length;
        final topLocations = _rankLogValues(visitorLogs, (payload) =>
            [payload['city'], payload['country']].where((value) => value != null && '$value'.isNotEmpty).join(', '));
        final topDevices = _rankLogValues(visitorLogs, (payload) => '${payload['device'] ?? ''}');

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              LayoutBuilder(builder: (context, constraints) {
                final columns = constraints.maxWidth > 650 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    _MetricCard(label: 'Unique visitors', value: visitorGroups.length),
                    _MetricCard(label: 'New visitors', value: newVisitors),
                    _MetricCard(label: 'Returning visits', value: returningVisits),
                    _MetricCard(label: 'CV downloads', value: cvDownloads),
                    _MetricCard(label: 'Contact messages', value: contacts),
                    _MetricCard(label: 'CV downloads / visitor (%)', value: visitorGroups.isEmpty ? 0 : (cvDownloads / visitorGroups.length * 100).round()),
                    _MetricCard(label: 'Messages / visitor (%)', value: visitorGroups.isEmpty ? 0 : (contacts / visitorGroups.length * 100).round()),
                  ],
                );
              }),
              if (topLocations.isNotEmpty || topDevices.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        if (topLocations.isNotEmpty) _TopValues(title: 'Top locations', values: topLocations),
                        if (topDevices.isNotEmpty) _TopValues(title: 'Top devices', values: topDevices),
                      ],
                    ),
                  ),
                ),
              Wrap(
                spacing: 8,
                children: [
                  for (final filter in ['all', 'visitor', 'cv_download', 'contact'])
                    ChoiceChip(
                      label: Text(_filterName(filter)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No records match this filter.')),
                ),
              for (final item in items) _TelegramActivityCard(item: item),
            ],
          ),
        );
      },
    );
  }
}

class _TelegramActivityCard extends StatelessWidget {
  const _TelegramActivityCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    if (item['kind'] == 'visitor') {
      final logs = (item['logs'] as List).cast<Map<String, dynamic>>();
      final latest = logs.first;
      final payload = _map(latest['payload']);
      final visitor = AdminVisitor.fromMap('${item['visitorId']}', {
        ...payload,
        'visits': payload['totalVisits'] ?? logs.length,
        'firstSeen': logs.isEmpty ? null : _logTime(logs.last),
        'lastSeen': _logTime(latest),
      });
      return Card(
        child: ExpansionTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text('Visitor ${visitor.id}', maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${visitor.visits} visits · ${logs.length} Telegram visit notifications · ${_formatDate(_logTime(latest))}'),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            _PayloadDetails(payload: payload),
            const SizedBox(height: 8),
            for (final log in logs)
              ListTile(
                dense: true,
                leading: const Icon(Icons.visibility_outlined, size: 18),
                title: Text('Visit ${_map(log['payload'])['totalVisits'] ?? ''}'),
                subtitle: Text(_formatDate(_logTime(log))),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => VisitorDetailScreen(visitor: visitor),
                )),
                icon: const Icon(Icons.timeline),
                label: const Text('View full visitor activity'),
              ),
            ),
          ],
        ),
      );
    }
    final log = item['log'] as Map<String, dynamic>;
    final payload = _map(log['payload']);
    final type = '${log['type'] ?? 'activity'}';
    return Card(
      child: ExpansionTile(
        leading: Icon(type == 'contact' ? Icons.mail_outline : Icons.download_outlined),
        title: Text(type == 'contact' ? 'Contact message · ${payload['name'] ?? 'Unknown'}' : 'CV download'),
        subtitle: Text(_formatDate(_logTime(log))),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [_PayloadDetails(payload: payload)],
      ),
    );
  }
}

class _PayloadDetails extends StatelessWidget {
  const _PayloadDetails({required this.payload});
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final known = {'visitorId', 'name', 'email', 'message', 'isNewVisitor'};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final key in [
          'totalVisits', 'totalUnique', 'isNewVisitor', 'country', 'region', 'city', 'device', 'browser', 'os', 'timezone', 'source', 'firstTouch', 'path', 'visitorId', 'email', 'message',
        ])
          if (payload[key] != null && payload[key] != '')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text('${_fieldName(key)}: ${_displayValue(payload[key])}'),
            ),
        for (final entry in payload.entries)
          if (!known.contains(entry.key) && !{
            'totalVisits', 'totalUnique', 'country', 'region', 'city', 'device', 'browser', 'os', 'timezone', 'source', 'firstTouch', 'path',
          }.contains(entry.key))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text('${_fieldName(entry.key)}: ${_displayValue(entry.value)}'),
            ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text('$value', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      );
}

class _TopValues extends StatelessWidget {
  const _TopValues({required this.title, required this.values});
  final String title;
  final List<MapEntry<String, int>> values;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            for (final entry in values)
              _MetricRow(label: entry.key, value: '${entry.value}'),
          ],
        ),
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.subtitle});
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      );
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 8),
            Text(value, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      );
}

class _RankedAnalytics extends StatelessWidget {
  const _RankedAnalytics({required this.title, required this.values});
  final String title;
  final Object? values;

  @override
  Widget build(BuildContext context) {
    final counts = _intMap(values).entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    if (counts.isEmpty) return const SizedBox.shrink();
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text('${counts.length} values'),
      children: [for (final entry in counts.take(8)) _MetricRow(label: entry.key, value: '${entry.value}')],
    );
  }
}

class _SectionReach extends StatelessWidget {
  const _SectionReach({required this.analytics});
  final Map<String, dynamic> analytics;

  @override
  Widget build(BuildContext context) {
    final sections = _intMap(analytics['sections']);
    final homeSessions = _number(analytics['homepageSessions']);
    if (sections.isEmpty && homeSessions == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Homepage section reach (${homeSessions.round()} sessions)', style: Theme.of(context).textTheme.titleMedium),
        for (final name in ['projects', 'experience', 'contact'])
          _MetricRow(
            label: name,
            value: '${sections[name] ?? 0} / ${homeSessions.round()} · ${homeSessions == 0 ? 0 : ((sections[name] ?? 0) / homeSessions * 100).round()}%',
          ),
      ],
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined),
              const SizedBox(height: 8),
              Text('Could not load data: $message', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
            ],
          ),
        ),
      );
}

String _eventLabel(String event) {
  final words = event.replaceAll('_', ' ');
  if (event == 'page_view') return 'Page view';
  if (event == 'project_click') return 'Project opened';
  if (event == 'external_link_click') return 'External link clicked';
  if (event == 'cv_download') return 'CV downloaded';
  if (event == 'contact_submit') return 'Contact form submitted';
  if (event == 'section_view') return 'Section viewed';
  if (event == 'engagement') return 'Page engagement';
  return words;
}

String _filterName(String filter) => switch (filter) {
  'visitor' => 'Visitors',
  'cv_download' => 'CV downloads',
  'contact' => 'Messages',
  _ => 'All activity',
};

IconData _eventIcon(String event) => switch (event) {
  'page_view' => Icons.web,
  'project_click' => Icons.open_in_new,
  'external_link_click' => Icons.link,
  'cv_download' => Icons.download,
  'contact_submit' => Icons.mail_outline,
  'section_view' => Icons.view_agenda_outlined,
  _ => Icons.touch_app_outlined,
};

String _formatDate(DateTime? date) => date == null ? 'Unknown date' : DateFormat('MMM d, yyyy · h:mm a').format(date.toLocal());

DateTime _logTime(Map<String, dynamic> log) =>
    AdminData.date(log['createdAt']) ?? AdminData.date(log['timestamp']) ?? DateTime(0);

DateTime _itemTime(Map<String, dynamic> item) {
  if (item['kind'] == 'visitor') return _logTime((item['latest'] as Map).cast<String, dynamic>());
  return _logTime((item['log'] as Map).cast<String, dynamic>());
}

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

Map<String, int> _intMap(Object? value) => {
  if (value is Map)
    for (final entry in value.entries)
      if (entry.value is num) '${entry.key}': (entry.value as num).toInt(),
};

List<MapEntry<String, int>> _rankLogValues(
  List<Map<String, dynamic>> logs,
  String Function(Map<String, dynamic>) getValue,
) {
  final counts = <String, int>{};
  for (final log in logs) {
    final value = getValue(_map(log['payload']));
    if (value.isNotEmpty && value != 'Unknown') counts[value] = (counts[value] ?? 0) + 1;
  }
  final entries = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  return entries.take(4).toList();
}

double _number(Object? value) => value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

String _source(Object? value) {
  final source = _map(value);
  return '${source['utmSource'] ?? source['referrer'] ?? 'Direct'}';
}

String _displayValue(Object? value) => value is Map || value is List ? value.toString() : '$value';

String _fieldName(String value) => value.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)!.toLowerCase()}').replaceAll('_', ' ');
