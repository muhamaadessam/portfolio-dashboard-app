import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/use_cases/update_projects_use_case.dart';
import '../../projects.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectsEntity project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _languagesController;
  final List<Map<String, TextEditingController>> _linkControllers = [];

  String? _selectedCategory;
  String? _selectedStatus;
  bool _isFeatured = false;
  String _imageUrl = '';
  bool _isUploading = false;

  final List<String> _categories = [
    'Mobile',
    'Web',
    'Desktop',
    'Backend',
    'Full Stack',
    'UI/UX',
    'Other',
  ];

  final List<String> _statuses = [
    'Active',
    'Completed',
    'In Progress',
    'Planned',
  ];

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  void _initFields() {
    _nameController = TextEditingController(text: widget.project.projectName);
    _descController = TextEditingController(
      text: widget.project.projectDescription,
    );
    _languagesController = TextEditingController(
      text: widget.project.projectLanguages.join(', '),
    );

    // Dispose previous controllers in _linkControllers if they exist
    for (var ctrl in _linkControllers) {
      ctrl['title']?.dispose();
      ctrl['link']?.dispose();
    }
    _linkControllers.clear();
    for (var link in widget.project.links) {
      _linkControllers.add({
        'title': TextEditingController(text: link.title),
        'link': TextEditingController(text: link.link),
      });
    }

    _selectedCategory = widget.project.category;
    if (_selectedCategory != null && !_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Other';
    }

    _selectedStatus = widget.project.status;
    _isFeatured = widget.project.isFeatured ?? false;
    _imageUrl = widget.project.projectImage;
  }

  @override
  void didUpdateWidget(covariant ProjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project != widget.project) {
      _initFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _languagesController.dispose();
    for (var ctrl in _linkControllers) {
      ctrl['title']?.dispose();
      ctrl['link']?.dispose();
    }
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: const TextTitle('Delete Project'),
          content: TextBody14(
            'Are you sure you want to delete "${widget.project.projectName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: TextBody14('Cancel', color: AppColors.secondTextColor),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ProjectsCubit>().deleteProject(widget.project.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                elevation: 0,
              ),
              child: const TextBody14('Delete', color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    final projectsCubit = context.read<ProjectsCubit>();
    _initFields(); // Reset fields to current widget state

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              title: const TextTitle('Edit Project'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        // Image Upload / Preview section
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.secondTextColor,
                                ),
                              ),
                              child: _imageUrl.isNotEmpty
                                  ? CustomNetworkImage(image: _imageUrl)
                                  : Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: AppColors.secondTextColor,
                                      ),
                                    ),
                            ),
                            if (_isUploading)
                              Container(
                                color: Colors.black45,
                                height: 150,
                                width: double.infinity,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),

                        ElevatedButton.icon(
                          onPressed: _isUploading
                              ? null
                              : () async {
                                  setStateDialog(() {
                                    _isUploading = true;
                                  });
                                  try {
                                    final imageBytes = await pickImage();
                                    if (imageBytes != null) {
                                      final url = await uploadImageToCloudinary(
                                        imageBytes,
                                      );
                                      setStateDialog(() {
                                        _imageUrl = url;
                                      });
                                    }
                                  } catch (e) {
                                    context.errorSnackBar(
                                      title: 'Image upload failed: $e',
                                    );
                                  } finally {
                                    setStateDialog(() {
                                      _isUploading = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.upload, color: Colors.white),
                          label: TextBody14(
                            _imageUrl.isNotEmpty
                                ? 'Change Image'
                                : 'Upload Image',
                            color: Colors.white,
                          ),
                        ),

                        // Form Fields
                        CustomTextFormField(
                          controller: _nameController,
                          label: 'Project Title *',
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Title is required'
                              : null,
                        ),

                        CustomTextFormField(
                          controller: _descController,
                          label: 'Description *',
                          maxLines: 3,
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Description is required'
                              : null,
                        ),

                        CustomTextFormField(
                          controller: _languagesController,
                          label: 'Technologies (comma separated) *',
                          hint: 'Flutter, Dart, Firebase',
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Technologies are required'
                              : null,
                        ),

                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondTextColor,
                                    fontFamily: 'Cairo',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondTextColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: AppColors.reverseTextColor(context),
                                  fontFamily: 'Cairo',
                                ),
                                dropdownColor:
                                    AppColors.containerBackgroundColor(context),
                                items: _categories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setStateDialog(() {
                                    _selectedCategory = val;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondTextColor,
                                    fontFamily: 'Cairo',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondTextColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: AppColors.reverseTextColor(context),
                                  fontFamily: 'Cairo',
                                ),
                                dropdownColor:
                                    AppColors.containerBackgroundColor(context),
                                items: _statuses
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setStateDialog(() {
                                    _selectedStatus = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        // Links Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextBody14(
                              'Project Links',
                              fontWeight: FontWeight.bold,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setStateDialog(() {
                                  _linkControllers.add({
                                    'title': TextEditingController(),
                                    'link': TextEditingController(),
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: AppColors.mainColor,
                                size: 16,
                              ),
                              label: TextBody12(
                                'Add Link',
                                color: AppColors.mainColor,
                              ),
                            ),
                          ],
                        ),

                        // Links List
                        if (_linkControllers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextBody12(
                              'No links added yet.',
                              color: AppColors.secondTextColor,
                            ),
                          )
                        else
                          Column(
                            children: List.generate(_linkControllers.length, (
                              index,
                            ) {
                              final controllers = _linkControllers[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomTextFormField(
                                        controller: controllers['title']!,
                                        label: 'Title *',
                                        textColor: AppColors.reverseTextColor(
                                          context,
                                        ),
                                        color: AppColors.mainColor,
                                        validator: (val) =>
                                            val == null || val.trim().isEmpty
                                            ? 'Required'
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 3,
                                      child: CustomTextFormField(
                                        controller: controllers['link']!,
                                        label: 'URL *',
                                        textColor: AppColors.reverseTextColor(
                                          context,
                                        ),
                                        color: AppColors.mainColor,
                                        validator: (val) =>
                                            val == null || val.trim().isEmpty
                                            ? 'Required'
                                            : null,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.errorColor,
                                      ),
                                      onPressed: () {
                                        setStateDialog(() {
                                          controllers['title']!.dispose();
                                          controllers['link']!.dispose();
                                          _linkControllers.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),

                        CheckboxListTile(
                          title: const TextBody14('Featured Project'),
                          value: _isFeatured,
                          activeColor: AppColors.mainColor,
                          checkColor: Colors.white,
                          onChanged: (val) {
                            setStateDialog(() {
                              _isFeatured = val ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: TextBody14('Cancel', color: AppColors.secondTextColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_imageUrl.isEmpty) {
                        context.errorSnackBar(
                          title: 'Please upload a project image',
                        );
                        return;
                      }

                      final languages = _languagesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      final links = _linkControllers.map((ctrl) {
                        return LinkModel(
                          title: ctrl['title']!.text.trim(),
                          link: ctrl['link']!.text.trim(),
                        );
                      }).toList();

                      projectsCubit.updateProject(
                        UpdateProjectsRequest(
                          project: ProjectsModel(
                            id: widget.project.id,
                            projectName: _nameController.text.trim(),
                            projectDescription: _descController.text.trim(),
                            projectImage: _imageUrl,
                            projectLanguages: languages,
                            links: links,
                            category: _selectedCategory,
                            status: _selectedStatus,
                            isFeatured: _isFeatured,
                          ),
                        ),
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    elevation: 0,
                  ),
                  child: const TextBody14('Save', color: Colors.white),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondTextColor),
        color: AppColors.containerBackgroundColor(context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            image: widget.project.projectImage,
            width: double.infinity,
            height: 200,
          ),
          Container(
            color: AppColors.secondTextColor,
            height: 1,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextTitle(
                        widget.project.projectName,
                        fontSize: 20,
                      ),
                    ),
                    if (widget.project.isFeatured == true)
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                  ],
                ),

                // Badges/Tags for Category & Status
                if ((widget.project.category != null &&
                        widget.project.category!.isNotEmpty) ||
                    (widget.project.status != null &&
                        widget.project.status!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Row(
                      spacing: 8,
                      children: [
                        if (widget.project.category != null &&
                            widget.project.category!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.mainColor),
                            ),
                            child: TextBody12(
                              widget.project.category!,
                              color: AppColors.mainColor,
                            ),
                          ),
                        if (widget.project.status != null &&
                            widget.project.status!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.secondTextColor,
                              ),
                            ),
                            child: TextBody12(
                              widget.project.status!,
                              color: AppColors.secondTextColor,
                            ),
                          ),
                      ],
                    ),
                  ),

                TextBody14(
                  widget.project.projectDescription,
                  color: AppColors.secondTextColor,
                ),
              ],
            ),
          ),
          if (widget.project.projectLanguages.isNotEmpty)
            Column(
              children: [
                Container(
                  color: AppColors.secondTextColor,
                  height: 1,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 8,
                    children: List.generate(
                      widget.project.projectLanguages.length,
                      (index) => Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextBody14(
                              widget.project.projectLanguages[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          Container(
            color: AppColors.secondTextColor,
            height: 1,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Links (if present)
                Row(
                  spacing: 12,
                  children: widget.project.links.map((link) {
                    IconData iconData = Icons.link;
                    final title = link.title.toLowerCase();
                    if (title.contains('github') ||
                        title.contains('git') ||
                        title.contains('code') ||
                        title.contains('repo')) {
                      iconData = Icons.code;
                    } else if (title.contains('play') ||
                        title.contains('google') ||
                        title.contains('android')) {
                      iconData = Icons.android_rounded;
                    } else if (title.contains('apple') ||
                        title.contains('ios') ||
                        title.contains('app store')) {
                      iconData = Icons.apple;
                    } else if (title.contains('website') ||
                        title.contains('web')) {
                      iconData = Icons.web;
                    } else if (title.contains('microsoft') ||
                        title.contains('microsoft store')) {
                      iconData = Icons.window;
                    } else if (title.contains('linux') ||
                        title.contains('ubuntu')) {
                      iconData = Icons.computer;
                    } else if (title.contains('figma')) {
                      iconData = Icons.design_services;
                    } else if (title.contains('flutter')) {
                      iconData = Icons.flutter_dash;
                    } else if (title.contains('dart')) {
                      iconData = Icons.code;
                    }

                    return IconButton(
                      tooltip: link.title,
                      icon: Icon(iconData, color: AppColors.mainColor),
                      onPressed: () async {
                        final uri = Uri.tryParse(link.link);
                        if (uri != null) {
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Could not launch ${link.link}',
                                  ),
                                  backgroundColor: AppColors.errorColor,
                                ),
                              );
                            }
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
                // Actions (Edit, Delete)
                Row(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Edit Project',
                      icon: Icon(Icons.edit, color: AppColors.mainColor),
                      onPressed: () => _showEditDialog(context),
                    ),
                    IconButton(
                      tooltip: 'Delete Project',
                      icon: Icon(Icons.delete, color: AppColors.errorColor),
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
