import 'dart:async';
import 'dart:ffi';

import 'package:developersuniverse_client/main.dart';
import 'package:developersuniverse_client/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/jobs/base_job.dart';
import '../../models/jobs/media_file_index_list_download_job.dart';
import 'updater_controller.dart';

class Updater extends StatefulWidget {
  const Updater({Key? key}) : super(key: key);

  @override
  State<Updater> createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater>
    with TickerProviderStateMixin {
  final c = Get.put(UpdaterController());
  Timer? timer;
  Duration sec = const Duration(seconds: 1);

  bool landscape = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      c.updateAll(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: OrientationBuilder(builder: (context, orientation) {
        landscape = orientation == Orientation.landscape;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: jobListView(),
        );
      }),
    );
  }

  Widget jobListView() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.0, color: Colors.black),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF222222),
                Color(0xFF111111),
              ]),
          boxShadow: const [
            BoxShadow(
                color: Colors.white70,
                offset: Offset(0, -2),
                blurRadius: 3,
                spreadRadius: -7),
            BoxShadow(
                color: Colors.black87,
                offset: Offset(0, 4),
                blurRadius: 3,
                spreadRadius: -7),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: c.jobList.length,
            itemBuilder: (context, index) {
              if (index >= c.jobList.length) {
                return const SizedBox();
              }
              BaseJob jobIndex = c.jobList[index];
              return Obx(() => AnimatedContainer(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan),
                    duration: const Duration(milliseconds: 200),
                    child: ListTile(
                      title: Text(jobIndex.name),
                      leading: jobIndex.icon,
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(jobIndex.description ?? ""),
                          SizedBox(
                              height: 5,
                              child: Obx(() => LinearProgressIndicator(
                                  value: jobIndex.progress.value,
                                  backgroundColor: Colors.black,
                                  color: jobIndex.doneWithError.value
                                      ? const Color(0xFFdd2c00)
                                      : jobIndex.isDone.value
                                          ? const Color(0xFF00c853)
                                          : const Color(0xFFffff00)))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(() => Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: (jobIndex.isStarted.value &&
                                              jobIndex.isDone.value &&
                                              jobIndex.doneWithError.value)
                                          ? const Color(0xFFdd2c00)
                                          : (jobIndex.isStarted.value &&
                                                  jobIndex.isDone.value &&
                                                  !jobIndex.doneWithError.value)
                                              ? const Color(0xFF00c853)
                                              : const Color(0xFFf9a825),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: theme.shadow(),
                                    ),
                                    child: (!jobIndex.isStarted.value &&
                                            !jobIndex.isDone.value)
                                        ? const Icon(
                                            FontAwesomeIcons.pause,
                                            color: Colors.white,
                                            size: 13,
                                          )
                                        : (jobIndex.isStarted.value &&
                                                jobIndex.isDone.value &&
                                                !jobIndex.doneWithError.value)
                                            ? const Icon(
                                                FontAwesomeIcons.check,
                                                color: Colors.white,
                                                size: 13,
                                              )
                                            : (jobIndex.isStarted.value &&
                                                    jobIndex.isDone.value &&
                                                    jobIndex
                                                        .doneWithError.value)
                                                ? const Icon(
                                                    FontAwesomeIcons.xmark,
                                                    color: Colors.white,
                                                    size: 13,
                                                  )
                                                : const Icon(
                                                    FontAwesomeIcons.play,
                                                    color: Colors.white,
                                                    size: 13,
                                                  ))),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Obx(() => Text(
                                        jobIndex.statusMessage.value.trim(),
                                        style: theme.textTheme().bodySmall,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (!jobIndex.isStarted.value && jobIndex.cancellable)
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF2100),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      FontAwesomeIcons.xmark,
                                      color: Colors.white,
                                      size: 20,
                                    ))),
                          if (jobIndex.isDone.value &&
                              jobIndex.doneWithError.value &&
                              jobIndex.retryable)
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00c853),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: theme.shadow(),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      jobIndex.progress.value = 0;
                                      jobIndex.progress.refresh();
                                      jobIndex.isStarted.value = false;
                                      jobIndex.isStarted.refresh();
                                      jobIndex.isDone.value = false;
                                      jobIndex.isDone.refresh();
                                      jobIndex.doneWithError.value = false;
                                      jobIndex.doneWithError.refresh();
                                      jobIndex.statusMessage.value =
                                          "On Retry Wait Queue";
                                      jobIndex.statusMessage.refresh();
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.arrowRotateRight,
                                      color: Colors.white,
                                      size: 20,
                                      shadows: theme.shadow(),
                                    ))),
                        ],
                      ),
                      //const Icon(Icons.download, color: Colors.white70,),
                      onTap: (() async {}),
                      onLongPress: (() async {}),
                    ),
                  ));
            }),
      ),
    );
  }
}
