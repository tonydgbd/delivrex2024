import 'package:flutter/material.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/provider/onboarding_provider.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/routes.dart';
import 'package:delivrex/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false)
        .initBoardingList(context);

    return Scaffold(
      body: Consumer<OnBoardingProvider>(
        builder: (context, onBoardingList, child) => onBoardingList
                .onBoardingList.isNotEmpty
            ? SafeArea(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            onBoardingList.selectedIndex !=
                                    onBoardingList.onBoardingList.length - 1
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context,
                                              Routes.getWelcomeRoute());
                                        },
                                        child: Text(
                                          getTranslated('skip', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                        )),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: 400,
                              child: PageView.builder(
                                itemCount: onBoardingList.onBoardingList.length,
                                controller: _pageController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Image.asset(onBoardingList
                                        .onBoardingList[index].imageUrl),
                                  );
                                },
                                onPageChanged: (index) {
                                  onBoardingList.changeSelectIndex(index);
                                },
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _pageIndicators(
                                      onBoardingList.onBoardingList, context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 60, top: 50, bottom: 22),
                                  child: Text(
                                    onBoardingList.selectedIndex == 0
                                        ? onBoardingList.onBoardingList[0].title
                                        : onBoardingList.selectedIndex == 1
                                            ? onBoardingList
                                                .onBoardingList[1].title
                                            : onBoardingList
                                                .onBoardingList[2].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontSize: 24.0,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                                  child: Text(
                                    onBoardingList.selectedIndex == 0
                                        ? onBoardingList
                                            .onBoardingList[0].description
                                        : onBoardingList.selectedIndex == 1
                                            ? onBoardingList
                                                .onBoardingList[1].description
                                            : onBoardingList
                                                .onBoardingList[2].description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.7),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(
                                      onBoardingList.selectedIndex == 2
                                          ? 0
                                          : 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      onBoardingList.selectedIndex == 0 ||
                                              onBoardingList.selectedIndex == 2
                                          ? const SizedBox.shrink()
                                          : TextButton(
                                              onPressed: () {
                                                _pageController.previousPage(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    curve: Curves.ease);
                                              },
                                              child: Text(
                                                getTranslated(
                                                    'previous', context)!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.7)),
                                              )),
                                      onBoardingList.selectedIndex == 2
                                          ? const SizedBox.shrink()
                                          : TextButton(
                                              onPressed: () {
                                                _pageController.nextPage(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    curve: Curves.ease);
                                              },
                                              child: Text(
                                                getTranslated('next', context)!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.7)),
                                              )),
                                    ],
                                  ),
                                ),
                                onBoardingList.selectedIndex == 2
                                    ? Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeLarge),
                                        child: CustomButton(
                                          btnTxt: getTranslated(
                                              'lets_start', context),
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                Routes.getWelcomeRoute());
                                          },
                                        ))
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex
              ? 16
              : 7,
          height: 7,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor.withOpacity(0.7),
            borderRadius:
                i == Provider.of<OnBoardingProvider>(context).selectedIndex
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }
}
