// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import './values/values.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// class PayementScreen extends StatelessWidget {
//   TextEditingController codeaccess = TextEditingController();
//   TextEditingController phone = TextEditingController(text: "");
//   String phonetxt = "";
//   int montant;
//   String userphone;
//   AsyncCallback callback;
//   String description;
//   PayementScreen(
//       {Key? key,
//       required this.description,
//       required this.montant,
//       required this.userphone,
//       required this.callback})
//       : super(key: key);
//   createDialogue(BuildContext context, String code, String banner,
//       String app_id, bool orange) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             actionsAlignment: MainAxisAlignment.center,
//             title: Container(
//               width: 300,
//               height: 50,
//               decoration: BoxDecoration(
//                   image: DecorationImage(image: AssetImage(banner))),
//             ),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "Montant: ",
//                         style: mediumLargeTextStyle,
//                       ),
//                       Text(
//                         "$montant XOF",
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             color: primaryColor),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "Pour generer votre code de paiement,composez ou cliquer sur le code suivant:",
//                     style: smallMediumTextStyle,
//                   ),
//                   TextButton(
//                     child: Text(
//                       code,
//                       style: mediumLargeTextStyle.copyWith(
//                           color: primaryColor,
//                           decoration: TextDecoration.underline),
//                     ),
//                     onPressed: () async {
//                       final Uri launchUri = Uri(
//                         scheme: 'tel',
//                         path: code,
//                       );
//                       await launchUrl(launchUri,
//                           mode: LaunchMode.platformDefault);
//                     },
//                   ),
// //                   Container(
// //                     width: 170,
// //                     height: 20,
// //                     decoration: BoxDecoration(color: Colors.yellow[700]!),
// //                     child: TextButton(onPressed: ()
// //                       async{
// // final Uri launchUri = Uri(
// //       scheme: 'tel',
// //       path: code,
// //     );
// //     await launchUrl(launchUri);
// //         },
// //           child: Center(child: Text('Ou cliquez ici(Si votre numero est dans votre télephone)',style: TextStyle(fontSize: 17,color: Colors.white),)),),),
// //                   SizedBox(height: 5,),

//                   const SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     maxLength: 5,
//                     controller: codeaccess,
//                     decoration: InputDecoration(
//                         label: Text(
//                           "Code De Payement",
//                           style: mediumLargeTextStyle,
//                         ),
//                         border: OutlineInputBorder(borderSide: BorderSide())),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   // Text('NB: Ce code est different de votre code De connexion à L\'application'),
//                   Center(
//                     child: CupertinoButton(
//                       onPressed: () async {
//                         EasyLoading.show(
//                             indicator: Column(
//                           children: [
//                             CircularProgressIndicator(),
//                             Text(
//                               "Verification du paiement",
//                               style: mediumLargeTextStylewhite,
//                             )
//                           ],
//                         ));
//                         try {
//                           if (!codeaccess.text.isNumericOnly) {
//                             throw Exception();
//                           }
//                           var res = await Dio(BaseOptions(
//                                   baseUrl:
//                                       "https://shark-app-xeyhn.ondigitalocean.app"))
//                               .post("/pay/control", data: {
//                             "api_key": "2pKOZHdl8SC-_6g4WO94nhmZD2vWfIth",
//                             "app_id": app_id,
//                             "code_otp": codeaccess.text,
//                             "amount": montant,
//                             "orange": orange
//                           });
//                           print(res.data);

