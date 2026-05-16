class ClassificationResult {
  const ClassificationResult({
    required this.id,
    required this.candidateIds,
    required this.isDuplicate,
    required this.isTransferLike,
    required this.isExpense,
    required this.requiresReview,
    required this.reasonCodes,
    required this.confidence,
    required this.createdAt,
    required this.userFeedback,
  });

  final String id;
  final List<String> candidateIds;
  final bool isDuplicate;
  final bool isTransferLike;
  final bool isExpense;
  final bool requiresReview;
  final List<String> reasonCodes;
  final double confidence;
  final DateTime createdAt;
  final bool? userFeedback;
}
