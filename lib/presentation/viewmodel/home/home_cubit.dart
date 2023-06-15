import 'package:bloc/bloc.dart';
import 'package:memory_mind_app/data/repository/home_repository.dart';

import '../../../data/models/media_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit(this.homeRepository) : super(HomeInitial());
  void getUserMedia(String token) {
    try {
      emit(HomeLoading());
      homeRepository.getUserMedia(token).then((media) {
        emit(HomeLoaded(media));
      });
    } catch (e) {
      emit(HomeError());
    }
  }
}
