import 'package:flutter/material.dart';

Future<bool?> showExitConfirmationDialog(BuildContext ctx) async {
  return await showDialog<bool>(
    context: ctx,
    builder:
        (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Exit Confirmation'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
  );
}
