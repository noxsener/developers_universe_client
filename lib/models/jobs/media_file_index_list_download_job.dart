import 'package:developersuniverse_client/models/jobs/base_job.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../../services/common_service.dart';
import '../../webservices/audio_playlist_manager_service.dart';
import '../common_model.dart';

class MediaFileIndexListDownloadJob extends BaseJob {
  MediaFileIndexListDownloadJob(BuildContext context, {onJobDone})
      : super(
            context,
            const Uuid().v1(),
            "Music Info Lists Download",
            false,
            false,
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2100),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: theme.shadow(),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                ))) {
    processJob = process();
  }


  Future<dynamic> process() async {
    isStarted.value = true;
    statusMessage.value = "Started";
    statusMessage.refresh();
    progress.value = 0;
    progress.refresh();
    await mediaIndexFileListCall(context).then((mediaIndexList) {
      int totalCount = mediaIndexList.length;

      MyApp.mediaFileIndexBox.deleteAll(MyApp.mediaFileIndexBox.keys);
      for (int i = 0; i < mediaIndexList.length; i++) {
        Media media = mediaIndexList[i];
        MyApp.mediaFileIndexBox.add(media);
        progress.value =
            ((i.toDouble() / totalCount.toDouble()) * 100).toDouble();
        progress.refresh();
      }
      progress.value = 100;
      progress.refresh();
      isDone.value = true;
      statusMessage.value =
          "Media Index List Updated: $totalCount row${totalCount > 0 ? "s" : ""} processed";
      statusMessage.refresh();

      if (context.mounted) {
        showSnackBar(context,
            "Media Index List Updated: $totalCount row${totalCount > 0 ? "s" : ""} processed");

        if (onJobDone != null) {
          onJobDone!();
        }
      }
    });
    /*
    isStarted.value = true;
    statusMessage.value = "Started";
    statusMessage.refresh();
    RequestGrid requestGrid = RequestGrid(
        page: 0,
        pageSize: 1000000,
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
    await mediaGenreServiceGridCall(context, requestGrid)
        .then((value) async {

      try {
        int totalCount = value.length;
        for (int i = 0; i < totalCount; i++) {
          MediaGenre mediaGenre = value[i];
          await MyApp.mediaGenreBox.put(mediaGenre.id, mediaGenre);
          await MyApp.genreBox.put(mediaGenre.genre!.id, mediaGenre.genre!);
          await MyApp.mediaBox.put(mediaGenre.media!.id, mediaGenre.media!);
          await MyApp.mediaDownloadSourceBox.put(
              mediaGenre.media!.mediaDownloadSource!.id,
              mediaGenre.media!.mediaDownloadSource!);
          if (i % 10 == 0) {
            progress.refresh();
            progress.value =
                ((i.toDouble() / totalCount.toDouble())).toDouble();
            progress.refresh();
          }
        }
        progress.value = 100;
        progress.refresh();
        isDone.value = true;
        statusMessage.value = "List Updated: $totalCount row/s processed";
        statusMessage.refresh();
        if (context.mounted) {
          showSnackBar(context,
              "Music list updated: $totalCount row/s processed for offline usage");
        }
      } catch (e) {
        progress.value = 100;
        progress.refresh();
        isDone.value = true;
        doneWithError.value = true;
        doneWithError.refresh();
        statusMessage.value = e.toString();
        statusMessage.refresh();
        showSnackBar(context, "Music list failed: $e");
      }
    });

     */
  }
}
