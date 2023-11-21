import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .homeDelivery!
          ? 'delivery'
          : 'take_away',
      notify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('my_cart', context),
                  isBackButtonExist: !ResponsiveHelper.isMobile()))
          as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            double? deliveryCharge = 0;
            (Provider.of<OrderProvider>(context, listen: false).orderType ==
                        'delivery' &&
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .deliveryManagement!
                            .status ==
                        0)
                ? deliveryCharge =
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel!
                        .deliveryCharge
                : deliveryCharge = 0;
            List<List<AddOns>> addOnsList = [];
            List<bool> availableList = [];
            double itemPrice = 0;
            double discount = 0;
            double tax = 0;
            double addOns = 0;
            for (var cartModel in cart.cartList) {
              List<AddOns> addOnList = [];

              for (var addOnId in cartModel!.addOnIds!) {
                for (AddOns addOns in cartModel.product!.addOns!) {
                  if (addOns.id == addOnId.id) {
                    addOnList.add(addOns);
                    break;
                  }
                }
              }
              addOnsList.add(addOnList);

              availableList.add(DateConverter.isAvailable(
                  cartModel.product!.availableTimeStarts!,
                  cartModel.product!.availableTimeEnds!,
                  context));

              for (int index = 0; index < addOnList.length; index++) {
                addOns = addOns +
                    (addOnList[index].price! *
                        cartModel.addOnIds![index].quantity!);
              }
              itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
              discount =
                  discount + (cartModel.discountAmount! * cartModel.quantity!);

              tax = tax + (cartModel.taxAmount! * cartModel.quantity!);
            }
            double subTotal = itemPrice + tax + addOns;
            double total = subTotal -
                discount -
                Provider.of<CouponProvider>(context).discount! +
                deliveryCharge!;
            double totalWithoutDeliveryFee = subTotal -
                discount -
                Provider.of<CouponProvider>(context).discount!;

            double orderAmount = itemPrice + addOns;

            bool kmWiseCharge =
                Provider.of<SplashProvider>(context, listen: false)
                        .configModel!
                        .deliveryManagement!
                        .status ==
                    1;

            return cart.cartList.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: Center(
                                child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      !ResponsiveHelper.isDesktop(context) &&
                                              height < 600
                                          ? height
                                          : height - 400),
                              child: SizedBox(
                                  width: 1170,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (ResponsiveHelper.isDesktop(context))
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge,
                                              vertical:
                                                  Dimensions.paddingSizeLarge),
                                          child: CartListWidget(
                                              cart: cart,
                                              addOns: addOnsList,
                                              availableList: availableList),
                                        )),
                                      if (ResponsiveHelper.isDesktop(context))
                                        const SizedBox(
                                            width: Dimensions.paddingSizeLarge),
                                      Expanded(
                                          child: Container(
                                        decoration: ResponsiveHelper.isDesktop(
                                                context)
                                            ? BoxDecoration(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor,
                                                      blurRadius: 10,
                                                    )
                                                  ])
                                            : const BoxDecoration(),
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeSmall,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        padding:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeLarge,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Product
                                              if (!ResponsiveHelper.isDesktop(
                                                  context))
                                                CartListWidget(
                                                    cart: cart,
                                                    addOns: addOnsList,
                                                    availableList:
                                                        availableList),

                                              // Coupon
                                              Consumer<CouponProvider>(
                                                builder:
                                                    (context, coupon, child) {
                                                  return IntrinsicHeight(
                                                    child: Row(children: [
                                                      Expanded(
                                                          child: TextField(
                                                        controller:
                                                            _couponController,
                                                        style: rubikRegular,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: getTranslated(
                                                              'enter_promo_code',
                                                              context),
                                                          hintStyle: rubikRegular.copyWith(
                                                              color: ColorResources
                                                                  .getHintColor(
                                                                      context)),
                                                          isDense: true,
                                                          filled: true,
                                                          enabled:
                                                              coupon.discount ==
                                                                  0,
                                                          fillColor:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .horizontal(
                                                              left: Radius.circular(
                                                                  Provider.of<LocalizationProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .isLtr
                                                                      ? 10
                                                                      : 0),
                                                              right: Radius.circular(
                                                                  Provider.of<LocalizationProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .isLtr
                                                                      ? 0
                                                                      : 10),
                                                            ),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                        ),
                                                      )),
                                                      InkWell(
                                                        onTap: () {
                                                          if (_couponController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              !coupon
                                                                  .isLoading) {
                                                            if (coupon
                                                                    .discount! <
                                                                1) {
                                                              coupon
                                                                  .applyCoupon(
                                                                      _couponController
                                                                          .text,
                                                                      total)
                                                                  .then(
                                                                      (discount) {
                                                                if (discount! >
                                                                    0) {
                                                                  showCustomSnackBar(
                                                                      'You got ${PriceConverter.convertPrice(discount)} discount',
                                                                      isError:
                                                                          false);
                                                                } else {
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'invalid_code_or',
                                                                          context),
                                                                      isError:
                                                                          true);
                                                                }
                                                              });
                                                            } else {
                                                              coupon
                                                                  .removeCouponData(
                                                                      true);
                                                            }
                                                          } else if (_couponController
                                                              .text.isEmpty) {
                                                            showCustomSnackBar(
                                                                getTranslated(
                                                                    'enter_a_Coupon_code',
                                                                    context));
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .horizontal(
                                                              left: Radius.circular(
                                                                  Provider.of<LocalizationProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .isLtr
                                                                      ? 0
                                                                      : 10),
                                                              right: Radius.circular(
                                                                  Provider.of<LocalizationProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .isLtr
                                                                      ? 10
                                                                      : 0),
                                                            ),
                                                          ),
                                                          child: coupon
                                                                      .discount! <=
                                                                  0
                                                              ? !coupon
                                                                      .isLoading
                                                                  ? Text(
                                                                      getTranslated(
                                                                          'apply',
                                                                          context)!,
                                                                      style: rubikMedium.copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  : const CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .white))
                                                              : const Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ]),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),

                                              // Order type
                                              Text(
                                                  getTranslated(
                                                      'delivery_option',
                                                      context)!,
                                                  style: rubikMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge)),

                                              Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .configModel!
                                                      .homeDelivery!
                                                  ? DeliveryOptionButton(
                                                      value: 'delivery',
                                                      title: getTranslated(
                                                          'delivery', context),
                                                      kmWiseFee: kmWiseCharge)
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .only(
                                                          left: Dimensions
                                                              .paddingSizeSmall,
                                                          top: Dimensions
                                                              .paddingSizeLarge),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .remove_circle_outline_sharp,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor,
                                                          ),
                                                          const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeExtraLarge),
                                                          Text(
                                                              getTranslated(
                                                                  'home_delivery_not_available',
                                                                  context)!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)),
                                                        ],
                                                      ),
                                                    ),

                                              Provider.of<
                                                              SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .configModel!
                                                      .selfPickup!
                                                  ? DeliveryOptionButton(
                                                      value: 'take_away',
                                                      title: getTranslated(
                                                          'take_away', context),
                                                      kmWiseFee: kmWiseCharge)
                                                  : SizedBox(
                                                      height: 50,
                                                    ),

                                              // : Padding(
                                              //   padding: const EdgeInsets
                                              //           .only(
                                              //       left: Dimensions
                                              //           .paddingSizeSmall,
                                              //       bottom: Dimensions
                                              //           .paddingSizeLarge),
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(
                                              //         Icons
                                              //             .remove_circle_outline_sharp,
                                              //         color: Theme.of(
                                              //                 context)
                                              //             .hintColor,
                                              //       ),
                                              //       const SizedBox(
                                              //           width: Dimensions
                                              //               .paddingSizeExtraLarge),
                                              //       Text(
                                              //           getTranslated(
                                              //               'self_pickup_not_available',
                                              //               context)!,
                                              //           style: TextStyle(
                                              //               fontSize:
                                              //                   Dimensions
                                              //                       .fontSizeDefault,
                                              //               color: Theme.of(
                                              //                       context)
                                              //                   .primaryColor)),
                                              //     ],
                                              //   ),
                                              // ),

                                              // Total
                                              ItemView(
                                                title: getTranslated(
                                                    'items_price', context)!,
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        itemPrice),
                                              ),
                                              const SizedBox(height: 10),

                                              // ItemView(
                                              //   title: getTranslated('tax', context)!,
                                              //   subTitle: '(+) ${PriceConverter.convertPrice(tax)}',
                                              // ),
                                              // const SizedBox(height: 10),

                                              ItemView(
                                                title: getTranslated(
                                                    'addons', context)!,
                                                subTitle:
                                                    '(+) ${PriceConverter.convertPrice(addOns)}',
                                              ),
                                              const SizedBox(height: 10),

                                              ItemView(
                                                title: getTranslated(
                                                    'discount', context)!,
                                                subTitle:
                                                    '(-) ${PriceConverter.convertPrice(discount)}',
                                              ),
                                              const SizedBox(height: 10),

                                              ItemView(
                                                title: getTranslated(
                                                    'coupon_discount',
                                                    context)!,
                                                subTitle:
                                                    '(-) ${PriceConverter.convertPrice(Provider.of<CouponProvider>(context).discount)}',
                                              ),
                                              const SizedBox(height: 10),

                                              kmWiseCharge
                                                  ? const SizedBox()
                                                  : ItemView(
                                                      title: getTranslated(
                                                          'delivery_fee',
                                                          context)!,
                                                      subTitle:
                                                          '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                                    ),

                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeSmall),
                                                child: CustomDivider(),
                                              ),

                                              ItemView(
                                                title: getTranslated(
                                                    kmWiseCharge
                                                        ? 'subtotal'
                                                        : 'total_amount',
                                                    context)!,
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        total),
                                                style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeDefault),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                CheckOutButtonView(
                                                  orderAmount: orderAmount,
                                                  totalWithoutDeliveryFee:
                                                      totalWithoutDeliveryFee,
                                                ),
                                            ]),
                                      )),
                                    ],
                                  )),
                            )),
                          ),
                          if (ResponsiveHelper.isDesktop(context))
                            const FooterView(),
                        ]),
                      )),
                      if (!ResponsiveHelper.isDesktop(context))
                        CheckOutButtonView(
                          orderAmount: orderAmount,
                          totalWithoutDeliveryFee: totalWithoutDeliveryFee,
                        ),
                    ],
                  )
                : const NoDataScreen(isCart: true);
          },
        );
      }),
    );
  }
}

