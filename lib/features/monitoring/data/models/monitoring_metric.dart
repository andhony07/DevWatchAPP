class MonitoringMetric {
  const MonitoringMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.progress,
    required this.description,
  });

  final String name;
  final String value;
  final String unit;
  final double progress;
  final String description;
}
