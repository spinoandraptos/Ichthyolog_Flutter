import 'package:ichthyolog/Models/species.dart';
import 'package:selectable_list/selectable_list.dart';
import 'package:flutter/material.dart';

class OrderPicker extends StatefulWidget {
  final Function orderCallback;
  final String class_;
  const OrderPicker(
      {Key? key, required this.orderCallback, required this.class_})
      : super(key: key);

  @override
  OrderPickerState createState() => OrderPickerState(this.class_);
}

class OrderPickerState extends State<OrderPicker> {
  String class_ = '';
  OrderPickerState(String classes) {
    class_ = classes;
  }

  final ordersActinopterygii = [
    SpeciesClassification(
        classification: 'Perciformes',
        description: 'Cichlids, terapons and related species'),
    SpeciesClassification(
        classification: 'Anabantiformes',
        description: 'Snakeheads and gouramies'),
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
  ];

  final ordersChondrichthyes = [
    SpeciesClassification(
        classification: 'Dummy 1', description: 'Dummerinos 1'),
  ];

  final ordersSarcopterygii = [
    SpeciesClassification(
        classification: 'Dummy 2', description: 'Dummerinos 2'),
  ];

  String? selectedOrder;

  @override
  Widget build(BuildContext context) {
    switch (class_) {
      case 'Chondrichthyes':
        return SelectableList<SpeciesClassification, String?>(
          items: ordersChondrichthyes,
          itemBuilder: (context, order, selected, onTap) => ListTile(
              title: Text(order.classification),
              subtitle: Text(order.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (order) => order.classification,
          selectedValue: selectedOrder,
          onItemSelected: (order) => setState(() {
            selectedOrder = order.classification;
            widget.orderCallback(selectedOrder);
          }),
          onItemDeselected: (order) => setState(() {
            selectedOrder = null;
            widget.orderCallback(selectedOrder);
          }),
        );
      //TODO
      case 'Actinopterygii':
        return SelectableList<SpeciesClassification, String?>(
          items: ordersActinopterygii,
          itemBuilder: (context, order, selected, onTap) => ListTile(
              title: Text(order.classification),
              subtitle: Text(order.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (order) => order.classification,
          selectedValue: selectedOrder,
          onItemSelected: (order) => setState(() {
            selectedOrder = order.classification;
            widget.orderCallback(selectedOrder);
          }),
          onItemDeselected: (order) => setState(() {
            selectedOrder = null;
            widget.orderCallback(selectedOrder);
          }),
        );
      //TODO
      case 'Sarcopterygii':
        return SelectableList<SpeciesClassification, String?>(
          items: ordersSarcopterygii,
          itemBuilder: (context, order, selected, onTap) => ListTile(
              title: Text(order.classification),
              subtitle: Text(order.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (order) => order.classification,
          selectedValue: selectedOrder,
          onItemSelected: (order) => setState(() {
            selectedOrder = order.classification;
            widget.orderCallback(selectedOrder);
          }),
          onItemDeselected: (order) => setState(() {
            selectedOrder = null;
            widget.orderCallback(selectedOrder);
          }),
        );
      //TODO
      default:
        return SelectableList<SpeciesClassification, String?>(
          items: ordersSarcopterygii,
          itemBuilder: (context, order, selected, onTap) => ListTile(
              title: Text(order.classification),
              subtitle: Text(order.description),
              selected: selected,
              onTap: onTap),
          valueSelector: (order) => order.classification,
          selectedValue: selectedOrder,
          onItemSelected: (order) => setState(() {
            selectedOrder = order.classification;
            widget.orderCallback(selectedOrder);
          }),
          onItemDeselected: (order) => setState(() {
            selectedOrder = null;
            widget.orderCallback(selectedOrder);
          }),
        );
    }
  }
}
