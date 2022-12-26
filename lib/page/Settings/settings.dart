
import 'package:developersuniverse_client/page/Settings/Profile/profile.dart';
import 'package:developersuniverse_client/page/Settings/settings-controller.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../component/codenfast-drawer/curved_drawer.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Settings> {
  List<DrawerItem> settingsDrawerItemList = const [
    DrawerItem(
        label: "Profile",
        icon: Icon(FontAwesomeIcons.user, shadows: [Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)])),
    DrawerItem(
        label: "Security",
        icon: Icon(FontAwesomeIcons.lock, shadows: [Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)]))
  ];

  final c = Get.put(SettingsController());

  bool landscape = false;

  Profile profile = const Profile();
  Widget? selectedPage = null;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    selectedPage ??= profile;

    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Scaffold(backgroundColor: Colors.transparent,
          body:
           Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: selectedPage!,
                  )
                ],
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: 20,
                  height: MediaQuery.of(context).size.height,
                  child: CurvedDrawer(
                      items: settingsDrawerItemList,
                      onTap: (value) {
                        setState(() {

                        });
                    if(value == 1) {
                      return;
                    }
                    selectedPage = profile;
                  },
                      labelColor: Colors.white,
                      shadows: theme.shadow(),
                      buttonBackgroundColor: Colors.cyan,
                      color: Colors.cyan
                  ),
                ),
              )
            ],
          ),
      );
    });
  }
}
