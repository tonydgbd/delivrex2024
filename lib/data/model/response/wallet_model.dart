
class WalletModel {

  int? totalSize;
  String? limit;
  String? offset;
  List<Transaction>? data;

  WalletModel({this.totalSize, this.limit, this.offset, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
     totalSize = json["total_size"];
     limit = json["limit"].toString();
     offset = json["offset"].toString();
     if (json['data'] != null) {
       data = [];
     json['data'].forEach((v) {
       data!.add(Transaction.fromJson(v));
     });
     }
  }

  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['total_size'] = totalSize;
      data['limit'] = limit;
      data['offset'] = offset;
      if (this.data != null) {
       data['data'] = this.data!.map((v) => v.toJson()).toList();
      }
      return data;
  }
}

class Transaction {

  int? userId;
  String? transactionId;
  double? credit;
  double? debit;
  double? adminBonus;
  double? balance;
  double? loyaltyAmount;
  String? transactionType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.userId,
    this.transactionId,
    this.credit,
    this.debit,
    this.adminBonus,
    this.balance,
    this.loyaltyAmount,
    this.transactionType,
    this.createdAt,
    this.updatedAt,
  });


  Transaction.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    transactionId = json["transaction_id"];
    credit = json["credit"].toDouble();
    debit = json["debit"].toDouble();
    if(json["admin_bonus"] != null){
      adminBonus = json["admin_bonus"].toDouble();
    }
    if(json['balance'] != null) {
      balance = double.parse('${json['balance']}');
    }
    if(json['amount'] != null) {
      balance = double.parse('${json['amount']}');
    }

    transactionType = json["transaction_type"] ?? json['type'] ?? '';
    if(json["created_at"] != null) {
      createdAt =  DateTime.parse(json["created_at"]);
    }
    if(json["created_at"] != null) {
      updatedAt = DateTime.parse(json["updated_at"]);
    }

  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
    data["user_id"] = userId;
    data["transaction_id"] = transactionId;
    data["credit"] = credit;
    data["debit"] = debit;
    data["admin_bonus"] = adminBonus;
    data["balance"] = balance;
    data["transaction_type"] = transactionType;
    data["created_at"] = createdAt!.toIso8601String();
    data["updated_at"] = updatedAt!.toIso8601String();
  return data;
  }
}
