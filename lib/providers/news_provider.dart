import 'package:flutter/material.dart';
import 'package:news_app_rest_api/services/news_api.dart';

import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];
  List<NewsModel> get getNewsList {
    return newsList;
  }

  // pravimo future metodu koja prikuplja data iz api providera i smjesta ulistu
  Future<List<NewsModel>> fetchAllNews(
      {required int pageIndex, required String sortBy}) async {
    newsList =
        await NewsApiServices.getAllNews(page: pageIndex, sortBy: sortBy);
    return newsList;
  }

  // ne moyemo koristiti id posto je isti za sve, moramo koristiti publishedAt kao id
  NewsModel findByDate({required String? publishedAt}) {
    return newsList
        .firstWhere((newsModel) => newsModel.publishedAt == publishedAt);
  }

  // pravimo future metodu za dobijanje top headlines
  Future<List<NewsModel>> fetchTopheadlines() async {
    newsList = await NewsApiServices.getTopHeadlines();
    return newsList;
  }

  // pravimo future metodu za search news
  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsApiServices.searchNews(query: query);
    return newsList;
  }
}
