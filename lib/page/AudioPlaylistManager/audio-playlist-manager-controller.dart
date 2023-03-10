import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:developersuniverse_client/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/common-model.dart';
import '../../webservices/audio-playlist-manager-service.dart';

class AudioPlaylistManagerController extends GetxController {
  RxList<Media> mediaList = <Media>[].obs;
  RxList<Media> filteredMediaList = <Media>[].obs;
  RxList<Genre> genreList = <Genre>[].obs;
  List<String> genreListMultiSelectList = [];

  /*Page - Filter*/
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
        genreListMultiSelectList = genreList.value.map((Genre genre) => genre.name!).toList();
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
      genreListMultiSelectList = genreList.value.map((Genre genre) => genre.name!).toList();
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
      if (genreList != null && genreList.isNotEmpty) {
        requestGrid.filters!.add(FilterParam(
            "genre.id", "in", genreList.map((e) => e.id).toList(growable: false)));
      }
      mediaGenreServiceGridCall(context,requestGrid).then((List<MediaGenre> responseValue) {
        mediaList.value = responseValue.map((e) => e.media!).toList();
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
    audioPlayer.value.onDurationChanged.listen((event) {
      duration.value = event;
      duration.refresh();
    });
    audioPlayer.value.onPositionChanged.listen((event) {
      position.value = event;
      position.refresh();
    });
    audioPlayer.value.onPlayerComplete.listen((event) {
      if (!isLoop.isTrue) {
        nextMedia();
      } else {
        position.value = const Duration();
        Source source = UrlSource(media!.value.downloadedUrl!);
        audioPlayer.value
            .play(source, position: position.value, mode: PlayerMode.mediaPlayer);
      }
    });

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

  void nextMedia() {
    int currentPage = (pageController.page ?? 0).toInt();
    int newPage = (currentPage + 1).toInt();
    if (newPage >= mediaList.length) {
      return;
    }
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }
    pageController.animateToPage(newPage,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
    if (media != null) {
      media!.value = mediaList[newPage];
    } else {
      media = mediaList[newPage].obs;
    }
    media!.refresh();
    position.value = const Duration();
    duration.value = const Duration();
    if (audioPlayer.value.state != PlayerState.stopped &&
        audioPlayer.value.state != PlayerState.paused) {
      Source source = UrlSource(media!.value.downloadedUrl!);
      audioPlayer.value
          .play(source, position: position.value, mode: PlayerMode.mediaPlayer);
      startButtonAnimationController.forward();
      audioPlayer.refresh();
      return;
    }
  }

  void mediaListOnClick(int index) {
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      audioPlayer.value.state = PlayerState.stopped;
      startButtonAnimationController.reverse();
    }
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
    if (media != null) {
      media!.value = mediaList[index];
    } else {
      media = mediaList[index].obs;
    }
    media!.refresh();
    position.value = const Duration();
    duration.value = const Duration();
    Source source = UrlSource(media!.value.downloadedUrl!);
    audioPlayer.value
        .play(source, position: position.value, mode: PlayerMode.mediaPlayer);
    audioPlayer.value.state = PlayerState.playing;
    startButtonAnimationController.forward();
    position.refresh();
    duration.refresh();
    audioPlayer.refresh();
  }

  loopButtonOnClick() {
    isLoop.value = (!isLoop.isTrue);
    if (isLoop.isTrue) {
      // Linux limitation; release mode
      //audioPlayer.value.setReleaseMode(ReleaseMode.loop);
    } else {
      // Linux limitation; release mode
      //audioPlayer.value.setReleaseMode(ReleaseMode.release);
    }
    audioPlayer.refresh();
    isLoop.refresh();
  }

  startButtonOnClick() {
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.pause();
      startButtonAnimationController.reverse();
    } else if (position.value.inSeconds != 0) {
      audioPlayer.value.play(UrlSource(media!.value.downloadedUrl!),
          position: position.value, mode: playerMode.value);
      startButtonAnimationController.forward();
    } else if (audioPlayer.value.state != PlayerState.playing) {
      position.value = const Duration();
      audioPlayer.value.play(UrlSource(media!.value.downloadedUrl!),
          position: position.value, mode: playerMode.value);
      startButtonAnimationController.forward();
    }
    audioPlayer.value.state = PlayerState.playing;
    audioPlayer.refresh();
    position.refresh();
  }

