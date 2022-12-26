import 'dart:async';

import 'package:developersuniverse_client/main.dart';
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
    RequestGrid requestGrid =
    mediaGenreServiceGridRequest(0, null, pageSize: 10000000);
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
      basejob.statusMessage ??= "List Updated".obs;
      basejob.statusMessage.value = "List Updated: $totalCount row/s processed";
      basejob.statusMessage.refresh();
    } catch (e) {
      basejob.progress.value = 100;
      basejob.progress.refresh();
      basejob.isDone.value = true;
      basejob.doneWithError.value = true;
      basejob.doneWithError.refresh();
      basejob.statusMessage ??= e.toString().obs;
      basejob.statusMessage.value = e.toString();
      basejob.statusMessage.refresh();
    }
    }).onError((error, stackTrace) {
      job!.value.progress.value = 100;
      job!.value.progress.refresh();
      job!.value.isDone.value = true;
      job!.value.doneWithError.value = true;
      job!.value.doneWithError.refresh();
      job!.value.statusMessage ??= error.toString().obs;
      job!.value.statusMessage.value = error.toString();
      job!.value.statusMessage.refresh();
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
