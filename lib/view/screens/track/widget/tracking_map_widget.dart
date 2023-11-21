import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/delivery_man_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:collection';
import 'dart:ui';

class TrackingMapWidget extends StatefulWidget {
  final DeliveryManModel? deliveryManModel;
  final String? orderID;
  final AddressModel? addressModel;
  const TrackingMapWidget({Key? key, required this.deliveryManModel, required this.orderID, required this.addressModel}) : super(key: key);

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  late LatLng _deliveryBoyLatLng;
  late LatLng _addressLatLng;
  late LatLng _restaurantLatLng;

  @override
  void initState() {
    super.initState();

    RestaurantLocationCoverage coverage = Provider.of<SplashProvider>(context, listen: false).configModel!.restaurantLocationCoverage!;
    _deliveryBoyLatLng = LatLng(double.parse(widget.deliveryManModel!.latitude ?? '0'), double.parse(widget.deliveryManModel!.longitude ?? '0'));
    _addressLatLng = widget.addressModel != null ? LatLng(double.parse(widget.addressModel!.latitude!), double.parse(widget.addressModel!.longitude!)) : const LatLng(0,0);
    _restaurantLatLng = LatLng(double.parse(coverage.latitude!), double.parse(coverage.longitude!));
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 200, width: ResponsiveHelper.isMobilePhone() ? width - 130 : 1170.0 - 100.0,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget.deliveryManModel!.latitude != null ? Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: _addressLatLng, zoom: 18),
            zoomControlsEnabled: true,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _isLoading = false;
              setMarker();
            },
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            onTap: (latLng) async {
              await Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(widget.orderID);
              String url ='https://www.google.com/maps/dir/?api=1&origin=${widget.deliveryManModel!.latitude},${widget.deliveryManModel!.longitude}'
                  '&destination=${_addressLatLng.latitude},${_addressLatLng.longitude}&mode=d';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),

          _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox(),
        ],
      ) : FittedBox(child: Text(getTranslated('no_delivery_man_data_found', context)!)),
    );
  }

  void setMarker() async {
    try {

      late BitmapDescriptor restaurantImageData;
      late BitmapDescriptor deliveryBoyImageData;
      late BitmapDescriptor destinationImageData;

      await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.restaurantMarker).then((marker) {
        restaurantImageData = marker;
      });

      await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.deliveryBoyMarker).then((marker) {
        deliveryBoyImageData = marker;
      });

      await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.destinationMarker).then((marker) {
        destinationImageData = marker;
      });

      // Uint8List restaurantImageData = await convertAssetToUnit8List(
      //   Images.restaurant_marker, width: ResponsiveHelper.isMobilePhone() ? 50 : 5,
      // );
      // Uint8List deliveryBoyImageData = await convertAssetToUnit8List(
      //   Images.delivery_boy_marker, width: ResponsiveHelper.isMobilePhone() ? 50 : 5,
      // );
      //
      // Uint8List destinationImageData = await convertAssetToUnit8List(
      //   Images.destination_marker, width: ResponsiveHelper.isMobilePhone() ? 50 : 5,
      // );

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if (_controller != null) {
        if (_addressLatLng.latitude < _restaurantLatLng.latitude) {
          bounds = LatLngBounds(southwest: _addressLatLng, northeast: _restaurantLatLng);
          rotation = 0;
        } else {
          bounds = LatLngBounds(southwest: _restaurantLatLng, northeast: _addressLatLng);
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
          (bounds!.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: 5)));

      if(ResponsiveHelper.isMobilePhone()) {
        zoomToFit(_controller, bounds, centerBounds);
      }

      // Marker
      _markers = HashSet<Marker>();
      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: _addressLatLng,
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: '${_addressLatLng.latitude}, ${_addressLatLng.longitude}',
        ),
        icon: destinationImageData,
      ));

      _markers.add(Marker(
        markerId: const MarkerId('restaurant'),
        position: _restaurantLatLng,
        infoWindow: InfoWindow(
          title: 'Restaurant',
          snippet: '${_restaurantLatLng.latitude}, ${_restaurantLatLng.longitude}',
        ),
        icon: restaurantImageData,
      ));
      widget.deliveryManModel!.latitude != null ? _markers.add(Marker(
        markerId: const MarkerId('delivery_boy'),
        position: _deliveryBoyLatLng,
        infoWindow: InfoWindow(
          title: 'Delivery Man',
          snippet: '${_deliveryBoyLatLng.latitude}, ${_deliveryBoyLatLng.longitude}',
        ),
        rotation: rotation,
        icon: deliveryBoyImageData,
      )) : const SizedBox();
    }catch(e) {
      debugPrint('error ===> $e');
    }

    setState(() {});
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)){
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}
