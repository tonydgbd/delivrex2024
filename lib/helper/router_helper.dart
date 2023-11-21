import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/html_type.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/map_widget.dart';
import 'package:flutter_restaurant/view/base/not_found.dart';
import 'package:flutter_restaurant/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/address/select_location_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/maintainance_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';
import 'package:flutter_restaurant/view/screens/category/category_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/order_web_payment.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/image_screen.dart';
import 'package:flutter_restaurant/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter_restaurant/view/screens/popular_item_screen/popular_item_screen.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter_restaurant/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_result_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:flutter_restaurant/view/screens/setmenu/set_menu_screen.dart';
import 'package:flutter_restaurant/view/screens/splash/splash_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/track/order_tracking_screen.dart';
import 'package:flutter_restaurant/view/screens/update/update_screen.dart';
import 'package:flutter_restaurant/view/screens/wallet/wallet_screen.dart';
import 'package:flutter_restaurant/view/screens/welcome_screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static final Handler _splashHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const SplashScreen());

  static final Handler _maintainHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context!, const MaintenanceScreen()),
  );

  // ignore: non_constant_identifier_names, missing_required_param

  static final Handler _languageHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return  ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static final Handler _onbordingHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => OnBoardingScreen(),
  );

  static final Handler _welcomeHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const WelcomeScreen()),
  );

  static final Handler _loginHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const LoginScreen()),
  );

  static final Handler _signUpHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const SignUpScreen()),
  );

  static final Handler _verificationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context!,  VerificationScreen(
      fromSignUp: params['page'][0] == 'sign-up', emailAddress: jsonDecode(params['email'][0]),
    ));
  });

  static final Handler _forgotPassHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const ForgotPasswordScreen()),
  );

  static final Handler _createNewPassHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        CreateNewPasswordScreen? createPassScreen = ModalRoute.of(context!)!.settings.arguments as CreateNewPasswordScreen?;
        return _routeHandler(context, createPassScreen ?? CreateNewPasswordScreen(
          email: params['email'][0], resetToken: params['token'][0],
        ));
      }
  );

  static final Handler _createAccountHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    String? email;
    try{
      email = utf8.decode(base64Decode(params['email'][0]));
    }catch(error){
     email = null;
    }
    if(email == null) {
      return _routeHandler(context!, const DashboardScreen(pageIndex: 0));
    }
    return _routeHandler(context!,  CreateAccountScreen(email: email));
  });

  static final Handler _dashScreenBoardHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context!, DashboardScreen(
      pageIndex: params['page'][0] == 'home'
          ? 0 : params['page'][0] == 'cart'
          ? 1 : params['page'][0] == 'order'
          ? 2 : params['page'][0] == 'favourite'
          ? 3 : params['page'][0] == 'menu'
          ? 4 : 0,
    ), isBranchCheck: params['page'][0] != 'menu' && params['page'][0] != 'order');
  });

  static final Handler _homeScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context!,HomeScreen(params['from'][0] == 'true' ? true : false), isBranchCheck: true);
  });

  static final Handler _deshboardHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => kIsWeb ? _routeHandler(context!, const DashboardScreen(pageIndex: 0), isBranchCheck: true) : const DashboardScreen(pageIndex: 0),
  );

  static final Handler _searchHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!,const SearchScreen(), isBranchCheck: true),
  );

  static final Handler _searchResultHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context!, SearchResultScreen(searchString: jsonDecode(params['text'][0])), isBranchCheck: true);

  });
  static final Handler _updateHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const UpdateScreen(),
  );

  static final Handler _setMenuHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const SetMenuScreen(), isBranchCheck: true),
  );

  static final Handler _categoryHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CategoryModel? category;

    try{
      List<int> decode = base64Decode(params['category'][0].replaceAll(' ', '+'));
      category = CategoryModel.fromJson(jsonDecode(utf8.decode(decode)));
    }catch(error){
      category = null;
    }
    if(category == null) {
      return _routeHandler(context!, const DashboardScreen(pageIndex: 0), isBranchCheck: true);
    }

    return _routeHandler(context!, CategoryScreen(categoryModel: category), isBranchCheck: true);
  });

  static final Handler _notificationHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const NotificationScreen()),
  );

  static final Handler _checkoutHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    String amount  = '${jsonDecode(utf8.decode(base64Decode(params['amount'][0])))}';
    CheckoutScreen? checkoutScreen = ModalRoute.of(context!)!.settings.arguments as CheckoutScreen?;
    bool fromCart = params['page'][0] == 'cart';
    return _routeHandler(context, checkoutScreen ?? (!fromCart ? const NotFound() : CheckoutScreen(
      amount: double.tryParse(amount), orderType: params['type'][0], cartList: null,
      fromCart: params['page'][0] == 'cart', couponCode: params['code'][0],
    )), isBranchCheck: true);
  });

  static final Handler _paymentHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        String? url = params['url'][0] ;
        return _routeHandler(context!,  PaymentScreen(
            url: url,
        ), isBranchCheck: true);
      }
  );

  static final Handler _orderSuccessHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        int status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success')
            ? 0 : params['status'][0] == 'payment-fail'
            ? 1 : params['status'][0] == 'order-fail' ?  2 : 3;
        return _routeHandler(context!, OrderSuccessfulScreen(orderID: params['id'][0], status: status), isBranchCheck: true);
      }
  );

  static final Handler _orderWebPaymentHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        return _routeHandler(context!, OrderWebPayment(token: params['token'][0]), isBranchCheck: true);
      }
  );

  static final Handler _orderDetailsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        OrderDetailsScreen? orderDetailsScreen = ModalRoute.of(context!)!.settings.arguments as OrderDetailsScreen?;
        return _routeHandler(context,orderDetailsScreen ?? OrderDetailsScreen(orderId: int.parse(params['id'][0]), orderModel: null));
      }
  );

  static final Handler _rateReviewHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    RateReviewScreen? rateReviewScreen =  ModalRoute.of(context!)!.settings.arguments as RateReviewScreen?;
    return _routeHandler(context, rateReviewScreen ?? const NotFound());
  });

  static final Handler _orderTrackingHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        return _routeHandler(context!, OrderTrackingScreen(orderID: params['id'][0]));
      }
  );

  static final Handler _profileHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const ProfileScreen()),
  );

  static final Handler _addressHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const AddressScreen()),
  );

  static final Handler _mapHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    DeliveryAddress data = DeliveryAddress.fromJson(jsonDecode(utf8.decode(decode)));
    return _routeHandler(context!,  MapWidget(address: data));
  });

  static final Handler _newAddressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    AddressModel? addressModel;
    if(isUpdate) {
      String decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return _routeHandler(context!, AddNewAddressScreen(
        fromCheckout: params['page'][0] == 'checkout',
        isEnableUpdate: isUpdate,
        address: isUpdate ? addressModel : null),
    );
  });

  static final Handler _selectLocationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen =  ModalRoute.of(context!)!.settings.arguments as SelectLocationScreen?;
    return _routeHandler(context,  locationScreen ?? const NotFound());
  });

  static final Handler _chatHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return _routeHandler(context!,  ChatScreen(
      orderModel : orderModel != null ? OrderModel.fromJson(orderModel) : null,
    ));
  });

  static final Handler _couponHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const CouponScreen()),
  );

  static final Handler _supportHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const SupportScreen());

  static final Handler _termsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>  const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition));

  static final Handler _policyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy));

  static final Handler _aboutUsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const HtmlViewerScreen(htmlType: HtmlType.aboutUs));

  static final Handler _notFoundHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const NotFound()),
  );

  static final Handler _popularItemScreenHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const PopularItemScreen(), isBranchCheck: true),
  );

  static final Handler _returnPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context!, const HtmlViewerScreen(htmlType: HtmlType.returnPolicy)),
  );

  static final Handler _refundPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const HtmlViewerScreen(htmlType: HtmlType.refundPolicy));

  static final Handler _cancellationPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy));

  static final Handler _walletHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context!, WalletScreen(fromWallet: params['page'][0] == 'wallet')),
  );

  static final Handler _referAndEarnHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context!, const ReferAndEarnScreen(),)
  );

  static final Handler _branchListHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(context!, const BranchListScreen(),)
  );

  static final Handler _productImageHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      final productJson = jsonDecode(utf8.decode(base64Url.decode(params['product'][0].replaceAll(' ', '+'))));
      return _routeHandler(context!, ProductImageScreen(product: Product.fromJson(productJson)), isBranchCheck: true);
    }
  );






