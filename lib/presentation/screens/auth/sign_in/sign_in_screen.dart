import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter/material.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/config/routes/navigation_helpers.dart'
    show navigateToHome, navigateToSignUp;
import 'package:kib_sales_force/core/constants/app_constants.dart'
    show invalidAction;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:kib_sales_force/firebase_services/firebase_auth_service.dart'
    show FirebaseAuthService;
import 'package:kib_sales_force/presentation/reusable_widgets/export.dart'
    show showExitConfirmationDialog;
import 'package:kib_utils/kib_utils.dart';

class SignInScreen extends StatefulWidgetK {
  SignInScreen({super.key, super.tag = "SignInScreen"});

  @override
  StateK<StatefulWidgetK> createState() => _SignInScreenState();
}

class _SignInScreenState extends StateK<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = getIt<FirebaseAuthService>();
  final _appPrefs = getIt<AppPrefsAsyncManager>();
  bool _obscurePassword = true;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ensure form data is valid';
      });
      return;
    }

    context.hideKeyboard();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    switch (result) {
      case Success(value: final UserCredential userCredentials):
        kprint.lg('_signIn: ${userCredentials.user}');
        setState(() {
          _isLoading = false;
        });
        /* // TODO: to be removed, just for reference
          {
            "signIn": {
              "additionalUserInfo": {
                "isNewUser": false,
                "profile": {},
                "providerId": null,
                "username": null,
                "authorizationCode": null
              },
              "credential": null,
              "user": {
                "displayName": null,
                "email": "test_one@sample.com",
                "isEmailVerified": false,
                "isAnonymous": false,
                "metadata": {
                  "creationTime": "2025-05-11T05:58:54.758Z",
                  "lastSignInTime": "2025-05-11T06:16:18.177Z"
                },
                "phoneNumber": null,
                "photoURL": null,
                "providerData": [
                  {
                    "displayName": null,
                    "email": "test_one@sample.com",
                    "phoneNumber": null,
                    "photoURL": null,
                    "providerId": "password",
                    "uid": "test_one@sample.com"
                  }
                ],
                "refreshToken": null,
                "tenantId": null,
                "uid": "q8mrjnJxQZOTyuNEajXOgdKL4Tr1"
              }
            }
          } 
         */
        final User? user = userCredentials.user;
        if (user == null) {
          setState(() {
            _errorMessage = 'No user data available';
          });
          return;
        }

        final userUid = user.uid;
        await _appPrefs.setCurrentUserUid(userUid);

        (() => navigateToHome(context))();
        break;
      case Failure(error: final Exception e):
        setState(() {
          _isLoading = false;
          _errorMessage = e is ExceptionX ? e.message : e.toString();
        });
        break;
    }
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

  @override
  Widget buildWithTheme(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? () => context.showMessage(invalidAction)
                        : () => _signIn(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Log In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => navigateToSignUp(context),
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                  // TODO: forgot password flow
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
}
