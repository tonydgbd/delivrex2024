import 'dart:convert';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class Routes {

  static const String splashScreen = '/splash';
  static const String languageScreen = '/select-language';
  static const String onBoardingScreen = '/on_boarding';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String signupScreen = '/sign-up';
  static const String verify = '/verify';
  static const String forgotPassScreen = '/forgot-password';
  static const String createNewPassScreen = '/create-new-password';
  static const String createAccountScreen = '/create-account';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String update = '/update';
  static const String dashboardScreen = '/main';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String setMenuScreen = '/set-menu';
  static const String categoryScreen = '/category';
  static const String notificationScreen = '/notification';
  static const String checkoutScreen = '/checkout';
  static const String paymentScreen = '/payment';
  static const String orderSuccessScreen = '/order-successful';
  static const String orderDetailsScreen = '/order-details';
  static const String rateScreen = '/rate-review';
  static const String orderTrackingScreen = '/order-tracking';
  static const String profileScreen = '/profile';
  static const String addressScreen = '/address';
  static const String mapScreen = '/map';
  static const String addAddressScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String chatScreen = '/messages';
  static const String couponScreen = '/coupons';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String imageDialog = '/image-dialog';
  static const String menuScreenWeb = '/menu_screen_web';
  static const String homeScreen = '/home';
  static const String orderWebPayment = '/order-web-payment';
  static const String popularItemRoute = '/POPULAR_ITEM_ROUTE';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String wallet = '/wallet';
  static const String referAndEarn = '/refer_and_earn';
  static const String branchListScreen = '/branch-list';
  static const String productImageScreen = '/image-screen';



  static String getSplashRoute() => splashScreen;
  static String getLanguageRoute(String page) => '$languageScreen?page=$page';
  static String getOnBoardingRoute() => onBoardingScreen;
  static String getWelcomeRoute() => welcomeScreen;
  static String getLoginRoute() => loginScreen;
  static String getSignUpRoute() => signupScreen;
  static String getForgetPassRoute() => forgotPassScreen;
  static String getNewPassRoute(String email, String token) => '$createNewPassScreen?email=$email&token=$token';
  static String getVerifyRoute(String page, String email) {
    String data = Uri.encodeComponent(jsonEncode(email));
    return '$verify?page=$page&email=$data';
  }

  static String getCreateAccountRoute(String email) {
    String email0 = base64Encode(utf8.encode(email));
    return '$createAccountScreen?email=$email0';
  }
  static String getMainRoute() => dashboard;
  static String getMaintainRoute() => maintain;
  static String getUpdateRoute() => update;
  static String getHomeRoute({required String fromAppBar}) {
    String appBar = fromAppBar;
    return '$homeScreen?from=$appBar';
  }
  static String getDashboardRoute(String page) => '$dashboardScreen?page=$page';
  static String getSearchRoute() => searchScreen;
  static String getSearchResultRoute(String text) {
    return '$searchResultScreen?text=${Uri.encodeComponent(jsonEncode(text))}';
  }
  static String getSetMenuRoute() => setMenuScreen;
  static String getNotificationRoute() => notificationScreen;
  static String getCategoryRoute(CategoryModel categoryModel) {
    String data = base64Url.encode(utf8.encode(jsonEncode(categoryModel.toJson())));
    return '$categoryScreen?category=$data';
  }
  static String getCheckoutRoute(double? amount, String page, String? type, String? code) {
    String amount0= base64Url.encode(utf8.encode(amount.toString()));
    return '$checkoutScreen?amount=$amount0&page=$page&type=$type&code=$code';
  }

  static String getPaymentRoute(String url) {
    return '$paymentScreen?url=$url';
  }
  static String getOrderDetailsRoute(int? id) => '$orderDetailsScreen?id=$id';
  static String getRateReviewRoute() => rateScreen;
  static String getOrderTrackingRoute(int? id) => '$orderTrackingScreen?id=$id';
  static String getProfileRoute() => profileScreen;
  static String getAddressRoute() => addressScreen;
  static String getMapRoute(AddressModel addressModel) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    return '$mapScreen?address=$data';
  }
  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$addAddressScreen?page=$page&action=$action&address=$data';
  }
  static String getSelectLocationRoute() => selectLocationScreen;
  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$chatScreen?order=$orderModel0';
  }
  static String getCouponRoute() => couponScreen;
  static String getSupportRoute() => supportScreen;
  static String getTermsRoute() => termsScreen;
  static String getPolicyRoute() => policyScreen;
  static String getAboutUsRoute() => aboutUsScreen;
  static String getPopularItemScreen() => popularItemRoute;
  static String getReturnPolicyRoute() => returnPolicyScreen;
  static String getCancellationPolicyRoute() => cancellationPolicyScreen;
  static String getRefundPolicyRoute() => refundPolicyScreen;
  static String getWalletRoute(bool fromWallet) => '$wallet?page=${fromWallet ? 'wallet' : 'loyalty_points'}';
  static String getReferAndEarnRoute() => referAndEarn;
  static String getBranchListScreen() => branchListScreen;
  static String getProductImageScreen(Product product)  {
    // print('produt is ----> ${product.toJson()}');
    String productJson = base64Encode(utf8.encode(jsonEncode(product)));
    return '$productImageScreen?product=$productJson';
  }
}