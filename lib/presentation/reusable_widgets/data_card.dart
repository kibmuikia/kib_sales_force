import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const DataCard({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: icon != null ? Icon(icon, size: 32) : null,
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
