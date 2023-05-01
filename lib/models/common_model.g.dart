// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 0;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      artist: fields[1] as String?,
      attributionLink: fields[2] as String?,
      attributionSourceLink: fields[3] as String?,
      attributionText: fields[4] as String?,
      createTime: fields[5] as DateTime?,
      description: fields[6] as String?,
      downloadIntent: fields[7] as DownloadIntent?,
      downloadPartList: (fields[8] as List?)?.cast<DownloadPart>(),
      downloadedUrl: fields[9] as String?,
      fileLocation: fields[10] as String?,
      fileName: fields[11] as String?,
      height: fields[12] as int?,
      id: fields[0] as String?,
      imageOfMediaList: (fields[13] as List?)?.cast<Media>(),
      isPublic: fields[14] as bool?,
      mediaDownloadSource: fields[15] as MediaDownloadSource?,
      mediaImage: fields[16] as Media?,
      mediaSize: fields[17] as int?,
      mimeType: fields[18] as String?,
      multipartFile: fields[19] as MultipartFile?,
      name: fields[20] as String?,
      partialDownloadSupport: fields[21] as bool?,
      passive: fields[22] as bool?,
      size: fields[23] as int?,
      status: fields[24] as DownloadStatus?,
      updateTime: fields[25] as DateTime?,
      width: fields[26] as int?,
      zipMimeType: fields[27] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.attributionLink)
      ..writeByte(3)
      ..write(obj.attributionSourceLink)
      ..writeByte(4)
      ..write(obj.attributionText)
      ..writeByte(5)
      ..write(obj.createTime)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.downloadIntent)
      ..writeByte(8)
      ..write(obj.downloadPartList)
      ..writeByte(9)
      ..write(obj.downloadedUrl)
      ..writeByte(10)
      ..write(obj.fileLocation)
      ..writeByte(11)
      ..write(obj.fileName)
      ..writeByte(12)
      ..write(obj.height)
      ..writeByte(13)
      ..write(obj.imageOfMediaList)
      ..writeByte(14)
      ..write(obj.isPublic)
      ..writeByte(15)
      ..write(obj.mediaDownloadSource)
      ..writeByte(16)
      ..write(obj.mediaImage)
      ..writeByte(17)
      ..write(obj.mediaSize)
      ..writeByte(18)
      ..write(obj.mimeType)
      ..writeByte(19)
      ..write(obj.multipartFile)
      ..writeByte(20)
      ..write(obj.name)
      ..writeByte(21)
      ..write(obj.partialDownloadSupport)
      ..writeByte(22)
      ..write(obj.passive)
      ..writeByte(23)
      ..write(obj.size)
      ..writeByte(24)
      ..write(obj.status)
      ..writeByte(25)
      ..write(obj.updateTime)
      ..writeByte(26)
      ..write(obj.width)
      ..writeByte(27)
      ..write(obj.zipMimeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaDownloadSourceAdapter extends TypeAdapter<MediaDownloadSource> {
  @override
  final int typeId = 1;

  @override
  MediaDownloadSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaDownloadSource(
      createTime: fields[0] as DateTime?,
      description: fields[1] as String?,
      id: fields[2] as String?,
      image: fields[3] as Media?,
      name: fields[4] as String?,
      passive: fields[5] as bool?,
      siteName: fields[6] as String?,
      title: fields[7] as String?,
      type: fields[8] as String?,
      updateTime: fields[9] as DateTime?,
      url: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaDownloadSource obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.passive)
      ..writeByte(6)
      ..write(obj.siteName)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.updateTime)
      ..writeByte(10)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaDownloadSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaFolderAdapter extends TypeAdapter<MediaFolder> {
  @override
  final int typeId = 2;

  @override
  MediaFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaFolder(
      createTime: fields[0] as DateTime?,
      description: fields[1] as String?,
      id: fields[2] as String?,
      name: fields[3] as String?,
      passive: fields[4] as bool?,
      updateTime: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaFolder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.passive)
      ..writeByte(5)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadIntentAdapter extends TypeAdapter<DownloadIntent> {
  @override
  final int typeId = 3;

  @override
  DownloadIntent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadIntent(
      createTime: fields[0] as DateTime?,
      id: fields[1] as String?,
      name: fields[2] as String?,
      passive: fields[3] as bool?,
      updateTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadIntent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.passive)
      ..writeByte(4)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadIntentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadPartAdapter extends TypeAdapter<DownloadPart> {
  @override
  final int typeId = 4;

  @override
  DownloadPart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadPart(
      byteRangeEnd: fields[0] as int?,
      byteRangeStart: fields[1] as int?,
      createTime: fields[2] as DateTime?,
      id: fields[3] as String?,
      media: fields[4] as Media?,
      partFileName: fields[5] as String?,
      partNumber: fields[6] as int?,
      passive: fields[7] as bool?,
      status: fields[8] as DownloadStatus?,
      updateTime: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadPart obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.byteRangeEnd)
      ..writeByte(1)
      ..write(obj.byteRangeStart)
      ..writeByte(2)
      ..write(obj.createTime)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.media)
      ..writeByte(5)
      ..write(obj.partFileName)
      ..writeByte(6)
      ..write(obj.partNumber)
      ..writeByte(7)
      ..write(obj.passive)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadPartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadStatusAdapter extends TypeAdapter<DownloadStatus> {
  @override
  final int typeId = 5;

  @override
  DownloadStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadStatus(
      createTime: fields[0] as DateTime?,
      id: fields[1] as String?,
      name: fields[2] as String?,
      passive: fields[3] as bool?,
      updateTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadStatus obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.passive)
      ..writeByte(4)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final int typeId = 6;

  @override
  Genre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Genre(
      createTime: fields[0] as DateTime?,
      id: fields[1] as String?,
      name: fields[2] as String?,
      passive: fields[3] as bool?,
      updateTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Genre obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.passive)
      ..writeByte(4)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaGenreAdapter extends TypeAdapter<MediaGenre> {
  @override
  final int typeId = 7;

  @override
  MediaGenre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaGenre(
      createTime: fields[0] as DateTime?,
      id: fields[1] as String?,
      media: fields[2] as Media?,
      genre: fields[3] as Genre?,
      passive: fields[4] as bool?,
      updateTime: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaGenre obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.createTime)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.media)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.passive)
      ..writeByte(5)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaGenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
