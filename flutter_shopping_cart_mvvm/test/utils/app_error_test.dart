import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';

void main() {
  group('AppError', () {
    test('AppError can be instantiated with message and type', () {
      const errorMessage = 'Something went wrong';
      const errorType = AppErrorType.server;

      final appError = AppError(message: errorMessage, type: errorType);

      expect(appError, isA<AppError>());
      expect(appError.message, errorMessage);
      expect(appError.type, errorType);
    });

    test('AppErrorType enum has all expected values', () {
      expect(AppErrorType.values, contains(AppErrorType.local));
      expect(AppErrorType.values, contains(AppErrorType.network));
      expect(AppErrorType.values, contains(AppErrorType.server));
      expect(AppErrorType.values, contains(AppErrorType.validation));
      expect(AppErrorType.values, contains(AppErrorType.auth));
      expect(AppErrorType.values, contains(AppErrorType.requisitionLimit));
      expect(AppErrorType.values, contains(AppErrorType.unknown));
      expect(AppErrorType.values.length, 7); // Ensure no new values are added unexpectedly
    });
  });
}