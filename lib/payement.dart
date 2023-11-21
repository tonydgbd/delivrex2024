import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import './values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      String app_id, bool orange) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(banner))),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    "Pour generer votre code de paiement,composez ou cliquer sur le code suivant:",
                    style: smallMediumTextStyle,
                  ),
                  TextButton(
                    child: Text(
                      code,
                      style: mediumLargeTextStyle.copyWith(
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: code,
                      );
                      await launchUrl(launchUri,
                          mode: LaunchMode.platformDefault);
                    },
                  ),
//                   Container(
//                     width: 170,
//                     height: 20,
//                     decoration: BoxDecoration(color: Colors.yellow[700]!),
//                     child: TextButton(onPressed: ()
//                       async{
// final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: code,
//     );
//     await launchUrl(launchUri);
//         },
//           child: Center(child: Text('Ou cliquez ici(Si votre numero est dans votre télephone)',style: TextStyle(fontSize: 17,color: Colors.white),)),),),
//                   SizedBox(height: 5,),

                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    controller: codeaccess,
                    decoration: InputDecoration(
                        label: Text(
                          "Code De Payement",
                          style: mediumLargeTextStyle,
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide())),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text('NB: Ce code est different de votre code De connexion à L\'application'),
                  Center(
                    child: CupertinoButton(
                      onPressed: () async {
                        EasyLoading.show(
                            indicator: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              "Verification du paiement",
                              style: mediumLargeTextStylewhite,
                            )
                          ],
                        ));
                        try {
                          if (!codeaccess.text.isNumericOnly) {
                            throw Exception();
                          }
                          var res = await Dio(BaseOptions(
                                  baseUrl:
                                      "https://shark-app-xeyhn.ondigitalocean.app"))
                              .post("/pay/control", data: {
                            "api_key": "2pKOZHdl8SC-_6g4WO94nhmZD2vWfIth",
                            "app_id": app_id,
                            "code_otp": codeaccess.text,
                            "amount": montant,
                            "orange": orange
                          });
                          print(res.data);

                          if ((res.data as Map)['success']) {
                            EasyLoading.showSuccess("Success de l'achat");
                            await callback();
                          } else {
                            EasyLoading.showError(
                                "Code  invalide, verifier vos informations");
                          }
                        } catch (e) {
                          EasyLoading.showError("Verifier vos informations");
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
                          "&text=Salut j'ai rencontré une difficulte pour valider mon vote";
                      var whatAppURLIOS =
                          "https://wa.me/$whatsapp?text=${Uri.parse("Salut j'ai rencontré une difficulte pour valider mon vote")}";
                      if (GetPlatform.isIOS) {
                        // for iOS phone only
                        if (await canLaunchUrlString(whatAppURLIOS)) {
                          await launchUrlString(
                            whatAppURLIOS,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Whatsapp non installé")));
                        }
                      } else if (GetPlatform.isWeb) {
                        launchUrlString(whatAppURLIOS);
                      } else {
                        if (await canLaunchUrlString(whatsappURlAndroid)) {
                          await launchUrlString(whatsappURlAndroid);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Whatsapp non installé")));
                        }
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String codeOrange = "*144*10*05690560*$montant#";
    String codeMoov = "*555*4*1*03301404*$montant#";
    String orangeBanner = "assets/Orange_Money-Logo.wine.png";
    String moovBanner = "assets/moov-money-removebg-preview.png";
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Payer votre Ticket",
          style: mediumLargeTextStyle,
        ),
      ),
      body: ScreenTypeLayout.builder(
          desktop: (ctx) => SafeArea(
                child: Center(
                    child: Container(
                  height: Get.height,
                  // width: Get.width,
                  constraints: BoxConstraints(maxWidth: 500),
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
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
                                      createDialogue(
                                          context,
                                          codeOrange,
                                          orangeBanner,
                                          "a4939d0b-7f68-4199-a3d8-6cc6cf7cf5ae",
                                          true);
                                    },
                                    child: Card(
                                      child: Container(
                                        width: 475 * 0.4,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          false);
                                    },
                                    child: Card(
                                      child: Container(
                                        width: 475 * 0.4,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                          //           Text("Pay",style: TextStyle(color: Colors.yellow[700]!,fontWeight: FontWeight.bold),)
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
          mobile: (context) {
            return SafeArea(
              child: Center(
                  child: Container(
                height: Get.height,
                width: Get.width,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    // width: Get.width,
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                                    createDialogue(
                                        context,
                                        codeOrange,
                                        orangeBanner,
                                        "a4939d0b-7f68-4199-a3d8-6cc6cf7cf5ae",
                                        true);
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
                                        false);
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
                        //           Text("Pay",style: TextStyle(color: Colors.yellow[700]!,fontWeight: FontWeight.bold),)
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
            );
          }),
      bottomNavigationBar: SizedBox(
        width: Get.width,
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
              style: TextStyle(
                  color: Colors.yellow[700]!, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
