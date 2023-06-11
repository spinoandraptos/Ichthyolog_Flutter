import 'package:ichthyolog/Models/species.dart';
import 'package:selectable_list/selectable_list.dart';
import 'package:flutter/material.dart';

class GenusPicker extends StatefulWidget {
  final Function genusCallback;
  final String family;
  const GenusPicker(
      {Key? key, required this.genusCallback, required this.family})
      : super(key: key);

  @override
  GenusPickerState createState() => GenusPickerState(this.family);
}

class GenusPickerState extends State<GenusPicker> {
  String family = '';

  GenusPickerState(String family_) {
    family = family_;
  }

  final genusChannidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
    SpeciesClassification(
        classification: 'Osphronemidae', description: 'Gouramies'),
  ];

  final genusOsphronemidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];

  final genusCarangidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];

  final genusRachycentridae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];

  final genusEcheneidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];

  final genusMenidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];
  final genusCichlidae = [
    SpeciesClassification(
        classification: 'Cichla', description: 'Peacock Bass'),
    SpeciesClassification(
        classification: 'Oreochromis', description: 'Tilapias'),
    SpeciesClassification(classification: 'Mayaheros', description: 'Mayan'),
    SpeciesClassification(classification: 'Amphilophus ', description: 'Midas'),
    SpeciesClassification(classification: 'Vieja ', description: 'Redhead'),
  ];
  final genusTerapontidae = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];
  final genusHaemulidaee = [
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
  ];

  String? selectedGenus;

  @override
  Widget build(BuildContext context) {
    switch (family) {
      case 'Cichlidae':
        return SelectableList<SpeciesClassification, String?>(
          items: genusCichlidae,
          itemBuilder: (context, genus, selected, onTap) => ListTile(
              title: Text(genus.classification),
              subtitle: Text(genus.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (genus) => genus.classification,
          selectedValue: selectedGenus,
          onItemSelected: (genus) {
            setState(() {
              selectedGenus = genus.classification;
            });
            widget.genusCallback(selectedGenus);
          },
          onItemDeselected: (genus) {
            setState(() {
              selectedGenus = '';
            });
            widget.genusCallback(selectedGenus);
          },
        );

      //TODO: Update default return widget
      default:
        return SelectableList<SpeciesClassification, String?>(
          items: genusChannidae,
          itemBuilder: (context, genus, selected, onTap) => ListTile(
              title: Text(genus.classification),
              subtitle: Text(genus.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (genus) => genus.classification,
          selectedValue: selectedGenus,
          onItemSelected: (genus) {
            setState(() {
              selectedGenus = genus.classification;
            });
            widget.genusCallback(selectedGenus);
          },
          onItemDeselected: (genus) {
            setState(() {
              selectedGenus = '';
            });
            widget.genusCallback(selectedGenus);
          },
        );
    }
  }
}
