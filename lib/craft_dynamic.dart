// ignore_for_file: depend_on_referenced_packages

library craft_dynamic;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:craft_dynamic/src/builder/request_builder.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/src/util/extensions_util.dart';
import 'package:craft_dynamic/src/util/location_util.dart';
import 'package:craft_dynamic/src/util/permissions_util.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Key, Table, Column;
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_session_timeout/local_session_timeout.dart'
    hide SessionTimeoutState, SessionTimeoutManager;

// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:logger/logger.dart';
import 'package:floor/floor.dart';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import "package:hex/hex.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:yaml/yaml.dart';

import 'src/app_data/constants.dart';
import 'src/session_manager/session_manager.dart';
import 'src/state/plugin_state.dart';
import 'src/util/common_lib_util.dart';
import 'src/util/logger_util.dart';

part 'src/app_data/model.dart';

part 'src/app_data/entity.dart';

part 'src/app_data/enums.dart';

part 'src/app_data/shared_pref.dart';

part 'src/network/api_service.dart';

part 'src/util/device_info_util.dart';

part 'src/util/crypt_util.dart';

part 'src/util/biometric_util.dart';

part 'src/ui/dynamic_craft_wrapper.dart';

part 'src/repository/auth_repository.dart';

part 'src/repository/home_repository.dart';

part 'src/repository/init_repository.dart';

part 'src/repository/account_repository.dart';

part 'src/session_manager/session_helper.dart';

part 'src/ui/dynamic_static/blurr_load_screen.dart';

part 'src/ui/dynamic_static/search_module_delegate.dart';
