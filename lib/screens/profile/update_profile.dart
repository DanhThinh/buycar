import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../configs/style_config.dart';
import '../../models/user_model.dart';
import '../../providers/user_state.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  UserModel? _userModel;
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();

  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    controllerFullName.text = _userModel!.username;
    controllerAddress.text = _userModel!.address;
    super.initState();
  }

  Future<void> updateUser() async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('User').doc(_userModel!.id);
    _userModel!.address = controllerAddress.text;
    _userModel!.username = controllerFullName.text;
    await documentRef.update(_userModel!.toJson()).then((value) {
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
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: controllerFullName,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: kColorBgDark),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Full Name'.tr(),
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff677285),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: controllerAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: kColorBgDark),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Address'.tr(),
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff677285),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      updateUser();
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
