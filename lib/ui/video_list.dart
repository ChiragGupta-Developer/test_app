import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:preload_page_view/preload_page_view.dart';
import 'package:test_app/models/video_data_model.dart';
import 'package:test_app/ui/video_widget.dart';
import 'package:test_app/utils/constants.dart' as Const;

class MyVideoPage extends StatefulWidget {
  @override
  _MyVideoPageState createState() => _MyVideoPageState();
}

class _MyVideoPageState extends State<MyVideoPage> {
  Future<List<VideoDataModel>> videoList;

  PreloadPageController _controller;
  int current = 0;
  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _controller.page == _controller.page.roundToDouble()) {
      setState(() {
        current = _controller.page.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning && current.toDouble() != _controller.page) {
      if ((current.toDouble() - _controller.page).abs() > 0.1) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoList = fetchVideo();
    _controller = PreloadPageController();
    _controller.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.pink])),
        child: Center(
          child: FutureBuilder<List<VideoDataModel>>(
              future: videoList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
//                  return Text(snapshot.data[0].url);
                  return PreloadPageView.builder(
                    controller: _controller,
                    itemBuilder: (context, position) {
                      return VideoWidget(
                        videoDataModel: snapshot.data[position],
                        play: true,
                        pageIndex: position,
                        currentPageIndex: current,
                        isPaused: isOnPageTurning,
                      );
                    },
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    preloadPagesCount: 2,
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(
                    "Something went wrong...\nPlease Try again later...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Future<List<VideoDataModel>> fetchVideo() async {
    var response = await http.get(Const.API_URL);

    if (response.statusCode == 200) {
      print('Response :  ${json.decode(response.body)}');
      var data = json.decode(response.body) as List;
      return data.map((value) => new VideoDataModel.fromJson(value)).toList();
    } else {
      // then throw an exception.
      return null;
//      throw Exception('Failed to load album');
    }
  }
}
