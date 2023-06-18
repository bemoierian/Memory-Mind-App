import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_mind_app/data/repository/home_repository.dart';
import '../../../data/models/media_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit(this.homeRepository) : super(HomeInitial());
  int currPage = 1;
  final int items = 15;
  void getUserMedia({required String token}) {
    try {
      // debugPrint("fetching page $currPage");
      if (state is HomeLoading) return;
      MediaModel oldMedia = MediaModel();
      // if the home page is loaded before, store the old media
      if (state is HomeLoaded) {
        // emit(HomeLoading(oldMedia: oldMedia))
        oldMedia = (state as HomeLoaded).media;
      }
      emit(HomeLoading(oldMedia: oldMedia, firstTime: currPage == 1));
      homeRepository
          .getUserMedia(token: token, page: currPage, items: items)
          .then((media) {
        if (media.message == "Fetched media successfully.") {
          // final oldMediaList = oldMedia.media!;
          // if the home is loaded for the first time, just emit the new media
          if (currPage == 1) {
            emit(HomeLoaded(media));
            currPage = currPage + 1;
            return;
          }
          // if the home is loaded before, add the new media to the old media
          currPage = currPage + 1;
          oldMedia.media!.addAll(media.media!);
          media.media = oldMedia.media;
          emit(HomeLoaded(media));
        } else {
          emit(HomeError(message: media.message ?? "Error in home cubit"));
        }
      });
    } catch (e) {
      emit(HomeError());
    }
  }

  void resetUserMedia() {
    currPage = 1;
    emit(HomeInitial());
  }

  void uploadMedia(Uint8List mediaBytes, String name, String mimeType,
      String title, String content, String? remindeMeDate, String token) {
    if (mimeType == "") {
      return;
    }
    homeRepository
        .uploadMedia(
            mediaBytes, name, mimeType, title, content, remindeMeDate, token)
        .then((media) {
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(media));
      } else {
        emit(HomeLoaded(media));
      }
      debugPrint("Media: ${media.media![0].fileUrl}");
    });
  }

  void deleteMedia(String mediaID, String token) {
    homeRepository.deleteMedia(mediaID, token).then((res) {
      if (res.message! == "Deleted file.") {
        if (state is HomeLoaded) {
          final oldMedia = (state as HomeLoaded).media;
          oldMedia.media!.removeWhere((element) => element.sId == mediaID);
          oldMedia.usedStorage = res.usedStorage;
          emit(HomeLoaded(oldMedia));
        }
      } else {
        debugPrint("Error in deleting media");
      }
      // debugPrint("Media: ${media.media![0].fileUrl}");
    });
  }
}
