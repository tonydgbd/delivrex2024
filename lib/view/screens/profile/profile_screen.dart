
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class  ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode? _firstNameFocus;
  FocusNode? _lastNameFocus;
  FocusNode? _emailFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  File? file;
  XFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late bool _isLoggedIn;

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  _pickImage() async {
    data = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    _isLoggedIn = authProvider.isLoggedIn();


    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    if(_isLoggedIn) {
      profileProvider.getUserInfo(true).then((_) {

        UserInfoModel? userInfoModel = profileProvider.userInfoModel;
        if(userInfoModel != null){
          _firstNameController!.text = userInfoModel.fName ?? '';
          _lastNameController!.text = userInfoModel.lName ?? '';
          _phoneNumberController!.text = userInfoModel.phone ?? '';
          _emailController!.text = userInfoModel.email ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('my_profile', context))) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if(ResponsiveHelper.isDesktop(context)) {
            return ProfileScreenWeb(
              file: data,
              pickImage: _pickImage,
              confirmPasswordController: _confirmPasswordController,
              confirmPasswordFocus: _confirmPasswordFocus,
              emailController: _emailController,
              firstNameController: _firstNameController,
              firstNameFocus: _firstNameFocus,
              lastNameController: _lastNameController,
              lastNameFocus: _lastNameFocus,
              emailFocus: _emailFocus,
              passwordController: _passwordController,
              passwordFocus: _passwordFocus,
              phoneNumberController: _phoneNumberController,
              phoneNumberFocus: _phoneNumberFocus
            );
          }
          return profileProvider.userInfoModel != null ? Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Center(
                    child: Container(
                      width: width > 700 ? 700 : width,
                      padding: width > 700 ? const EdgeInsets.symmetric( horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall) : null,
                      decoration: width > 700 ? BoxDecoration(
                        color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for profile image
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorResources.borderColor,
                              border: Border.all(color: Colors.white54, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage,
                              child: Stack(
                                clipBehavior: Clip.none, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: file != null ? Image.file(file!, width: 80, height: 80, fit: BoxFit.fill) : data != null
                                        ? Image.network(data!.path, width: 80, height: 80, fit: BoxFit.fill)
                                        : FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderUser, width: 80, height: 80, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, width: 80, height: 80, fit: BoxFit.cover,),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    right: -10,
                                    child: InkWell(onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage, child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorResources.borderColor,
                                        border: Border.all(width: 2, color: Colors.white54),
                                      ),
                                      child: const Icon(Icons.edit, size: 13),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // for name
                          Center(
                              child: Text(
                                '${profileProvider.userInfoModel!.fName} ${profileProvider.userInfoModel!.lName}',
                                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                              )),

                          const SizedBox(height: 28),
                          // for first name section
                          Text(
                            getTranslated('first_name', context)!,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
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
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: 'Doe',
                            isShowBorder: true,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _phoneNumberFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // for email section
                          Text(
                            getTranslated('email', context)!,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('demo_gmail', context),
                            isShowBorder: true,
                            controller: _emailController,
                            isEnabled: false,
                            focusNode: _emailFocus,
                            nextFocus: _phoneNumberFocus,

                            inputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // for phone Number section
                          Text(
                            getTranslated('mobile_number', context)!,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('number_hint', context),
                            isShowBorder: true,
                            controller: _phoneNumberController,
                            focusNode: _phoneNumberFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated('password', context)!,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isPassword: true,
                            isShowSuffixIcon: true,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated('confirm_password', context)!,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

              !profileProvider.isLoading ? Center(
                child: Container(
                  width: width > 700 ? 700 : width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                  child: CustomButton(
                    btnTxt: getTranslated('update_profile', context),
                    onTap: () async {
                      String firstName = _firstNameController!.text.trim();
                      String lastName = _lastNameController!.text.trim();
                      String phoneNumber = _phoneNumberController!.text.trim();
                      String password = _passwordController!.text.trim();
                      String confirmPassword = _confirmPasswordController!.text.trim();
                      if (profileProvider.userInfoModel!.fName == firstName &&
                          profileProvider.userInfoModel!.lName == lastName &&
                          profileProvider.userInfoModel!.phone == phoneNumber &&
                          profileProvider.userInfoModel!.email == _emailController!.text && file == null && data == null
                          && password.isEmpty && confirmPassword.isEmpty) {
                        showCustomSnackBar(getTranslated('change_something_to_update', context));
                      }else if (firstName.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_first_name', context));
                      }else if (lastName.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_last_name', context));
                      }else if (phoneNumber.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_phone_number', context));
                      } else if((password.isNotEmpty && password.length < 6)
                          || (confirmPassword.isNotEmpty && confirmPassword.length < 6)) {
                        showCustomSnackBar(getTranslated('password_should_be', context));
                      } else if(password != confirmPassword) {
                        showCustomSnackBar(getTranslated('password_did_not_match', context));
                      } else {
                        UserInfoModel updateUserInfoModel = UserInfoModel();
                        updateUserInfoModel.fName = firstName;
                        updateUserInfoModel.lName = lastName ;
                        updateUserInfoModel.phone = phoneNumber ;
                        String pass = password;

                        ResponseModel responseModel = await profileProvider.updateUserInfo(
                          updateUserInfoModel, pass, file, data,
                          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                        );

                        if(responseModel.isSuccess) {
                          profileProvider.getUserInfo(true);

                          if(context.mounted){
                            showCustomSnackBar(getTranslated('updated_successfully', context), isError: false);
                          }
                        }else {
                          showCustomSnackBar(responseModel.message);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ),
              ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

            ],
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : const NotLoggedInScreen(),
    );
  }
}
