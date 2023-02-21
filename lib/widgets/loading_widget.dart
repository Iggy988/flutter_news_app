import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_rest_api/consts/vars.dart';
import 'package:news_app_rest_api/providers/bookmarks_provider.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key, required this.newsType}) : super(key: key);

  final NewsType newsType;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  BorderRadius borderRadius = BorderRadius.circular(18);
  late Color baseShimmerColor, highlightShimmerColor, widgetShimmerColor;

  @override
  void didChangeDependencies() {
    // imamo pristup contextu unutar state classe
    var utils = Utils(context);
    baseShimmerColor = utils.baseShimmerColor;
    highlightShimmerColor = utils.highlightShimmerColor;
    widgetShimmerColor = utils.widgetShimmerColor;
    Provider.of<BookmarksProvider>(context, listen: false).fetchBookmarks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    // da bristupili vrijednosti izvan State class moramo poyvati widget.
    return widget.newsType == NewsType.topTrending
        ? Swiper(
            autoplayDelay: 6000,
            autoplay: true,
            itemWidth: size.width * 0.9,
            layout: SwiperLayout.STACK,
            viewportFraction: 0.9,
            itemCount: 5,
            itemBuilder: (ctx, index) {
              return TopTreandingLoadingWidget(
                  baseShimmerColor: baseShimmerColor,
                  highlightShimmerColor: highlightShimmerColor,
                  size: size,
                  borderRadius: borderRadius,
                  widgetShimmerColor: widgetShimmerColor);
            },
          )
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (ctx, index) {
                  return ArticlesShimmerEffectWidget(
                      baseShimmerColor: baseShimmerColor,
                      highlightShimmerColor: highlightShimmerColor,
                      size: size,
                      borderRadius: borderRadius,
                      widgetShimmerColor: widgetShimmerColor);
                }),
          );
  }
}

class TopTreandingLoadingWidget extends StatelessWidget {
  const TopTreandingLoadingWidget({
    Key? key,
    required this.baseShimmerColor,
    required this.highlightShimmerColor,
    required this.size,
    required this.borderRadius,
    required this.widgetShimmerColor,
  }) : super(key: key);

  final Color baseShimmerColor;
  final Color highlightShimmerColor;
  final Size size;
  final BorderRadius borderRadius;
  final Color widgetShimmerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12)),
          child: Shimmer.fromColors(
            baseColor: baseShimmerColor,
            highlightColor: highlightShimmerColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                      boxFit: BoxFit.fill,
                      errorWidget: Image.asset('assets/images/empty_image.png'),
                      imageUrl:
                          'https://techcrunch.com/wp-content/uploads/2022/01/locket-app.jpg?w=1390&crop=1',
                      height: size.height * 0.33,
                      width: double.infinity),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: size.width * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: borderRadius, color: widgetShimmerColor),
                  ),
                ),
                // Date
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.025,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            color: widgetShimmerColor),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}

class ArticlesShimmerEffectWidget extends StatelessWidget {
  const ArticlesShimmerEffectWidget({
    Key? key,
    required this.baseShimmerColor,
    required this.highlightShimmerColor,
    required this.size,
    required this.borderRadius,
    required this.widgetShimmerColor,
  }) : super(key: key);

  final Color baseShimmerColor;
  final Color highlightShimmerColor;
  final Size size;
  final BorderRadius borderRadius;
  final Color widgetShimmerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        child: Stack(
          children: [
            Container(
              height: 60,
              width: 60,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                width: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              color: Theme.of(context).cardColor,
              child: Shimmer.fromColors(
                baseColor: baseShimmerColor,
                highlightColor: highlightShimmerColor,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.red,
                        height: size.height * 0.12,
                        width: size.height * 0.12,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.06,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: widgetShimmerColor),
                          ),
                          const VerticalSpacing(5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: size.height * 0.025,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Colors.red),
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: size.height * 0.025,
                                  width: size.width * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
