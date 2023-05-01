library connectionService;

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/common_model.dart';
import '../services/codenfast_http_client.dart';
import '../services/common_service.dart';

class GenreWebService {
  Future<Genre?> save(BuildContext context,
      Genre genre) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/genre/save",
          object: genre)
          .then((response) async {
        if (response.statusCode != 200) {
          errorHandler(context, response);
          return null;
        }
        Map<String, dynamic> responseEntityMap = await jsonDecode(
            hclient.decryptAES(
                response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
        ResponseEntity responseEntity = ResponseEntity.fromJSON(
            responseEntityMap);
        if (responseEntity.body == null) {
          return null;
        }
        return Genre.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<Genre?> update(BuildContext context,
      Genre genre) async {
    HClient hclient = HClient();
    return
      hclient.put(":10007/api/genre/update",
           genre)
          .then((response) async {
        if (response.statusCode != 200) {
          errorHandler(context, response);
          return null;
        }
        Map<String, dynamic> responseEntityMap = await jsonDecode(
            hclient.decryptAES(
                response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
        ResponseEntity responseEntity = ResponseEntity.fromJSON(
            responseEntityMap);
        if (responseEntity.body == null) {
          return null;
        }
        return Genre.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<bool?> delete(BuildContext context,
      String genreId) async {
    HClient hclient = HClient();
    return
      hclient.delete(":10007/api/genre/delete/$genreId")
          .then((response) async {
        if (response.statusCode != 200) {
          errorHandler(context, response);
          return null;
        }
        Map<String, dynamic> responseEntityMap = await jsonDecode(
            hclient.decryptAES(
                response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
        ResponseEntity responseEntity = ResponseEntity.fromJSON(
            responseEntityMap);
        if (responseEntity.body == null) {
          return null;
        }
        return true;
      });
  }

  Future<TableModel<MediaGenre>> mediaGenreServiceGridTableCall(
      BuildContext context, RequestGrid requestGrid) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/genre/grid-table-model",
          object:  requestGrid)
          .then((response) async {
        if (response.statusCode != 200) {
          errorHandler(context, response);
          return TableModel.getDefault();
        }
        Map<String, dynamic> responseEntityMap = await jsonDecode(hclient.decryptAES(response.headers[aHeader]!, utf8.decode(response.bodyBytes)));
        ResponseEntity responseEntity = ResponseEntity.fromJSON(responseEntityMap);
        if(responseEntity.body == null) {
          return TableModel.getDefault();
        }
        TableModel<MediaGenre> tableModel = TableModel.fromJSON(responseEntity.body);
        tableModel.dataGeneric = tableModel.data!.map<MediaGenre>((mediaGenreMap) => MediaGenre.fromJSON(mediaGenreMap)).toList();
        return tableModel;
      });
  }
}