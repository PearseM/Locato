import 'package:flutter/material.dart';

class Category {
  String name;
  Color colour;

  Category(this.name, this.colour);

  static List<Category> all() => [
        Category("Landscape", Colors.green),
        Category("Mountains", Colors.grey),
        Category("Urban", Colors.blueGrey),
        Category("Water", Colors.blue),
        Category("Woodland", Colors.brown),
        Category("Place of Worship", Colors.orangeAccent),
      ];
}
