/// This error is thrown when the user data[ `user uuid` ],
/// in shared preferences[ `AppPrefsAsyncManager` ],
/// is not unset via `setCurrentUserUid`, ie, back to empty string.
///
/// This is a critical error, as it means the user is logged out,
/// but the user data is not unset, thus the app will think the user is still logged in.
class FailedToUnsetUserDataException implements Exception {
  final String message;
  FailedToUnsetUserDataException([this.message = 'Failed to unset user data'])
      : assert(message.isNotEmpty, 'Exception message must not be empty');
}
