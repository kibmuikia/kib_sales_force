import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kib_sales_force/data/models/export.dart' show Visit;
import 'package:kib_sales_force/core/utils/common_enum.dart' show StringVisitStatusExtension, VisitStatus;

class VisitDetailsBottomSheet extends StatelessWidget {
  final Visit visit;

  const VisitDetailsBottomSheet({super.key, required this.visit});

  static Future<T?> show<T>(BuildContext context, Visit visit) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VisitDetailsBottomSheet(visit: visit),
      ),
    );
  }

  Widget _buildPill(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = visit.status.tryFromString() ?? VisitStatus.created;
    final statusColor = colorScheme.primary;
    final statusBg = colorScheme.primaryContainer;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final visitDate = dateFormat.format(visit.visitDate);
    final createdAt = dateFormat.format(visit.createdAt);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Visit Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visit ID',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visit.id.toString(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Status & Dates
              Row(
                children: [
                  _buildPill(status.label, statusBg, statusColor),
                  const SizedBox(width: 12),
                  _buildPill('Visit: $visitDate', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: colorScheme.outline),
                  const SizedBox(width: 6),
                  Text('Created', style: theme.textTheme.labelMedium),
                  const SizedBox(width: 8),
                  _buildPill(createdAt, colorScheme.surfaceVariant, colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 24),
              // Location
              Text(
                'Location',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  visit.location,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
              // Customer
              Text(
                'Customer',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  visit.customerId.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 32),
              // Actions (optional, e.g. Edit, Share)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () {
                        // TODO: Implement edit
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      onPressed: () {
                        // TODO: Implement share
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 