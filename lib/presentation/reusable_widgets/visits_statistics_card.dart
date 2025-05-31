import 'package:flutter/material.dart';
import 'package:kib_sales_force/core/utils/common_enum.dart'
    show StringVisitStatusExtension, VisitStatus;
import 'package:kib_sales_force/data/models/export.dart' show Visit;

class VisitsStatisticsCard extends StatelessWidget {
  final List<Visit> visits;

  const VisitsStatisticsCard({
    super.key,
    required this.visits,
  });

  Map<VisitStatus, int> _getStatusCounts() {
    final counts = <VisitStatus, int>{};
    for (final status in VisitStatus.values) {
      counts[status] = 0;
    }

    for (final visit in visits) {
      final status = visit.status.tryFromString();
      if (status != null) {
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }

    return counts;
  }

  Widget _buildStatusRow(VisitStatus status, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            status.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusCounts = _getStatusCounts();
    final totalVisits = visits.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visit Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Total: $totalVisits',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            ...VisitStatus.values.map(
              (status) => _buildStatusRow(status, statusCounts[status] ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}
