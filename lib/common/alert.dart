import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../configs/style_config.dart';
import '../main.dart';

void alert(BuildContext ctx, content) {
  Flushbar(
    message: content,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    messageColor: Colors.black87,
    backgroundColor: Color(0xFFFDE8EA),
    shouldIconPulse: false,
    icon: const Icon(
      Icons.info,
      size: 20,
      color: kColorRed,
    ),
    borderRadius: BorderRadius.circular(4),
    flushbarPosition: FlushbarPosition.TOP,
    duration: const Duration(milliseconds: 1500),
  ).show(ctx);
}
