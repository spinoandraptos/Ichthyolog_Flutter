import '../Models/species.dart';
import 'package:selectable_list/selectable_list.dart';
import 'package:flutter/material.dart';

class FamilyPicker extends StatefulWidget {
  final Function familyCallback;
  final String order;
  const FamilyPicker(
      {Key? key, required this.familyCallback, required this.order})
      : super(key: key);

  @override
  FamilyPickerState createState() => FamilyPickerState();
}

class FamilyPickerState extends State<FamilyPicker> {
  final familyAnabantiformes = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
    SpeciesClassification(
        classification: 'Osphronemidae', description: 'Gouramies'),
  ];

  final familyCarangiformes = [
    SpeciesClassification(
        classification: 'Carangidae', description: 'Trevallies'),
    SpeciesClassification(
        classification: 'Rachycentridae', description: 'Cobia'),
    SpeciesClassification(classification: 'Echeneidae', description: 'Remora'),
    SpeciesClassification(classification: 'Menidae ', description: 'Moonfish'),
  ];

  final familyPerciformes = [
    SpeciesClassification(classification: 'Cichlidae', description: 'Cichlids'),
    SpeciesClassification(
        classification: 'Terapontidae', description: 'Terapons'),
    SpeciesClassification(
        classification: 'Haemulidae', description: 'Grunters'),
  ];

  String? selectedFamily;

  @override
  Widget build(BuildContext context) {
    switch (widget.order) {
      case 'Carangiformes':
        return SelectableList<SpeciesClassification, String?>(
          items: familyCarangiformes,
          itemBuilder: (context, family, selected, onTap) => ListTile(
              title: Text(family.classification),
              subtitle: Text(family.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (family) => family.classification,
          selectedValue: selectedFamily,
          onItemSelected: (family) {
            setState(() {
              selectedFamily = family.classification;
            });
            widget.familyCallback(selectedFamily);
          },
          onItemDeselected: (family) {
            setState(() {
              selectedFamily = '';
            });
            widget.familyCallback(selectedFamily);
          },
        );

      case 'Perciformes':
        return SelectableList<SpeciesClassification, String?>(
          items: familyPerciformes,
          itemBuilder: (context, family, selected, onTap) => ListTile(
              title: Text(family.classification),
              subtitle: Text(family.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (family) => family.classification,
          selectedValue: selectedFamily,
          onItemSelected: (family) {
            setState(() {
              selectedFamily = family.classification;
            });
            widget.familyCallback(selectedFamily);
          },
          onItemDeselected: (family) {
            setState(() {
              selectedFamily = '';
            });
            widget.familyCallback(selectedFamily);
          },
        );

      case 'Anabantiformes':
        return SelectableList<SpeciesClassification, String?>(
          items: familyAnabantiformes,
          itemBuilder: (context, family, selected, onTap) => ListTile(
              title: Text(family.classification),
              subtitle: Text(family.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (family) => family.classification,
          selectedValue: selectedFamily,
          onItemSelected: (family) {
            setState(() {
              selectedFamily = family.classification;
            });
            widget.familyCallback(selectedFamily);
          },
          onItemDeselected: (family) {
            setState(() {
              selectedFamily = '';
            });
            widget.familyCallback(selectedFamily);
          },
        );

      //TODO: Update default return widget
      default:
        return SelectableList<SpeciesClassification, String?>(
          items: familyAnabantiformes,
          itemBuilder: (context, family, selected, onTap) => ListTile(
              title: Text(family.classification),
              subtitle: Text(family.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (family) => family.classification,
          selectedValue: selectedFamily,
          onItemSelected: (family) {
            setState(() {
              selectedFamily = family.classification;
            });
            widget.familyCallback(selectedFamily);
          },
          onItemDeselected: (family) {
            setState(() {
              selectedFamily = '';
            });
            widget.familyCallback(selectedFamily);
          },
        );
    }
  }
}
