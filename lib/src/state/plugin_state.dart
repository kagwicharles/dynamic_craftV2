import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PluginState extends ChangeNotifier {
  bool _loadingNetworkData = false;
  bool _obscureText = true;
  String _currentTab = "";
  final List<Map<String?, dynamic>> _formInputValues = [];
  Map<String?, dynamic> _encryptedFields = {};

  bool get loadingNetworkData => _loadingNetworkData;

  String get currentTab => _currentTab;

  bool get obscureText => _obscureText;

  List<Map<String?, dynamic>> get formInputValues => _formInputValues;

  Map<String?, dynamic> get encryptedFields => _encryptedFields;

  void setRequestState(bool state, {String? currentTab}) {
    _loadingNetworkData = state;
    _currentTab = currentTab ?? "";
    notifyListeners();
  }

  changeVisibility(bool visibility) {
    _obscureText = visibility;
    notifyListeners();
  }

  changeBiometricStatus(bool biometricStatus) {
    notifyListeners();
  }

  addFormInput(Map<String?, dynamic> formInput) {
    _formInputValues.add(formInput);
    notifyListeners();
  }

  addEncryptedFields(key, value) {
    _encryptedFields[key] = value;
    notifyListeners();
  }

  clearDynamicInput() {
    _formInputValues.clear();
    _encryptedFields.clear();
    notifyListeners();
  }
}

var showLoadingScreen = false.obs;

var isBiometricEnabled = false.obs;

var isCallingService = false.obs;

var currentStepperIndex = 0.obs;

var isStepperForm = false.obs;
