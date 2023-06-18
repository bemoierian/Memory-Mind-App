part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final MediaModel oldMedia;
  final bool firstTime;
  HomeLoading({required this.oldMedia, this.firstTime = false});
}

class HomeLoaded extends HomeState {
  final MediaModel media;
  HomeLoaded(this.media);
  HomeLoaded copyWith(MediaModel newMedia) {
    media.media!.insert(0, newMedia.media![0]);
    media.usedStorage = newMedia.usedStorage;
    return HomeLoaded(media);
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError({this.message = "Error in home cubit"});
}
