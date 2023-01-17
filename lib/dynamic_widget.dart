library dynamic_widget;

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/src/dynamic_static/view_standing_order.dart';
import 'package:craft_dynamic/src/native_binder/native_bind.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:craft_dynamic/src/util/enum_formatter_util.dart';
import 'package:provider/provider.dart';

import 'src/dynamic_static/biometric_login.dart';
import 'src/dynamic_static/transactions_list.dart';
import 'src/dynamic_static/view_beneficiary.dart';
import 'src/ui/forms/forms_list.dart';
import 'src/ui/modules/modules_list.dart';
import 'src/ui/platform_components/platform_button.dart';
import 'src/ui/platform_components/platform_textfield.dart';
import 'src/util/common_lib_util.dart';

part 'src/adapter/dropdown_adapter.dart';
part 'src/ui/dynamic_widget_factory.dart';
part 'src/ui/dynamic_screen.dart';
part 'src/ui/modules/module_item.dart';
