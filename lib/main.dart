import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:developersuniverse_client/models/common-model.dart';
import 'package:developersuniverse_client/page/Modules/modules.dart';
import 'package:developersuniverse_client/page/TaskManager/job-management.dart';
import 'package:developersuniverse_client/services/admob-service.dart';
import 'package:developersuniverse_client/services/common-service.dart';
import 'package:developersuniverse_client/services/jobService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';

import 'page/AudioPlaylistManager/audio-playlist-manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerHiveAdapters();
  if (Platform.isAndroid || Platform.isIOS) {
    ByteData data = await PlatformAssetBundle()
        .load('assets/trusted-certs/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
    await MobileAds.instance.initialize();
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(800, 600);
      win.minSize = const Size(500,600);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Developers Universe";
      win.show();
    });
  }
  initTimerTasks();
  MyApp appInstance = const MyApp();
  await Hive.openBox<MediaGenre>("MediaGenre").then((mediaGenreBox) => MyApp.mediaGenreBox = mediaGenreBox);
  await Hive.openBox<Genre>("Genre").then((genreBox) => MyApp.genreBox = genreBox);
  await Hive.openBox<Media>("Media").then((mediaBox) => MyApp.mediaBox = mediaBox);
  await Hive.openBox<MediaDownloadSource>("MediaDownloadSource").then(
      (mediaDownloadSourceBox) =>
          MyApp.mediaDownloadSourceBox = mediaDownloadSourceBox);
  // await Hive.openBox<Media>("ApplicationModules").then((applicationModules) => MyApp.applicationModules = applicationModules);
  await Hive.openBox<ElectronicArchive>("ElectronicArchive").then((electronicArchive) => MyApp.electronicArchiveBox = electronicArchive);
  await Hive.openBox<ElectronicArchiveProperty>("ElectronicArchiveProperty").then((electronicArchiveProperty) => MyApp.electronicArchivePropertyBox = electronicArchiveProperty);
  await Hive.openBox<ElectronicArchivePropertyValue>("ElectronicArchivePropertyValue").then((electronicArchivePropertyValue) => MyApp.electronicArchivePropertyValueBox = electronicArchivePropertyValue);
  runApp(appInstance);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static late Box<Genre> genreBox;
  static late Box<Media> mediaBox;
  static late Box<MediaGenre> mediaGenreBox;
  static late Box<MediaDownloadSource> mediaDownloadSourceBox;
  static late Box<ElectronicArchive> electronicArchiveBox;
  static late Box<ElectronicArchiveProperty> electronicArchivePropertyBox;
  static late Box<ElectronicArchivePropertyValue> electronicArchivePropertyValueBox;


  // static late Box<ApplicationModules> applicationModules;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: theme.blackTransparent,
            textTheme: theme.textTheme(),
            primaryTextTheme: theme.textTheme(),
            iconTheme: theme.iconTheme(),
            inputDecorationTheme: theme.inputDecorationTheme(),
            snackBarTheme: SnackBarThemeData(
                contentTextStyle: theme.textTheme().bodySmall,
                backgroundColor: Colors.black),
            dialogTheme: DialogTheme(
              contentTextStyle: theme.textTheme().bodySmall,
              backgroundColor: theme.cyanTransparent[500],
              iconColor: Colors.white,
              titleTextStyle: theme.textTheme().titleSmall,
              elevation: 2,
              alignment: Alignment.centerLeft,
              actionsPadding: EdgeInsets.all(20)
            ),
            focusColor: Colors.cyan,
            appBarTheme: AppBarTheme(
                backgroundColor: theme.blackTransparent,
                foregroundColor: Colors.white,
                iconTheme: theme.iconTheme(),
                titleTextStyle: theme.textTheme().titleLarge,
                toolbarTextStyle: theme.textTheme().bodySmall,
                centerTitle: true,
            toolbarHeight: 0),
            bannerTheme: MaterialBannerThemeData(
              backgroundColor: theme.blackTransparent,
            )),
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
  AdMobService adMobService = AdMobService();


  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if(Platform.isAndroid || Platform.isIOS) {
      AdMobService.bannerAd?.dispose();
      // AdMobService.interstitialAd?.dispose();
      // AdMobService.rewardedAd?.dispose();
      // AdMobService.rewardedInterstitialAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    initAds();
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return SafeArea(
        child: Column(
          children: [
            if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: SizedBox(height: 28,child: MoveWindow())),
                WindowBorder(
                    color: Colors.black, child: const WindowButtons()),
              ],
            ),
            Expanded(
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
                      physics: const NeverScrollableScrollPhysics(),
                      tabs: [
                        Tab(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.table_chart),
                              if(size.width > 700) Text("Modules", style: theme.textTheme().titleSmall,)
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow),
                              if(size.width > 700) Text("Music Player", style: theme.textTheme().titleSmall,)
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.task),
                              if(size.width > 700) Text("App's Jobs" , style: theme.textTheme().titleSmall,)
                            ],
                          ),
                        )
                      ],
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
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
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab One
                      const Modules(),

                      const AudioPlaylistManager(),
                      // Tab Three
                      jobManagement
                    ],
                  ),
                  bottomNavigationBar:getAdBanner(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void initAds() {
    if(!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    if(AdMobService.bannerAd == null) {
      adMobService.createBanerAd(MediaQuery.of(context).size);
    }

    // adMobService.createInterstitialAd();
    // adMobService.createRewardedAd();
    // adMobService.createRewardedInterstitialAd();
  }

  Widget getAdBanner() {
    Widget empty = const SizedBox();
    if(!Platform.isAndroid && !Platform.isIOS) {
      AdMobService.bannerAd?.dispose().then((value) => AdMobService.bannerAd = null);
      return empty;
    }
    if(AdMobService.bannerAd == null) {
      return empty;
    }
    AdWidget adWidget = AdWidget(ad: AdMobService.bannerAd!);
    AdSize adSize = AdMobService().getBannerAdSize(MediaQuery.of(context).size);
    return Container(
      alignment: Alignment.center,
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: adWidget,
    );
  }

}

final buttonColors = WindowButtonColors(
    iconNormal: Colors.cyan,
    mouseOver: theme.cyanTransparent[300],
    mouseDown: theme.cyanTransparent[700],
    iconMouseOver: Colors.cyan,
    iconMouseDown: Colors.cyan);

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFFFF0000),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
