import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app_rest_api/models/news_model.dart';
import '../consts/api_consts.dart';
import 'package:http/http.dart' as http;

import '../models/bookmarks_model.dart';
import '../services/news_api.dart';

class BookmarksProvider with ChangeNotifier {
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, 'bookmarks.json');
      var response = await http.post(
        uri,
        body: json.encode(newsModel.toJson()),
      );
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      rethrow;
    }
  }

  // pravimo future metodu koja prikuplja data iz api providera i smjesta ulistu
  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookmarkList = await NewsApiServices.getBookmarks() ?? [];
    notifyListeners();
    return bookmarkList;
  }

  Future<void> deleteBookmark({required String key}) async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, 'bookmarks/$key.json');
      var response = await http.delete(
        uri,
      );
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      rethrow;
    }
  }
}
