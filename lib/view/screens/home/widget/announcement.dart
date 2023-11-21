import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/screens/home/widget/marque_text.dart';

class AnnouncementView extends StatelessWidget {
  final String? announcement;
  const AnnouncementView({Key? key, this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      alignment: Alignment.center,
       color: Theme.of(context).primaryColor.withOpacity(0.9),
        child: MarqueeWidget(direction: Axis.horizontal,
          child: Text(announcement!, style: TextStyle(color: Theme.of(context).cardColor), maxLines: 2, textAlign: TextAlign.center),
        ));
  }
}
