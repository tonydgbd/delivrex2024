import 'package:flutter/material.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/provider/theme_provider.dart';
import 'package:delivrex/utill/color_resources.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => SizedBox(
          height: Dimensions.paddingSizeDefault,
          child: InkWell(
                onTap: themeProvider.toggleTheme,
                child: themeProvider.darkTheme
                    ? Container(
                        width: 60,
                        height: 29,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorResources.footerCol0r,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              getTranslated('on', context)!,
                              textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                            )),
                            const CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 29,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorResources.footerCol0r,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                            ),
                            Expanded(
                                child: Text(getTranslated('off', context)!,
                                    textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall)
                            )),
                          ],
                        ),
                      ),
              ),
        ));
  }
}
