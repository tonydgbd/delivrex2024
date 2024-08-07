import 'package:flutter/material.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/provider/splash_provider.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/images.dart';
import 'package:delivrex/utill/routes.dart';
import 'package:delivrex/utill/styles.dart';
import 'package:delivrex/view/base/menu_bar_view.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final BuildContext context;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Center(
            child: Container(
                color: Theme.of(context).cardColor,
                width: 1170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.getMainRoute()),
                        child: Provider.of<SplashProvider>(context).baseUrls !=
                                null
                            ? Consumer<SplashProvider>(
                                builder: (context, splash, child) =>
                                    FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderRectangle,
                                      image:
                                          '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                                      width: 120,
                                      height: 80,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                              Images.placeholderRectangle,
                                              width: 120,
                                              height: 80),
                                    ))
                            : const SizedBox(),
                      ),
                    ),
                    const MenuBarView(true),
                  ],
                )),
          )
        : AppBar(
            title: Text(title!,
                style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.of(context).maybePop(),
            ),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
          );
  }

  @override
  Size get preferredSize =>
      Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 50);
}
