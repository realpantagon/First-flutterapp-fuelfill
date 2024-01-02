import 'package:flutter/material.dart';

class Catergorymodel{
  String name;
  String icon;
  Color boxcolor;

  Catergorymodel({
    required this.name,
    required this.icon,
    required this.boxcolor,
  });

  static List<Catergorymodel> getCatergories(){

    List<Catergorymodel> catergories = [];

    catergories.add(
      Catergorymodel(name: 'Km/L', icon: "assets/icons/speedometer-svgrepo-com.svg", boxcolor: Color.fromARGB(255, 193, 252, 153)),
    );
    catergories.add(
      Catergorymodel(name: 'Total Expense', icon: "assets/icons/money-svgrepo-com.svg", boxcolor: const Color.fromARGB(255, 248, 202, 202)),
    );
    catergories.add(
      Catergorymodel(name: 'Total Distance', icon: "assets/icons/road-alt-svgrepo-com.svg", boxcolor: Color.fromARGB(255, 127, 198, 245)),
    );
    catergories.add(
      Catergorymodel(name: 'Baht/Km', icon: "assets/icons/divide-svgrepo-com.svg", boxcolor: Color.fromARGB(255, 193, 152, 247)),
    );
    return catergories;
  }
}