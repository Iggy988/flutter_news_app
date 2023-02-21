import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_rest_api/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

/// da bi koristili NewsModel kao data class za provider moramo dodati ChangeNotifier
class NewsModel with ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      readingTimeText;

  NewsModel(
      {required this.newsId,
      required this.sourceName,
      required this.authorName,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.dateToShow,
      required this.content,
      required this.readingTimeText});

  factory NewsModel.fromJson(dynamic json) {
    // pravimo title, content, description varijablu da bi je mogli ubaciti u reading time
    String title = json['title'] ?? '';
    String content = json['content'] ?? '';
    String description = json['description'] ?? '';
    // pravimo varijablu za prikazivanje vremena
    // ako nema teksta za formatirati onda ce prikazivati empty String
    String dateToShow = '';
    if (json['publishedAt'] != null) {
      dateToShow = GlobalMethods.formattedDateText(json['publishedAt']);
    }
    return NewsModel(
      newsId: json["source"]['id'] ?? '',
      // ako je null stavljamo empty string,
      sourceName: json['source']['name'] ?? '',
      authorName: json['author'] ?? '',
      title: title,
      description: description,
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ??
          'https://techcrunch.com/wp-content/uploads/2022/01/locket-app.jpg?w=1390&crop=1',
      publishedAt: json['publishedAt'] ?? '',
      content: content,
      dateToShow: dateToShow,
      // koristimo package reading_time
      // uvijek ce prikazivati less than a minute zato sto je content ogrnicen u api od strane dobavljaca
      readingTimeText: readingTime(title + description + content).msg,
    );
  }

  // newSnapshot sadrzi map koji u sebi ima sve keys iz fromJson
  static List<NewsModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      // da ne bi svaki put dodavali NewsModel sa parametrima, napravilismo fromJson
      return NewsModel.fromJson(json);
      // prebacujemo u listu zato sto je tipa List: da bi bilo iterable
    }).toList();
  }

  // pretvaranje u map (to Json)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["newsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["dateToShow"] = dateToShow;
    data["content"] = content;
    data["readingTimeText"] = readingTimeText;
    return data;
  }

  // ukoliko se tekst u app ne bude pravilno prikazao, moramo
  // override method toString da bi se mogao pravilno prikazati
  // @override
  // String toString() {
  //   return 'news {newsId: $newsId}';
  // }
}
