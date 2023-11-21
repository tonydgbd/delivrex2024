import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _emailController;
  TextEditingController? _numberController;
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _numberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.countryCode!).code;
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Center(
                      child: Container(
                        width: width > 700 ? 700 : width,
                        padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                        decoration: width > 700 ? BoxDecoration(
                          color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                        ) : null,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                                    builder:(context, splash, child) => FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderRectangle, height: MediaQuery.of(context).size.height / 4.5,
                                      image: splash.baseUrls != null ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}' : '',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: MediaQuery.of(context).size.height / 4.5),
                                    ),
                                  ) : Image.asset(Images.logo, matchTextDirection: true, height: MediaQuery.of(context).size.height / 4.5),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Text(
                                getTranslated('signup', context)!,
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                              const SizedBox(height: 35),


                              Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification!?
                              Text(
                                getTranslated('email', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                              ):Text(
                                getTranslated('mobile_number', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification!?
                              CustomTextField(
                                hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                focusNode: _emailFocus,
                                nextFocus: _numberFocus,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.emailAddress,
                                controller: _emailController,
                              ):Row(children: [
                                CodePickerWidget(
                                  onChanged: (CountryCode value) {
                                    countryCode = value.code;
                                  },
                                  initialSelection: countryCode,
                                  favorite: [countryCode!],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),

                                ),
                                Expanded(child: CustomTextField(
                                  hintText: getTranslated('number_hint', context),
                                  isShowBorder: true,
                                  controller: _numberController,
                                  focusNode: _numberFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                )),
                              ]),



                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage!.isNotEmpty
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  )
                                ],
                              ),
                              // for continue button
                              const SizedBox(height: 12),
                              !authProvider.isPhoneNumberVerificationButtonLoading
                                  ? CustomButton(
                                      btnTxt: getTranslated('continue', context),
                                      onTap: () {
                                        if(Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification!){
                                          // String countryCode;
                                          String email = _emailController!.text.trim();


                                          if (email.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_email_address', context));
                                          }else if (EmailChecker.isNotValid(email)) {
                                            showCustomSnackBar(getTranslated('enter_valid_email', context));
                                          }
                                          else {
                                            authProvider.checkEmail(email).then((value) async {
                                              if (value.isSuccess) {
                                                authProvider.updateEmail(email);
                                                if (value.message == 'active') {

                                                  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', email));
                                                } else {
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute(email,));
                                                }
                                              }
                                            });

                                          }
                                        }else{

                                          // String countryCode;
                                          String number =  '${CountryCode.fromCountryCode(countryCode!).dialCode!}${_numberController!.text.trim()}';
                                          String numberChk = _numberController!.text.trim();

                                          if (numberChk.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_phone_number', context));
                                          }
                                          else {
                                            authProvider.checkPhone(number).then((value) async {
                                              if (value.isSuccess) {
                                                authProvider.updatePhone(number);
                                                if (value.message == 'active') {
                                                  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', number));
                                                } else {
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute(number));
                                                }
                                              }
                                            });


                                          }

                                        }

                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )),

                              // for create an account
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('already_have_account', context)!,
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.7)),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      Text(
                                        getTranslated('login', context)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.getGreyBunkerColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