  stopButtonOnClick() {
    audioPlayer.value.stop();
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
    position.value = const Duration();
    position.refresh();
    duration.value = const Duration();
    duration.refresh();
    if (audioPlayer.value.state != PlayerState.stopped &&
        audioPlayer.value.state != PlayerState.paused) {
      Source source = UrlSource(media!.value.downloadedUrl!);
      audioPlayer.value
          .play(source, position: position.value, mode: PlayerMode.mediaPlayer);
      startButtonAnimationController.forward();
      return;
    }
  }

  previousButtonOnClick() {
    int currentPage = (pageController.page ?? 0).toInt();
    if (currentPage <= 0) {
      return;
    }
    if (audioPlayer.value.state == PlayerState.playing) {
      audioPlayer.value.stop();
      startButtonAnimationController.reverse();
    }
    int newPage = (currentPage - 1).toInt();
    pageController.animateToPage(newPage,
        duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
    if (media != null) {
      media!.value = mediaList[newPage];
    } else {
      media = mediaList[newPage].obs;
    }
    media!.refresh();
    position.value = const Duration();
    duration.value = const Duration();
    if (audioPlayer.value.state != PlayerState.stopped &&
        audioPlayer.value.state != PlayerState.paused) {
      Source source = UrlSource(media!.value.downloadedUrl!);
      audioPlayer.value
          .play(source, position: position.value, mode: PlayerMode.mediaPlayer);
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


  void onFilter(BuildContext context, List<String> selectedGenreFromDialog, String text) async {
    multiSelectSelectedGenreList.value = selectedGenreFromDialog;
    selectedGenreList.value = genreList.where((p0) => selectedGenreFromDialog.any((element) => element == p0.name)).toList();
    searchText=text;

    page.value = 0;
    page.refresh();

    if (MyApp.mediaGenreBox.values.isNotEmpty) {
      if (audioPlayer.value.state == PlayerState.playing) {
        audioPlayer.value.stop();
        audioPlayer.value.state = PlayerState.stopped;
        startButtonAnimationController.reverse();
      }
      pageController.animateToPage(0,
          duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 900), curve: Curves.easeIn);

      position.value = const Duration();
      position.refresh();
      duration.value = const Duration();
      duration.refresh();

      if (selectedGenreList.value.isNotEmpty) {
        mediaList.value = MyApp.mediaGenreBox.values
            .where((mediaGenre) => selectedGenreList.value
            .any((genre) => mediaGenre.genre!.id == genre.id))
            .where((mediaGenre) => text.isEmpty
            || mediaGenre.media!.name!.toLowerCase().contains(text.toLowerCase()))
            .map((e) => e.media!)
            .toList();
      } else if (text.isNotEmpty) {
        mediaList.value = MyApp.mediaGenreBox.values
            .where((mediaGenre) => mediaGenre.media!.name!.toLowerCase().contains(text.toLowerCase()))
            .map((e) => e.media!)
            .toList();
      } else {
        mediaList.value = MyApp.mediaBox.values
            .skip(Random().nextInt(200))
            .take(100)
            .toList();
        mediaList.value.sort((a, b) {
          if (a.name == null) {
            return -1;
          }
          if (b.name == null) {
            return 1;
          }
          return a.name!.compareTo(b.name!);
        });
      }

      mediaList.refresh();
    } else {
      RequestGrid requestGrid = RequestGrid(
          page: 0,
          pageSize: 1000000,
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
      if (genreList != null && genreList.isNotEmpty) {
        requestGrid.filters!.add(FilterParam(
            "genre.id", "in", genreList.map((e) => e.id).toList(growable: false)));
      }
      if (text.isNotEmpty) {
        requestGrid.filters!.add(FilterParam(
            "media.name", "like", ["%$text%"]));
      }
      await mediaGenreServiceGridCall(
          context,
          requestGrid)
          .then((List<MediaGenre> responseValue) {
        if (audioPlayer.value.state == PlayerState.playing) {
          audioPlayer.value.stop();
          audioPlayer.value.state = PlayerState.stopped;
          startButtonAnimationController.reverse();
        }
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 900), curve: Curves.easeIn);

        position.value = const Duration();
        position.refresh();
        duration.value = const Duration();
        duration.refresh();
        mediaList.value = responseValue.map((e) => e.media!).toList();
        mediaList.refresh();
      });
    }
    if (mediaList.isNotEmpty) {
      if (media != null) {
        media!.value = mediaList.first;
      } else {
        media = mediaList.first.obs;
      }
      media!.refresh();
    }
    genreList.refresh();
    mediaList.refresh();
  }
}
