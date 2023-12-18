import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/models/city_model.dart';
import 'package:lovica_sales_app/providers/notification_provider.dart';
import 'package:lovica_sales_app/services/provider_helper_class.dart';
import 'package:provider/provider.dart';

import '../common/helpers.dart';
import '../common/nav_routes.dart';
import '../models/country_model_class.dart';
import '../models/profile_model.dart';
import '../services/app_data.dart';
import '../services/service_config.dart';
import '../common/constants.dart';
import '../services/shared_preference_helper.dart';
import '../views/auth_screens/personal_details_screen.dart';

class AuthenticationProvider extends ChangeNotifier with ProviderHelperClass {
  City? selectedCity;
  Cities? cityModel;
  List<City> cityList = [];
  String? selectedGender = "male";
  UserData? userData;
  bool isMobileVerified = false;
  bool isPwdOtpVerified = false;
  int? cartCount = 0;
  int? notifCount = 0;
  Country? countrySelected;
  CountryModelClass? countryModelClass;
  List<Country> countryList = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;


  Future<void> login(
      {required BuildContext context,
      required String uName,
      required String password,
        required String locale
      }) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.login(uName: uName, password: password,locale: locale);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp['status_code'] == 200) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["token"] != null) {
            await SharedPreferencesHelper.saveLoginToken(_resp["token"]);

            log(_resp["token"]);
            log(_resp["details"]);
            if (_resp["details"].toLowerCase().replaceAll(' ', '') ==
                ConstantsDefault.required.toLowerCase().replaceAll(' ', '')) {
              await SharedPreferencesHelper.saveUserDataRequiredStatus(true);
              Future.microtask(() async {
                await navToPersonalDetails(context);
              });
            } else {
              await SharedPreferencesHelper.saveUserDataRequiredStatus(false);
              Future.microtask(() => context.read<AuthenticationProvider>()
                ..sendfcm(context: context, fcm: AppData.fcm)
                ..getProfile(context: context)
                ..getCartCount(context: context));
              Future.microtask(() => context
                  .read<NotificationProvider>()
                  .getNotificationList(context: context, start: 0, limit: 0));
              Future.microtask(() async {
                await navToMainPage(context);
              });
            }
          } else {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");
          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> changePwd(
      {required BuildContext context,
        required String passwordConfirm,
        required String password}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.changePwd(
            passwordConfirm: passwordConfirm, password: password);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["msg"] != null) {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["token"] != null) {
            await SharedPreferencesHelper.saveLoginToken(_resp["token"]);

            log(_resp["token"]);
            log(_resp["details"]);
            if (_resp["details"].toLowerCase().replaceAll(' ', '') ==
                ConstantsDefault.required.toLowerCase().replaceAll(' ', '')) {
              await SharedPreferencesHelper.saveUserDataRequiredStatus(true);
              Future.microtask(() async {
                await navToPersonalDetails(context);
              });
            } else {
              await SharedPreferencesHelper.saveUserDataRequiredStatus(false);
              Future.microtask(() async {
                await navToMainPage(context);
              });
            }
          } else {
            // Fluttertoast.showToast(msg: _resp["msg"]);
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }


  Future<bool> fgtPwdChange(
      {required BuildContext context,
        required String password,
        required String uName}) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
        await serviceConfig.fgtPwdChange(password: password, uName: uName);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp != null) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");
          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isUpdated;
  }




  // Future<bool> fgtPwdChange(
  //     {required BuildContext context,
  //     required String password,
  //     required String uName}) async {
  //   bool isUpdated = false;
  //   updateLoadState(LoadState.loading);
  //   final network = await Helpers.isInternetAvailable();
  //   if (network) {
  //     try {
  //       dynamic _resp =
  //           await serviceConfig.fgtPwdChange(password: password, uName: uName);
  //       updateLoadState(LoadState.loaded);
  //
  //       if (_resp.isEmpty) {
  //         updateLoadState(LoadState.loaded);
  //       }
  //
  //       if (_resp != null &&
  //           _resp["msg"] != null &&
  //           _resp["status_code"] == 200) {
  //         isUpdated = true;
  //         // Fluttertoast.showToast(msg: _resp["msg"]);
  //         updateLoadState(LoadState.loaded);
  //         FocusManager.instance.primaryFocus?.unfocus();
  //         // log(_resp["token"]);
  //         Future.microtask(() async {
  //           await   Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const PersonalDetailsScreen(),
  //
  //             ),
  //           );
  //         });
  //         // log(_resp["details"]);
  //         // await SharedPreferencesHelper.saveUserDataRequiredStatus(true);
  //         // Future.microtask(() async {
  //         //   await navToPersonalDetails(context);
  //         // });
  //         // if (_resp["status_code"] ==
  //         //     200) {
  //         //   // await SharedPreferencesHelper.saveUserDataRequiredStatus(true);
  //         //   Future.microtask(() async {
  //         //     await navToPersonalDetails(context);
  //         //   });
  //         // } else {
  //         //   // await SharedPreferencesHelper.saveUserDataRequiredStatus(false);
  //         //   Future.microtask(() async {
  //         //     await navToMainPage(context);
  //         //   });
  //         // }
  //         // if (_resp["token"] != null) {
  //         //   await SharedPreferencesHelper.saveLoginToken(_resp["token"]);
  //         //
  //         //
  //         // } else {
  //         //   // Fluttertoast.showToast(msg: _resp["msg"]);
  //         // }
  //       }
  //     } catch (_) {
  //       updateLoadState(LoadState.error);
  //     }
  //   } else {
  //     updateLoadState(LoadState.networkErr);
  //   }
  //   return isUpdated;
  // }

  Future<void> navToMainPage(BuildContext context) async {
    NavRoutes.navToDashboard(context);
  }
  Future<void> navToLoginPage(BuildContext context) async {
    NavRoutes.navToLogIn(context);
  }

  Future<void> navToPersonalDetails(BuildContext context) async {
    NavRoutes.navToPersonalDetails(context);
  }

  Future<void> getCities(
      {required BuildContext context, String? country = "ksa"}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCities(country);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            cityModel = Cities.fromJson(_resp);
            cityList = cityModel?.data ?? [];

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
    // }
  }

  Future<bool> updateUserData({
    required BuildContext context,
    required String name,
    required String gender,
    required String mob,
    required String idNum,
    required String iban,
    required String cityId,
    required String countryId,
    required String address,
    required String emNum,
    required String type,

  }) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.updateUserData(
            name: name,
            gender: gender,
            mob: mob,
            idNum: idNum,
            bankIban: iban,
            cityId: cityId,
            address: address,
            countryId: countryId,
            emNum: emNum,
          type: type,
        );
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["msg"] != null) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            await SharedPreferencesHelper.saveUserDataRequiredStatus(false);
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

  Future<void> getProfile({required BuildContext context}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getProfile();
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            ProfileModel model = ProfileModel.fromJson(_resp);
            userData = model.userData;
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
///Send otp for mobile number updating
  Future<void> sendOtp(
      {required BuildContext context, required String? mob,String? countryCode}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.sendOtp(mobile: mob ?? "",countryCode: countryCode);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp != null) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");
          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> sendOtpFgtPwd({
    required BuildContext context,
    required String? mob,
    required String? uName,
    required int? from,
  }) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.sendOtpFgtPwd(mobile: mob ?? "", uName: uName);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp != null) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");

            // if (from == 0) {
            //   Future.microtask(() => NavRoutes.navToFgtPwdOtp(context, uName));
            // } else {
            //   Future.microtask(
            //       () => NavRoutes.navToChangePwdOtp(context, uName));
            // }
          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> verifyMobile(
      {required BuildContext context,
      required String? mob,
      required String? otp}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.verifyMobile(mobile: mob ?? "", otp: otp ?? "");
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp != null) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");
            Future.microtask(() => Navigator.pop(context, true));
          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> verifyOtp(
      {required BuildContext context,
      required String? uName,
      required int? from,
      required String? otp}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.verifyOtp(uName: uName ?? "", otp: otp ?? "");
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp != null) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");
            if (from == 1 && _resp["status_code"] == 200) {
              verifyPwdOtp();
            }

          }
        } else {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> getCartCount({required BuildContext context}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCartCount();
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            cartCount = _resp["data"]["cart_count"];
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

  void updateGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  void updateCartCount(int val) {
    cartCount = val;
    notifyListeners();
  }

  void updateCity(City? city) {
    if (city != null) {
      selectedCity = city;
      notifyListeners();
    } else {
      selectedCity = null;
      notifyListeners();
    }
  }

  void updateCountry(Country? country) {
    if (country != null) {
      countrySelected = country;
      notifyListeners();
    } else {
      countrySelected = null;
      notifyListeners();
    }
  }

  void verifyPwdOtp() {
    isPwdOtpVerified = true;
    notifyListeners();
  }

  void updateCityWithId(String cityId) {
    for (int i = 0; i < cityList.length; i++) {
      if (cityList[i].id == cityId) {
        selectedCity = cityList[i];
      }
    }
    notifyListeners();
  }

  void updateCountryWithCountryId(BuildContext context,String countryId) {
    for (int i = 0; i < countryList.length; i++) {
      if (countryList[i].countryListId == countryId) {
        countrySelected = countryList[i];
        getCityListForEachCountry(context: context, countryId: countryId);

      }
    }
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    AppData.accessToken = '';
    AppData.isUserDataRequired = false;
    await SharedPreferencesHelper.clearUserData();
    notifyListeners();
    Future.microtask(() => NavRoutes.navToLoginRemoveUntil(context));
  }

  void updateMobileVerified() {
    isMobileVerified = !isMobileVerified;
    notifyListeners();
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  Future<bool> sendfcm(
      {required BuildContext context, required String fcm}) async {
    if(Platform.isAndroid) {
       androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo!.id}');
    } else if(Platform.isIOS) {
       iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo!.name}');
    }


    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.sendFcmToken(
            fcm: fcm,
            device: Platform.isAndroid ? "android" : "iphone",
          deviceId: Platform.isAndroid ? "android:${androidInfo!.model}" :
          "iphone:${iosInfo!.identifierForVendor}"
        );
        updateLoadState(LoadState.loaded);
        print("FCM RESPONSE $_resp");

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        updateLoadState(LoadState.loaded);
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isUpdated;
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

            if (userData!=null) {
              updateCountryWithCountryId(context,userData?.countryId??"");
            }
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
            if (userData != null) {
              updateCityWithId(userData?.cityId ?? "");
            }
            notifyListeners();
          }
        } else {
          cityModel = null;
          cityList = [];
          updateCity(null);
          notifyListeners();
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

}
