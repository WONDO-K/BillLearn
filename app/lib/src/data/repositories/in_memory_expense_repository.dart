import 'dart:async';

import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';

class InMemoryExpenseRepository implements ExpenseRepository {
  final List<RawNotification> _rawNotifications = [];
  final List<ExpenseTransaction> _expenses = [];

  final _rawController = StreamController<List<RawNotification>>.broadcast();
  final _expenseController =
      StreamController<List<ExpenseTransaction>>.broadcast();

  @override
  Stream<List<RawNotification>> watchRawNotifications() async* {
    yield List.unmodifiable(_rawNotifications);
    yield* _rawController.stream;
  }

  @override
  Stream<List<ExpenseTransaction>> watchExpenses() async* {
    yield List.unmodifiable(_expenses);
    yield* _expenseController.stream;
  }

  @override
  Future<void> saveRawNotification(RawNotification rawNotification) async {
    _rawNotifications.add(rawNotification);
    _rawController.add(List.unmodifiable(_rawNotifications));
  }

  @override
  Future<void> saveExpense(ExpenseTransaction expense) async {
    _expenses.add(expense);
    _expenseController.add(List.unmodifiable(_expenses));
  }

  Future<void> dispose() async {
    await _rawController.close();
    await _expenseController.close();
  }
}
