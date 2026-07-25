enum AlertSeverity { critical, high, medium, low }

enum AlertStatus { active, acknowledged, resolved }

class AlertModel {
  const AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    required this.severity,
    required this.status,
    required this.triggeredAt,
  });

  final String id;
  final String title;
  final String description;
  final String source;
  final AlertSeverity severity;
  final AlertStatus status;
  final String triggeredAt;
}
