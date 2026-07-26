import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/alert_model.dart';

class AlertNotifier extends Notifier<List<AlertModel>> {
  @override
  List<AlertModel> build() {
    return const [
      AlertModel(
        id: '1',
        title: 'High CPU Usage',
        description: 'CPU utilization exceeded the configured 85% threshold.',
        source: 'Production API',
        severity: AlertSeverity.critical,
        status: AlertStatus.active,
        triggeredAt: '5 min ago',
      ),
      AlertModel(
        id: '2',
        title: 'Memory Threshold Reached',
        description: 'Memory utilization has remained above 80%.',
        source: 'Worker Service',
        severity: AlertSeverity.high,
        status: AlertStatus.acknowledged,
        triggeredAt: '18 min ago',
      ),
      AlertModel(
        id: '3',
        title: 'Response Time Increased',
        description: 'Average API response time increased above 300 ms.',
        source: 'API Gateway',
        severity: AlertSeverity.medium,
        status: AlertStatus.active,
        triggeredAt: '42 min ago',
      ),
      AlertModel(
        id: '4',
        title: 'Database Connection Recovered',
        description: 'Database connectivity returned to normal.',
        source: 'Database',
        severity: AlertSeverity.low,
        status: AlertStatus.resolved,
        triggeredAt: '2 hours ago',
      ),
    ];
  }

  void acknowledgeAlert(String id) {
    state = [
      for (final alert in state)
        if (alert.id == id)
          alert.copyWith(status: AlertStatus.acknowledged)
        else
          alert,
    ];
  }

  void resolveAlert(String id) {
    state = [
      for (final alert in state)
        if (alert.id == id)
          alert.copyWith(status: AlertStatus.resolved)
        else
          alert,
    ];
  }

  void resetAlerts() {
    ref.invalidateSelf();
  }
}

final alertProvider = NotifierProvider<AlertNotifier, List<AlertModel>>(
  AlertNotifier.new,
);
