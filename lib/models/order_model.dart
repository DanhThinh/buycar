import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  late String idCar;
  late String idUserPay;
  late String idByer;
  late int status;
  late double price;
  late Timestamp time;
  OrderModel(
      {required this.idCar,
      required this.idUserPay,
      required this.idByer,
      required this.status,
      required this.price,
      required this.time});

  Map<String, dynamic> toJson() => {
        "idCar": idCar,
        "idUserPay": idUserPay,
        "idByer": idByer,
        "status": status,
        "price": price,
        "time": time,
      };
}
