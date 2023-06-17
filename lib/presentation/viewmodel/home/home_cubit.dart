import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_mind_app/data/repository/home_repository.dart';
import '../../../data/models/media_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit(this.homeRepository) : super(HomeInitial());
  void getUserMedia({required String token, int? page, int? items}) {
    try {
      emit(HomeLoading());
      homeRepository
          .getUserMedia(token: token, page: page, items: items)
          .then((media) {
        emit(HomeLoaded(media));
      });
    } catch (e) {
      emit(HomeError());
    }
  }

  void resetUserMedia() {
    emit(HomeInitial());
  }

  void uploadMedia(Uint8List mediaBytes, String name, String mimeType,
      String title, String content, String token) {
    if (mimeType == "") {
      return;
    }
    homeRepository
        .uploadMedia(mediaBytes, name, mimeType, title, content, token)
        .then((media) {
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(media));
      } else {
        emit(HomeLoaded(media));
      }
      debugPrint("Media: ${media.media![0].fileUrl}");
    });
  }
}
