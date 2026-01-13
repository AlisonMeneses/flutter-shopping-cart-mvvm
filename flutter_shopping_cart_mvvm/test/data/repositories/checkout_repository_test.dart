import 'package:flutter_shopping_cart_mvvm/data/repositories/checkout_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutService extends Mock implements ICheckoutService {}

void main() {
  group('CheckoutRepositoryImpl', () {
    late CheckoutRepositoryImpl checkoutRepository;
    late MockCheckoutService mockCheckoutService;

    setUp(() {
      mockCheckoutService = MockCheckoutService();
      checkoutRepository = CheckoutRepositoryImpl(checkoutService: mockCheckoutService);
    });

    test('checkout calls checkout service and returns its result', () async {
      // Arrange
      when(() => mockCheckoutService.checkout()).thenAnswer((_) async => Success(unit));

      // Act
      final result = await checkoutRepository.checkout();

      // Assert
      expect(result, isA<Success>());
      verify(() => mockCheckoutService.checkout()).called(1);
    });

    test('checkout propagates failures from the service', () async {
      // Arrange
      final failure = Failure<Unit, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockCheckoutService.checkout()).thenAnswer((_) async => failure);

      // Act
      final result = await checkoutRepository.checkout();

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure<Unit, AppError>).error.message, 'Error');
    });
  });
}
