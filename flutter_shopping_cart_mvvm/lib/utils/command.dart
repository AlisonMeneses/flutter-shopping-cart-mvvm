import 'package:flutter/foundation.dart';
import 'result.dart';

/// ===============================
/// Unit - para comandos sem retorno
/// ===============================
class Unit {
  const Unit();
}

const unit = Unit();

/// ===============================
/// Estados do Command
/// ===============================

sealed class CommandState<S, E extends Object> {
  const CommandState();
}

final class IdleCommand<S, E extends Object> extends CommandState<S, E> {
  const IdleCommand();
}

final class RunningCommand<S, E extends Object> extends CommandState<S, E> {
  const RunningCommand();
}

final class SuccessCommand<S, E extends Object> extends CommandState<S, E> {
  final S value;
  const SuccessCommand(this.value);
}

final class FailureCommand<S, E extends Object> extends CommandState<S, E> {
  final E error;
  const FailureCommand(this.error);
}

/// ===============================
/// Base Command
/// ===============================

abstract class Command<S, E extends Object> {
  final ValueNotifier<CommandState<S, E>> state =
  ValueNotifier(IdleCommand<S, E>());

  void _setState(CommandState<S, E> newState) {
    state.value = newState;
  }

  void onRunning(void Function() callback) {
    state.addListener(() {
      final s = state.value;
      if (s is RunningCommand<S, E>) callback();
    });
  }

  void onSuccess(void Function(S value) callback) {
    state.addListener(() {
      final s = state.value;
      if (s is SuccessCommand<S, E>) callback(s.value);
    });
  }

  void onError(void Function(E error) callback) {
    state.addListener(() {
      final s = state.value;
      if (s is FailureCommand<S, E>) callback(s.error);
    });
  }

  void onComplete(void Function() callback) {
    state.addListener(() {
      final s = state.value;
      if (s is SuccessCommand<S, E> || s is FailureCommand<S, E> ) {
        callback();
      }
    });
  }


  void dispose() {
    state.dispose();
  }
}

/// ===============================
/// Command0 - sem parâmetro
/// ===============================

class Command0<S, E extends Object> extends Command<S, E> {
  final Future<Result<S, E>> Function() _action;

  Command0(this._action);

  Future<void> execute() async {
    _setState(RunningCommand<S, E>());
    try {
      final result = await _action();
      result.fold(
            (success) => _setState(SuccessCommand<S, E>(success)),
            (error) => _setState(FailureCommand<S, E>(error)),
      );
    } catch (e) {
      _setState(FailureCommand<S, E>(e as E));
    }
  }
}

/// ===============================
/// Command1 - 1 parâmetro
/// ===============================

class Command1<P1, S, E extends Object> extends Command<S, E> {
  final Future<Result<S, E>> Function(P1 p1) _action;

  Command1(this._action);

  Future<void> execute(P1 p1) async {
    _setState(RunningCommand<S, E>());
    try {
      final result = await _action(p1);
      result.fold(
            (success) => _setState(SuccessCommand<S, E>(success)),
            (error) => _setState(FailureCommand<S, E>(error)),
      );
    } catch (e) {
      _setState(FailureCommand<S, E>(e as E));
    }
  }
}

/// ===============================
/// Command2 - 2 parâmetros
/// ===============================

class Command2<P1, P2, S, E extends Object> extends Command<S, E> {
  final Future<Result<S, E>> Function(P1 p1, P2 p2) _action;

  Command2(this._action);

  Future<void> execute(P1 p1, P2 p2) async {
    _setState(RunningCommand<S, E>());
    try {
      final result = await _action(p1, p2);
      result.fold(
            (success) => _setState(SuccessCommand<S, E>(success)),
            (error) => _setState(FailureCommand<S, E>(error)),
      );
    } catch (e) {
      _setState(FailureCommand<S, E>(e as E));
    }
  }
}

/// ===============================
/// Command3 - 3 parâmetros
/// ===============================

class Command3<P1, P2, P3, S, E extends Object> extends Command<S, E> {
  final Future<Result<S, E>> Function(P1 p1, P2 p2, P3 p3) _action;

  Command3(this._action);

  Future<void> execute(P1 p1, P2 p2, P3 p3) async {
    _setState(RunningCommand<S, E>());
    try {
      final result = await _action(p1, p2, p3);
      result.fold(
            (success) => _setState(SuccessCommand<S, E>(success)),
            (error) => _setState(FailureCommand<S, E>(error)),
      );
    } catch (e) {
      _setState(FailureCommand<S, E>(e as E));
    }
  }
}

/// ===============================
/// Command4 - 4 parâmetros
/// ===============================

class Command4<P1, P2, P3, P4, S, E extends Object> extends Command<S, E> {
  final Future<Result<S, E>> Function(P1 p1, P2 p2, P3 p3, P4 p4) _action;

  Command4(this._action);

  Future<void> execute(P1 p1, P2 p2, P3 p3, P4 p4) async {
    _setState(RunningCommand<S, E>());
    try {
      final result = await _action(p1, p2, p3, p4);
      result.fold(
            (success) => _setState(SuccessCommand<S, E>(success)),
            (error) => _setState(FailureCommand<S, E>(error)),
      );
    } catch (e) {
      _setState(FailureCommand<S, E>(e as E));
    }
  }
}
