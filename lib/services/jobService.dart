library jobService;

import 'dart:async';

import 'package:developersuniverse_client/services/common-service.dart';
import 'package:ntp/ntp.dart';

const Duration sec = Duration(seconds: 1);

initTimerTasks() async {
  everySecond();
}

everySecond() async {
  Timer.periodic(
    sec,
    (t) {
      setTimeFromNTP();
    },
  );
}

setTimeFromNTP() async {
  if (time != null) {
    time = time!.add(sec);
  } else {
    time = await NTP.now(lookUpAddress: 'time.google.com');
  }
}
