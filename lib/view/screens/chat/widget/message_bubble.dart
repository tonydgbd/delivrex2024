import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

import 'image_diaglog.dart';

class MessageBubble extends StatelessWidget {
  final Messages? messages;
  final bool? isAdmin;
  const MessageBubble({Key? key, this.messages, this.isAdmin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    return !isAdmin! ? messages!.deliverymanId != null ?
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),

      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messages!.deliverymanId!.name??'',style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholderUser, fit: BoxFit.cover, width: 40, height: 40,
                        image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.deliveryManImageUrl}/${messages!.deliverymanId!.image??''}',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, fit: BoxFit.cover, width: 40, height: 40),
                      ),
                    ),
                  ),
                ),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(messages!.message != null) Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(messages!.message != null?Dimensions.paddingSizeDefault:0),
                            child: Text(messages!.message ?? ''),
                          ),
                        ),
                      ),
                      if( messages!.attachment !=null) const SizedBox(height: Dimensions.paddingSizeSmall),
                      messages!.attachment !=null? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 3,
                          crossAxisSpacing: 5, mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messages!.attachment!.length,
                        itemBuilder: (BuildContext context, index){
                          return  messages!.attachment!.isNotEmpty?
                          InkWell(
                            onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl: messages!.attachment![index]), ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:FadeInImage.assetNetwork(
                                placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                image: messages!.attachment![index],
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover),
                              ),
                            ),
                          ):const SizedBox();

                        },):const SizedBox(),
                    ],
                  ),
                ),

              ],
            ),





            const SizedBox(height: Dimensions.paddingSizeSmall),
            const SizedBox(),
            Text(DateConverter.formatDate(DateConverter.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),),
          ],
        ),
      ),
    ):
    Padding(
      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          //color: Colors.red
        ),

        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${profileProvider.userInfoModel!.fName} ${profileProvider.userInfoModel!.lName}',style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(messages!.message != null) Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(messages!.message != null ? Dimensions.paddingSizeDefault:0),
                              child: Text(messages!.message??''),
                            ),
                          ),
                        ),
                        messages!.attachment != null ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
                        messages!.attachment !=null? Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8: 3,
                              crossAxisSpacing: 5, mainAxisSpacing: 5,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: messages!.attachment!.length,
                            itemBuilder: (BuildContext context, index){
                              return  (messages!.attachment!.isNotEmpty) ?
                              InkWell(
                                onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl: messages!.attachment![index]), ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                    image: messages!.attachment![index],
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover),
                                  ),
                                ),
                              ):const SizedBox();

                            },),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    child: Container(width: 40, height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholderImage, fit: BoxFit.cover, width: 40, height: 40,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, fit: BoxFit.cover),
                          image: Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null?
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}':'',
                        ),
                      ),
                    ),
                  ),
                ],
              ),




              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(DateConverter.formatDate(DateConverter.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),),

            ],
          ),
        ),
      ),
    )
    //customer to admin
        :Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: (messages!.isReply != null && messages!.isReply!) ?
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

        ),

        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${Provider.of<SplashProvider>(context,listen: false).configModel!.restaurantName}',style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.logo, fit: BoxFit.cover, width: 40, height: 40,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.restaurantImageUrl}/${Provider.of<SplashProvider>(context,listen: false).configModel!.restaurantName}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, fit: BoxFit.contain, width: 40, height: 40),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),


                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(messages!.reply != null && messages!.reply!.isNotEmpty)  Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(messages!.reply != null ? Dimensions.paddingSizeDefault:0),
                              child: Text(messages!.reply ?? ''),
                            ),
                          ),
                        ),
                        if(messages!.reply != null && messages!.reply!.isNotEmpty) const SizedBox(height: 8.0),

                        messages!.image != null ?
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 3,
                            crossAxisSpacing: 5, mainAxisSpacing: 5,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages!.image!.length,
                          itemBuilder: (BuildContext context, index){
                            return  messages!.image!.isNotEmpty ?
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.chatImageUrl}/${messages!.image![index]}'), ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: (messages!.message != null && messages!.message!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                    image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.chatImageUrl}/${messages!.image![index]}',
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ):const SizedBox();

                          },):const SizedBox(),


                      ],
                    ),
                  ),

                ],
              ),





              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(DateConverter.formatDate(DateConverter.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),),
            ],
          ),
        ),
      ):

      Padding(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

          ),

          child: Consumer<ProfileProvider>(
              builder: (context, profileController,_) {
                return Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${profileController.userInfoModel != null ? profileController.userInfoModel!.fName ?? '' : ''} ${profileController.userInfoModel != null?profileController.userInfoModel!.lName ?? '' : ''}', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (messages!.message != null && messages!.message!.isNotEmpty) ? Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(messages!.message != null ? Dimensions.paddingSizeDefault : 0),
                                    child: Text(messages!.message ?? ''),
                                  ),
                                ),
                              ) : const SizedBox(),
                              messages!.image != null ?
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: GridView.builder(
                                  //reverse: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 3,
                                      crossAxisSpacing: 5, mainAxisSpacing: 5
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: messages!.image!.length,
                                  itemBuilder: (BuildContext context, index){
                                    return  messages!.image!.isNotEmpty ?
                                    InkWell(
                                      onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl: messages!.image![index])),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: (messages!.message != null && messages!.message!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,                                       ),
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                            image: messages!.image![index],
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ):const SizedBox();

                                  },),
                              ):const SizedBox(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          child: Container(width: 40, height: 40,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholderImage, fit: BoxFit.cover, width: 40, height: 40,
                                image: profileController.userInfoModel != null? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileController.userInfoModel!.image}':'',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, fit: BoxFit.cover, width: 40, height: 40,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(DateConverter.formatDate(DateConverter.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
