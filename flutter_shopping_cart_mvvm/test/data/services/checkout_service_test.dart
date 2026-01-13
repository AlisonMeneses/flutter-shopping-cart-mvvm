import 'package:flutter_shopping_cart_mvvm/data/services/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckoutServiceImpl', () {
    late CheckoutServiceImpl checkoutService;

    setUp(() {
      checkoutService = CheckoutServiceImpl();
    });

    test('checkout returns Success(unit) after delay', () async {
      // Act
      final result = await checkoutService.checkout();

      // Assert
      expect(result, isA<Success>());
      expect((result as Success<Unit, AppError>).value, unit);
    });
  });
}
