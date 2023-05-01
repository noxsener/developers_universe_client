library connectionService;

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/common_model.dart';
import '../services/codenfast_http_client.dart';
import '../services/common_service.dart';

class DownloadIntentWebService {
  Future<DownloadIntent?> save(BuildContext context,
      DownloadIntent downloadIntent) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/download-intent/save",
          object: downloadIntent)
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
        return DownloadIntent.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<DownloadIntent?> update(BuildContext context,
      DownloadIntent downloadIntent) async {
    HClient hclient = HClient();
    return
      hclient.put(":10007/api/download-intent/update",
           downloadIntent)
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
        return DownloadIntent.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<bool?> delete(BuildContext context,
      String downloadIntentId) async {
    HClient hclient = HClient();
    return
      hclient.delete(":10007/api/download-intent/delete/$downloadIntentId")
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
      hclient.post(":10007/api/download-intent/grid-table-model",
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