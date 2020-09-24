import 'dart:convert';

import 'package:test_app/models/user_model.dart';

class VideoDataModel {
  String url;
  int comment;
  int like;
  int share;
  String title;
  UserModel userModel;

  VideoDataModel(
      {this.url,
      this.comment,
      this.like,
      this.share,
      this.title,
      this.userModel});

  factory VideoDataModel.fromJson(Map<String, dynamic> data) {
    return VideoDataModel(
      url: data['url'],
      comment: data['comment-count'],
      like: data['like-count'],
      share: data['share-count'],
      title: data['title'],
      userModel: UserModel.fromJson(data['user']),
    );
  }
}
