import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_rest_api/consts/api_consts.dart';
import 'package:news_app_rest_api/consts/http_exceptions.dart';
import 'package:news_app_rest_api/models/bookmarks_model.dart';
import 'package:news_app_rest_api/models/news_model.dart';
import 'dart:developer';

class NewsApiServices {
  // future metoda za parse url
  // metoda je typa List<NewsModel>
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    // stavljamo parse umjesto http
    // var url = Uri.parse(
    //     // mozemo ubaciti parameter => &pageSize=5&
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=a4f7ea388a7c4338aa28c83bb7d46513');

    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/everything',
        {
          'q': 'bitcoin',
          'pageSize': '5',
          //'domains': 'bbc.co.uk,techcrunch.com,engadget.com',
          // (iz api provider docs) moramo int prebaciti u string
          'page': page.toString(),
          'sortBy': sortBy,
          //'apiKey': API_KEY
        },
      );
      var response = await http.get(uri, headers: {
        //u newsApi stranici je napisano da se koristi 'X-Api-key' za api key
        'X-Api-key': API_KEY
      });
      log('Response status: ${response.statusCode}');
      // log -> dart:developer
      //log('Response body: ${response.body}');
      // moramo decodati response body zato sto je tipa json
      Map data = jsonDecode(response.body);

      // na stranici api provajdera u docs je objasnjenje za error handling
      if (data['code'] != null) {
        //throw data['message'];
        throw HttpExceptions(data['code']);
      }

      // inicijaliziramo listu u koju cemo dodavati map data kad loop data
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data['articles'].length.toString());

      }
      // vracamo newsFromSnapshot koja je type list zato sto je getAllNews
      // type Future<List<NewsModel>>
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (e) {
      throw e.toString();
    }
  }

  // metoda za pribavljanje topHeadlines (Api provider)
  static Future<List<NewsModel>> getTopHeadlines() async {
    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/top-headlines',
        {
          'country': 'rs'
          //'apiKey': API_KEY
        },
      );
      var response = await http.get(uri, headers: {
        //u newsApi stranici je napisano da se koristi 'X-Api-key' za api key
        'X-Api-key': API_KEY
      });
      log('Response status: ${response.statusCode}');
      // log -> dart:developer
      //log('Response body: ${response.body}');
      // moramo decodati response body zato sto je tipa json
      Map data = jsonDecode(response.body);

      // na stranici api provajdera u docs je objasnjenje za error handling
      if (data['code'] != null) {
        //throw data['message'];
        throw HttpExceptions(data['code']);
      }

      // inicijaliziramo listu u koju cemo dodavati map data kad loop data
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data['articles'].length.toString());

      }
      // vracamo newsFromSnapshot koja je type list zato sto je getAllNews
      // type Future<List<NewsModel>>
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (e) {
      throw e.toString();
    }
  }

  // ,metoda za koristenje search
  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/everything',
        {
          'q': query,
          'pageSize': '10',
          //'domains': 'bbc.co.uk,techcrunch.com,engadget.com',
          // (iz api provider docs) moramo int prebaciti u string
        },
      );
      var response = await http.get(uri, headers: {
        //u newsApi stranici je napisano da se koristi 'X-Api-key' za api key
        'X-Api-key': API_KEY
      });
      log('Response status: ${response.statusCode}');
      // log -> dart:developer
      //log('Response body: ${response.body}');
      // moramo decodati response body zato sto je tipa json
      Map data = jsonDecode(response.body);

      // na stranici api provajdera u docs je objasnjenje za error handling
      if (data['code'] != null) {
        //throw data['message'];
        throw HttpExceptions(data['code']);
      }

      // inicijaliziramo listu u koju cemo dodavati map data kad loop data
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data['articles'].length.toString());

      }
      // vracamo newsFromSnapshot koja je type list zato sto je getAllNews
      // type Future<List<NewsModel>>
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (e) {
      throw e.toString();
    }
  }

  // za dobijanje dat iz database bookmarks unos
  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, 'bookmarks.json');
      var response = await http.get(
        uri,
      );
      // json ce biti map
      Map data = jsonDecode(response.body);
      List allKeys = [];

      if (data['code'] != null) {
        throw HttpExceptions(data['code']);
      }
      for (String key in data.keys) {
        allKeys.add(key);
      }
      log('allKeys : $allKeys');
      return BookmarksModel.bookmarksFromSnapshot(json: data, allKeys: allKeys);
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
    } catch (e) {
      rethrow;
    }
  }
}
