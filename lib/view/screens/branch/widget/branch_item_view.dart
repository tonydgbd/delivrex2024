import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class BranchItemView extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchItemView({Key? key, this.branchesValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        return GestureDetector(
          onTap: (){
            if(branchesValue!.branches!.status!) {
              branchProvider.updateBranchId(branchesValue!.branches!.id);
            }else{
              showCustomSnackBar('${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
            }

          },
          child: Stack(children: [
            Opacity(
              opacity: branchesValue!.branches!.status! ? 1 : 0.7,
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(branchProvider.selectedBranchId == branchesValue!.branches!.id ? 0.8 : 0.1),width: 2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),

                  child: Stack(
                    children: [

                      Column(children: [
                        Expanded(child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(Dimensions.radiusDefault),
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                          ),
                          child: Stack(children: [
                            FadeInImage.assetNetwork(
                              placeholder: Images.branchBanner,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                              fit: BoxFit.cover,
                              width: Dimensions.webScreenWidth,
                              imageErrorBuilder:(c, o, s)=> Image.asset(Images.branchBanner, width: Dimensions.webScreenWidth,),
                            ),


                          ]),
                        )),

                        Expanded(child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),
                            ),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Image.asset(Images.branchIcon, width: 20, height: 20),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(branchesValue!.branches!.name!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                              ]),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Row(children: [
                                Icon(Icons.location_on_outlined, size: 20, color: Theme.of(context).primaryColor),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(
                                  branchesValue!.branches!.address != null
                                      ? branchesValue!.branches!.address!.length > 25
                                      ? '${branchesValue!.branches!.address!.substring(0, 25)}...'
                                      : branchesValue!.branches!.address! : branchesValue!.branches!.name!,
                                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                ),

                              ]),
                            ]),

                           if(branchesValue!.distance != -1) Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                              Text('${branchesValue!.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                              const SizedBox(width: 3),

                              Text(getTranslated('away', context)!, style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                              )),

                            ],),
                          ]),

                        )),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]),

                      Positioned(right: 10, top: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderImage,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                              height: size.width < 400 ? 38 : 50, width: size.width < 400 ? 38 : 50,
                              fit: BoxFit.cover,
                              imageErrorBuilder:(c, o, s)=> Image.asset(Images.placeholderImage, width: size.width < 400 ? 38 : 50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
            ),

           if(!branchesValue!.branches!.status!) Container(
             margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
             padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
             decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(branchProvider.selectedBranchId == branchesValue!.branches!.id ? 0.8 : 0.1),width: 2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
             child: Align(
               alignment: Alignment.topLeft,
               child:Container(
                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                 decoration: BoxDecoration(
                   color: Theme.of(context).primaryColor,
                   border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1),width: 2),
                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),


                 ),
                 child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                   const Icon(
                     Icons.schedule_outlined,
                     color: Colors.white,
                     size: Dimensions.paddingSizeLarge,
                   ),
                   const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                   Text(
                     getTranslated('close_now', context)!,
                     style: rubikRegular.copyWith(
                       fontSize: Dimensions.fontSizeDefault,
                       color: Colors.white,
                     ),
                   ),

                 ],),
               ),
             ),
            ),



          ]),
        );
      }
    );
  }
}