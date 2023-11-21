class BannerModel {
  int? _id;
  String? _title;
  String? _image;
  int? _productId;
  String? _createdAt;
  String? _updatedAt;
  int? _categoryId;

  BannerModel(
      {int? id,
      String? title,
      String? image,
      int? productId,
      int? status,
      String? createdAt,
      String? updatedAt,
      int? categoryId}) {
    _id = id;
    _title = title;
    _image = image;
    _productId = productId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryId = categoryId;
  }

  int? get id => _id;
  String? get title => _title;
  String? get image => _image;
  int? get productId => _productId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get categoryId => _categoryId;

  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _productId = json['product_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _image;
    data['product_id'] = _productId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['category_id'] = _categoryId;
    return data;
  }
}
