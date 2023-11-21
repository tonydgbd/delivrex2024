import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<WishListProvider>(context, listen: false).initWishList();
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('my_favourite', context), isBackButtonExist: !ResponsiveHelper.isMobile())) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          return !wishlistProvider.isLoading ? !wishlistProvider.isLoading && wishlistProvider.wishIdList.isNotEmpty  ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<WishListProvider>(context, listen: false).initWishList();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1, vertical:  Dimensions.paddingSizeDefault),
                          child: SizedBox(
                            width: 1170,
                            child:  GridView.builder(
                              gridDelegate: ResponsiveHelper.isDesktop(context) ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                              SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 4,crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1),
                              itemCount: wishlistProvider.wishList!.length,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ResponsiveHelper.isDesktop(context) ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ProductWidgetWeb(product: wishlistProvider.wishList![index]),
                                ) : ProductWidget(product: wishlistProvider.wishList![index]);
                              },
                            )
                          ),
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                  ],
                ),
              ),
            ),
          ): const NoDataScreen()
            : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : const NotLoggedInScreen(),
    );
  }
}
