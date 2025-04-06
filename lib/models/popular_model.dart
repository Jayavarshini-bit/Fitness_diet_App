import 'package:flutter/material.dart';

class PopularDietModel {
  String name;
  String iconPath;
  String level;
  String duration;
  String calorie;
  Color boxColor;
  bool boxIsSelected;

  PopularDietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calorie,
    required this.boxColor,
    required this.boxIsSelected,
  });

  static List<PopularDietModel> getPopularDiets() {
    List<PopularDietModel> popularDiets = [];

    popularDiets.add(
      PopularDietModel(
        name: 'Burrito',
        iconPath: 'assets/icons/burrito.svg',
        level: 'Medium',
        duration: '30min',
        calorie: '230kCal',
        boxColor: Color(0xff92A3FD),
        boxIsSelected: true,
      ),
    );

    popularDiets.add(
      PopularDietModel(
        name: 'RiceBall',
        iconPath: 'assets/icons/RiceBall.svg',
        level: 'Medium',
        duration: '10min',
        calorie: '200kCal',
        boxColor: Color(0xffC58BF2),
        boxIsSelected: true,
      ),
    );

    return popularDiets;
  }
}
