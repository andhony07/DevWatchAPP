import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/monitoring_metric.dart';

class MonitoringNotifier extends Notifier<List<MonitoringMetric>> {
  @override
  List<MonitoringMetric> build() {
    return const [
      MonitoringMetric(
        id: 'cpu',
        name: 'CPU Usage',
        value: '68',
        unit: '%',
        progress: 0.68,
        description: 'Average CPU utilization',
        status: 'Normal',
        trend: 4.2,
      ),
      MonitoringMetric(
        id: 'memory',
        name: 'Memory Usage',
        value: '74',
        unit: '%',
        progress: 0.74,
        description: 'Current memory utilization',
        status: 'Warning',
        trend: 6.8,
      ),
      MonitoringMetric(
        id: 'disk',
        name: 'Disk Usage',
        value: '52',
        unit: '%',
        progress: 0.52,
        description: 'Current disk utilization',
        status: 'Normal',
        trend: -1.4,
      ),
      MonitoringMetric(
        id: 'response',
        name: 'Response Time',
        value: '184',
        unit: 'ms',
        progress: 0.37,
        description: 'Average API response time',
        status: 'Normal',
        trend: -8.3,
      ),
    ];
  }

  void updateMetric({
    required String id,
    required String value,
    required double progress,
    String? status,
    double? trend,
  }) {
    state = [
      for (final metric in state)
        if (metric.id == id)
          metric.copyWith(
            value: value,
            progress: progress,
            status: status,
            trend: trend,
          )
        else
          metric,
    ];
  }

  void resetMetrics() {
    ref.invalidateSelf();
  }
}

final monitoringProvider =
    NotifierProvider<MonitoringNotifier, List<MonitoringMetric>>(
      MonitoringNotifier.new,
    );
