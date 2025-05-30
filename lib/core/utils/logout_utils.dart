import 'package:flutter/material.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_sales_force/core/errors/exceptions.dart'
    show FailedToUnsetUserDataException;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/firebase_services/firebase_auth_service.dart'
    show FirebaseAuthService;
import 'package:kib_utils/kib_utils.dart';

/// Ensure to handle error case, ie, `FailedToUnsetUserDataException`
Future<Result<bool, Exception>> logoutUtil(
  BuildContext ctx,
  FirebaseAuthService authService,
  AppPrefsAsyncManager appPrefs,
) async {
  final signOutResult = await authService.signOut();
  switch (signOutResult) {
    case Success():
      final isUnset = await appPrefs.setCurrentUserUid('');
      if (isUnset) {
        return success(true);
      } else {
        kprint.err('logout:signOut:Failed to unset user data');
        return failure(FailedToUnsetUserDataException());
      }
    case Failure():
      kprint.err('logout:signOut:Error: ${signOutResult.error}');
      return failure(signOutResult.error);
  }
}
