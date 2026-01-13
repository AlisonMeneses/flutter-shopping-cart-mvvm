import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

abstract class ICheckoutRepository {
  AsyncResult<Unit, AppError> checkout();
}
