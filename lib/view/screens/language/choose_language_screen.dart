import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/onboarding_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/language/widget/search_widget.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: SafeArea(
        child: Center(
          child: Container(
            padding:width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeLarge) : EdgeInsets.zero,
            child: Container(
              width: width > 700 ? 700 : width,
              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: width > 700 ? BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 1170,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                      child: Text(
                        getTranslated('choose_the_language', context)!,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 22, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 1170,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                      child: const SearchWidget(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Consumer<LanguageProvider>(
                      builder: (context, languageProvider, child) => Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Center(
                                child: SizedBox(
                                  width: 1170,
                                  child: ListView.builder(
                                      itemCount: languageProvider.languages.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => _languageWidget(
                                          context: context, languageModel: languageProvider.languages[index], languageProvider: languageProvider, index: index)),
                                ),
                              ),
                            ),
                          ))),
                  Consumer<LanguageProvider>(
                      builder: (context, languageProvider, child) => Center(
                        child: Container(
                          width: 1170,
                              padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge),
                              child: CustomButton(
                                btnTxt: getTranslated('save', context),
                                onTap: () {
                                  Provider.of<OnBoardingProvider>(context, listen: false).toggleShowOnBoardingStatus();
                                  if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                                      AppConstants.languages[languageProvider.selectIndex!].languageCode!,
                                      AppConstants.languages[languageProvider.selectIndex!].countryCode,
                                    ));
                                    if (fromMenu) {
                                      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(true, '1');
                                      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(true);
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        ResponsiveHelper.isMobile() ? Routes.getOnBoardingRoute() : Routes.getMainRoute(),
                                      );
                                    }
                                  }else {
                                    showCustomSnackBar(getTranslated('select_a_language', context));
                                  }
                                },
                              ),
                            ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageWidget({required BuildContext context, required LanguageModel languageModel, required LanguageProvider languageProvider, int? index}) {
    return InkWell(
      onTap: () {
        languageProvider.setSelectIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor.withOpacity(.15) : null,
          border: Border(
              top: BorderSide(width: 1.0, color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent),
              bottom: BorderSide(width: 1.0, color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: languageProvider.selectIndex == index ? Colors.transparent : Colors.white54.withOpacity(.3))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(languageModel.imageUrl!, width: 34, height: 34),
                  const SizedBox(width: 30),
                  Text(
                    languageModel.languageName!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ],
              ),
              languageProvider.selectIndex == index ? Image.asset(Images.done, width: 17, height: 17, color: Theme.of(context).primaryColor)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
