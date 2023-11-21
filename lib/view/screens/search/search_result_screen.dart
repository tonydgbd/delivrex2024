import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:flutter_restaurant/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchString;
  const SearchResultScreen({Key? key, required this.searchString}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _type = 'all';

  @override
  void initState() {
    super.initState();

    int atamp = 0;
    if (atamp == 0) {
     _searchController.text = widget.searchString!.replaceAll('-', ' ');
      atamp = 1;
    }

    Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(_searchController.text);
    Provider.of<SearchProvider>(context,listen: false).searchProduct(_searchController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:ResponsiveHelper.isDesktop(context)? 0:Dimensions.paddingSizeDefault),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: SizedBox(
                    width: 1170,
                    child: Row(
                      children: [
                        ResponsiveHelper.isDesktop(context) ? const SizedBox():Expanded(
                          child: CustomTextField(
                            hintText: getTranslated('search_items_here', context),
                            isShowBorder: true,
                            isShowSuffixIcon: true,
                            suffixIconUrl: Images.filter,
                            controller: _searchController,
                            isShowPrefixIcon: false,
                            prefixIconUrl: Images.search,
                            inputAction: TextInputAction.search,
                            isIcon: true,
                            onSubmit: (value){
                              searchProvider.saveSearchAddress(value);
                              searchProvider.searchProduct(value, context);
                            },

                            onSuffixTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<double?> prices = [];
                                    for (var product in searchProvider.filterProductList!) {
                                      prices.add(product.price);
                                    }
                                    prices.sort();
                                    double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)),
                                      child: SizedBox(
                                          width: 550,
                                          child: FilterWidget(maxValue: maxValue)),
                                    );
                                  });

                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ResponsiveHelper.isDesktop(context) ?
                        const SizedBox(): InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                searchProvider.searchProductList != null ? Center(
                  child: SizedBox(
                    width: 1170,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${searchProvider.searchProductList!.length} ${getTranslated('product_found', context)}',
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  List<double?> prices = [];
                                  for (var product in searchProvider.filterProductList!) {
                                    prices.add(product.price);
                                  }
                                  prices.sort();
                                  double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)),
                                    child: SizedBox(
                                        width: 550,
                                        child: FilterWidget(maxValue: maxValue)),
                                  );
                                });

                          },
                          child: Image.asset(Images.filter),
                        )
                      ],
                    ),
                  ),
                ) : const SizedBox.shrink(),
                const SizedBox(height: 13),

                IgnorePointer(
                  ignoring: searchProvider.searchProductList == null,
                  child: FilterButtonWidget(
                    type: _type,
                    items: Provider.of<ProductProvider>(context).productTypeList,
                    onSelected: (selected) {
                      _type = selected;
                      Provider.of<SearchProvider>(context,listen: false).searchProduct(_searchController.text, context, type: _type, isUpdate: true);
                    },
                  ),
                ),

                Expanded(
                  child: searchProvider.searchProductList != null ? searchProvider.searchProductList!.isNotEmpty ? Scrollbar(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                              child: SizedBox(width: 1170,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: searchProvider.searchProductList!.length,
                                  padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall) : EdgeInsets.zero,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 3,
                                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 3 : 1),
                                  itemBuilder: (context, index) =>ResponsiveHelper.isDesktop(context) ? ProductWidgetWeb(product: searchProvider.searchProductList![index]): ProductWidget(product: searchProvider.searchProductList![index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            ResponsiveHelper.isDesktop(context) ? const FooterView() : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ) : const NoDataScreen() : Center(
                    child: SizedBox(width: 1170,
                      child: GridView.builder(
                        itemCount: 10,//searchProvider.searchProductList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 3,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 3 : 1,
                        ),
                        itemBuilder: (context, index) => ResponsiveHelper.isDesktop(context) ? const ProductWidgetWebShimmer() : ProductShimmer(isEnabled: searchProvider.searchProductList == null),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
