import 'package:car_rent/common/alert.dart';
import 'package:car_rent/custom_icons_icons.dart';
import 'package:car_rent/models/discount_code.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/screens/addcar_screen/add_screen.dart';
import 'package:car_rent/screens/home_car/car_detail.dart';
import 'package:car_rent/screens/home_car/car_screen.dart';
import 'package:car_rent/screens/home_car/discount_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/car_model.dart';
import '../../providers/user_state.dart';

class HomeCarScreen extends StatefulWidget {
  const HomeCarScreen({super.key});

  @override
  State<HomeCarScreen> createState() => _HomeCarScreenState();
}

class _HomeCarScreenState extends State<HomeCarScreen> {
  bool isLoading = false;
  UserModel? _userModel;
  @override
  void initState() {
    loadUser();
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  Future<void> loadUser() async {
    isLoading = true;
    await context.read<UserState>().loadUserModel().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading)
        return const Center(
          child: CircularProgressIndicator(),
        );
      return Container(
        margin: const EdgeInsets.only(left: 13, right: 13, top: 30),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello, ${context.read<UserState>().userModel.username}"),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddScreen()),
                    );
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('discount').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return const Text('No data available');
              }
              return PageView(
                scrollDirection: Axis.horizontal,
                children: List.generate(snapshot.data!.docs.length, (index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  DiscountModel model = DiscountModel(
                    name: document["name"],
                    description: document["description"],
                    image: document["image"],
                    percent: document["percent"],
                    code: document["code"],
                  );
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiscountScreen(model)),
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(model.image,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fitWidth),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              model.name,
                              style: const TextStyle(fontSize: 30),
                            )
                          ],
                        )
                        // Text(document['description']),
                        ),
                  );
                }),
              );
            },
          )),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('car').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Vehicle"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CarScreen()),
                          );
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text("See all")),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (index < 5) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          CarModel model = CarModel(
                              idCar: document.id,
                              id: document["id"],
                              gmail: document["gmail"],
                              carName: document["carName"],
                              description: document["description"],
                              carbrand: document["carbrand"],
                              fuel: document["fuel"],
                              kilometer: document["kilometer"],
                              seats: document["seats"],
                              price: document["price"],
                              urlImage: document["urlImage"],
                              isActive: document["isActive"]);
                          if (model.isActive == "1") {
                            return InkWell(
                              onTap: () {
                                if (_userModel!.id == model.id) {
                                  alert(context, "Xe cuar ban");
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CarDetail(model)),
                                  );
                                }
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      (2 / 3),
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(model.urlImage,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fitWidth),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        model.carName,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        model.price.toString(),
                                        style: const TextStyle(fontSize: 25),
                                      )
                                    ],
                                  )),
                            );
                          }
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ))
        ]),
      );
    });
  }
}
