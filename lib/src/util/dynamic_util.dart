import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/builder/factory_builder.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/list_screen.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/request_status.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/transaction_receipt.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:provider/provider.dart';

class DynamicUtil {
  static showReceipt({required context, required postDynamic, moduleName}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      CommonUtils.navigateToRoute(
          context: context,
          widget: TransactionReceipt(
            postDynamic: postDynamic,
            moduleName: moduleName,
          ));
    });
  }

  static navigateToStatusRoute(
      {required context, required status, required message}) {
    if (status != null && message != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        CommonUtils.navigateToRoute(
            context: context,
            widget: RequestStatusScreen(
              statusCode: status,
              message: message,
            ));
      });
    }
  }

  static processDynamicResponse(
      DynamicData? dynamicData, BuildContext context, String? controlID,
      {moduleItem}) {
    Provider.of<PluginState>(context, listen: false).setRequestState(false);

    var builder = DynamicFactory.getPostDynamicObject(
        dynamicData); //Get a builder based on action type
    var postDynamic = PostDynamic(builder, context, controlID ?? "");
    debugPrint("PostDynamic formfields::::${postDynamic.formFields}");

    switch (postDynamic.status) {
      case "000":
        {
          if (postDynamic.opensDynamicRoute) {
            postDynamic.formID != null &&
                    postDynamic.formID == "ALERTCONFIRMATIONFORM"
                ? AlertUtil.showModalBottomDialog(
                    postDynamic.context, postDynamic.jsonDisplay)
                : CommonUtils.navigateToRoute(
                    context: postDynamic.context,
                    widget: DynamicWidget(
                      nextFormSequence: postDynamic.nextFormSequence,
                      isWizard: true,
                      jsonDisplay: postDynamic.jsonDisplay,
                      formFields: postDynamic.formFields,
                      moduleItem: postDynamic.moduleItem,
                      formID: postDynamic.formID,
                    ));
            break;
          }

          if (!postDynamic.isList) {
            var receiptDetails = postDynamic.receiptDetails;
            if (receiptDetails != null && receiptDetails.isNotEmpty) {
              showReceipt(
                  context: postDynamic.context,
                  postDynamic: postDynamic,
                  moduleName: moduleItem.moduleName);
              break;
            } else {
              navigateToStatusRoute(
                context: postDynamic.context,
                status: postDynamic.status,
                message: postDynamic.notifyText == null ||
                        postDynamic.notifyText == ""
                    ? postDynamic.message
                    : postDynamic.notifyText,
              );
              break;
            }
          } else if (postDynamic.tappedButton) {
            CommonUtils.navigateToRoute(
                context: postDynamic.context,
                widget: ListDataScreen(
                    title: postDynamic.moduleItem!.moduleName,
                    widget: ListWidget(
                      dynamicList: postDynamic.list,
                      scrollable: true,
                      controlID: postDynamic.controlID,
                    )));
            break;
          }
        }
        break;
      case "091":
        {
          AlertUtil.showAlertDialog(context, postDynamic.message ?? "Error");
        }
        break;
      case "099":
        {
          navigateToStatusRoute(
            context: postDynamic.context,
            status: postDynamic.status,
            message: postDynamic.message,
          );
        }
        break;
      default:
        {
          CommonUtils.buildErrorSnackBar(
              context: postDynamic.context,
              message: "Error processing request!");
        }
    }
  }
}
