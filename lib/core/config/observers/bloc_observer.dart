import 'package:flutter_bloc/flutter_bloc.dart';
import '../loggers/logger_mixin.dart';

class AppBlocObserver extends BlocObserver with LoggerMixin {
  @override
  String get logPrefix => 'bloc-observer';

  @override
  void onEvent(Bloc bloc, Object? event) {
    debugLog('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    debugLog('onChange -- bloc: ${bloc.runtimeType}, change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    errorLog('onError -- bloc: ${bloc.runtimeType}, error: $error', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugLog('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
    super.onTransition(bloc, transition);
  }
}
