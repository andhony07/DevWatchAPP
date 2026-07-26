class MonitoringMetric {
  const MonitoringMetric({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.progress,
    required this.description,
    required this.status,
    required this.trend,
  });

  final String id;
  final String name;
  final String value;
  final String unit;
  final double progress;
  final String description;
  final String status;
  final double trend;

  MonitoringMetric copyWith({
    String? id,
    String? name,
    String? value,
    String? unit,
    double? progress,
    String? description,
    String? status,
    double? trend,
  }) {
    return MonitoringMetric(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      progress: progress ?? this.progress,
      description: description ?? this.description,
      status: status ?? this.status,
      trend: trend ?? this.trend,
    );
  }
}
