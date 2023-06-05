import 'package:flutter/material.dart';
import 'classChooser.dart';
import 'orderChooser.dart';
import 'familyChooser.dart';
import 'genusChooser.dart';

class SpeciesStepper extends StatefulWidget {
  final Function classCallback;
  final Function orderCallback;
  final Function familyCallback;
  final Function genusCallback;
  final String order;
  final String class_;
  final String family;
  const SpeciesStepper(
      {Key? key,
      required this.order,
      required this.class_,
      required this.family,
      required this.classCallback,
      required this.orderCallback,
      required this.familyCallback,
      required this.genusCallback})
      : super(key: key);

  @override
  SpeciesStepperState createState() => SpeciesStepperState(order, class_,
      family, classCallback, orderCallback, familyCallback, genusCallback);
}

class SpeciesStepperState extends State<SpeciesStepper> {
  String order = '';
  String class_ = '';
  String family = '';
  late Function classCallback;
  late Function orderCallback;
  late Function familyCallback;
  late Function genusCallback;

  SpeciesStepperState(
      String order_,
      String class_2,
      String family_,
      Function classCallback_,
      Function orderCallback_,
      Function familyCallback_,
      Function genusCallback_) {
    order = order_;
    class_ = class_2;
    classCallback = classCallback_;
    orderCallback = orderCallback_;
    familyCallback = familyCallback_;
    genusCallback = genusCallback_;
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
        type: StepperType.vertical,
        physics: const ScrollPhysics(),
        currentStep: currentStep,
        onStepCancel: () => currentStep == 0
            ? null
            : setState(() {
                currentStep--;
              }),
        onStepTapped: (stepIndex) => setState(() {
              currentStep = stepIndex;
            }),
        onStepContinue: () {
          bool isLastStep = (currentStep == showSpeciesSteps().length - 1);
          if (isLastStep) {
            return;
          } else {
            setState(() {
              currentStep += 1;
            });
          }
        },
        steps: showSpeciesSteps());
  }

  List<Step> showSpeciesSteps() {
    return <Step>[
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text("Choose Class"),
          content: ClassPicker(classCallback: classCallback)),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text("Choose Order"),
          content: OrderPicker(
            orderCallback: orderCallback,
            class_: class_,
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text("Choose Family"),
          content: FamilyPicker(
            familyCallback: familyCallback,
            order: order,
          )),
      Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text("Choose Genus"),
          content: GenusPicker(
            genusCallback: genusCallback,
            family: family,
          )),
    ];
  }
}
