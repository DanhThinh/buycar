import 'package:car_rent/common/alert.dart';
import 'package:car_rent/models/car_model.dart';
import 'package:car_rent/models/discount_code.dart';
import 'package:car_rent/models/order_model.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/providers/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../configs/style_config.dart';

class CheckoutScreen extends StatefulWidget {
  final CarModel model;
  const CheckoutScreen(this.model, {super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  UserModel? _userModel;
  DateTime? time;
  bool isLoading = false;

  final TextEditingController _controllerDiscount = TextEditingController();
  int percent = 0;

  @override
  void initState() {
    _userModel = context.read<UserState>().userModel;
    time = DateTime.now();
    super.initState();
  }

  Future<void> checkCodeDiscount(String code) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('discount')
        .where("code", isEqualTo: code)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      var checkUser = await FirebaseFirestore.instance
          .collection('discount')
          .doc(document.id)
          .get();
      List<dynamic> list = checkUser["email"];
      bool isMatch = false;
      for (int i = 0; i < list.length; i++) {
        if (list[i].toString() == _userModel!.email) {
          isMatch = true;
          break;
        }
      }
      if (isMatch) {
        alert(context, "Đã sử dụng discount này rồi!");
      } else {
        setState(() {
          percent = int.parse(document["percent"]);
        });
      }
    } else {
      alert(context, "Không có discount này nha!!!");
    }
  }

  Future<void> Pay() async {
    if (widget.model.id == _userModel!.id) {
      alert(context, "Xe là của bạn!!!");
    } else {
      isLoading = true;
      OrderModel om = OrderModel(
          idCar: widget.model.idCar,
          idUserPay: widget.model.id,
          idByer: _userModel!.id,
          status: 0,
          price: (1 - (percent / 100)) * widget.model.price,
          time: Timestamp.fromDate(time!));
      FirebaseFirestore.instance
          .collection('order')
          .add(om.toJson())
          .then((value) {
        FirebaseFirestore.instance
            .collection('car')
            .doc(widget.model.idCar)
            .update({"isActive": "0"});
        setState(() {
          isLoading = false;
        });
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
                        const Text("Payment success"),
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
    return Material(
      child: SafeArea(
        child: Builder(builder: (context) {
          if (isLoading)
            return const Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 13, right: 13, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("CAR DETAIL"),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.model.carName),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(widget.model.price.toString()),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    Image.network(
                                      widget.model.urlImage,
                                      height: 75,
                                      width: 75,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Date"),
                                    Text(time.toString().split(" ")[0]),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text("Buyer information"),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Full name"),
                                    Text(_userModel!.username),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Address line"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _userModel!.address,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Email Address"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _userModel!.email,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text("DISCOUNT"),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    _controllerDiscount.clear();
                                    String code =
                                        await _showBottomSheetDialog(context);
                                    checkCodeDiscount(code);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: const Center(
                                      child: Text("Use a discount code"),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Price"),
                                    Text(
                                      widget.model.price.toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Discount"),
                                    Text(
                                        "-${(percent / 100) * widget.model.price}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total"),
                                    Text(
                                        "${(1 - (percent / 100)) * widget.model.price}"),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                ),
              ),
              InkWell(
                onTap: () {
                  Pay();
                },
                child: Container(
                  margin: const EdgeInsets.all(13),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: const Center(
                      child: Text(
                    "Payment",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<String> _showBottomSheetDialog(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 13,
                right: 13),
            child: Column(
              children: [
                const Text("DISCOUNT"),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _controllerDiscount,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: kColorBgDark),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Input your discount code here',
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff677285),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _controllerDiscount.text);
                  },
                  child: Text('Redeem'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
