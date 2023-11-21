import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/menu_bar_view.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final BuildContext context;
  final OrderModel? orderModel;
  const ChatAppBar({Key? key, this.isBackButtonExist = true, this.onBackPressed, required this.context, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splashProvider =  Provider.of<SplashProvider>(context, listen: false);
    return ResponsiveHelper.isDesktop(context) ? Center(
      child: Container(
          color: Theme.of(context).cardColor,
          width: 1170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                  child: splashProvider.baseUrls != null?  Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                        placeholder: Images.placeholderRectangle, image:  '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                        width: 120, height: 80,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, width: 120, height: 80),
                      )): const SizedBox(),
                ),
              ),
              const MenuBarView(true),
            ],
          )
      ),
    ) : AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(orderModel != null ? '${orderModel?.deliveryMan!.fName} ${orderModel?.deliveryMan!.lName}' : splashProvider.configModel!.restaurantName!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
          orderModel == null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeDefault),
            child: CircleAvatar(
              radius: Dimensions.paddingSizeDefault,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(Images.placeholderUser),
              ),
            ),
          ) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeDefault),
            child: CircleAvatar(
              radius: Dimensions.paddingSizeDefault,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholderUser, fit: BoxFit.cover, height: 40.0,width: 40.0,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${orderModel?.deliveryMan!.image ?? ''}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, fit: BoxFit.cover),
                ),
                // child: Image.asset(Images.placeholderUser), borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),

        ],
      ),


      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 50);
}
