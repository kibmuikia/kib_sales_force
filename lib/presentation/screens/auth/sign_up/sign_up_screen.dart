import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:flutter/material.dart';
import 'package:kib_debug_print/service.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/config/routes/navigation_helpers.dart'
    show navigateToHome, navigateToSignIn;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:kib_sales_force/firebase_services/firebase_auth_service.dart'
    show FirebaseAuthService;
import 'package:kib_utils/kib_utils.dart';

class SignUpScreen extends StatefulWidgetK {
  SignUpScreen({super.key, super.tag = "SignUpScreen"});

  @override
  StateK<StatefulWidgetK> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends StateK<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = getIt<FirebaseAuthService>();
  final _appPrefs = getIt<AppPrefsAsyncManager>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp(BuildContext context) async {
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

    final signUpResult = await _authService.signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    switch (signUpResult) {
      case Success(value: final UserCredential userCredential):
        kprint.lg('_signUp: $userCredential');
        final createdUser = userCredential.user;
        if (createdUser == null) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Received a success sign-up-result, but user is null';
          });
          return;
        }

        informUser('Signing in user ${createdUser.email}');
        final signInResult = await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        switch (signInResult) {
          case Success(value: final UserCredential userCredential):
            kprint.lg('_signUp: signInResult: $userCredential');
            final signedInUser = userCredential.user;
            if (signedInUser == null) {
              _handledFailedSignIn(
                'Received a success sign-in-result, but user is null',
                'Failed to sign in user ${createdUser.email}',
              );
              return;
            }

            await _appPrefs.setCurrentUserUid(signedInUser.uid);
            setState(() {
              _isLoading = false;
              _errorMessage = null;
            });
            (() => navigateToHome(context))();
            break;
          case Failure(error: final Exception e):
            _handledFailedSignIn(
              e is ExceptionX ? e.message : e.toString(),
              'Failed to sign in user ${createdUser.email}',
            );
            break;
        }
        break;
      case Failure(error: final Exception e):
        setState(() {
          _isLoading = false;
          _errorMessage = e is ExceptionX ? e.message : e.toString();
        });
        break;
    }
  }

  void _handledFailedSignIn(
    String errorMessage,
    String informUserMessage,
  ) async {
    setState(() {
      _isLoading = false;
      _errorMessage = errorMessage;
    });
    informUser(informUserMessage);
    await Future.delayed(const Duration(milliseconds: 500));
    (() => navigateToSignIn(context))();
  }

  @override
  Widget buildWithTheme(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
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
                  onPressed: _isLoading ? null : () => _signUp(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    navigateToSignIn(context);
                  },
                  child: const Text('Already have an account? Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
