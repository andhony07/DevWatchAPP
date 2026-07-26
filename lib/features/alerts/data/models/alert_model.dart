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

  AlertModel copyWith({
    String? id,
    String? title,
    String? description,
    String? source,
    AlertSeverity? severity,
    AlertStatus? status,
    String? triggeredAt,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      source: source ?? this.source,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }
}
