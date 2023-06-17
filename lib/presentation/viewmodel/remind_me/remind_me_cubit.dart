import 'package:bloc/bloc.dart';

part 'remind_me_state.dart';

class RemindMeCubit extends Cubit<RemindMeState> {
  RemindMeCubit() : super(RemindMeInitial());
  bool value = false;
  void changeValue(bool newValue) {
    value = newValue;
    emit(RemindMeChanged());
  }
}
