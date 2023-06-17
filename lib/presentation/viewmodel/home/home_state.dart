part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MediaModel media;
  HomeLoaded(this.media);
  HomeLoaded copyWith(MediaModel newMedia) {
    media.media!.add(newMedia.media![0]);
    return HomeLoaded(media);
  }
}

class HomeError extends HomeState {}
