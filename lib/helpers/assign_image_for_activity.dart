import 'dart:math';

import 'package:flutter_application_3/config/images/app_images.dart';

String assingImageForActivity(String type) {
  final List<String> classroomImages = [
    AppImages.classroom,
    AppImages.classroom2,
    AppImages.classroom3,
    AppImages.classroom4,
    AppImages.classroom5,
    AppImages.classroom6
  ];
  final List<String> hallImages = [AppImages.hall];
  final List<String> chapelImages = [
    AppImages.chapel,
    AppImages.chapel2,
    AppImages.chapel3,
    AppImages.chapel4,
    AppImages.chapel5
  ];
  final List<String> seminarImages = [AppImages.interdisciplinary];

  switch (type) {
    case "classroom":
      return classroomImages.getRandomValue();
    case "hall":
      return hallImages.getRandomValue();
    case "chapel":
      return chapelImages.getRandomValue();
    case "seminar":
      return seminarImages.getRandomValue();
  }
  return '';
}

extension RandomValue on List<String> {
  // this is an extension on the list of strings and then it returns a random value in the list
  getRandomValue() {
    Random random = Random();
    int index = random.nextInt(length);
    return this[index];
  }
}
