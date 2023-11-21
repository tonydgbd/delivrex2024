import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  const CreateAccountScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referTextFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referTextController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .code;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    final bool isPhone = EmailChecker.isNotValid(widget.email);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Center(
                    child: Container(
                      width: width > 700 ? 700 : width,
                      padding: width > 700
                          ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                          : null,
                      decoration: width > 700
                          ? BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                            getTranslated('create_account', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontSize: 24,
                                    color: ColorResources.getGreyBunkerColor(
                                        context)),
                          )),
                          const SizedBox(height: 20),

                          // for first name section
                          Text(
                            getTranslated('first_name', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: 'John',
                            isShowBorder: true,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // for last name section
                          Text(
                            getTranslated('last_name', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          configModel!.emailVerification!
                              ? CustomTextField(
                                  hintText: 'Doe',
                                  isShowBorder: true,
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocus,
                                  nextFocus: _numberFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                )
                              : CustomTextField(
                                  hintText: 'Doe',
                                  isShowBorder: true,
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocus,
                                  nextFocus: _emailFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // for email section
                          configModel.emailVerification!
                              ? Text(
                                  getTranslated('mobile_number', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: ColorResources.getHintColor(
                                              context)),
                                )
                              : Text(
                                  getTranslated('email', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: ColorResources.getHintColor(
                                              context)),
                                ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          configModel.emailVerification!
                              ? Row(children: [
                                  CodePickerWidget(
                                    onChanged: (CountryCode countryCode) {
                                      _countryDialCode = countryCode.dialCode;
                                    },
                                    initialSelection: _countryDialCode,
                                    favorite: [_countryDialCode!],
                                    showDropDownButton: true,
                                    padding: EdgeInsets.zero,
                                    showFlagMain: true,
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .color),
                                  ),
                                  Expanded(
                                      child: CustomTextField(
                                    hintText:
                                        getTranslated('number_hint', context),
                                    isShowBorder: true,
                                    controller: _numberController,
                                    focusNode: _numberFocus,
                                    nextFocus: configModel.referEarnStatus!
                                        ? _referTextFocus
                                        : _passwordFocus,
                                    inputType: TextInputType.phone,
                                  )),
                                ])
                              : CustomTextField(
                                  hintText:
                                      getTranslated('demo_gmail', context),
                                  isShowBorder: true,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: configModel.referEarnStatus!
                                      ? _referTextFocus
                                      : _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          //refer code
                          if (configModel.referEarnStatus!)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${getTranslated('refer_code', context)} (${getTranslated('optional', context)})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: ColorResources.getHintColor(
                                              context)),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                CustomTextField(
                                  hintText: 'lzPUA85HEtxCo6X9N1cV',
                                  isShowBorder: true,
                                  controller: _referTextController,
                                  focusNode: _referTextFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.text,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                              ],
                            ),

                          // for password section
                          Text(
                            getTranslated('password', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                          ),
                          const SizedBox(height: 22),

                          // for confirm password section
                          Text(
                            getTranslated('confirm_password', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.registrationErrorMessage!.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 5)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              )
                            ],
                          ),

                          // for signup button
                          const SizedBox(height: 10),
                          !authProvider.isLoading
                              ? CustomButton(
                                  btnTxt: getTranslated('signup', context),
                                  onTap: () async {
                                    String firstName =
                                        _firstNameController.text.trim();
                                    String lastName =
                                        _lastNameController.text.trim();
                                    String number = _countryDialCode! +
                                        _numberController.text.trim();
                                    String email = _emailController.text.trim();
                                    String password =
                                        _passwordController.text.trim();
                                    String confirmPassword =
                                        _confirmPasswordController.text.trim();

                                    if (firstName.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_first_name', context));
                                    } else if (lastName.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_last_name', context));
                                    } else if (number.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_phone_number', context));
                                    } else if (password.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_password', context));
                                    } else if (password.length < 6) {
                                      showCustomSnackBar(getTranslated(
                                          'password_should_be', context));
                                    } else if (confirmPassword.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_confirm_password', context));
                                    } else if (password != confirmPassword) {
                                      showCustomSnackBar(getTranslated(
                                          'password_did_not_match', context));
                                    } else {
                                      SignUpModel signUpModel = SignUpModel(
                                        fName: firstName,
                                        lName: lastName,
                                        email: isPhone ? email : widget.email,
                                        password: password,
                                        phone: isPhone ? widget.email : number,
                                        referralCode:
                                            _referTextController.text.trim(),
                                      );
                                      await authProvider
                                          .registration(signUpModel)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          await Navigator
                                              .pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.getMainRoute(),
                                                  (route) => false);
                                        }
                                      });
                                    }
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),

                          // for already an account
                          const SizedBox(height: 11),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.getLoginRoute());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(
                                        'already_have_account', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(0.7)),
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Text(
                                    getTranslated('login', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources
                                                .getGreyBunkerColor(context)),
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
                if (ResponsiveHelper.isDesktop(context)) const FooterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
