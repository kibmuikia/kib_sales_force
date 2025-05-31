import 'package:flutter/material.dart';

class CreateVisitScreen extends StatelessWidget {
  const CreateVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Visit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Placeholder(),
      ),
    );
  }
} 