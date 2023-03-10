import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/common-model.dart';
import '../../services/common-service.dart';

class ModulesController extends GetxController {

  Rx<Widget?>? activeWidget;
  RxString title = "".obs;

  static Widget? userProfile;
  Widget? settingMenu;
  Widget? moduleMenu;
  Widget? electronicArchive;

  initState(BuildContext context, TickerProvider ticketProvider) async {
  }

  Widget modulesMenu(BuildContext context, List<CodenfastMenu> menuList) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      key: const ValueKey("modulesMenu"),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: CarouselSlider(
                items: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider("https://c.pxhere.com/photos/d0/37/cafe_coffee_shop_coffee_iphone_table-39.jpg!d"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                color: theme.cyanTransparent[300]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                        "New Tech ? ",
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: theme.cyanTransparent[300],
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                color: theme.cyanTransparent[300]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                        "It's will expensive",
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: size.aspectRatio,
                  viewportFraction:
                  (size.width < 737
                      ? 0.6
                      : size.width < 981
                      ? 0.55
                      : 0.5),
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                )
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: size.width /
                      (size.width < 900 ? 0.9
                          : size.width < 1200 ? 1.8 : 3.6),
                  childAspectRatio: 5 / 3,
                  //(size.longestSide / (size.shortestSide)),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: menuList.length,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(onTap: () {
                  if(menuList[index].onClick != null) {
                    menuList[index].onClick!();
                  }
                  },child: menuList[index].getHero());
              }),
        ],
      ),
    );
  }

  Widget settingsMenu(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      key: const ValueKey("settingsMenu"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.cyan
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(onPressed: () {activeWidget!.value = moduleMenu;}, icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.white,)),
                    const Text("Settings"),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.cyanTransparent[300]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Expanded(child: Text("Setting")),
                    Expanded(child: Text("Setting")),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.cyanTransparent[300]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Expanded(child: Text("Setting")),
                    Expanded(child: Text("Setting")),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}