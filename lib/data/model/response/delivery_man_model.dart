class DeliveryManModel {
  int? _id;
  int? _orderId;
  int? _deliverymanId;
  String? _time;
  String? _longitude;
  String? _latitude;
  String? _location;
  String? _createdAt;
  String? _updatedAt;

  DeliveryManModel(
      {int? id,
        int? orderId,
        int? deliverymanId,
        String? time,
        String? longitude,
        String? latitude,
        String? location,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _orderId = orderId;
    _deliverymanId = deliverymanId;
    _time = time;
    _longitude = longitude;
    _latitude = latitude;
    _location = location;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get orderId => _orderId;
  int? get deliverymanId => _deliverymanId;
  String? get time => _time;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get location => _location;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  DeliveryManModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _deliverymanId = json['deliveryman_id'];
    _time = json['time'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _location = json['location'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['order_id'] = _orderId;
    data['deliveryman_id'] = _deliverymanId;
    data['time'] = _time;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['location'] = _location;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}