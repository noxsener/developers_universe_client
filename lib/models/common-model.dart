import 'package:http/http.dart';

class TableModel<T> {
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

  toJSON() {
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

class FilterParam {
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

  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyName'] = propertyName;
    data['filterType'] = filterType;
    data['filterValue'] = filterValue;
    return data;
  }
}

class RequestGrid {
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

class ErrorObject {
  DateTime? timestamp;
  int? status;
  String? error;
  String? message;
  String? path;

  ErrorObject({this.timestamp, this.status, this.error, this.message, this.path});

  ErrorObject.fromJSON(Map<String, dynamic> json) {
    if(json['timestamp'] != null) {
      timestamp = DateTime.parse(json['timestamp']);
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

class RequestObject {
  List<dynamic>? data;

  RequestObject({this.data});

  RequestObject.fromJSON(Map<String, dynamic> json) {
    if(json['data'] != null) {
      data = json['data'];
    }
  }

  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    return data;
  }
}

class Media {
  String? artist;
  String? attributionLink;
  String? attributionSourceLink;
  String? attributionText;
  DateTime? createTime;
  String? description;
  DownloadIntent? downloadIntent;
  List<DownloadPart>? downloadPartList;
  String? downloadedUrl;
  String? fileLocation;
  String? fileName;
  int? height;
  String? id;
  List<Media>? imageOfMediaList;
  bool? isPublic;
  MediaDownloadSource? mediaDownloadSource;
  Media? mediaImage;
  int? mediaSize;
  String? mimeType;
  MultipartFile? multipartFile;
  String? name;
  bool? partialDownloadSupport;
  bool? passive;
  int? size;
  DownloadStatus? status;
  DateTime? updateTime;
  int? width;
  String? zipMimeType;

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
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
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
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
    if (json['width'] != null) {
      width = json['width'];
    }
    if (json['zipMimeType'] != null) {
      zipMimeType = json['zipMimeType'];
    }
  }

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
  if (zipMimeType != null) {
    data['zipMimeType'] = zipMimeType;
  }
  return data;
  }

}

class MediaDownloadSource {
  DateTime? createTime;
  String? description;
  String? id;
  Media? image;
  String? name;
  bool? passive;
  String? siteName;
  String? title;
  String? type;
  DateTime? updateTime;
  String? url;

  MediaDownloadSource({this.createTime, this.description, this.id, this.image, this.name, this.passive, this.siteName, this.title, this.type, this.updateTime, this.url, });

  MediaDownloadSource.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
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
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
    if (json['url'] != null) {
      url = json['url'];
    }
  }

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

class MediaFolder {
  DateTime? createTime;
  String? description;
  String? id;
  String? name;
  bool? passive;
  DateTime? updateTime;

  MediaFolder({this.createTime, this.description, this.id, this.name, this.passive, this.updateTime, });

  MediaFolder.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
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
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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

class DownloadIntent {
  DateTime? createTime;
  String? id;
  String? name;
  bool? passive;
  DateTime? updateTime;

  DownloadIntent({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  DownloadIntent.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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
class DownloadPart {
  int? byteRangeEnd;
  int? byteRangeStart;
  DateTime? createTime;
  String? id;
  Media? media;
  String? partFileName;
  int? partNumber;
  bool? passive;
  DownloadStatus? status;
  DateTime? updateTime;

  DownloadPart({this.byteRangeEnd, this.byteRangeStart, this.createTime, this.id, this.media, this.partFileName, this.partNumber, this.passive, this.status, this.updateTime, });

  DownloadPart.fromJSON(Map<String, dynamic> json) {
    if (json['byteRangeEnd'] != null) {
      byteRangeEnd = json['byteRangeEnd'];
    }
    if (json['byteRangeStart'] != null) {
      byteRangeStart = json['byteRangeStart'];
    }
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
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
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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
class DownloadStatus {
  DateTime? createTime;
  String? id;
  String? name;
  bool? passive;
  DateTime? updateTime;

  DownloadStatus({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  DownloadStatus.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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
class Genre {
  DateTime? createTime;
  String? id;
  String? name;
  bool? passive;
  DateTime? updateTime;

  Genre({this.createTime, this.id, this.name, this.passive, this.updateTime, });

  Genre.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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

class MediaGenre {
  DateTime? createTime;
  String? id;
  Media? media;
  Genre? genre;
  bool? passive;
  DateTime? updateTime;

  MediaGenre({this.createTime, this.id, this.media, this.genre, this.passive, this.updateTime, });

  MediaGenre.fromJSON(Map<String, dynamic> json) {
    createTime = json['createTime'] != null ? DateTime.parse(json['createTime']) : null;
    if (json['id'] != null) {
      id = json['id'];
    }
    media = json['media'] != null ? Media.fromJSON(json['media']) : null;
    genre = json['genre'] != null ? Genre.fromJSON(json['genre']) : null;
    if (json['passive'] != null) {
      passive = json['passive'];
    }
    updateTime = json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null;
  }

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

