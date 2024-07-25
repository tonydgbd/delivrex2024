import 'package:flutter/material.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/styles.dart';
import 'package:delivrex/view/base/on_hover.dart';
class AddButtonView extends StatelessWidget {
  final Function onTap;
  const AddButtonView({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: Dimensions.paddingSizeExtraSmall),
      child: OnHover(
        builder: (onHover) {
          return InkWell(
            onTap: onTap as void Function()?,
            hoverColor: Colors.transparent,
            child: Container(
              width: 110.0,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(getTranslated('add_new', context)!, style: rubikRegular.copyWith(color: Colors.white))
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}