import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String? resetToken;
  final String? email;
  CreateNewPasswordScreen({Key? key, required this.resetToken, required this.email}) : super(key: key);

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('create_new_password', context)),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    decoration: width > 700 ? BoxDecoration(
                      color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                    ) : null,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),
                        Center(
                          child: Image.asset(
                            Images.openLock,
                            width: 142,
                            height: 142,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                            child: Text(
                              getTranslated('enter_password_to_create', context)!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // for password section

                              const SizedBox(height: 60),
                              Text(
                                getTranslated('new_password', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              CustomTextField(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                focusNode: _passwordFocus,
                                nextFocus: _confirmPasswordFocus,
                                isShowSuffixIcon: true,
                                inputAction: TextInputAction.next,
                                controller: _passwordController,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                              // for confirm password section
                              Text(
                                getTranslated('confirm_password', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              CustomTextField(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                isShowSuffixIcon: true,
                                focusNode: _confirmPasswordFocus,
                                controller: _confirmPasswordController,
                                inputAction: TextInputAction.done,
                              ),

                              const SizedBox(height: 24),
                              !auth.isForgotPasswordLoading ? CustomButton(
                                btnTxt: getTranslated('save', context),
                                onTap: () {
                                  if (_passwordController.text.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_password', context));
                                  }else if (_passwordController.text.length < 6) {
                                    showCustomSnackBar(getTranslated('password_should_be', context));
                                  }else if (_confirmPasswordController.text.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_confirm_password', context));
                                  }else if(_passwordController.text != _confirmPasswordController.text) {
                                    showCustomSnackBar(getTranslated('password_did_not_match', context));
                                  }else {
                                    String? mail = Provider.of<SplashProvider>(context, listen: false).configModel!.phoneVerification!
                                        ? '+${email!.trim()}' : email;
                                    auth.resetPassword(mail, resetToken, _passwordController.text, _confirmPasswordController.text).then((value) {
                                      if(value.isSuccess) {
                                        auth.login(email, _passwordController.text).then((value) async {
                                          // await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                          //   context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                          // );
                                          Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                        });
                                      }else {
                                        showCustomSnackBar('Failed to reset password');
                                      }
                                    });
                                  }
                                },
                              ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
