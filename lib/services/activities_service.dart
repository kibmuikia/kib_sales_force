import 'package:app_database/app_database.dart' show DatabaseService;
import 'package:app_http/app_http.dart' show ServerService;
import 'package:app_http/utils/export.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/core/utils/export.dart';
import 'package:kib_sales_force/data/models/export.dart' show Activity;
import 'package:kib_utils/kib_utils.dart';

class ActivitiesService {
  final DatabaseService _databaseService;
  final ServerService _serverService;
  final AppPrefsAsyncManager _authPrefs;

  ActivitiesService({
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

  /// Save activity locally
  Future<Result<int, Exception>> saveActivityLocally(
    Activity activity,
    String userUid,
  ) async =>
      tryResultAsync<int, Exception>(
        () async {
          final result = _databaseService.activityEntityDao
              .saveActivity(activity.toEntity(userUid));
          if (result < 0) {
            throw Exception('Failed to save activity locally');
          }
          return result;
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving activity',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Save activity to server - save locally first
  Future<Result<bool, Exception>> saveActivity(Activity activity) async =>
      tryResultAsync<bool, Exception>(
        () async {
          final authCheckResult = await isAuthenticated;
          if (authCheckResult.valueOrNull == false ||
              authCheckResult.isFailure) {
            return false;
          }

          final result = await saveActivityLocally(
            activity,
            await currentUserUid,
          );
          kprint.lg('activities-service:saveActivity:result: $result');
          switch (result) {
            case Success(value: final _):
              final serverResult =
                  await _serverService.post<Map<String, dynamic>>(
                ActivitiesEndpoints.createActivity.build(),
                data: activity.toString(),
              );
              kprint.lg(
                  'activities-service:saveActivity:serverResult: $serverResult');
              return serverResult.success;
            case Failure(error: final _):
              return false;
          }
        },
        (err) => err is Exception
            ? err
            : ExceptionX(
                message: 'Error saving activity',
                errorType: err.runtimeType,
                stackTrace: StackTrace.current,
                error: err),
      );

  /// Stream activities from local database and server
  Stream<List<Activity>> streamActivities() async* {
    final localActivityEntities =
        _databaseService.activityEntityDao.getActivitiesForUser(
      await currentUserUid,
    );
    final localActivities =
        localActivityEntities.map((e) => Activity.fromEntity(e)).toList();
    final processedLocalActivities = localActivities.isNotEmpty
        ? localActivities
        : generateActivities(3); // for debug
    yield processedLocalActivities;

    final serverResult = await _serverService
        .get<Map<String, dynamic>>(ActivitiesEndpoints.activities.build());
    kprint.lg('');
    if (serverResult.success) {
      // TODO: process response, save locally and yield
    }
  }
}
