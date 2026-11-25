import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.projectUrl,
    this.projectImageUrl = '',
    this.status = 'ongoing',
    this.id,
  });

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String techStack;
  final String projectUrl;
  final String status;

  @JsonKey(defaultValue: '')
  final String projectImageUrl;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id']?.toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      techStack: (json['tech_stack'] ?? json['status'] ?? '').toString(),
      projectUrl: (json['project_url'] ?? json['external_url'] ?? '')
          .toString(),
      projectImageUrl: (json['project_image_url'] ?? json['image_path'] ?? '')
          .toString(),
      status: (json['status'] ?? 'ongoing').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'tech_stack': techStack,
      'project_url': projectUrl,
      'project_image_url': projectImageUrl,
      // Compatibility keys for the existing Django Tutorial 07 ProjectSerializer.
      'status': status,
      'image_path': projectImageUrl,
      'external_url': projectUrl,
    };
  }
}
