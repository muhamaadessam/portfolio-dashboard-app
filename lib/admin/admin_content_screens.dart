import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Core/Components/PickImage/pick_image.dart';

enum _FieldType { text, multiline, list, links, boolean, select, nullableDate, image, images }

class _AdminField {
  const _AdminField(
    this.key,
    this.label, {
    this.type = _FieldType.text,
    this.required = false,
    this.options = const [],
    this.hint,
  });

  final String key;
  final String label;
  final _FieldType type;
  final bool required;
  final List<String> options;
  final String? hint;
}

class ProjectsAdminScreen extends StatelessWidget {
  const ProjectsAdminScreen({super.key});

  static const fields = [
    _AdminField('id', 'ID / order', hint: 'Leave empty to use the document ID'),
    _AdminField('projectName', 'Project name', required: true),
    _AdminField('category', 'Category', required: true),
    _AdminField('status', 'Status', type: _FieldType.select, required: true, options: ['planning', 'in-progress', 'testing', 'completed', 'client-account-closed']),
    _AdminField('testingGroupLink', 'Testing group link'),
    _AdminField('projectDescription', 'Description', type: _FieldType.multiline, required: true),
    _AdminField('projectImage', 'Main image URL', type: _FieldType.image),
    _AdminField('techStack', 'Tech stack', type: _FieldType.list, hint: 'One item per line'),
    _AdminField('keyFeaturesAndBenefits', 'Key features & benefits', type: _FieldType.list, hint: 'One item per line'),
    _AdminField('myContribution', 'My contribution', type: _FieldType.list, hint: 'One item per line'),
    _AdminField('links', 'Project links', type: _FieldType.links, hint: 'One per line: Title | https://...'),
    _AdminField('isFeatured', 'Featured project', type: _FieldType.boolean),
    _AdminField('screenshots', 'Screenshots', type: _FieldType.images, hint: 'One image URL per line'),
    _AdminField('overview', 'Overview', type: _FieldType.multiline),
    _AdminField('challenge', 'Challenge', type: _FieldType.multiline),
    _AdminField('solution', 'Solution', type: _FieldType.multiline),
    _AdminField('myRole', 'My role', type: _FieldType.multiline),
  ];

  @override
  Widget build(BuildContext context) => const _CollectionManagerScreen(
        collection: 'projects',
        title: 'Projects',
        fields: fields,
        summaryKey: 'projectName',
        extraSummaryKey: 'category',
      );
}

class SkillsAdminScreen extends StatelessWidget {
  const SkillsAdminScreen({super.key});

  static const fields = [
    _AdminField('title', 'Group title', required: true),
    _AdminField('skills', 'Skills', type: _FieldType.list, required: true, hint: 'One skill per line'),
  ];

  @override
  Widget build(BuildContext context) => const _CollectionManagerScreen(
        collection: 'skills',
        title: 'Skills',
        fields: fields,
        summaryKey: 'title',
        extraSummaryKey: 'skills',
      );
}

class ExperienceAdminScreen extends StatelessWidget {
  const ExperienceAdminScreen({super.key});

  static const fields = [
    _AdminField('title', 'Job title', required: true),
    _AdminField('company', 'Company', required: true),
    _AdminField('location', 'Location', required: true),
    _AdminField('employmentType', 'Employment type', required: true),
    _AdminField('startDate', 'Start date (YYYY-MM)', required: true, hint: '2024-06'),
    _AdminField('endDate', 'End date (YYYY-MM)', type: _FieldType.nullableDate, hint: 'Leave current role checked for Present'),
    _AdminField('companyUrl', 'Company website or link'),
    _AdminField('description', 'Description', type: _FieldType.list, required: true, hint: 'One bullet per line'),
    _AdminField('skills', 'Skills', type: _FieldType.list, hint: 'One skill per line'),
  ];

  @override
  Widget build(BuildContext context) => const _CollectionManagerScreen(
        collection: 'experiences',
        title: 'Experience',
        fields: fields,
        summaryKey: 'title',
        extraSummaryKey: 'company',
        sortExperience: true,
      );
}

