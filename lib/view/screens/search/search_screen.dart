import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1170,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: getTranslated('search_items_here', context),
                              isShowBorder: true,
                              isShowSuffixIcon: true,
                              suffixIconUrl: Images.search,
                              onSuffixTap: () {
                                if (_searchController.text.isNotEmpty) {
                                  searchProvider.saveSearchAddress(_searchController.text);
                                  searchProvider.searchProduct(_searchController.text, context);
                                  Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text), arguments: SearchResultScreen(searchString: _searchController.text));
                                 // Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text.replaceAll(' ', '-')));
                                }
                              },
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                if (_searchController.text.isNotEmpty) {
                                  searchProvider.saveSearchAddress(_searchController.text);
                                  searchProvider.searchProduct(_searchController.text, context);
                                  Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text), arguments: SearchResultScreen(searchString: _searchController.text));
                                  //Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text.replaceAll(' ', '-')));
                                }
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                getTranslated('cancel', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                              ))
                        ],
                      ),
                      // for resent search section
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('recent_search', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
                          ),
                          searchProvider.historyList.isNotEmpty
                              ? TextButton(
                                  onPressed: searchProvider.clearSearchAddress,
                                  child: Text(
                                    getTranslated('remove_all', context)!,
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),

                      // for recent search list section
                      Expanded(
                        child: ListView.builder(
                            itemCount: searchProvider.historyList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    searchProvider.searchProduct(searchProvider.historyList[index], context);
                                    Navigator.pushNamed(context, Routes.getSearchResultRoute(searchProvider.historyList[index].replaceAll(' ', '-')));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history, size: 16, color: Theme.of(context).hintColor),
                                            const SizedBox(width: 13),
                                            Text(
                                              searchProvider.historyList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                            )
                                          ],
                                        ),
                                        Icon(Icons.arrow_upward, size: 16, color: Theme.of(context).hintColor),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
