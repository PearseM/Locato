import 'package:flutter/material.dart';
import 'package:integrated_project/resources/option.dart';

class FilterPicker extends StatefulWidget {
  final List<Option> options;

  FilterPicker({Key key, this.options}) : super(key: key);

  @override
  FilterPickerState createState() => FilterPickerState();
}

class FilterPickerState extends State<FilterPicker> {
  Set<Option> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: List.generate(widget.options.length, (i) {
        Option option = widget.options[i];
        bool selected = selectedOptions.contains(option);

        return FilterChip(
          label: Text(option.text),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (selected) {},
          selected: selected,
          selectedColor: option.colour,
          backgroundColor: option.colour.withOpacity(0.2),
        );
      }),
    );
  }
}
