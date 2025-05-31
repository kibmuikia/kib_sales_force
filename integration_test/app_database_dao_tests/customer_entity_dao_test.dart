import 'package:app_database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late final DatabaseService databaseService;

  setUpAll(() async {
    databaseService = await DatabaseService.create();
  });

  tearDownAll(() {
    databaseService.close();
  });

  group('CustomerEntityDao Integration Tests', () {
    const testUserId = 'test_user_123';
    final testCustomer = CustomerEntity(
      autoId: 0,
      id: 1,
      name: 'John Doe',
      createdAt: DateTime.now(),
      userUid: testUserId,
    );

    test('should save and retrieve a customer', () async {
      // Save customer
      final savedId = databaseService.customerEntityDao.saveCustomer(testCustomer);
      expect(savedId, isNot(-1));

      // Retrieve customer
      final retrievedCustomer = databaseService.customerEntityDao.getCustomerById(savedId);
      expect(retrievedCustomer, isNotNull);
      expect(retrievedCustomer?.name, equals(testCustomer.name));
      expect(retrievedCustomer?.userUid, equals(testCustomer.userUid));
    });

    test('should get all customers', () async {
      // Save multiple customers
      final customers = [
        CustomerEntity(
          autoId: 0,
          id: 2,
          name: 'Jane Smith',
          createdAt: DateTime.now(),
          userUid: testUserId,
        ),
        CustomerEntity(
          autoId: 0,
          id: 3,
          name: 'Bob Johnson',
          createdAt: DateTime.now(),
          userUid: testUserId,
        ),
      ];

      final savedIds = databaseService.customerEntityDao.saveManyCustomers(customers);
      expect(savedIds.length, equals(customers.length));

      // Get all customers
      final allCustomers = databaseService.customerEntityDao.getCustomers();
      expect(allCustomers.length, greaterThanOrEqualTo(customers.length));
      expect(allCustomers.any((c) => c.name == 'Jane Smith'), isTrue);
      expect(allCustomers.any((c) => c.name == 'Bob Johnson'), isTrue);
    });

    test('should get customers for specific user', () async {
      const otherUserId = 'other_user_456';
      final otherUserCustomer = CustomerEntity(
        autoId: 0,
        id: 4,
        name: 'Alice Brown',
        createdAt: DateTime.now(),
        userUid: otherUserId,
      );

      // Save customer for other user
      final savedId = databaseService.customerEntityDao.saveCustomer(otherUserCustomer);
      expect(savedId, isNot(-1));

      // Get customers for test user
      final userCustomers = databaseService.customerEntityDao.getCustomersForUser(testUserId);
      expect(userCustomers.every((c) => c.userUid == testUserId), isTrue);
      expect(userCustomers.any((c) => c.userUid == otherUserId), isFalse);
    });

    test('should handle saving multiple customers', () async {
      final customers = List.generate(
        5,
        (index) => CustomerEntity(
          autoId: 0,
          id: 10 + index,
          name: 'Customer ${index + 1}',
          createdAt: DateTime.now(),
          userUid: testUserId,
        ),
      );

      final savedIds = databaseService.customerEntityDao.saveManyCustomers(customers);
      expect(savedIds.length, equals(customers.length));
      expect(savedIds.every((id) => id > 0), isTrue);
    });

    test('should verify createdAt property correctness', () async {
      final customer = CustomerEntity(
        autoId: 0,
        id: 20,
        name: 'Test Customer',
        createdAt: DateTime.now(),
        userUid: testUserId,
      );

      final savedId = databaseService.customerEntityDao.saveCustomer(customer);
      final savedCustomer = databaseService.customerEntityDao.getCustomerById(savedId);
      
      expect(savedCustomer?.createdAt, isNotNull);
      expect(savedCustomer?.createdAt.isBefore(DateTime.now()), isTrue);
    });

    test('should handle empty customer list in saveManyCustomers', () async {
      final savedIds = databaseService.customerEntityDao.saveManyCustomers([]);
      expect(savedIds, isEmpty);
    });
  });
} 