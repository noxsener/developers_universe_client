library translatePipe;

import 'dart:convert';

import 'package:flutter/material.dart';

String language = 'tr_TR';
Map<String, dynamic> tr_TR = {};
Map<String, dynamic> en_US = {};

initTranslate(BuildContext context) async {
  if (tr_TR.isNotEmpty && en_US.isNotEmpty) {
    return;
  }
  DefaultAssetBundle.of(context)
      .loadString("assets/language/en_US.json")
      .then((value) {
    en_US = jsonDecode(value);
  });
  DefaultAssetBundle.of(context)
      .loadString("assets/language/tr_TR.json")
      .then((value) {
    tr_TR = jsonDecode(value);
  });
}

String transform(String key) {
  return transformWithArgs(key, null);
}

String transformWithArgs(String key, List<String>? args) {
  String message = key;
  if (language == 'en_US') {
    if (en_US[key] != null) {
      message = en_US[key];
    }
  } else {
    //Default
    if (tr_TR[key] != null) {
      message = tr_TR[key];
    }
  }
  if (args != null && args.isNotEmpty && args[0].isNotEmpty) {
    for (int i = 0; i < args[0].length; i++) {
      RegExp regex = RegExp('[{]' + i.toString() + '[}]');
      String replacer = args[0][i];
      message = message.replaceAll(regex, replacer);
    }
  }
  message = message.replaceAll(RegExp('{[0-9]*}'), '');
  return message;
}
