import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app/models/video_data_model.dart';
import 'package:test_app/utils/constants.dart' as Const;
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final VideoDataModel videoDataModel;
  final int pageIndex;
  final int currentPageIndex;
  bool isPaused;
  bool isVideoPaused = false;

  VideoWidget(
      {Key key,
      @required this.videoDataModel,
      @required this.play,
      @required this.currentPageIndex,
      @required this.pageIndex,
      @required this.isPaused})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool initialized = false;
  static const Color black = Color(0xA6000000);

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    _controller = VideoPlayerController.network(
      widget.videoDataModel.url,
    );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        _controller.setLooping(true);
        initialized = true;
      });
    });

    // Use the controller to loop the video.
    _controller.setLooping(widget.play);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    print(
        "CALL>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused &&
        initialized) {
      _controller.play();
    } else {
      _controller.pause();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black
              ])),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.pink])),
          child: Center(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return InkWell(
                    child: VideoPlayer(_controller),
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          widget.isPaused = true;
                          widget.isVideoPaused = true;
                        } else {
                          widget.isPaused = false;
                          widget.isVideoPaused = false;
                        }
                      });
                    },
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        Center(
          child: Visibility(
            child: Image.asset(
              Const.IMAGES_IC_PLAY,
              width: 100,
              height: 100,
            ),
            visible: widget.isVideoPaused,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.videoDataModel.userModel.name}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${widget.videoDataModel.title}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getImageWidget(Const.IMAGES_IC_MUSIC_4),
                    _getImageWithTextWidget(
                        Const.IMAGES_IC_DISLIKE, widget.videoDataModel.like),
                    _getImageWithTextWidget(
                        Const.IMAGES_IC_COMMENT, widget.videoDataModel.comment),
                    _getImageWithTextWidget(
                        Const.IMAGES_IC_SHARE, widget.videoDataModel.share),
                    _getImageFromURLWidget(widget.videoDataModel.userModel.headshot),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _getImageWithTextWidget(String img, int txt) {
    return Column(
      children: [
        Image.asset(
          img,
          width: 40,
          height: 40,
        ),
        Text(
          '${txt}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  _getImageWidget(String img) {
    return Column(
      children: [
        Image.asset(
          img,
          width: 50,
          height: 50,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  _getImageFromURLWidget(String image_url) {
    return Column(
      children: [
        ClipOval(
          child: FadeInImage(
            height: 50,
            width: 50,
            image: NetworkImage(image_url),
            placeholder: AssetImage(Const.IMAGES_IC_MUSIC_1),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
