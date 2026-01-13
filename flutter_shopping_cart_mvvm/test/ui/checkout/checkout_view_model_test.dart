import 'package:flutter_shopping_cart_mvvm/sessions/cart_session.dart';
import 'package:flutter_shopping_cart_mvvm/ui/checkout/checkout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartSession extends Mock implements CartSession {}

void main() {
  group('CheckoutViewModel', () {
    late CheckoutViewModel checkoutViewModel;
    late MockCartSession mockCartSession;

    setUp(() {
      mockCartSession = MockCartSession();
      checkoutViewModel = CheckoutViewModel(cartSession: mockCartSession);
    });

    test('constructor assigns cartSession correctly', () {
      expect(checkoutViewModel.cartSession, mockCartSession);
    });
  });
}
