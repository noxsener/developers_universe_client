import 'dart:async';

import 'package:developersuniverse_client/main.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/common-model.dart';
import '../../webservices/audio-playlist-manager-service.dart';

class JobManagementController extends GetxController {
  Duration sec = const Duration(seconds: 1);
  static RxList<BaseJob> jobList = <BaseJob>[].obs;
  Rx<BaseJob>? job;
  Timer? timer;

  initState(BuildContext context, TickerProvider ticketProvider) {
    startTimer(context);
  }

  startTimer(BuildContext context) {
    if (timer != null && timer!.isActive) {
      return;
    }
    timer = Timer.periodic(
      sec,
      (t) async {
        if (job == null) {
          if (jobList.isNotEmpty) {
            job!.value = jobList.first;
            job!.refresh();
          } else {
            job = null;
          }
          return;
        }
        if (!job!.value.isStarted.value && !job!.value.isDone.value) {
          await downloadMusicList(context, job!.value);
        }
        if (job!.value.isStarted.value && job!.value.isDone.value) {
          if (jobList.where((p0) => !p0.isDone.value).isNotEmpty) {
            job!.value = jobList.where((p0) => !p0.isDone.value).first;
            job!.refresh();
          }
        }
      },
    );
  }

  Future<dynamic> downloadMusicList(BuildContext context, BaseJob basejob) async {
    basejob.isStarted.value = true;
    basejob.statusMessage.value = "Started";
    basejob.statusMessage.refresh();
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
          basejob.progress.refresh();
          basejob.progress.value =
              ((i.toDouble() / totalCount.toDouble())).toDouble();
          basejob.progress.refresh();
        }
      }
      basejob.progress.value = 100;
      basejob.progress.refresh();
      basejob.isDone.value = true;
      basejob.statusMessage.value = "List Updated: $totalCount row/s processed";
      basejob.statusMessage.refresh();
      showSnackBar(context, "Music list updated: $totalCount row/s processed for offline usage");
    } catch (e) {
      basejob.progress.value = 100;
      basejob.progress.refresh();
      basejob.isDone.value = true;
      basejob.doneWithError.value = true;
      basejob.doneWithError.refresh();
      basejob.statusMessage.value = e.toString();
      basejob.statusMessage.refresh();
      showSnackBar(context, "Music list failed: $e");
    }
    }).onError((error, stackTrace) {
      job!.value.progress.value = 100;
      job!.value.progress.refresh();
      job!.value.isDone.value = true;
      job!.value.doneWithError.value = true;
      job!.value.doneWithError.refresh();
      job!.value.statusMessage.value = error.toString();
      job!.value.statusMessage.refresh();
      showSnackBar(context, "Music list failed: $error");
    });
  }

}

class BaseJob {
  String id;
  String name;
  String? description;
  bool? needsInternetConnection;
  bool cancellable;
  bool retryable;
  Rx<bool> isStarted = false.obs;
  Rx<bool> isDone = false.obs;
  Rx<double> progress = (0.0).obs;
  Rx<String> statusMessage = "Waiting".obs;
  Rx<bool> doneWithError = false.obs;
  Rx<DateTime> createTime = DateTime.now().obs;
  Rx<DateTime?>? startTime;
  Rx<DateTime?>? endTime;
  Widget icon;

  BaseJob({required this.id, required this.name, required this.icon, this.description, this.cancellable = true, this.retryable = true, this.startTime});
}
