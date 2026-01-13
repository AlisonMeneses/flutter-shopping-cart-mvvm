import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

abstract class ICheckoutService {
  AsyncResult<Unit, AppError> checkout();
}

class CheckoutServiceImpl implements ICheckoutService {
  @override
  AsyncResult<Unit, AppError> checkout() async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a successful checkout
    return const Success(unit);

    // Simulate a failure checkout
    //return Failure(AppError(message: 'Could not checkout', type: AppErrorType.server));
  }
}
