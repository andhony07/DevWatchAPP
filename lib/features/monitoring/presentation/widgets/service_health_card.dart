import 'package:flutter/material.dart';

class ServiceHealthCard extends StatelessWidget {
  const ServiceHealthCard({super.key});

  @override
  Widget build(BuildContext context) {
    const services = [
      _Service(
        name: 'Production API',
        status: 'Operational',
        responseTime: '118 ms',
      ),
      _Service(
        name: 'Web Application',
        status: 'Operational',
        responseTime: '86 ms',
      ),
      _Service(
        name: 'Worker Service',
        status: 'Degraded',
        responseTime: '342 ms',
      ),
      _Service(name: 'Database', status: 'Operational', responseTime: '24 ms'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Health',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Current status of monitored services',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ...services.map((service) => _ServiceTile(service: service)),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final _Service service;

  @override
  Widget build(BuildContext context) {
    final isHealthy = service.status == 'Operational';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            isHealthy
                ? Icons.check_circle_outline
                : Icons.warning_amber_outlined,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  service.status,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            service.responseTime,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _Service {
  const _Service({
    required this.name,
    required this.status,
    required this.responseTime,
  });

  final String name;
  final String status;
  final String responseTime;
}
