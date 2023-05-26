import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/providers/user_state.dart';
import 'package:car_rent/screens/profile/chagepassword.dart';
import 'package:car_rent/screens/profile/update_profile.dart';
import 'package:car_rent/screens/profile/vehicle_manage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userModel;
  bool isLoading = false;
  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  Future<void> logoutUser() async {
    isLoading = true;
    await context.read<UserState>().logout().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) return const CircularProgressIndicator();
      return Container(
        margin: const EdgeInsets.only(top: 30, left: 13, right: 13),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Profile",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlueAccent,
                border: Border.all(color: Colors.black)),
            child: Row(children: [
              const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_userModel!.username),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_userModel!.email)
                ],
              ))
            ]),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 13, right: 13, top: 20, bottom: 20),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: SingleChildScrollView(
                child: Column(children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfile()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        children: const [
                          Icon(Icons.person_2_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Account Profile")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VehicleManage()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        children: const [
                          Icon(Icons.car_repair),
                          SizedBox(
                            width: 10,
                          ),
                          Text("vehicle management")
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              logoutUser();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding:
                  EdgeInsets.only(left: 13, right: 13, top: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text("Logout")),
            ),
          ),
        ]),
      );
    });
  }
}
