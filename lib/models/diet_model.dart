import 'package:flutter/material.dart';

class DietModel {
  String name;
  String iconPath;
  String level;
  String duration;
  String calorie;
  bool viewIsSelected;
  Color boxColor;

  DietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calorie,
    required this.viewIsSelected,
    required this.boxColor,
  });

  static List<DietModel> getDiets() {
    List<DietModel> diets = [];

    diets.add(
      DietModel(
        name: 'Sandwich',
        iconPath: 'assets/icons/Sandwich.svg',
        level: 'Easy',
        duration: '30mins',
        calorie: '180kCal',
        boxColor: Color(0xff92A3FD),
        viewIsSelected: true,
      ),
    );

    diets.add(
      DietModel(
        name: 'Honey Pancake',
        iconPath: 'assets/icons/Pancake.svg',
        level: 'Easy',
        duration: '20mins',
        calorie: '230kCal',
        boxColor: Color(0xffC58BF2),
        viewIsSelected: true,
      ),
    );

    return diets;
  }
}
