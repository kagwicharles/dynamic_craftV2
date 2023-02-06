part of craft_dynamic;

class ProfileRepository {
  final _bankRepository = BankAccountRepository();
  final _sharedPref = CommonSharedPref();
  final _services = APIService();

  Future<List<BankAccount>> getUserBankAccounts() =>
      _bankRepository.getAllBankAccounts();

  Future<String> getUserInfo(UserAccountData key) =>
      _sharedPref.getUserAccountInfo(key);

  Future<DynamicResponse?> checkAccountBalance(String bankAccountID) {
    return _services.checkAccountBalance(
        bankAccountID: bankAccountID, merchantID: "BALANCE", moduleID: "HOME");
  }

  Future<DynamicResponse?> checkMiniStatement(String bankAccountID) {
    return _services.checkMiniStatement(
        bankAccountID: bankAccountID,
        merchantID: "STATEMENT",
        moduleID: "STATEMENT");
  }
}
