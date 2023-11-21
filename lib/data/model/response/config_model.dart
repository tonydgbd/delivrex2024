class ConfigModel {
  String? _restaurantName;
  String? _restaurantLogo;
  String? _restaurantAddress;
  String? _restaurantPhone;
  String? _restaurantEmail;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  double? _deliveryCharge;
  String? _cashOnDelivery;
  String? _digitalPayment;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  bool? _emailVerification;
  bool? _phoneVerification;
  String? _currencySymbolPosition;
  bool? _maintenanceMode;
  String? _countryCode;
  bool? _selfPickup;
  bool? _homeDelivery;
  RestaurantLocationCoverage? _restaurantLocationCoverage;
  double? _minimumOrderValue;
  List<Branches?>? _branches;
  DeliveryManagement? _deliveryManagement;
  PlayStoreConfig? _playStoreConfig;
  AppStoreConfig? _appStoreConfig;
  List<SocialMediaLink>? _socialMediaLink;
  String? _softwareVersion;
  String? _footerCopyright;
  String? _timeZone;
  int? _decimalPointSettings;
  List<RestaurantScheduleTime>? _restaurantScheduleTime;
  int? _scheduleOrderSlotDuration;
  String? _timeFormat;
  SocialStatus? _socialLoginStatus;
  List<String>? _activePaymentMethodList;
  double? _loyaltyPointItemPurchasePoint;
  bool? _loyaltyPointStatus;
  double?  _loyaltyPointMinimumPoint;
  double? _loyaltyPointExchangeRate;
  bool? _referEarningStatus;
  bool? _walletStatus;
  Whatsapp? _whatsapp;
  CookiesManagement? _cookiesManagement;
  int? _otpResendTime;
  bool? _isVegNonVegActive;






  ConfigModel(
      {String? restaurantName,
        String? restaurantLogo,
        String? restaurantAddress,
        String? restaurantPhone,
        String? restaurantEmail,
        BaseUrls? baseUrls,
        String? currencySymbol,
        double? deliveryCharge,
        String? cashOnDelivery,
        String? digitalPayment,
        String? termsAndConditions,
        String? privacyPolicy,
        String? aboutUs,
        bool? emailVerification,
        bool? phoneVerification,
        String? currencySymbolPosition,
        bool? maintenanceMode,
        String? countryCode,
        RestaurantLocationCoverage? restaurantLocationCoverage,
        double? minimumOrderValue,
        List<Branches?>? branches,
        bool? selfPickup,
        bool? homeDelivery,
        DeliveryManagement? deliveryManagement,
        PlayStoreConfig? playStoreConfig,
        AppStoreConfig? appStoreConfig,
        List<SocialMediaLink>? socialMediaLink,
        String? softwareVersion,
        String? footerCopyright,
        String? timeZone,
        int? decimalPointSettings,
        List<RestaurantScheduleTime>? restaurantScheduleTime,
        int? scheduleOrderSlotDuration,
        String? timeFormat,
        SocialStatus? socialLoginStatus,
        List<String>? activePaymentMethodList,
        double? loyaltyPointItemPurchasePoint,
        bool? loyaltyPointStatus,
        double? loyaltyPointMinimumPoint,
        double? loyaltyPointExchangeRate,
        bool? referEarningStatus,
        bool? walletStatus,
        Whatsapp? whatsapp,
        CookiesManagement? cookiesManagement,
        int? otpResendTime,
        bool? isVegNonVegActive,

      }) {
    _restaurantName = restaurantName;
    _restaurantLogo = restaurantLogo;
    _restaurantAddress = restaurantAddress;
    _restaurantPhone = restaurantPhone;
    _restaurantEmail = restaurantEmail;
    _baseUrls = baseUrls;
    _currencySymbol = currencySymbol;
    _deliveryCharge = deliveryCharge;
    _cashOnDelivery = cashOnDelivery;
    _digitalPayment = digitalPayment;
    _termsAndConditions = termsAndConditions;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _restaurantLocationCoverage = restaurantLocationCoverage;
    _minimumOrderValue = minimumOrderValue;
    _branches = branches;
    _emailVerification = emailVerification;
    _phoneVerification = phoneVerification;
    _currencySymbolPosition = currencySymbolPosition;
    _maintenanceMode = maintenanceMode;
    _countryCode = countryCode;
    _selfPickup = selfPickup;
    _homeDelivery = homeDelivery;
    _deliveryManagement = deliveryManagement;
    if (playStoreConfig != null) {
      _playStoreConfig = playStoreConfig;
    }
    if (appStoreConfig != null) {
      _appStoreConfig = appStoreConfig;
    }
    if (socialMediaLink != null) {
      _socialMediaLink = socialMediaLink;
    }
    _softwareVersion = softwareVersion ?? '';
    _footerCopyright = footerCopyright ?? '';
    _timeZone = timeZone ?? '';
    _decimalPointSettings = decimalPointSettings ?? 1;
    _restaurantScheduleTime = restaurantScheduleTime;
    _scheduleOrderSlotDuration = scheduleOrderSlotDuration;
    _timeFormat = timeFormat;
    _activePaymentMethodList = activePaymentMethodList;
    _loyaltyPointItemPurchasePoint = loyaltyPointItemPurchasePoint;
    _loyaltyPointStatus = _loyaltyPointStatus;
    _loyaltyPointMinimumPoint = loyaltyPointMinimumPoint;
    _loyaltyPointExchangeRate = loyaltyPointExchangeRate;
    _referEarningStatus = referEarningStatus;
    _walletStatus = walletStatus;
    _whatsapp = whatsapp;
    _cookiesManagement = cookiesManagement;
    _otpResendTime = otpResendTime;
    _isVegNonVegActive = isVegNonVegActive;


  }

  String? get restaurantName => _restaurantName;
  String? get restaurantLogo => _restaurantLogo;
  String? get restaurantAddress => _restaurantAddress;
  String? get restaurantPhone => _restaurantPhone;
  String? get restaurantEmail => _restaurantEmail;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  double? get deliveryCharge => _deliveryCharge;
  String? get cashOnDelivery => _cashOnDelivery;
  String? get digitalPayment => _digitalPayment;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs=> _aboutUs;
  String? get privacyPolicy=> _privacyPolicy;
  RestaurantLocationCoverage? get restaurantLocationCoverage => _restaurantLocationCoverage;
  double? get minimumOrderValue => _minimumOrderValue;
  List<Branches?>? get branches => _branches;
  bool? get emailVerification => _emailVerification;
  bool? get phoneVerification => _phoneVerification;
  String? get currencySymbolPosition => _currencySymbolPosition;
  bool? get maintenanceMode => _maintenanceMode;
  String? get countryCode => _countryCode;
  bool? get selfPickup => _selfPickup;
  bool? get homeDelivery => _homeDelivery;
  DeliveryManagement? get deliveryManagement => _deliveryManagement;
  PlayStoreConfig? get playStoreConfig => _playStoreConfig;
  AppStoreConfig? get appStoreConfig => _appStoreConfig;
  List<SocialMediaLink>? get socialMediaLink => _socialMediaLink;
  String? get softwareVersion => _softwareVersion;
  String? get footerCopyright => _footerCopyright;
  String? get timeZone  => _timeZone;
  int? get decimalPointSettings => _decimalPointSettings;
  List<RestaurantScheduleTime>? get restaurantScheduleTime => _restaurantScheduleTime;
  int? get scheduleOrderSlotDuration => _scheduleOrderSlotDuration;
  String? get timeFormat => _timeFormat;
  SocialStatus? get socialLoginStatus => _socialLoginStatus;
  List<String>? get activePaymentMethodList => _activePaymentMethodList;
  double? get loyaltyPointItemPurchasePoint => _loyaltyPointItemPurchasePoint;
  bool? get loyaltyPointStatus => _loyaltyPointStatus;
  double? get loyaltyPointMinimumPoint => _loyaltyPointMinimumPoint;
  double? get loyaltyPointExchangeRate => _loyaltyPointExchangeRate;
  bool? get referEarnStatus => _referEarningStatus;
  bool? get walletStatus => _walletStatus;
  Whatsapp? get whatsapp => _whatsapp;
  CookiesManagement? get cookiesManagement => _cookiesManagement;
  int? get otpResendTime => _otpResendTime;
  bool? get isVegNonVegActive => _isVegNonVegActive;




  ConfigModel.fromJson(Map<String, dynamic> json) {
    _restaurantName = json['restaurant_name'];
    _restaurantLogo = json['restaurant_logo'];
    _restaurantAddress = json['restaurant_address'];
    _restaurantPhone = json['restaurant_phone'];
    _restaurantEmail = json['restaurant_email'];
    _baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _currencySymbolPosition = json['currency_symbol_position'];
    _maintenanceMode = json['maintenance_mode'];
    _countryCode = json['country'];
    _selfPickup = json['self_pickup'];
    _homeDelivery = json['delivery'];
    _restaurantLocationCoverage = json['restaurant_location_coverage'] != null
        ? RestaurantLocationCoverage.fromJson(json['restaurant_location_coverage']) : null;
    _minimumOrderValue = json['minimum_order_value'] != null ? json['minimum_order_value'].toDouble() : 0;
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches!.add(Branches.fromJson(v));
      });
    }
    _deliveryManagement = json['delivery_management'] != null
        ? DeliveryManagement.fromJson(json['delivery_management'])
        : null;
    _playStoreConfig = json['play_store_config'] != null
        ? PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? AppStoreConfig.fromJson(json['app_store_config'])
        : null;

    if (json['social_media_link'] != null) {
      _socialMediaLink = <SocialMediaLink>[];
      json['social_media_link'].forEach((v) {
        _socialMediaLink!.add(SocialMediaLink.fromJson(v));
      });
    }
    if(json['software_version'] !=null){
      _softwareVersion = json['software_version'];
    }
    if(json['footer_text']!=null){
      _footerCopyright = json['footer_text'];
    }
    _timeZone = json['time_zone'];
    _decimalPointSettings = json['decimal_point_settings'] ?? 1;

    _restaurantScheduleTime = List<RestaurantScheduleTime>.from(json["restaurant_schedule_time"].map((x) => RestaurantScheduleTime.fromJson(x)));

    try {
      _scheduleOrderSlotDuration = json['schedule_order_slot_duration'] ?? 30;
    }catch(_){
      _scheduleOrderSlotDuration = int.tryParse(json['schedule_order_slot_duration'] ?? 30 as String);
    }

    _timeFormat =  json['time_format'].toString();

    if(json['social_login'] != null) {
      _socialLoginStatus = SocialStatus.fromJson(json['social_login']) ;
    }
    
    if(json['active_payment_method_list'] != null) {
      _activePaymentMethodList = json['active_payment_method_list'].cast<String>();
    }

    //json['active_payment_method_list'];

   if(json['loyalty_point_item_purchase_point'] != null) {
     _loyaltyPointItemPurchasePoint = double.parse('${json['loyalty_point_item_purchase_point']}');
   }
   _loyaltyPointStatus = '${json['loyalty_point_status']}' == '1';
    _loyaltyPointMinimumPoint = double.tryParse('${json['loyalty_point_minimum_point']}');
    _loyaltyPointExchangeRate = double.tryParse('${json['loyalty_point_exchange_rate']}');
    _referEarningStatus = '${json['ref_earning_status']}' == '1';
    _walletStatus = '${json['wallet_status']}' == '1';
    _whatsapp = json['whatsapp'] != null
        ? Whatsapp.fromJson(json['whatsapp'])
        : null;
    _cookiesManagement = json['cookies_management'] != null
        ? CookiesManagement.fromJson(json['cookies_management'])
        : null;

    _otpResendTime =  int.tryParse('${json['otp_resend_time']}');
    _isVegNonVegActive = '${json['is_veg_non_veg_active']}'.contains('1');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_name'] = _restaurantName;
    data['restaurant_logo'] = _restaurantLogo;
    data['restaurant_address'] = _restaurantAddress;
    data['restaurant_phone'] = _restaurantPhone;
    data['restaurant_email'] = _restaurantEmail;
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    data['currency_symbol'] = _currencySymbol;
    data['delivery_charge'] = _deliveryCharge;
    data['cash_on_delivery'] = _cashOnDelivery;
    data['digital_payment'] = _digitalPayment;
    data['terms_and_conditions'] = _termsAndConditions;
    data['privacy_policy'] = privacyPolicy;
    data['about_us'] = aboutUs;
    data['email_verification'] = emailVerification;
    data['phone_verification'] = phoneVerification;
    data['currency_symbol_position'] = currencySymbolPosition;
    data['maintenance_mode'] = maintenanceMode;
    data['country'] = countryCode;
    data['self_pickup'] = selfPickup;
    data['delivery'] = homeDelivery;
    if (_restaurantLocationCoverage != null) {
      data['restaurant_location_coverage'] = _restaurantLocationCoverage!.toJson();
    }
    data['minimum_order_value'] = _minimumOrderValue;
    if (_branches != null) {
      data['branches'] = _branches!.map((v) => v!.toJson()).toList();
    }
    if (_deliveryManagement != null) {
      data['delivery_management'] = _deliveryManagement!.toJson();
    }
    if (_playStoreConfig != null) {
      data['play_store_config'] = _playStoreConfig!.toJson();
    }
    if (_appStoreConfig != null) {
      data['app_store_config'] = _appStoreConfig!.toJson();
    }
    if (_socialMediaLink != null) {
      data['social_media_link'] =
          _socialMediaLink!.map((v) => v.toJson()).toList();
    }
    data['software_version'] = _softwareVersion;
    data['footer_text'] = _footerCopyright;
    data['time_zone'] = _timeZone;
    data['restaurant_schedule_time'] = _restaurantScheduleTime;
    data['loyalty_point_item_purchase_point'] = _loyaltyPointItemPurchasePoint;
    data['loyalty_point_exchange_rate'] = _loyaltyPointExchangeRate;
    data['loyalty_point_minimum_point'] = _loyaltyPointMinimumPoint;
    data['ref_earning_status'] = _referEarningStatus;
    data['wallet_status'] = _walletStatus;
    if (_whatsapp != null) {
      data['whatsapp'] = _whatsapp!.toJson();
    }
    data['otp_resend_time'] = _otpResendTime;

    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _categoryBannerImageUrl;
  String? _reviewImageUrl;
  String? _notificationImageUrl;
  String? _restaurantImageUrl;
  String? _deliveryManImageUrl;
  String? _chatImageUrl;
  String? _branchImageUrl;

  BaseUrls(
      {String? productImageUrl,
        String? customerImageUrl,
        String? bannerImageUrl,
        String? categoryImageUrl,
        String? categoryBannerImageUrl,
        String? reviewImageUrl,
        String? notificationImageUrl,
        String? restaurantImageUrl,
        String? deliveryManImageUrl,
        String? chatImageUrl,
        String? branchImageUrl,
      }) {
    _productImageUrl = productImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _categoryBannerImageUrl = categoryBannerImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _notificationImageUrl = notificationImageUrl;
    _restaurantImageUrl = restaurantImageUrl;
    _deliveryManImageUrl = deliveryManImageUrl;
    _chatImageUrl = chatImageUrl;
    _branchImageUrl = branchImageUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get categoryBannerImageUrl => _categoryBannerImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get restaurantImageUrl => _restaurantImageUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;
  String? get chatImageUrl => _chatImageUrl;
  String? get branchImageUrl => _branchImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'] ?? '';
    _customerImageUrl = json['customer_image_url'] ?? '';
    _bannerImageUrl = json['banner_image_url'] ?? '';
    _categoryImageUrl = json['category_image_url'] ?? '';
    _categoryBannerImageUrl = json['category_banner_image_url'];
    _reviewImageUrl = json['review_image_url'] ?? '';
    _notificationImageUrl = json['notification_image_url'];
    _restaurantImageUrl = json['restaurant_image_url'] ?? '';
    _deliveryManImageUrl = json['delivery_man_image_url'] ?? '';
    _chatImageUrl = json['chat_image_url'] ?? '';
    _branchImageUrl = json['branch_image_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['restaurant_image_url'] = _restaurantImageUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    data['chat_image_url'] = _chatImageUrl;
    data['branch_image_url'] = _branchImageUrl;
    return data;
  }
}

class RestaurantLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;

  RestaurantLocationCoverage(
      {String? longitude, String? latitude, double? coverage}) {
    _longitude = longitude;
    _latitude = latitude;
    _coverage = coverage;
  }

  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  RestaurantLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['coverage'] = _coverage;
    return data;
  }
}

class Branches {
  int? _id;
  String? _name;
  String? _email;
  String? _longitude;
  String? _latitude;
  String? _address;
  double? _coverage;
  String? _coverImage;
  String? _image;
  bool? _status;

  Branches(
      {int? id,
        String? name,
        String? email,
        String? longitude,
        String? latitude,
        String? address,
        double? coverage,
        String? coverImage,
        String? image,
        bool? status,
      }) {
    _id = id;
    _name = name;
    _email = email;
    _longitude = longitude;
    _latitude = latitude;
    _address = address;
    _coverage = coverage;
    _coverImage = coverImage;
    _image = image;
  }

  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get address => _address;
  double? get coverage => _coverage;
  String? get coverImage => _coverImage;
  String? get image => _image;
  bool? get status => _status;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
    _image = json['image'];
    _status = '${json['status']}'.contains('1');
    _coverImage = json['cover_image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['email'] = _email;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['address'] = _address;
    data['coverage'] = _coverage;
    data['image'] = _image;
    data['status'] = _status;
    return data;
  }
}
class BranchValue {
  final Branches? branches;
  final double distance;

