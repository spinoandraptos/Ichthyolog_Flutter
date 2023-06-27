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
  String? selectedFamily;

  @override
  Widget build(BuildContext context) {
    return SelectableList<SpeciesClassification, String?>(
      items: mux(),
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

  List<SpeciesClassification> mux() {
    switch (widget.order) {
      case 'Albuliformes':
        return familyAlbuliformes;
      case 'Anabantiformes':
        return familyAnabantiformes;
      case 'Anguilliformes':
        return familyAnguilliformes;
      case 'Atheriniformes':
        return familyAtheriniformes;
      case 'Aulopiformes':
        return familyAulopiformes;
      case 'Batrachoidiformes':
        return familyBatrachoidiformes;
      case 'Beloniformes':
        return familyBeloniformes;
      case 'Blenniformes':
        return familyBlenniformes;
      case 'Carangiformes':
        return familyCarangiformes;
      case 'Carcharhiniformes':
        return familyCarcharhiniformes;
      case 'Characiformes':
        return familyCharaciformes;
      case 'Cichliformes':
        return familyCichliformes;
      case 'Clupeiformes':
        return familyClupeiformes;
      case 'Cypriniformes':
        return familyCypriniformes;
      case 'Cyprinodontiformes':
        return familyCyprinodontiformes;
      case 'Elopiformes':
        return familyElopiformes;
      case 'Gobiiformes':
        return familyGobiiformes;
      case 'Gonorynchiformes':
        return familyGonorynchiformes;
      case 'Holocentriformes':
        return familyHolocentriformes;
      case 'Istiophoriformes':
        return familyIstiophoriformes;
      case 'Kurtiformes':
        return familyKurtiformes;
      case 'Lepisosteiformes':
        return familyLepisosteiformes;
      case 'Lophiiformes':
        return familyLophiiformes;
      case 'Mugiliformes':
        return familyMugiliformes;
      case 'Ophidiiformes':
        return familyOphidiiformes;
      case 'Orectolobiformes':
        return familyOrectolobiformes;
      case 'Osteoglossiformes':
        return familyOsteoglossiformes;
      case 'Perciformes':
        return familyPerciformes;
      case 'Pleuronectiformes':
        return familyPleuronectiformes;
      case 'Rajiformes':
        return familyRajiformes;
      case 'Rhinopristiformes':
        return familyRhinopristiformes;
      case 'Scombriformes':
        return familyScombriformes;
      case 'Scorpaeniformes':
        return familyScorpaeniformes;
      case 'Siluriformes':
        return familySiluriformes;
      case 'Synbranchiformes':
        return familySynbranchiformes;
      case 'Syngnathiformes':
        return familySyngnathiformes;
      case 'Tetraodontiformes':
        return familyTetraodontiformes;
      case 'Torpediniformes':
        return familyTorpediniformes;
      default:
        return familyAlbuliformes +
            familyAnabantiformes +
            familyAnguilliformes +
            familyAtheriniformes +
            familyAulopiformes +
            familyBatrachoidiformes +
            familyBeloniformes +
            familyBlenniformes +
            familyCarangiformes +
            familyCarcharhiniformes +
            familyCharaciformes +
            familyCichliformes +
            familyClupeiformes +
            familyCypriniformes +
            familyCyprinodontiformes +
            familyElopiformes +
            familyElopiformes +
            familyGobiiformes +
            familyGonorynchiformes +
            familyHolocentriformes +
            familyIstiophoriformes +
            familyKurtiformes +
            familyLepisosteiformes +
            familyLophiiformes +
            familyMugiliformes +
            familyOphidiiformes +
            familyOrectolobiformes +
            familyOsteoglossiformes +
            familyPerciformes +
            familyPleuronectiformes +
            familyRajiformes +
            familyRhinopristiformes +
            familyScombriformes +
            familyScorpaeniformes +
            familySiluriformes +
            familySynbranchiformes +
            familySyngnathiformes +
            familyTetraodontiformes +
            familyTorpediniformes;
    }
  }

  final familyAlbuliformes = [
    SpeciesClassification(classification: 'Albulidae', description: 'Bonefish')
  ];
  final familyAnabantiformes = [
    SpeciesClassification(
        classification: 'Anabantidae', description: 'Climbing Perch'),
    SpeciesClassification(
        classification: 'Channidae', description: 'Snakeheads'),
    SpeciesClassification(
        classification: 'Osphronemidae', description: 'Gouramis')
  ];
  final familyAnguilliformes = [
    SpeciesClassification(classification: 'Muraenidae', description: 'Morays'),
    SpeciesClassification(
        classification: 'Muraenisocidae', description: 'Pike Congers'),
    SpeciesClassification(
        classification: 'Ophichthidae', description: 'Snake Eels')
  ];
  final familyAtheriniformes = [
    SpeciesClassification(
        classification: 'Atherinidae', description: 'Silversides')
  ];
  final familyAulopiformes = [
    SpeciesClassification(
        classification: 'Synodontidae', description: 'Lizardfishes')
  ];
  final familyBatrachoidiformes = [
    SpeciesClassification(
        classification: 'Batrachoididae', description: 'Toadfishes')
  ];
  final familyBeloniformes = [
    SpeciesClassification(
        classification: 'Belonidae', description: 'Needlefishes'),
    SpeciesClassification(
        classification: 'Hemiramphidae', description: 'Halfbeaks'),
    SpeciesClassification(
        classification: 'Zenarchopteridae', description: 'Viviparous Halfbeaks')
  ];
  final familyBlenniformes = [
    SpeciesClassification(classification: 'Blennidae', description: 'Blennies')
  ];
  final familyCarangiformes = [
    SpeciesClassification(
        classification: 'Carangidae',
        description: 'Trevallies, Scads, Pompano'),
    SpeciesClassification(
        classification: 'Coryphaenidae', description: 'Dolphinfish'),
    SpeciesClassification(classification: 'Echeneidae', description: 'Remora'),
    SpeciesClassification(classification: 'Menidae ', description: 'Moonfish'),
    SpeciesClassification(
        classification: 'Rachycentridae', description: 'Cobia'),
  ];
  final familyCharaciformes = [
    SpeciesClassification(
        classification: 'Anostomidae', description: 'Leporinus'),
    SpeciesClassification(classification: 'Characidae', description: 'Tetra'),
    SpeciesClassification(classification: 'Serrasalmidae', description: 'Pacu'),
  ];
  final familyCichliformes = [
    SpeciesClassification(classification: 'Cichlidae', description: 'Cichlids')
  ];
  final familyClupeiformes = [
    SpeciesClassification(
        classification: 'Chirocentridae', description: 'Wolf Herrings'),
    SpeciesClassification(
        classification: 'Clupeidae', description: 'Sardines and Gizzard Shads'),
    SpeciesClassification(
        classification: 'Dussumieriidae', description: 'Rainbow Sardine'),
    SpeciesClassification(
        classification: 'Engraulidae', description: 'Anchovies and Thryssa'),
    SpeciesClassification(
        classification: 'Pristigasteridae', description: 'Ilishas')
  ];
  final familyCypriniformes = [
    SpeciesClassification(
        classification: 'Cyprinidae', description: 'Carps and Barbs'),
    SpeciesClassification(
        classification: 'Gyrinocheilidae', description: 'Algae Eater')
  ];
  final familyCyprinodontiformes = [
    SpeciesClassification(
        classification: 'Aplocheilidae',
        description: 'Panchax and Killifishes'),
    SpeciesClassification(
        classification: 'Poeciliidae',
        description: 'Mosquitofishes, Guppy, Swordtail, Mollies, Platyfishes'),
  ];
  final familyElopiformes = [
    SpeciesClassification(
        classification: 'Elopidae', description: 'Giant Herrings'),
    SpeciesClassification(classification: 'Megalopidae', description: 'Tarpons')
  ];
  final familyGobiiformes = [
    SpeciesClassification(
        classification: 'Eleotridae', description: 'Gudgeons'),
    SpeciesClassification(classification: 'Gobiidae', description: 'Gobies'),
    SpeciesClassification(
        classification: 'Ptereleotridae', description: 'Dartfish')
  ];
  final familyGonorynchiformes = [
    SpeciesClassification(classification: 'Chanidae', description: 'Milkfish')
  ];
  final familyHolocentriformes = [
    SpeciesClassification(
        classification: 'Holocentridae',
        description: 'Squirrelfish and Soldierfish')
  ];
  final familyIstiophoriformes = [
    SpeciesClassification(
        classification: 'Istiophoridae', description: 'Marlins and Sailfish'),
    SpeciesClassification(
        classification: 'Sphyraenidae', description: 'Barracudas'),
  ];
  final familyKurtiformes = [
    SpeciesClassification(
        classification: 'Apogonidae', description: 'Cardinalfishes')
  ];
  final familyLepisosteiformes = [
    SpeciesClassification(classification: 'Lepisosteidae', description: 'Gars')
  ];
  final familyLophiiformes = [
    SpeciesClassification(
        classification: 'Antennariidae', description: 'Frogfishes')
  ];
  final familyMugiliformes = [
    SpeciesClassification(classification: 'Mugilidae', description: 'Mullets')
  ];
  final familyOphidiiformes = [
    SpeciesClassification(
        classification: 'Blythitidae', description: 'Viviparous Brotulas')
  ];
  final familyOsteoglossiformes = [
    SpeciesClassification(
        classification: 'Arapaimidae', description: 'Arapaima'),
    SpeciesClassification(
        classification: 'Gymnarchidae', description: 'Electric Knifefish'),
    SpeciesClassification(
        classification: 'Notopteridae', description: 'Knifefishes'),
    SpeciesClassification(
        classification: 'Osteoglossidae', description: 'Arowanas'),
  ];
  final familyPleuronectiformes = [
    SpeciesClassification(
        classification: 'Bothidae', description: 'Largescale Flounder'),
    SpeciesClassification(
        classification: 'Cynoglossidae', description: 'Tongue Soles'),
    SpeciesClassification(
        classification: 'Paralichthyidae', description: 'Flounders'),
    SpeciesClassification(
        classification: 'Psettodidae', description: 'Halibuts'),
    SpeciesClassification(
        classification: 'Soleidae', description: 'True Soles'),
  ];
  final familyPerciformes = [
    SpeciesClassification(
        classification: 'Acanthuridae', description: 'Surgeonfish and Tangs'),
    SpeciesClassification(
        classification: 'Centrogenyidae', description: 'False Scorpionfish'),
    SpeciesClassification(
        classification: 'Chaetodonidae', description: 'Butterflyfishes'),
    SpeciesClassification(
        classification: 'Drepaneidae', description: 'Sicklefish'),
    SpeciesClassification(
        classification: 'Ephippidae', description: 'Spadefishes'),
    SpeciesClassification(classification: 'Gerreidae', description: 'Mojarras'),
    SpeciesClassification(
        classification: 'Haemulidae', description: 'Grunters'),
    SpeciesClassification(classification: 'Labridae', description: 'Wrasses'),
    SpeciesClassification(
        classification: 'Leiognathidae', description: 'Ponyfishes'),
    SpeciesClassification(
        classification: 'Lethrinidae', description: 'Emperors'),
    SpeciesClassification(
        classification: 'Lutjanidae', description: 'Snappers'),
    SpeciesClassification(
        classification: 'Nemipteridae', description: 'Breams'),
    SpeciesClassification(
        classification: 'Pinguipedidae', description: 'Sandperches'),
    SpeciesClassification(
        classification: 'Pomacanthidae', description: 'Saltwater Angelfishes'),
    SpeciesClassification(
        classification: 'Pomacentridae', description: 'Damselfishes'),
    SpeciesClassification(
        classification: 'Scaridae', description: 'Parrotfishes'),
    SpeciesClassification(
        classification: 'Sciaenidae ', description: 'Croakers'),
    SpeciesClassification(
        classification: 'Serranidae', description: 'Groupers'),
    SpeciesClassification(
        classification: 'Siganidae', description: 'Rabbitfishes'),
    SpeciesClassification(
        classification: 'Sillaginidae', description: 'Sand Whitings'),
    SpeciesClassification(
        classification: 'Terapontidae', description: 'Terapons and Perches'),
    SpeciesClassification(
        classification: 'Trichonotidae', description: 'Sand-divers'),
  ];
  final familyScorpaeniformes = [
    SpeciesClassification(
        classification: 'Platycephalidae', description: 'Flatheads'),
    SpeciesClassification(
        classification: 'Scorpaenidae',
        description: 'Scorpionfishes and Lionfishes'),
    SpeciesClassification(
        classification: 'Synanceiidae',
        description: 'Stingers and Stonefishes'),
    SpeciesClassification(
        classification: 'Tetrarogidae', description: 'Waspfish')
  ];
  final familySiluriformes = [
    SpeciesClassification(
        classification: 'Ariidae', description: 'Sea Catfishes'),
    SpeciesClassification(
        classification: 'Bagridae', description: 'Bagrid Catfishes'),
    SpeciesClassification(
        classification: 'Clariidae', description: 'Walking Catfishes'),
    SpeciesClassification(
        classification: 'Claroteidae', description: 'Nile Golden Catfish'),
    SpeciesClassification(
        classification: 'Loricariidae', description: 'Plecos'),
    SpeciesClassification(
        classification: 'Mochokidae', description: 'Featherfin Squeaker'),
    SpeciesClassification(
        classification: 'Pangasiidae',
        description: 'Patin, Chao Phraya Catfish'),
    SpeciesClassification(
        classification: 'Pimelodidae', description: 'Redtailed Catfish'),
    SpeciesClassification(
        classification: 'Plotosidae', description: 'Eeltail Catfishes'),
  ];
  final familyScombriformes = [
    SpeciesClassification(
        classification: 'Scombridae', description: 'Mackerels and Tunas')
  ];
  final familySynbranchiformes = [
    SpeciesClassification(
        classification: 'Mastacembelidae', description: 'Spiny Eels'),
    SpeciesClassification(
        classification: 'Synbranchidae', description: 'Swamp Eels'),
  ];
  final familySyngnathiformes = [
    SpeciesClassification(
        classification: 'Aulostomidae', description: 'Trumpetfish'),
    SpeciesClassification(
        classification: 'Centriscidae', description: 'Razorfish'),
    SpeciesClassification(
        classification: 'Fistulariidae', description: 'Cornetfish'),
    SpeciesClassification(classification: 'Pegasidae', description: 'Seamoth'),
    SpeciesClassification(
        classification: 'Syngnathidae', description: 'Pipefishes and Seahorses')
  ];
  final familyTetraodontiformes = [
    SpeciesClassification(
        classification: 'Balistidae', description: 'Triggerfishes'),
    SpeciesClassification(
        classification: 'Diodontidae', description: 'Porcupine Puffers'),
    SpeciesClassification(
        classification: 'Monacanthidae', description: 'Filefishes'),
    SpeciesClassification(
        classification: 'Tetraodontidae', description: 'Puffers'),
    SpeciesClassification(
        classification: 'Triacanthidae', description: 'Tripodfishes')
  ];
  final familyCarcharhiniformes = [
    SpeciesClassification(
        classification: 'Atelomycteridae', description: 'Catshark'),
    SpeciesClassification(
        classification: 'Carcharhinidae',
        description: 'Reef Sharks and Bull Shark'),
  ];
  final familyOrectolobiformes = [
    SpeciesClassification(
        classification: 'Hemiscyllidae', description: 'Bamboo sharks')
  ];
  final familyRajiformes = [
    SpeciesClassification(
        classification: 'Aetobatidae', description: 'Eagle Ray'),
    SpeciesClassification(
        classification: 'Dasyatidae', description: 'Saltwater Stingrays'),
    SpeciesClassification(
        classification: 'Potamotrygonidae', description: 'Motoro Ray'),
  ];
  final familyRhinopristiformes = [
    SpeciesClassification(
        classification: 'Rhinobatidae', description: 'Shovelnose Ray'),
    SpeciesClassification(
        classification: 'Rhynchobatus', description: 'Guitarfish'),
  ];
  final familyTorpediniformes = [
    SpeciesClassification(
        classification: 'Narkidae', description: 'Electric Ray')
  ];
}
