import 'package:flutter_restaurant/data/model/response/product_model.dart';

class OrderDetailsModel {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  Product? _productDetails;
  List<Variation>? _variations;
  List<OldVariation>? _oldVariations;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  List<int>? _addOnIds;
  List<double>? _addOnPrices;
  List<int>? _addOnQtys;
  double? _addOnTaxAmount;

  OrderDetailsModel({
    int? id,
    int? productId,
    int? orderId,
    double? price,
    Product? productDetails,
    List<Variation>? variations,
    List<OldVariation>? oldVariations,
    double? discountOnProduct,
    String? discountType,
    int? quantity,
    double? taxAmount,
    String? createdAt,
    String? updatedAt,
    List<int>? addOnIds,
    List<int>? addOnQtys,
    double? addOnTaxAmount,
    List<double>? addOnPrices,
  }) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _productDetails = productDetails;
    _oldVariations = oldVariations;
    _variations = variations;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _addOnIds = addOnIds;
    _addOnQtys = addOnQtys;
    _addOnTaxAmount = addOnTaxAmount;
    _addOnPrices = addOnPrices;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  Product? get productDetails => _productDetails;
  List<Variation>? get variations => _variations;
  List<OldVariation>? get oldVariations => _oldVariations;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<int>? get addOnIds => _addOnIds;
  List<int>? get addOnQtys => _addOnQtys;
  double? get addOnTaxAmount => _addOnTaxAmount;
  List<double>? get addOnPrices => _addOnPrices;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _productDetails = Product.fromJson(json['product_details']);

    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if (json['variation'][0]['values'] != null) {
        _variations = [];
        json['variation'].forEach((v) {
          _variations!.add(Variation.fromJson(v));
        });
      } else {
        _oldVariations = [];
        json['variation'].forEach((v) {
          _oldVariations!.add(OldVariation.fromJson(v));
        });
      }
    }

    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_on_qtys'] != null) {
      _addOnQtys = [];
      json['add_on_qtys'].forEach((qun) {
        try {
          _addOnQtys!.add(int.parse(qun));
        } catch (e) {
          _addOnQtys!.add(qun);
        }
      });
    }

    // if(json['add_on_prices'] != null) {
    //   _addOnPrices = [];
    //   json['add_on_prices'].forEach((qun) {
    //     try {
    //       _addOnPrices?.add( double.parse('$qun'));
    //     }catch(e) {
    //       _addOnPrices?.add(qun);
    //     }

    //   });
    // }
    _addOnTaxAmount = double.tryParse('${json['add_on_tax_amount']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['variation'] = _variations;
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['add_on_ids'] = _addOnIds;
    data['add_on_qtys'] = _addOnQtys;
    data['add_on_tax_amount'] = _addOnTaxAmount;
    data['add_on_prices'] = _addOnPrices;
    if (_variations != null) {
      data['variations'] = _variations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OldVariation {
  String? type;
  double? price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = double.tryParse('${json['price']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}
