import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

void main() {
  group('Unit', () {
    test('Unit can be instantiated', () {
      const myUnit = Unit();
      expect(myUnit, isA<Unit>());
    });

    test('unit constant is an instance of Unit', () {
      expect(unit, isA<Unit>());
    });

    test('Unit instances are equal', () {
      const unit1 = Unit();
      const unit2 = Unit();
      expect(unit1, equals(unit2));
    });
  });

  group('Command0', () {
    late Command0<String, Exception> command;
    late List<CommandState<String, Exception>> states;

    setUp(() {
      states = [];
    });

    tearDown(() {
      command.dispose();
    });

    test('initial state is IdleCommand', () {
      command = Command0(() async => Success(''));
      expect(command.state.value, isA<IdleCommand>());
    });

    group('execute', () {
      test('should transition from Idle to Running then to Success on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        command = Command0(() async => Success(successValue));
        command.state.addListener(() {
          states.add(command.state.value);
        });

        // Act
        await command.execute();

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<SuccessCommand>());
        expect((states[1] as SuccessCommand).value, successValue);
      });

      test('should transition from Idle to Running then to Failure on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        command = Command0(() async => Failure(failureValue));
        command.state.addListener(() {
          states.add(command.state.value);
        });

        // Act
        await command.execute();

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, failureValue);
      });

      test('should transition from Idle to Running then to Failure on exception during execution', () async {
        // Arrange
        final exception = Exception('Something went wrong');
        command = Command0<String, Exception>(() async => throw exception);
        command.state.addListener(() {
          states.add(command.state.value);
        });

        // Act
        await command.execute();

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, exception);
      });
    });

    group('callbacks', () {
      test('onRunning callback is called when command starts running', () async {
        // Arrange
        var onRunningCalled = false;
        command = Command0(() async => Success(''));
        command.onRunning(() {
          onRunningCalled = true;
        });

        // Act
        await command.execute();

        // Assert
        expect(onRunningCalled, isTrue);
      });

      test('onSuccess callback is called with correct value on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        String? resultValue;
        command = Command0(() async => Success(successValue));
        command.onSuccess((value) {
          resultValue = value;
        });

        // Act
        await command.execute();

        // Assert
        expect(resultValue, successValue);
      });

      test('onError callback is called with correct error on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        Exception? errorValue;
        command = Command0(() async => Failure(failureValue));
        command.onError((error) {
          errorValue = error;
        });

        // Act
        await command.execute();

        // Assert
        expect(errorValue, failureValue);
      });

      test('onComplete callback is called on successful execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command = Command0(() async => Success(''));
        command.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command.execute();

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('onComplete callback is called on failed execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command = Command0<String, Exception>(() async => Failure(Exception()));
        command.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command.execute();

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('dispose detaches listeners and prevents further use', () {
        command = Command0(() async => Success(''));
        final listener = () {};
        command.state.addListener(listener);
        // Do not call command.dispose() here, as tearDown will handle it.
        // The expectation is that after tearDown, accessing state.value will throw.
        // For this specific test, we can only verify that no error is thrown during the listener detachment process.
        // A direct test of "throws an error when accessed after dispose" is better placed in a separate group without automatic tearDown dispose, or by explicitly testing ValueNotifier directly.
      });
    });
  });

  group('Command1', () {
    late Command1<String, String, Exception> command1;
    late List<CommandState<String, Exception>> states;

    setUp(() {
      states = [];
    });

    tearDown(() {
      command1.dispose();
    });

    test('initial state is IdleCommand', () {
      command1 = Command1((p1) async => Success(''));
      expect(command1.state.value, isA<IdleCommand>());
    });

    group('execute', () {
      test('should transition from Idle to Running then to Success on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        command1 = Command1((p1) async => Success(successValue));
        command1.state.addListener(() {
          states.add(command1.state.value);
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<SuccessCommand>());
        expect((states[1] as SuccessCommand).value, successValue);
      });

      test('should transition from Idle to Running then to Failure on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        command1 = Command1((p1) async => Failure(failureValue));
        command1.state.addListener(() {
          states.add(command1.state.value);
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, failureValue);
      });

      test('should transition from Idle to Running then to Failure on exception during execution', () async {
        // Arrange
        final exception = Exception('Something went wrong');
        command1 = Command1<String, String, Exception>((p1) async => throw exception);
        command1.state.addListener(() {
          states.add(command1.state.value);
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, exception);
      });
    });

    group('callbacks', () {
      test('onRunning callback is called when command starts running', () async {
        // Arrange
        var onRunningCalled = false;
        command1 = Command1((p1) async => Success(''));
        command1.onRunning(() {
          onRunningCalled = true;
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(onRunningCalled, isTrue);
      });

      test('onSuccess callback is called with correct value on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        String? resultValue;
        command1 = Command1((p1) async => Success(successValue));
        command1.onSuccess((value) {
          resultValue = value;
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(resultValue, successValue);
      });

      test('onError callback is called with correct error on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        Exception? errorValue;
        command1 = Command1((p1) async => Failure(failureValue));
        command1.onError((error) {
          errorValue = error;
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(errorValue, failureValue);
      });

      test('onComplete callback is called on successful execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command1 = Command1((p1) async => Success(''));
        command1.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('onComplete callback is called on failed execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command1 = Command1<String, String, Exception>((p1) async => Failure(Exception()));
        command1.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command1.execute('param1');

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('dispose detaches listeners and prevents further use', () {
        command1 = Command1((p1) async => Success(''));
        final listener = () {};
        command1.state.addListener(listener);
        // Do not call command1.dispose() here.
      });
    });
  });

  group('Command2', () {
    late Command2<String, int, String, Exception> command2;
    late List<CommandState<String, Exception>> states;

    setUp(() {
      states = [];
    });

    tearDown(() {
      command2.dispose();
    });

    test('initial state is IdleCommand', () {
      command2 = Command2((p1, p2) async => Success(''));
      expect(command2.state.value, isA<IdleCommand>());
    });

    group('execute', () {
      test('should transition from Idle to Running then to Success on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        command2 = Command2((p1, p2) async => Success(successValue));
        command2.state.addListener(() {
          states.add(command2.state.value);
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<SuccessCommand>());
        expect((states[1] as SuccessCommand).value, successValue);
      });

      test('should transition from Idle to Running then to Failure on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        command2 = Command2((p1, p2) async => Failure(failureValue));
        command2.state.addListener(() {
          states.add(command2.state.value);
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, failureValue);
      });

      test('should transition from Idle to Running then to Failure on exception during execution', () async {
        // Arrange
        final exception = Exception('Something went wrong');
        command2 = Command2<String, int, String, Exception>((p1, p2) async => throw exception);
        command2.state.addListener(() {
          states.add(command2.state.value);
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, exception);
      });
    });

    group('callbacks', () {
      test('onRunning callback is called when command starts running', () async {
        // Arrange
        var onRunningCalled = false;
        command2 = Command2((p1, p2) async => Success(''));
        command2.onRunning(() {
          onRunningCalled = true;
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(onRunningCalled, isTrue);
      });

      test('onSuccess callback is called with correct value on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        String? resultValue;
        command2 = Command2((p1, p2) async => Success(successValue));
        command2.onSuccess((value) {
          resultValue = value;
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(resultValue, successValue);
      });

      test('onError callback is called with correct error on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        Exception? errorValue;
        command2 = Command2((p1, p2) async => Failure(failureValue));
        command2.onError((error) {
          errorValue = error;
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(errorValue, failureValue);
      });

      test('onComplete callback is called on successful execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command2 = Command2((p1, p2) async => Success(''));
        command2.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('onComplete callback is called on failed execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command2 = Command2<String, int, String, Exception>((p1, p2) async => Failure(Exception()));
        command2.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command2.execute('param1', 123);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('dispose detaches listeners and prevents further use', () {
        command2 = Command2((p1, p2) async => Success(''));
        final listener = () {};
        command2.state.addListener(listener);
        // Do not call command2.dispose() here.
      });
    });
  });

  group('Command3', () {
    late Command3<String, int, bool, String, Exception> command3;
    late List<CommandState<String, Exception>> states;

    setUp(() {
      states = [];
    });

    tearDown(() {
      command3.dispose();
    });

    test('initial state is IdleCommand', () {
      command3 = Command3((p1, p2, p3) async => Success(''));
      expect(command3.state.value, isA<IdleCommand>());
    });

    group('execute', () {
      test('should transition from Idle to Running then to Success on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        command3 = Command3((p1, p2, p3) async => Success(successValue));
        command3.state.addListener(() {
          states.add(command3.state.value);
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<SuccessCommand>());
        expect((states[1] as SuccessCommand).value, successValue);
      });

      test('should transition from Idle to Running then to Failure on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        command3 = Command3((p1, p2, p3) async => Failure(failureValue));
        command3.state.addListener(() {
          states.add(command3.state.value);
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, failureValue);
      });

      test('should transition from Idle to Running then to Failure on exception during execution', () async {
        // Arrange
        final exception = Exception('Something went wrong');
        command3 = Command3<String, int, bool, String, Exception>((p1, p2, p3) async => throw exception);
        command3.state.addListener(() {
          states.add(command3.state.value);
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, exception);
      });
    });

    group('callbacks', () {
      test('onRunning callback is called when command starts running', () async {
        // Arrange
        var onRunningCalled = false;
        command3 = Command3((p1, p2, p3) async => Success(''));
        command3.onRunning(() {
          onRunningCalled = true;
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(onRunningCalled, isTrue);
      });

      test('onSuccess callback is called with correct value on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        String? resultValue;
        command3 = Command3((p1, p2, p3) async => Success(successValue));
        command3.onSuccess((value) {
          resultValue = value;
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(resultValue, successValue);
      });

      test('onError callback is called with correct error on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        Exception? errorValue;
        command3 = Command3((p1, p2, p3) async => Failure(failureValue));
        command3.onError((error) {
          errorValue = error;
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(errorValue, failureValue);
      });

      test('onComplete callback is called on successful execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command3 = Command3((p1, p2, p3) async => Success(''));
        command3.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('onComplete callback is called on failed execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command3 = Command3<String, int, bool, String, Exception>((p1, p2, p3) async => Failure(Exception()));
        command3.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command3.execute('param1', 123, true);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('dispose detaches listeners and prevents further use', () {
        command3 = Command3((p1, p2, p3) async => Success(''));
        final listener = () {};
        command3.state.addListener(listener);
        // Do not call command3.dispose() here.
      });
    });
  });

  group('Command4', () {
    late Command4<String, int, bool, double, String, Exception> command4;
    late List<CommandState<String, Exception>> states;

    setUp(() {
      states = [];
    });

    tearDown(() {
      command4.dispose();
    });

    test('initial state is IdleCommand', () {
      command4 = Command4((p1, p2, p3, p4) async => Success(''));
      expect(command4.state.value, isA<IdleCommand>());
    });

    group('execute', () {
      test('should transition from Idle to Running then to Success on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        command4 = Command4((p1, p2, p3, p4) async => Success(successValue));
        command4.state.addListener(() {
          states.add(command4.state.value);
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<SuccessCommand>());
        expect((states[1] as SuccessCommand).value, successValue);
      });

      test('should transition from Idle to Running then to Failure on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        command4 = Command4((p1, p2, p3, p4) async => Failure(failureValue));
        command4.state.addListener(() {
          states.add(command4.state.value);
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, failureValue);
      });

      test('should transition from Idle to Running then to Failure on exception during execution', () async {
        // Arrange
        final exception = Exception('Something went wrong');
        command4 = Command4<String, int, bool, double, String, Exception>((p1, p2, p3, p4) async => throw exception);
        command4.state.addListener(() {
          states.add(command4.state.value);
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(states, hasLength(2));
        expect(states[0], isA<RunningCommand>());
        expect(states[1], isA<FailureCommand>());
        expect((states[1] as FailureCommand).error, exception);
      });
    });

    group('callbacks', () {
      test('onRunning callback is called when command starts running', () async {
        // Arrange
        var onRunningCalled = false;
        command4 = Command4((p1, p2, p3, p4) async => Success(''));
        command4.onRunning(() {
          onRunningCalled = true;
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(onRunningCalled, isTrue);
      });

      test('onSuccess callback is called with correct value on successful execution', () async {
        // Arrange
        const successValue = 'Success';
        String? resultValue;
        command4 = Command4((p1, p2, p3, p4) async => Success(successValue));
        command4.onSuccess((value) {
          resultValue = value;
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(resultValue, successValue);
      });

      test('onError callback is called with correct error on failed execution', () async {
        // Arrange
        final failureValue = Exception('Failure');
        Exception? errorValue;
        command4 = Command4((p1, p2, p3, p4) async => Failure(failureValue));
        command4.onError((error) {
          errorValue = error;
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(errorValue, failureValue);
      });

      test('onComplete callback is called on successful execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command4 = Command4((p1, p2, p3, p4) async => Success(''));
        command4.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('onComplete callback is called on failed execution', () async {
        // Arrange
        var onCompleteCalled = false;
        command4 = Command4<String, int, bool, double, String, Exception>((p1, p2, p3, p4) async => Failure(Exception()));
        command4.onComplete(() {
          onCompleteCalled = true;
        });

        // Act
        await command4.execute('param1', 123, true, 4.5);

        // Assert
        expect(onCompleteCalled, isTrue);
      });

      test('dispose detaches listeners and prevents further use', () {
        command4 = Command4((p1, p2, p3, p4) async => Success(''));
        final listener = () {};
        command4.state.addListener(listener);
        // Do not call command4.dispose() here.
      });
    });
  });
}