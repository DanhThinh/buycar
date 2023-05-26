import 'package:car_rent/common/alert.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/providers/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../configs/style_config.dart';

class ChagePassWord extends StatefulWidget {
  const ChagePassWord({super.key});

  @override
  State<ChagePassWord> createState() => _ChagePassWordState();
}

class _ChagePassWordState extends State<ChagePassWord> {
  User? user;
  UserModel? _userModel;
  final TextEditingController controllerOld = TextEditingController();
  final TextEditingController controllerNew = TextEditingController();
  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  void changePassword() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null && controllerOld.text.trim() == _userModel!.password) {
      try {
        user = FirebaseAuth.instance.currentUser;
        await user!.updatePassword(controllerNew.text.trim());
        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('User').doc(_userModel!.id);

        try {
          await documentRef.update({
            "password": controllerNew.text.trim(),
          });
          print('Cập nhật dữ liệu thành công');
        } catch (error) {
          print('Lỗi khi cập nhật dữ liệu: $error');
        }
        alert(context, "Đổi pass thành công");
      } catch (error) {
        print(error);
        alert(context, "lỗi $error");
      }
    } else {
      alert(context, "password old khoong ddungs");
    }
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
                    obscureText: true,
                    controller: controllerOld,
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
                      labelText: 'old Password'.tr(),
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
                    obscureText: true,
                    controller: controllerNew,
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
                      labelText: 'new Password'.tr(),
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
                      changePassword();
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
