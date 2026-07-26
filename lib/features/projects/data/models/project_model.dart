class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.environment,
    required this.cloudProvider,
    required this.status,
    required this.repositoryUrl,
  });

  final String id;
  final String name;
  final String description;
  final String environment;
  final String cloudProvider;
  final String status;
  final String repositoryUrl;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['projectName'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      environment: (json['environment'] ?? '').toString(),
      cloudProvider: (json['cloudProvider'] ?? '').toString(),
      status: (json['status'] ?? 'Operational').toString(),
      repositoryUrl: (json['repositoryUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'environment': environment,
      'cloudProvider': cloudProvider,
      'status': status,
      'repositoryUrl': repositoryUrl,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? environment,
    String? cloudProvider,
    String? status,
    String? repositoryUrl,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      environment: environment ?? this.environment,
      cloudProvider: cloudProvider ?? this.cloudProvider,
      status: status ?? this.status,
      repositoryUrl: repositoryUrl ?? this.repositoryUrl,
    );
  }
}
