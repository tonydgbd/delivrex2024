import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/time_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class TimerView extends StatefulWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
        builder: (context, orderTimer, child) {
          int? days, hours, minutes, seconds;
          if (orderTimer.duration != null) {
            days = orderTimer.duration!.inDays;
            hours = orderTimer.duration!.inHours - days * 24;
            minutes = orderTimer.duration!.inMinutes - (24 * days * 60) - (hours * 60);
            seconds = orderTimer.duration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
          }
          return Column( children: [
            Image.asset(Images.deliveryManGif, height: 200),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              minutes! < 5 ? getTranslated('be_prepared_your_food', context)! : getTranslated('your_food_delivery', context)!,
              style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            days! > 0 || hours! > 0 ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if(days > 0) TimerBox(time: days, text: getTranslated('day', context), isBorder: true),
                if(days > 0) const SizedBox(width: 5),

                if(days > 0) Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                if(days > 0) const SizedBox(width: 5),

                TimerBox(time: hours, text: getTranslated('hour', context), isBorder: true),
                const SizedBox(width: 5),

                Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                const SizedBox(width: 5),

                TimerBox(time: minutes, text: getTranslated('min', context), isBorder: true),
                const SizedBox(width: 5),

                Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                const SizedBox(width: 5),
                TimerBox(time: seconds,text: getTranslated('sec', context), isBorder: true,),

                const SizedBox(width: 5),
              ]),
            ) :

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${minutes < 5 ? 0 : minutes - 5} - ${minutes < 5 ? 5 : minutes}',
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(getTranslated('min', context)!, style: rubikRegular.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeLarge,
              )),

            ],),


          ],);

        }
    );
  }
}


class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;
  final String? text;

  const TimerBox({Key? key,  this.time, this.isBorder = false, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isBorder ? null : Theme.of(context).primaryColor,
        border: isBorder ? Border.all(width: 1, color: Theme.of(context).primaryColor) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(time! < 10 ? '0$time' : time.toString(),
              style: rubikMedium.copyWith(
                color: isBorder ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
            Text(text!, style: rubikRegular.copyWith(color: isBorder ?
            Theme.of(context).primaryColor : Theme.of(context).highlightColor,
              fontSize: Dimensions.fontSizeSmall,)),
          ],
        ),
      ),
    );
  }
}

