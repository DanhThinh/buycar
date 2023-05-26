import 'package:car_rent/models/car_model.dart';
import 'package:car_rent/screens/home_car/checkout_screen.dart';
import 'package:flutter/material.dart';

class CarDetail extends StatefulWidget {
  final CarModel model;
  const CarDetail(this.model, {super.key});

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            widget.model.urlImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 13, right: 13, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.model.carName),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(widget.model.description),
                                const SizedBox(
                                  height: 45,
                                ),
                                const Text("CAR DETAIL"),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Fuel"),
                                    Text(widget.model.fuel),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Kilomester"),
                                    Text("${widget.model.kilometer} km"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Seats"),
                                    Text(widget.model.seats.toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Car brand"),
                                    Text(widget.model.carbrand.toString()),
                                  ],
                                ),
                              ],
                            ))
                      ]),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(13),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.model.carName),
                          Text(widget.model.price.toString())
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CheckoutScreen(widget.model)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text("Rent car"),
                        ),
                      )
                    ]),
              )
            ],
          ),
          Positioned(
              top: 30,
              left: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
