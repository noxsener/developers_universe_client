import 'dart:async';

import 'package:developersuniverse_client/main.dart';
import 'package:developersuniverse_client/page/AudioPlaylistManager/audio_playlist_manager.dart';
import 'package:developersuniverse_client/services/common_service.dart';
import 'package:developersuniverse_client/services/job_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/jobs/base_job.dart';
import '../../models/jobs/media_file_index_list_download_job.dart';

class UpdaterController extends GetxController {
  RxList<BaseJob> jobList = <BaseJob>[].obs;

  void updateAll(BuildContext context) async {
    jobList.add(MediaFileIndexListDownloadJob(context));
    List<Future> pendingJobs = [];
    for (int i = 0; i < jobList.length; i++) {
      BaseJob job = jobList[i];
      pendingJobs.add(job.processJob!.then((value) => null));
    }
    Future.wait(pendingJobs);
    goToMainContent(context);
  }

  void goToMainContent(BuildContext context) {
    showSnackBar(context, "All updated");
    Future.delayed(sec, () =>
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AudioPlaylistManager(),
          ),
        )
    );
  }

}
