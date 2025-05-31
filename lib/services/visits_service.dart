import 'package:app_database/app_database.dart' show DatabaseService;
import 'package:app_http/app_http.dart' show ServerService;
import 'package:app_http/utils/export.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX, UnauthorizedException;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/core/utils/export.dart';
import 'package:kib_sales_force/data/models/export.dart' show Visit;
import 'package:kib_utils/kib_utils.dart';

class VisitsService {
  final DatabaseService _databaseService;
  final ServerService _serverService;
  final AppPrefsAsyncManager _authPrefs;

  VisitsService({
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

  /// Save visit locally
  Future<Result<int, Exception>> saveVisitLocally(
    Visit visit,
    String userUid,
  ) async =>
      tryResultAsync<int, Exception>(
        () async {
          final result = _databaseService.visitEntityDao
              .saveVisit(visit.toVisitEntity(userUid: userUid));
          if (result < 0) {
            throw Exception('Failed to save visit locally');
          }
          return result;
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving visit',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Save visit to server - save locally first
  Future<Result<bool, Exception>> saveVisit(Visit visit) async =>
      tryResultAsync<bool, Exception>(
        () async {
          final authCheckResult = await isAuthenticated;
          if (authCheckResult.valueOrNull == false ||
              authCheckResult.isFailure) {
            throw UnauthorizedException('User is not authenticated');
          }

          final result = await saveVisitLocally(
            visit,
            await currentUserUid,
          );
          kprint.lg('visits-service:saveVisit:result: $result');
          switch (result) {
            case Success(value: final _):
              final serverResult =
                  await _serverService.post<Map<String, dynamic>>(
                VisitsEndpoints.createVisit.build(),
                data: visit.toString(),
              );
              kprint.lg('visits-service:saveVisit:serverResult: $serverResult');
              if (serverResult.success) {
                return true;
              }
              throw ExceptionX(
                message: 'Failed to save visit to server',
                errorType: serverResult.apiError!.runtimeType,
                stackTrace: StackTrace.current,
                error: serverResult.apiError!.error,
              );
            case Failure(error: final e):
              throw ExceptionX(
                message: 'Failed to save visit locally',
                errorType: e.runtimeType,
                stackTrace: StackTrace.current,
                error: e,
              );
          }
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving visit',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Stream visits from local database and server
  Stream<List<Visit>> streamVisits() async* {
    final localVisitEntities = _databaseService.visitEntityDao.getVisitsForUser(
      await currentUserUid,
    );
    final localVisits =
        localVisitEntities.map((e) => Visit.fromVisitEntity(e)).toList();
    final processedLocalVisits = localVisits.isNotEmpty
        ? localVisits
        : generateVisits(3, customers: generateCustomers(3)); // for debug
    yield processedLocalVisits;

    final serverResult = await _serverService
        .get<Map<String, dynamic>>(VisitsEndpoints.visits.build());

    kprint.lg('visits-service:streamVisits:serverResult: $serverResult');

    if (serverResult.success) {
      // TODO: process response, save locally and yield
    }
  }
}
