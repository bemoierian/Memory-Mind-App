import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaCard extends StatefulWidget {
  final String mediaURL;
  final String title;
  final Function onTapFunc;
  final bool isVideo;
  bool init;
  // final VideoPlayerController? videoPlayerController;
  MediaCard({
    required this.mediaURL,
    required this.title,
    required this.onTapFunc,
    required this.isVideo,
    required this.init,
    // this.videoPlayerController,
    super.key,
  });

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  VideoPlayerController? _controller;
  VideoPlayerController? _dialogController;

  void _initVideoPlayer() async {
    if (!_controller!.value.isInitialized) {
      await _controller!.initialize();
      setState(() {
        // debugPrint("Initialized Video Player 1");
        _controller!.setVolume(0);
        _controller!.pause();
      });
    }
    if (!_dialogController!.value.isInitialized) {
      await _dialogController!.initialize();
      setState(() {
        // debugPrint("Initialized Video Player 2");
        _dialogController!.pause();
      });
    }

    // generate thumbnail
    // widget.videoThumbnailFileName = await VideoThumbnail.thumbnailFile(
    //   video: widget.mediaURL,
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.WEBP,
    //   maxHeight:
    //       200, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 75,
    // );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _initVideoPlayer();
    if (widget.init) {
      debugPrint("Init State, isVideo: ${widget.isVideo}");
      if (widget.isVideo) {
        if (_controller != null) {
          _controller!.dispose();
        }
        if (_dialogController != null) {
          _dialogController!.dispose();
        }
        _controller = VideoPlayerController.network(widget.mediaURL);
        _dialogController = VideoPlayerController.network(widget.mediaURL);
        _initVideoPlayer();
      }
      widget.init = false;
    }
    return GestureDetector(
      onTap: () {
        widget.onTapFunc(_dialogController);
        debugPrint("Tapped on Media Card");
      },
      child: Container(
        width: 200,
        height: 200,
        // color: Colors.grey.shade200,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image
            SizedBox(
              width: 200,
              height: 200,
              child: !widget.isVideo
                  ? Image(
                      image: NetworkImage(widget.mediaURL),
                      fit: BoxFit.cover,
                    )
                  : _controller != null && _controller!.value.isInitialized
                      ? GestureDetector(
                          onTap: () {
                            widget.onTapFunc(_dialogController);
                            debugPrint("Tapped on Media Card");
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              ),
                              const Icon(
                                Icons.play_arrow,
                                size: 50,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
            ),
            const SizedBox(height: 20),
            Text(widget.title),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isVideo) {
      _controller!.dispose();
      _dialogController!.dispose();
    }
  }
}
