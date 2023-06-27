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
  OrderPickerState createState() => OrderPickerState();
}

class OrderPickerState extends State<OrderPicker> {
  String? selectedOrder;

  @override
  Widget build(BuildContext context) {
    return SelectableList<SpeciesClassification, String?>(
      items: mux(),
      itemBuilder: (context, order, selected, onTap) => ListTile(
          title: Text(order.classification),
          subtitle: Text(order.description),
          selected: selected,
          onTap: onTap),
      valueSelector: (order) => order.classification,
      selectedValue: selectedOrder,
      onItemSelected: (order) {
        setState(() {
          selectedOrder = order.classification;
        });
        widget.orderCallback(selectedOrder);
      },
      onItemDeselected: (order) {
        setState(() {
          selectedOrder = '';
        });
        widget.orderCallback(selectedOrder);
      },
    );
  }

  List<SpeciesClassification> mux() {
    switch (widget.class_) {
      case 'Chondrichthyes':
        return ordersChondrichthyes;
      case 'Actinopterygii':
        return ordersActinopterygii;
      default:
        return ordersActinopterygii + ordersChondrichthyes;
    }
  }

  final ordersActinopterygii = [
    SpeciesClassification(
        classification: 'Albuliformes', description: 'Bonefish'),
    SpeciesClassification(
        classification: 'Anabantiformes', description: 'Labyrinth Fishes'),
    SpeciesClassification(
        classification: 'Anguilliformes', description: 'True eels'),
    SpeciesClassification(
        classification: 'Atheriniformes', description: 'Silversides'),
    SpeciesClassification(
        classification: 'Aulopiformes', description: 'Lizardfishes'),
    SpeciesClassification(
        classification: 'Batrachoidiformes', description: 'Toadfishes'),
    SpeciesClassification(
        classification: 'Beloniformes',
        description: 'Needlefishes and Halfbeaks'),
    SpeciesClassification(
        classification: 'Blenniformes', description: 'Blennies'),
    SpeciesClassification(
        classification: 'Carangiformes',
        description:
            'Trevallies, Queenfishes, Scads, Pompanos, Remora, Cobia, Dolphinfish and Moonfish'),
    SpeciesClassification(
        classification: 'Characiformes', description: 'Tetras'),
    SpeciesClassification(
        classification: 'Cichliformes', description: 'Cichlids'),
    SpeciesClassification(
        classification: 'Clupeiformes ', description: 'Herrings and Anchovies'),
    SpeciesClassification(
        classification: 'Cypriniformes',
        description: 'Barbs, Carps and Algae Eater'),
    SpeciesClassification(
        classification: 'Cyprinodontiformes', description: 'Toothcarps'),
    SpeciesClassification(
        classification: 'Elopiformes', description: 'Tarpon and Ladyfish'),
    SpeciesClassification(
        classification: 'Gobiiformes', description: 'Gobies and Gudgeons'),
    SpeciesClassification(
        classification: 'Gonorynchiformes ', description: 'Milkfish'),
    SpeciesClassification(
        classification: 'Holocentriformes',
        description: 'Squirrelfishes and Soldierfishes'),
    SpeciesClassification(
        classification: 'Istiophoriformes',
        description: 'Barracudas, Marlins and Sailfishes'),
    SpeciesClassification(
        classification: 'Kurtiformes', description: 'Cardinalfishes'),
    SpeciesClassification(
        classification: 'Lepisosteiformes', description: 'Gars'),
    SpeciesClassification(
        classification: 'Lophiiformes', description: 'Frogfishes'),
    SpeciesClassification(
        classification: 'Mugiliformes', description: 'Mullets'),
    SpeciesClassification(
        classification: 'Ophidiiformes', description: 'Cuskeels and Brotulas'),
    SpeciesClassification(
        classification: 'Osteoglossiformes ',
        description: 'Arapaima, Arowana and Knifefish'),
    SpeciesClassification(
        classification: 'Pleuronectiformes', description: 'Flatfishes'),
    SpeciesClassification(
        classification: 'Perciformes',
        description:
            'Perches, Terapons, Grunters, Sweetlips, Croakers, Wrasses, Tuskfishes, Parrotfishes, Mojarras, Ponyfishes, Groupers, Emperors, Snappers, Breams, Sand-divers, Sandperches, Spadefishes, Sicklefish, Damselfishes, Whitings, Rabbitfishes, Tangs, Butterflyfishes, Angelfishes'),
    SpeciesClassification(
        classification: 'Scorpaeniformes',
        description:
            'Flatheads, Lionfishes, Scorpionfishes, Stonefishes, Waspfishes'),
    SpeciesClassification(
        classification: 'Siluriformes', description: 'Catfishes'),
    SpeciesClassification(
        classification: 'Scombriformes', description: 'Mackerels ands Tunas'),
    SpeciesClassification(
        classification: 'Synbranchiformes ',
        description: 'Swamp eels, Spiny eels and Mud eels'),
    SpeciesClassification(
        classification: 'Syngnathiformes',
        description:
            'Seahorses, Pipefishes, Seamoths, Razorfishes, Trumpetfishes and Cornetfishes'),
    SpeciesClassification(
        classification: 'Tetraodontiformes',
        description:
            'Pufferfishes, Filefishes, Triggerfishes and Tripodfishes'),
  ];

  final ordersChondrichthyes = [
    SpeciesClassification(
        classification: 'Carcharhiniformes',
        description: 'Reef sharks, Bull shark and Catshark'),
    SpeciesClassification(
        classification: 'Orectolobiformes', description: 'Bamboo Sharks'),
    SpeciesClassification(
        classification: 'Rajiformes', description: 'Stingrays'),
    SpeciesClassification(
        classification: 'Rhinopristiformes', description: 'Shovelnose Rays'),
    SpeciesClassification(
        classification: 'Torpediniformes', description: 'Electric Rays'),
  ];
}
