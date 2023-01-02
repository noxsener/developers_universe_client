import 'dart:io';

import 'package:developersuniverse_client/component/codenfast-drawer/curved_drawer.dart';
import 'package:developersuniverse_client/models/common-model.dart';
import 'package:developersuniverse_client/page/Modules/modules.dart';
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
import 'package:window_size/window_size.dart';

import 'page/AudioPlaylistManager/audio-playlist-manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    ByteData data = await PlatformAssetBundle()
        .load('assets/trusted-certs/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Developers Universe');
    setWindowMinSize(const Size(500, 600));
    setWindowMaxSize(Size.infinite);
  }
  await Hive.initFlutter();
  registerHiveAdapters();
  initTimerTasks();
  MyApp appInstance = const MyApp();
  await Hive.openBox<MediaGenre>("MediaGenre").then((mediaGenreBox) => MyApp.mediaGenreBox = mediaGenreBox);
  await Hive.openBox<Genre>("Genre").then((genreBox) => MyApp.genreBox = genreBox);
  await Hive.openBox<Media>("Media").then((mediaBox) => MyApp.mediaBox = mediaBox);
  await Hive.openBox<MediaDownloadSource>("MediaDownloadSource").then((mediaDownloadSourceBox) => MyApp.mediaDownloadSourceBox = mediaDownloadSourceBox);
  // await Hive.openBox<Media>("ApplicationModules").then((applicationModules) => MyApp.applicationModules = applicationModules);
  runApp(appInstance);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static late Box<Genre> genreBox;
  static late Box<Media> mediaBox;
  static late Box<MediaGenre> mediaGenreBox;
  static late Box<MediaDownloadSource> mediaDownloadSourceBox;
  // static late Box<ApplicationModules> applicationModules;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Developers Universe',
        theme: ThemeData(
          primarySwatch: theme.blackTransparent,
          textTheme: theme.textTheme,
          primaryTextTheme: theme.textTheme,
          iconTheme: theme.iconTheme,
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Colors.white,
            fillColor: Colors.white,
            suffixIconColor: Colors.white,
            prefixIconColor: Colors.white,
            iconColor: Colors.white,
            hoverColor: Colors.white,
            labelStyle: theme.textTheme.labelLarge,
            counterStyle: theme.textTheme.bodyMedium,
            prefixStyle: theme.textTheme.bodyMedium,
            suffixStyle: theme.textTheme.bodyMedium,
            errorStyle: theme.textTheme.labelMedium?.copyWith(inherit: true, color: Colors.white),
            hintStyle: theme.textTheme.bodySmall,
            helperStyle: theme.textTheme.bodySmall,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            helperMaxLines: 3,
            errorMaxLines: 3,
            contentPadding: const EdgeInsets.all(5),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1
                  )
              ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1
                )
            ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Colors.cyanAccent,
                      width: 2
                  )
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1
                  )
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color(0xFFD50000),
                      width: 1
                  )
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2
                  )
              ),
          )
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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
            appBar: AppBar(
              bottom: TabBar(

                tabs: [
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.table_chart),
                        if(landscape) const Text("Modules")],
                    ),
                  ),
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow),
                        if(landscape) const Text("Music Player")],
                    ),
                  ),
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.task),
                        if(landscape) const Text("App's Jobs")],
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
              title: const Text('Developers Universe'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab One
                      const Modules(),

                      const AudioPlaylistManager(),
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
