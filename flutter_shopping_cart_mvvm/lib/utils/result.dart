sealed class Result<S, E extends Object> {
  const Result();

  T fold<T>(
      T Function(S success) onSuccess,
      T Function(E error) onError,
      );

  bool get isSuccess;
  bool get isError;
}

final class Success<S, E extends Object> extends Result<S, E> {
  final S value;
  const Success(this.value);

  @override
  T fold<T>(
      T Function(S success) onSuccess,
      T Function(E error) onError,
      ) =>
      onSuccess(value);

  @override
  bool get isSuccess => true;

  @override
  bool get isError => false;

  @override
  String toString() => 'Success($value)';
}

final class Failure<S, E extends Object> extends Result<S, E> {
  final E error;
  const Failure(this.error);

  @override
  T fold<T>(
      T Function(S success) onSuccess,
      T Function(E error) onError,
      ) =>
      onError(error);

  @override
  bool get isSuccess => false;

  @override
  bool get isError => true;

  @override
  String toString() => 'Failure($error)';
}

typedef AsyncResult<S, E extends Object> = Future<Result<S, E>>;
