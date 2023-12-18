import 'package:lovica_sales_app/services/service_config.dart';

import '../common/constants.dart';

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoadState loaderState = LoadState.initial;
  int apiCallCount = 0;

  void pageInit() {}

  void pageDispose() {}

  void updateApiCallCount() {}

  void updateLoadState(LoadState state);
}
