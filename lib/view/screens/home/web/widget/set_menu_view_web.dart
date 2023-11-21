import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/arrey_button.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/set_menu_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


class SetMenuViewWeb extends StatefulWidget {
  const SetMenuViewWeb({Key? key}) : super(key: key);

  @override
  State<SetMenuViewWeb> createState() => _SetMenuViewWebState();
}

class _SetMenuViewWebState extends State<SetMenuViewWeb> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
  void _previousPage() {
    pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SetMenuProvider>(
      builder: (context, setMenu, child) {
        return Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(getTranslated('set_menu', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                    ),
                  ],
                ),
                Positioned.fill(
                    child: SizedBox(
                      height: 20, width: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [ArrayButton(isLeft: true, isLarge: false,onTop:  _previousPage, isVisible: !setMenu.pageFirstIndex && (setMenu.setMenuList != null ? setMenu.setMenuList!.length > 5 : false)), const SizedBox(width: Dimensions.paddingSizeSmall),
                          ArrayButton(isLeft: false, isLarge: false, onTop: _nextPage,isVisible:  !setMenu.pageLastIndex && (setMenu.setMenuList != null ? setMenu.setMenuList!.length > 5 : false))]
                      ),
                    )
                )
              ],
            ),

            SizedBox(
              height: 360,
              child: setMenu.setMenuList != null ? setMenu.setMenuList!.isNotEmpty ? SetMenuPageView(setMenuProvider: setMenu, pageController: pageController) : Center(child: Text(getTranslated('no_set_menu_available', context)!)) : const SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  const SetMenuShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 4,
      itemBuilder: (context, index){
        return Container(
          height: 360,
          width: 280,
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: const Duration(seconds: 1),
            interval: const Duration(seconds: 1),
            enabled: Provider.of<SetMenuProvider>(context).setMenuList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 225.0, width: 368,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Theme.of(context).shadowColor
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      child: Container(height: 15, color: Theme.of(context).shadowColor),
                    ),
                    const RatingBar(rating: 0.0, size: Dimensions.paddingSizeDefault),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: Dimensions.paddingSizeSmall, width: 30, color: Theme.of(context).shadowColor),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Container(height: Dimensions.paddingSizeSmall,width: 30, color: Theme.of(context).shadowColor),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 240, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).shadowColor),),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

