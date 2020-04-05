import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

class Tag extends Option {
  Tag(String name, Color colour) : super(text: name, colour: colour);

  // TODO: fill these out with some userful tags/better colours
  static List<Tag> all() => [
        Tag("Night", Colors.purple),
        Tag("Portrait", Colors.blue),
        Tag("Wildlife", Colors.green),
        Tag("Long exposure", Colors.orange),
      ];

  Map<String, String> asMap() {
    return {"name": this.text};
  }

  static Tag find(String text) => Tag.all().firstWhere(
        (test) => test.text == text,
  );
}
