import 'package:app_database/app_database.dart' show DatabaseService;
import 'package:app_http/app_http.dart' show ServerService;
import 'package:app_http/utils/export.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/core/utils/export.dart';
import 'package:kib_sales_force/data/models/export.dart' show Customer;
import 'package:kib_utils/kib_utils.dart';

class CustomersService {
  final DatabaseService _databaseService;
  final ServerService _serverService;
  final AppPrefsAsyncManager _authPrefs;

  CustomersService({
    required DatabaseService databaseService,
    required ServerService serverService,
    required AppPrefsAsyncManager authPrefs,
  })  : _databaseService = databaseService,
        _serverService = serverService,
        _authPrefs = authPrefs;

  Future<String> get currentUserUid async =>
      await _authPrefs.getCurrentUserUid() ?? '';

  Future<Result<bool, Exception>> get isAuthenticated async =>
      tryResultAsync<bool, Exception>(
        () async {
          final uid = await currentUserUid;
          return uid.isNotEmpty;
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error checking if user is authenticated',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err,
              ),
      );

  /// Save customer locally
  Future<Result<int, Exception>> saveCustomerLocally(
    Customer customer,
    String userUid,
  ) async =>
      tryResultAsync<int, Exception>(
        () async {
          final result = _databaseService.customerEntityDao
              .saveCustomer(customer.toEntity(userUid));
          if (result < 0) {
            throw Exception('Failed to save customer locally');
          }
          return result;
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving customer',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Save customer to server - save locally first
  Future<Result<bool, Exception>> saveCustomer(Customer customer) async =>
      tryResultAsync<bool, Exception>(
        () async {
          final authCheckResult = await isAuthenticated;
          if (authCheckResult.valueOrNull == false ||
              authCheckResult.isFailure) {
            return false;
          }

          final result = await saveCustomerLocally(
            customer,
            await currentUserUid,
          );
          kprint.lg('customers-service:saveCustomer:result: $result');
          switch (result) {
            case Success(value: final _):
              final serverResult =
                  await _serverService.post<Map<String, dynamic>>(
                CustomersEndpoints.createCustomer.build(),
                data: customer.toString(),
              );
              kprint.lg(
                  'customers-service:saveCustomer:serverResult: $serverResult');
              return serverResult.success;
            case Failure(error: final _):
              return false;
          }
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving customer',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Stream customers from local database and server
  Stream<List<Customer>> streamCustomers() async* {
    final localCustomerEntities =
        _databaseService.customerEntityDao.getCustomersForUser(
      await currentUserUid,
    );
    final localCustomers =
        localCustomerEntities.map((e) => Customer.fromEntity(e)).toList();
    final processedLocalCustomers = localCustomers.isNotEmpty
        ? localCustomers
        : generateCustomers(3); // for debug
    yield processedLocalCustomers;

    final serverResult = await _serverService
        .get<Map<String, dynamic>>(CustomersEndpoints.customers.build());
    kprint.lg('');
    if (serverResult.success) {
      // TODO: process response, save locally and yield
    }
  }
}
