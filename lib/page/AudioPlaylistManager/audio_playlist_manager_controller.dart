import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:developersuniverse_client/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/common_model.dart';
import '../../services/common_service.dart';
import '../../services/job_service.dart';
import '../../webservices/audio_playlist_manager_service.dart';

class AudioPlaylistManagerController extends GetxController {
  RxList<Media> mediaList = <Media>[].obs;
  RxList<Media> filteredMediaList = <Media>[].obs;
  RxList<Genre> genreList = <Genre>[].obs;
  List<String> genreListMultiSelectList = [];

  /*Page - Filter*/
  String musicListTextFilter = "";
  RxList<Genre> selectedGenreList = <Genre>[].obs;
  RxList<String> multiSelectSelectedGenreList = <String>[].obs;
  RxInt page = 0.obs;
  RxBool stillLoading = false.obs;
  String searchText = "";

  Rx<PlayerMode> playerMode = PlayerMode.mediaPlayer.obs;
  final ScrollController genreScrollController = ScrollController();
  final ScrollController scrollController = ScrollController();
  late AnimationController startButtonAnimationController;

  final Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  final RxDouble audioPlayerVolume = (1.0).obs;
  Rx<Duration> duration = const Duration().obs;
  Rx<Duration> position = const Duration().obs;
  Rx<Media>? media;
  RxBool isLoop = false.obs;

  final PageController pageController = PageController(viewportFraction: 0.6);
  Rx<double?> currentPage = 0.0.obs;

  initState(BuildContext context, TickerProvider ticketProvider) {
    startButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: ticketProvider);
    AudioPlayer.global.changeLogLevel(LogLevel.error);

    if (MyApp.genreBox.values.toList().isEmpty) {
      genreServiceGridCall(context, genreServiceGridRequest())
          .then((List<Genre> genreListResponseValue) {
        genreList.value = genreListResponseValue;
        genreListMultiSelectList =
            genreList.value.map((Genre genre) => genre.name!).toList();
      });
    } else {
      genreList.value = MyApp.genreBox.values.toList();
      genreList.value.sort((a, b) {
        if (a.name == null) {
          return -1;
        }
        if (b.name == null) {
          return 1;
        }
        return a.name!.compareTo(b.name!);
      });
      genreListMultiSelectList =
          genreList.value.map((Genre genre) => genre.name!).toList();
    }
    genreList.refresh();

    if (MyApp.mediaBox.values.isEmpty) {
      RequestGrid requestGrid = RequestGrid(
          page: (page.value ?? 0) * 20,
          pageSize: (((page.value ?? 0) + 1) * 200) - 1,
          sortField: null,
          sortOrder: null,
          propertyList: [
            "id",
            "genre.id",
            "genre.name",
            "media.id",
            "media.artist",
            "media.name",
            "media.mediaImage.id",
            "media.mediaImage.downloadedUrl",
            "media.attributionText",
            "media.attributionLink",
            "media.downloadedUrl",
            "media.lengthInSeconds",
            "media.mediaDownloadSource.id",
            "media.mediaDownloadSource.siteName",
            "media.mediaDownloadSource.title",
            "media.mediaDownloadSource.url",
            "media.mediaDownloadSource.image.id",
            "media.mediaDownloadSource.image.downloadedUrl"
          ],
          filters: [
            FilterParam("passive", "equal", [false]),
            FilterParam("genre.passive", "equal", [false]),
            FilterParam("media.passive", "equal", [false]),
            FilterParam("media.mimeType", "equal", ["audio/mpeg"]),
            FilterParam("media.status.name", "equal", ["DONE"]),
          ]);
      if (genreList.isNotEmpty) {
        requestGrid.filters!.add(FilterParam("genre.id", "in",
            genreList.map((e) => e.id).toList(growable: false)));
      }
      mediaGenreServiceGridTableCall(context, requestGrid)
          .then((TableModel<MediaGenre> responseValue) {
        mediaList.value =
            responseValue.dataGeneric.map((e) => e.media!).toList();
      });
    } else {
      mediaList.value =
          MyApp.mediaBox.values.skip(Random().nextInt(200)).take(50).toList();
    }
    stillLoading.value = false;
    stillLoading.refresh();

