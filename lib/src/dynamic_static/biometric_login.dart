import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/util/common_lib_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

final _sharedPref = CommonSharedPref();

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  final String enableMessage = "Enter your pin to enable fingerprint login";
  final String disableMessage = "Enter your pin to disable fingerprint login";
  bool isBioEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBioIsEnabled();
  }

  _checkBioIsEnabled() async {
    bool? bioEnabled = await _sharedPref.getBio();
    isBiometricEnabled.value = bioEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text("Enroll fingerprint"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "packages/craft_dynamic/assets/images/fingerprint.png",
                width: 77,
                height: 77,
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Text(
                "Login with Fingerprint",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Text(
                "Use fingerprint for faster and easy access to your account",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    enableDisableBioDialog(context: context);
                  },
                  child: Obx(() => Text(isBiometricEnabled.value
                      ? "Disable Fingerprint Login"
                      : "Enable Fingerprint Login")))
            ],
          ),
        ));
  }

  enableDisableBioDialog({context}) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => const ModalBottomSheet());
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final LocalAuthentication auth = LocalAuthentication();
  final _services = APIService();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isBioEnabled = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Enter PIN"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pin';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                _isLoading
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading_list.json"))
                    : Obx(() => WidgetFactory.buildButton(
                        context,
                        enableBiometric,
                        isBiometricEnabled.value
                            ? "Disable Biometric"
                            : "Enable Biometric"))
              ],
            ),
          ),
        ));
  }

  enableBiometric() async {
    if (await canBiometricAuthenticate()) {
      var enrolledFingerprints = await getEnrolledBiometrics();
      if (enrolledFingerprints.length > 0) {
        _handleBiometrics(CryptLib.encryptField(_pinController.text));
      } else {
        CommonUtils.buildErrorSnackBar(
            context: context,
            message: "No fingerprints enrolled on this device");
      }
    }
  }

  _handleBiometrics(String encryptedPin) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () async {
        await _services.login(encryptedPin).then((value) async => {
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (value.status == "000") {
                  _sharedPref.setBioPin(encryptedPin);
                  isBiometricEnabled.value
                      ? _sharedPref.setBio(false)
                      : _sharedPref.setBio(true);
                  isBiometricEnabled.value = !isBiometricEnabled.value;
                  Navigator.pop(context);
                  _pinController.clear();
                } else {
                  CommonUtils.buildErrorSnackBar(
                      context: context, message: value.message);
                }
              }),
            });
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  getEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    return availableBiometrics;
  }

  canBiometricAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }
}
