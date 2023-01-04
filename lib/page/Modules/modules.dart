import 'package:developersuniverse_client/page/Modules/UserLogin/user-profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/common-model.dart';
import 'modules-controller.dart';

class Modules extends StatefulWidget {
  const Modules({Key? key}) : super(key: key);

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Modules> {
  final c = Get.put(ModulesController());

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
    super.build(context);
    List<CodenfastMenu> menuList = [
      CodenfastMenu(
          title: "Profile",
          icon: const Icon(
            FontAwesomeIcons.userTie,
            color: Colors.white,
          ),
          description:
              "It's just like a mirror to see yourself and how is your look to other people",
          image:
              "https://c.pxhere.com/photos/30/1d/business_card_business_card_man_holding_hand_suit_meeting-1187260.jpg!d",
          onClick: () {
            setState(() {
              c.title.value= 'User Profile';
              ModulesController.userProfile ??= const UserProfile();
              c.activeWidget!.value = ModulesController.userProfile;
              c.title.refresh();
              c.activeWidget!.refresh();
            });
          }),
      CodenfastMenu(
          title: "Digital Archive",
          icon: const Icon(
            FontAwesomeIcons.paperclip,
            color: Colors.white,
          ),
          description: "Store and retrieve your bla bla bla papers....",
          image:
              "https://c.pxhere.com/photos/7b/35/library_books_shelving_shelves_reading_culture_corridor_classic-863788.jpg!d"),
      CodenfastMenu(
          title: "Coffee Break",
          icon: const Icon(
            FontAwesomeIcons.mugHot,
            color: Colors.white,
          ),
          description: "Just relax, you know; you were earn it!",
          image:
              "https://c.pxhere.com/photos/d0/37/cafe_coffee_shop_coffee_iphone_table-39.jpg!d"),
      CodenfastMenu(
          title: "Settings",
          icon: const Icon(
            FontAwesomeIcons.gear,
            color: Colors.white,
          ),
          description: "The App dude isn't fit for you? Give him a few hint",
          image:
              "https://c.pxhere.com/photos/d6/1f/wrench_spanner_repair_fix_toolbox_service_work_tool-1328937.jpg!d",
          onClick: () {
            setState(() {
              c.title.value= 'Digital Archive';
              c.digitalArchive ??= c.settingsMenu(context);
              c.activeWidget!.value = c.settingMenu;
              c.title.refresh();
              c.activeWidget!.refresh();
            });
          }),
    ];

    if (c.activeWidget == null || c.activeWidget!.value == null) {
      c.moduleMenu = c.modulesMenu(context, menuList);
      setState(() {
        c.activeWidget = c.moduleMenu.obs;
        // c.activeWidget = c.settingsMenu(context);
      });
    }

    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Column(
        children: [
          if(c.activeWidget!.value! != c.moduleMenu) Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.cyan
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(onPressed: () {c.activeWidget!.value = c.moduleMenu;}, icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.white,)),
                    Text(c.title.value),
                  ],
                ),
              ),
            ),
          ),
           Expanded(flex: 10,child: Obx(() => c.activeWidget!.value!)),
        ],
      );
    });
  }
}
