import 'dart:collection';
import 'dart:convert' as convert;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delivrex/data/model/body/place_order_body.dart';
import 'package:delivrex/data/model/response/address_model.dart';
import 'package:delivrex/data/model/response/cart_model.dart';
import 'package:delivrex/data/model/response/config_model.dart';
import 'package:delivrex/helper/date_converter.dart';
import 'package:delivrex/helper/price_converter.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/main.dart';
import 'package:delivrex/payement.dart';
import 'package:delivrex/provider/auth_provider.dart';
import 'package:delivrex/provider/branch_provider.dart';
import 'package:delivrex/provider/cart_provider.dart';
import 'package:delivrex/provider/coupon_provider.dart';
import 'package:delivrex/provider/location_provider.dart';
import 'package:delivrex/provider/order_provider.dart';
import 'package:delivrex/provider/profile_provider.dart';
import 'package:delivrex/provider/splash_provider.dart';
import 'package:delivrex/utill/app_constants.dart';
import 'package:delivrex/utill/color_resources.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/images.dart';
import 'package:delivrex/utill/routes.dart';
import 'package:delivrex/utill/styles.dart';
import 'package:delivrex/view/base/branch_button_view.dart';
import 'package:delivrex/view/base/custom_app_bar.dart';
import 'package:delivrex/view/base/custom_button.dart';
import 'package:delivrex/view/base/custom_divider.dart';
import 'package:delivrex/view/base/custom_snackbar.dart';
import 'package:delivrex/view/base/custom_text_field.dart';
import 'package:delivrex/view/base/footer_view.dart';
import 'package:delivrex/view/base/not_logged_in_screen.dart';
import 'package:delivrex/view/base/web_app_bar.dart';
import 'package:delivrex/view/screens/address/widget/permission_dialog.dart';
import 'package:delivrex/view/screens/cart/cart_screen.dart';
import 'package:delivrex/view/screens/checkout/widget/delivery_fee_dialog.dart';
import 'package:delivrex/view/screens/checkout/widget/digital_payment_view.dart';
import 'package:delivrex/view/screens/checkout/widget/slot_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart' as gt;

class CheckoutScreen extends StatefulWidget {
  final double? amount;
  final String? orderType;
  final List<CartModel>? cartList;
  final bool fromCart;
  final String? couponCode;
  const CheckoutScreen(
      {Key? key,
      required this.amount,
      required this.orderType,
      required this.fromCart,
      required this.cartList,
      required this.couponCode})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  late GoogleMapController _mapController;
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  late bool _isLoggedIn;
  late List<CartModel?> _cartList;
  final List<String> _paymentList = [];
  final List<Color> _paymentColor = [];
  Branches? currentBranch;

