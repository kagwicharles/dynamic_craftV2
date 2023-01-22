// ignore_for_file: depend_on_referenced_packages

library database;

import 'dart:async';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'src/local_db/dao.dart';
part 'src/local_db/database.g.dart';
part 'src/local_db/repository.dart';
part 'src/network/network_repository.dart';

@Database(version: 1, entities: [
  ModuleItem,
  FormItem,
  ActionItem,
  UserCode,
  OnlineAccountProduct,
  BankBranch,
  ImageData,
  BankAccount,
  FrequentAccessedModule,
  Beneficiary,
  ModuleToHide,
  ModuleToDisable,
  AtmLocation,
  BranchLocation,
  PendingTrxDisplay
])
abstract class AppDatabase extends FloorDatabase {
  ModuleItemDao get moduleItemDao;

  FormItemDao get formItemDao;

  ActionControlDao get actionControlDao;

  UserCodeDao get userCodeDao;

  OnlineAccountProductDao get onlineAccountProductDao;

  BankBranchDao get bankBranchDao;

  ImageDataDao get imageDataDao;

  BankAccountDao get bankAccountDao;

  FrequentAccessedModuleDao get frequentAccessedModuleDao;

  BeneficiaryDao get beneficiaryDao;

  ModuleToHideDao get moduleToHideDao;

  ModuleToDisableDao get moduleToDisableDao;

  AtmLocationDao get atmLocationDao;

  BranchLocationDao get branchLocationDao;

  PendingTrxDisplayDao get pendingTrxDisplayDao;

  static getDatabaseInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
