part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MediaModel media;
  HomeLoaded(this.media);
}

class HomeError extends HomeState {}
