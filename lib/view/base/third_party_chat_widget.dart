import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdPartyChatWidget extends StatelessWidget {
  const ThirdPartyChatWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        return splashProvider.configModel != null && (splashProvider.configModel!.whatsapp != null
            && splashProvider.configModel!.whatsapp!.status!
            && splashProvider.configModel!.whatsapp!.number != null) ?
        InkWell(
          onTap: () async {
            final String? whatsapp = splashProvider.configModel!.whatsapp!.number;
            final Uri whatsappMobile = Uri.parse("whatsapp://send?phone=$whatsapp");
            if (await canLaunchUrl(whatsappMobile)) {
              await launchUrl(whatsappMobile, mode: LaunchMode.externalApplication);
            } else {
              await launchUrl( Uri.parse("https://web.whatsapp.com/send?phone=$whatsapp"), mode: LaunchMode.externalApplication);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
            height: 35, width: 90,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).secondaryHeaderColor),
            child: Row(children: [
              Image.asset(Images.whatsapp),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(getTranslated('chat', context)!, style: rubikMedium.copyWith(color: Colors.white),)
            ]),
          ),
        ) : const SizedBox();
      }
    );
  }
}