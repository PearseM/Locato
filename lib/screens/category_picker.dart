import 'package:flutter/material.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/screens/option_picker.dart';

class CategoryPicker extends OptionPicker {
  CategoryPicker({Key key})
      : super(Category.all(),
            key: key, input: true, style: OptionPickerStyle.RadioButton);
}
