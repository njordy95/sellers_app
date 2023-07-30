import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? nameID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedData;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  Items({
    this.nameID,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedData,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price
});

  Items.fromJson(Map<String, dynamic> json) {
    nameID = json['nameID'];
    sellerUID = json['sellerUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedData = json['publishedData'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nameID'] = nameID;
    data['sellerUID'] = sellerUID;
  data['itemID'] = itemID;
  data['title'] = title;
  data['shortInfo'] = shortInfo;
  data['publishedData'] = publishedData;
  data['thumbnailUrl'] = thumbnailUrl;
  data['longDescription'] = longDescription;
  data['status'] = status;
  data['price'] = price;

  return data;
}

}