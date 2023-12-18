import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/models/country_model_class.dart';
import 'package:lovica_sales_app/models/report_model_class.dart';
import 'package:lovica_sales_app/providers/check_out_provider.dart';
import 'package:lovica_sales_app/services/provider_helper_class.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../common/helpers.dart';
import '../models/city_model.dart';
import '../models/customer_model.dart';
import '../models/customer_model_class.dart';
import '../services/app_data.dart';

class CustomerProvider extends ChangeNotifier with ProviderHelperClass {
  CustomerModel? customerModel;
  List<Customer> customerList = [];
  CountryModelClass? countryModelClass;
  CustomerModelClass? customerModelClass;
  CustomerData? customerModelForEditCustomer;

  ReportModelClass? reportModel;
  ReportData? reportData;
  List<Country> countryList = [];
  TotalCustomers? totalCustomers;
  TotalCustomers? totalOrders;
  TotalCustomers? activeOrders;
  TotalCustomers? completedOrders;
  TotalCustomers? daysWorked;
  TotalCustomers? earnings;
  List<TotalCustomers> data = [];
  int? totPdtCountAftrPagination = 0;
  int? totPdtCount = 0;
  bool paginationLoader = false;
  Country? countrySelected;
  Cities? cityModel;
  List<City> cityList = [];
  City? selectedCityForEditCustomer;

  Future<bool> getCustomers(String city, String search,
      {required BuildContext context,
      required int? start,
      required int? limit,
      required initialLoad}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    if (initialLoad!) {
      updateLoadState(LoadState.loading);
    } else {
      updatePaginationLoader(true);
    }
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCustomers(
            city, search, limit ?? 0, start ?? 0);
        updateLoadState(LoadState.loaded);

        if (initialLoad!) {
          updateLoadState(LoadState.loaded);
        } else {
          updatePaginationLoader(false);
        }
        if (_resp != null && _resp["status_code"] == 200) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            customerModel = CustomerModel.fromJson(_resp);
            totPdtCount = customerModel?.totalPdtCount ?? 0;

            if (initialLoad ?? true) {
              customerList = customerModel?.customerList ?? [];
            } else {
              List<Customer>? _customerList = [];
              _customerList = customerModel?.customerList ?? [];
              if (_customerList.isNotEmpty) {
                customerList!.addAll(_customerList);
                customerList = [...?customerList, ..._customerList];
              } else {
                print("Entered initial load false list empty");
              }
              print(customerList?.length);
            }
            totPdtCountAftrPagination = customerList?.length ?? 0;

            notifyListeners();
            return true;
          }
        } else {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          return false;
        }
      } catch (_) {
        updateLoadState(LoadState.error);
        return false;
      }
    } else {
      updateLoadState(LoadState.networkErr);
      return false;
    }

    // }
    return false;
  }

  Future<bool> addCustomer({
    required BuildContext context,
    required String name,
    required String mob,
    required String cityId,
    required String countryId,
    required String address,
  }) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.addCustomer(
            name: name,
            mob: mob,
            cityId: cityId,
            countryId: countryId,
            address: address);
        updateLoadState(LoadState.loaded);
        print(_resp);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["msg"] != null) {
          Helpers.showToast(AppData.appLocale=="ar"?_resp["msg_ar"]??"":_resp["msg"]??"");
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            Future.microtask(() => context.read<CheckOutProvider>()
                .updateCustomer(Customer.fromJson(_resp["customer"])));
            isUpdated = true;
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

  Future<bool> updateCustomer({
    required BuildContext context,
    required String name,
    required String mob,
    required String cityId,
    required String address,
    required String countryId,
    required String customerId,
  }) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.updateCustomer(
            name: name,
            mob: mob,
            cityId: cityId,
            address: address,
            countryId: countryId,
            customerId: customerId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["msg"] != null) {
          Helpers.showToast(AppData.appLocale=="ar"?_resp["msg_ar"]??"":_resp["msg"]??"");
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            isUpdated = true;
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

  void clearData() {
    customerList = [];
    notifyListeners();
  }

  void clearReports() {
    data = [];
    notifyListeners();
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  Future<void> getReports({required BuildContext context}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getReports();
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            reportModel = ReportModelClass.fromJson(_resp);

            reportData = reportModel?.data;
            data = [];
            if (reportData != null) {
              daysWorked = reportData?.daysWorked;
              totalCustomers = reportData?.totalCustomers;
              totalOrders = reportData?.totalOrders;
              activeOrders = reportData?.activeOrders;
              completedOrders = reportData?.completedOrders;
              earnings = reportData?.earnings;
              data.add(daysWorked!);
              data.add(totalCustomers!);
              data.add(totalOrders!);
              data.add(activeOrders!);
              data.add(completedOrders!);
              data.add(earnings!);
            }
          }
        } else {
          // Fluttertoast.showToast(msg: _resp["msg"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> getCountryList({required BuildContext context}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCountryList();
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            countryModelClass = CountryModelClass.fromJson(_resp);
            countryList = countryModelClass?.data ?? [];
            print(countryList.length);
            notifyListeners();
          }
        } else {
          // Fluttertoast.showToast(msg: _resp["msg"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> getCityListForEachCountry(
      {required BuildContext context, required String? countryId}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCitiesForEachCountry(countryId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            cityModel = Cities.fromJson(_resp);
            cityList = cityModel?.data ?? [];
            notifyListeners();
          }
        } else {
          cityModel = null;
          cityList = [];
          updateCityForEditCustomer(null);
          notifyListeners();
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> getCustomerDetails(
      {required BuildContext context, required String? customerId}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCustomerDetails(customerId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            customerModelClass = CustomerModelClass.fromJson(_resp);
            if (customerModelClass?.data != null) {
              customerModelForEditCustomer = customerModelClass?.data;
              selectedCityForEditCustomer = City(
                  id: customerModelForEditCustomer?.customerCityid ?? "",
                  nameAr:
                      customerModelForEditCustomer?.customerCitynameAr ?? "",
                  nameEn:
                      customerModelForEditCustomer?.customerCitynameEn ?? "");

              for (int i=0;i<countryList.length;i++) {
                if (customerModelForEditCustomer?.customerCountryCode==countryList[i].countryCode) {
                  countrySelected=countryList[i];
                  notifyListeners();
                }
              }
              notifyListeners();
            }
          }
        } else {
          Helpers.showToast(AppData.appLocale=="ar"?_resp["msg_ar"]??"":_resp["msg"]??"");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  void updateCountryForCustomer(Country? country) {
    countrySelected = country;
    notifyListeners();
  }

  void clearCustomerForEdit() {
    customerModelForEditCustomer = CustomerData(
        customerId: "",
        customerAddress: "",
        customerCityid: "",
        customerCitynameAr: ",c"
            "",
        customerCitynameEn: "",
        customerCountryId: "",
        customerCountrynameAr: "",
        customerCountrynameEn: "",
        customerMobile: "",
        customerName: "",
        salesmanId: "");
    notifyListeners();
  }

  void updateCityForEditCustomer(City? city) {
    if (city != null) {
      selectedCityForEditCustomer = city;
      notifyListeners();
    } else {
      selectedCityForEditCustomer = null;
      notifyListeners();
    }
  }
}
