import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/src/media_type.dart';

import '../models/common-model.dart';
import 'application-properties.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class HClient {
  Map<String, String> getDefaultHeaders() {
    Map<String, String> headers = {"Content-Type": "application/json"};
    return headers;
  }

  Future<Response> get(String path, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    return http.get(url,
        headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<Response> post(String path, String? json,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    return http.post(url,body: json, headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<http.StreamedResponse> downloadFile(
      String path,
      String kurumId,
      String entityType,
      String entityId,
      String fileName,
      String dosyaId,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$path/$kurumId/$entityType/$entityId/$fileName/$dosyaId');
    // return http.post(url, body: json, headers: (headers != null) ? headers : getDefaultHeaders());
    return await http.Client().send(http.Request('GET', url));
  }

  Future<http.StreamedResponse> uploadFile(
      String path,
      String kurumId,
      String? isletmeId,
      String kullaniciId,
      String entityType,
      String? entityId,
      List<PlatformFile> fileList,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    // return http.post(url, body: json, headers: (headers != null) ? headers : getDefaultHeaders());
    MultipartRequest request = http.MultipartRequest("POST", url);
    request.fields["kurumId"] = kurumId;
    if(isletmeId != null) {
      request.fields["isletmeId"] = isletmeId;
    }
    request.fields["kullaniciId"] = kullaniciId;
    request.fields["entityType"] = entityType;
    if(entityId != null) {
      request.fields["entityId"] = entityId;
    }
    for (PlatformFile file in fileList) {
      request.files.add(await http.MultipartFile.fromPath(
        'fileList',
        file.path!,
        contentType: _getMediaTypeFromExtension(file),
      ));
    }
    return request.send();
  }

  Future<Response> requestGrid(String path, RequestGrid requestGrid,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    String jsonRequest = jsonEncode(requestGrid.toJson());
    return http.post(url,
        body: jsonRequest,
        headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<Response> put(String path, String json,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    return http.put(url,
        body: json, headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<Response> delete(String path, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    return http.delete(url,
        headers: (headers != null) ? headers : getDefaultHeaders());
  }

  MediaType _getMediaTypeFromExtension(PlatformFile file) {
    if (file.extension == null) {
      return MediaType("application", "octet-stream");
    }
    if (file.extension == "jpg" ||
        file.extension == "jpeg" ||
        file.extension == "jfif") {
      return MediaType("image", "jpeg");
    }
    if (file.extension == "png") {
      return MediaType("image", "png");
    }
    if (file.extension == "gif") {
      return MediaType("image", "gif");
    }
    if (file.extension == "doc") {
      return MediaType("application", "vnd.msword");
    }
    if (file.extension == "docx") {
      return MediaType("application",
          "vnd.openxmlformats-officedocument.wordprocessingml.document");
    }
    if (file.extension == "xls") {
      return MediaType("application", "vnd.ms-excel");
    }
    if (file.extension == "xlsx") {
      return MediaType("application",
          "vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    }
    if (file.extension == "ppt") {
      return MediaType("application", "vnd.ms-powerpoint");
    }
    if (file.extension == "pptx") {
      return MediaType("application",
          "vnd.openxmlformats-officedocument.presentationml.presentation");
    }
    if (file.extension == "pdf") {
      return MediaType("application", "pdf");
    }
    if (file.extension == "jrxml") {
      return MediaType("application", "jrxml");
    }
    if (file.extension == "xml") {
      return MediaType("application", "xml");
    }
    if (file.extension == "json") {
      return MediaType("application", "json");
    }
    if (file.extension == "txt") {
      return MediaType("text", "plain");
    }
    if (file.extension == "jar") {
      return MediaType("application", "java-archive");
    }
    if (file.extension == "jnlp") {
      return MediaType("application", "x-java-jnlp-file");
    }
    if (file.extension == "zip") {
      return MediaType("application", "zip");
    }
    if (file.extension == "rar") {
      return MediaType("application", "x-rar-compressed");
    }
    if (file.extension == "tar") {
      return MediaType("application", "x-tar");
    }
    if (file.extension == "sql") {
      return MediaType("text", "plain");
    }
    if (file.extension == "7z") {
      return MediaType("application", "x-7z-compressed");
    }
    if (file.extension == "3gp") {
      return MediaType("video", "3gpp");
    }
    if (file.extension == "3g2") {
      return MediaType("video", "3gpp2");
    }
    if (file.extension == "mp4") {
      return MediaType("video", "mp4");
    }
    if (file.extension == "flv") {
      return MediaType("video", "x-flv");
    }
    if (file.extension == "mpeg") {
      return MediaType("video", "mpeg");
    }
    if (file.extension == "xhtml") {
      return MediaType("video", "xhtml+xml");
    }
    if (file.extension == "html") {
      return MediaType("text", "html");
    }
    if (file.extension == "css") {
      return MediaType("text", "css");
    }
    if (file.extension == "js") {
      return MediaType("text", "javascript");
    }
    if (file.extension == "java") {
      return MediaType("text", "x-java-source,java");
    }
    return MediaType("application", "octet-stream");
  }
}
