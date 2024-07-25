import 'package:flutter/material.dart';
import 'package:delivrex/helper/network_info.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/provider/cart_provider.dart';
import 'package:delivrex/provider/order_provider.dart';
import 'package:delivrex/provider/splash_provider.dart';
import 'package:delivrex/utill/styles.dart';
import 'package:delivrex/view/base/third_party_chat_widget.dart';
import 'package:delivrex/view/screens/cart/cart_screen.dart';
import 'package:delivrex/view/screens/home/home_screen.dart';
import 'package:delivrex/view/screens/menu/menu_screen.dart';
import 'package:delivrex/view/screens/order/order_screen.dart';
import 'package:delivrex/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if (splashProvider.policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    }
    HomeScreen.loadData(false);

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(false),
      // const CartScreen(),
      const OrderScreen(),
      const WishListScreen(),
      MenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton:
            !ResponsiveHelper.isDesktop(context) && _pageIndex == 0
                ? const ThirdPartyChatWidget()
                : null,
        bottomNavigationBar: !ResponsiveHelper.isDesktop(context)
            ? BottomNavigationBar(
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor:
                    Theme.of(context).hintColor.withOpacity(0.7),
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(Icons.home, getTranslated('home', context), 0),
                  // _barItem(
                  //     Icons.shopping_cart, getTranslated('cart', context), 1),
                  _barItem(
                      Icons.shopping_bag, getTranslated('order', context), 2),
                  _barItem(
                      Icons.favorite, getTranslated('favourite', context), 3),
                  _barItem(Icons.menu, getTranslated('menu', context), 4)
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              )
            : const SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              color: index == _pageIndex
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).hintColor.withOpacity(0.7),
              size: 25),
          index == 1
              ? Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                      Provider.of<CartProvider>(context)
                          .cartList
                          .length
                          .toString(),
                      style: rubikMedium.copyWith(
                          color: Colors.white, fontSize: 8),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
