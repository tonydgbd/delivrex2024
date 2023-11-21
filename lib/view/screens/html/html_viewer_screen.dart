import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/html_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({Key? key, required this.htmlType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;
    String data = 'no_data_found';
    String appBarText = '';

    switch (htmlType) {
      case HtmlType.termsAndCondition :
        data = configModel!.termsAndConditions ?? '';
        appBarText = 'terms_and_condition';
        break;
      case HtmlType.aboutUs :
        data = configModel!.aboutUs ?? '';
        appBarText = 'about_us';
        break;
      case HtmlType.privacyPolicy :
        data = configModel!.privacyPolicy ?? '';
        appBarText = 'privacy_policy';
        break;
      case HtmlType.cancellationPolicy :
        data = policyModel!.cancellationPage!.content ?? '';
        appBarText = 'cancellation_policy';
        break;
      case HtmlType.refundPolicy :
        data = policyModel!.refundPage!.content ?? '';
        appBarText = 'refund_policy';
        break;
      case HtmlType.returnPolicy :
        data = policyModel!.returnPage!.content ?? '';
        appBarText = 'return_policy';
        break;
    }

    if(data.isNotEmpty) {
      data = data.replaceAll('href=', 'target="_blank" href=');
    }

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) :  CustomAppBar(
        title: getTranslated(appBarText, context),
        context: context,
      )) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 1170,
                child:  ResponsiveHelper.isDesktop(context) ? Column(
                  children: [
                    Container(
                      height: 100, alignment: Alignment.center,
                      child: SelectableText(getTranslated(appBarText, context)!,
                        style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight:  height < 600 ? height : height - 400),
                      child: HtmlWidget(data,
                        factoryBuilder: () => MyWidgetFactory(),
                        key: Key(htmlType.toString()),
                        onTapUrl: (String url) {
                          return launchUrl(Uri.parse(url));
                        },),
                    ),
                    const SizedBox(height: 30),
                  ],
                ) : SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  child: HtmlWidget(
                    data,
                    key: Key(htmlType.toString()),
                    onTapUrl: (String url) {
                      return launchUrl(Uri.parse(url));
                    },
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) const FooterView(

            )
          ],
        ),
      ),
    );


  }
}

class MyWidgetFactory extends WidgetFactory with SelectableTextFactory {

  @override
  SelectionChangedCallback  get selectableTextOnChanged => (selection, cause) {};


}