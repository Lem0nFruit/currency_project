import 'package:flutter/material.dart';

Widget customDropDown(List<String> items, String value, void Function(String?) onChange) {
  // Перевірка на наявність поточного значення в списку
  if (!items.contains(value)) {
    value = items.first;
  }

  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      value: value,
      onChanged: (val) {
        onChange(val);
      },
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
      dropdownColor: Colors.black,
      style: TextStyle(color: Colors.blue,
          fontWeight: FontWeight.bold),
      iconEnabledColor: Colors.blue,
    ),
  );
}