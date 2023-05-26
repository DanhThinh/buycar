import 'dart:io';

import 'package:car_rent/common/alert.dart';
import 'package:car_rent/models/car_model.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/providers/user_state.dart';
import 'package:car_rent/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import '../../configs/style_config.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  UserModel? _userModel;
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
  String url = "";
  File? i;
  String nameImage = "";

  //TextFile
  final TextEditingController controllerCarName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerKilomester = TextEditingController();
  final TextEditingController controllerSeats = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  String email = "";

  //
  @override
  void initState() {
    email = context.read<UserState>().user!.email ?? "thinh@gmail.com";
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      CroppedFile? images = await ImageCropper()
          .cropImage(sourcePath: file.path, aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio3x2,
      ]);
      nameImage = result.files.single.name;
      i = File(images!.path);
      setState(() {
        url = images.path;
      });
    }
  }

  Future<void> submitCar() async {
    bool isPush = true;
    var storageRef = FirebaseStorage.instance.ref().child('imagesCar');
    if (nameImage == "") {
      isPush = false;
      alert(context, "chưa có ảnh nè bạn yêu ơi");
    }
    if (controllerCarName.text.trim().isEmpty) {
      isPush = false;
      alert(context, "Namecar chưa điền kìa bạn iu ơi");
    }
    if (controllerDescription.text.trim().isEmpty) {
      isPush = false;
      alert(context, "Description chưa điền kìa bạn iu ơi");
    }
    if (controllerKilomester.text.trim().isEmpty) {
      isPush = false;
      alert(context, "Kilomester chưa điền kìa bạn iu ơi");
    }
    if (controllerSeats.text.trim().isEmpty) {
      isPush = false;
      alert(context, "Seats chưa điền kìa bạn iu ơi");
    }
    if (controllerPrice.text.trim().isEmpty) {
      isPush = false;
      alert(context, "Price chưa điền kìa bạn iu ơi");
    }
    if (isPush) {
      var imageRef = storageRef.child(nameImage);
      await imageRef.putFile(i!);
      String imageUrl = await imageRef.getDownloadURL();
      print(_userModel!.id);
      CarModel c = CarModel(
          idCar: "",
          id: _userModel!.id,
          gmail: email,
          carName: controllerCarName.text,
          description: controllerDescription.text,
          carbrand: selectedCarType!,
          fuel: selectedFuel!,
          kilometer: double.parse(controllerKilomester.text),
          seats: int.parse(controllerSeats.text),
          price: double.parse(controllerPrice.text),
          urlImage: imageUrl,
          isActive: "1");
      FirebaseFirestore.instance
          .collection('car')
          .add(c.toJson())
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
                        const Text("Push Compelte!!!!"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Car"),
        elevation: 0,
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
                                image: FileImage(File(url)),
                                fit: BoxFit.fill,
                              )),
                          child: url != ""
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    pickFile();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Center(
                                          child:
                                              Icon(Icons.camera_alt_outlined)),
                                      Text("Add your photo here")
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    submitCar();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text("Submit"),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
