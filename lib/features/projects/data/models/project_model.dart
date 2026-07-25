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
}
