import 'dart:io';
import 'package:daily_kitchen_base/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

getCroppedImage(File imageFile,{List ratio= const [24,17]}) async {
  File croppedFile = await ImageCropper.cropImage(
    maxWidth: 1000,
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX:ratio[0].toDouble(), ratioY: ratio[1].toDouble()),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: DKTheme.green1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
      return croppedFile;
}
