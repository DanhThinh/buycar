import 'dart:io';

import 'package:car_rent/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../configs/style_config.dart';

class UpdateCar extends StatefulWidget {
  final CarModel model;
  const UpdateCar(this.model, {super.key});

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  CarModel? c;
  String? selectedCarType;
  List<String> carTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Crossover',
    'Truck',
    'Van',
    'Motorcycle',
  ];
  String? selectedFuel;
  List<String> carFuel = ["gasoline", "oil,"];
  final TextEditingController controllerCarName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerKilomester = TextEditingController();
  final TextEditingController controllerSeats = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  @override
  void initState() {
    controllerCarName.text = widget.model.carName;
    controllerDescription.text = widget.model.description;
    controllerKilomester.text = widget.model.kilometer.toString();
    controllerSeats.text = widget.model.seats.toString();
    controllerPrice.text = widget.model.price.toString();
    selectedCarType = widget.model.carbrand;
    selectedFuel = widget.model.fuel;
    c = widget.model;
    super.initState();
  }

  Future<void> updateCar() async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('car').doc(widget.model.idCar);
    c!.carName = controllerCarName.text;
    c!.description = controllerDescription.text;
    c!.kilometer = double.parse(controllerKilomester.text);
    c!.seats = int.parse(controllerSeats.text);
    c!.price = double.parse(controllerPrice.text);
    c!.carbrand = selectedCarType!;
    c!.fuel = selectedFuel!;
    await documentRef.update(c!.toJson()).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Update Compelte!!!!"),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("BackHome"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Update Car"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('car')
                    .doc(widget.model.idCar)
                    .delete()
                    .then((value) {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Delete Compelte!!!!"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text("BackHome"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                });
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: SafeArea(
        child: Container(
            margin:
                const EdgeInsets.only(left: 13, right: 13, bottom: 15, top: 10),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerCarName,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: kColorBgDark),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Car Name'.tr(),
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff677285),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: controllerDescription,
                          minLines: 3,
                          maxLines: 3,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: kColorBgDark),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Car description'.tr(),
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff677285),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Car brand:  "),
                                  DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(20),
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.green,
                                    ),
                                    value: selectedCarType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCarType = newValue;
                                      });
                                    },
                                    items: carTypes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Fuel:  "),
                                  DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(20),
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.green,
                                    ),
                                    value: selectedFuel,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedFuel = newValue;
                                      });
                                    },
                                    items: carFuel
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: controllerKilomester,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: kColorBgDark),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Kilometer'.tr(),
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff677285),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: controllerSeats,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: kColorBgDark),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Seats'.tr(),
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff677285),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: controllerPrice,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: kColorBgDark),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Pirce'.tr(),
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff677285),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                              image: DecorationImage(
                                image: NetworkImage(widget.model.urlImage),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    updateCar();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text("Update"),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
