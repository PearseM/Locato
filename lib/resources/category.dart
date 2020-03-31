import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

class Category extends Option {
  Category(String name, Color colour) : super(name, colour);

  static List<Category> all() => [
        Category("Landscape", Colors.green),
        Category("Mountains", Colors.grey),
        Category("Urban", Colors.blueGrey),
        Category("Water", Colors.blue),
        Category("Woodland", Colors.brown),
        Category("Place of Worship", Colors.orangeAccent),
      ];
}
