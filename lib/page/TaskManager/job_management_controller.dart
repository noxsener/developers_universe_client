import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/jobs/base_job.dart';

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
          await job!.value.processJob!.then((value) => null);
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

}
