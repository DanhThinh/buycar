import 'package:car_rent/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/car_model.dart';
import '../../models/user_model.dart';
import '../../providers/user_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  UserModel? _userModel;
  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cart",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('order').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return const Text('No data available');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        OrderModel om = OrderModel(
                            idCar: document["idCar"],
                            idUserPay: document["idUserPay"],
                            idByer: document["idByer"],
                            status: document["status"],
                            price: document["price"],
                            time: document["time"]);

                        if (_userModel!.id == om.idByer) {
                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('car')
                                .doc(om.idCar)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return const Text('No data available');
                              }
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              CarModel model = CarModel(
                                  idCar: document.id,
                                  id: data["id"],
                                  gmail: data["gmail"],
                                  carName: data["carName"],
                                  description: data["description"],
                                  carbrand: data["carbrand"],
                                  fuel: data["fuel"],
                                  kilometer: data["kilometer"],
                                  seats: data["seats"],
                                  price: data["price"],
                                  urlImage: data["urlImage"],
                                  isActive: data["isActive"]);

                              return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black))),
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
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
                                        om.time
                                            .toDate()
                                            .toString()
                                            .split(" ")[0],
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        om.price.toString(),
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Center(
                                        child: Text("Xe đã mua"),
                                      )
                                    ],
                                  ));
                            },
                          );
                        } else {
                          if (_userModel!.id == om.idUserPay) {
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('car')
                                  .doc(om.idCar)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Text('No data available');
                                }
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                CarModel model = CarModel(
                                    idCar: document.id,
                                    id: data["id"],
                                    gmail: data["gmail"],
                                    carName: data["carName"],
                                    description: data["description"],
                                    carbrand: data["carbrand"],
                                    fuel: data["fuel"],
                                    kilometer: data["kilometer"],
                                    seats: data["seats"],
                                    price: data["price"],
                                    urlImage: data["urlImage"],
                                    isActive: data["isActive"]);

                                return Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
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
                                          om.time
                                              .toDate()
                                              .toString()
                                              .split(" ")[0],
                                          style: const TextStyle(fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          om.price.toString(),
                                          style: const TextStyle(fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Center(
                                          child: Text("Xe đã bán"),
                                        )
                                      ],
                                    ));
                              },
                            );
                          }
                        }
                      });
                }),
          ],
        ));
  }
}
