import 'package:ichthyolog/Models/species.dart';
import 'package:selectable_list/selectable_list.dart';
import 'package:flutter/material.dart';

class OrderPicker extends StatefulWidget {
  @override
  _OrderPickerState createState() => _OrderPickerState();
}

class _OrderPickerState extends State<OrderPicker> {
  final orders = [
    SpeciesClassification(
        classification: 'Gobiiformes',
        description: 'Gobies and related species'),
    SpeciesClassification(
        classification: 'Carangiformes',
        description: 'Trevallies and related species'),
    SpeciesClassification(
        classification: 'Scombriformes',
        description: 'Mackerels, queenfish and related species'),
    SpeciesClassification(
        classification: 'Kurtiformes',
        description: 'Cardinalfish and related species'),
    SpeciesClassification(
        classification: 'Batrachoidiformes',
        description: 'Toadfish and related species'),
    SpeciesClassification(
        classification: 'Anguilliformes',
        description: 'Sardines and related species'),
    SpeciesClassification(
        classification: 'Perciformes',
        description: 'Cichlids, terapons and related species'),
    SpeciesClassification(
        classification: 'anabantiformes',
        description: 'Snakeheads and gouramies')
  ];

  String? selectedOrder;

  @override
  Widget build(BuildContext context) {
    return SelectableList<SpeciesClassification, String?>(
      items: orders,
      itemBuilder: (context, order, selected, onTap) => ListTile(
          title: Text(order.classification),
          subtitle: Text(order.description),
          selected: selected,
          onTap: onTap),
      valueSelector: (order) => order.classification,
      selectedValue: selectedOrder,
      onItemSelected: (order) =>
          setState(() => selectedOrder = order.classification),
      onItemDeselected: (person) => setState(() => selectedOrder = null),
    );
  }
}
