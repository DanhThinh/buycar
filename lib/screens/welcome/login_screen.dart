import 'package:car_rent/custom_icons_icons.dart';
import 'package:car_rent/screens/welcome/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../common/alert.dart';
import '../../configs/style_config.dart';
import '../../providers/user_state.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();

  Future _signInWithGoogle() async {
    try {
      await Provider.of<UserState>(context, listen: false).signInWithGoogle();
    } catch (e) {
      alert(context, 'alertLogin'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding:
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
                  "Enter your Car rent account to contrinue",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Column(
              children: [
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
                    labelText: 'Email address'.tr(),
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
                    labelText: 'Password'.tr(),
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff677285),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                context.read<UserState>().login(controllerEmail.text.trim(),
                    controllerPass.text.trim(), context);
              },
              child: Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text("Login"),
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
                Text("Didn't have a account?"),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text("Resigter"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
