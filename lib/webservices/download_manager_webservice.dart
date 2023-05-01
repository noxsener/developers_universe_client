library connectionService;

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/common_model.dart';
import '../services/codenfast_http_client.dart';
import '../services/common_service.dart';

class DownloadDownloadWebService {
  Future<Media?> addDownloadQueue(BuildContext context,
      Media media) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/download-manager/add-download-queue",
          object: media)
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
        return Media.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<Media?> generateMediaFromUrl(BuildContext context,
      Media media) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/download-manager/generate-media-from-url",
          object: media)
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
        return Media.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<Media?> downloadMedia(BuildContext context,
      Media media) async {
    HClient hclient = HClient();
    return
      hclient.post(":10007/api/download-manager/download-media",
          object: media)
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
        return Media.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<Media?> cancelMedia(BuildContext context,
      String mediaId) async {
    HClient hclient = HClient();
    return
      hclient.delete(":10007/api/download-manager/id/$mediaId/cancel")
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
        return Media.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<Media?> retryMedia(BuildContext context,
      String mediaId) async {
    HClient hclient = HClient();
    return
      hclient.put(":10007/api/download-manager/id/$mediaId/retry-download-process", null)
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
        return Media.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
      });
  }

  Future<List<Media>> waitingMediaList(
      BuildContext context) async {
    HClient hclient = HClient();
    return
      hclient.get(":10007/api/download-manager")
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
        return responseEntity.body
            .map<Media>((mediaGenreMap) => Media.fromJSON(mediaGenreMap)).toList();
      });
  }
}