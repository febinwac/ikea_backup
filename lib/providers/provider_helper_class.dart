import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../common/constants.dart';
import '../services/service_config.dart';

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoaderState loaderState = LoaderState.initial;

  void pageInit() {}

  void pageDispose() {}

  void updateLoadState(LoaderState state);
}

abstract class TabHelperClass {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  void updateTabIndex(int index);
}
