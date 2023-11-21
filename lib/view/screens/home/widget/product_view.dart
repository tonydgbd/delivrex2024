import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType productType;
  final ScrollController? scrollController;
  const ProductView({Key? key, required this.productType, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(!ResponsiveHelper.isDesktop(context) && productType == ProductType.latestProduct) {
      scrollController?.addListener(() {

        if (scrollController!.position.pixels == scrollController!.position.maxScrollExtent &&
            (productProvider.latestProductList != null) && !productProvider.isLoading
        ) {
          late int pageSize;
          if (productType == ProductType.latestProduct) {
            pageSize = (productProvider.latestPageSize! / 10).ceil();
          }
          if (productProvider.latestOffset < pageSize) {
            productProvider.latestOffset ++;
            productProvider.showBottomLoader();
            if(productType == ProductType.latestProduct) {
              productProvider.getLatestProductList(false, productProvider.latestOffset.toString());
            }

          }
        }
      });

    }
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        if (productType == ProductType.latestProduct) {
          productList = prodProvider.latestProductList;
        }
        else if (productType == ProductType.popularProduct) {
          productList = prodProvider.popularProductList;
        }
        if(productList == null ) {
          return productType == ProductType.popularProduct ?
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 195,
                  child: const ProductWidgetWebShimmer(),
                );},
            ),
          ) :
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:ResponsiveHelper.isDesktop(context) ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: 12,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? const ProductWidgetWebShimmer() : ProductShimmer(isEnabled: productList == null);
              },
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          );
        }
        if(productList.isEmpty) {
          return const SizedBox();
        }

        return productType == ProductType.popularProduct
            ? SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    width: 195,
                    child: ProductWidgetWeb(product: productList![index], fromPopularItem: true),
                  );
                },
              ),
        ) :
        Column(children: [

          GridView.builder(
            gridDelegate: ResponsiveHelper.isDesktop(context)
                ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 3.5,
              crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: productList.length,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: ProductWidgetWeb(product: productList![index]),
              ) : ProductWidget(product: productList![index]);
            },
          ),
          const SizedBox(height: 30),

          productList.isNotEmpty ? Padding(
            padding: ResponsiveHelper.isDesktop(context)? const EdgeInsets.only(top: 40,bottom: 70) :  const EdgeInsets.all(0),
            child: ResponsiveHelper.isDesktop(context) ?
            prodProvider.isLoading ? Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              ),
            ) : (productProvider.latestOffset == (Provider.of<ProductProvider>(context, listen: false).latestPageSize! / 10).ceil())
                ? const SizedBox() :
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style : ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: (){
                  productProvider.moreProduct(context);
                  },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(getTranslated('see_more', context)!, style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                ),
              ),
            ) : prodProvider.isLoading
                ? Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,)),
            )) : const SizedBox.shrink(),
          ) : const SizedBox.shrink(),
        ]);
      },
    );
  }
}
