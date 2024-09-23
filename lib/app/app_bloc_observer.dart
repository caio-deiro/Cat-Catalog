import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

final class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    debugPrint('${bloc.runtimeType} $change');
    super.onChange(bloc, change);
  }
}