class CheckOutButtonView extends StatelessWidget {
  const CheckOutButtonView({
    Key? key,
    required this.orderAmount,
    required this.totalWithoutDeliveryFee,
  }) : super(key: key);

  final double orderAmount;
  final double totalWithoutDeliveryFee;

  @override
  Widget build(BuildContext context) {
    ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    return ((configModel.selfPickup ?? false) ||
            (configModel.homeDelivery ?? false))
        ? Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButton(
                btnTxt: getTranslated('continue_checkout', context),
                onTap: () {
                  if (orderAmount <
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .minimumOrderValue!) {
                    showCustomSnackBar(
                        'Minimum order amount is ${PriceConverter.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue)}, you have ${PriceConverter.convertPrice(orderAmount)} in your cart, please add more item.');
                  } else {
                    Navigator.pushNamed(
                        context,
                        Routes.getCheckoutRoute(
                          totalWithoutDeliveryFee,
                          'cart',
                          Provider.of<OrderProvider>(context, listen: false)
                              .orderType,
                          Provider.of<CouponProvider>(context, listen: false)
                              .code,
                        ));
                  }
                }),
          )
        : const SizedBox();
  }
}

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.title,
    required this.subTitle,
    this.style,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: style ??
              rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      CustomDirectionality(
          child: Text(
        subTitle,
        style:
            style ?? rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
    ]);
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  const CartListWidget(
      {Key? key,
      required this.cart,
      required this.addOns,
      required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(
            cart: cart.cartList[index],
            cartIndex: index,
            addOns: addOns[index],
            isAvailable: availableList[index]);
      },
    );
  }
}
