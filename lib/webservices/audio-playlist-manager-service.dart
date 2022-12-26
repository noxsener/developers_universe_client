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
  return "http://85.105.13.152:10007/media/$id";
}

RequestGrid mediaGenreServiceGridRequest(int? page, List<Genre>? genreList, {int pageSize = 20, String? sortField, int? sortOrder}) {
  RequestGrid requestGrid = RequestGrid(
      page: (page ?? 0) * 20,
      pageSize: (((page ?? 0) + 1) * pageSize) - 1,
      sortField: null,
      sortOrder: null,
      propertyList: [
        "id",
        "genre.id",
        "genre.name",
        "media.id",
        "media.artist",
        "media.name",
        "media.mediaImage.id",
        "media.mediaImage.downloadedUrl",
        "media.attributionText",
        "media.attributionLink",
        "media.downloadedUrl",
        "media.mediaDownloadSource.id",
        "media.mediaDownloadSource.siteName",
        "media.mediaDownloadSource.title",
        "media.mediaDownloadSource.url",
        "media.mediaDownloadSource.image.id",
        "media.mediaDownloadSource.image.downloadedUrl"
      ],
      filters: [
        FilterParam("passive", "equal", [false]),
        FilterParam("genre.passive", "equal", [false]),
        FilterParam("media.passive", "equal", [false]),
        FilterParam("media.mimeType", "equal", ["audio/mpeg"]),
        FilterParam("media.status.name", "equal", ["DONE"]),
      ]);
  if (genreList != null && genreList.isNotEmpty) {
    requestGrid.filters!.add(FilterParam(
        "genre.id", "in", genreList.map((e) => e.id).toList(growable: false)));
  }
  return requestGrid;
}

Future<List<MediaGenre>> mediaGenreServiceGridCall(
    BuildContext context, RequestGrid requestGrid) async {
  HClient hclient = HClient();
  return
  hclient.post(":10007/api/media-genre/grid",
      requestGrid)
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
      .post(":10007/api/genre/grid", requestGrid)
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
