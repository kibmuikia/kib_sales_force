import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/config/routes/navigation_helpers.dart'
    show navigateToSignIn;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/core/utils/common_enum.dart' show VisitStatus;
import 'package:kib_sales_force/core/utils/export.dart'
    show homeScreenScaffoldKey, logoutUtil;
import 'package:kib_sales_force/data/models/export.dart' show Visit;
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:kib_sales_force/firebase_services/firebase_auth_service.dart'
    show FirebaseAuthService;
import 'package:kib_sales_force/presentation/reusable_widgets/export.dart'
    show
        CreateVisitBottomSheet,
        DataCard,
        VisitDetailsBottomSheet,
        VisitsStatisticsCard,
        showExitConfirmationDialog;
import 'package:kib_sales_force/providers/home_screen_provider.dart'
    show HomeScreenProvider;
import 'package:kib_utils/kib_utils.dart';
import 'package:provider/provider.dart' show Consumer, Provider;

class HomeScreenProviderUtil extends StatelessWidgetK {
  HomeScreenProviderUtil({super.key, super.tag = "HomeScreenProviderUtil"});

  @override
  Widget buildWithTheme(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return LocalProviderUtils.withProvider(
      create: (context) => HomeScreenProvider(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidgetK {
  HomeScreen({super.key, super.tag = "HomeScreen"});

  @override
  StateK<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends StateK<HomeScreen> {
  final _appPrefs = getIt<AppPrefsAsyncManager>();
  final _authService = getIt<FirebaseAuthService>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late final HomeScreenProvider _homeScreenProvider;
  String _currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    _appPrefs.getCurrentUserUid().then(
          (value) => kprint.lg(
            'home_screen:initState: _appPrefs.getCurrentUserUid: $value',
          ),
        );
    postFrame(() async {
      _initHomeScreenProvider();
      _getCurrentUserEmail();
    });
  }

  void _initHomeScreenProvider() async {
    _homeScreenProvider = Provider.of<HomeScreenProvider>(
      context,
      listen: false,
    );
    await _homeScreenProvider.init();
  }

  void _getCurrentUserEmail() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email ?? '-';
      });
    }
    _authService.authStateChanges.listen(
      (user) {
        kprint.lg(
          'home_screen:_getCurrentUserEmail: email[ ${user == null ? '-' : '${user.email} - ${user.uid}'} ]',
        );
        if (user != null) {
          setState(() {
            _currentUserEmail = user.email ?? '-';
          });
        }
      },
      onError: (err) {
        kprint.err('home_screen:_getCurrentUserEmail: ${err.toString()}');
      },
      onDone: () {
        kprint.lg('home_screen:_getCurrentUserEmail: onDone');
      },
    );
  }

  void _onPopInvokedWithResult(bool didPop, bool? result) async {
    if (didPop) return;
    final shouldPop = await showExitConfirmationDialog(context);
    kprint.lg(
      '_onPopInvokedWithResult: shouldPop: $shouldPop - mounted: $mounted',
    );
    if (mounted && shouldPop == true) {
      Navigator.of(context).pop();
    }
  }

  void logout(BuildContext ctx) async {
    final result = await logoutUtil(ctx, _authService, _appPrefs);
    switch (result) {
      case Success(value: final bool isLoggedOut):
        kprint.lg('home_screen:logout: isLoggedOut: $isLoggedOut');
        if (isLoggedOut) {
          (() => navigateToSignIn(ctx))();
        } else {
          informUser('Error signing out');
        }
        break;
      case Failure(error: final Exception e):
        kprint.err('home_screen:logout:Error: $e');
        informUser('Error signing out: $e');
        // TODO: handle error case, ie, `FailedToUnsetUserDataException`
        break;
    }
  }

  @override
  Widget buildWithTheme(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Consumer<HomeScreenProvider>(
        builder: (context, provider, _) {
          final status = provider.status;
          final visits = provider.visits;
          return Scaffold(
            key: homeScreenScaffoldKey,
            appBar: _buildAppBar(),
            floatingActionButton: _buildFloatingActionButton(),
            body: SafeArea(
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: () async {
                  _homeScreenProvider.setupVisitsStream();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      if (status.isLoading && visits.isEmpty)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                      if (!status.isLoading && visits.isEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No entries yet.\nUse the + button to add one.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      if (status.isError && provider.error != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorToString!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      if (!status.isLoading && visits.isNotEmpty) ...[
                        _buildSearchAndFilter(context, provider),
                        const SizedBox(height: 16),
                        VisitsStatisticsCard(visits: visits),
                        const SizedBox(height: 16),
                        _buildListOfVisits(
                          visits,
                          onTap: (entry) =>
                              VisitDetailsBottomSheet.show(context, entry),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: InkWell(
        onTap: () {
          _homeScreenProvider.setupVisitsStream();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome'),
            if (_currentUserEmail.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _currentUserEmail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
      actions: [
        // Logout
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => logout(context),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: 'home_screen_floating_action_button',
      shape: CircleBorder(
        side: BorderSide(color: colorScheme.primary),
      ),
      backgroundColor: colorScheme.surface,
      onPressed: () async {
        final result = await CreateVisitBottomSheet.show(
          context,
          (visit) {
            kprint.lg('home_screen:_buildFloatingActionButton: visit: $visit');
            _homeScreenProvider.setupVisitsStream();
          },
          entryToEdit: null,
        );
        kprint.lg('home_screen:_buildFloatingActionButton: result: $result');
      },
      child: Icon(Icons.add, color: colorScheme.onSurface),
    );
  }

  Widget _buildListOfVisits(
    List<Visit> visits, {
    required Function(Visit) onTap,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: visits.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        final visit = visits[i];

        final visitDate = DateFormat('dd/MM/yyyy').format(visit.visitDate);
        final createdAt =
            DateFormat('dd/MM/yyyy HH:mm').format(visit.createdAt);

        return DataCard(
          title: 'Visit ${visit.id} for ${visit.customerId} on $visitDate',
          subtitle:
              'At ${visit.location},\nstatus: ${visit.status},\ncreated at: $createdAt',
          onTap: () => onTap(visit),
        );
      },
    );
  }

  Widget _buildSearchAndFilter(
      BuildContext context, HomeScreenProvider provider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: colorScheme.surfaceVariant,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          onChanged: provider.setSearchQuery,
        ),
        const SizedBox(height: 12),
        // Status filter
        Row(
          children: [
            const Text('Filter by status:'),
            const SizedBox(width: 12),
            DropdownButton<VisitStatus?>(
              value: provider.statusFilter,
              hint: const Text('All'),
              items: [
                const DropdownMenuItem<VisitStatus?>(
                  value: null,
                  child: Text('All'),
                ),
                ...VisitStatus.values
                    .map((status) => DropdownMenuItem<VisitStatus?>(
                          value: status,
                          child: Text(status.label),
                        )),
              ],
              onChanged: provider.setStatusFilter,
              borderRadius: BorderRadius.circular(12),
            ),
            const Spacer(),
            if (provider.searchQuery.isNotEmpty ||
                provider.statusFilter != null)
              TextButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                onPressed: provider.clearFilters,
              ),
          ],
        ),
      ],
    );
  }

  //
}
