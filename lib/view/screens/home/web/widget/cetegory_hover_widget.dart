import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';

class CategoryHoverWidget extends StatelessWidget {
  final List<CategoryModel>? categoryList;
  const CategoryHoverWidget({Key? key, required this.categoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(
          children: categoryList!.map((category) => InkWell(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 100)).then((value) async{
               await Navigator.pushNamed(
                  context, Routes.getCategoryRoute(category),
                );
               Navigator.of(Get.context!).pop();

               Navigator.pushNamed(
                 Get.context!, Routes.getCategoryRoute(category),
               );


              } );


            },
            child: OnHover(
                builder: (isHover) {
                  String? name = '';
                  category.name!.length > 25 ? name = '${category.name!.substring(0, 25)} ...' : name = category.name;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(color: isHover ? Theme.of(context).secondaryHeaderColor.withOpacity(0.4) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(name!, overflow: TextOverflow.ellipsis),
                        ),
                        const Icon(Icons.chevron_right, size: Dimensions.paddingSizeDefault),
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
}
