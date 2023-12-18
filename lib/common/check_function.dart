import '../models/error_model.dart';
import '../services/app_data.dart';
import '../services/service_config.dart';
import '../services/shared_preference_helper.dart';
import 'helpers.dart';

class Check {
  static checkException(dynamic _resp,
      {Function? noCustomer,
      Function? onError,
      Function? onCartIdExpired,
      Function(bool val)? onAuthError,
      bool enableToast = true}) async {
    ErrorModel errorModel = ErrorModel.fromJson(_resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          if (enableToast) Helpers.showToast('${errorModel.message}');
          break;
        case 'graphql-authorization':
          if (AppData.accessToken.isNotEmpty) {
            // await validateRefreshToken();
            if (onAuthError != null) onAuthError(true);
          }
          break;
        case 'graphql-no-such-entity':
          // if (AppData.accessToken.isEmpty) await getEmptyCart();
          if (onCartIdExpired != null) onCartIdExpired(true);
          break;

        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            if (enableToast) Helpers.showToast('${errorModel.message}');
            if (onError != null) onError(true);
          }
      }
    } else {
      if (errorModel.error != null &&
          errorModel.error == 'error' &&
          errorModel.message != null) {
        if (enableToast) Helpers.showToast('${errorModel.message}');
        onError!(true);
      }
    }
  }

  static checkExceptionWithOutToast(dynamic _resp,
      {Function? noCustomer,
      Function? onError,
      Function(bool val)? onAuthError}) async {
    ErrorModel errorModel = ErrorModel.fromJson(_resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          break;
        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            onError!(true);
          }
      }
    }
  }

}
