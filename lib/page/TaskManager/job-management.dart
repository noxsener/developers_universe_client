import 'package:developersuniverse_client/services/common-service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'job-management-controller.dart';

class JobManagement extends StatefulWidget {
  const JobManagement({Key? key}) : super(key: key);

  @override
  State<JobManagement> createState() => _JobManagementState();
}

class _JobManagementState extends State<JobManagement>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<JobManagement> {
  final c = Get.put(JobManagementController());

  bool landscape = false;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
    if (c.job == null) {
      BaseJob baseJob = BaseJob(id: const Uuid().v1(),
          name: "Music Download Task 1",
          description: "Offline Music List for save bandwitdh",
          icon:
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFFFF2100),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: const Icon(Icons.music_note, color: Colors.white,)));
      JobManagementController.jobList.add(baseJob);
      JobManagementController.jobList.refresh();
      c.job ??= baseJob.obs;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Scaffold(backgroundColor: Colors.transparent, body: jobListView()
        // landscape
        //     ? Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     musicPlayer(),
        //     musicList(),
        //   ],
        // )
        //     : Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     musicPlayer(),
        //     musicList(),
        //   ],
        // ),
      );
    });
  }

  Widget jobListView() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
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
            itemCount: JobManagementController.jobList.length,
            itemBuilder: (context, index) {
              if (index >= JobManagementController.jobList.length) {
                return const SizedBox();
              }
              BaseJob jobIndex = JobManagementController.jobList[index];
              return Obx(() =>
                  AnimatedContainer(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: c.job?.value?.id == jobIndex.id
                            ? Colors.cyan
                            : Colors.transparent),
                    duration: const Duration(milliseconds: 200),
                    child: ListTile(
                      title: Text(
                        jobIndex.name
                      ),
                      leading: jobIndex.icon,
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobIndex.description ?? ""
                          ),
                          SizedBox(
                              height: 5,
                              child:
                              Obx(() =>
                                  LinearProgressIndicator(
                                      value: jobIndex.progress.value,
                                      backgroundColor: Colors.black,
                                      color: jobIndex.doneWithError.value ?
                                      const Color(0xFFdd2c00) :
                                      jobIndex.isDone.value ?
                                      const Color(0xFF00c853) :
                                      const Color(0xFFffff00)
                                  )
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Obx(() =>
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color:
                                        (jobIndex.isStarted.value && jobIndex.isDone.value && jobIndex.doneWithError.value) ? const Color(0xFFdd2c00) :
                                        (jobIndex.isStarted.value && jobIndex.isDone.value && !jobIndex.doneWithError.value) ? const Color(0xFF00c853) :
                                        const Color(0xFFf9a825),
                                        borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                    (!jobIndex.isStarted.value && !jobIndex.isDone.value) ? const Icon(FontAwesomeIcons.pause, color: Colors.white, size: 14,) :
                                    (jobIndex.isStarted.value && jobIndex.isDone.value) ? const Icon(FontAwesomeIcons.check, color: Colors.white, size: 14,) :
                                    const Icon(FontAwesomeIcons.play, color: Colors.white, size: 14,)
                                )),
                                const SizedBox(width: 5,),
                                Expanded(
                                  child: Obx(() => Text(
                                    jobIndex.statusMessage.value ?? ""
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
                          if (!jobIndex.isStarted.value && jobIndex.cancellable )
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFF2100),
                                  borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(onPressed: () {
                              }, icon: const Icon(FontAwesomeIcons.times, color: Colors.white, size: 20,))),
                          if (jobIndex.isDone.value && jobIndex.doneWithError.value && jobIndex.retryable)
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF00c853),
                                  borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(onPressed: () {

                                jobIndex.progress.value = 0;
                                jobIndex.progress.refresh();
                                jobIndex.isStarted.value = false;
                                jobIndex.isStarted.refresh();
                                jobIndex.isDone.value = false;
                                jobIndex.isDone.refresh();
                                jobIndex.doneWithError.value = false;
                                jobIndex.doneWithError.refresh();
                                jobIndex.statusMessage.value = "On Retry Wait Queue";
                                jobIndex.statusMessage.refresh();
                              }, icon: const Icon(FontAwesomeIcons.redo, color: Colors.white, size: 20,))),
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