class _CollectionManagerScreen extends StatefulWidget {
  const _CollectionManagerScreen({
    required this.collection,
    required this.title,
    required this.fields,
    required this.summaryKey,
    required this.extraSummaryKey,
    this.sortExperience = false,
  });

  final String collection;
  final String title;
  final List<_AdminField> fields;
  final String summaryKey;
  final String extraSummaryKey;
  final bool sortExperience;

  @override
  State<_CollectionManagerScreen> createState() => _CollectionManagerScreenState();
}

class _CollectionManagerScreenState extends State<_CollectionManagerScreen> {
  late Future<List<Map<String, dynamic>>> _records;

  @override
  void initState() {
    super.initState();
    _records = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.collection).get();
    final records = snapshot.docs.map((doc) => {'_docId': doc.id, ...doc.data()}).toList();
    if (widget.sortExperience) {
      records.sort((a, b) {
        final aEnd = '${a['endDate'] ?? '9999-99'}';
        final bEnd = '${b['endDate'] ?? '9999-99'}';
        final byEnd = bEnd.compareTo(aEnd);
        return byEnd == 0 ? '${b['startDate'] ?? ''}'.compareTo('${a['startDate'] ?? ''}') : byEnd;
      });
    } else {
      records.sort((a, b) =>
          '${a[widget.summaryKey] ?? ''}'.toLowerCase().compareTo('${b[widget.summaryKey] ?? ''}'.toLowerCase()));
    }
    return records;
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _records = future);
    await future;
  }

  Future<void> _edit([Map<String, dynamic>? record]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _AdminRecordDialog(fields: widget.fields, record: record ?? const {}),
    );
    if (result == null) return;
    try {
      final collection = FirebaseFirestore.instance.collection(widget.collection);
      final docId = record?['_docId'] as String?;
      if (docId == null) {
        final doc = collection.doc();
        final id = '${result['id'] ?? ''}'.trim();
        result['id'] = id.isEmpty ? doc.id : id;
        await doc.set(result);
      } else {
        final id = '${result['id'] ?? ''}'.trim();
        result['id'] = id.isEmpty ? docId : id;
        await collection.doc(docId).update(result);
      }
      await _refresh();
    } catch (error) {
      if (mounted) _showSnack('Could not save ${widget.title.toLowerCase()}: $error');
    }
  }

  Future<void> _delete(Map<String, dynamic> record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${widget.title.toLowerCase()}?'),
        content: const Text('This permanently removes this record from the portfolio.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await FirebaseFirestore.instance.collection(widget.collection).doc(record['_docId']).delete();
      await _refresh();
    } catch (error) {
      if (mounted) _showSnack('Could not delete this record: $error');
    }
  }

  void _showSnack(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _records,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Could not load ${widget.title.toLowerCase()}: ${snapshot.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _refresh, child: const Text('Retry')),
            ]),
          ));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final records = snapshot.data!;
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refresh,
              child: records.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 160),
                      Center(child: Text('No ${widget.title.toLowerCase()} yet.')),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
                      itemCount: records.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final record = records[index];
                        final detail = record[widget.extraSummaryKey];
                        final detailText = detail is List ? detail.join(', ') : '${detail ?? ''}';
                        return Card(
                          child: ListTile(
                            title: Text('${record[widget.summaryKey] ?? 'Untitled'}'),
                            subtitle: detailText.isEmpty ? null : Text(detailText, maxLines: 2, overflow: TextOverflow.ellipsis),
                            onTap: () => _edit(record),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) => action == 'edit' ? _edit(record) : _delete(record),
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(value: 'delete', child: Text('Delete')),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                onPressed: () => _edit(),
                icon: const Icon(Icons.add),
                label: Text('Add ${widget.title == 'Experience' ? 'experience' : widget.title.toLowerCase().substring(0, widget.title.length - 1)}'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AdminRecordDialog extends StatefulWidget {
  const _AdminRecordDialog({required this.fields, required this.record});

  final List<_AdminField> fields;
  final Map<String, dynamic> record;

  @override
  State<_AdminRecordDialog> createState() => _AdminRecordDialogState();
}

class _AdminRecordDialogState extends State<_AdminRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, bool> _checks;
  late final Map<String, String?> _selections;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _checks = {};
    _selections = {};
    for (final field in widget.fields) {
      final value = field.key == 'techStack' && widget.record[field.key] == null
          ? widget.record['projectLanguages']
          : widget.record[field.key];
      switch (field.type) {
        case _FieldType.boolean:
          _checks[field.key] = value == true;
        case _FieldType.select:
          _selections[field.key] = value is String ? value : null;
        case _FieldType.list || _FieldType.images:
          _controllers[field.key] = TextEditingController(
            text: value is List ? value.join('\n') : '',
          );
        case _FieldType.links:
          _controllers[field.key] = TextEditingController(
            text: value is List
                ? value.map((link) {
                    final item = link is Map ? link : <String, dynamic>{};
                    final title = '${item['title'] ?? ''}';
                    final url = '${item['link'] ?? ''}';
                    return title.isEmpty ? url : '$title | $url';
                  }).join('\n')
                : '',
          );
        case _FieldType.text || _FieldType.multiline || _FieldType.image || _FieldType.nullableDate:
          _controllers[field.key] = TextEditingController(text: value == null ? '' : '$value');
      }
    }
    if (widget.record['endDate'] == null) _checks['endDate'] = true;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _upload(_AdminField field) async {
    setState(() => _uploading = true);
    try {
      final bytes = await pickImage();
      if (bytes == null) return;
      final url = await uploadImageToCloudinary(bytes);
      final controller = _controllers[field.key]!;
      controller.text = field.type == _FieldType.images && controller.text.trim().isNotEmpty
          ? '${controller.text.trim()}\n$url'
          : url;
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image upload failed: $error')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Map<String, dynamic> _values() {
    final values = <String, dynamic>{};
    for (final field in widget.fields) {
      final controller = _controllers[field.key];
      switch (field.type) {
        case _FieldType.boolean:
          values[field.key] = _checks[field.key] ?? false;
        case _FieldType.select:
          values[field.key] = _selections[field.key] ?? '';
        case _FieldType.nullableDate:
          values[field.key] = _checks[field.key] == true ? null : controller!.text.trim();
        case _FieldType.list || _FieldType.images:
          values[field.key] = controller!.text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
        case _FieldType.links:
          values[field.key] = controller!.text.split('\n').map((line) {
            final parts = line.split('|');
            return {
              'title': parts.length > 1 ? parts.first.trim() : '',
              'link': parts.length > 1 ? parts.skip(1).join('|').trim() : line.trim(),
            };
          }).where((link) => (link['link'] as String).isNotEmpty).toList();
        case _FieldType.text || _FieldType.multiline || _FieldType.image:
          values[field.key] = controller!.text.trim();
      }
    }
    return values;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final values = _values();
    if (values['status'] == 'testing' && !'${values['testingGroupLink'] ?? ''}'.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A valid HTTPS testing group link is required for a project in Testing.')));
      return;
    }
    Navigator.of(context).pop(values);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.record['_docId'] != null;
    return AlertDialog(
      title: Text(editing ? 'Edit record' : 'Add record'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [for (final field in widget.fields) _buildField(field)],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _uploading ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _uploading ? null : _save, child: const Text('Save')),
      ],
    );
  }

  Widget _buildField(_AdminField field) {
    if (field.type == _FieldType.boolean) {
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(field.label),
        value: _checks[field.key] ?? false,
        onChanged: (value) => setState(() => _checks[field.key] = value ?? false),
      );
    }
    if (field.type == _FieldType.select) {
      final current = _selections[field.key];
      final options = [...field.options, if (current != null && current.isNotEmpty && !field.options.contains(current)) current];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          initialValue: current,
          decoration: InputDecoration(labelText: field.label),
          items: options.map((value) => DropdownMenuItem(value: value, child: Text(value.replaceAll('-', ' ')))).toList(),
          onChanged: (value) => setState(() => _selections[field.key] = value),
          validator: field.required ? (value) => value == null || value.isEmpty ? 'Required' : null : null,
        ),
      );
    }
    if (field.type == _FieldType.nullableDate) {
      return Column(
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Currently working here (Present)'),
            value: _checks[field.key] ?? false,
            onChanged: (value) => setState(() => _checks[field.key] = value ?? false),
          ),
          if (_checks[field.key] != true) _textInput(field),
        ],
      );
    }
    if (field.type == _FieldType.image || field.type == _FieldType.images) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            _textInput(field),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _uploading ? null : () => _upload(field),
                icon: _uploading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.upload_outlined),
                label: Text(field.type == _FieldType.images ? 'Upload screenshot' : 'Upload image'),
              ),
            ),
          ],
        ),
      );
    }
    return _textInput(field);
  }

  Widget _textInput(_AdminField field) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: _controllers[field.key],
          minLines: field.type == _FieldType.multiline || field.type == _FieldType.list || field.type == _FieldType.links || field.type == _FieldType.images ? 3 : 1,
          maxLines: field.type == _FieldType.multiline || field.type == _FieldType.list || field.type == _FieldType.links || field.type == _FieldType.images ? 5 : 1,
          decoration: InputDecoration(labelText: field.label, hintText: field.hint),
          validator: (value) {
            if (field.required && (value == null || value.trim().isEmpty)) return 'Required';
            if ((field.key == 'startDate' || field.key == 'endDate') &&
                value != null &&
                value.trim().isNotEmpty &&
                !RegExp(r'^\d{4}-(0[1-9]|1[0-2])$').hasMatch(value.trim())) {
              return 'Use YYYY-MM, for example 2024-06.';
            }
            return null;
          },
        ),
      );
}

