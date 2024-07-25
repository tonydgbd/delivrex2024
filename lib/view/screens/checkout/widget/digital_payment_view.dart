import 'package:flutter/material.dart';
import 'package:delivrex/localization/app_localization.dart';
import 'package:delivrex/provider/order_provider.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/images.dart';
import 'package:delivrex/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DigitalPaymentView extends StatefulWidget {
  final List<String> paymentList;
  final List<Color> colorList;
  const DigitalPaymentView(
      {Key? key, required this.paymentList, required this.colorList})
      : super(key: key);

  @override
  State<DigitalPaymentView> createState() => _DigitalPaymentViewState();
}

class _DigitalPaymentViewState extends State<DigitalPaymentView> {
  AutoScrollController? scrollController;

  @override
  void initState() {
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.paymentList.map((method) {
          return AutoScrollTag(
            controller: scrollController!,
            key: ValueKey(widget.paymentList.indexOf(method)),
            index: widget.paymentList.indexOf(method),
            child:
                Consumer<OrderProvider>(builder: (context, orderProvider, _) {
              return InkWell(
                radius: 10,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () async {
                  orderProvider.setPaymentMethod(method);
                  await scrollController!.scrollToIndex(
                      widget.paymentList.indexOf(method),
                      preferPosition: AutoScrollPosition.middle);
                },
                child: Card(
                  color: orderProvider.paymentMethod == method
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : CardTheme.of(context).color,
                  shadowColor: orderProvider.paymentMethod == method
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : CardTheme.of(context).shadowColor,
                  child: Container(
                    width: 130,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    margin:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.replaceAll('_', ' ').toTitleCase(),
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            Image.asset(
                              Images.getPaymentImage(method),
                              height: 25,
                              width: 80,
                            ),
                          ],
                        ),
                        if (orderProvider.paymentMethod == method)
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Transform(
                                  transform:
                                      Matrix4.translationValues(0, 10, 0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 25,
                                  ),
                                )),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}
