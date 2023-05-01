import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:developersuniverse_client/page/AudioPlaylistManager/audio_playlist_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/music_card.dart';
import '../../models/common_model.dart';
import '../../services/common_service.dart';

class AudioPlaylistManager extends StatefulWidget {
  const AudioPlaylistManager({Key? key}) : super(key: key);

  @override
  State<AudioPlaylistManager> createState() => _AudioPlaylistManagerState();
}

class _AudioPlaylistManagerState extends State<AudioPlaylistManager>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AudioPlaylistManager> {
  final c = Get.put(AudioPlaylistManagerController());
  bool landscape = false;
  late Size size;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
    if (Platform.isLinux) {
      setState(() {});
    }
    c.audioPlayer.value.onDurationChanged.listen(onDurationChanged);
    c.audioPlayer.value.onPositionChanged.listen(onPositionChanged);
    c.audioPlayer.value.onPlayerComplete.listen(onPlayerCompleted);
  }

  @override
  bool get wantKeepAlive => true;

  void onDurationChanged(Duration event) {
    c.duration.value = event;
    c.duration.refresh();
  }

  void onPositionChanged(Duration event) {
    c.position.value = event;
    c.position.refresh();
  }

  void onPlayerCompleted(event) {
    c.nextMedia(onDurationChanged, onPositionChanged, onPlayerCompleted);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: OrientationBuilder(builder: (context, orientation) {
        landscape = orientation == Orientation.landscape;
        return Scaffold(
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
        );
      }),
    );
  }

  Widget musicList() {
    return Expanded(
      flex: 6,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
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
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          style: theme.negativeButtonStyle(),
                          onPressed: () {
                            showSelectionDialog(
                                context,
                                "Select Genre",
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: c.genreList.value.length,
                                    itemBuilder: (context, index) {
                                      Genre genre = c.genreList.value[index];
                                      return Obx(
                                        () => AnimatedContainer(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: c.selectedGenreList.value
                                                      .contains(genre)
                                                  ? Colors.cyan
                                                  : Colors.transparent),
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: CheckboxListTile(
                                            value: c.selectedGenreList.value
                                                .contains(genre),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (value != null && !value) {
                                                  c.selectedGenreList.value
                                                      .remove(genre);
                                                } else {
                                                  c.selectedGenreList.value
                                                      .add(genre);
                                                }
                                                c.selectedGenreList.refresh();
                                              });
                                            },
                                            title: Text(
                                              genre.name!,
                                              style: theme
                                                  .textTheme()
                                                  .labelMedium
                                                  ?.copyWith(
                                                      inherit: true,
                                                      color: c.selectedGenreList
                                                              .value
                                                              .contains(genre)
                                                          ? Colors.black
                                                          : Colors.white,
                                                      shadows: c
                                                              .selectedGenreList
                                                              .value
                                                              .contains(genre)
                                                          ? []
                                                          : theme.shadow()),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                description:
                                    "Filter what you want to listen genre",
                                actionButtons: <TextButton>[
                                  TextButton(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2.0,
                                                color: Colors.black),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFF222222),
                                                  Color(0xFF111111),
                                                ]),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.red,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Clear All',
                                            style: theme.textTheme().bodyMedium,
                                          ),
                                        )),
                                    onPressed: () {
                                      c.selectedGenreList.value = [];
                                      c.selectedGenreList.refresh();
                                    },
                                  ),
                                  TextButton(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2.0,
                                                color: Colors.black),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFF222222),
                                                  Color(0xFF111111),
                                                ]),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.red,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Select All',
                                            style: theme.textTheme().bodyMedium,
                                          ),
                                        )),
                                    onPressed: () {
                                      c.selectedGenreList.value = c.genreList.value;
                                      c.selectedGenreList.refresh();
                                    },
                                  ),
                                  TextButton(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2.0,
                                                color: Colors.black),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.cyan,
                                                  Colors.cyan,
                                                ]),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.red,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Done',
                                            style: theme.textTheme().bodyMedium,
                                          ),
                                        )),
                                    onPressed: () {
                                      c.onFilter(context);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]);
                          },
                          child: Text(
                            "Genre",
                            style: theme.textTheme().bodyMedium!,
                          ),
                        )
                        ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        onChanged: (text) {
                          c.musicListTextFilter = text;
                          c.onFilter(context);},
                        style: theme.inputFieldStyle(),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.5),
                          labelText: "Search",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: RawScrollbar(
                  thumbColor: Colors.cyanAccent,
                  trackVisibility: true,
                  thickness: 5,
                  thumbVisibility: true,
                  controller: c.scrollController,
                  child: Obx(
                    () => ListView.builder(
                        controller: c.scrollController,
                        itemCount: c.mediaList.length,
                        itemBuilder: (context, index) {
                          if (index >= c.mediaList.length) {
                            return const SizedBox();
                          }
                          Media mediaIndex = c.mediaList[index];
                          return AnimatedContainer(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: c.media?.value.id == mediaIndex.id
                                    ? Colors.cyan
                                    : Colors.transparent),
                            duration: const Duration(milliseconds: 200),
                            child: ListTile(
                              title: Text(
                                mediaIndex.name ?? "No-Name Music",
                                style: theme.textTheme().labelMedium?.copyWith(
                                    inherit: true,
                                    color: c.media?.value.id == mediaIndex.id
                                        ? Colors.black
                                        : Colors.cyan,
                                    shadows: c.media?.value.id == mediaIndex.id
                                        ? []
                                        : theme.shadow()),
                              ),
                              subtitle: Text(
                                mediaIndex.attributionText ?? "",
                                style: theme.textTheme().bodySmall,
                              ),
                              isThreeLine: false,
                              trailing: null,
                              //const Icon(Icons.download, color: Colors.white70,),
                              onTap: (() {
                                setState(() {
                                  c.mediaListOnClick(index, onDurationChanged,
                                      onPositionChanged, onPlayerCompleted);
                                });
                              }),
                              onLongPress: (() async {
                                if (mediaIndex.attributionLink == null) {
                                  return;
                                }
                                launchUrl(
                                    Uri.parse(mediaIndex.attributionLink!));
                              }),
                            ),
                          );
                        }),
                  ),
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
            borderRadius: BorderRadius.circular(10),
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
            screen(),
            volumeSliderScreen(),
            if (c.duration.value.inSeconds > 0) sliderScreen(),
            circleButtons()
          ],
        ),
      ),
    );
  }

  Widget screen() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    if (c.audioPlayer.value.state != PlayerState.playing)
                      Colors.black,
                    if (c.audioPlayer.value.state != PlayerState.playing)
                      Colors.blueGrey,
                    if (c.audioPlayer.value.state == PlayerState.playing)
                      colorList[
                          (c.position.value.inSeconds - 1) % colorList.length],
                    if (c.audioPlayer.value.state == PlayerState.playing)
                      colorList[c.position.value.inSeconds % colorList.length],
                    if (c.audioPlayer.value.state == PlayerState.playing)
                      colorList[
                          (c.position.value.inSeconds + 2) % colorList.length],
                  ]),
            ),
            child: Stack(children: [
              PageView.builder(
                controller: c.pageController,
                scrollDirection: Axis.horizontal,
                itemCount: c.mediaList.length,
                physics: const NeverScrollableScrollPhysics(),
                // onPageChanged: (page) => c.onPageChanged(page),
                itemBuilder: (context, index) {
                  Media media = c.mediaList[index];
                  return Obx(
                    () => MusicCard(
                        media: media,
                        currentIdx: index,
                        currentPage: c.currentPage.value!),
                  );
                },
              ),
              if (c.media != null)
                AnimatedContainer(
                  height: 40,
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 5, top: 5),
                  decoration: BoxDecoration(
                      color: theme.cyanTransparent.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Obx(
                    () => AnimatedTextKit(
                      onTap: () {
                        if (c.media != null &&
                            c.media!.value.attributionLink != null) {
                          launchUrl(Uri.parse(c.media!.value.attributionLink!));
                        }
                      },
                      repeatForever: true,
                      animatedTexts: [
                        RotateAnimatedText(
                            turkishToEnglishLetters(
                                c.media!.value.name ?? "No-Name Music"),
                            duration: const Duration(seconds: 4),
                            textStyle: theme.textTheme().labelLarge?.copyWith(
                                inherit: true, color: Colors.cyanAccent)),
                        if (c.media != null &&
                            c.media!.value.attributionText != null)
                          RotateAnimatedText(c.media!.value.attributionText!,
                              duration: const Duration(seconds: 2),
                              textStyle: theme.textTheme().bodySmall),
                        if (c.media != null &&
                            c.media!.value.attributionLink != null)
                          RotateAnimatedText(c.media!.value.attributionLink!,
                              duration: const Duration(seconds: 2),
                              textStyle: theme.textTheme().bodySmall?.copyWith(
                                  inherit: true, color: Colors.cyanAccent)),
                      ],
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget volumeSliderScreen() {
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
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 70,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                              c.audioPlayerVolume.value > 0.7
                                  ? Icons.volume_up
                                  : c.audioPlayerVolume.value != 0
                                      ? Icons.volume_down
                                      : Icons.volume_off,
                              color: Colors.white),
                          Text("${(c.audioPlayerVolume.value * 100).toInt()}",
                              style: theme.textTheme().bodyMedium?.copyWith(
                                  inherit: true, color: Colors.cyanAccent)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Slider(
                      activeColor: Colors.yellow,
                      inactiveColor: Colors.grey,
                      value: c.audioPlayerVolume.value,
                      min: 0,
                      max: 1,
                      onChanged: (double value) {
                        c.audioPlayer.value.setVolume(value);
                        c.audioPlayerVolume.value = value;
                      }),
                ),
              ],
            )));
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 150,
              child: Obx(
                () => Text(
                    "${c.position.toString().split('.').first.padLeft(8, "0")}/ ${c.duration.toString().split('.').first.padLeft(8, "0")}",
                    style: theme
                        .textTheme()
                        .bodyMedium
                        ?.copyWith(inherit: true, color: Colors.cyanAccent)),
              ),
            ),
          ),
          Expanded(child: slider()),
        ],
      ),
    );
  }

  Widget circleButtons() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.all(4.0),
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
                padding: const EdgeInsets.all(4.0),
                child: Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
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
                              color: ((c.audioPlayer.value.state ==
                                      PlayerState.stopped)
                                  ? Colors.cyan
                                  : Colors.transparent),
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
                    child: stopButton(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Obx(
                  () => AnimatedContainer(
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
                              color: ((c.audioPlayer.value.state ==
                                          PlayerState.playing &&
                                      c.position.value.inSeconds % 2 == 0)
                                  ? Colors.cyan
                                  : Colors.transparent),
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
                    duration: const Duration(seconds: 1),
                    child: Container(
                        alignment: Alignment.center, child: startButton()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
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
                              color: ((c.isLoop.isTrue)
                                  ? Colors.cyan
                                  : Colors.transparent),
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
                    child: loopButton(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
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
          c.startButtonOnClick(
              onDurationChanged, onPositionChanged, onPlayerCompleted);
        });
      },
      iconSize: 25,
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: c.startButtonAnimationController,
        color: c.audioPlayer.value.state == PlayerState.playing
            ? Colors.cyan
            : Colors.grey,
      ),
    );
  }

  Widget previousButton() {
    return IconButton(
        iconSize: 25,
        onPressed: () {
          setState(() {
            c.previousButtonOnClick(
                onDurationChanged, onPositionChanged, onPlayerCompleted);
          });
        },
        icon: const Icon(
          Icons.fast_rewind,
          color: Colors.grey,
        ));
  }

  Widget nextButton() {
    return IconButton(
      iconSize: 25,
      onPressed: () {
        setState(() {
          c.nextMedia(onDurationChanged, onPositionChanged, onPlayerCompleted);
        });
      },
      icon: const Icon(
        Icons.fast_forward,
        color: Colors.grey,
      ),
    );
  }

  Widget loopButton() {
    return IconButton(
      iconSize: 25,
      onPressed: () {
        c.loopButtonOnClick();
        if (Platform.isLinux) {
          setState(() {});
        }
      },
      icon: Icon(
        Icons.loop,
        color: c.isLoop.isTrue ? Colors.cyan : Colors.grey,
        shadows: [
          if (c.isLoop.isTrue)
            const BoxShadow(
                color: Colors.cyan,
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 12),
        ],
      ),
    );
  }

  Widget stopButton() {
    return IconButton(
      iconSize: 25,
      onPressed: () {
        setState(() {
          c.stopButtonOnClick();
        });
      },
      icon: Obx(() => Icon(Icons.stop,
              color: c.audioPlayer.value.state == PlayerState.stopped
                  ? Colors.cyan
                  : Colors.grey,
              shadows: [
                if (c.audioPlayer.value.state == PlayerState.stopped)
                  const BoxShadow(
                      color: Colors.cyan,
                      offset: Offset(0, 0),
                      blurRadius: 5,
                      spreadRadius: 12),
              ])),
    );
  }

  Widget slider() {
    return c.position.value.inSeconds.toDouble() >= 0 &&
            c.position.value.inSeconds.toDouble() <=
                c.duration.value.inSeconds.toDouble()
        ? Obx(() => Slider(
            activeColor:
                c.duration.value.inSeconds > 0 ? Colors.cyan : Colors.grey,
            inactiveColor: Colors.grey,
            value: c.position.value.inSeconds.toDouble(),
            min: 0,
            max: c.duration.value.inSeconds.toDouble(),
            onChanged: (double value) => c.sliderOnChanged(value)))
        : const SizedBox();
  }
}
