import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/common-model.dart';

class AudioPlaylistManagerController extends GetxController {
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
}