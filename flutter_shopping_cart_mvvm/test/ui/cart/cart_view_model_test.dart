import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/cart_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/checkout_repository.dart';
import 'package:flutter_shopping_cart_mvvm/sessions/cart_session.dart';
import 'package:flutter_shopping_cart_mvvm/ui/cart/cart_view_model.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartSession extends Mock implements CartSession {}
class MockCheckoutRepository extends Mock implements ICheckoutRepository {}
class MockCartRepository extends Mock implements ICartRepository {}
class MockProductEntity extends Mock implements ProductEntity {}

void main() {
  group('CartViewModel', () {
    late CartViewModel cartViewModel;
    late MockCartSession mockCartSession;
    late MockCheckoutRepository mockCheckoutRepository;
    late MockCartRepository mockCartRepository;

    setUp(() {
      mockCartSession = MockCartSession();
      mockCheckoutRepository = MockCheckoutRepository();
      mockCartRepository = MockCartRepository();

      cartViewModel = CartViewModel(
        cartSession: mockCartSession,
        checkoutRepository: mockCheckoutRepository,
        cartRepository: mockCartRepository,
      );

      // Register fallback for ProductEntity
      registerFallbackValue(MockProductEntity());
    });

    tearDown(() {
      cartViewModel.dispose();
    });

    test('checkoutProductsCmd calls checkoutRepository.checkout and propagates result', () async {
      // Arrange
      when(() => mockCheckoutRepository.checkout()).thenAnswer((_) async => Success(unit));

      // Act
      await cartViewModel.checkoutProductsCmd.execute();

      // Assert
      verify(() => mockCheckoutRepository.checkout()).called(1);
      expect(cartViewModel.checkoutProductsCmd.state.value, isA<SuccessCommand<Unit, AppError>>());
      expect((cartViewModel.checkoutProductsCmd.state.value as SuccessCommand<Unit, AppError>).value, unit);
    });

    test('checkoutProductsCmd propagates failures from checkoutRepository.checkout', () async {
      // Arrange
      final failure = Failure<Unit, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockCheckoutRepository.checkout()).thenAnswer((_) async => failure);

      // Act
      await cartViewModel.checkoutProductsCmd.execute();

      // Assert
      verify(() => mockCheckoutRepository.checkout()).called(1);
      expect(cartViewModel.checkoutProductsCmd.state.value, isA<FailureCommand<Unit, AppError>>());
      expect((cartViewModel.checkoutProductsCmd.state.value as FailureCommand<Unit, AppError>).error.message, 'Error');
    });

    test('removeProductCmd calls cartRepository.remove and sets productToRemove', () async {
      // Arrange
      final product = MockProductEntity();
      when(() => product.id).thenReturn(1);
      when(() => mockCartRepository.remove(productEntity: any(named: 'productEntity')))
          .thenAnswer((_) async => Success(product));

      // Act
      await cartViewModel.removeProductCmd.execute(product);

      // Assert
      verify(() => mockCartRepository.remove(productEntity: product)).called(1);
      expect(cartViewModel.productToRemove, product);
      expect(cartViewModel.removeProductCmd.state.value, isA<SuccessCommand<ProductEntity, AppError>>());
      expect((cartViewModel.removeProductCmd.state.value as SuccessCommand<ProductEntity, AppError>).value, product);
    });

    test('removeProductCmd propagates failures from cartRepository.remove', () async {
      // Arrange
      final product = MockProductEntity();
      when(() => product.id).thenReturn(1);
      final failure = Failure<ProductEntity, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockCartRepository.remove(productEntity: any(named: 'productEntity')))
          .thenAnswer((_) async => failure);

      // Act
      await cartViewModel.removeProductCmd.execute(product);

      // Assert
      verify(() => mockCartRepository.remove(productEntity: product)).called(1);
      expect(cartViewModel.productToRemove, product);
      expect(cartViewModel.removeProductCmd.state.value, isA<FailureCommand<ProductEntity, AppError>>());
      expect((cartViewModel.removeProductCmd.state.value as FailureCommand<ProductEntity, AppError>).error.message, 'Error');
    });

  });
}