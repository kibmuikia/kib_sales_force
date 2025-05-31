import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX;
import 'package:kib_sales_force/config/routes/router_config.dart'
    show AppRoutes;
import 'package:kib_utils/kib_utils.dart' show Result, tryResult;

// Auth Navigation
Result<void, Exception> navigateToHome(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.home.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to home',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateToSignIn(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.signIn.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to sign in',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateToSignUp(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.signUp.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to sign up',
              errorType: err.runtimeType,
            ),
    );

// Visit Management Navigation
Result<void, Exception> navigateToCreateVisit(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.createVisit.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to create visit',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateToVisitDetails(
  BuildContext context,
  String visitId, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(
          AppRoutes.visitDetails.path.replaceAll(':id', visitId),
          extra: extra,
        );
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to visit details',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateToVisitList(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.visitList.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to visit list',
              errorType: err.runtimeType,
            ),
    );

// Customer Management Navigation
Result<void, Exception> navigateToCustomerList(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.customerList.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to customer list',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateToCustomerDetails(
  BuildContext context,
  String customerId, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(
          AppRoutes.customerDetails.path.replaceAll(':id', customerId),
          extra: extra,
        );
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to customer details',
              errorType: err.runtimeType,
            ),
    );

// Statistics Navigation
Result<void, Exception> navigateToStatistics(
  BuildContext context, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(AppRoutes.statistics.path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating to statistics',
              errorType: err.runtimeType,
            ),
    );

// Navigation Actions
Result<void, Exception> navigateBack(
  BuildContext context, {
  Object? result,
}) =>
    tryResult(
      () {
        context.pop(result);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating back',
              errorType: err.runtimeType,
            ),
    );

Result<void, Exception> navigateAndRemoveUntil(
  BuildContext context,
  String path, {
  Object? extra,
}) =>
    tryResult(
      () {
        context.go(path, extra: extra);
      },
      (err) => err is Exception
          ? err
          : ExceptionX(
              error: err,
              stackTrace: StackTrace.current,
              message:
                  'Error, ${err.runtimeType}, encountered while navigating and removing until',
              errorType: err.runtimeType,
            ),
    );
