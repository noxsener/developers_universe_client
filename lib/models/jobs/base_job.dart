import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

abstract class BaseJob {
  BuildContext context;

  String id;
  String name;
  String? description;
  bool? mandatory;
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
  Future<dynamic>? processJob;
  Function? onJobDone;

  BaseJob(this.context, this.id, this.name, this.cancellable, this.retryable, this.icon, {this.processJob, this.onJobDone});
}