import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

class RadioButtonPicker extends StatefulWidget {
  final List<Option> options;

  RadioButtonPicker({Key key, this.options}) : super(key: key);

  @override
  RadioButtonPickerState createState() => RadioButtonPickerState();
}

class RadioButtonPickerState extends State<RadioButtonPicker> {
  Option selectedOption;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: List.generate(widget.options.length, (i) {
        Option option = widget.options[i];
        bool selected = selectedOption == option;

        return ChoiceChip(
          label: Text(option.text),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (selected) => setState(() {
            if (selected) {
              selectedOption = option;
            }
          }),
          selected: selected,
          selectedColor: option.colour,
          backgroundColor: option.colour.withOpacity(0.2),
        );
      }),
    );
  }
}
