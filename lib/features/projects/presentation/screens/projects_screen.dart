// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/create_projects_use_case.dart';
import '../../projects.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends BaseView<ProjectsCubit, ProjectsState> {
  ProjectsScreen({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      CustomAppBar(title: 'Projects Screen');

  @override
  Widget body(BuildContext context, ProjectsState state) {
    return ProjectScreenBody();
  }
}

class ProjectScreenBody extends StatefulWidget {
  const ProjectScreenBody({super.key});

  @override
  State<ProjectScreenBody> createState() => _ProjectScreenBodyState();
}

class _ProjectScreenBodyState extends State<ProjectScreenBody> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedStatus;
  String _sortBy = 'name'; // 'name' or 'featured'

  final List<String> _categories = [
    'Mobile',
    'Web',
    'Desktop',
    'Backend',
    'Full Stack',
    'UI/UX',
    'Other'
  ];

  final List<String> _statuses = [
    'Active',
    'Completed',
    'In Progress',
    'Planned'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    final projectsCubit = context.read<ProjectsCubit>();
    final formKey = GlobalKey<FormState>();
    
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final languagesController = TextEditingController();
    final List<Map<String, TextEditingController>> linkControllers = [];
    
    String? selectedCategory;
    String? selectedStatus;
    bool isFeatured = false;
    String imageUrl = '';
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              title: const TextTitle('Add Project'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        // Image Upload / Preview
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondTextColor),
                              ),
                              child: imageUrl.isNotEmpty
                                  ? CustomNetworkImage(image: imageUrl)
                                  : Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: AppColors.secondTextColor,
                                      ),
                                    ),
                            ),
                            if (isUploading)
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
                          onPressed: isUploading
                              ? null
                              : () async {
                                  setStateDialog(() {
                                    isUploading = true;
                                  });
                                  try {
                                    final imageBytes = await pickImage();
                                    if (imageBytes != null) {
                                      final url = await uploadImageToCloudinary(imageBytes);
                                      setStateDialog(() {
                                        imageUrl = url;
                                      });
                                    }
                                  } catch (e) {
                                    context.errorSnackBar(title: 'Image upload failed: $e');
                                  } finally {
                                    setStateDialog(() {
                                      isUploading = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.upload, color: Colors.white),
                          label: TextBody14(
                            imageUrl.isNotEmpty ? 'Change Image' : 'Upload Image',
                            color: Colors.white,
                          ),
                        ),

                        // Input fields
                        CustomTextFormField(
                          controller: nameController,
                          label: 'Project Title *',
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Title is required' : null,
                        ),

                        CustomTextFormField(
                          controller: descController,
                          label: 'Description *',
                          maxLines: 3,
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Description is required' : null,
                        ),

                        CustomTextFormField(
                          controller: languagesController,
                          label: 'Technologies (comma separated) *',
                          hint: 'Flutter, Dart, Firebase',
                          textColor: AppColors.reverseTextColor(context),
                          color: AppColors.mainColor,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Technologies are required' : null,
                        ),

                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondTextColor,
                                    fontFamily: 'Cairo',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.secondTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.mainColor),
                                  ),
                                ),
                                style: TextStyle(
                                  color: AppColors.reverseTextColor(context),
                                  fontFamily: 'Cairo',
                                ),
                                dropdownColor: AppColors.containerBackgroundColor(context),
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
                                    selectedCategory = val;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondTextColor,
                                    fontFamily: 'Cairo',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.secondTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.mainColor),
                                  ),
                                ),
                                style: TextStyle(
                                  color: AppColors.reverseTextColor(context),
                                  fontFamily: 'Cairo',
                                ),
                                dropdownColor: AppColors.containerBackgroundColor(context),
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
                                    selectedStatus = val;
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
                            const TextBody14('Project Links', fontWeight: FontWeight.bold),
                            TextButton.icon(
                              onPressed: () {
                                setStateDialog(() {
                                  linkControllers.add({
                                    'title': TextEditingController(),
                                    'link': TextEditingController(),
                                  });
                                });
                              },
                              icon: Icon(Icons.add, color: AppColors.mainColor, size: 16),
                              label: TextBody12('Add Link', color: AppColors.mainColor),
                            ),
                          ],
                        ),

                        // Links List
                        if (linkControllers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextBody12(
                              'No links added yet.',
                              color: AppColors.secondTextColor,
                            ),
                          )
                        else
                          Column(
                            children: List.generate(linkControllers.length, (index) {
                              final controllers = linkControllers[index];
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
                                        textColor: AppColors.reverseTextColor(context),
                                        color: AppColors.mainColor,
                                        validator: (val) => val == null || val.trim().isEmpty
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
                                        textColor: AppColors.reverseTextColor(context),
                                        color: AppColors.mainColor,
                                        validator: (val) => val == null || val.trim().isEmpty
                                            ? 'Required'
                                            : null,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: AppColors.errorColor),
                                      onPressed: () {
                                        setStateDialog(() {
                                          controllers['title']!.dispose();
                                          controllers['link']!.dispose();
                                          linkControllers.removeAt(index);
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
                          value: isFeatured,
                          activeColor: AppColors.mainColor,
                          checkColor: Colors.white,
                          onChanged: (val) {
                            setStateDialog(() {
                              isFeatured = val ?? false;
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
                  onPressed: () {
                    for (var ctrl in linkControllers) {
                      ctrl['title']?.dispose();
                      ctrl['link']?.dispose();
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: TextBody14('Cancel', color: AppColors.secondTextColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (imageUrl.isEmpty) {
                        context.errorSnackBar(title: 'Please upload a project image');
                        return;
                      }

                      final languages = languagesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      final links = linkControllers.map((ctrl) {
                        return LinkModel(
                          title: ctrl['title']!.text.trim(),
                          link: ctrl['link']!.text.trim(),
                        );
                      }).toList();

                      projectsCubit.createProject(
                        CreateProjectsRequest(
                          project: ProjectsModel(
                            id: '',
                            projectName: nameController.text.trim(),
                            projectDescription: descController.text.trim(),
                            projectImage: imageUrl,
                            projectLanguages: languages,
                            links: links,
                            category: selectedCategory,
                            status: selectedStatus,
                            isFeatured: isFeatured,
                          ),
                        ),
                      );
                      for (var ctrl in linkControllers) {
                        ctrl['title']?.dispose();
                        ctrl['link']?.dispose();
                      }
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
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        // Filter and sort projects locally
        final filteredProjects = state.projects.where((project) {
          final query = _searchQuery.toLowerCase();
          final matchesQuery = project.projectName.toLowerCase().contains(query) ||
              project.projectDescription.toLowerCase().contains(query);
          final matchesCategory = _selectedCategory == null || project.category == _selectedCategory;
          final matchesStatus = _selectedStatus == null || project.status == _selectedStatus;
          
          return matchesQuery && matchesCategory && matchesStatus;
        }).toList();

        // Sort projects
        if (_sortBy == 'name') {
          filteredProjects.sort((a, b) => a.projectName.toLowerCase().compareTo(b.projectName.toLowerCase()));
        } else if (_sortBy == 'featured') {
          filteredProjects.sort((a, b) {
            final aFeatured = a.isFeatured == true ? 1 : 0;
            final bFeatured = b.isFeatured == true ? 1 : 0;
            return bFeatured.compareTo(aFeatured); // Descending featured first
          });
        }

        return CustomScaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: Icon(Icons.add, color: AppColors.mainColor),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  // Search & Filter Section
                  Column(
                    spacing: 12,
                    children: [
                      CustomTextFormField(
                        controller: _searchController,
                        label: 'Search Projects...',
                        textColor: AppColors.reverseTextColor(context),
                        color: AppColors.mainColor,
                        prefixIcon: Icon(Icons.search, color: AppColors.mainColor),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                      
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Category Filter Dropdown
                          Container(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedCategory,
                              hint: const Text('All Categories'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.secondTextColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.mainColor),
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.reverseTextColor(context),
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                              dropdownColor: AppColors.containerBackgroundColor(context),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Categories')),
                                ..._categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedCategory = val;
                                });
                              },
                            ),
                          ),
                          
                          // Status Filter Dropdown
                          Container(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              hint: const Text('All Statuses'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.secondTextColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.mainColor),
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.reverseTextColor(context),
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                              dropdownColor: AppColors.containerBackgroundColor(context),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Statuses')),
                                ..._statuses.map((status) => DropdownMenuItem(value: status, child: Text(status))),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedStatus = val;
                                });
                              },
                            ),
                          ),

                          // Sort Dropdown
                          Container(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              initialValue: _sortBy,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.secondTextColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.mainColor),
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.reverseTextColor(context),
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                              dropdownColor: AppColors.containerBackgroundColor(context),
                              items: const [
                                DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                                DropdownMenuItem(value: 'featured', child: Text('Sort by Featured')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _sortBy = val ?? 'name';
                                });
                              },
                            ),
                          ),

                          // Clear Filters Button
                          if (_searchQuery.isNotEmpty ||
                              _selectedCategory != null ||
                              _selectedStatus != null ||
                              _sortBy != 'name')
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                  _selectedCategory = null;
                                  _selectedStatus = null;
                                  _sortBy = 'name';
                                });
                              },
                              icon: Icon(Icons.clear, color: AppColors.errorColor),
                              label: TextBody12('Clear Filters', color: AppColors.errorColor),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Project List Grid/Wrap
                  if (filteredProjects.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: TextBody14('No projects found matching the criteria.'),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 32,
                      runSpacing: 32,
                      children: List.generate(
                        filteredProjects.length,
                        (index) => ProjectCard(project: filteredProjects[index]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
