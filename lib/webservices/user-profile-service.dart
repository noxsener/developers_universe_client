library connectionService;

import 'dart:convert';


import 'package:flutter/material.dart';

import '../models/common-model.dart';
import '../services/codenfast-http-client.dart';
import '../services/common-service.dart';

Future<String?> loginCall(BuildContext context, String username, String password) async {
  String headerString = "$username:$password";
  String authorizationHeaderValue = base64Encode(utf8.encoder.convert(headerString));
  HClient hclient = HClient();
  return
  hclient.post(":10080/user/login",headers: {
    "Authorization": "Basic $authorizationHeaderValue"
  })
      .then((response) async {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    return utf8.decode(response.bodyBytes);
  });
}

