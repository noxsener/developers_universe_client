library connectionService;

import 'dart:convert';


import 'package:flutter/material.dart';

import '../models/common-model.dart';
import '../services/codenfast-http-client.dart';
import '../services/common-service.dart';



String getCodenfastMediaUrl(String? id) {
  if (id == null || id.isEmpty) {
    return "https://app.codenfast.com:8443/api/rest/server-files/system/image/codenfast.com/012021/logo.webp";
  }
  return "http://192.168.1.254:10007/media/$id";
}

Future<List<MediaGenre>> mediaGenreServiceGridCall(
    BuildContext context, RequestGrid requestGrid) async {
  HClient hclient = HClient();
  return
  hclient.post(":10007/api/media-genre/grid",
      object:  requestGrid)
      .then((response) async {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return [];
    }
    Map<String, dynamic> responseEntityMap = await jsonDecode(hclient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return [];
    }
    return await responseEntity.body.map<MediaGenre>((mediaGenreMap) => MediaGenre.fromJSON(mediaGenreMap)).toList();
  });
}

RequestGrid genreServiceGridRequest() {
  return RequestGrid(sortField: "name", sortOrder: 1, propertyList: [
    "id",
    "name"
  ], filters: [
    FilterParam("passive", "equal", [false])
  ]);
}

Future<List<Genre>> genreServiceGridCall(
    BuildContext context, RequestGrid requestGrid) async {
  HClient hclient = HClient();
  return hclient
      .post(":10007/api/genre/grid", object: requestGrid)
      .then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return [];
    }
    Map<String, dynamic> responseEntityMap = jsonDecode(hclient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
    ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
    if(responseEntity.body == null) {
      return [];
    }
    return responseEntity.body.map<Genre>((genreMap) => Genre.fromJSON(genreMap)).toList();
  });
}
