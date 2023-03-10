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
  await hclient.post(":10080/api/user/login",headers: {
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

Future<User?> loginByTokenRequest(BuildContext context, LoginUserModel loginUserModel) async {
  HClient hClient = HClient();
  return await hClient.post(":10080/api/user/login-by-token",object:  loginUserModel).then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = jsonDecode(hClient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    return User.fromJSON(responseEntity.body);
  });
}

Future<User?> save(BuildContext context, User user) async {
  HClient hClient = HClient();
  return await hClient.post(":10080/api/user/save",object:  user).then((response) async {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = await jsonDecode(hClient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    return User.fromJSON(responseEntity.body);
  });
}

Future<User?> update(BuildContext context, User user) async {
  HClient hClient = HClient();
  return await hClient.post(":10080/api/user/update",object:  user).then((response) async {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = await jsonDecode(hClient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    return User.fromJSON(responseEntity.body);
  });
}

Future<User?> delete(BuildContext context, User user) async {
  HClient hClient = HClient();
  return await hClient.delete(":10080/api/user/update/${user.id}").then((response) async {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = await jsonDecode(hClient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    return User.fromJSON(responseEntity.body);
  });
}

RequestGrid requestGrid(int? page, List<Genre>? genreList, {int pageSize = 20, String? sortField, int? sortOrder}) {
  RequestGrid requestGrid = RequestGrid(
      page: (page ?? 0) * 20,
      pageSize: (((page ?? 0) + 1) * pageSize) - 1,
      sortField: null,
      sortOrder: null,
      propertyList: [
      ],
      filters: [
      ]);
  return requestGrid;
}

Future<TableModel<User>?> gridTable(
    BuildContext context, RequestGrid requestGrid) async {
  HClient hclient = HClient();
  return hclient
      .post(":10080/api/user/grid", object: requestGrid)
      .then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = jsonDecode(hclient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    TableModel tableModel = TableModel.fromJSON(responseEntity.body);
    tableModel.data = (tableModel.data ?? []).map<User>((userMap) => User.fromJSON(userMap)).toList();
    return TableModel.fromJSON(responseEntity.body);
  });
}

Future<List<User>?> grid(
    BuildContext context, RequestGrid requestGrid) async {
  HClient hclient = HClient();
  return hclient
      .post(":10080/api/user/grid", object: requestGrid)
      .then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return null;
    }
    Map<String, dynamic> responseEntityMap = jsonDecode(hclient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return null;
    }
    return responseEntity.body.map<User>((userMap) => User.fromJSON(userMap)).toList();
  });
}