  BranchValue(this.branches, this.distance);
}

class DeliveryManagement {
  int? _status;
  double? _minShippingCharge;
  double? _shippingPerKm;

  DeliveryManagement(
      {int? status, double? minShippingCharge, double? shippingPerKm}) {
    _status = status;
    _minShippingCharge = minShippingCharge;
    _shippingPerKm = shippingPerKm;
  }

  int? get status => _status;
  double? get minShippingCharge => _minShippingCharge;
  double? get shippingPerKm => _shippingPerKm;

  DeliveryManagement.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['min_shipping_charge'] = _minShippingCharge;
    data['shipping_per_km'] = _shippingPerKm;
    return data;
  }
}
class PlayStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  PlayStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }
  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] != null && json['min_version'] != '' ){
      _minVersion = double.parse(json['min_version']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class AppStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  AppStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version'] != ''){
      _minVersion = double.parse(json['min_version']);
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class SocialMediaLink {
  int? id;
  String? name;
  String? link;
  int? status;
  String? updatedAt;

  SocialMediaLink(
      {this.id,
        this.name,
        this.link,
        this.status,
        this.updatedAt});

  SocialMediaLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link'] = link;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RestaurantScheduleTime {
  RestaurantScheduleTime({
    this.day,
    this.openingTime,
    this.closingTime,
  });

  String? day;
  String? openingTime;
  String? closingTime;

  factory RestaurantScheduleTime.fromJson(Map<String, dynamic> json) => RestaurantScheduleTime(
    day: json["day"].toString(),
    openingTime: json["opening_time"].toString(),
    closingTime: json["closing_time"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "opening_time": openingTime,
    "closing_time": closingTime,
  };
}

class SocialStatus{
  bool? isGoogle;
  bool? isFacebook;

  SocialStatus(this.isGoogle, this.isFacebook);

  SocialStatus.fromJson(Map<String, dynamic> json){
    isGoogle = '${json['google']}' == '1';
    isFacebook = '${json['facebook']}' == '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = isGoogle;
    data['facebook'] = isFacebook;
    return data;
  }
}

class Whatsapp {
  bool? status;
  String? number;

  Whatsapp({this.status, this.number});

  Whatsapp.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] = number;
    return data;
  }
}


class CookiesManagement {
  bool? status;
  String? content;

  CookiesManagement({this.status, this.content});

  CookiesManagement.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    content = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['text'] = content;
    return data;
  }
}