class ChatModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Messages>? messages;

  ChatModel({this.totalSize, this.limit, this.offset, this.messages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? conversationId;
  CustomerId? customerId;
  DeliverymanId? deliverymanId;
  String? message;
  String? reply;
  List<String>? attachment;
  List<String>? image;
  bool? isReply;
  String? createdAt;
  String? updatedAt;

  Messages(
      {this.id,
        this.conversationId,
        this.customerId,
        this.deliverymanId,
        this.message,
        this.reply,
        this.attachment,
        this.image,
        this.isReply,
        this.createdAt,
        this.updatedAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    try{
      conversationId = json['conversation_id'];
    }catch(e) {
      conversationId = int.parse(json['conversation_id']);
    }
    if(json['customer_id']!=null){
      customerId = json['customer_id'] != null
          ? CustomerId.fromJson(json['customer_id'])
          : null;
    }

    if(json['deliveryman_id']!= null){
      deliverymanId = json['deliveryman_id'] != null
          ? DeliverymanId.fromJson(json['deliveryman_id'])
          : null;
    }
    message = json['message'];
    reply = json['reply'];
    if(json['attachment']!=null && json['attachment']!=[]){
      attachment = json['attachment'].cast<String>();
    }
    if(json['image']!=null){
      image = json['image'].cast<String>();
    }

    isReply = json['is_reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    if (customerId != null) {
      data['customer_id'] = customerId!.toJson();
    }
    if (deliverymanId != null) {
      data['deliveryman_id'] = deliverymanId!.toJson();
    }
    data['message'] = message;
    data['reply'] = reply;
    data['attachment'] = attachment;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;


    return data;
  }
}

class CustomerId {
  String? name;
  String? image;

  CustomerId({this.name, this.image});

  CustomerId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
class DeliverymanId {
  String? name;
  String? image;

  DeliverymanId({this.name, this.image});

  DeliverymanId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