//*******Route Define*********
  static void setupRouter() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.splashScreen, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.languageScreen, handler: _languageHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.onBoardingScreen, handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.welcomeScreen, handler: _welcomeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.loginScreen, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.signupScreen, handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.verify, handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.createAccountScreen, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.forgotPassScreen, handler: _forgotPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.createNewPassScreen, handler: _createNewPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.dashboardScreen, handler: _dashScreenBoardHandler, transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.homeScreen, handler: _homeScreenHandler, transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.dashboard, handler: _deshboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.searchScreen, handler: _searchHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.searchResultScreen, handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.categoryScreen, handler: _categoryHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.setMenuScreen, handler: _setMenuHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.notificationScreen, handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.checkoutScreen, handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.paymentScreen, handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define('${Routes.orderSuccessScreen}/:id/:status', handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define('${Routes.orderWebPayment}/:status?:token', handler: _orderWebPaymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.orderDetailsScreen, handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.rateScreen, handler: _rateReviewHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.orderTrackingScreen, handler: _orderTrackingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.profileScreen, handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.addressScreen, handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.mapScreen, handler: _mapHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.addAddressScreen, handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.selectLocationScreen, handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.chatScreen, handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.couponScreen, handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.supportScreen, handler: _supportHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.termsScreen, handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.policyScreen, handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.aboutUsScreen, handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.maintain, handler: _maintainHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.update, handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.popularItemRoute, handler: _popularItemScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.returnPolicyScreen, handler: _returnPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.refundPolicyScreen, handler: _refundPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.cancellationPolicyScreen, handler: _cancellationPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.wallet, handler: _walletHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.referAndEarn, handler: _referAndEarnHandler, transitionType: TransitionType.material);
    router.define(Routes.branchListScreen, handler: _branchListHandler, transitionType: TransitionType.material);
    router.define(Routes.productImageScreen, handler: _productImageHandler, transitionType: TransitionType.material);
  }


  static  Widget _routeHandler(BuildContext context, Widget route, {bool isBranchCheck = false}) {
   return Provider.of<SplashProvider>(context, listen: false).configModel!.maintenanceMode!
       ? const MaintenanceScreen() : (Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1 || !isBranchCheck)
       ?  route : const BranchListScreen();

  }
}