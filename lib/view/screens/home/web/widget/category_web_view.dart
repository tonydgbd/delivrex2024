import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/arrey_button.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/category_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryViewWeb extends StatefulWidget {
  const CategoryViewWeb({Key? key}) : super(key: key);

  @override
  State<CategoryViewWeb> createState() => _CategoryViewWebState();
}

class _CategoryViewWebState extends State<CategoryViewWeb> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
  void _previousPage() {
    pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(getTranslated('all_categories', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                ),
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 160,
                          child: category.categoryList != null ? category.categoryList!.isNotEmpty ?
                          CategoryPageView(categoryProvider: category, pageController: pageController)
                              : Center(child: Text(getTranslated('no_category_available', context)!)) : const CategoryShimmer(),
                        ),
                      ),
                    ],
                  ),
                ),
                if(category.categoryList != null) Positioned.fill( child: Align(alignment: Provider.of<LocalizationProvider>(context).isLtr ? Alignment.centerLeft : Alignment.centerRight, child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ArrayButton(isLeft: true, isLarge: true, onTop: _previousPage, isVisible: !category.pageFirstIndex && (category.categoryList != null ? category.categoryList!.length > 7 : false)),
                ))),
               if(category.categoryList != null) Positioned.fill(child: Align(alignment: Provider.of<LocalizationProvider>(context).isLtr ? Alignment.centerRight : Alignment.centerLeft, child: Padding(
                 padding: const EdgeInsets.only(bottom: 16),
                 child: ArrayButton(isLeft: false, isLarge: true, onTop: _nextPage, isVisible:  !category.pageLastIndex && (category.categoryList != null ? category.categoryList!.length > 7 : false)),
               ))),
              ],
            ),

          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        itemCount: 7,
        // padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 125, width: 125,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 5),
                Container(height: 10, width: 50, color: Theme.of(context).shadowColor),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  const CategoryAllShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65, width: 65,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Theme.of(context).shadowColor),
          ]),
        ),
      ),
    );
  }
}

