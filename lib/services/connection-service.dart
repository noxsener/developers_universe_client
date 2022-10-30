library connectionService;

import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/common-model.dart';
import 'codenfast-http-client.dart';
import 'common-service.dart';

String getCodenfastMediaUrl(String? id) {
  if (id == null || id.isEmpty) {
    return "https://app.codenfast.com:8443/api/rest/server-files/system/image/codenfast.com/012021/logo.webp";
  }
  return "http://app.codenfast.com:10007/media/$id";
}

RequestGrid mediaGenreServiceGridRequest(int? page, List<Genre>? genreList) {
  RequestGrid requestGrid = RequestGrid(page: (page ?? 0 )* 20, pageSize: (((page ?? 0) + 1) * 20) -1, sortField: "id", sortOrder: 1, propertyList: [
    "media.id","media.artist","media.name","media.mediaImage.id","media.attributionText","media.attributionLink","media.mediaDownloadSource.id","media.mediaDownloadSource.siteName","media.mediaDownloadSource.title",
    "media.mediaDownloadSource.url","media.mediaDownloadSource.image.id"
  ], filters: [
    FilterParam("passive", "equal", [false]),
    FilterParam("genre.passive", "equal", [false]),
    FilterParam("media.passive", "equal", [false]),
    FilterParam("media.mimeType", "equal", ["audio/mpeg"]),
    FilterParam("media.status.name", "equal", ["DONE"]),
  ]);
  if(genreList != null && genreList.isNotEmpty) {
    requestGrid.filters!.add(FilterParam("genre.id", "in", genreList.map((e) => e.id).toList(growable: false)));
  }
  return requestGrid;
}


Future<List<MediaGenre>> mediaGenreServiceGridCall(BuildContext context, RequestGrid requestGrid) async {
  return await HClient().post(":10007/media-genre/grid", jsonEncode(requestGrid.toJson())).then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return [];
    }
    return jsonDecode(utf8.decode(response.bodyBytes)).map<MediaGenre>((model) => MediaGenre.fromJSON(model)).toList();
  });
}

RequestGrid genreServiceGridRequest() {
  return RequestGrid(sortField: "name", sortOrder: 1, propertyList: [
    "id","name"
  ], filters: [
    FilterParam("passive", "equal", [false])
  ]);
}

Future<List<Genre>> genreServiceGridCall(BuildContext context, RequestGrid requestGrid) async {
  return await HClient().post(":10007/genre/grid", jsonEncode(requestGrid.toJson())).then((response) {
    if (response.statusCode != 200) {
      errorHandler(context, response);
      return [];
    }
    return jsonDecode(utf8.decode(response.bodyBytes)).map<Genre>((model) => Genre.fromJSON(model)).toList();
  });
}