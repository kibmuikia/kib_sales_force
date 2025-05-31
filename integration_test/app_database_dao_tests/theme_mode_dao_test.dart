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

  group('ThemeModeDao Integration Tests', () {
    test('should save and retrieve the correct theme mode', () async {
      // Test dark mode
      final darkMode = 'dark';
      databaseService.themeModeDao.saveThemeMode(darkMode);
      var latestTheme = databaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, equals(darkMode));

      // Test light mode
      final lightMode = 'light';
      databaseService.themeModeDao.saveThemeMode(lightMode);
      latestTheme = databaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, equals(lightMode));

      // Test system mode
      final systemMode = 'system';
      databaseService.themeModeDao.saveThemeMode(systemMode);
      latestTheme = databaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, equals(systemMode));
    });

    test('should handle multiple theme mode saves', () async {
      // Save multiple theme modes
      final themeModes = ['dark', 'light', 'system', 'dark'];

      for (final mode in themeModes) {
        databaseService.themeModeDao.saveThemeMode(mode);
      }

      // Verify the latest saved theme mode
      final latestTheme = databaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, equals(themeModes.last));
    });

    test('should work with rapid successive theme mode changes', () async {
      // Simulate rapid theme mode changes
      for (int i = 0; i < 10; i++) {
        final mode = i % 2 == 0 ? 'dark' : 'light';
        databaseService.themeModeDao.saveThemeMode(mode);

        // Short delay to simulate real-world scenario
        await Future.delayed(const Duration(milliseconds: 10));
      }

      final latestTheme = databaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, isNotNull);
    });

    test('should verify createdAt property correctness', () async {
      // Save a mode
      final mode = 'dark';
      final savedId = databaseService.themeModeDao.saveThemeMode(mode);

      // Retrieve and check the `createdAt` field
      final savedTheme = databaseService.themeModeDao.box.get(savedId);
      expect(savedTheme?.createdAt, isNotNull);
      expect(savedTheme?.createdAt.isBefore(DateTime.now()), isTrue);
    });

    test('should persist theme mode across database restarts', () async {
      // Save a theme mode
      final persistentMode = 'dark';
      databaseService.themeModeDao.saveThemeMode(persistentMode);

      // Close and restart the database
      databaseService.close();
      final restartedDatabaseService = await DatabaseService.create();

      // Verify the saved mode is still accessible
      final latestTheme =
          restartedDatabaseService.themeModeDao.getCurrentThemeMode();
      expect(latestTheme?.mode, equals(persistentMode));

      restartedDatabaseService.close();
    });
  });
}
