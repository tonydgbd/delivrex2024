import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchCartView extends StatelessWidget {
  final BranchValue? branchModel;
  final List<BranchValue>? branchModelList;
  final VoidCallback? onTap;
  const BranchCartView({
    Key? key, this.branchModel, this.onTap, this.branchModelList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          return GestureDetector(onTap: branchModel!.branches!.status! ?  () {
            branchProvider.updateBranchId(branchModel!.branches!.id);
            onTap!();
          } : null, child: Container(
            width: 320,
            margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall).copyWith(bottom: Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: branchProvider.selectedBranchId == branchModel!.branches!.id
                    ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.6)) : null,
                boxShadow: [BoxShadow(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
                  blurRadius: 30, offset: const Offset(0, 3),
                )]
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholderRectangle,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.branchImageUrl}/${branchModel!.branches!.image}',
                      width: 60, fit: BoxFit.cover, height: 60,
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholderRectangle, width: 60, height: 60, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(branchModel!.branches!.name ?? '', style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(children: [
                      Image.asset(Images.branchIcon, width: 20, height: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(
                        branchModel!.branches!.address != null ? branchModel!.branches!.address!.length > 25 ? '${branchModel!.branches!.address!.substring(0, 25)}...' : branchModel!.branches!.address! : branchModel!.branches!.name!,
                        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),

                    ]),

                  ]),

                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge,),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                    Icon(
                      Icons.schedule_outlined,
                      color:branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error,
                      size: Dimensions.paddingSizeLarge,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(
                      getTranslated(branchModel!.branches!.status! ? 'open_now' : 'close_now', context)!,
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color:branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error,
                      ),
                    ),

                  ],),

                if(branchModel!.distance != -1)  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${branchModel!.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                    const SizedBox(width: 3),

                    Text(getTranslated('away', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ],),


                ]),



              ],
            ),
          ));
        }
    );
  }
}