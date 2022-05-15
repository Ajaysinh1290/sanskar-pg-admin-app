import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/models/payment/payment.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/fees/payment_successful.dart';
import 'package:sanskar_pg_admin_app/services/notification_service.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/widgets.dart';

class PaymentController extends GetxController {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxBool isLoading = RxBool(false);

  bool validate() {
    if (amountController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Amount can\'t be empty');
      return false;
    } else {
      try {
        num.parse(amountController.text);
        return true;
      } catch (e) {
        showErrorDialog('Error', 'Only numbers are allowed in amount field');
        return false;
      }
    }
  }

  createTransaction(UserModel userModel) async {
    if (!validate()) return;
    isLoading.value = true;
    Payment payment = Payment(
        amount: num.parse(amountController.text.trim()),
        description: descriptionController.text.trim(),
        transactionDate: DateTime.now(),
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userModel.userId);
    userModel.transactions ??= [];
    userModel.transactions?.add(payment.transactionId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.userId)
        .set(userModel.toJson());
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(userModel.hostelId)
        .collection('transactions')
        .doc(payment.transactionId)
        .set(payment.toJson());
    await NotificationService.sendNotification(
        'New Transaction',
        payment.amount.toString() +
            Constants.currencySymbol +
            ' Fees Submitted',
        {
          'screen': 'transaction_details',
          'transaction_id': payment.transactionId
        },
        payment.userId);
    Get.off(PaymentSuccessful(payment: payment));
    isLoading.value = true;
  }
}
