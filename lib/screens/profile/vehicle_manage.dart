import 'package:car_rent/screens/profile/update_car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/car_model.dart';
import '../../models/user_model.dart';
import '../../providers/user_state.dart';
import '../home_car/car_detail.dart';

class VehicleManage extends StatefulWidget {
  const VehicleManage({super.key});

  @override
  State<VehicleManage> createState() => _VehicleManageState();
}

class _VehicleManageState extends State<VehicleManage> {
  UserModel? _userModel;

  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('car')
            .where("id", isEqualTo: _userModel!.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No data available');
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateCar(model)),
                    );
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(model.urlImage,
                                width: MediaQuery.of(context).size.width,
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
              });
        },
      ),
    );
  }
}
