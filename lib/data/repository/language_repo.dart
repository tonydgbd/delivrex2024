import 'package:flutter/material.dart';
import 'package:delivrex/data/model/response/language_model.dart';
import 'package:delivrex/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
