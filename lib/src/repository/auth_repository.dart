part of craft_dynamic;

final _userAccountRepository = UserAccountRepository();
final _sharedPref = CommonSharedPref();

class AuthRepository {
  final _services = APIService();

  // Call this method to login
  Future<ActivationResponse> login(String pin) async {
    ActivationResponse activationResponse =
        await _services.login(CryptLib.encryptField(pin));
    if (activationResponse.status == StatusCode.success.statusCode) {
      await ClearDB.clearAllUserData();
      await _userAccountRepository.addUserAccountData(activationResponse);
    }
    return activationResponse;
  }

  // Call this method to activate app
  Future<ActivationResponse> activate(
      {required mobileNumber, required pin}) async {
    ActivationResponse activationResponse = await _services.activateMobile(
      mobileNumber: mobileNumber,
      encryptedPin: CryptLib.encryptField(pin),
    );
    return activationResponse;
  }

  // Call this method to verify otp
  Future<ActivationResponse> verifyOTP(
      {required mobileNumber, required otp}) async {
    ActivationResponse activationResponse =
        await _services.verifyOTP(mobileNumber: mobileNumber, key: otp);
    if (activationResponse.customerID != null &&
        activationResponse.customerID != "") {
      _sharedPref.addActivationData(
          mobileNumber, activationResponse.customerID!);
    }
    return activationResponse;
  }
}
