import 'package:car_rent/models/discount_code.dart';
import 'package:flutter/material.dart';

class DiscountScreen extends StatefulWidget {
  final DiscountModel model;
  const DiscountScreen(this.model, {super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                widget.model.image,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              Text(widget.model.name),
              SizedBox(
                height: 10,
              ),
              Text("code: ${widget.model.code}"),
              SizedBox(
                height: 10,
              ),
              Text(widget.model.description),
            ],
          ),
        ),
      ),
    );
  }
}
