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
  GenusPickerState createState() => GenusPickerState();
}

class GenusPickerState extends State<GenusPicker> {
  String? selectedGenus;

  @override
  Widget build(BuildContext context) {
    return SelectableList<SpeciesClassification, String?>(
      items: mux(),
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

  List<SpeciesClassification> mux() {
    switch (widget.family) {
      case 'Aetobatidae':
        return genusAetobatidae;
      case 'Albulidae':
        return genusAlbulidae;
      case 'Anabantidae':
        return genusAnabantidae;
      case 'Anostomidae':
        return genusAnostomidae;
      case 'Antennariidae':
        return genusAntennariidae;
      case 'Aplocheilidae':
        return genusAplocheilidae;
      case 'Apogonidae':
        return genusApogonidae;
      case 'Arapaimidae':
        return genusArapaimidae;
      case 'Ariidae':
        return genusAriidae;
      case 'Atelomycteridae':
        return genusAtelomycteridae;
      case 'Atherinidae':
        return genusAtherinidae;
      case 'Aulostomidae':
        return genusAulostomidae;
      case 'Bagridae':
        return genusBagridae;
      case 'Balistidae':
        return genusBalistidae;
      case 'Batrachoididae':
        return genusBatrachoididae;
      case 'Belonidae':
        return genusBelonidae;
      case 'Blennidae':
        return genusBlennidae;
      case 'Blythitidae':
        return genusBlythitidae;
      case 'Bothidae':
        return genusBothidae;
      case 'Carangidae':
        return genusCarangidae;
      case 'Carcharhinidae':
        return genusCarcharhinidae;
      case 'Centrogenyidae':
        return genusCentrogenyidae;
      case 'Chaetodonidae':
        return genusChaetodonidae;
      case 'Chanidae':
        return genusChanidae;
      case 'Channidae':
        return genusChannidae;
      case 'Characidae':
        return genusCharacidae;
      case 'Chirocentridae':
        return genusChirocentridae;
      case 'Cichlidae':
        return genusCichlidae;
      case 'Clariidae':
        return genusClariidae;
      case 'Claroteidae':
        return genusClaroteidae;
      case 'Clupeidae':
        return genusClupeidae;
      case 'Coryphaenidae':
        return genusCoryphaenidae;
      case 'Cynoglossidae':
        return genusCynoglossidae;
      case 'Cyprinidae':
        return genusCyprinidae;
      case 'Dasyatidae':
        return genusDasyatidae;
      case 'Diodontidae':
        return genusDiodontidae;
      case 'Drepaneidae':
        return genusDrepaneidae;
      case 'Dussumieriidae':
        return genusDussumieriidae;
      case 'Echeneidae':
        return genusEcheneidae;
      case 'Eleotridae':
        return genusEleotridae;
      case 'Elopidae':
        return genusElopidae;
      case 'Engraulidae':
        return genusEngraulidae;
      case 'Ephippidae':
        return genusEphippidae;
      case 'Fistulariidae':
        return genusFistulariidae;
      case 'Gerreidae':
        return genusGerreidae;
      case 'Gobiidae':
        return genusGobiidae;
      case 'Gymnarchidae':
        return genusGymnarchidae;
      case 'Gyrinocheilidae':
        return genusGyrinocheilidae;
      case 'Haemulidae':
        return genusHaemulidae;
      case 'Hemiramphidae':
        return genusHemiramphidae;
      case 'Hemiscyllidae':
        return genusHemiscyllidae;
      case 'Holocentridae':
        return genusHolocentridae;
      case 'Istiophoridae':
        return genusIstiophoridae;
      case 'Labridae':
        return genusLabridae;
      case 'Leiognathidae':
        return genusLeiognathidae;
      case 'Lepisosteidae':
        return genusLepisosteidae;
      case 'Lethrinidae':
        return genusLethrinidae;
      case 'Loricariidae':
        return genusLoricariidae;
      case 'Lutjanidae':
        return genusLutjanidae;
      case 'Mastacembelidae':
        return genusMastacembelidae;
      case 'Megalopidae':
        return genusMegalopidae;
      case 'Menidae':
        return genusMenidae;
      case 'Mochokidae':
        return genusMochokidae;
      case 'Monacanthidae':
        return genusMonacanthidae;
      case 'Mugilidae':
        return genusMugilidae;
      case 'Muraenidae':
        return genusMuraenidae;
      case 'Muraenisocidae':
        return genusMuraenisocidae;
      case 'Narkidae':
        return genusNarkidae;
      case 'Nemipteridae':
        return genusNemipteridae;
      case 'Notopteridae':
        return genusNotopteridae;
      case 'Ophichthidae':
        return genusOphichthidae;
      case 'Osphronemidae':
        return genusOsphronemidae;
      case 'Osteoglossidae':
        return genusOsteoglossidae;
      case 'Pangasiidae':
        return genusPangasiidae;
      case 'Paralichthyidae':
        return genusParalichthyidae;
      case 'Pegasidae':
        return genusPegasidae;
      case 'Pimelodidae':
        return genusPimelodidae;
      case 'Pinguipedidae':
        return genusPinguipedidae;
      case 'Platycephalidae':
        return genusPlatycephalidae;
      case 'Plotosidae':
        return genusPlotosidae;
      case 'Poeciliidae':
        return genusPoeciliidae;
      case 'Pomacanthidae':
        return genusPomacanthidae;
      case 'Pomacentridae':
        return genusPomacentridae;
      case 'Potamotrygonidae':
        return genusPotamotrygonidae;
      case 'Pristigasteridae':
        return genusPristigasteridae;
      case 'Psettodidae':
        return genusPsettodidae;
      case 'Rachycentridae':
        return genusRachycentridae;
      case 'Rhinidae':
        return genusRhinidae;
      case 'Rhinobatidae':
        return genusRhinobatidae;
      case 'Scaridae':
        return genusScaridae;
      case 'Sciaenidae':
        return genusSciaenidae;
      case 'Scombridae':
        return genusScombridae;
      case 'Scorpaenidae':
        return genusScorpaenidae;
      case 'Serranidae':
        return genusSerranidae;
      case 'Serrasalmidae':
        return genusSerrasalmidae;
      case 'Siganidae':
        return genusSiganidae;
      case 'Sillaginidae':
        return genusSillaginidae;
      case 'Soleidae':
        return genusSoleidae;
      case 'Sphyraenidae':
        return genusSphyraenidae;
      case 'Synanceiidae':
        return genusSynanceiidae;
      case 'Synbranchidae':
        return genusSynbranchidae;
      case 'Syngnathidae':
        return genusSyngnathidae;
      case 'Synodontidae':
        return genusSynodontidae;
      case 'Terapontidae':
        return genusTerapontidae;
      case 'Tetraodontidae':
        return genusTetraodontidae;
      case 'Tetrarogidae':
        return genusTetrarogidae;
      case 'Triacanthidae':
        return genusTriacanthidae;
      case 'Trichonotidae':
        return genusTrichonotidae;
      case 'Zenarchopteridae':
        return genusZenarchopteridae;
      default:
        return genusAetobatidae +
            genusAlbulidae +
            genusAnabantidae +
            genusAnostomidae +
            genusAntennariidae +
            genusAplocheilidae +
            genusApogonidae +
            genusArapaimidae +
            genusAriidae +
            genusAtelomycteridae +
            genusAtherinidae +
            genusAulostomidae +
            genusBagridae +
            genusBalistidae +
            genusBatrachoididae +
            genusBelonidae +
            genusBlennidae +
            genusBlythitidae +
            genusBothidae +
            genusCarangidae +
            genusCarcharhinidae +
            genusCentrogenyidae +
            genusChaetodonidae +
            genusChanidae +
            genusChannidae +
            genusCharacidae +
            genusChirocentridae +
            genusCichlidae +
            genusClariidae +
            genusClaroteidae +
            genusClupeidae +
            genusCoryphaenidae +
            genusCynoglossidae +
            genusCyprinidae +
            genusDasyatidae +
            genusDiodontidae +
            genusDrepaneidae +
            genusDrepaneidae +
            genusDussumieriidae +
            genusEcheneidae +
            genusEleotridae +
            genusElopidae +
            genusEngraulidae +
            genusEphippidae +
            genusFistulariidae +
            genusGerreidae +
            genusGobiidae +
            genusGymnarchidae +
            genusGyrinocheilidae +
            genusHaemulidae +
            genusHemiramphidae +
            genusHemiscyllidae +
            genusHolocentridae +
            genusIstiophoridae +
            genusLabridae +
            genusLeiognathidae +
            genusLepisosteidae +
            genusLethrinidae +
            genusLoricariidae +
            genusLutjanidae +
            genusMastacembelidae +
            genusMegalopidae +
            genusMenidae +
            genusMochokidae +
            genusMochokidae +
            genusMonacanthidae +
            genusMugilidae +
            genusMuraenidae +
            genusMuraenisocidae +
            genusNarkidae +
            genusNemipteridae +
            genusNotopteridae +
            genusOphichthidae +
            genusOsphronemidae +
            genusOsteoglossidae +
            genusPangasiidae +
            genusParalichthyidae +
            genusParalichthyidae +
            genusPegasidae +
            genusPimelodidae +
            genusPinguipedidae +
            genusPlatycephalidae +
            genusPlotosidae +
            genusPoeciliidae +
            genusPomacanthidae +
            genusPomacentridae +
            genusPotamotrygonidae +
            genusPristigasteridae +
            genusPsettodidae +
            genusRachycentridae +
            genusRhinidae +
            genusRhinobatidae +
            genusScaridae +
            genusSciaenidae +
            genusScombridae +
            genusScorpaenidae +
            genusSerranidae +
            genusSerrasalmidae +
            genusSiganidae +
            genusSillaginidae +
            genusSoleidae +
            genusSphyraenidae +
            genusSynanceiidae +
            genusSynbranchidae +
            genusSyngnathidae +
            genusSynodontidae +
            genusTerapontidae +
            genusTetraodontidae +
            genusTetrarogidae +
            genusTrichonotidae +
            genusZenarchopteridae;
    }
  }

  final genusAetobatidae = [
    SpeciesClassification(
        classification: 'Aetobatus', description: 'Spotted Eagle Ray'),
  ];
  final genusAlbulidae = [
    SpeciesClassification(classification: 'Albula', description: 'Bonefish')
  ];
  final genusAnabantidae = [
    SpeciesClassification(
        classification: 'Anabas', description: 'Climbing Perch')
  ];
  final genusAnostomidae = [
    SpeciesClassification(classification: 'Leporinus', description: 'Leporinus')
  ];
  final genusAntennariidae = [
    SpeciesClassification(classification: 'Antennarius', description: ''),
    SpeciesClassification(
        classification: 'Lophiocharon', description: 'Spotted-tail Frogfish'),
  ];
  final genusAplocheilidae = [
    SpeciesClassification(classification: 'Aplocheilus', description: 'Panchax')
  ];
  final genusApogonidae = [
    SpeciesClassification(
        classification: 'Apogon',
        description: 'Ruby Cardinalfish, Flame Cardinalfish'),
    SpeciesClassification(
        classification: 'Apogonichthyoides',
        description:
            'Black Cardinalfish, Timor Cardinalfish, Blackfin Cardinalfish'),
    SpeciesClassification(
        classification: 'Archamia', description: 'Gon’s Cardinalfish'),
    SpeciesClassification(
        classification: 'Cheilodipterus', description: 'Toothy Cardinalfishes'),
    SpeciesClassification(
        classification: 'Fibramia',
        description:
            'Ambon Cardinalfish, Humpbacked Cardinalfish, Masked Cardinalfish'),
    SpeciesClassification(
        classification: 'Fowleria',
        description: 'Crosseyed Cardinalfish, Variegated Cardinalfish'),
    SpeciesClassification(
        classification: 'Jaydia',
        description: 'Flat-tail Cardinalfish, Tenlined Cardinalfish'),
    SpeciesClassification(
        classification: 'Lepidamia', description: 'Pinstriped Cardinalfish'),
    SpeciesClassification(
        classification: 'Nectamia',
        description: 'Samoan Cardinalfish, Similar Cardinalfish'),
    SpeciesClassification(
        classification: 'Ostorhinchus', description: 'Other Cardinalfishes'),
    SpeciesClassification(
        classification: 'Pristiapogon', description: 'Bridled Cardinalfish'),
    SpeciesClassification(
        classification: 'Pristicon',
        description: 'Redfin Cardinalfish, Threespot Cardinalfish'),
    SpeciesClassification(
        classification: 'Pseudamia', description: 'Whitejawed Cardinalfish'),
    SpeciesClassification(
        classification: 'Rhabdamia', description: 'Slender Cardinalfish'),
    SpeciesClassification(
        classification: 'Siphamia', description: 'Urchin Cardinalfish'),
    SpeciesClassification(
        classification: 'Sphaeramia',
        description: 'Orbicular Cardinalfish, Pyjama Cardinalfish'),
    SpeciesClassification(
        classification: 'Taeniamia',
        description: 'Orangelined Cardinalfish, Duskytail Cardinalfish'),
    SpeciesClassification(
        classification: 'Yarica', description: 'Mangrove Cardinalfish')
  ];
  final genusArapaimidae = [
    SpeciesClassification(classification: 'Arapaima', description: 'Arapaima')
  ];
  final genusAriidae = [
    SpeciesClassification(
        classification: 'Arius',
        description: 'Gagora Catfish, Lowly Sea Catfish'),
    SpeciesClassification(
        classification: 'Hemiarius', description: 'Sona Sea Catfish'),
    SpeciesClassification(
        classification: 'Hexanematichthys', description: 'Sagor Catfish'),
    SpeciesClassification(
        classification: 'Netuma',
        description: 'Bronze Catfish, Giant Salmon Catfish'),
    SpeciesClassification(
        classification: 'Plicofollis',
        description: 'Shieldhead Catfish, Longsnouted Catfish'),
    SpeciesClassification(
        classification: 'Osteogeneiosus', description: 'Soldier Catfish'),
  ];
  final genusAtelomycteridae = [
    SpeciesClassification(
        classification: 'Atelomycterus ', description: 'Coral Catshark'),
  ];
  final genusAtherinidae = [
    SpeciesClassification(
        classification: 'Atherinomorus',
        description: 'Widebanded Hardyhead Silverside'),
    SpeciesClassification(
        classification: 'Doboatherina', description: 'Tropical Silverside'),
    SpeciesClassification(
        classification: 'Hypoatherina', description: 'Sumatran Silverside'),
  ];
  final genusAulostomidae = [
    SpeciesClassification(
        classification: 'Aulostomus', description: 'Trumpetfish'),
  ];
  final genusBagridae = [
    SpeciesClassification(
        classification: 'Hemibagrus',
        description: 'Malayan River Catfish, Asian Redtailed Catfish'),
    SpeciesClassification(
        classification: 'Mystus', description: 'Estuarine Catfish, Baung')
  ];
  final genusBalistidae = [
    SpeciesClassification(
        classification: 'Abalistes', description: 'Starry Triggerfish'),
    SpeciesClassification(
        classification: 'Balistapus', description: 'Orangelined Triggerfish'),
    SpeciesClassification(
        classification: 'Balistoides', description: 'Titan Triggerfish'),
  ];
  final genusBatrachoididae = [
    SpeciesClassification(
        classification: 'Batrachomoeus', description: 'Toadfish')
  ];
  final genusBelonidae = [
    SpeciesClassification(
        classification: 'Ablennes', description: 'Flat Needlefish'),
    SpeciesClassification(
        classification: 'Strongylura', description: 'Other Needlefishes'),
    SpeciesClassification(
        classification: 'Tylosurus', description: 'Hound Needlefish'),
  ];
  final genusBlennidae = [
    SpeciesClassification(
        classification: 'Entomacrodus',
        description: 'Stellar Rockskipper, Blackspotted Rockskipper'),
    SpeciesClassification(
        classification: 'Istiblennius', description: 'Streaky Rockskipper'),
    SpeciesClassification(
        classification: 'Omobranchus', description: 'Crested Oyster Blenny'),
    SpeciesClassification(
        classification: 'Petroscirtes',
        description: 'Variable Sabretooth Blenny'),
  ];
  final genusBlythitidae = [
    SpeciesClassification(
        classification: 'Alionematichthys ', description: 'Bigeye Cuskeel'),
    SpeciesClassification(
        classification: 'Dinematichthys', description: 'Yellow Cuskeel'),
    SpeciesClassification(
        classification: 'Ungusurculus', description: 'Riau Viviparous Brotula'),
  ];
  final genusBothidae = [
    SpeciesClassification(
        classification: 'Engyprosopon', description: 'Largescale Flounder'),
  ];
  final genusCarangidae = [
    SpeciesClassification(
        classification: 'Alectis', description: 'African Pompano'),
    SpeciesClassification(classification: 'Alepes', description: 'Other Scads'),
    SpeciesClassification(
        classification: 'Atropus',
        description:
            'Cleftbelly Trevally, Longfin Trevally, Bumpnose Trevally, Longrakered Trevally'),
    SpeciesClassification(
        classification: 'Atule', description: 'Yellowtail Scad'),
    SpeciesClassification(
        classification: 'Carangoides', description: 'Brownback Trevally'),
    SpeciesClassification(
        classification: 'Caranx',
        description: 'Bigeye Trevally, Giant Trevally, Bluefin Trevally'),
    SpeciesClassification(
        classification: 'Decapterus',
        description: 'Indian Scad, Mackerel Scad'),
    SpeciesClassification(
        classification: 'Platycaranx',
        description: 'Longnose Trevally, Imposter Trevally, Malabar trevally'),
    SpeciesClassification(
        classification: 'Scomberoides', description: 'Queenfishes'),
    SpeciesClassification(
        classification: 'Scyris', description: 'Diamond Trevally'),
    SpeciesClassification(
        classification: 'Selar', description: 'Oxeye Scad, Bigeye Scad'),
    SpeciesClassification(
        classification: 'Selaroides', description: 'Yellowstripe Scad'),
    SpeciesClassification(
        classification: 'Trachinotus', description: 'Pompanos'),
    SpeciesClassification(
        classification: 'Turrum',
        description: 'Goldspotted Trevally, Onion Trevally'),
  ];
  final genusCentrogenyidae = [
    SpeciesClassification(
        classification: 'Centrogenys', description: 'False Scorpionfish'),
  ];
  final genusChaetodonidae = [
    SpeciesClassification(
        classification: 'Parachaetodon', description: 'Kite Butterflyfish'),
    SpeciesClassification(
        classification: 'Chaetodon', description: 'Eightbanded Butterflyfish'),
    SpeciesClassification(
        classification: 'Chelmon', description: 'Copperbanded Butterflyfish'),
  ];
  final genusChanidae = [
    SpeciesClassification(classification: 'Chanos', description: 'Milkfish')
  ];
  final genusChannidae = [
    SpeciesClassification(classification: 'Channa', description: 'Snakeheads')
  ];
  final genusCharacidae = [
    SpeciesClassification(
        classification: 'Hemigrammus', description: 'Golden Tetra')
  ];
  final genusCarcharhinidae = [
    SpeciesClassification(
        classification: 'Carcharhinus', description: 'Reef Sharks, Bull Shark'),
  ];
  final genusChirocentridae = [
    SpeciesClassification(
        classification: 'Chirocentrus', description: 'Wolf Herrings')
  ];
  final genusCichlidae = [
    SpeciesClassification(
        classification: 'Acarichthys', description: 'Threadfin Acara'),
    SpeciesClassification(
        classification: 'Amphilophus',
        description: 'Trimac Cichlid, Midas Cichlid, Red Devil Cichlid'),
    SpeciesClassification(
        classification: 'Cichla', description: 'Peacock Basses'),
    SpeciesClassification(
        classification: 'Etroplus', description: 'Green Chromide'),
    SpeciesClassification(
        classification: 'Geophagus', description: 'Red-lined Eartheater'),
    SpeciesClassification(
        classification: 'Heterotilapia', description: 'Zebra Tilapia'),
    SpeciesClassification(
        classification: 'Mayaheros', description: 'Mayan Cichlid'),
    SpeciesClassification(
        classification: 'Oreochromis', description: 'Other Tilapias'),
    SpeciesClassification(
        classification: 'Parachromis ', description: 'Jaguar Cichlid'),
    SpeciesClassification(
        classification: 'Satanoperca', description: 'Demon Eartheater'),
    SpeciesClassification(classification: 'Uaru', description: 'Uaru Cichlid'),
    SpeciesClassification(
        classification: 'Vieja', description: 'Redhead Cichlid'),
  ];
  final genusClariidae = [
    SpeciesClassification(
        classification: 'Clarias', description: 'Walking Catfishes')
  ];
  final genusClaroteidae = [
    SpeciesClassification(
        classification: 'Chrysichthys', description: 'Nile Golden Catfish')
  ];
  final genusClupeidae = [
    SpeciesClassification(
        classification: 'Amblygaster', description: 'Spotted Sardine'),
    SpeciesClassification(
        classification: 'Anodontosoma', description: 'Chacunda Gizzard Shad'),
    SpeciesClassification(
        classification: 'Herklotsichthys', description: 'Blacksaddle Herring'),
    SpeciesClassification(classification: 'Hilsa', description: 'Kelee Shad'),
    SpeciesClassification(
        classification: 'Nematalosa',
        description: 'Galathea Gizzard Shad, Bloch’s Gizzard Shad'),
    SpeciesClassification(
        classification: 'Sardinella', description: 'Sardinellas'),
  ];
  final genusCoryphaenidae = [
    SpeciesClassification(classification: 'Coryphaena', description: 'Dolphin'),
  ];
  final genusCynoglossidae = [
    SpeciesClassification(classification: 'Cynoglossus', description: ''),
    SpeciesClassification(
        classification: 'Paraplagusia', description: 'Tongue Soles'),
    SpeciesClassification(classification: 'Plagusia', description: ''),
  ];
  final genusCyprinidae = [
    SpeciesClassification(
        classification: 'Barbodes',
        description: 'Saddle Barb, Indochinese Spotted Barb'),
    SpeciesClassification(
        classification: 'Barbonymus', description: 'Tinfoil Barbs'),
    SpeciesClassification(
        classification: 'Brachydanio', description: 'Pearl Danio'),
    SpeciesClassification(classification: 'Carassius', description: 'Goldfish'),
    SpeciesClassification(
        classification: 'Ctenopharyngodon', description: 'Grass Carp'),
    SpeciesClassification(
        classification: 'Cyclocheilichthys', description: 'Beardless Barb'),
    SpeciesClassification(
        classification: 'Cyprinus', description: 'Common Carp, Amur Carp'),
    SpeciesClassification(
        classification: 'Desmopuntius', description: 'Sixbanded Tiger Barb'),
    SpeciesClassification(
        classification: 'Hampala', description: 'Hampala Barb'),
    SpeciesClassification(
        classification: 'Hypophthalmichthys',
        description: 'Bighead Carp, Silver Carp'),
    SpeciesClassification(classification: 'Labeo', description: 'Rohu'),
    SpeciesClassification(
        classification: 'Leptobarbus', description: 'Sultan Fish'),
    SpeciesClassification(
        classification: 'Osteochilus', description: 'Bonylip Barb'),
    SpeciesClassification(
        classification: 'Puntigrus',
        description: 'Fourbanded Tiger Barb, Fivebanded Tiger Barb'),
    SpeciesClassification(
        classification: 'Puntius', description: 'Spotfin Swamp Barb'),
    SpeciesClassification(
        classification: 'Rasbora', description: 'Other Rasboras'),
    SpeciesClassification(
        classification: 'Striuntius', description: 'Spanner Barb'),
    SpeciesClassification(classification: 'Tor', description: 'Mahseers'),
    SpeciesClassification(
        classification: 'Toxabramis', description: 'Sharpbelly'),
    SpeciesClassification(
        classification: 'Trigonostigma', description: 'Harlequin Rasbora'),
  ];
  final genusDasyatidae = [
    SpeciesClassification(
        classification: 'Brevitrygon',
        description: 'Dwarf Whipray, Dwarf Mangrove Whipray'),
    SpeciesClassification(
        classification: 'Himantura', description: 'Other Whiprays'),
    SpeciesClassification(
        classification: 'Neotrygon', description: 'Kuhl’s Maskray'),
    SpeciesClassification(
        classification: 'Pastinachus', description: 'Cowtail Ray'),
    SpeciesClassification(
        classification: 'Taeniura', description: 'Bluespotted Ribbontail Ray'),
  ];
  final genusDiodontidae = [
    SpeciesClassification(
        classification: 'Cyclichthys', description: 'Burrfishes'),
    SpeciesClassification(
        classification: 'Diodon', description: 'Porcupinefishes'),
  ];
  final genusDrepaneidae = [
    SpeciesClassification(classification: 'Drepane', description: 'Sicklefish'),
  ];
  final genusDussumieriidae = [
    SpeciesClassification(
        classification: 'Dussumieria', description: 'Slender Rainbow Sardine')
  ];
  final genusEcheneidae = [
    SpeciesClassification(classification: 'Echeneis', description: 'Remora'),
  ];
  final genusEleotridae = [
    SpeciesClassification(
        classification: 'Butis',
        description: 'Mudsleeper, Olive Flathead Gudgeon, Duckbill Sleeper'),
    SpeciesClassification(
        classification: 'Ophiocara', description: 'Spangled Gudgeon'),
    SpeciesClassification(
        classification: 'Oxyeleotris', description: 'Marbled Goby'),
  ];
  final genusElopidae = [
    SpeciesClassification(classification: 'Elops', description: 'Ladyfish')
  ];
  final genusEngraulidae = [
    SpeciesClassification(
        classification: 'Coilia', description: 'Grenadier Anchovies'),
    SpeciesClassification(
        classification: 'Encrasicholina',
        description: 'Shorthead Anchovy, Buccaneer Anchovy'),
    SpeciesClassification(
        classification: 'Setipinna', description: 'Scaly Hairfin Anchovy'),
    SpeciesClassification(
        classification: 'Stolephorus', description: 'Other Anchovies'),
    SpeciesClassification(classification: 'Thryssa', description: 'Thryssas'),
  ];
  final genusEphippidae = [
    SpeciesClassification(classification: 'Ephippus', description: 'Orbfish'),
    SpeciesClassification(classification: 'Platax', description: 'Batfishes'),
  ];
  final genusFistulariidae = [
    SpeciesClassification(
        classification: 'Fistularia', description: 'Cornetfish'),
  ];
  final genusGerreidae = [
    SpeciesClassification(classification: 'Gerres', description: 'Mojarras'),
  ];
  final genusGobiidae = [
    SpeciesClassification(
        classification: 'Acentrogobius', description: 'Mangrove Gobies'),
    SpeciesClassification(
        classification: 'Amblyeleotris',
        description: 'Masked Shrimpgoby, Giant Shrimpgoby'),
    SpeciesClassification(
        classification: 'Amblygobius ',
        description: 'Head-stripe Goby. Buan goby'),
    SpeciesClassification(classification: 'Amoya', description: ''),
    SpeciesClassification(classification: 'Arcygobius', description: ''),
    SpeciesClassification(
        classification: 'Bathygobius', description: 'Frillfin Gobies'),
    SpeciesClassification(
        classification: 'Boleophthalmus',
        description: 'Bluespotted Mudskipper'),
    SpeciesClassification(
        classification: 'Brachygobius', description: 'Bumbleebee Gobies'),
    SpeciesClassification(
        classification: 'Cryptocentroides', description: 'Insignia Shrimpgoby'),
    SpeciesClassification(
        classification: 'Cryptocentrus', description: 'Other Shrimpgobies'),
    SpeciesClassification(classification: 'Drombus', description: ''),
    SpeciesClassification(classification: 'Eugnathogobius', description: ''),
    SpeciesClassification(classification: 'Eviota', description: ''),
    SpeciesClassification(
        classification: 'Favonigobius', description: 'Sand Gobies'),
    SpeciesClassification(
        classification: 'Glossogobius',
        description: 'Golden Flathead Goby, Tank Goby'),
    SpeciesClassification(
        classification: 'Gobiodon', description: 'Broadbarred Acropora Goby'),
    SpeciesClassification(
        classification: 'Gobiopterus', description: 'Glass Gobies'),
    SpeciesClassification(classification: 'Hemigobius', description: ''),
    SpeciesClassification(
        classification: 'Istigobius', description: 'Lagoon Gobies'),
    SpeciesClassification(classification: 'Macrodontogobius', description: ''),
    SpeciesClassification(
        classification: 'Mahidolia', description: 'Flagfin Shrimpgoby'),
    SpeciesClassification(classification: 'Mugilogobius', description: ''),
    SpeciesClassification(
        classification: 'Myersina',
        description: 'Yellowspotted Shrimpgoby, Blacklined Shrimpgoby'),
    SpeciesClassification(classification: 'Oplopomus', description: ''),
    SpeciesClassification(classification: 'Pandaka ', description: ''),
    SpeciesClassification(
        classification: 'Periophthalmodon', description: 'Giant Mudskipper'),
    SpeciesClassification(
        classification: 'Periophthalmus', description: 'Other Mudskippers'),
    SpeciesClassification(classification: 'Priolepis', description: ''),
    SpeciesClassification(
        classification: 'Psammogobius', description: 'Sleepy Goby'),
    SpeciesClassification(
        classification: 'Pseudapocryptes', description: 'Elongated Mudskipper'),
    SpeciesClassification(
        classification: 'Pseudogobiopsis', description: 'Bigmouth Stream Goby'),
    SpeciesClassification(
        classification: 'Pseudogobius ', description: 'Fat Nose Gobies'),
    SpeciesClassification(classification: 'Redigobius', description: ''),
    SpeciesClassification(
        classification: 'Rhinogobius', description: 'Barcheek River Goby'),
    SpeciesClassification(
        classification: 'Scartelaos', description: 'Bearded Mudskipper'),
    SpeciesClassification(classification: 'Silhouettea', description: ''),
    SpeciesClassification(
        classification: 'Stigmatogobius', description: 'Knight Gobies'),
    SpeciesClassification(classification: 'Tomiyamichthys', description: ''),
    SpeciesClassification(
        classification: 'Trypauchen', description: 'Pink Mud Goby'),
    SpeciesClassification(
        classification: 'Valenciennea ',
        description: 'Diamond Watchman Goby, Mural Goby'),
    SpeciesClassification(
        classification: 'Yongeichthys', description: 'Shadow Goby'),
  ];
  final genusGymnarchidae = [
    SpeciesClassification(
        classification: 'Gymnarchus', description: 'African Knifefish')
  ];
  final genusGyrinocheilidae = [
    SpeciesClassification(
        classification: 'Gyrinocheilus', description: 'Chinese Algae Eater')
  ];
  final genusHaemulidae = [
    SpeciesClassification(classification: 'Pomadasys', description: 'Grunters'),
    SpeciesClassification(
        classification: 'Plectorhinchus', description: 'Other Sweetlips'),
    SpeciesClassification(
        classification: 'Diagramma', description: 'Painted Sweetlips')
  ];
  final genusHemiramphidae = [
    SpeciesClassification(
        classification: 'Hemiramphus', description: 'Blackbarred Halfbeak'),
    SpeciesClassification(
        classification: 'Hyporhamphus',
        description: 'Quoy’s Halfbeak, Congaturi Halfbeak'),
    SpeciesClassification(classification: 'Euleptorhamphus', description: '')
  ];
  final genusHemiscyllidae = [
    SpeciesClassification(
        classification: 'Chiloscyllium', description: 'Bamboo Sharks'),
  ];
  final genusHolocentridae = [
    SpeciesClassification(
        classification: 'Myripristis', description: 'Soldierfishes'),
    SpeciesClassification(
        classification: 'Sargocentron', description: 'Squirrelfishes'),
  ];
  final genusIstiophoridae = [
    SpeciesClassification(
        classification: 'Istiompax ', description: 'Black Marlin'),
    SpeciesClassification(
        classification: 'Istiophorus', description: 'Sailfish'),
  ];
  final genusLabridae = [
    SpeciesClassification(
        classification: 'Anampses', description: 'Spotted Wrasse'),
    SpeciesClassification(
        classification: 'Cheilinus',
        description: 'Maori Wrasses, Floral Wrasse'),
    SpeciesClassification(
        classification: 'Cheilio', description: 'Cigar Wrasse'),
    SpeciesClassification(classification: 'Choerodon', description: 'Tuskfish'),
    SpeciesClassification(
        classification: 'Halichoeres', description: 'Other Wrasses'),
    SpeciesClassification(
        classification: 'Hemigymnus', description: 'Half-and-Half Wrasse'),
    SpeciesClassification(
        classification: 'Oxycheilinus', description: 'Cheeklined Wrasse'),
    SpeciesClassification(
        classification: 'Thalassoma', description: 'Moon Wrasse'),
    SpeciesClassification(
        classification: 'Pteragogus', description: 'Weedy Wrasse'),
  ];
  final genusLeiognathidae = [
    SpeciesClassification(
        classification: 'Aurigequula',
        description: 'Striped Ponyfish, Longspine Ponyfish'),
    SpeciesClassification(
        classification: 'Deveximentum', description: 'Pugnose Ponyfish'),
    SpeciesClassification(
        classification: 'Equulites', description: 'Whipfin Ponyfish'),
    SpeciesClassification(
        classification: 'Eubleekeria',
        description: 'Jones’ Ponyfish, Splendid Ponyfish'),
    SpeciesClassification(classification: 'Gazza', description: 'Toothpony'),
    SpeciesClassification(
        classification: 'Karalla', description: 'Goldstriped Ponyfish'),
    SpeciesClassification(
        classification: 'Leiognathus', description: 'Common Ponyfish'),
    SpeciesClassification(
        classification: 'Nuchequula', description: 'Decorated Ponyfish'),
    SpeciesClassification(classification: 'Photolateralis', description: ''),
    SpeciesClassification(classification: 'Photopectoralis', description: ''),
  ];
  final genusLepisosteidae = [
    SpeciesClassification(
        classification: 'Atractosteus', description: 'Alligator Gar'),
    SpeciesClassification(
        classification: 'Lepisosteus', description: 'Spotted Gar'),
  ];
  final genusLethrinidae = [
    SpeciesClassification(classification: 'Lethrinus', description: 'Emperors'),
  ];
  final genusLoricariidae = [
    SpeciesClassification(
        classification: 'Pterygoplichthys', description: 'Plecos')
  ];
  final genusLutjanidae = [
    SpeciesClassification(classification: 'Lutjanus', description: 'Snappers'),
  ];
  final genusMastacembelidae = [
    SpeciesClassification(
        classification: 'Macrognathus', description: 'Spiny Eels')
  ];
  final genusMegalopidae = [
    SpeciesClassification(classification: 'Megalops', description: 'Tarpon')
  ];
  final genusMenidae = [
    SpeciesClassification(classification: 'Mene', description: 'Moonfish'),
  ];
  final genusMochokidae = [
    SpeciesClassification(
        classification: 'Synodontis', description: 'Featherfin Squeaker')
  ];
  final genusMonacanthidae = [
    SpeciesClassification(
        classification: 'Acreichthys', description: 'Seagrass Filefish'),
    SpeciesClassification(
        classification: 'Aluterus', description: 'Scrawled Filefish'),
    SpeciesClassification(
        classification: 'Anacanthus', description: 'Bearded Filefish'),
    SpeciesClassification(
        classification: 'Chaetodermis', description: 'Feathery Filefish'),
    SpeciesClassification(
        classification: 'Monacanthus', description: 'Fan-bellied Filefish'),
    SpeciesClassification(
        classification: 'Paramonacanthus',
        description: 'Pig-faced Leatherjacket'),
    SpeciesClassification(
        classification: 'Pseudomonacanthus', description: 'Strapweed Filefish'),
  ];
  final genusMugilidae = [
    SpeciesClassification(
        classification: 'Ellochelon', description: 'Diamondscale Mullet'),
    SpeciesClassification(
        classification: 'Mugil', description: 'Flathead Grey Mullet'),
    SpeciesClassification(
        classification: 'Osteomugil', description: 'Longfin Mullet'),
    SpeciesClassification(
        classification: 'Planiliza', description: 'Greenback Mullet'),
    SpeciesClassification(
        classification: 'Valamugil', description: 'Bluespot Mullet'),
  ];
  final genusMuraenidae = [
    SpeciesClassification(
        classification: 'Diaphenchelys', description: 'Dalmatian Moray'),
    SpeciesClassification(
        classification: 'Gymnothorax', description: 'Other Morays'),
    SpeciesClassification(
        classification: 'Strophidon',
        description:
            'Gangetic Moray, Slender Giant Moray, Four-pored Slender Giant Moray, Longback Moray'),
  ];
  final genusMuraenisocidae = [
    SpeciesClassification(
        classification: 'Congresox',
        description: 'Yellow Pike Conger, Indian Pike Conger'),
    SpeciesClassification(
        classification: 'Muraenesox',
        description: 'Common Pike Conger, Daggertooth Pike Conger')
  ];
  final genusNarkidae = [
    SpeciesClassification(
        classification: 'Temera', description: 'Hardwicke’s Electric Ray'),
  ];
  final genusNemipteridae = [
    SpeciesClassification(
        classification: 'Nemipterus', description: 'Threadfin Breams'),
    SpeciesClassification(
        classification: 'Pentapodus', description: 'Whiptails'),
    SpeciesClassification(
        classification: 'Scolopsis', description: 'Monocle Breams'),
  ];
  final genusNotopteridae = [
    SpeciesClassification(
        classification: 'Chitala',
        description: 'Clown Knifefish, Royal Knifefish'),
    SpeciesClassification(
        classification: 'Notopterus', description: 'Bronze Knifefish'),
  ];
  final genusOphichthidae = [
    SpeciesClassification(
        classification: 'Ophichthus', description: 'Evermann’s Snake Eel'),
    SpeciesClassification(
        classification: 'Pisodonophis',
        description: 'Mangrove Snake Eel, Longfin Snake Eel'),
    SpeciesClassification(
        classification: 'Scolecenchelys', description: 'Worm Eels'),
  ];
  final genusOsphronemidae = [
    SpeciesClassification(classification: 'Betta', description: 'Bettas'),
    SpeciesClassification(
        classification: 'Osphronemus ', description: 'Giant Gourami'),
    SpeciesClassification(
        classification: 'Trichopodus', description: 'Threespot Gourami'),
    SpeciesClassification(
        classification: 'Trichopsis',
        description: 'Croaking Gourami, Sparkling Gourami')
  ];
  final genusOsteoglossidae = [
    SpeciesClassification(
        classification: 'Osteoglossum', description: 'Silver Arowana'),
    SpeciesClassification(
        classification: 'Scleropages', description: 'Asian Arowana, Saratoga'),
  ];
  final genusPangasiidae = [
    SpeciesClassification(
        classification: 'Pangasianodon', description: 'Patin'),
    SpeciesClassification(
        classification: 'Pangasius', description: 'Chao Phraya Catfish'),
  ];
  final genusParalichthyidae = [
    SpeciesClassification(
        classification: 'Pseudorhombus ', description: 'Flounders'),
  ];
  final genusPegasidae = [
    SpeciesClassification(classification: 'Pegasus', description: 'Seamoth'),
  ];
  final genusPimelodidae = [
    SpeciesClassification(
        classification: 'Phractocephalus', description: 'Redtailed Catfish')
  ];
  final genusPinguipedidae = [
    SpeciesClassification(
        classification: 'Parapercis', description: 'Sandperches'),
  ];
  final genusPlatycephalidae = [
    SpeciesClassification(classification: 'Grammoplites', description: ''),
    SpeciesClassification(
        classification: 'Inegocia', description: 'Japanese Flathead'),
    SpeciesClassification(
        classification: 'Platycephalus',
        description: 'Bartailed Flathead, Dusky Flathead'),
    SpeciesClassification(classification: 'Rogadius', description: ''),
    SpeciesClassification(
        classification: 'Sphyraena',
        description: 'Fringe-eyed Flathead, Crocodile Flathead'),
    SpeciesClassification(
        classification: 'Sunagocia', description: 'Papillose Flathead'),
    SpeciesClassification(
        classification: 'Thysanophrys', description: 'Celebes Flathead'),
  ];
  final genusPlotosidae = [
    SpeciesClassification(
        classification: 'Paraplotosus',
        description: 'Whitelipped Eeltail Catfish'),
    SpeciesClassification(
        classification: 'Plotosus',
        description: 'Black Eeltail Catfish, Striped Eeltail Catfish')
  ];
  final genusPoeciliidae = [
    SpeciesClassification(
        classification: 'Gambusia', description: 'Mosquitofish'),
    SpeciesClassification(
        classification: 'Poecilia', description: 'Guppy, Mollies'),
    SpeciesClassification(
        classification: 'Xiphophorus', description: 'Swordtail, Platyfishes'),
  ];
  final genusPomacanthidae = [
    SpeciesClassification(
        classification: 'Pomacanthus',
        description: 'Blueringed Angelfish, Sixbar Angelfish'),
    SpeciesClassification(
        classification: 'Pomacanthus', description: 'Singapore Angelfish'),
  ];
  final genusPomacentridae = [
    SpeciesClassification(
        classification: 'Abudefduf', description: 'Sergeants'),
    SpeciesClassification(
        classification: 'Amblyglyphidodon', description: 'Staghorn Damsel'),
    SpeciesClassification(
        classification: 'Amphiprion', description: 'Clownfish'),
    SpeciesClassification(
        classification: 'Dascyllus', description: 'Threespot Dascyllus'),
    SpeciesClassification(
        classification: 'Dischistodus',
        description:
            'White Damsel, Bumblebee Damsel, Honeyhead Damsel, Whitespot Damsel'),
    SpeciesClassification(
        classification: 'Hemiglyphidodon', description: 'Sweetlip Damsel'),
    SpeciesClassification(
        classification: 'Neopomacentrus', description: 'Demoiselles'),
    SpeciesClassification(
        classification: 'Pomacentrus',
        description:
            'Smoky Damsel, Silty Damsel, Obscure Damsel, Threespot Damsel, Whitetail Damsel'),
    SpeciesClassification(
        classification: 'Stegastes', description: 'Western Gregory'),
  ];
  final genusPotamotrygonidae = [
    SpeciesClassification(
        classification: 'Potamotrygon', description: 'Motoro Ray'),
  ];
  final genusPristigasteridae = [
    SpeciesClassification(classification: 'Ilisha', description: 'Ilishas'),
    SpeciesClassification(
        classification: 'Opisthopterus',
        description: 'Bigeyed Longfin Herring'),
    SpeciesClassification(
        classification: 'Pellona', description: 'Indian Pellona'),
  ];
  final genusPsettodidae = [
    SpeciesClassification(classification: 'Psettodes', description: 'Halibuts'),
  ];
  final genusRachycentridae = [
    SpeciesClassification(classification: 'Rachycentron', description: 'Cobia'),
  ];
  final genusRhinidae = [
    SpeciesClassification(
        classification: 'Rhynchobatus', description: 'Whitespotted Guitarfish'),
  ];
  final genusRhinobatidae = [
    SpeciesClassification(
        classification: 'Pseudobatos', description: 'Pacific Shovelnose Ray'),
  ];
  final genusScaridae = [
    SpeciesClassification(
        classification: 'Scarus', description: 'Parrotfishes'),
  ];
  final genusSciaenidae = [
    SpeciesClassification(
        classification: 'Dendrophysa', description: 'Goatee Croaker'),
    SpeciesClassification(
        classification: 'Johnius', description: 'Other Croakers'),
    SpeciesClassification(classification: 'Nibea ', description: 'Barracudas'),
    SpeciesClassification(
        classification: 'Otolithes', description: 'Tigertooth Croaker'),
    SpeciesClassification(
        classification: 'Otolithoides', description: 'Bronze Croaker'),
    SpeciesClassification(
        classification: 'Pennahia', description: 'Bigeye Croaker'),
    SpeciesClassification(classification: 'Protonibea', description: ''),
    SpeciesClassification(
        classification: 'Pseudolarimichthys ',
        description: 'Terengganu Yellow Croaker'),
  ];
  final genusScombridae = [
    SpeciesClassification(
        classification: 'Euthynnus', description: 'Mackerel Tuna'),
    SpeciesClassification(
        classification: 'Rastrelliger',
        description: 'Short Mackerel, Indian Mackerel'),
    SpeciesClassification(
        classification: 'Scomberomorus', description: 'Spanish Mackerels'),
  ];
  final genusScorpaenidae = [
    SpeciesClassification(
        classification: 'Parascorpaena', description: 'Painted Scorpionfish'),
    SpeciesClassification(classification: 'Pterois', description: 'Lionfishes'),
    SpeciesClassification(classification: 'Scorpaenodes', description: ''),
    SpeciesClassification(
        classification: 'Scorpaenopsis', description: 'Other Scorpionfishes'),
  ];
  final genusSerranidae = [
    SpeciesClassification(
        classification: 'Cephalopholis', description: 'Hinds'),
    SpeciesClassification(
        classification: 'Diploprion', description: 'Yellow Soapfish'),
    SpeciesClassification(
        classification: 'Epinephelus', description: 'Groupers'),
    SpeciesClassification(
        classification: 'Plectropomus', description: 'Coral Trouts'),
  ];
  final genusSerrasalmidae = [
    SpeciesClassification(classification: 'Piaractus', description: 'Pacu')
  ];
  final genusSiganidae = [
    SpeciesClassification(
        classification: 'Siganus', description: 'Rabbitfishes'),
  ];
  final genusSillaginidae = [
    SpeciesClassification(
        classification: 'Sillago', description: 'Sand Whitings'),
  ];
  final genusSoleidae = [
    SpeciesClassification(
        classification: 'Brachirus', description: 'Oriental Sole, Dusky Sole'),
    SpeciesClassification(
        classification: 'Dagetichthys', description: 'Commerson’s Sole'),
    SpeciesClassification(
        classification: 'Pardachirus', description: 'Peacock Sole'),
    SpeciesClassification(classification: 'Synaptura', description: ''),
    SpeciesClassification(classification: 'Zebrias', description: 'Zebra Sole'),
  ];
  final genusSphyraenidae = [
    SpeciesClassification(
        classification: 'Sphyraena', description: 'Barracudas'),
  ];
  final genusSynanceiidae = [
    SpeciesClassification(classification: 'Inimicus', description: 'Stingers'),
    SpeciesClassification(
        classification: 'Leptosynanceia', description: 'Mangrove Stonefish'),
    SpeciesClassification(
        classification: 'Synanceia',
        description: 'Hollow-cheeked Stonefish, Reef Stonefish'),
    SpeciesClassification(
        classification: 'Trachicephalus', description: 'Stargazing Stonefish'),
  ];
  final genusSynbranchidae = [
    SpeciesClassification(
        classification: 'Macrotrema', description: 'Pink Mud Eel'),
    SpeciesClassification(
        classification: 'Monopterus', description: 'Sunda Swamp Eel'),
    SpeciesClassification(
        classification: 'Ophisternon', description: 'Mangrove Swamp Eel'),
  ];
  final genusSyngnathidae = [
    SpeciesClassification(
        classification: 'Ichthyocampus', description: 'Mangrove Pipefish'),
    SpeciesClassification(classification: 'Corythoichthys', description: ''),
    SpeciesClassification(classification: 'Syngnathoides', description: ''),
    SpeciesClassification(
        classification: 'Hippocampus', description: 'Seahorses'),
  ];
  final genusSynodontidae = [
    SpeciesClassification(
        classification: 'Saurida', description: 'Lizardfishes')
  ];
  final genusTerapontidae = [
    SpeciesClassification(classification: 'Pelates', description: 'Trumpeters'),
    SpeciesClassification(classification: 'Scortum', description: 'Jade Perch'),
    SpeciesClassification(
        classification: 'Terapon',
        description: 'Crescent Perch, Banded Perch, Smallscaled Terapon'),
  ];
  final genusTetraodontidae = [
    SpeciesClassification(
        classification: 'Arothron',
        description:
            'Yelloweye Puffer, Reticulate Puffer, Stars and Stripes Puffer, Starry Puffer, Map Puffer, Bluespotted Puffer'),
    SpeciesClassification(
        classification: 'Chelonodontops', description: 'Milkspotted Puffer'),
    SpeciesClassification(
        classification: 'Dichotomyctere', description: 'Spotted Green Puffer'),
    SpeciesClassification(
        classification: 'Lagocephalus',
        description:
            'Rough Golden Puffer, Half-smooth Golden Puffer, Suez Puffer, Guenther’s Puffer, Silvercheeked Puffer'),
    SpeciesClassification(
        classification: 'Takifugu', description: 'Oblong Blaasop'),
  ];
  final genusTetrarogidae = [
    SpeciesClassification(
        classification: 'Paracentropogon', description: 'Longspine Waspfish'),
  ];
  final genusTriacanthidae = [
    SpeciesClassification(
        classification: 'Triacanthus',
        description: 'Shortnose Tripodfish, Silver Tripodfish'),
    SpeciesClassification(
        classification: 'Tripodichthys', description: 'Longtail Tripodfish')
  ];
  final genusTrichonotidae = [
    SpeciesClassification(
        classification: 'Trichonotus', description: 'Sand-diver'),
  ];
  final genusZenarchopteridae = [
    SpeciesClassification(
        classification: 'Dermogenys', description: 'Pygmy Halfbeak'),
    SpeciesClassification(
        classification: 'Hemirhamphodon',
        description: 'Malayan Forest Halfbeak'),
    SpeciesClassification(
        classification: 'Zenarchopterus', description: 'Other Halfbeaks'),
  ];
}
