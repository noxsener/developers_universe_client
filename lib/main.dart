import 'dart:io';

import 'package:developersuniverse_client/component/codenfast-drawer/curved_drawer.dart';
import 'package:developersuniverse_client/models/common-model.dart';
import 'package:developersuniverse_client/page/Settings/settings.dart';
import 'package:developersuniverse_client/page/TaskManager/job-management.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:developersuniverse_client/services/jobService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'page/AudioPlaylistManager/audio-playlist-manager.dart';

void main() async {
  if (Platform.isAndroid || Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    ByteData data = await PlatformAssetBundle()
        .load('assets/trusted-certs/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  await Hive.initFlutter();
  registerHiveAdapters();
  initTimerTasks();
  MyApp appInstance = const MyApp();
  await Hive.openBox<MediaGenre>("MediaGenre").then((mediaGenreBox) => MyApp.mediaGenreBox = mediaGenreBox);
  await Hive.openBox<Genre>("Genre").then((genreBox) => MyApp.genreBox = genreBox);
  await Hive.openBox<Media>("Media").then((mediaBox) => MyApp.mediaBox = mediaBox);
  await Hive.openBox<MediaDownloadSource>("MediaDownloadSource").then((mediaDownloadSourceBox) => MyApp.mediaDownloadSourceBox = mediaDownloadSourceBox);
  // await Hive.openBox<Media>("ApplicationSettings").then((applicationSettings) => MyApp.applicationSettings = applicationSettings);
  runApp(appInstance);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static late Box<Genre> genreBox;
  static late Box<Media> mediaBox;
  static late Box<MediaGenre> mediaGenreBox;
  static late Box<MediaDownloadSource> mediaDownloadSourceBox;
  // static late Box<ApplicationSettings> applicationSettings;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Developers Universe',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale("tr", "TR"),
          Locale("de", "DE")
        ],
        locale: const Locale("en", "US"));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool landscape = false;
  TabController? _tabController;

  JobManagement jobManagement = const JobManagement();

  List<DrawerItem> moduleDrawerItemList = const [
    DrawerItem(
        label: "Digital Archive",
        icon: Icon(FontAwesomeIcons.folderOpen, shadows: [BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)])),
    DrawerItem(
        label: "Fibonacci Poker",
        icon: Icon(FontAwesomeIcons.solidHeart, shadows: [BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)]))
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;



      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                theme.backGroundColor1,
                theme.backGroundColor2,
                theme.backGroundColor3,
                theme.backGroundColor4
              ])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                TabBar(
                  
                  tabs: [
                    Tab(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, shadows: theme.shadow()),
                          if(landscape) Text("Music Player", style: GoogleFonts.orbitron(shadows: theme.shadow()))],
                      ),
                    ),
                    Tab(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.table_chart, shadows: theme.shadow()),
                          if(landscape) Text("Modules", style: GoogleFonts.orbitron(shadows: theme.shadow()))],
                      ),
                    ),
                    Tab(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(FontAwesomeIcons.cogs, shadows: theme.shadow()),
                          ),
                          if(landscape) Text("Settings", style: GoogleFonts.orbitron(shadows: theme.shadow()))],
                      ),
                    ),
                    Tab(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task, shadows: theme.shadow()),
                          if(landscape) Text("Jobs", style: GoogleFonts.orbitron(shadows: theme.shadow()))],
                      ),
                    )
                  ],
                  indicator: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          1
                        ],
                        colors: [
                          Colors.cyan,
                        ]),
                  ),
                  controller: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab One
                      const AudioPlaylistManager(),
                      // Tab Two
                      CurvedDrawer(
                          items: moduleDrawerItemList,
                          onTap: (index) {
                            print("Drawer Clicked $index");
                            setState(() {});
                          },
                          labelColor: Colors.white,
                          shadows: theme.shadow(),
                          buttonBackgroundColor: Colors.cyan,
                          color: Colors.cyan),
                      const Settings(),
                      // Tab Three
                      jobManagement
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
