import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/models/notification_list_model.dart';
import 'package:lovica_sales_app/services/provider_helper_class.dart';

import '../common/helpers.dart';

class NotificationProvider extends ChangeNotifier with ProviderHelperClass {
  List<NotificationItem>? notificationList = [];
  List<NotificationItem>? genList = [];
  List<NotificationItem>? genListToday = [];
  List<NotificationItem>? genListTodaySorted = [];
  List<NotificationItem>? indList = [];
  List<NotificationItem>? indListToday = [];
  List<NotificationItem>? transList = [];
  List<NotificationItem>? transListToday = [];
  NotificationList? model;
  int? totPdtCountAftrPagination = 0;
  int? totPdtCount = 0;
  int? unReadCount = 0;
  String? date;
  bool paginationLoader = false;
  bool unreadMessagesFound = false;
  static BuildContext? bContext;

  Future<void> getNotificationList(
      {required BuildContext context,
        int? limit,
        int? start,
        bool? initialLoad = false}) async {
    if (initialLoad!) {
      updateLoadState(LoadState.loading);
    } else {
      updatePaginationLoader(true);
    }
    notifyListeners();
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;
        _resp =
        await serviceConfig.getNotificationList(start: start, limit: limit);
        if (initialLoad!) {
          updateLoadState(LoadState.loaded);
        } else {
          updatePaginationLoader(false);
        }
        if (_resp != null && _resp["msg"] != null) {
          if (_resp["status_code"] == 200) {
            model = NotificationList.fromJson(_resp);
            if (model != null && model?.data != null) {
              totPdtCount = model?.totalCount ?? 0;
              if (initialLoad ?? true) {
                notificationList = model?.data ?? [];
                updateListValue();
              } else {
                List<NotificationItem>? _notificationList = [];
                _notificationList = model?.data ?? [];
                if (_notificationList.isNotEmpty) {
                  notificationList!.addAll(_notificationList);
                  notificationList = [
                    ...?notificationList,
                    ..._notificationList
                  ];
                  updateListValue();
                } else {
                  print("Entered initial load false list empty");
                }
              }
              totPdtCountAftrPagination = notificationList?.length ?? 0;
              notifyListeners();
            }
          } else {
            notificationList = [];
            notifyListeners();
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  void clearList() {
    notificationList = [];
    genList = [];
    genListToday = [];
    transList = [];
    transListToday = [];
    indList = [];
    indListToday = [];
    notifyListeners();
  }

  void updateListValue() {
    if (notificationList?.isNotEmpty ?? true) {
      unReadCount = 0;
      for (int i = 0; i < notificationList!.length; i++) {
        if (notificationList![i].messageRead == 0) {
          unReadCount = unReadCount! + 1;
          notifyListeners();
        }

        if (notificationList![i].type == "Individual") {
          indList!.add(notificationList![i]);
        } else if (notificationList![i].type == "General") {
          genList!.add(notificationList![i]);
        } else {
          transList!.add(notificationList![i]);
        }
      }
      if (unReadCount! > 0) {
        unreadMessagesFound = true;
        notifyListeners();
      } else {
        unreadMessagesFound = false;
        notifyListeners();
      }
      updateEachListByDate();
    }
    notifyListeners();
  }

  void updateEachListByDate() {
    String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    for (int i = 0; i < genList!.length; i++) {
      if (genList![i].date == currentDate) {
        genListToday!.add( genList![i]);
        genList!.remove(genList![i]);
        // genListTodaySorted = genListToday!.map((e) => e).toList()
        // ..sort((a,b) =>
        // DateTime.parse(genListToday![i].dateFormatted!).compareTo(DateTime.parse(currentDate)));

      }
    }
    for (int i = 0; i < indList!.length; i++) {
      if (indList![i].date == currentDate) {
        indListToday!.add(indList![i]);
        indList!.remove(indList![i]);
      }
    }
    for (int i = 0; i < transList!.length; i++) {
      if (transList![i].date == currentDate) {
        transListToday!.add(transList![i]);
        transList!.remove(transList![i]);
      }
    }
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  Future<bool> readNotification({
    required BuildContext context,
    required String id,
  }) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;

        _resp = await serviceConfig.readNotification(id: id);

        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        if (_resp != null && _resp["msg"] != null) {
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            isUpdated = true;
            notifyListeners();
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isUpdated;
  }

  static void setContext(BuildContext context) {
    bContext = context;
  }
}
