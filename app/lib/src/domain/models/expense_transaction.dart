enum ConfirmationStatus { confirmed, needsReview, rejected }

enum ConfirmedBy { rule, user, import }

enum SyncStatus { localOnly, pendingUpload, synced, conflict }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.amount,
    required this.merchantName,
    required this.categoryId,
    required this.spentAt,
    required this.confirmationStatus,
    required this.confirmedBy,
    required this.candidateIds,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });

  final String id;
  final int amount;
  final String merchantName;
  final String? categoryId;
  final DateTime spentAt;
  final ConfirmationStatus confirmationStatus;
  final ConfirmedBy confirmedBy;
  final List<String> candidateIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;

  ExpenseTransaction copyWith({
    int? amount,
    String? merchantName,
    String? categoryId,
    DateTime? spentAt,
    ConfirmationStatus? confirmationStatus,
    ConfirmedBy? confirmedBy,
    List<String>? candidateIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return ExpenseTransaction(
      id: id,
      amount: amount ?? this.amount,
      merchantName: merchantName ?? this.merchantName,
      categoryId: categoryId ?? this.categoryId,
      spentAt: spentAt ?? this.spentAt,
      confirmationStatus: confirmationStatus ?? this.confirmationStatus,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      candidateIds: candidateIds ?? this.candidateIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