    mediaList.refresh();
    if (mediaList.isNotEmpty) {
      if (media != null) {
        media!.value = mediaList.first;
      } else {
        media = mediaList.first.obs;
      }
      media!.refresh();
    }

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //       scrollController.position.maxScrollExtent * 0.8 ||
    //       scrollController.offset >=
    //           scrollController.position.maxScrollExtent &&
    //           !scrollController.position.outOfRange) {
    //     // reached to bottom
    //     if (stillLoading.isTrue) {
    //       return;
    //     }
    //     stillLoading.value = true;
    //     stillLoading.refresh();
    //     page++;
    //     mediaGenreServiceGridCall(context,
    //         mediaGenreServiceGridRequest(page.value, selectedGenreList, pageSize: 100000))
    //         .then((List<MediaGenre> responseValue) {
    //       stillLoading.value = false;
    //       stillLoading.refresh();
    //       mediaList.value = responseValue
    //           .map((e) => e.media!)
    //           .toList();
    //       mediaList.refresh();
    //     });
    //   }
    //   // if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent * 1.2) {
    //   // move list
    //   // }
    // });

    pageController.addListener(() {
      currentPage.value = pageController.page ?? 0.0;
      currentPage.refresh();
    });
  }

  void nextMedia(Function(Duration) onDurationChanged,
      Function(Duration) onPositionChanged, Function(void) onPlayerCompleted) {
    int currentPage = (pageController.page ?? 0).toInt();
    int index = (currentPage + 1).toInt();
    if (index >= mediaList.length) {
      return;
    }
    if (media != null) {
      media!.value = mediaList[index];
    } else {
      media = mediaList[index].obs;
    }
    media!.refresh();
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }
    audioPlayer.value
        .stop()
        .then((value) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
    if (media != null) {
      media!.value = mediaList[index];
    } else {
      media = mediaList[index].obs;
    }
    media!.refresh();

    position.value = const Duration();
    duration.value = Duration(seconds: media!.value.lengthInSeconds ?? 0);
    position.refresh();
    duration.refresh();
    startButtonAnimationController.forward();
    Source source = UrlSource(media!.value.downloadedUrl!);
    audioPlayer.value.play(source, position: position.value);
    audioPlayer.value.state = PlayerState.playing;
    audioPlayer.refresh();

    });

  }

  void mediaListOnClick(int index, Function(Duration) onDurationChanged,
      Function(Duration) onPositionChanged, Function(void) onPlayerCompleted) {
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }
    if (media != null) {
      media!.value = mediaList[index];
    } else {
      media = mediaList[index].obs;
    }
    media!.refresh();
    audioPlayer.value
        .stop()
        .then((value)  {
    audioPlayer.value = AudioPlayer();
    audioPlayer.value.onDurationChanged.listen(onDurationChanged);
    audioPlayer.value.onPositionChanged.listen(onPositionChanged);
    audioPlayer.value.onPlayerComplete.listen(onPlayerCompleted);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);

    position.value = const Duration();
    duration.value = Duration(seconds: media!.value.lengthInSeconds ?? 0);
    position.refresh();
    duration.refresh();
    startButtonAnimationController.forward();
    Source source = UrlSource(media!.value.downloadedUrl!);
    audioPlayer.value.play(source, position: position.value);
    audioPlayer.value.state = PlayerState.playing;
    audioPlayer.refresh();
    });
  }

  previousButtonOnClick(Function(Duration) onDurationChanged,
      Function(Duration) onPositionChanged, Function(void) onPlayerCompleted) {
    int currentPage = (pageController.page ?? 0).toInt();
    if (currentPage <= 0) {
      return;
    }
    int index = (currentPage - 1).toInt();
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }

    if (media != null) {
      media!.value = mediaList[index];
    } else {
      media = mediaList[index].obs;
    }
    media!.refresh();

    audioPlayer.value
        .stop()
        .then((value)  {
    audioPlayer.value = AudioPlayer();
    audioPlayer.value.onDurationChanged.listen(onDurationChanged);
    audioPlayer.value.onPositionChanged.listen(onPositionChanged);
    audioPlayer.value.onPlayerComplete.listen(onPlayerCompleted);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
    position.value = const Duration();
    duration.value = Duration(seconds: media!.value.lengthInSeconds ?? 0);
    position.refresh();
    duration.refresh();
    startButtonAnimationController.forward();
    Source source = UrlSource(media!.value.downloadedUrl!);
    audioPlayer.value.play(source, position: position.value);
    audioPlayer.value.state = PlayerState.playing;
    audioPlayer.refresh();
    });
  }

  loopButtonOnClick() {
    isLoop.value = (!isLoop.isTrue);
    if (isLoop.isTrue) {
      // Linux limitation; release mode
      audioPlayer.value.setReleaseMode(ReleaseMode.loop);
    } else {
      // Linux limitation; release mode
      //audioPlayer.value.setReleaseMode(ReleaseMode.release);
    }
    audioPlayer.refresh();
    isLoop.refresh();
  }

  startButtonOnClick(Function(Duration) onDurationChanged,
      Function(Duration) onPositionChanged, Function(void) onPlayerCompleted) {
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.pause();
      startButtonAnimationController.reverse();
      audioPlayer.value.state = PlayerState.playing;
      audioPlayer.refresh();
      position.refresh();
    } else if (position.value.inSeconds != 0) {
      audioPlayer.value.play(UrlSource(media!.value.downloadedUrl!),
          position: position.value, mode: playerMode.value);
      startButtonAnimationController.forward();
      audioPlayer.value.state = PlayerState.playing;
      audioPlayer.refresh();
      position.refresh();
    } else if (audioPlayer.value.state != PlayerState.playing) {
      audioPlayer.value
          .stop()
          .then((value) {
      audioPlayer.value = AudioPlayer();
      audioPlayer.value.onDurationChanged.listen(onDurationChanged);
      audioPlayer.value.onPositionChanged.listen(onPositionChanged);
      audioPlayer.value.onPlayerComplete.listen(onPlayerCompleted);
      position.value = const Duration();
      duration.value = Duration(seconds: media!.value.lengthInSeconds ?? 0);
      position.refresh();
      duration.refresh();
      startButtonAnimationController.forward();
      Source source = UrlSource(media!.value.downloadedUrl!);
      audioPlayer.value.play(source, position: position.value);
      audioPlayer.value.state = PlayerState.playing;
      audioPlayer.refresh();
      });
    }
  }

  stopButtonOnClick() {
    audioPlayer.value.stop();
    audioPlayer.value.release();

    startButtonAnimationController.reverse();
    position.value = const Duration(milliseconds: 0);
    audioPlayer.value.state = PlayerState.stopped;
    audioPlayer.refresh();
    position.refresh();
  }

  onPageChanged(int page) {
    int currentPage = page;
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }
    if (media != null) {
      media!.value = mediaList[currentPage];
    } else {
      media = mediaList[currentPage].obs;
    }
    media!.refresh();
    position.value = const Duration(seconds: 0);
    duration.value = const Duration(seconds: 0);
    position.refresh();
    duration.refresh();
    if (audioPlayer.value.state != PlayerState.stopped &&
        audioPlayer.value.state != PlayerState.paused) {
      Source source = UrlSource(media!.value.downloadedUrl!);
      audioPlayer.value.play(source, position: position.value);
      startButtonAnimationController.forward();
      return;
    }
  }

  sliderOnChanged(double value) {
    if (duration.value.inSeconds < 1) {
      return;
    }
    position.value = Duration(seconds: value.toInt());
    position.refresh();
    audioPlayer.value.seek(position.value);
    audioPlayer.refresh();
  }

  void onFilter(BuildContext context) {
      mediaList.value = MyApp.mediaGenreBox.values.where((element) {
        if (element.media == null || element.media!.name == null) {
          return false;
        }
        bool result = true;
        if(selectedGenreList.isNotEmpty) {
          result = result && selectedGenreList.indexWhere(
                  (selectedGenre) => element.genre != null && element.genre!.id == selectedGenre.id) >= 0;
        }
        if (musicListTextFilter.isNotEmpty) {
          result = result && element.media!.name!.toLowerCase().contains(musicListTextFilter.toLowerCase());
        }
        return result;
      }).where((e) => e.media != null).map((e) => e.media!).toList();
      mediaList.refresh();
  }

  void showDownloadConfirmDialog<T>(BuildContext context, String title,Widget downloadList, {String? description, List<TextButton>? actionButtons}) {
    Size size = MediaQuery.of(context).size;
    showDialog
      (
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title, style: theme.textTheme().headlineLarge,),
              content:  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(description != null) Text(description, style: theme.textTheme().bodyMedium),
                  SizedBox(
                      width: size.width * (size.width < 800
                          ? 0.95
                          : size.width < 1000
                          ? 0.8
                          : 0.5),
                      height: size.height * 0.35,
                      child: downloadList
                  ),
                ],
              ),
              actions: <Widget>[
                if(actionButtons != null) ...actionButtons
              ],
            );
          },
        );
      },
    );
  }
}
