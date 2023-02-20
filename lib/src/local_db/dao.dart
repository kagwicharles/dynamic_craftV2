import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:floor/floor.dart';

@dao
abstract class ActionControlDao {
  @Query(
      'SELECT * FROM ActionItem WHERE moduleId = :moduleId AND controlId = :controlId')
  Future<ActionItem?> getActionControlByModuleIdAndControlId(
      String moduleId, String controlId);

  @insert
  Future<void> insertActionControl(ActionItem actionItem);

  @Query('DELETE FROM ActionItem')
  Future<void> clearTable();
}

@dao
abstract class FormItemDao {
  @Query('SELECT * FROM FormItem WHERE moduleId = :id')
  Future<List<FormItem>> getFormsByModuleId(String id);

  @Query(
      'SELECT * FROM FormItem WHERE moduleId = :id AND formSequence = :formSequence')
  Future<List<FormItem>> getFormsByModuleIdAndFormSequence(
      String id, int formSequence);

  @Query(
      'SELECT * FROM FormItem WHERE moduleId = :id AND linkedToControl = :controlID')
  Future<List<FormItem>> getFormsByModuleIdAndControlID(
      String id, String controlID);

  @insert
  Future<void> insertFormItem(FormItem formItem);

  @Query('DELETE FROM FormItem')
  Future<void> clearTable();
}

@dao
abstract class ImageDataDao {
  @Query('SELECT * FROM ImageData WHERE imageCategory = :imageType')
  Future<List<ImageData>> getAllImages(String imageType);

  @insert
  Future<void> insertImage(ImageData imageData);

  @Query('DELETE FROM ImageData')
  Future<void> clearTable();
}

@dao
abstract class ModuleItemDao {
  @Query('SELECT * FROM ModuleItem WHERE parentModule = :parentModule')
  Future<List<ModuleItem>> getModulesById(String parentModule);

  @Query('SELECT * FROM ModuleItem WHERE moduleId = :moduleId')
  Future<ModuleItem?> getModuleById(String moduleId);

  @Query('SELECT * FROM ModuleItem WHERE isMainMenu IS TRUE')
  Future<List<ModuleItem>?> getTabModules();

  @Query(
      "SELECT * FROM ModuleItem WHERE moduleName LIKE :moduleName AND parentModule != 'ALL'")
  Future<List<ModuleItem>> searchModuleItem(String moduleName);

  @insert
  Future<void> insertModuleItem(ModuleItem moduleItem);

  @Query('DELETE FROM ModuleItem')
  Future<void> clearTable();
}

@dao
abstract class UserCodeDao {
  @Query('SELECT * FROM UserCode WHERE id = :id')
  Future<List<UserCode>> getUserCodesById(String id);

  @insert
  Future<void> insertUserCode(UserCode userCode);

  @Query('DELETE FROM UserCode')
  Future<void> clearTable();
}

@dao
abstract class OnlineAccountProductDao {
  @Query('SELECT * FROM OnlineAccountProduct')
  Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts();

  @insert
  Future<void> insertOnlineAccountProduct(
      OnlineAccountProduct onlineAccountProduct);

  @Query('DELETE FROM OnlineAccountProduct')
  Future<void> clearTable();
}

@dao
abstract class BankBranchDao {
  @Query('SELECT * FROM BankBranch')
  Future<List<BankBranch>> getAllBankBranches();

  @insert
  Future<void> insertBankBranch(BankBranch bankBranch);

  @Query('DELETE FROM BankBranch')
  Future<void> clearTable();
}

@dao
abstract class BankAccountDao {
  @Query('SELECT * FROM BankAccount')
  Future<List<BankAccount>> getAllBankAccounts();

  @insert
  Future<void> insertBankAccount(BankAccount bankAccount);

  @Query('DELETE FROM BankAccount')
  Future<void> clearTable();
}

@dao
abstract class FrequentAccessedModuleDao {
  @Query('SELECT * FROM FrequentAccessedModule')
  Future<List<FrequentAccessedModule>> getAllFrequentModules();

  @insert
  Future<void> insertFrequentModule(
      FrequentAccessedModule frequentAccessedModule);

  @Query('DELETE FROM FrequentAccessedModule')
  Future<void> clearTable();
}

@dao
abstract class BeneficiaryDao {
  @Query('SELECT * FROM Beneficiary')
  Future<List<Beneficiary>> getAllBeneficiaries();

  @Query('SELECT * FROM Beneficiary WHERE merchantID =:merchantID')
  Future<List<Beneficiary>> getBeneficiariesByMerchantID(String merchantID);

  @insert
  Future<void> insertBeneficiary(Beneficiary beneficiary);

  @Query('DELETE FROM Beneficiary WHERE rowId =:no')
  Future<void> deleteBeneficiary(int no);

  @Query('DELETE FROM Beneficiary')
  Future<void> clearTable();
}

@dao
abstract class ModuleToHideDao {
  @Query('SELECT * FROM ModuleToHide')
  Future<List<ModuleToHide>> getAllModulesToHide();

  @insert
  Future<void> insertModuleToHide(ModuleToHide moduleToHide);

  @Query('DELETE FROM ModuleToHide')
  Future<void> clearTable();
}

@dao
abstract class ModuleToDisableDao {
  @Query('SELECT * FROM ModuleToDisable')
  Future<List<ModuleToDisable>> getAllModulesToDisable();

  @insert
  Future<void> insertModuleToDisable(ModuleToDisable moduleToDisable);

  @Query('DELETE FROM ModuleToDisable')
  Future<void> clearTable();
}

@dao
abstract class BranchLocationDao {
  @Query('SELECT * FROM BranchLocation')
  Future<List<BranchLocation>> getAllBranchLocations();

  @insert
  Future<void> insertBranchLocation(BranchLocation branchLocation);

  @Query('DELETE FROM BranchLocation')
  Future<void> clearTable();
}

@dao
abstract class AtmLocationDao {
  @Query('SELECT * FROM AtmLocation')
  Future<List<AtmLocation>> getAllAtmLocations();

  @insert
  Future<void> insertAtmLocation(AtmLocation atmLocation);

  @Query('DELETE FROM AtmLocation')
  Future<void> clearTable();
}

@dao
abstract class PendingTrxDisplayDao {
  @Query('SELECT * FROM PendingTrxDisplay')
  Future<List<PendingTrxDisplay>> getAllPendingTransactions();

  @insert
  Future<void> insertPendingTransaction(PendingTrxDisplay pendingTrxDisplay);

  @Query('DELETE FROM PendingTrxDisplay')
  Future<void> clearTable();
}
