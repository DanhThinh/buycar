import 'package:car_rent/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../common/alert.dart';
import '../../configs/style_config.dart';
import '../../custom_icons_icons.dart';
import '../../providers/user_state.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "register_screen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoding = false;
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();

  Future _signInWithGoogle() async {
    try {
      await Provider.of<UserState>(context, listen: false).signInWithGoogle();
    } catch (e) {
      alert(context, 'alertLogin'.tr());
    }
  }

  Future register() async {
    try {
      UserModel u = UserModel(
          id: "",
          username: controllerFullName.text,
          password: controllerPass.text,
          email: controllerEmail.text,
          address: controllerAddress.text);
      isLoding = true;
      await context.read<UserState>().register(u).then((value) {
        Navigator.pop(context);
        isLoding = false;
      });
    } catch (e) {
      alert(context, 'alertLogin'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (context) {
        if (isLoding) return Center(child: const CircularProgressIndicator());
        return Container(
          color: Colors.white,
          margin:
              const EdgeInsets.only(left: 13, right: 13, top: 30, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: const [
                  Text(
                    "Welcome to, Car rent!",
                    style: TextStyle(color: Colors.black, fontSize: 32),
                  ),
                  Text(
                    "It' your first time to use Car rent",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
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
                  labelText: 'Username'.tr(),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff677285),
                  ),
                ),
              ),
              TextField(
                controller: controllerEmail,
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
                  labelText: "Email address".tr(),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff677285),
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                controller: controllerPass,
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
                  labelText: "Password".tr(),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff677285),
                  ),
                ),
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
                  labelText: "Address".tr(),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff677285),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  register();
                },
                child: Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text("Register"),
                  ),
                ),
              ),
              Column(
                children: [
                  const Text("or login with"),
                  IconButton(
                      onPressed: _signInWithGoogle,
                      icon: const Icon(
                        CustomIcons.google,
                        size: 22,
                        color: Colors.red,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have a acount?"),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("login"),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
