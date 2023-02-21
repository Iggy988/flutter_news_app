import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_rest_api/consts/vars.dart';
import 'package:news_app_rest_api/inner_screens/search_screen.dart';
import 'package:news_app_rest_api/providers/news_provider.dart';
import 'package:news_app_rest_api/services/news_api.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:news_app_rest_api/widgets/articles_widget.dart';
import 'package:news_app_rest_api/widgets/drawer_widget.dart';
import 'package:news_app_rest_api/widgets/empty_screen_widget.dart';
import 'package:news_app_rest_api/widgets/loading_widget.dart';
import 'package:news_app_rest_api/widgets/tabs.dart';
import 'package:news_app_rest_api/widgets/top_trending.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/news_model.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;

  /*
  @override
  void didChangeDependencies() {
    getNewsList();
    super.didChangeDependencies();
  }

  // getAllNews je of type List<Future>, zato moramo da ubacimo u Future method  newsList
  // koju cemo pozivati u didChangeDependencies()
  Future<List<NewsModel>> getNewsList() async {
    List<NewsModel> newsList = await NewsApiServices.getAllNews();
    return newsList;
  }
  */

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;

    /// koristimo provider za stateManagment
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Text(
              "News App",
              style: GoogleFonts.lobster(
                  textStyle: TextStyle(
                      color: color, fontSize: 20, letterSpacing: 0.6)),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SearchScreen(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                icon: Icon(IconlyLight.search))
          ],
        ),
        drawer: DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              VerticalSpacing(12),
              Row(
                children: [
                  TabsWidget(
                      text: 'All news',
                      color: newsType == NewsType.allNews
                          ? Theme.of(context).cardColor
                          : Colors.transparent,
                      function: () {
                        // provjeravamo da li je newsType == NewsType.allNews
                        if (newsType == NewsType.allNews) {
                          // ako jeste samo ga vracamo
                          return;
                        }
                        // u suprotnom namjestamo newsType == NewsType.allNews
                        setState(() {
                          newsType = NewsType.allNews;
                        });
                      },
                      fontSize: newsType == NewsType.allNews ? 22 : 14),
                  SizedBox(
                    width: 25,
                  ),
                  TabsWidget(
                      text: 'Top trending',
                      color: newsType == NewsType.topTrending
                          ? Theme.of(context).cardColor
                          : Colors.transparent,
                      function: () {
                        // provjeravamo da li je newsType == NewsType.allNews
                        if (newsType == NewsType.topTrending) {
                          // ako jeste samo ga vracamo
                          return;
                        }
                        // u suprotnom namjestamo newsType == NewsType.allNews
                        setState(() {
                          newsType = NewsType.topTrending;
                        });
                      },
                      fontSize: newsType == NewsType.topTrending ? 22 : 14),
                ],
              ),
              VerticalSpacing(10),
              // ako je all news onda se prikazuje paggination button
              newsType == NewsType.topTrending
                  ? Container()
                  : SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          paginationButtons(
                              function: () {
                                setState(() {
                                  if (currentPageIndex == 0) {
                                    return;
                                  }
                                  currentPageIndex -= 1;
                                });
                              },
                              text: 'Prev'),
                          Flexible(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // stavljamo material widget da se vidi inkwel press
                                  child: Material(
                                    color: currentPageIndex == index
                                        ? Colors.blue
                                        : Theme.of(context).cardColor,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentPageIndex = index;
                                        });
                                      },
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              color: currentPageIndex == index
                                                  ? Colors.white
                                                  : Colors.grey),
                                        ),
                                      )),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          paginationButtons(
                              function: () {
                                setState(() {
                                  if (currentPageIndex == 4) {
                                    return;
                                  }
                                  currentPageIndex += 1;
                                });
                              },
                              text: 'Next'),
                        ],
                      ),
                    ),
              const VerticalSpacing(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                              value: sortBy,
                              items: dropDownItems,
                              onChanged: (String? value) {
                                // dobijamo value iz:
                                // DropdownMenuItem(
                                //   value: SortByEnum.relevance.name,
                                //   child: Text(SortByEnum.relevance.name),
                                // ),
                                setState(() {
                                  sortBy = value!;
                                });
                              }),
                        ),
                      ),
                    ),

              /**
                  ako je stranica allNews -> stavljamo -> LoadingWidget()
                  ako je stranica topTrending -> stavljamo -> Expanded( child:LoadingWidget())
                  zbog overflowa
               */

              FutureBuilder<List<NewsModel>>(
                future: newsType == NewsType.topTrending
                    ? newsProvider.fetchTopheadlines()
                    :
                    // // moramo dodati +1 zato sto stranica ne moze biti nula po defaultu(api provider docs)
                    newsProvider.fetchAllNews(
                        pageIndex: currentPageIndex + 1, sortBy: sortBy),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return newsType == NewsType.allNews
                        ? LoadingWidget(
                            newsType: newsType,
                          )
                        : Expanded(
                            child: LoadingWidget(
                              newsType: newsType,
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: EmptyNewsWidget(
                        text: 'An error occurred ${snapshot.error}',
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  } else if (snapshot.data == null) {
                    return const Expanded(
                      child: EmptyNewsWidget(
                        text: 'No news found',
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  }
                  return newsType == NewsType.allNews
                      ? Expanded(
                          child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (ctx, index) {
                            /// pravimo da ChangeNotifierProvider bude parent ArticlesWidget
                            return ChangeNotifierProvider.value(
                              // ubacujemo vrijednost snapshota u provider
                              value: snapshot.data![index],
                              child: ArticlesWidget(

                                  /// koristimo provider kao efikasniji metod za stateManagment
                                  // dateToShow: snapshot.data![index].dateToShow,
                                  // imageUrl: snapshot.data![index].urlToImage,
                                  // title: snapshot.data![index].title,
                                  // readingTime:
                                  //     snapshot.data![index].readingTimeText,
                                  // url: snapshot.data![index].url,
                                  ),
                            );
                          },
                        ))
                      : SizedBox(
                          height: size.height * 0.6,
                          child: Swiper(
                              autoplayDelay: 6000,
                              autoplay: true,
                              itemWidth: size.width * 0.9,
                              layout: SwiperLayout.STACK,
                              viewportFraction: 0.9,
                              itemCount: 5,
                              itemBuilder: (ctx, index) {
                                return ChangeNotifierProvider.value(
                                  value: snapshot.data![index],
                                  child: TopTrendingWidget(
                                      //url: snapshot.data![index].url,
                                      ),
                                );
                              }),
                        );
                }),
              ),
              //LoadingWidget(newsType: newsType)
            ],
          ),
        ),
      ),
    );
  }

  // pravimo getter List i dodajemo mu elemente iz Enum class
  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: SortByEnum.relevance.name,
        child: Text(SortByEnum.relevance.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItems;
  }

  Widget paginationButtons({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(6),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
