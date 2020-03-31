import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

enum OptionPickerStyle {
  Checkbox,
  RadioButton,
}

class OptionPicker extends StatefulWidget {
  final List<Option> options;
  final bool input;
  final OptionPickerStyle style;

  OptionPicker(this.options,
      {Key key, @required this.input, @required this.style})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionPickerState();
}

class OptionPickerState extends State<OptionPicker> {
  Set<Option> selected = Set<Option>();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: List.generate(widget.options.length, (i) {
        Option option = widget.options[i];
        bool isSelected = !widget.input || selected.contains(option);

        if (widget.input) {
          return ChoiceChip(
            label: Text(option.value),
            labelStyle:
                TextStyle(color: isSelected ? Colors.white : Colors.black),
            onSelected: (selectVal) => setState(() {
              if (widget.style == OptionPickerStyle.Checkbox) {
                if (selectVal) {
                  selected.add(option);
                } else {
                  selected.remove(option);
                }
              } else if (widget.style == OptionPickerStyle.RadioButton) {
                if (selectVal) {
                  selected.clear();
                  selected.add(option);
                }
              }
            }),
            selected: isSelected,
            selectedColor: option.colour,
            backgroundColor: option.colour.withOpacity(0.2),
          );
        } else {
          return Chip(
            label: Text(option.value),
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: option.colour,
          );
        }
      }),
    );
  }
}
