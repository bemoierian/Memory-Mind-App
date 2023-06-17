part of 'image_picker_cubit.dart';

abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImageSelected extends ImagePickerState {
  Uint8List bytes;
  String selectedImageName;
  String selectedImageMimeType;
  ImageSelected(
      {required this.bytes,
      required this.selectedImageName,
      required this.selectedImageMimeType});
}

class ImageError extends ImagePickerState {}

class ImageLoading extends ImagePickerState {}
