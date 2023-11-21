import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonView extends StatelessWidget {
  final bool isRow;
  const BranchButtonView({
    Key? key, this.isRow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
        return  splashProvider.isBranchSelectDisable() ?  Consumer<BranchProvider>(
            builder: (context, branchProvider, _) {
              return branchProvider.getBranchId() != -1 ? InkWell(
                  onTap: ()=>  Navigator.pushNamed(context, Routes.getBranchListScreen()),
                  child: isRow ? Row(children: [
                    Row(children: [
                      Image.asset(
                        Images.branchIcon, color: Colors.white, height: Dimensions.paddingSizeDefault,
                      ),

                      const RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: Colors.white, size: Dimensions.paddingSizeDefault)),
                      const SizedBox(width: 2),

                      Text(
                        branchProvider.getBranch()!.name!,
                        style:  poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ]) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [
                        Image.asset(
                          Images.branchIcon, color: Theme.of(context).textTheme.bodyLarge!.color, height: Dimensions.paddingSizeDefault,
                        ),
                        RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: Theme.of(context).textTheme.bodyLarge!.color, size: Dimensions.paddingSizeDefault))
                      ]),
                      const SizedBox(height: 2),


                      Text(
                        branchProvider.getBranch()!.name!,
                        style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )) : const SizedBox();
            }
        ) : const SizedBox();
      }
    );
  }
}