import 'package:flutter/cupertino.dart';

import '../common/constants.dart';
import 'order_list_model.dart';

class RouteArguments {
  String? title;
  String? orderNumber;
  String? id;
  String? customerID;
  String? catId;
  String? catName;
  String? mobile;
  int index;
  bool enableFullScreen;
  List<String>? categoriesIDs;
  Map<String, dynamic>? filter;
  Map<dynamic, dynamic>? sort;
  bool? isEditAddress;
  String? sku;
  String? apartmentSelectedFromLocation;
  double? latitude;
  double? longitude;
  int? reviewIndex;
  NavFromState? navFromState;
  String? incrementId;
  String? reviewImageUrl;
  String? reviewProductName;
  bool? isFromOrders;
  String? searchKey;
  String? productId;
  String? combinationId;
  String? prodType;
  String? quantity;
  String? from;
  String? orderNum;
  String? uName;
  String? subCatChildName;
  OrderItem? orderItem;
  String? countryID;

  RouteArguments(
      {this.title,
      this.id,
      this.customerID,
      this.orderItem,
      this.uName,
      this.orderNum,
      this.catId,
      this.catName,
      this.productId,
      this.combinationId,
      this.prodType,
      this.quantity,
      this.from,
      this.mobile,
      this.sku,
      this.index = 0,
      this.enableFullScreen = false,
      this.isEditAddress,
      this.apartmentSelectedFromLocation,
      this.latitude,
      this.longitude,
      this.categoriesIDs,
      this.filter,
      this.sort,
      this.reviewIndex,
      this.searchKey,
      this.navFromState,
      this.incrementId,
      this.reviewImageUrl,
      this.reviewProductName,
      this.orderNumber,
      this.subCatChildName,
      this.isFromOrders,
        this.countryID,
      });
}
