import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());
  void pickImage() {
    // emit(ImageLoading());
    try {
      ImagePicker().pickImage(source: ImageSource.gallery).then((imagePicker) {
        if (imagePicker == null) {
          emit(ImageError());
          return;
        }
        String selectedImageName = imagePicker.name;
        String selectedImageMimeType = imagePicker.mimeType ?? "";
        // debugPrint("Name: $name, Type: $type");
        imagePicker.readAsBytes().then((bytes) {
          emit(ImageSelected(
            bytes: bytes,
            selectedImageName: selectedImageName,
            selectedImageMimeType: selectedImageMimeType,
          ));
          return;
        });
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      emit(ImageError());
    }
  }

  void deleteImage() {
    emit(ImagePickerInitial());
  }
}
