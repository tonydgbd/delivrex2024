import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';


class PopularItemScreen extends StatefulWidget {
  const PopularItemScreen({Key? key}) : super(key: key);

  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {
  final ScrollController _scrollController = ScrollController();
  String _type = 'all';

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(true,'1');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          (productProvider.popularProductList != null) && !productProvider.isLoading
      ) {
        int pageSize;
        pageSize = (productProvider.popularPageSize! / 10).ceil();
        if (productProvider.popularOffset < pageSize) {
          productProvider.popularOffset ++;
          productProvider.showBottomLoader();

          productProvider.getPopularProductList(false, productProvider.popularOffset.toString(), type: _type);

        }
      }
    });
    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('popular_item', context)),
      body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
          return Column(
            children: [
              IgnorePointer(
                ignoring: productProvider.popularProductList == null,
                child: FilterButtonWidget(
                  type: _type,
                  items: Provider.of<ProductProvider>(context).productTypeList,
                  onSelected: (selected) {
                    _type = selected;
                    productProvider.getPopularProductList(true,'1', type: _type, isUpdate: true);
                  },
                ),
              ),
              Expanded(
                child: productProvider.popularProductList != null ?
                productProvider.popularProductList!.isNotEmpty ? RefreshIndicator(
                  onRefresh: () async {
                    _type = 'all';
                    await Provider.of<ProductProvider>(context, listen: false).getPopularProductList(true, '1');
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: GridView.builder(
                          gridDelegate: ResponsiveHelper.isDesktop(context)
                              ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 3.5,
                            crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
                          ),
                          itemCount: productProvider.popularProductList!.length,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ResponsiveHelper.isDesktop(context) ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ProductWidgetWeb(product: productProvider.popularProductList![index]),
                            ) : ProductWidget(product: productProvider.popularProductList![index]);
                          },
                        ),
                      ),
                    ),
                  ),
                ) :
                const NoDataScreen() :
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7: 4,
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                  ),
                  itemBuilder: (context, index) {
                    return ResponsiveHelper.isDesktop(context)? const ProductWidgetWebShimmer ():ProductShimmer(isEnabled: productProvider.popularProductList == null,);
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
