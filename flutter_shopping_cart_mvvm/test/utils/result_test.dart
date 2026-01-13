import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should hold a success value', () {
        const successValue = 'Data fetched successfully';
        final result = Success<String, AppError>(successValue);

        expect(result.isSuccess, isTrue);
        expect(result.isError, isFalse);
        expect(result.value, successValue);
      });

      test('fold should call onSuccess with the success value', () {
        const successValue = 123;
        final result = Success<int, AppError>(successValue);

        final foldedValue = result.fold(
          (success) => 'Success: $success',
          (error) => 'Error: ${error.message}',
        );

        expect(foldedValue, 'Success: $successValue');
      });

      test('toString should return a string representation of Success', () {
        const successValue = true;
        final result = Success<bool, AppError>(successValue);
        expect(result.toString(), 'Success($successValue)');
      });
    });

    group('Failure', () {
      final error = AppError(message: 'Network error', type: AppErrorType.network);

      test('should hold an error value', () {
        final result = Failure<String, AppError>(error);

        expect(result.isSuccess, isFalse);
        expect(result.isError, isTrue);
        expect(result.error, error);
      });

      test('fold should call onError with the error value', () {
        final result = Failure<int, AppError>(error);

        final foldedValue = result.fold(
          (success) => 'Success: $success',
          (error) => 'Error: ${error.message}',
        );

        expect(foldedValue, 'Error: ${error.message}');
      });

      test('toString should return a string representation of Failure', () {
        final result = Failure<bool, AppError>(error);
        expect(result.toString(), 'Failure($error)');
      });
    });

    group('AsyncResult', () {
      test('AsyncResult should be a Future of Result', () async {
        AsyncResult<String, AppError> asyncSuccess() async => Success('Async data');
        AsyncResult<String, AppError> asyncFailure() async => Failure(AppError(message: 'Async error', type: AppErrorType.unknown));

        final successResult = await asyncSuccess();
        expect(successResult, isA<Success<String, AppError>>());
        expect(successResult.isSuccess, isTrue);

        final failureResult = await asyncFailure();
        expect(failureResult, isA<Failure<String, AppError>>());
        expect(failureResult.isError, isTrue);
      });
    });
  });
}
