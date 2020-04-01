import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

class CheckBoxPicker extends StatefulWidget {
  final List<Option> options;

  CheckBoxPicker({Key key, this.options}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckBoxPickerState();
}

class CheckBoxPickerState extends State<CheckBoxPicker> {
  Set<Option> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: List.generate(widget.options.length, (i) {
        Option option = widget.options[i];
        bool selected = selectedOptions.contains(option);

        return ChoiceChip(
          label: Text(option.text),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (selected) => setState(() {
            if (selected) {
              selectedOptions.add(option);
            } else {
              selectedOptions.remove(option);
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
