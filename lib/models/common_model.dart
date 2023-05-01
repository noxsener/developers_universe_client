import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import '../services/common_service.dart';
part 'common_model.g.dart';
// flutter packages pub run build_runner build


void registerHiveAdapters() {
  // in common_model.g.dart, use regex "[ ][a-zA-Z0-9]*Adapter "
  Hive.registerAdapter(MediaAdapter());
  Hive.registerAdapter(MediaDownloadSourceAdapter());
  Hive.registerAdapter(MediaFolderAdapter());
  Hive.registerAdapter(DownloadIntentAdapter());
  Hive.registerAdapter(DownloadPartAdapter());
  Hive.registerAdapter(DownloadStatusAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(MediaGenreAdapter());
}

class JsonConvertable { // interface
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class TableModel<T> implements JsonConvertable {
  List<dynamic>? data = [];
  List<T> dataGeneric = [];

  int? count = 0;
  bool? loading = false;

  TableModel({this.data, this.count, this.loading});

  TableModel.getDefault() {
    data = [];
    count = 0;
    loading = false;
  }

  TableModel.fromJSON(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = json['data'];
    }
    if (json['count'] != null) {
      count = json['count'];
    }
    if (json['loading'] != null) {
      loading = json['loading'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    if (count != null) {
      data['count'] = count;
    }
    if (loading != null) {
      data['loading'] = loading;
    }
    return data;
  }
}

class FilterParam implements JsonConvertable {
  late String propertyName;
  late String filterType;
  late List<dynamic> filterValue;

  FilterParam(this.propertyName, this.filterType, this.filterValue);

  FilterParam.fromJSON(Map<String, dynamic> json) {
    if(json['propertyName'] != null) {
      propertyName = json['propertyName'];
    }
    if(json['filterType'] != null) {
      filterType = json['filterType'];
    }
    if(json['filterValue'] != null) {
      filterValue = json['filterValue'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyName'] = propertyName;
    data['filterType'] = filterType;
    data['filterValue'] = filterValue;
    return data;
  }
}

class RequestGrid implements JsonConvertable {
  List<String>? propertyList;
  List<FilterParam>? filters;
  int? page;
  int? pageSize;
  String? sortField;
  int? sortOrder;


  RequestGrid({this.propertyList, this.filters, this.page, this.pageSize, this.sortField, this.sortOrder});

  RequestGrid.getDefault() {
    propertyList = null;
    filters = null;
    page = 0;
    pageSize = 10;
    sortField = null;
    sortOrder = null;
  }

  RequestGrid.fromJSON(Map<String, dynamic> json) {
    if(json['propertyList'] != null) {
      propertyList = json['propertyList'];
    }
    if(json['filters'] != null) {
      filters = json['filters'];
    }
    if(json['page'] != null) {
      page = json['page'];
    }
    if(json['pageSize'] != null) {
      pageSize = json['pageSize'];
    }
    if(json['sortField'] != null) {
      sortField = json['sortField'];
    }
    if(json['sortOrder'] != null) {
      sortOrder = json['sortOrder'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(propertyList != null) {
      data['propertyList'] = propertyList;
    }
    if(filters != null) {
      data['filters'] = filters;
    }
    if(page != null) {
      data['page'] = page;
    }
    if(pageSize != null) {
      data['pageSize'] = pageSize;
    }
    if(sortField != null) {
      data['sortField'] = sortField;
    }
    if(sortOrder != null) {
      data['sortOrder'] = sortOrder;
    }
    return data;
  }
}

class ResponseEntity<T> {
  String? status;
  T? body;
  HttpHeaders? headers;

  ResponseEntity.fromJSON(Map<String, dynamic> json) {
    if(json['body'] != null) {
      body = json['body'];
    }
    if(json['status'] != null) {
      status = json['status'];
    }
    if(json['headers'] != null) {
      headers = HttpHeaders.fromJSON(json['headers']);
    }
  }
}

class HttpHeaders<K,V> {
  Map<K, List<V>>? headers;

  HttpHeaders.fromJSON(Map<String, dynamic> json) {
    if(json['headers'] != null) {
      headers = json['headers'];
    }
  }
}

class ErrorObject implements JsonConvertable {
  DateTime? timestamp;
  int? status;
  String? error;
  String? message;
  String? path;

  ErrorObject({this.timestamp, this.status, this.error, this.message, this.path});

  ErrorObject.fromJSON(Map<String, dynamic> json) {
    if(json['timestamp'] != null) {
      timestamp = parseLocalDateTime(json['timestamp']);
    }
    if(json['status'] != null) {
      status = json['status'];
    }
    if(json['error'] != null) {
      error = json['error'];
    }
    if(json['message'] != null) {
      message = json['message'];
    }
    if(json['path'] != null) {
      path = json['path'];
    }
  }

  @override
  toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if(timestamp != null) {
      data['timestamp'] = timestamp;
    }
    if(status != null) {
      data['status'] = status;
    }
    if(error != null) {
      data['error'] = error;
    }
    if(message != null) {
      data['message'] = message;
    }
    if(path != null) {
      data['path'] = path;
    }
    return data;
  }
}

class User implements JsonConvertable {
  String? id;
  bool? passive;
  DateTime? createTime;
  DateTime? updateTime;

  String? username;
  String? name;
  String? surname;
  String? bio;
  String? language;
  DateTime? birthDate;
  String? email;
  DateTime? lastTokenTime;
  List<UserAuthorization>? userAuthorizationList;
  List<UserRole>? userRoleList;


  User({
      this.id,
      this.passive,
      this.createTime,
      this.updateTime,
      this.username,
      this.name,
      this.surname,
      this.bio,
      this.language,
      this.birthDate,
      this.email,
      this.lastTokenTime,
      this.userAuthorizationList,
      this.userRoleList});

  User.fromJSON(Map<String, dynamic> json) {
    if(json['id'] != null) {
      id = json['id'];
    }
    if(json['passive'] != null) {
      passive = json['passive'];
    }
    if(json['createTime'] != null) {

      createTime = DateTime(json['createTime'][0],json['createTime'][1],json['createTime'][2],json['createTime'][3],json['createTime'][4],json['createTime'][5],json['createTime'][6]);
    }
    if(json['updateTime'] != null) {
      updateTime = DateTime(json['updateTime'][0],json['updateTime'][1],json['updateTime'][2],json['updateTime'][3],json['updateTime'][4],json['updateTime'][5],json['updateTime'][6]);
    }
    if(json['username'] != null) {
      username = json['username'];
    }
    if(json['name'] != null) {
      name = json['name'];
    }
    if(json['surname'] != null) {
      surname = json['surname'];
    }
    if(json['bio'] != null) {
      bio = json['bio'];
    }
    if(json['language'] != null) {
      language = json['language'];
    }
    if(json['birthDate'] != null) {
      birthDate = DateTime(json['birthDate'][0],json['birthDate'][1],json['birthDate'][2],json['birthDate'][3],json['birthDate'][4],json['birthDate'][5],json['birthDate'][6]);
    }
    if(json['email'] != null) {
      email = json['email'];
    }
    if(json['lastTokenTime'] != null) {
      lastTokenTime = parseLocalDateTime(json['lastTokenTime']);
    }
    if(json['lastTokenTime'] != null) {
      userAuthorizationList =
      json['lastTokenTime'] != null ? json['lastTokenTime'].map<
          DownloadPart>((i) => UserAuthorization.fromJSON(i)).toList() : [];
    }
    if(json['userRoleList'] != null) {
      userRoleList =
      json['userRoleList'] != null ? json['userRoleList'].map<
          DownloadPart>((i) => UserRole.fromJSON(i)).toList() : [];
    }
  }


  @override
  toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id != null) {
      data['id'] = id;
    }
    if(passive != null) {
      data['passive'] = passive;
    }
    if(createTime != null) {
      data['createTime'] = createTime!.toIso8601String();
    }
    if(updateTime != null) {
      data['updateTime'] = updateTime!.toIso8601String();
    }
    if(username != null) {
      data['username'] = username;
    }
    if(name != null) {
      data['name'] = name;
    }
    if(surname != null) {
      data['surname'] = surname;
    }
    if(bio != null) {
      data['bio'] = bio;
    }
    if(language != null) {
      data['language'] = language;
    }
    if(birthDate != null) {
      data['birthDate'] = birthDate!.toIso8601String();
    }
    if(email != null) {
      data['email'] = email;
    }
    if(lastTokenTime != null) {
      data['lastTokenTime'] = lastTokenTime!.toIso8601String();
    }
    if(userAuthorizationList != null) {
      data['userAuthorizationList'] = userAuthorizationList;
    }
    if(userRoleList != null) {
      data['userRoleList'] = userRoleList;
    }
    return data;
  }
}

class LoginUserModel implements JsonConvertable {
  String? pass;
  String? refreshToken;
  String? username;

  LoginUserModel({this.pass, this.refreshToken, this.username, });

  LoginUserModel.fromJSON(Map<String, dynamic> json) {
    if (json['pass'] != null) {
      pass = json['pass'];
    }
    if (json['refreshToken'] != null) {
      refreshToken = json['refreshToken'];
    }
    if (json['username'] != null) {
      username = json['username'];
    }
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (pass != null) {
    data['pass'] = pass;
  }
  if (refreshToken != null) {
    data['refreshToken'] = refreshToken;
  }
  if (username != null) {
    data['username'] = username;
  }
  return data;
  }

}


class UserRole implements JsonConvertable {
  DateTime? createTime;
  String? id;
  String? name;
  bool? passive;
  List<Role>? roleList;
  DateTime? updateTime;
  User? user;

  UserRole({this.createTime, this.id, this.name, this.passive, this.roleList, this.updateTime, this.user, });

  UserRole.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    roleList = json['roleList'] != null ? json['roleList'].map<Role>((i) => Role.fromJSON(i)).toList() : [];
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    user = json['user'] != null ? User.fromJSON(json['user']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (roleList != null) {
    data['roleList'] = roleList;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  if (user != null) {
    data['user'] = user;
  }
  return data;
  }

}


class UserAuthorization implements JsonConvertable {
  Authorization? authorization;
  DateTime? createTime;
  String? grant;
  String? id;
  bool? passive;
  DateTime? updateTime;
  User? user;

  UserAuthorization({this.authorization, this.createTime, this.grant, this.id, this.passive, this.updateTime, this.user, });

  UserAuthorization.fromJSON(Map<String, dynamic> json) {
    authorization = json['authorization'] != null ? Authorization.fromJSON(json['authorization']) : null;
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['grant'] != null) {
      grant = json['grant'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    user = json['user'] != null ? User.fromJSON(json['user']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (authorization != null) {
    data['authorization'] = authorization;
  }
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (grant != null) {
    data['grant'] = grant;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  if (user != null) {
    data['user'] = user;
  }
  return data;
  }

}


class Authorization implements JsonConvertable {
  DateTime? createTime;
  bool? grant;
  String? id;
  String? name;
  bool? passive;
  List<RoleAuthorization>? roleAuthorizationList;
  DateTime? updateTime;
  List<UserAuthorization>? userAuthorizationList;

  Authorization({this.createTime, this.grant, this.id, this.name, this.passive, this.roleAuthorizationList, this.updateTime, this.userAuthorizationList, });

  Authorization.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['grant'] != null) {
      grant = json['grant'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    roleAuthorizationList = json['roleAuthorizationList'] != null ? json['roleAuthorizationList'].map<RoleAuthorization>((i) => RoleAuthorization.fromJSON(i)).toList() : [];
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    userAuthorizationList = json['userAuthorizationList'] != null ? json['userAuthorizationList'].map<UserAuthorization>((i) => UserAuthorization.fromJSON(i)).toList() : [];
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (grant != null) {
    data['grant'] = grant;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (roleAuthorizationList != null) {
    data['roleAuthorizationList'] = roleAuthorizationList;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  if (userAuthorizationList != null) {
    data['userAuthorizationList'] = userAuthorizationList;
  }
  return data;
  }

}

class RoleAuthorization implements JsonConvertable {
  Authorization? authorization;
  DateTime? createTime;
  String? grant;
  String? id;
  bool? passive;
  Role? role;
  DateTime? updateTime;

  RoleAuthorization({this.authorization, this.createTime, this.grant, this.id, this.passive, this.role, this.updateTime, });

  RoleAuthorization.fromJSON(Map<String, dynamic> json) {
    authorization = json['authorization'] != null ? Authorization.fromJSON(json['authorization']) : null;
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['grant'] != null) {
      grant = json['grant'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    role = json['role'] != null ? Role.fromJSON(json['role']) : null;
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (authorization != null) {
    data['authorization'] = authorization;
  }
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (grant != null) {
    data['grant'] = grant;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (role != null) {
    data['role'] = role;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  return data;
  }

}

class Role implements JsonConvertable {
  DateTime? createTime;
  String? id;
  String? name;
  bool? passive;
  List<RoleAuthorization>? roleAuthorizationList;
  DateTime? updateTime;

  Role({this.createTime, this.id, this.name, this.passive, this.roleAuthorizationList, this.updateTime, });

  Role.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    roleAuthorizationList = json['roleAuthorizationList'] != null ? json['roleAuthorizationList'].map<RoleAuthorization>((i) => RoleAuthorization.fromJSON(i)).toList() : [];
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (roleAuthorizationList != null) {
    data['roleAuthorizationList'] = roleAuthorizationList;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  return data;
  }

}


class RequestObject implements JsonConvertable {
  List<dynamic>? data;

  RequestObject({this.data});

  RequestObject.fromJSON(Map<String, dynamic> json) {
    if(json['data'] != null) {
      data = json['data'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    return data;
  }
}

class CodenfastMenu {
  String title;
  String? description;
  String? image;
  Widget? icon;
  Function? onClick;
  bool? visible;
  List<CodenfastMenu>? items;

  CodenfastMenu({required this.title, this.description, this.image, this.onClick, this.items, this.visible, this.icon});

  Hero getHero() {

    return Hero(
      tag: title,
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.easeInOut,
                    fadeInDuration: const Duration(milliseconds: 200),
                    imageUrl: image!,
                    height: 360.0,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            color: theme.cyanTransparent,
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ))),
          Expanded(
            flex: 8,
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: theme.cyanTransparent[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: icon!,
                          ),
                        Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme().titleSmall,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: Colors.red,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  FontAwesomeIcons.exclamation,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Text(
                          description ?? "",style: theme.textTheme().bodySmall,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

@HiveType(typeId: 0)
class Media extends HiveObject implements JsonConvertable {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  String? attributionLink;
  @HiveField(3)
  String? attributionSourceLink;
  @HiveField(4)
  String? attributionText;
  @HiveField(5)
  DateTime? createTime;
  @HiveField(6)
  String? description;
  @HiveField(7)
  DownloadIntent? downloadIntent;
  @HiveField(8)
  List<DownloadPart>? downloadPartList;
  @HiveField(9)
  String? downloadedUrl;
  @HiveField(10)
  String? fileLocation;
  @HiveField(11)
  String? fileName;
  @HiveField(12)
  int? height;
  @HiveField(13)
  List<Media>? imageOfMediaList;
  @HiveField(14)
  bool? isPublic;
  @HiveField(15)
  MediaDownloadSource? mediaDownloadSource;
  @HiveField(16)
  Media? mediaImage;
  @HiveField(17)
  int? mediaSize;
  @HiveField(18)
  String? mimeType;
  @HiveField(19)
  MultipartFile? multipartFile;
  @HiveField(20)
  String? name;
  @HiveField(21)
  bool? partialDownloadSupport;
  @HiveField(22)
  bool? passive;
  @HiveField(23)
  int? size;
  @HiveField(24)
  DownloadStatus? status;
  @HiveField(25)
  DateTime? updateTime;
  @HiveField(26)
  int? width;
  @HiveField(27)
  String? zipMimeType;
  @HiveField(28)
  int? lengthInSeconds;

  Media({this.artist, this.attributionLink, this.attributionSourceLink, this.attributionText, this.createTime, this.description, this.downloadIntent, this.downloadPartList, this.downloadedUrl, this.fileLocation, this.fileName, this.height, this.id, this.imageOfMediaList, this.isPublic, this.mediaDownloadSource, this.mediaImage, this.mediaSize, this.mimeType, this.multipartFile, this.name, this.partialDownloadSupport, this.passive, this.size, this.status, this.updateTime, this.width, this.zipMimeType, });

  Media.fromJSON(Map<String, dynamic> json) {
    if (json['artist'] != null) {
      artist = json['artist'];
    }
    if (json['attributionLink'] != null) {
      attributionLink = json['attributionLink'];
    }
    if (json['attributionSourceLink'] != null) {
      attributionSourceLink = json['attributionSourceLink'];
    }
    if (json['attributionText'] != null) {
      attributionText = json['attributionText'];
    }
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['description'] != null) {
      description = json['description'];
    }
    downloadIntent = json['downloadIntent'] != null ? DownloadIntent.fromJSON(json['downloadIntent']) : null;
    downloadPartList = json['downloadPartList'] != null ? json['downloadPartList'].map<DownloadPart>((i) => DownloadPart.fromJSON(i)).toList() : [];
    if (json['downloadedUrl'] != null) {
      downloadedUrl = json['downloadedUrl'];
    }
    if (json['fileLocation'] != null) {
      fileLocation = json['fileLocation'];
    }
    if (json['fileName'] != null) {
      fileName = json['fileName'];
    }
    if (json['height'] != null) {
      height = json['height'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    imageOfMediaList = json['imageOfMediaList'] != null ? json['imageOfMediaList'].map<Media>((i) => Media.fromJSON(i)).toList() : [];
    if (json['isPublic'] != null) {
      isPublic = json['isPublic'];
    }
    mediaDownloadSource = json['mediaDownloadSource'] != null ? MediaDownloadSource.fromJSON(json['mediaDownloadSource']) : null;
    mediaImage = json['mediaImage'] != null ? Media.fromJSON(json['mediaImage']) : null;
    if (json['mediaSize'] != null) {
      mediaSize = json['mediaSize'];
    }
    if (json['mimeType'] != null) {
      mimeType = json['mimeType'];
    }
    // multipartFile = json['multipartFile'] != null ? MultipartFile.fromJSON(json['multipartFile']) : null;
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['partialDownloadSupport'] != null) {
      partialDownloadSupport = json['partialDownloadSupport'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    if (json['size'] != null) {
      size = json['size'];
    }
    status = json['status'] != null ? DownloadStatus.fromJSON(json['status']) : null;
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    if (json['width'] != null) {
      width = json['width'];
    }
    if (json['lengthInSeconds'] != null) {
      lengthInSeconds = json['lengthInSeconds'];
    }
    if (json['zipMimeType'] != null) {
      zipMimeType = json['zipMimeType'];
    }
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (artist != null) {
    data['artist'] = artist;
  }
  if (attributionLink != null) {
    data['attributionLink'] = attributionLink;
  }
  if (attributionSourceLink != null) {
    data['attributionSourceLink'] = attributionSourceLink;
  }
  if (attributionText != null) {
    data['attributionText'] = attributionText;
  }
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (description != null) {
    data['description'] = description;
  }
  if (downloadIntent != null) {
    data['downloadIntent'] = downloadIntent;
  }
  if (downloadPartList != null) {
    data['downloadPartList'] = downloadPartList;
  }
  if (downloadedUrl != null) {
    data['downloadedUrl'] = downloadedUrl;
  }
  if (fileLocation != null) {
    data['fileLocation'] = fileLocation;
  }
  if (fileName != null) {
    data['fileName'] = fileName;
  }
  if (height != null) {
    data['height'] = height;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (imageOfMediaList != null) {
    data['imageOfMediaList'] = imageOfMediaList;
  }
  if (isPublic != null) {
    data['isPublic'] = isPublic;
  }
  if (mediaDownloadSource != null) {
    data['mediaDownloadSource'] = mediaDownloadSource;
  }
  if (mediaImage != null) {
    data['mediaImage'] = mediaImage;
  }
  if (mediaSize != null) {
    data['mediaSize'] = mediaSize;
  }
  if (mimeType != null) {
    data['mimeType'] = mimeType;
  }
  if (multipartFile != null) {
    data['multipartFile'] = multipartFile;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (partialDownloadSupport != null) {
    data['partialDownloadSupport'] = partialDownloadSupport;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (size != null) {
    data['size'] = size;
  }
  if (status != null) {
    data['status'] = status;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  if (width != null) {
    data['width'] = width;
  }
  if (lengthInSeconds != null) {
    data['lengthInSeconds'] = lengthInSeconds;
  }
  if (zipMimeType != null) {
    data['zipMimeType'] = zipMimeType;
  }
  return data;
  }

}

@HiveType(typeId: 1)
class MediaDownloadSource extends HiveObject implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? id;
  @HiveField(3)
  Media? image;
  @HiveField(4)
  String? name;
  @HiveField(5)
  bool? passive;
  @HiveField(6)
  String? siteName;
  @HiveField(7)
  String? title;
  @HiveField(8)
  String? type;
  @HiveField(9)
  DateTime? updateTime;
  @HiveField(10)
  String? url;

  MediaDownloadSource({this.createTime, this.description, this.id, this.image, this.name, this.passive, this.siteName, this.title, this.type, this.updateTime, this.url, });

  MediaDownloadSource.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['description'] != null) {
      description = json['description'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['image'] != null) {
      image = Media.fromJSON(json['image']);
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    if (json['siteName'] != null) {
      siteName = json['siteName'];
    }
    if (json['title'] != null) {
      title = json['title'];
    }
    if (json['type'] != null) {
      type = json['type'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    if (json['url'] != null) {
      url = json['url'];
    }
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (description != null) {
    data['description'] = description;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (image != null) {
    data['image'] = image;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (siteName != null) {
    data['siteName'] = siteName;
  }
  if (title != null) {
    data['title'] = title;
  }
  if (type != null) {
    data['type'] = type;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  if (url != null) {
    data['url'] = url;
  }
  return data;
  }

}

@HiveType(typeId: 2)
class MediaFolder extends HiveObject implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? name;
  @HiveField(4)
  bool? passive;
  @HiveField(5)
  DateTime? updateTime;

  MediaFolder({this.createTime, this.description, this.id, this.name, this.passive, this.updateTime, });

  MediaFolder.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['description'] != null) {
      description = json['description'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (description != null) {
    data['description'] = description;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  return data;
  }

}

@HiveType(typeId: 3)
class DownloadIntent extends HiveObject implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  bool? passive;
  @HiveField(4)
  DateTime? updateTime;

  DownloadIntent({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  DownloadIntent.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  return data;
  }

}

@HiveType(typeId: 4)
class DownloadPart implements JsonConvertable {
  @HiveField(0)
  int? byteRangeEnd;
  @HiveField(1)
  int? byteRangeStart;
  @HiveField(2)
  DateTime? createTime;
  @HiveField(3)
  String? id;
  @HiveField(4)
  Media? media;
  @HiveField(5)
  String? partFileName;
  @HiveField(6)
  int? partNumber;
  @HiveField(7)
  bool? passive;
  @HiveField(8)
  DownloadStatus? status;
  @HiveField(9)
  DateTime? updateTime;

  DownloadPart({this.byteRangeEnd, this.byteRangeStart, this.createTime, this.id, this.media, this.partFileName, this.partNumber, this.passive, this.status, this.updateTime, });

  DownloadPart.fromJSON(Map<String, dynamic> json) {
    if (json['byteRangeEnd'] != null) {
      byteRangeEnd = json['byteRangeEnd'];
    }
    if (json['byteRangeStart'] != null) {
      byteRangeStart = json['byteRangeStart'];
    }
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    media = json['media'] != null ? Media.fromJSON(json['media']) : null;
    if (json['partFileName'] != null) {
      partFileName = json['partFileName'];
    }
    if (json['partNumber'] != null) {
      partNumber = json['partNumber'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    status = json['status'] != null ? DownloadStatus.fromJSON(json['status']) : null;
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (byteRangeEnd != null) {
    data['byteRangeEnd'] = byteRangeEnd;
  }
  if (byteRangeStart != null) {
    data['byteRangeStart'] = byteRangeStart;
  }
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (id != null) {
    data['id'] = id;
  }
  if (media != null) {
    data['media'] = media;
  }
  if (partFileName != null) {
    data['partFileName'] = partFileName;
  }
  if (partNumber != null) {
    data['partNumber'] = partNumber;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (status != null) {
    data['status'] = status;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  return data;
  }

}

@HiveType(typeId: 5)
class DownloadStatus implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  bool? passive;
  @HiveField(4)
  DateTime? updateTime;

  DownloadStatus({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  DownloadStatus.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String();
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String();
  }
  return data;
  }

}

@HiveType(typeId: 6)
class Genre implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  bool? passive;
  @HiveField(4)
  DateTime? updateTime;

  Genre({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  Genre.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (name != null) {
    data['name'] = name;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  return data;
  }

}

@HiveType(typeId: 7)
class MediaGenre extends HiveObject implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? id;
  @HiveField(2)
  Media? media;
  @HiveField(3)
  Genre? genre;
  @HiveField(4)
  bool? passive;
  @HiveField(5)
  DateTime? updateTime;

  MediaGenre({this.createTime, this.id, this.media, this.genre, this.passive, this.updateTime, });

  MediaGenre.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    media = json['media'] != null ? Media.fromJSON(json['media']) : null;
    genre = json['genre'] != null ? Genre.fromJSON(json['genre']) : null;
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {final Map<String, dynamic> data = <String, dynamic>{};
  if (createTime != null) {
    data['createTime'] = createTime!.toIso8601String;
  }
  if (id != null) {
    data['id'] = id;
  }
  if (media != null) {
    data['media'] = media;
  }
  if (genre != null) {
    data['genre'] = genre;
  }
  if (passive != null) {
    data['passive'] = passive;
  }
  if (updateTime != null) {
    data['updateTime'] = updateTime!.toIso8601String;
  }
  return data;
  }

}

@HiveType(typeId: 8)
class ElectronicArchive implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? description;
  @HiveField(2)
  ElectronicArchive? electronicArchiveFolder;
  @HiveField(3)
  List<ElectronicArchive>? electronicArchiveList;
  @HiveField(4)
  String? fileBase64;
  @HiveField(5)
  String? fileLocation;
  @HiveField(6)
  String? fileName;
  @HiveField(7)
  int? height;
  @HiveField(8)
  String? id;
  @HiveField(9)
  bool? isFolder;
  @HiveField(10)
  String? mimeType;
  @HiveField(11)
  String? name;
  @HiveField(12)
  bool? passive;
  @HiveField(13)
  int? size;
  @HiveField(14)
  DateTime? updateTime;
  @HiveField(15)
  int? width;
  @HiveField(16)
  String? zipMimeType;

  ElectronicArchive({this.createTime, this.description, this.electronicArchiveFolder, this.electronicArchiveList, this.fileBase64, this.fileLocation, this.fileName, this.height, this.id, this.isFolder, this.mimeType, this.name, this.passive, this.size, this.updateTime, this.width, this.zipMimeType, });

  ElectronicArchive.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['description'] != null) {
      description = json['description'];
    }
    electronicArchiveFolder = json['electronicArchiveFolder'] != null ? ElectronicArchive.fromJSON(json['electronicArchiveFolder']) : null;
    electronicArchiveList = json['electronicArchiveList'] != null ? json['electronicArchiveList'].map<ElectronicArchive>((i) => ElectronicArchive.fromJSON(i)).toList() : [];
    if (json['fileBase64'] != null) {
      fileBase64 = json['fileBase64'];
    }
    if (json['fileLocation'] != null) {
      fileLocation = json['fileLocation'];
    }
    if (json['fileName'] != null) {
      fileName = json['fileName'];
    }
    if (json['height'] != null) {
      height = json['height'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['isFolder'] != null) {
      isFolder = json['isFolder'];
    }
    if (json['mimeType'] != null) {
      mimeType = json['mimeType'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    if (json['size'] != null) {
      size = json['size'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    if (json['width'] != null) {
      width = json['width'];
    }
    if (json['zipMimeType'] != null) {
      zipMimeType = json['zipMimeType'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (createTime != null) {
      data['createTime'] = createTime!.toIso8601String;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (electronicArchiveFolder != null) {
      data['electronicArchiveFolder'] = electronicArchiveFolder;
    }
    if (electronicArchiveList != null) {
      data['electronicArchiveList'] = electronicArchiveList;
    }
    if (fileBase64 != null) {
      data['fileBase64'] = fileBase64;
    }
    if (fileLocation != null) {
      data['fileLocation'] = fileLocation;
    }
    if (fileName != null) {
      data['fileName'] = fileName;
    }
    if (height != null) {
      data['height'] = height;
    }
    if (id != null) {
      data['id'] = id;
    }
    if (isFolder != null) {
      data['isFolder'] = isFolder;
    }
    if (mimeType != null) {
      data['mimeType'] = mimeType;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (passive != null) {
      data['passive'] = passive;
    }
    if (size != null) {
      data['size'] = size;
    }
    if (updateTime != null) {
      data['updateTime'] = updateTime!.toIso8601String;
    }
    if (width != null) {
      data['width'] = width;
    }
    if (zipMimeType != null) {
      data['zipMimeType'] = zipMimeType;
    }
    return data;
  }

}


@HiveType(typeId: 9)
class ElectronicArchiveProperty implements JsonConvertable {
  @HiveField(0)
  DateTime? createTime;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? name;
  @HiveField(4)
  bool? passive;
  @HiveField(5)
  DateTime? updateTime;
  @HiveField(6)
  String? valueType;

  ElectronicArchiveProperty({this.createTime, this.description, this.id, this.name, this.passive, this.updateTime, this.valueType, });

  ElectronicArchiveProperty.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['description'] != null) {
      description = json['description'];
    }
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    if (json['valueType'] != null) {
      valueType = json['valueType'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (createTime != null) {
      data['createTime'] = createTime!.toIso8601String;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (id != null) {
      data['id'] = id;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (passive != null) {
      data['passive'] = passive;
    }
    if (updateTime != null) {
      data['updateTime'] = updateTime!.toIso8601String;
    }
    if (valueType != null) {
      data['valueType'] = valueType;
    }
    return data;
  }

}

@HiveType(typeId: 10)
class ElectronicArchivePropertyValue implements JsonConvertable {
  @HiveField(0)
  bool? booleanValue;
  @HiveField(1)
  DateTime? createTime;
  @HiveField(2)
  DateTime? dateValue;
  @HiveField(3)
  ElectronicArchiveProperty? electronicArchiveProperty;
  @HiveField(4)
  String? id;
  @HiveField(5)
  double? numberValue;
  @HiveField(6)
  bool? passive;
  @HiveField(7)
  String? stringValue;
  @HiveField(8)
  DateTime? updateTime;

  ElectronicArchivePropertyValue({this.booleanValue, this.createTime, this.dateValue, this.electronicArchiveProperty, this.id, this.numberValue, this.passive, this.stringValue, this.updateTime, });

  ElectronicArchivePropertyValue.fromJSON(Map<String, dynamic> json) {
    if (json['booleanValue'] != null) {
      booleanValue = json['booleanValue'];
    }
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    dateValue = json['dateValue'] != null ? parseLocalDateTime(json['dateValue']) : null;
    electronicArchiveProperty = json['electronicArchiveProperty'] != null ? ElectronicArchiveProperty.fromJSON(json['electronicArchiveProperty']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['numberValue'] != null) {
      numberValue = json['numberValue'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    if (json['stringValue'] != null) {
      stringValue = json['stringValue'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (booleanValue != null) {
      data['booleanValue'] = booleanValue;
    }
    if (createTime != null) {
      data['createTime'] = createTime!.toIso8601String;
    }
    if (dateValue != null) {
      data['dateValue'] = dateValue!.toIso8601String;
    }
    if (electronicArchiveProperty != null) {
      data['electronicArchiveProperty'] = electronicArchiveProperty;
    }
    if (id != null) {
      data['id'] = id;
    }
    if (numberValue != null) {
      data['numberValue'] = numberValue;
    }
    if (passive != null) {
      data['passive'] = passive;
    }
    if (stringValue != null) {
      data['stringValue'] = stringValue;
    }
    if (updateTime != null) {
      data['updateTime'] = updateTime!.toIso8601String;
    }
    return data;
  }

}


@HiveType(typeId: 11)
class OfflineDbInfo implements JsonConvertable {
  @HiveField(0)
  String? id;
  @HiveField(1)
  bool? passive;
  @HiveField(2)
  DateTime? createTime;
  @HiveField(3)
  DateTime? updateTime;
  @HiveField(4)
  String? name;


  OfflineDbInfo({this.id, this.passive, this.createTime, this.updateTime,
      this.name});

  OfflineDbInfo.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? parseLocalDateTime(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? parseLocalDateTime(json['updateTime']) : null;
    if (json['name'] != null) {
      name = json['name'];
    }
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (createTime != null) {
      data['createTime'] = createTime!.toIso8601String;
    }
    if (id != null) {
      data['id'] = id;
    }
    if (passive != null) {
      data['passive'] = passive;
    }
    if (updateTime != null) {
      data['updateTime'] = updateTime!.toIso8601String;
    }
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }

}



