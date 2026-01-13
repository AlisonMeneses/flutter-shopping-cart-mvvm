import '../../domain/repositories/checkout_repository.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';
import '../services/checkout_service.dart';

class CheckoutRepositoryImpl implements ICheckoutRepository {
  final ICheckoutService checkoutService;

  CheckoutRepositoryImpl({required this.checkoutService});

  @override
  AsyncResult<Unit, AppError> checkout() async {
    return await checkoutService.checkout();
  }
}
