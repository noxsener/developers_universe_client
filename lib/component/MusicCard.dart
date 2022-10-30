import 'package:cached_network_image/cached_network_image.dart';
import 'package:developersuniverse_client/services/connection-service.dart';
import 'package:flutter/material.dart';

import '../models/common-model.dart';

class MusicCard extends StatelessWidget {
  final Media media;
  final int currentIdx;
  final double currentPage;
  const MusicCard({Key? key, required this.media, required this.currentIdx, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIdx - currentPage;
    return SizedBox(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
            ..setEntry(3,2,0.003)
            ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6)+ 0.4)
            ..rotateY(relativePosition),
        alignment: relativePosition >= 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
              fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    media.mediaImage?.id != null ? getCodenfastMediaUrl(media.mediaImage!.id) : getCodenfastMediaUrl(media.mediaDownloadSource?.image?.id),
                  ),
              )
            ),
      ),
      ),
    );
  }
}
