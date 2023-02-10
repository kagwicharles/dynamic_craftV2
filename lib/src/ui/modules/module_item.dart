// ignore_for_file: must_be_immutable

part of dynamic_widget;

final _moduleItemUtil = ModuleItemUtil();

class ModuleItemWidget extends StatelessWidget {
  bool isMain = false;
  bool isSearch;
  ModuleItem moduleItem;

  ModuleItemWidget(
      {Key? key,
      this.isMain = false,
      this.isSearch = false,
      required this.moduleItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double iconSize = 54;

    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          _moduleItemUtil.onItemClick(moduleItem, context);
        },
        child: Provider.of<PluginState>(context, listen: false).menuItem ??
            Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageUrl: moduleItem.moduleUrl ?? "",
                      height: iconSize,
                      width: iconSize,
                      placeholder: (context, url) => Lottie.asset(
                          'packages/craft_dynamic/assets/lottie/loading.json'),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                        child: Text(
                      moduleItem.moduleName.capitalizeWords(),
                      // overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.roboto(fontSize: 14),
                    )),
                  ]),
            ));
  }
}

class OtherModuleItem extends StatelessWidget {
  ModuleItem moduleItem;

  OtherModuleItem({super.key, required this.moduleItem});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 48;

    return Card(
        elevation: 1,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: InkWell(
              onTap: () {
                _moduleItemUtil.onItemClick(moduleItem, context);
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CachedNetworkImage(
                        imageUrl: moduleItem.moduleUrl ?? "",
                        height: iconSize,
                        width: iconSize,
                        placeholder: (context, url) => Lottie.asset(
                            'packages/craft_dynamic/assets/lottie/loading.json'),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Flexible(
                          child: Text(
                        moduleItem.moduleName,
                        // overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )),
                    ],
                  )),
            )));
  }
}

class ModuleItemUtil {
  void onItemClick(ModuleItem moduleItem, BuildContext context) {
    switch (EnumFormatter.getModuleId(moduleItem.moduleId)) {
      case ModuleId.FINGERPRINT:
        {
          CommonUtils.navigateToRoute(
              context: context, widget: const BiometricLogin());
          break;
        }
      case ModuleId.TRANSACTIONSCENTER:
        {
          getTransactionList(context, moduleItem);
          break;
        }
      case ModuleId.PENDINGTRANSACTIONS:
        {
          break;
        }
      case ModuleId.VIEWBENEFICIARY:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: ViewBeneficiary(moduleItem: moduleItem));
          break;
        }
      case ModuleId.STANDINGORDERVIEWDETAILS:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: ViewStandingOrder(moduleItem: moduleItem));
          break;
        }
      case ModuleId.BOOKCAB:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Ride.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.MERCHANTPAYMENT:
        {
          NativeBinder.invokeMethod(LittleProduct
              .PayMerchants.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.TOPUPWALLET:
        {
          NativeBinder.invokeMethod(LittleProduct
              .LoadWallet.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.FOOD:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.PHARMACY:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.SUPERMARKET:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.GROCERIES:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.GAS:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.DRINKS:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.CAKE:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      default:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: DynamicWidget(
                moduleItem: moduleItem,
              ));
        }
    }
  }

  getTransactionList(context, moduleItem) {
    CommonUtils.navigateToRoute(
        context: context, widget: TransactionList(moduleItem: moduleItem));
  }
}
