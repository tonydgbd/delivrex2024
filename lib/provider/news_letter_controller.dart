import 'package:flutter/material.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/data/repository/news_letter_repo.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/main.dart';
import 'package:delivrex/view/base/custom_snackbar.dart';

class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo? newsLetterRepo;
  NewsLetterProvider({required this.newsLetterRepo});


  Future<void> addToNewsLetter(String email) async {
    ApiResponse apiResponse = await newsLetterRepo!.addToNewsLetter(email);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(getTranslated('successfully_subscribe', Get.context!),isError: false);
      notifyListeners();
    } else {
      showCustomSnackBar(getTranslated('mail_already_exist', Get.context!));
    }
  }
}
