import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:developersuniverse_client/page/AudioPlaylistManager/audio-playlist-manager-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/MusicCard.dart';
import '../../models/common-model.dart';
import '../../services/common-service.dart';
import '../../webservices/audio-playlist-manager-service.dart';

class AudioPlaylistManager extends StatefulWidget {
  const AudioPlaylistManager({Key? key}) : super(key: key);

  @override
  State<AudioPlaylistManager> createState() => _AudioPlaylistManagerState();
}

class _AudioPlaylistManagerState extends State<AudioPlaylistManager>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<AudioPlaylistManager> {
  final c = Get.put(AudioPlaylistManagerController());
  bool landscape = false;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
    if(Platform.isLinux) {setState(() {});}
  }


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
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
                    thickness: 5,
                    thumbVisibility: true,
                    controller: c.genreScrollController,
                    child: Obx(
                      () => ListView.builder(
                          controller: c.genreScrollController,
                          itemCount: c.genreList.length,
                          itemBuilder: (context, index) {
                            if (index >= c.genreList.length) {
                              return const SizedBox();
                            }
                            Genre genreIndex = c.genreList[index];
                            return ListTile(
                              title: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        c.selectedGenreList.contains(genreIndex)
                                            ? Colors.cyan
                                            : Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                      genreIndex.name ?? "No-Name Genre",
                                      style: theme.textTheme().labelSmall?.copyWith(inherit: true,
                                          color: c.selectedGenreList.value.any((element) => element.id == genreIndex.id) ? Colors.white : Colors.cyanAccent)),
                                ),
                              ),
                              onTap: (() {
                                  c.genreListOnClick(context, genreIndex);
                                if(Platform.isLinux) {setState(() {});}})
                            );
                          }),
                    ),
                  )),
              Flexible(
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
                          return Obx(
                            () => AnimatedContainer(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: c.media?.value.id == mediaIndex.id
                                      ? Colors.cyan
                                      : Colors.transparent),
                              duration: const Duration(milliseconds: 200),
                              child: ListTile(
                                title: Text(
                                  mediaIndex.name ?? "No-Name Music",
                                  style: theme.textTheme().labelMedium?.copyWith(inherit: true, color: c.media?.value.id == mediaIndex.id
                                      ? Colors.black
                                      : Colors.cyan,
                                  shadows: c.media?.value.id == mediaIndex.id ? [] : theme.shadow()),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl: mediaIndex
                                              .mediaImage?.downloadedUrl !=
                                          null
                                      ? mediaIndex.mediaImage!.downloadedUrl!
                                      : mediaIndex.mediaImage?.id != null
                                          ? getCodenfastMediaUrl(
                                              mediaIndex.mediaImage?.id)
                                          : getCodenfastMediaUrl(mediaIndex
                                              .mediaDownloadSource?.image?.id),
                                  height: 172.0,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              color: Colors.cyan,
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                subtitle: Text(
                                  mediaIndex.attributionText ?? "",
                                  style: theme.textTheme().bodySmall,
                                ),
                                isThreeLine: true,
                                trailing: null,
                                //const Icon(Icons.download, color: Colors.white70,),
                                onTap: (() { c.mediaListOnClick(index);if(Platform.isLinux) {setState(() {});}}),
                                onLongPress: (() async {
                                  if (mediaIndex.attributionLink == null) {
                                    return;
                                  }
                                  launchUrl(
                                      Uri.parse(mediaIndex.attributionLink!));
                                }),
                              ),
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
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 5, top: 10),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turkishToEnglishLetters(c.media!.value.name ?? "No-Name Music"),
                          style: theme.textTheme().labelLarge?.copyWith(inherit: true, color: Colors.cyanAccent)
                        ),
                        if (c.media != null && c.media!.value.attributionText != null)
                          Expanded(
                          child: Obx(() => Text(c.media!.value.attributionText!,
                              style: theme.textTheme().bodySmall)),
                        )
                      ],
                    ),
                  ),
                ),
              // if (c.media != null && c.media!.value.attributionText != null)
              //   Container(
              //       alignment: Alignment.topLeft,
              //       margin: const EdgeInsets.only(left: 5, top: 60),
              //       child: Obx(() => Text(c.media!.value.attributionText!,
              //           style: theme.textTheme().bodySmall))),
              if (c.media != null && c.media!.value.attributionLink != null)
                Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(left: 5, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(c.media!.value.attributionLink!));
                      },
                      child: Obx(() => Text(c.media!.value.attributionLink!,
                          style: theme.textTheme().bodySmall?.copyWith(inherit: true, color: Colors.cyanAccent))),
                    )),
              if (c.media != null)
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(5),
                  child: Obx(
                    () => Text(
                      "${c.position.toString().split('.').first.padLeft(8, "0")}/${c.duration.toString().split('.').first.padLeft(8, "0")}",
    style: theme.textTheme().bodyMedium?.copyWith(inherit: true, color: Colors.cyanAccent)),
                    ),
                  ),
            ]),
          ),
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
      child: Obx(
        () => slider(),
      ),
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
                padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(8.0),
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
      onPressed: () {c.startButtonOnClick(); if(Platform.isLinux) {setState(() {});}},
      iconSize: 30,
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
        iconSize: 30,
        onPressed: (){ c.previousButtonOnClick(); if(Platform.isLinux) {setState(() {});}},
        icon: const Icon(
          Icons.fast_rewind,
          color: Colors.grey,
        ));
  }

  Widget nextButton() {
    return IconButton(
      iconSize: 30,
      onPressed: () {
        c.nextMedia();
        if(Platform.isLinux) {setState(() {});}
      },
      icon: const Icon(
        Icons.fast_forward,
        color: Colors.grey,
      ),
    );
  }

  Widget loopButton() {
    return IconButton(
      iconSize: 30,
      onPressed: () { c.loopButtonOnClick(); if(Platform.isLinux) {setState(() {});}},
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
      iconSize: 30,
      onPressed: () {c.stopButtonOnClick(); if(Platform.isLinux) {setState(() {});}},
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
        ? Slider(
            activeColor:
                c.duration.value.inSeconds > 0 ? Colors.cyan : Colors.grey,
            inactiveColor: Colors.grey,
            value: c.position.value.inSeconds.toDouble(),
            min: 0,
            max: c.duration.value.inSeconds.toDouble(),
            onChanged: (double value) => c.sliderOnChanged(value))
        : const SizedBox();
  }
}
