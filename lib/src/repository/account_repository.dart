part of craft_dynamic;

class AccountRepository {
  final _services = APIService();

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