class MessagesAdminScreen extends StatefulWidget {
  const MessagesAdminScreen({super.key});

  @override
  State<MessagesAdminScreen> createState() => _MessagesAdminScreenState();
}

class _MessagesAdminScreenState extends State<MessagesAdminScreen> {
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _load();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _load() async => (await FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .get()).docs;

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _messages = future);
    await future;
  }

  Future<void> _delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This permanently removes the message.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await FirebaseFirestore.instance.collection('messages').doc(id).delete();
      await _refresh();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete message: $error')));
    }
  }

  Future<void> _markRead(String id) async {
    try {
      await FirebaseFirestore.instance.collection('messages').doc(id).update({'read': true});
      await _refresh();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update message: $error')));
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Could not load messages: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final messages = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: messages.isEmpty
                ? ListView(children: const [SizedBox(height: 160), Center(child: Text('No messages found.'))])
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final doc = messages[index];
                      final data = doc.data();
                      final createdAt = data['createdAt'];
                      final date = createdAt is Timestamp ? createdAt.toDate() : null;
                      final read = data['read'] == true;
                      return Card(
                        child: ExpansionTile(
                          leading: Icon(read ? Icons.drafts_outlined : Icons.mark_email_unread_outlined),
                          title: Text('${data['name'] ?? 'Unknown'}${read ? '' : ' · NEW'}'),
                          subtitle: Text('${data['email'] ?? ''} · ${date == null ? 'Unknown date' : DateFormat('MMM d, yyyy · h:mm a').format(date.toLocal())}'),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: [
                            Align(alignment: Alignment.centerLeft, child: Text('${data['message'] ?? ''}')),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 8,
                              children: [
                                if (!read) OutlinedButton.icon(onPressed: () => _markRead(doc.id), icon: const Icon(Icons.mark_email_read_outlined), label: const Text('Mark as read')),
                                TextButton.icon(onPressed: () => _delete(doc.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        },
      );
}
