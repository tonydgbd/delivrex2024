import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.countryCode!).code;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final ConfigModel configModel =  Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('forgot_password', context))) as PreferredSizeWidget?,
      body: Center(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Container(
              width: width > 700 ? 700 : width,
              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: width > 700 ? BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 55),
                      
                      Center(
                        child: Image.asset(
                          Images.closeLock,
                          width: 142,
                          height: 142,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      configModel.phoneVerification!?
                      Center(child: Text(
                        getTranslated('please_enter_your_mobile_number_to', context)!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                      )):
                      Center(
                          child: Text(
                            getTranslated('please_enter_your_number_to', context)!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          )),

                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),
                            Text(configModel.phoneVerification!
                                ?  getTranslated('mobile_number', context)! : getTranslated('email', context)!,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            configModel.phoneVerification! ? Row(children: [
                              CodePickerWidget(
                                onChanged: (CountryCode countryCode) {
                                  _countryCode = countryCode.code;
                                },
                                initialSelection: _countryCode,
                                favorite: [_countryCode!],
                                showDropDownButton: true,
                                padding: EdgeInsets.zero,
                                textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
                                showFlagMain: true,

                              ),
                              Expanded(child: CustomTextField(
                                hintText: getTranslated('number_hint', context),
                                isShowBorder: true,
                                controller: _phoneNumberController,
                                inputType: TextInputType.phone,
                                inputAction: TextInputAction.done,
                              ),),
                            ]) : CustomTextField(
                              hintText: getTranslated('demo_gmail', context),
                              isShowBorder: true,
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 24),

                            !auth.isForgotPasswordLoading ? CustomButton(
                              btnTxt: getTranslated('send', context),
                              onTap: () {
                                if(configModel.phoneVerification!){
                                  if (_phoneNumberController!.text.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context));
                                  }else {
                                    String phoneNumber = '${CountryCode.fromCountryCode(_countryCode!).dialCode}${_phoneNumberController!.text.trim()}';

                                    auth.forgetPassword(phoneNumber).then((value) {
                                      if (value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getVerifyRoute('forget-password', phoneNumber));
                                      } else {
                                        showCustomSnackBar(value.message);
                                      }
                                    });
                                  }
                                }else{
                                  if (_emailController!.text.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_email_address', context));
                                  }else if (EmailChecker.isNotValid(_emailController!.text.trim())) {
                                    showCustomSnackBar(getTranslated('enter_valid_email', context));
                                  }else {
                                    auth.forgetPassword(_emailController!.text).then((value) {
                                      if (value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getVerifyRoute('forget-password', _emailController!.text));
                                      }
                                    });
                                  }
                                }

                              },
                            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )),

          if(ResponsiveHelper.isDesktop(context)) const FooterView()
        ]),
      )),
    );
  }
}
