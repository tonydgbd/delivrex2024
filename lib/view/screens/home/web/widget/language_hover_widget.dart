import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../localization/language_constrants.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../base/custom_snackbar.dart';
import '../../../../base/on_hover.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({Key? key, required this.languageList}) : super(key: key);

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Column(
              children: widget.languageList.map((language) => InkWell(
                onTap: () async {
                  if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(
                        Locale(language.languageCode!, language.countryCode)
                    );
                    HomeScreen.loadData(true);

                  }else {
                    showCustomSnackBar(getTranslated('select_a_language', context));
                  }
                },
                child: OnHover(
                    builder: (isHover) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: isHover ? Theme.of(context).secondaryHeaderColor.withOpacity(0.4) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: Image.asset(language.imageUrl!,height: Dimensions.paddingSizeLarge, fit: BoxFit.cover,),
                                ),
                                Text(language.languageName!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: Dimensions.fontSizeSmall),),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                ),
              )).toList()
            // [
            //   Text(_categoryList[5].name),
            // ],
          ),
        );
      }
    );
  }
}
