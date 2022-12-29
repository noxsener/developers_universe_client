
import 'package:developersuniverse_client/page/Settings/Profile/profile-controller.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Profile> {
  final c = Get.put(ProfileController());

  bool landscape = false;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
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
        child: SizedBox(),
      ),
    );
  }
}
