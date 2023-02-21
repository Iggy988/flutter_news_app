import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_app_rest_api/consts/vars.dart';
import 'package:news_app_rest_api/models/news_model.dart';
import 'package:news_app_rest_api/providers/news_provider.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_app_rest_api/widgets/empty_screen_widget.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';

import '../widgets/articles_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  @override
  void initState() {
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  List<NewsModel>? searchList = [];
  bool isSearching = false;

  // kad user ode na drugi screen unistavaju se itemi iz prethodnog screena
  @override
  void dispose() {
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    return SafeArea(
      // klikom na empty screen unfocusuje se teht input
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      focusNode.unfocus();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      IconlyLight.arrowLeft2,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _searchTextController,
                      focusNode: focusNode,
                      style: TextStyle(color: color),
                      autofocus: true,
                      // da promjenimo button iz done u search
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () async {
                        // query je tekst koji se unosi u search polje
                        searchList = await newsProvider.searchNewsProvider(
                            query: _searchTextController.text);
                        isSearching = true;
                        focusNode.unfocus();
                        // pozivamo setState to rebuild image
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 8 / 5),
                        hintText: 'Search',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              _searchTextController.clear();
                              focusNode.unfocus();
                              isSearching = false;
                              // kad kliknemo na x da se izbrise search list
                              //searchList = [];
                              searchList!.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpacing(15),
              if (!isSearching && searchList!.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      itemCount: searchKeywords.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            _searchTextController.text = searchKeywords[index];
                            searchList = await newsProvider.searchNewsProvider(
                                query: _searchTextController.text);
                            isSearching = true;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(color: color),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    searchKeywords[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (isSearching && searchList!.isEmpty)
                const Expanded(
                  child: EmptyNewsWidget(
                      text: 'Ops! No results found',
                      imagePath: 'assets/images/search.png'),
                ),
              if (searchList != null && searchList!.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                  itemCount: searchList!.length,
                  itemBuilder: (ctx, index) {
                    /// pravimo da ChangeNotifierProvider bude parent ArticlesWidget
                    return ChangeNotifierProvider.value(
                      // ubacujemo vrijednost snapshota u provider
                      value: searchList![index],
                      child: ArticlesWidget(),
                    );
                  },
                ))
            ],
          ),
        ),
      ),
    );
  }
}
