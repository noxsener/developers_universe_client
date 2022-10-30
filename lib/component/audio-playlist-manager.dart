import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:developersuniverse_client/services/connection-service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/common-model.dart';
import '../services/common-service.dart';
import 'MusicCard.dart';

class AudioPlaylistManager extends StatefulWidget {
  const AudioPlaylistManager({Key? key}) : super(key: key);

  @override
  State<AudioPlaylistManager> createState() => _AudioPlaylistManagerState();
}

class _AudioPlaylistManagerState extends State<AudioPlaylistManager>
    with TickerProviderStateMixin {
  List<Media> mediaList = [];
  List<Genre> genreList = [];

  /*Page - Filter*/
  List<Genre> selectedGenreList = [];
  int page = 0;
  bool stillLoading = false;

  PlayerMode _playerMode = PlayerMode.mediaPlayer;
  final ScrollController _genreScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _startButtonAnimationController;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  Media? media;
  bool isLoop = false;

  final PageController _pageController = PageController(viewportFraction: 0.6);
  double currentPage = 0.0;

  bool landscape = false;

  @override
  void initState() {
    _startButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    super.initState();
    genreServiceGridCall(context, genreServiceGridRequest())
        .then((List<Genre> genreListResponseValue) {
      genreList = genreListResponseValue;
    });
    page = 0;
    stillLoading = true;
    mediaGenreServiceGridCall(
            context, mediaGenreServiceGridRequest(page, selectedGenreList))
        .then((List<MediaGenre> responseValue) {
      stillLoading = false;
      if (Platform.isAndroid) {
        DeviceInfoPlugin()
            .androidInfo
            .then((AndroidDeviceInfo androidDeviceInfo) {
          if (androidDeviceInfo.version.sdkInt < 23) {
            _playerMode = PlayerMode.lowLatency;
          }
        });
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 0.8 ||
            _scrollController.offset >=
                    _scrollController.position.maxScrollExtent &&
                !_scrollController.position.outOfRange) {
          // reached to bottom
            if (stillLoading) {
              return;
            }
            stillLoading = true;
          page++;
          mediaGenreServiceGridCall(context,
                  mediaGenreServiceGridRequest(page, selectedGenreList))
              .then((List<MediaGenre> responseValue) {
            stillLoading = false;
            setState(() {
              mediaList.addAll(responseValue.map((e) => e.media!).toList());
            });
          });
        }
        // if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent * 1.2) {
        // move list
        // }
      });

      mediaList = [];
      mediaList.addAll(responseValue.map((e) => e.media!).toList());
      setState(() {
        if (mediaList.isNotEmpty) {
          media = mediaList[0];
        }
      });

      _audioPlayer.onDurationChanged.listen((event) {
        setState(() {
          _duration = event;
        });
      });
      _audioPlayer.onPositionChanged.listen((event) {
        setState(() {
          _position = event;
        });
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        if (!isLoop) {
          nextMedia();
        } else {
          _position = const Duration();
        }
      });
    });

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Container(
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
          body: landscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    musicPlayer(),
                    musicList(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    musicPlayer(),
                    musicList(),
                  ],
                ),
        ),
      );
    });
  }

  Widget musicList() {
    return Expanded(
      flex: 6,
      child: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 3,
                  child: RawScrollbar(
                    thumbColor: Colors.cyanAccent,
                    trackVisibility: true,
                    thickness: 3,
                    thumbVisibility: true,
                    controller: _genreScrollController,
                    child: ListView.builder(
                        controller: _genreScrollController,
                        itemCount: genreList.length,
                        itemBuilder: (context, index) {
                          if (index >= genreList.length) {
                            return const SizedBox();
                          }
                          Genre genreIndex = genreList[index];
                          return ListTile(
                            title: AnimatedContainer(
                              duration: const Duration(milliseconds: 900),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedGenreList.contains(genreIndex)
                                      ? Colors.cyan
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(genreIndex.name ?? "No-Name Genre",
                                    style: GoogleFonts.orbitron(
                                        fontSize: 14,
                                        color:
                                            selectedGenreList.contains(genreIndex)
                                                ? Colors.black87
                                                : Colors.cyan)),
                              ),
                            ),
                            onTap: (() {
                              bool removed = false;
                              for (int i = 0; i < selectedGenreList.length; i++) {
                                if (selectedGenreList[i].id == genreIndex.id) {
                                  selectedGenreList.removeAt(i);
                                  removed = true;
                                  break;
                                }
                              }
                              if (!removed) {
                                selectedGenreList.add(genreIndex);
                              }
                              page = 0;
                              mediaGenreServiceGridCall(
                                      context,
                                      mediaGenreServiceGridRequest(
                                          page, selectedGenreList))
                                  .then((List<MediaGenre> responseValue) {
                                setState(() {
                                  if (_audioPlayer.state == PlayerState.playing) {
                                    _audioPlayer.stop();
                                    _audioPlayer.state = PlayerState.stopped;
                                    _startButtonAnimationController.reverse();
                                  }
                                  _pageController.animateToPage(0,
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.easeIn);
                                  _scrollController.animateTo(0,
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.easeIn);

                                  _position = const Duration();
                                  _duration = const Duration();
                                  mediaList = [];
                                  mediaList.addAll(responseValue
                                      .map((e) => e.media!)
                                      .toList());

                                  if (mediaList.isNotEmpty) {
                                    media = mediaList[0];
                                  }
                                });
                              });
                            }),
                          );
                        }),
                  )),
              Flexible(
                flex: 9,
                child: RawScrollbar(
                  thumbColor: Colors.cyanAccent,
                  trackVisibility: true,
                  thickness: 3,
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        if (index >= mediaList.length) {
                          return const SizedBox();
                        }
                        Media mediaIndex = mediaList[index];
                        return AnimatedContainer(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: media?.id == mediaIndex.id
                                  ? Colors.cyan
                                  : Colors.transparent),
                          duration: const Duration(milliseconds: 900),
                          child: ListTile(
                            title: Text(
                              mediaIndex.name ?? "No-Name Music",
                              style: GoogleFonts.orbitron(
                                  fontSize: 14,
                                  color: media?.id == mediaIndex.id
                                      ? Colors.black87
                                      : Colors.cyan,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: CachedNetworkImage(
                              imageUrl: mediaIndex.mediaImage?.id != null
                                  ? getCodenfastMediaUrl(
                                      mediaIndex.mediaImage?.id)
                                  : getCodenfastMediaUrl(
                                      mediaIndex.mediaDownloadSource?.image?.id),
                              height: 172.0,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            subtitle: Text(
                              mediaIndex.attributionText ?? "",
                              style: GoogleFonts.orbitron(
                                  fontSize: 12, color: Colors.white70),
                            ),
                            isThreeLine: true,
                            trailing: null,
                            //const Icon(Icons.download, color: Colors.white70,),
                            onTap: (() {
                              if (_audioPlayer.state == PlayerState.playing) {
                                _audioPlayer.stop();
                                _audioPlayer.state = PlayerState.stopped;
                                _startButtonAnimationController.reverse();
                              }
                              _pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.easeIn);
                              media = mediaList[index];
                              _position = const Duration();
                              _duration = const Duration();
                              Source source =
                                  UrlSource(getCodenfastMediaUrl(media!.id));
                              _audioPlayer.play(source,
                                  position: _position,
                                  mode: PlayerMode.mediaPlayer);
                              _startButtonAnimationController.forward();
                            }),
                            onLongPress: (() async {
                              if (mediaIndex.attributionLink == null) {
                                return;
                              }
                              launchUrl(Uri.parse(mediaIndex.attributionLink!));
                            }),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget musicPlayer() {
    return Expanded(
      flex: 6,
      child: Container(
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            screen(),
            sliderScreen(),
            const SizedBox(
              height: 10,
            ),
            circleButtons()
          ],
        ),
      ),
    );
  }

  Widget screen() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  if (_audioPlayer.state != PlayerState.playing) Colors.black,
                  if (_audioPlayer.state != PlayerState.playing)
                    Colors.blueGrey,
                  if (_audioPlayer.state == PlayerState.playing)
                    colorList[(DateTime.now().second - 1) % colorList.length],
                  if (_audioPlayer.state == PlayerState.playing)
                    colorList[DateTime.now().second % colorList.length],
                  if (_audioPlayer.state == PlayerState.playing)
                    colorList[(DateTime.now().second + 2) % colorList.length],
                ]),
          ),
          child: Stack(children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: mediaList.length,
              onPageChanged: (page) {
                setState(() {
                  int currentPage = page.toInt();
                  if (_audioPlayer.state == PlayerState.playing) {
                    _audioPlayer.stop();
                    _startButtonAnimationController.reverse();
                  }
                  media = mediaList[currentPage];
                  _position = const Duration();
                  _duration = const Duration();
                  if (_audioPlayer.state != PlayerState.stopped &&
                      _audioPlayer.state != PlayerState.paused) {
                    Source source = UrlSource(getCodenfastMediaUrl(media!.id));
                    _audioPlayer.play(source,
                        position: _position, mode: PlayerMode.mediaPlayer);
                    _startButtonAnimationController.forward();
                    return;
                  }
                });
              },
              itemBuilder: (context, index) {
                Media media = mediaList[index];
                return MusicCard(
                    media: media, currentIdx: index, currentPage: currentPage);
              },
            ),
            if (media != null)
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 5, top: 20),
                child: Text(
                  "Music: ${turkishToEnglishLetters(media!.name ?? "No-Name Music")}",
                  style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      shadows: [
                        const BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 10)
                      ]),
                ),
              ),
            if (media != null && media!.attributionText != null)
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 5, top: 50),
                  child: Text(media!.attributionText!,
                      style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          shadows: [
                            const BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                                spreadRadius: 10)
                          ]))),
            if (media != null && media!.attributionLink != null)
              Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(left: 5, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(media!.attributionLink!));
                    },
                    child: Text(media!.attributionLink!,
                        style: GoogleFonts.orbitron(
                            textStyle: const TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                            shadows: [
                              const BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                  spreadRadius: 10)
                            ])),
                  )),
            if (media != null)
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.all(5),
                child: Text(
                  "${_position.toString().split('.').first.padLeft(8, "0")}/${_duration.toString().split('.').first.padLeft(8, "0")}",
                  style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                      shadows: [
                        const BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 10)
                      ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget sliderScreen() {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.black38,
              ]),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 1),
                offset: Offset(0, -2),
                blurRadius: 3,
                spreadRadius: 1),
            BoxShadow(
                color: Color.fromRGBO(200, 200, 200, 0.2),
                offset: Offset(0, 2),
                blurRadius: 3,
                spreadRadius: 1),
          ]),
      child: slider(),
    );
  }

  Widget circleButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                width: 2.0, color: Colors.black, style: BorderStyle.solid),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF222222),
                  Color(0xFF111111),
                ]),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, -2),
                  blurRadius: 3,
                  spreadRadius: 1),
              BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                  offset: Offset(0, 4),
                  blurRadius: 3,
                  spreadRadius: 1),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black,
                          ]),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white38,
                            offset: Offset(0, -2),
                            blurRadius: 12,
                            spreadRadius: -12),
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: -12),
                      ]),
                  child: previousButton(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black,
                          ]),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white38,
                            offset: Offset(0, -2),
                            blurRadius: 12,
                            spreadRadius: -12),
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: -12),
                      ]),
                  child: stopButton(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black,
                          ]),
                      boxShadow: [
                        BoxShadow(
                            color: ((_audioPlayer.state == PlayerState.playing && DateTime.now().second % 2 == 0)
                                ? Colors.cyan : Colors.transparent),
                            offset: const Offset(0, 0),
                            blurRadius: 12,
                            spreadRadius: 2),
                        const BoxShadow(
                            color: Colors.white38,
                            offset: Offset(0, -2),
                            blurRadius: 12,
                            spreadRadius: -12),
                        const BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: -12),
                      ]),
                  duration: const Duration(milliseconds: 999),
                  child: Container(
                      alignment: Alignment.center, child: startButton()),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black,
                          ]),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white38,
                            offset: Offset(0, -2),
                            blurRadius: 12,
                            spreadRadius: -12),
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: -12),
                      ]),
                  child: loopButton(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black,
                          ]),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white38,
                            offset: Offset(0, -2),
                            blurRadius: 12,
                            spreadRadius: -12),
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: -12),
                      ]),
                  child: nextButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (_audioPlayer.state == PlayerState.playing) {
            _audioPlayer.pause();
            _startButtonAnimationController.reverse();
          } else if (_position.inSeconds != 0) {
            _audioPlayer.play(UrlSource(getCodenfastMediaUrl(media!.id)),
                position: _position, mode: _playerMode);
            _startButtonAnimationController.forward();
          } else if (_audioPlayer.state != PlayerState.playing) {
            _position = const Duration();
            _audioPlayer.play(UrlSource(getCodenfastMediaUrl(media!.id)),
                position: _position, mode: _playerMode);
            _startButtonAnimationController.forward();
          }
        });
      },
      iconSize: 40,
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _startButtonAnimationController,
        color: Colors.cyan,
      ),
      // Icon(
      //   Icons.play_circle_fill,
      //   color: _audioPlayer.state == PlayerState.playing
      //       ? colorList[DateTime.now().second % colorList.length]
      //       : Colors.grey,
      //   shadows: [
      //     if (_audioPlayer.state == PlayerState.playing)
      //       BoxShadow(
      //           color: colorList[DateTime.now().second % colorList.length],
      //           offset: const Offset(0, 0),
      //           blurRadius: 5,
      //           spreadRadius: 12),
      //   ],
      // ),
    );
  }

  Widget previousButton() {
    return IconButton(
        iconSize: 40,
        onPressed: () {
          setState(() {
            int currentPage = (_pageController.page ?? 0).toInt();
            if (currentPage <= 0) {
              return;
            }
            if (_audioPlayer.state == PlayerState.playing) {
              _audioPlayer.stop();
              _startButtonAnimationController.reverse();
            }
            int newPage = (currentPage - 1).toInt();
            _pageController.animateToPage(newPage,
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeIn);
            media = mediaList[newPage];
            _position = const Duration();
            _duration = const Duration();
            if (_audioPlayer.state != PlayerState.stopped &&
                _audioPlayer.state != PlayerState.paused) {
              Source source = UrlSource(getCodenfastMediaUrl(media!.id));
              _audioPlayer.play(source,
                  position: _position, mode: PlayerMode.mediaPlayer);
              _startButtonAnimationController.forward();
              return;
            }
          });
        },
        icon: const Icon(
          Icons.fast_rewind,
          color: Colors.grey,
        ));
  }

  Widget nextButton() {
    return IconButton(
        iconSize: 40,
        onPressed: () {
          nextMedia();
        },
        icon: const Icon(
          Icons.fast_forward,
          color: Colors.grey,
        ));
  }

  void nextMedia() {
    setState(() {
      int currentPage = (_pageController.page ?? 0).toInt();
      int newPage = (currentPage + 1).toInt();
      if (newPage >= mediaList.length) {
        return;
      }
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.stop();
        _startButtonAnimationController.reverse();
      }
      _pageController.animateToPage(newPage,
          duration: const Duration(milliseconds: 900), curve: Curves.easeIn);
      media = mediaList[newPage];
      _position = const Duration();
      _duration = const Duration();
      if (_audioPlayer.state != PlayerState.stopped &&
          _audioPlayer.state != PlayerState.paused) {
        Source source = UrlSource(getCodenfastMediaUrl(media!.id));
        _audioPlayer.play(source,
            position: _position, mode: PlayerMode.mediaPlayer);
        _startButtonAnimationController.forward();
        return;
      }
    });
  }

  Widget loopButton() {
    return IconButton(
        iconSize: 40,
        onPressed: () {
          setState(() {
            isLoop = !isLoop;
            if (isLoop) {
              _audioPlayer.setReleaseMode(ReleaseMode.loop);
            } else {
              _audioPlayer.setReleaseMode(ReleaseMode.release);
            }
          });
        },
        icon: Icon(
          Icons.loop,
          color: isLoop ? Colors.blue : Colors.grey,
          shadows: [
            if (isLoop)
              const BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 12),
          ],
        ));
  }

  Widget stopButton() {
    return IconButton(
      iconSize: 40,
      onPressed: () {
        setState(() {
          _audioPlayer.stop();
          _startButtonAnimationController.reverse();
          _position = const Duration(milliseconds: 0);
          _audioPlayer.state = PlayerState.stopped;
        });
      },
      icon: Icon(Icons.stop,
          color: _audioPlayer.state == PlayerState.stopped
              ? Colors.blue
              : Colors.grey,
          shadows: [
            if (_audioPlayer.state == PlayerState.stopped)
              const BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 12),
          ]),
    );
  }

  Widget slider() {
    return _position.inSeconds.toDouble() >= 0 &&
            _position.inSeconds.toDouble() <= _duration.inSeconds.toDouble()
        ? Slider(
            activeColor: _duration.inSeconds > 0 ? Colors.cyan : Colors.grey,
            inactiveColor: Colors.grey,
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (double value) {
              if (_duration.inSeconds < 1) {
                return;
              }
              setState(() {
                _position = Duration(seconds: value.toInt());
                _audioPlayer.seek(_position);
              });
            },
          )
        : const SizedBox();
  }
}