  @override
  void initState() {
    super.initState();

    currentBranch =
        Provider.of<BranchProvider>(context, listen: false).getBranch();

    if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .cashOnDelivery ==
        'true') {
      _paymentList.add('cash_on_delivery');
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.02));
    }

    if (Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .walletStatus!) {
      _paymentList.add('wallet_payment');
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.1));
    }

    for (var method in Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .activePaymentMethodList!) {
      _paymentList.add(method);
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.1));
    }
    _paymentList.add("orange_money");
    _paymentColor.add(Colors.orange);
    _paymentList.add("moov_money");
    _paymentColor.add(Colors.orange);

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false)
          .initializeTimeSlot(context)
          .then((value) {
        Provider.of<OrderProvider>(context, listen: false).sortTime();
      });

      Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(false, isUpdate: false);

      Provider.of<LocationProvider>(context, listen: false).initAddressList();

      Provider.of<OrderProvider>(context, listen: false).clearPrevData();

      _cartList = [];
      widget.fromCart
          ? _cartList.addAll(
              Provider.of<CartProvider>(context, listen: false).cartList)
          : _cartList.addAll(widget.cartList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final configModel = splashProvider.configModel!;
    final height = MediaQuery.of(context).size.height;
    bool kmWiseCharge = configModel.deliveryManagement!.status == 1;
    bool takeAway = widget.orderType == 'take_away';

    return Scaffold(
      key: _scaffoldKey,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context, title: getTranslated('checkout', context)))
          as PreferredSizeWidget?,
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                double? deliveryCharge = 0;

                if (!takeAway && kmWiseCharge) {
                  deliveryCharge = order.distance *
                      configModel.deliveryManagement!.shippingPerKm!;
                  if (deliveryCharge <
                      configModel.deliveryManagement!.minShippingCharge!) {
                    deliveryCharge =
                        configModel.deliveryManagement!.minShippingCharge;
                  }
                } else if (!takeAway && !kmWiseCharge) {
                  deliveryCharge = configModel.deliveryCharge;
                }

                return Consumer<LocationProvider>(
                  builder: (context, address, child) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: !ResponsiveHelper.isDesktop(
                                                  context) &&
                                              height < 600
                                          ? height
                                          : height - 400),
                                  child: Center(
                                    child: SizedBox(
                                      width: 1170,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              margin: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .paddingSizeLarge)
                                                  : const EdgeInsets.all(0),
                                              decoration: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                          BoxShadow(
                                                            color: ColorResources
                                                                .cardShadowColor
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 10,
                                                          )
                                                        ])
                                                  : const BoxDecoration(),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (splashProvider
                                                              .isBranchSelectDisable())
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      getTranslated(
                                                                          'your_branch',
                                                                          context)!,
                                                                      style: rubikMedium.copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeLarge)),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child: const BranchButtonView(
                                                                        isRow:
                                                                            true),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          Container(
                                                            height:
                                                                ResponsiveHelper
                                                                        .isMobile()
                                                                    ? 200
                                                                    : 300,
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    Dimensions
                                                                        .paddingSizeSmall),
                                                            margin: const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeSmall),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                            ),
                                                            child: Stack(
                                                                children: [
                                                                  GoogleMap(
                                                                    mapType: MapType
                                                                        .normal,
                                                                    initialCameraPosition:
                                                                        CameraPosition(
                                                                      target:
                                                                          LatLng(
                                                                        double.parse(
                                                                            currentBranch!.latitude!),
                                                                        double.parse(
                                                                            currentBranch!.longitude!),
                                                                      ),
                                                                      zoom: 5,
                                                                    ),
                                                                    minMaxZoomPreference:
                                                                        const MinMaxZoomPreference(
                                                                            0,
                                                                            16),
                                                                    zoomControlsEnabled:
                                                                        true,
                                                                    markers:
                                                                        _markers,
                                                                    onMapCreated:
                                                                        (GoogleMapController
                                                                            controller) async {
                                                                      await Geolocator
                                                                          .requestPermission();
                                                                      _mapController =
                                                                          controller;
                                                                      _loading =
                                                                          false;
                                                                      _setMarkers(configModel
                                                                          .branches!
                                                                          .indexOf(
                                                                              currentBranch));
                                                                    },
                                                                  ),
                                                                  _loading
                                                                      ? Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                                        ))
                                                                      : const SizedBox(),
                                                                ]),
                                                          ),
                                                        ]),

                                                    // Address
                                                    !takeAway
                                                        ? Column(children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall),
                                                              child: Row(
                                                                  children: [
                                                                    Text(
                                                                        getTranslated(
                                                                            'delivery_address',
                                                                            context)!,
                                                                        style: rubikMedium.copyWith(
                                                                            fontSize:
                                                                                Dimensions.fontSizeLarge)),
                                                                    const Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                    TextButton
                                                                        .icon(
                                                                      onPressed: () => _checkPermission(Routes.getAddAddressRoute(
                                                                          'checkout',
                                                                          'add',
                                                                          AddressModel())),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .add),
                                                                      label: Text(
                                                                          getTranslated(
                                                                              'add',
                                                                              context)!,
                                                                          style:
                                                                              rubikRegular),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                              height: 60,
                                                              child: address
                                                                          .addressList !=
                                                                      null
                                                                  ? address
                                                                          .addressList!
                                                                          .isNotEmpty
                                                                      ? ListView
                                                                          .builder(
                                                                          physics:
                                                                              const BouncingScrollPhysics(),
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          padding:
                                                                              const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                                                          itemCount: address
                                                                              .addressList!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            bool
                                                                                isAvailable =
                                                                                currentBranch == null || (currentBranch!.latitude == null || currentBranch!.latitude!.isEmpty);
                                                                            if (!isAvailable) {
                                                                              double distance = Geolocator.distanceBetween(
                                                                                    double.parse(currentBranch!.latitude!),
                                                                                    double.parse(currentBranch!.longitude!),
                                                                                    double.parse(address.addressList![index].latitude!),
                                                                                    double.parse(address.addressList![index].longitude!),
                                                                                  ) /
                                                                                  1000;

                                                                              isAvailable = distance < currentBranch!.coverage!;
                                                                            }
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  if (isAvailable) {
                                                                                    order.setAddressIndex(index);
                                                                                    if (kmWiseCharge) {
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => Center(
                                                                                                  child: Container(
                                                                                                height: 100,
                                                                                                width: 100,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Theme.of(context).cardColor,
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                alignment: Alignment.center,
                                                                                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                                                              )),
                                                                                          barrierDismissible: false);
                                                                                      order
                                                                                          .getDistanceInMeter(
                                                                                        LatLng(
                                                                                          double.parse(currentBranch!.latitude!),
                                                                                          double.parse(currentBranch!.longitude!),
                                                                                        ),
                                                                                        LatLng(
                                                                                          double.parse(address.addressList![index].latitude!),
                                                                                          double.parse(address.addressList![index].longitude!),
                                                                                        ),
                                                                                      )
                                                                                          .then((isSuccess) {
                                                                                        Navigator.pop(context);
                                                                                        if (isSuccess) {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) => DeliveryFeeDialog(
                                                                                                    amount: widget.amount,
                                                                                                    distance: order.distance,
                                                                                                  ));
                                                                                        } else {
                                                                                          showCustomSnackBar(getTranslated('failed_to_fetch_distance', context));
                                                                                        }
                                                                                        return isSuccess;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Stack(children: [
                                                                                  Container(
                                                                                    height: 60,
                                                                                    width: 200,
                                                                                    decoration: BoxDecoration(
                                                                                      color: index == order.addressIndex ? Theme.of(context).cardColor : Theme.of(context).colorScheme.background.withOpacity(0.2),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      border: index == order.addressIndex ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                                                                    ),
                                                                                    child: Row(children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                                                        child: Icon(
                                                                                          address.addressList![index].addressType == 'Home'
                                                                                              ? Icons.home_outlined
                                                                                              : address.addressList![index].addressType == 'Workplace'
                                                                                                  ? Icons.work_outline
                                                                                                  : Icons.list_alt_outlined,
                                                                                          color: index == order.addressIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
                                                                                          size: 30,
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                          Text(address.addressList![index].addressType!,
                                                                                              style: rubikRegular.copyWith(
                                                                                                fontSize: Dimensions.fontSizeSmall,
                                                                                                color: ColorResources.getGreyBunkerColor(context),
                                                                                              )),
                                                                                          Text(address.addressList![index].address!, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                                                                                        ]),
                                                                                      ),
                                                                                      index == order.addressIndex
                                                                                          ? Align(
                                                                                              alignment: Alignment.topRight,
                                                                                              child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                                                                                            )
                                                                                          : const SizedBox(),
                                                                                    ]),
                                                                                  ),
                                                                                  !isAvailable
                                                                                      ? Positioned(
                                                                                          top: 0,
                                                                                          left: 0,
                                                                                          bottom: 0,
                                                                                          right: 0,
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                                                                                            child: Text(
                                                                                              getTranslated('out_of_coverage_for_this_branch', context)!,
                                                                                              textAlign: TextAlign.center,
                                                                                              maxLines: 2,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                ]),
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                      : Center(
                                                                          child: Text(getTranslated(
                                                                              'no_address_available',
                                                                              context)!))
                                                                  : Center(
                                                                      child: CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                          ])
                                                        : const SizedBox(),

                                                    // Time Slot
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeSmall),
                                                      child: Text(
                                                          getTranslated(
                                                              'preference_time',
                                                              context)!,
                                                          style: rubikMedium),
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeSmall),
                                                    SizedBox(
                                                      height: 50,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        padding: const EdgeInsets
                                                                .only(
                                                            left: Dimensions
                                                                .paddingSizeSmall),
                                                        itemCount: 2,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return SlotWidget(
                                                            title: index == 0
                                                                ? getTranslated(
                                                                    'today',
                                                                    context)
                                                                : getTranslated(
                                                                    'tomorrow',
                                                                    context),
                                                            isSelected: order
                                                                    .selectDateSlot ==
                                                                index,
                                                            onTap: () => order
                                                                .updateDateSlot(
                                                                    index),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeSmall),
                                                    SizedBox(
                                                      height: 50,
                                                      child: order.timeSlots !=
                                                              null
                                                          ? order.timeSlots!
                                                                  .isNotEmpty
                                                              ? ListView
                                                                  .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: Dimensions
                                                                          .paddingSizeSmall),
                                                                  itemCount: order
                                                                      .timeSlots!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return SlotWidget(
                                                                      title: (index == 0 &&
                                                                              order.selectDateSlot ==
                                                                                  0 &&
                                                                              Provider.of<SplashProvider>(context, listen: false).isRestaurantOpenNow(
                                                                                  context))
                                                                          ? getTranslated(
                                                                              'now',
                                                                              context)
                                                                          : '${DateConverter.dateToTimeOnly(order.timeSlots![index].startTime!, context)} '
                                                                              '- ${DateConverter.dateToTimeOnly(order.timeSlots![index].endTime!, context)}',
                                                                      isSelected:
                                                                          order.selectTimeSlot ==
                                                                              index,
                                                                      onTap: () =>
                                                                          order.updateTimeSlot(
                                                                              index),
                                                                    );
                                                                  },
                                                                )
                                                              : Center(
                                                                  child: Text(getTranslated(
                                                                      'no_slot_available',
                                                                      context)!))
                                                          : const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeLarge),

                                                    if (!ResponsiveHelper
                                                        .isDesktop(context))
                                                      detailsWidget(
                                                          context,
                                                          kmWiseCharge,
                                                          takeAway,
                                                          order,
                                                          deliveryCharge,
                                                          address),
                                                  ]),
                                            ),
                                          ),
                                          if (ResponsiveHelper.isDesktop(
                                              context))
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? const EdgeInsets
                                                            .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeLarge,
                                                        vertical: Dimensions
                                                            .paddingSizeLarge)
                                                    : const EdgeInsets.all(0),
                                                margin: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? const EdgeInsets
                                                            .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall,
                                                        vertical: Dimensions
                                                            .paddingSizeLarge)
                                                    : const EdgeInsets.all(0),
                                                decoration: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                            BoxShadow(
                                                              color: ColorResources
                                                                  .cardShadowColor
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 10,
                                                            )
                                                          ])
                                                    : const BoxDecoration(),
                                                child: detailsWidget(
                                                    context,
                                                    kmWiseCharge,
                                                    takeAway,
                                                    order,
                                                    deliveryCharge,
                                                    address),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                if (ResponsiveHelper.isDesktop(context))
                                  const FooterView(),
                              ],
                            ),
                          ),
                        ),
                        if (!ResponsiveHelper.isDesktop(context))
                          confirmButtonWidget(order, takeAway, address,
                              kmWiseCharge, deliveryCharge, context),
                      ],
                    );
                  },
                );
              },
            )
          : const NotLoggedInScreen(),
    );
  }

  Container confirmButtonWidget(
    OrderProvider order,
    bool takeAway,
    LocationProvider address,
    bool kmWiseCharge,
    double? deliveryCharge,
    BuildContext context,
  ) {
    return Container(
      width: 1170,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: !order.isLoading
          ? Builder(
              builder: (context) => CustomButton(
                  btnTxt: getTranslated('confirm_order', context),
                  onTap: () {
                    print(order.paymentMethod);
                    if (order.paymentMethod != '') {
                      bool isAvailable = true;
                      DateTime scheduleStartDate = DateTime.now();
                      DateTime scheduleEndDate = DateTime.now();
                      if (order.timeSlots == null || order.timeSlots!.isEmpty) {
                        isAvailable = false;
                      } else {
                        DateTime date = order.selectDateSlot == 0
                            ? DateTime.now()
                            : DateTime.now().add(const Duration(days: 1));
                        DateTime startTime =
                            order.timeSlots![order.selectTimeSlot].startTime!;
                        DateTime endTime =
                            order.timeSlots![order.selectTimeSlot].endTime!;
                        scheduleStartDate = DateTime(date.year, date.month,
                            date.day, startTime.hour, startTime.minute + 1);
                        scheduleEndDate = DateTime(date.year, date.month,
                            date.day, endTime.hour, endTime.minute + 1);
                        for (CartModel? cart in _cartList) {
                          if (!DateConverter.isAvailable(
                                cart!.product!.availableTimeStarts!,
                                cart.product!.availableTimeEnds!,
                                context,
                                time: scheduleStartDate,
                              ) &&
                              !DateConverter.isAvailable(
                                  cart.product!.availableTimeStarts!,
                                  cart.product!.availableTimeEnds!,
                                  context,
                                  time: scheduleEndDate)) {
                            isAvailable = false;
                            break;
                          }
                        }
                      }

                      if (widget.amount! <
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel!
                              .minimumOrderValue!) {
                        showCustomSnackBar(
                            'Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue}');
                      } else if (order.paymentMethod == 'wallet_payment' &&
                          Provider.of<ProfileProvider>(context, listen: false)
                                  .userInfoModel!
                                  .walletBalance !=
                              null &&
                          Provider.of<ProfileProvider>(context, listen: false)
                                  .userInfoModel!
                                  .walletBalance! <
                              (widget.amount! + deliveryCharge!)) {
                        showCustomSnackBar(getTranslated(
                            'you_do_not_have_sufficient_balance_in_wallet',
                            context));
                      } else if (!takeAway &&
                          (address.addressList == null ||
                              address.addressList!.isEmpty ||
                              order.addressIndex < 0)) {
                        showCustomSnackBar(
                            getTranslated('select_an_address', context));
                      } else if (order.timeSlots == null ||
                          order.timeSlots!.isEmpty) {
                        showCustomSnackBar(
                            getTranslated('select_a_time', context));
                      } else if (!isAvailable) {
                        showCustomSnackBar(getTranslated(
                            'one_or_more_products_are_not_available_for_this_selected_time',
                            context));
                      } else if (!takeAway &&
                          kmWiseCharge &&
                          order.distance == -1) {
                        showCustomSnackBar(
                            getTranslated('delivery_fee_not_set_yet', context));
                      } else {
                        List<Cart> carts = [];
                        for (int index = 0; index < _cartList.length; index++) {
                          CartModel cart = _cartList[index]!;
                          List<int?> addOnIdList = [];
                          List<int?> addOnQtyList = [];
                          List<OrderVariation> variations = [];

                          for (var addOn in cart.addOnIds!) {
                            addOnIdList.add(addOn.id);
                            addOnQtyList.add(addOn.quantity);
                          }

                          if (cart.product!.variations != null &&
                              cart.variations != null &&
                              cart.variations!.isNotEmpty) {
                            for (int i = 0;
                                i < cart.product!.variations!.length;
                                i++) {
                              if (cart.variations![i].contains(true)) {
                                variations.add(OrderVariation(
                                  name: cart.product!.variations![i].name,
                                  values: OrderVariationValue(label: []),
                                ));

                                for (int j = 0;
                                    j <
                                        cart.product!.variations![i]
                                            .variationValues!.length;
                                    j++) {
                                  if (cart.variations![i][j]!) {
                                    variations[variations.length - 1]
                                        .values!
                                        .label!
                                        .add(cart.product!.variations![i]
                                            .variationValues![j].level);
                                  }
                                }
                              }
                            }
                          }

                          carts.add(Cart(
                            cart.product!.id.toString(),
                            cart.discountedPrice.toString(),
                            [],
                            variations,
                            cart.discountAmount,
                            cart.quantity,
                            cart.taxAmount,
                            addOnIdList,
                            addOnQtyList,
                          ));
                        }
                        PlaceOrderBody placeOrderBody = PlaceOrderBody(
                          cart: carts,
                          couponDiscountAmount: Provider.of<CouponProvider>(
                                  context,
                                  listen: false)
                              .discount,
                          couponDiscountTitle: widget.couponCode!.isNotEmpty
                              ? widget.couponCode
                              : null,
                          deliveryAddressId: !takeAway
                              ? Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .addressList![order.addressIndex]
                                  .id
                              : 0,
                          orderAmount:
                              double.parse(widget.amount!.toStringAsFixed(2)),
                          orderNote: _noteController.text,
                          orderType: widget.orderType,
                          paymentMethod: order.paymentMethod,
                          couponCode: widget.couponCode!.isNotEmpty
                              ? widget.couponCode
                              : null,
                          distance: takeAway ? 0 : order.distance,
                          branchId: currentBranch!.id,
                          deliveryDate: DateFormat('yyyy-MM-dd')
                              .format(scheduleStartDate),
                          deliveryTime: (order.selectTimeSlot == 0 &&
                                  order.selectDateSlot == 0)
                              ? 'now'
                              : DateFormat('HH:mm').format(scheduleStartDate),
                        );

                        if (
                            order.paymentMethod == 'orange_money' ||
                            order.paymentMethod == 'moov_money') {
                          gt.Get.to(() => PayementScreen(
                              description:
                                  "Depot pour confirmation et paiement de votre commande",
                              montant: (placeOrderBody.orderAmount! + deliveryCharge!).toInt(),
                              userphone: "",
                              callback: () async {
                                order.placeOrder(placeOrderBody, _callback);
                              }));
                        } 
                        else if(order.paymentMethod == 'wallet_payment' || order.paymentMethod == 'cash_on_delivery' ) {
                    order.placeOrder(placeOrderBody, _callback);
                  }
                  
                      }
                    } else {
                      showCustomSnackBar(
                          getTranslated('select_payment_method', context));
                    }
                  }),
            )
          : Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor))),
    );
  }

  Widget detailsWidget(BuildContext context, bool kmWiseCharge, bool takeAway,
      OrderProvider order, double? deliveryCharge, LocationProvider address) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          child: Text(getTranslated('payment_method', context)!,
              style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.isDesktop(context)
                  ? 0
                  : Dimensions.paddingSizeSmall),
          child: DigitalPaymentView(
              paymentList: _paymentList, colorList: _paymentColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
              ? 0
              : Dimensions.paddingSizeSmall),
          child: Card(
              child: CustomTextField(
            controller: _noteController,
            hintText: getTranslated('additional_note', context),
            maxLines: 5,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        kmWiseCharge
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  ItemView(
                    title: getTranslated('subtotal', context)!,
                    subTitle: PriceConverter.convertPrice(widget.amount),
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge),
                  ),
                  const SizedBox(height: 10),
                  ItemView(
                    title: getTranslated('delivery_fee', context)!,
                    subTitle: (!takeAway || order.distance != -1)
                        ? '(+) ${PriceConverter.convertPrice(takeAway ? 0 : deliveryCharge)}'
                        : getTranslated('not_found', context)!,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    child: CustomDivider(),
                  ),
                  ItemView(
                    title: getTranslated('total_amount', context)!,
                    subTitle: PriceConverter.convertPrice(
                        widget.amount! + deliveryCharge!),
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).primaryColor),
                  ),
                ]),
              )
            : const SizedBox(),
        if (ResponsiveHelper.isDesktop(context))
          confirmButtonWidget(
              order, takeAway, address, kmWiseCharge, deliveryCharge, context),
      ],
    );
  }

  void _callback(
      bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();

      Navigator.pushReplacementNamed(
          context, '${Routes.orderSuccessScreen}/$orderID/success');
    } else {
      showCustomSnackBar(message);
    }
  }

  void _setMarkers(int selectedIndex) async {
    late BitmapDescriptor bitmapDescriptor;
    late BitmapDescriptor bitmapDescriptorUnSelect;

    List<Branches?> branches =
        Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .branches!;

    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(30, 50)),
            Images.restaurantMarker)
        .then((marker) {
      bitmapDescriptor = marker;
    });

    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(25, 40)),
            Images.unselectedRestaurantMarker)
        .then((marker) {
      bitmapDescriptorUnSelect = marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for (int index = 0; index < branches.length; index++) {
      _markers.add(Marker(
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(branches[index]!.latitude!),
            double.parse(branches[index]!.longitude!)),
        infoWindow: InfoWindow(
            title: branches[index]!.name, snippet: branches[index]!.address),
        icon: selectedIndex == index
            ? bitmapDescriptor
            : bitmapDescriptorUnSelect,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        double.parse(currentBranch!.latitude!),
        double.parse(currentBranch!.longitude!),
      ),
      zoom: ResponsiveHelper.isMobile() ? 12 : 16,
    )));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 30}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _checkPermission(String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', Get.context!));
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => const PermissionDialog());
    } else {
      Navigator.pushNamed(Get.context!, navigateTo);
    }
  }
}
