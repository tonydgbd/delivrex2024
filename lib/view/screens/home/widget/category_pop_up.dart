import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryPopUp extends StatelessWidget {
  const CategoryPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Consumer<CategoryProvider>(
          builder: (context, category, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child:
                      TitleWidget(title: getTranslated('all_categories', context)),
                ),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: category.categoryList != null
                        ? category.categoryList!.isNotEmpty
                            ? GridView.builder(
                                itemCount: category.categoryList!.length,
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.2,
                                        crossAxisCount: ResponsiveHelper.isDesktop(context)?5:4,
                                    ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    child: InkWell(
                                      onTap: () => Navigator.pushNamed(
                                        context, Routes.getCategoryRoute(category.categoryList![index]),
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                        ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholderImage, width: 65, height: 65, fit: BoxFit.cover,
                                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}'
                                                '/${category.categoryList![index].image}',
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, width: 65, height: 65, fit: BoxFit.cover),
                                            // width: 100, height: 100, fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          category.categoryList![index].name!,
                                          style: rubikMedium.copyWith(
                                              fontSize: Dimensions.fontSizeSmall),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                              ) : Center(child: Text(getTranslated('no_category_available', context)!)) : const CategoryShimmer(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: Theme.of(context).shadowColor),
              ]),
            ),
          );
        },
      ),
    );
  }
}
