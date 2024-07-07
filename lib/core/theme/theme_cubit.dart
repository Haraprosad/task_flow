import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/core/theme/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.lightBlue);

  void setTheme(AppTheme theme) => emit(theme);
}