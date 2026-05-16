import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';

abstract interface class ExpenseRepository {
  Stream<List<RawNotification>> watchRawNotifications();

  Stream<List<ExpenseTransaction>> watchExpenses();

  Future<List<ExpenseTransaction>> getExpenses();

  Future<ExpenseTransaction?> getExpenseById(String id);

  Future<void> saveRawNotification(RawNotification rawNotification);

  Future<void> saveExpense(ExpenseTransaction expense);
}
