import 'package:dio/dio.dart';
import 'package:delivrex/data/repository/auth_repo.dart';
import 'package:delivrex/data/repository/banner_repo.dart';
import 'package:delivrex/data/repository/cart_repo.dart';
import 'package:delivrex/data/repository/category_repo.dart';
import 'package:delivrex/data/repository/chat_repo.dart';
import 'package:delivrex/data/repository/coupon_repo.dart';
import 'package:delivrex/data/repository/location_repo.dart';
import 'package:delivrex/data/repository/notification_repo.dart';
import 'package:delivrex/data/repository/order_repo.dart';
import 'package:delivrex/data/repository/product_repo.dart';
import 'package:delivrex/data/repository/language_repo.dart';
import 'package:delivrex/data/repository/onboarding_repo.dart';
import 'package:delivrex/data/repository/search_repo.dart';
import 'package:delivrex/data/repository/set_menu_repo.dart';
import 'package:delivrex/data/repository/profile_repo.dart';
import 'package:delivrex/data/repository/splash_repo.dart';
import 'package:delivrex/data/repository/wallet_repo.dart';
import 'package:delivrex/data/repository/wishlist_repo.dart';
import 'package:delivrex/provider/auth_provider.dart';
import 'package:delivrex/provider/banner_provider.dart';
import 'package:delivrex/provider/branch_provider.dart';
import 'package:delivrex/provider/cart_provider.dart';
import 'package:delivrex/provider/category_provider.dart';
import 'package:delivrex/provider/chat_provider.dart';
import 'package:delivrex/provider/coupon_provider.dart';
import 'package:delivrex/provider/localization_provider.dart';
import 'package:delivrex/provider/news_letter_controller.dart';
import 'package:delivrex/provider/notification_provider.dart';
import 'package:delivrex/provider/order_provider.dart';
import 'package:delivrex/provider/location_provider.dart';
import 'package:delivrex/provider/product_provider.dart';
import 'package:delivrex/provider/language_provider.dart';
import 'package:delivrex/provider/onboarding_provider.dart';
import 'package:delivrex/provider/search_provider.dart';
import 'package:delivrex/provider/set_menu_provider.dart';
import 'package:delivrex/provider/profile_provider.dart';
import 'package:delivrex/provider/splash_provider.dart';
import 'package:delivrex/provider/theme_provider.dart';
import 'package:delivrex/provider/time_provider.dart';
import 'package:delivrex/provider/wallet_provider.dart';
import 'package:delivrex/provider/wishlist_provider.dart';
import 'package:delivrex/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/news_letter_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SetMenuRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WalletRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => SetMenuProvider(setMenuRepo: sl()));
  sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerLazySingleton(() => TimerProvider());
  sl.registerLazySingleton(() => WalletProvider(walletRepo: sl()));
  sl.registerLazySingleton(() => BranchProvider(splashRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