//                           if ((res.data as Map)['success']) {
//                             EasyLoading.showSuccess("Success de l'achat");
//                             await callback();
//                           } else {
//                             EasyLoading.showError(
//                                 "Code  invalide, verifier vos informations");
//                           }
//                         } catch (e) {
//                           EasyLoading.showError("Verifier vos informations");
//                         }
//                       },
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         "Confirmer le Paiement",
//                         style: mediumLargeTextStylewhite,
//                       ),
//                       color: primaryColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       EasyLoading.show(
//                           indicator: LoadingAnimationWidget.twistingDots(
//                             leftDotColor: Color.fromARGB(255, 255, 255, 255),
//                             rightDotColor: primaryColor,
//                             size: 25,
//                           ),
//                           dismissOnTap: false);
//                       var whatsapp = "+22660356506";
//                       var whatsappURlAndroid = "whatsapp://send?phone=" +
//                           whatsapp +
//                           "&text=Salut j'ai rencontré une difficulte pour valider mon vote";
//                       var whatAppURLIOS =
//                           "https://wa.me/$whatsapp?text=${Uri.parse("Salut j'ai rencontré une difficulte pour valider mon vote")}";
//                       if (GetPlatform.isIOS) {
//                         // for iOS phone only
//                         if (await canLaunchUrlString(whatAppURLIOS)) {
//                           await launchUrlString(
//                             whatAppURLIOS,
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Whatsapp non installé")));
//                         }
//                       } else if (GetPlatform.isWeb) {
//                         launchUrlString(whatAppURLIOS);
//                       } else {
//                         if (await canLaunchUrlString(whatsappURlAndroid)) {
//                           await launchUrlString(whatsappURlAndroid);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Whatsapp non installé")));
//                         }
//                       }
//                       EasyLoading.dismiss();
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/whatsapp.png',
//                           height: 25,
//                           width: 25,
//                         ),
//                         Text(
//                           "Contacter l'assistance",
//                           style: smallBoldTextStyle,
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String codeOrange = "*144*10*05690560*$montant#";
//     String codeMoov = "*555*4*1*03301404*$montant#";
//     String orangeBanner = "assets/Orange_Money-Logo.wine.png";
//     String moovBanner = "assets/moov-money-removebg-preview.png";
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Payer votre Ticket",
//           style: mediumLargeTextStyle,
//         ),
//       ),
//       body: ScreenTypeLayout.builder(
//           desktop: (ctx) => SafeArea(
//                 child: Center(
//                     child: Container(
//                   height: Get.height,
//                   // width: Get.width,
//                   constraints: BoxConstraints(maxWidth: 500),
//                   color: Colors.white,
//                   margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
//                   child: SingleChildScrollView(
//                     child: Container(
//                       constraints: const BoxConstraints(maxWidth: 500),
//                       height: Get.height,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Motif de la transaction :",
//                             style: mediumLargeTextStyle,
//                           ),
//                           Divider(color: Color.fromARGB(255, 211, 211, 211)),
//                           Text(
//                             description,
//                             style: mediumLargeTextStyle,
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Text("Montant total : $montant Franc CFA",
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold)),
//                           Divider(color: Color.fromARGB(255, 211, 211, 211)),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             "Payer avec :",
//                             style: mediumLargeTextStyle,
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       createDialogue(
//                                           context,
//                                           codeOrange,
//                                           orangeBanner,
//                                           "a4939d0b-7f68-4199-a3d8-6cc6cf7cf5ae",
//                                           true);
//                                     },
//                                     child: Card(
//                                       child: Container(
//                                         width: 475 * 0.4,
//                                         height: 100,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           image: DecorationImage(
//                                               image: AssetImage(orangeBanner)),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       createDialogue(
//                                           context,
//                                           codeMoov,
//                                           moovBanner,
//                                           "6f5ee7b0-44b1-4cbd-884c-7f9ec7ec4e07",
//                                           false);
//                                     },
//                                     child: Card(
//                                       child: Container(
//                                         width: 475 * 0.4,
//                                         height: 100,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           image: DecorationImage(
//                                               image: AssetImage(moovBanner)),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ]),
//                           ),
//                           //                 Align(
//                           //   alignment: Alignment.bottomCenter,
//                           //   child: SizedBox(
//                           //     width: Get.width,
//                           //     child: SingleChildScrollView(
//                           //       scrollDirection: Axis.horizontal,
//                           //       child: Row(
//                           //         children: [
//                           //           Icon(Icons.security),
//                           //           Text("Futurix ",style: mediumLargeTextStyle,),
//                           //           Text("Pay",style: TextStyle(color: Colors.yellow[700]!,fontWeight: FontWeight.bold),)
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ),
//                           // )
//                         ],
//                       ),
//                     ),
//                   ),
//                 )),
//               ),
//           mobile: (context) {
//             return SafeArea(
//               child: Center(
//                   child: Container(
//                 height: Get.height,
//                 width: Get.width,
//                 color: Colors.white,
//                 margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
//                 child: SingleChildScrollView(
//                   child: Container(
//                     constraints: BoxConstraints(maxWidth: 500),
//                     // width: Get.width,
//                     height: Get.height,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Motif de la transaction :",
//                           style: mediumLargeTextStyle,
//                         ),
//                         Divider(color: Color.fromARGB(255, 211, 211, 211)),
//                         Text(
//                           description,
//                           style: mediumLargeTextStyle,
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Text("Montant total : $montant Franc CFA",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Divider(color: Color.fromARGB(255, 211, 211, 211)),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           "Payer avec :",
//                           style: mediumLargeTextStyle,
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     createDialogue(
//                                         context,
//                                         codeOrange,
//                                         orangeBanner,
//                                         "a4939d0b-7f68-4199-a3d8-6cc6cf7cf5ae",
//                                         true);
//                                   },
//                                   child: Card(
//                                     child: Container(
//                                       width: Get.width * 0.4,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         image: DecorationImage(
//                                             image: AssetImage(orangeBanner)),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     createDialogue(
//                                         context,
//                                         codeMoov,
//                                         moovBanner,
//                                         "6f5ee7b0-44b1-4cbd-884c-7f9ec7ec4e07",
//                                         false);
//                                   },
//                                   child: Card(
//                                     child: Container(
//                                       width: Get.width * 0.4,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         image: DecorationImage(
//                                             image: AssetImage(moovBanner)),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ]),
//                         ),
//                         //                 Align(
//                         //   alignment: Alignment.bottomCenter,
//                         //   child: SizedBox(
//                         //     width: Get.width,
//                         //     child: SingleChildScrollView(
//                         //       scrollDirection: Axis.horizontal,
//                         //       child: Row(
//                         //         children: [
//                         //           Icon(Icons.security),
//                         //           Text("Futurix ",style: mediumLargeTextStyle,),
//                         //           Text("Pay",style: TextStyle(color: Colors.yellow[700]!,fontWeight: FontWeight.bold),)
//                         //         ],
//                         //       ),
//                         //     ),
//                         //   ),
//                         // )
//                       ],
//                     ),
//                   ),
//                 ),
//               )),
//             );
//           }),
//       bottomNavigationBar: SizedBox(
//         width: Get.width,
//         height: 75,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.security),
//             Text("Sécurisé par "),
//             Text(
//               "Futurix ",
//               style: mediumLargeTextStyle,
//             ),
//             Text(
//               "Pay",
//               style: TextStyle(
//                   color: Colors.yellow[700]!, fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_restaurant/values/colors.dart';
import 'package:flutter_restaurant/values/style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _bottomPaddingForButton = 150.0;
const double _buttonHeight = 56.0;
const double _buttonWidth = 200.0;
const double _pagePadding = 16.0;
const double _pageBreakpoint = 768.0;
const double _heroImageHeight = 250.0;
const Color _lightThemeShadowColor = Color(0xFFE4E4E4);
const Color _darkThemeShadowColor = Color(0xFF121212);
const Color _darkSabGradientColor = Color(0xFF313236);

class PayementScreen extends StatelessWidget {
  TextEditingController codeaccess = TextEditingController();
  TextEditingController phone = TextEditingController(text: "");
  String phonetxt = "";
  int montant;
  String userphone;
  AsyncCallback callback;
  String description;
  PayementScreen(
      {Key? key,
      required this.description,
      required this.montant,
      required this.userphone,
      required this.callback})
      : super(key: key);
  createDialogue(BuildContext context, String code, String banner,
      String app_id, bool is_orange) {
    WoltModalSheet.show<void>(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilder: (modalSheetContext) {
        final textTheme = Theme.of(context).textTheme;
        return [
          page1(modalSheetContext, textTheme, code, banner),
          page2(modalSheetContext, textTheme, code, banner,app_id,is_orange),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < _pageBreakpoint) {
          return WoltModalType.bottomSheet;
        } else {
          return WoltModalType.dialog;
        }
      },
      onModalDismissedWithBarrierTap: () {
        debugPrint('Closed modal sheet with barrier tap');
        Navigator.of(context).pop();
        pageIndexNotifier.value = 0;
      },
      maxDialogWidth: Get.width,
      minDialogWidth: 400,
      minPageHeight: 0.0,
      maxPageHeight: 0.9,
    );
  }

  final pageIndexNotifier = ValueNotifier(0);

  WoltModalSheetPage page1(BuildContext modalSheetContext, TextTheme textTheme,
      String code, String banner) {
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: Colors.white,
      hasSabGradient: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            Image.asset(
              banner,
              width: 250,
            ),
            Row(
              children: [
                Text(
                  "Montant: ",
                  style: mediumLargeTextStyle,
                ),
                Text(
                  "$montant XOF",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Entrez ou cliquez sur le code ci-dessous pour effectuer le paiement de la transaction et appuyez sur Continuer une fois terminé",
              style: smallMediumTextStyle,
            ),
            Center(
              child: TextButton(
                child: Text(
                  "code :${code}",
                  style: mediumLargeTextStyle.copyWith(
                      color: primaryColor,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: code,
                  );
                  await launchUrl(launchUri, mode: LaunchMode.platformDefault);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: CupertinoButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      Text(
                        "Faire la transaction",
                        style: mediumLargeTextStylewhite,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.green,
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: code,
                    );
                    await launchUrl(launchUri,
                        mode: LaunchMode.platformDefault);
                    pageIndexNotifier.value = 1;
                  }),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: Get.width * 095,
              child: CupertinoButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      Text(
                        "Paiement déjà effectué ? continuer",
                        style: mediumLargeTextStylewhite,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: primaryColor,
                  onPressed: () async {
                    pageIndexNotifier.value = 1;
                  }),
            )
          ],
        ),
      ),
      topBarTitle:
          Text("Code à composez pour l'achat", style: textTheme.titleSmall),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
    );
  }

  WoltModalSheetPage page2(BuildContext modalSheetContext, TextTheme textTheme,
      String code, String banner ,String app_id,bool is_orange){
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: Colors.white,

      enableDrag: true,
      
      stickyActionBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(
            _pagePadding, _pagePadding / 4, _pagePadding, _pagePadding),
        child: CupertinoButton(
          onPressed: () async {
            // bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
            if (true) {
              EasyLoading.show(
                  indicator: Column(
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Vérification des paiements",
                    style: mediumLargeTextStylewhite,
                  )
                ],
              ));
              try {
                print(phone.text);
                var headers = {'Content-Type': 'application/json'};
                var data = json.encode({
                  "api_key": "2pKOZHdl8SC-_6g4WO94nhmZD2vWfIth",
                  "app_id": app_id,
                  "amount": montant,
                  "phonenumber": phone.text,
                  "orange": is_orange
                });
                var dio = Dio();
                var response = await dio.request(
                  'https://shark-app-xeyhn.ondigitalocean.app/pay/control/phone_number',
                  options: Options(
                    method: 'POST',
                    headers: headers,
                  ),
                  data: data,
                );

                if (response.statusCode == 200) {
                  print(json.encode(response.data));
                  if(response.data['success']){
                    EasyLoading.showSuccess("Paiement confirmé");
                    await callback();
                } else {
                  EasyLoading.showError(
                      "Paiement non valide, S'il s'agit d'une transaction que vous venez d'effectuer, veuillez patienter et réessayer");
                  Get.back();
                }
                } else {
                  EasyLoading.showError(
                      "S'il s'agit d'une transaction que vous venez d'effectuer, veuillez patienter et réessayer");
                }
              } catch (e) {
                print(e);
                EasyLoading.showError(
                    "S'il s'agit d'une transaction que vous venez d'effectuer, veuillez patienter et réessayer");
              }
            }
          },
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Confirmer le Paiement",
            style: mediumLargeTextStylewhite,
          ),
          color: primaryColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              banner,
              width: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Entrez le numéro de téléphone que vous utilisez pour effectuer le paiement",
              style: mediumLargeTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width * 0.9,
              child: TextField(
                style: mediumLargeTextStyle,
                keyboardType: TextInputType.number,
                maxLength: 8,
                controller: phone,
                decoration: InputDecoration(
                  
                    label: Text(
                      "Numero de telephone",
                      style: mediumLargeTextStyle,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide())),
              ),
            ),

            // Text('NB: Ce code est different de votre code De connexion à L\'application'),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                EasyLoading.show(
                    indicator: LoadingAnimationWidget.twistingDots(
                      leftDotColor: Color.fromARGB(255, 255, 255, 255),
                      rightDotColor: primaryColor,
                      size: 25,
                    ),
                    dismissOnTap: false);
                var whatsapp = "+22660356506";
                var whatsappURlAndroid = "whatsapp://send?phone=" +
                    whatsapp +
                    "&text=Salut j'ai rencontré une difficulte pour payer mon ticket";
                var whatAppURLIOS =
                    "https://wa.me/$whatsapp?text=${Uri.parse("Salut j'ai rencontré une difficulte pour payer ma commande")}";

                // for iOS phone only
                try {
                  await launchUrlString(
                    whatAppURLIOS,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(modalSheetContext).showSnackBar(
                      const SnackBar(content: Text("Whatsapp non installé")));
                }

                EasyLoading.dismiss();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/whatsapp.png',
                    height: 25,
                    width: 25,
                  ),
                  Text(
                    "Contacter l'assistance",
                    style: smallBoldTextStyle,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      leadingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
      ),
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(modalSheetContext).pop();
          pageIndexNotifier.value = 0;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String codeOrange = "*144*10*05690560*$montant#";
    String codeMoov = "*555*$montant#";
    String orangeBanner = "assets/Orange_Money-Logo.wine.png";
    String moovBanner = "assets/moov-money-removebg-preview.png";
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Payer votre Ticket",
          style: mediumLargeTextStyle,
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: SingleChildScrollView(
            child: Container(
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Motif de la transaction :",
                    style: mediumLargeTextStyle,
                  ),
                  Divider(color: Color.fromARGB(255, 211, 211, 211)),
                  Text(
                    description,
                    style: mediumLargeTextStyle,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Montant total : $montant Franc CFA",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Divider(color: Color.fromARGB(255, 211, 211, 211)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Payer avec :",
                    style: mediumLargeTextStyle,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              createDialogue(context, codeOrange, orangeBanner,"a4939d0b-7f68-4199-a3d8-6cc6cf7cf5ae",true);
                            },
                            child: Card(
                              child: Container(
                                width: Get.width * 0.4,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(orangeBanner)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              createDialogue(
                                context,
                                codeMoov,
                                moovBanner,
                                "6f5ee7b0-44b1-4cbd-884c-7f9ec7ec4e07",
                                false
                              );
                            },
                            child: Card(
                              child: Container(
                                width: Get.width * 0.4,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(moovBanner)),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                  //                 Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: SizedBox(
                  //     width: Get.width,
                  //     child: SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Row(
                  //         children: [
                  //           Icon(Icons.security),
                  //           Text("Futurix ",style: mediumLargeTextStyle,),
                  //           Text("Pay",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        )),
      ),
      bottomNavigationBar: SizedBox(
        width: Get.width > 475 ? 475 : Get.width,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security),
            Text("Sécurisé par "),
            Text(
              "Futurix ",
              style: mediumLargeTextStyle,
            ),
            Text(
              "Pay",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
