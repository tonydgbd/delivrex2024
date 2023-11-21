import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final String method;
  const CustomCheckBox({Key? key, required this.title, required this.method}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setPaymentMethod(method),
          child: Row(children: [
            Checkbox(
              value: order.paymentMethod == method,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? isChecked) => order.setPaymentMethod(method),
            ),
            Expanded(
              child: Text(title, style: rubikRegular.copyWith(
                color: order.paymentMethod == method ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).hintColor.withOpacity(0.7),
              )),
            ),
          ]),
        );
      },
    );
  }
}
