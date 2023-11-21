import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_dialog.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/branch/widget/bracnh_cart_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'widget/branch_close_view.dart';
import 'widget/branch_item_view.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({Key? key}) : super(key: key);

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  List<BranchValue> _branchesValue = [];
  Set<Marker> _markers = HashSet<Marker>();
  late GoogleMapController _mapController;
  LatLng? _currentLocationLatLng;
  AutoScrollController? scrollController;





  @override
  void initState() {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    branchProvider.updateTabIndex(0, isUpdate: false);
    ///if need to previous selection
    if(branchProvider.getBranchId() == -1) {
      branchProvider.updateBranchId(null, isUpdate: false);
    } else{
      branchProvider.updateBranchId(branchProvider.getBranchId(),isUpdate: false);
    }


    Provider.of<LocationProvider>(context, listen: false).getCurrentLatLong().then((latLong){
      if(latLong != null) {
        _currentLocationLatLng = latLong;
      }
      _branchesValue = branchProvider.branchSort(_currentLocationLatLng);
    });


    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return WillPopScope(
          onWillPop: () async {
            if (branchProvider.branchTabIndex != 0) {
              branchProvider.updateTabIndex(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            appBar: (ResponsiveHelper.isDesktop(context)
                ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
                : CustomAppBar(context: context, title: getTranslated('select_branch', context))) as PreferredSizeWidget?,

            body: Center(child: SizedBox(
              width: Dimensions.webScreenWidth,
              child: splashProvider.getActiveBranch() == 0 ? const BranchCloseView() :
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: branchProvider.branchTabIndex == 1 ? Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(_branchesValue[0].branches!.latitude!),
                              double.parse(_branchesValue[0].branches!.longitude!),
                            ), zoom: 5,
                          ),
                          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                          zoomControlsEnabled: true,
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) async {
                            await Geolocator.requestPermission();
                            _mapController = controller;
                            // _loading = false;
                            _setMarkers(1);
                          },
                        ),

                        Positioned.fill(child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(children: _branchesValue.map((branchValue) => AutoScrollTag(
                              controller: scrollController!,
                              key: ValueKey(_branchesValue.indexOf(branchValue)),
                              index: _branchesValue.indexOf(branchValue),
                              child: BranchCartView(
                                branchModel: branchValue,
                                branchModelList: _branchesValue,
                                onTap: ()=> _setMarkers(_branchesValue.indexOf(branchValue), fromBranchSelect: true),
                              ),
                            )).toList(),
                            ),
                          ),
                        )),


                      ],
                    ) : Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${getTranslated('nearest_branch', context)} (${_branchesValue.length})', style: rubikBold),

                          GestureDetector(
                            onTap: ()=> branchProvider.updateTabIndex(1),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Theme.of(context).primaryColor),

                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 25, width: 25,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: Provider.of<LocalizationProvider>(context, listen: false).isLtr ?
                                      const BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                      ) : const BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                    child: const Icon(Icons.my_location_rounded, color: Colors.white, size: Dimensions.paddingSizeDefault,),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      getTranslated('select_from_map', context)!,
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          )

                        ],),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        _branchesValue.isNotEmpty ? Flexible(child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 50,
                            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 3.6 : 2.8,
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : MediaQuery.of(context).size.width > 780 ? 2 : 1,
                          ),
                          itemCount: _branchesValue.length,
                          itemBuilder: (context, index) => BranchItemView(
                            branchesValue: _branchesValue[index],
                          ),
                        )) : const CircularProgressIndicator(),

                      ]),
                    ),
                  ),

                  Container(
                    width: Dimensions.webScreenWidth,
                    padding: const EdgeInsets.all(Dimensions.fontSizeDefault),
                    child: Consumer<BranchProvider>(builder: (context,branchProvider, _) {
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                      return CustomButton(
                          btnTxt: getTranslated('confirm_branch', context),
                          borderRadius: 30, onTap: (){
                        if(branchProvider.selectedBranchId != null) {
                          if(branchProvider.selectedBranchId != branchProvider.getBranchId() && cartProvider.cartList.isNotEmpty) {
                            showAnimatedDialog(
                              context, CustomDialog(
                              buttonTextTrue: getTranslated('yes', context),
                              buttonTextFalse: getTranslated('no', context),
                              description: '',
                              icon: Icons.question_mark,
                              title: getTranslated('you_have_some_food', context),
                              onTapTrue: (){
                                cartProvider.clearCartList();
                                _setBranch();
                              },
                              onTapFalse: ()=> Navigator.of(context).pop(),
                            ), dismissible: false, isFlip: true,
                            );
                          }else{
                            if(branchProvider.branchTabIndex != 0) {
                              branchProvider.updateTabIndex(0, isUpdate: false);
                            }

                            _setBranch();

                          }


                        }else{
                          showCustomSnackBar(getTranslated('select_branch_first', context));
                        }
                      });
                    }),
                  ),
                ]),
            )),



          ),
        );
      }
    );
  }

  void _setBranch() {

    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    if(branchProvider.getBranchId() != branchProvider.selectedBranchId) {
      branchProvider.setBranch(branchProvider.selectedBranchId!);
      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
      showCustomSnackBar(getTranslated('branch_successfully_selected', context), isError: false);
    }else{
      showCustomSnackBar(getTranslated('this_is_your_current_branch', context));
    }

  }


  void _setMarkers(int selectedIndex, {bool fromBranchSelect = false}) async {
    await scrollController!.scrollToIndex(selectedIndex, preferPosition: AutoScrollPosition.middle);
    await scrollController!.highlight(selectedIndex);

    late BitmapDescriptor bitmapDescriptor;
    late BitmapDescriptor bitmapDescriptorUnSelect;
    late BitmapDescriptor currentLocationDescriptor;

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.restaurantMarker).then((marker) {
      bitmapDescriptor = marker;
    });

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(25, 40)), Images.restaurantMarkerUnselect).then((marker) {
      bitmapDescriptorUnSelect = marker;
    });

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.currentLocationMarker).then((marker) {
      currentLocationDescriptor = marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index <_branchesValue.length; index++) {

      _markers.add(Marker(
        onTap: () async {
          if(_branchesValue[index].branches!.status!) {
            Provider.of<BranchProvider>(context, listen: false).updateBranchId(_branchesValue[index].branches!.id);
          }},
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branchesValue[index].branches!.latitude!), double.parse(_branchesValue[index].branches!.longitude!)),
        infoWindow: InfoWindow(title: _branchesValue[index].branches!.name, snippet:_branchesValue[index].branches!.address), visible: _branchesValue[index].branches!.status! ,
        icon: selectedIndex == index ? bitmapDescriptor : bitmapDescriptorUnSelect,
      ));
    }
    if(_currentLocationLatLng != null) {
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocationLatLng!,
        infoWindow: InfoWindow(title: getTranslated('current_location', Get.context!), snippet: ''),
        icon: currentLocationDescriptor,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentLocationLatLng != null && !fromBranchSelect ? _currentLocationLatLng! : LatLng(
        double.parse(_branchesValue[selectedIndex].branches!.latitude!),
        double.parse(_branchesValue[selectedIndex].branches!.longitude!),
      ),
      zoom: ResponsiveHelper.isMobile() ? 12 : 16,
    )));

    setState(() {});
  }




}



