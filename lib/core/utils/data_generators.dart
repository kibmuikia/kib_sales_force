// To be used for generating sample data

import 'dart:math' show Random;

import 'package:kib_sales_force/data/models/activity.dart';
import 'package:kib_sales_force/data/models/customer.dart';
import 'package:kib_sales_force/data/models/visit.dart';

/// Generates a list of sample customers
List<Customer> generateCustomers(int count) {
  final random = Random();
  final names = [
    'John Smith',
    'Emma Johnson',
    'Michael Brown',
    'Sarah Davis',
    'David Wilson',
    'Lisa Anderson',
    'James Taylor',
    'Jennifer Martinez',
    'Robert Garcia',
    'Patricia Robinson',
  ];

  return List.generate(
    count,
    (index) => Customer(
      id: index + 1,
      name: names[random.nextInt(names.length)],
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
    ),
  );
}

/// Generates a list of sample activities
List<Activity> generateActivities(int count) {
  final random = Random();
  final descriptions = [
    'Product demonstration',
    'Sales pitch',
    'Contract negotiation',
    'Follow-up meeting',
    'Customer feedback session',
    'Product training',
    'Account review',
    'New feature showcase',
    'Support session',
    'Strategic planning',
  ];

  return List.generate(
    count,
    (index) => Activity(
      id: index + 1,
      description: descriptions[random.nextInt(descriptions.length)],
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
    ),
  );
}

/// Generates a list of sample visits
List<Visit> generateVisits(int count, {required List<Customer> customers}) {
  final random = Random();
  final locations = [
    '123 Main St, Springfield',
    '456 Oak Ave, Riverside',
    '789 Pine Rd, Lakeside',
    '321 Elm St, Hilltop',
    '654 Maple Dr, Valley View',
  ];

  final statuses = ['created', 'ongoing', 'completed', 'cancelled'];

  return List.generate(
    count,
    (index) {
      final visitDate = DateTime.now().add(Duration(days: random.nextInt(30)));
      final activitiesDone = List.generate(
        random.nextInt(5),
        (i) => i + 1,
      );

      return Visit(
        id: index + 1,
        customerId: customers[random.nextInt(customers.length)].id,
        visitDate: visitDate,
        status: statuses[random.nextInt(statuses.length)],
        location: locations[random.nextInt(locations.length)],
        notes: 'Sample visit notes for visit ${index + 1}',
        activitiesDone: activitiesDone,
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
      );
    },
  );
}

