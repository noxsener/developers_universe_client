import 'dart:async';
import 'dart:convert';

import 'package:developersuniverse_client/services/common_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:intl/intl.dart';

import '../models/common_model.dart';
import '../page/Modules/UserProfile/user_profile.dart';
import 'application_properties.dart';

String get keyString {
  return '4bc2059c4cf54aca96e4413a93a0fdsq';
}

const String aHeader = "time";
DateFormat dateFormatPlain = DateFormat("ddMMyyyyHHmmss");

class HClient {
  String getIvString(String data) {
    return '${data}0${data.substring(data.length - 2)}';
  }

  String encryptAES(String ivString, String plainText) {
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromUtf8(ivString);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ctr));
    encrypt.Encrypted? encrypted =
        encrypter.encryptBytes(utf8.encode(plainText), iv: iv);
    return base64Encode(encrypted.bytes);
  }

  String decryptAES(String ivString, String plainText) {
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromUtf8(getIvString(ivString));
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ctr));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(plainText), iv: iv);
  }

  Map<String, String> getDefaultHeaders() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      aHeader: DateFormat("ddMMyyyy HHmm").format(now),
      if (UserProfile.token != null)
        "Authorization": "Bearer ${UserProfile.token}"
    };
    return headers;
  }

  Map<String, String> getDefaultHeadersCrypted(String iv,
      {Map<String, String>? headers}) {
    headers ??= {
      "Content-Type": "text/plain",
      if (UserProfile.token != null)
        "Authorization": "Bearer ${UserProfile.token}"
    };
    headers[aHeader] = iv;
    return headers;
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    return http.get(url,
        headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<http.Response> post(String path,
      {JsonConvertable? object, Map<String, String>? headers}) async {
    String data = "01234567890AB"; // dateFormatPlain.format(now.toUtc());
    String iv = getIvString(data);
    String? json;
    if (object != null) {
      json = encryptAES(iv, jsonEncode(object.toJson()));
    }
    headers = getDefaultHeadersCrypted(data, headers: headers);
    Uri url = Uri.parse(baseUrl + path);
    return http.post(url, body: json, headers: headers);
  }

  Future<http.StreamedResponse> downloadFile(String path, String kurumId,
      String entityType, String entityId, String fileName, String dosyaId,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(
        '$baseUrl$path/$kurumId/$entityType/$entityId/$fileName/$dosyaId');
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
    http.MultipartRequest request = http.MultipartRequest("POST", url);
    request.fields["kurumId"] = kurumId;
    if (isletmeId != null) {
      request.fields["isletmeId"] = isletmeId;
    }
    request.fields["kullaniciId"] = kullaniciId;
    request.fields["entityType"] = entityType;
    if (entityId != null) {
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

  Future<http.Response> requestGrid(String path, RequestGrid requestGrid,
      {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + path);
    String jsonRequest = jsonEncode(requestGrid.toJson());
    return http.post(url,
        body: jsonRequest,
        headers: (headers != null) ? headers : getDefaultHeaders());
  }

  Future<http.Response> put(String path, JsonConvertable? object,
      {Map<String, String>? headers}) async {
    String data = "01234567890ABCDEF"; // dateFormatPlain.format(now.toUtc());
    String iv = getIvString(data);
    String? json;
    if (object != null) {
      json = encryptAES(iv, jsonEncode(object.toJson()));
    }
    headers = getDefaultHeadersCrypted(data, headers: headers);
    Uri url = Uri.parse(baseUrl + path);
    return http.put(url, body: json, headers: headers);
  }

  Future<http.Response> delete(String path,
      {Map<String, String>? headers}) async {
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
