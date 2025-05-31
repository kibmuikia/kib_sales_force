import 'package:flutter/material.dart';

class VisitDetailsScreen extends StatelessWidget {
  final String visitId;

  const VisitDetailsScreen({
    super.key,
    required this.visitId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Placeholder(
          child: Text('Visit ID: $visitId'),
        ),
      ),
    );
  }
} 