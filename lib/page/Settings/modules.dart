import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  List<CodenfastMenu> menuList = [
    CodenfastMenu(
        title: "Settings",
        icon: Icon(
          FontAwesomeIcons.cogs,
          color: Colors.white,
          shadows: theme.shadow(),
        ),
        description: "The App dude isn't fit for you? Give him a few hint",
        image: "https://c.pxhere.com/photos/d6/1f/wrench_spanner_repair_fix_toolbox_service_work_tool-1328937.jpg!d"),
    CodenfastMenu(
        title: "Profile",
        icon: Icon(
          FontAwesomeIcons.user,
          color: Colors.white,
          shadows: theme.shadow(),
        ),
        description:
            "It's just like a mirror to see yourself and how is your look to other people",
        image: "https://c.pxhere.com/photos/30/1d/business_card_business_card_man_holding_hand_suit_meeting-1187260.jpg!d"),
    CodenfastMenu(
        title: "Digital Archive",
        icon: Icon(
          FontAwesomeIcons.paperclip,
          color: Colors.white,
          shadows: theme.shadow(),
        ),
        description: "Store and retrieve your bla bla bla papers....",
        image: "https://c.pxhere.com/photos/7b/35/library_books_shelving_shelves_reading_culture_corridor_classic-863788.jpg!d"),
    CodenfastMenu(
        title: "Coffee Break",
        icon: Icon(
          FontAwesomeIcons.coffee,
          color: Colors.white,
          shadows: theme.shadow(),
        ),
        description: "Just relax, you know; you were earn it!",
        image: "https://c.pxhere.com/photos/d0/37/cafe_coffee_shop_coffee_iphone_table-39.jpg!d"),
  ];

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
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: CarouselSlider(
                    items: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: theme.cyanTransparent[300],
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider("https://c.pxhere.com/photos/d0/37/cafe_coffee_shop_coffee_iphone_table-39.jpg!d"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                    "New Tech ?",
                                    style: GoogleFonts.orbitron(
                                        shadows: theme.shadow(),
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: Text(
                                "New tech published",
                                style: GoogleFonts.orbitron(
                                    shadows: theme.shadow(),
                                    color: Colors.white,
                                    fontSize: 14),
                              ))
                        ],
                      ),
                    ),
                  ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: theme.cyanTransparent[300],
                          image: const DecorationImage(
                            image: CachedNetworkImageProvider("https://c.pxhere.com/photos/d0/37/cafe_coffee_shop_coffee_iphone_table-39.jpg!d"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "New Tech ?",
                                    style: GoogleFonts.orbitron(
                                        shadows: theme.shadow(),
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                  child: Text(
                                    "New tech published",
                                    style: GoogleFonts.orbitron(
                                        shadows: theme.shadow(),
                                        color: Colors.white,
                                        fontSize: 14),
                                  ))
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
                              ? 0.5
                              : 0.3),
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
                          (size.width < 737
                              ? 1
                              : size.width < 981
                                  ? 2
                                  : 4),
                      childAspectRatio: 4 / 2,
                      //(size.longestSide / (size.shortestSide)),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: menuList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return menuList[index].getHero();
                  }),
            ],
          ),
        ),
      );
    });
  }
}
