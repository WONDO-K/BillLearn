import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

class ExpenseClassifier {
  // 은행/간편송금 앱에서 계좌 이동을 실제 소비로 저장하지 않기 위한 1차 필터입니다.
  static const _transferKeywords = [
    '이체',
    '입금',
    '출금',
    '송금',
    '자동이체',
    '계좌간',
    '내 계좌',
  ];

  // Toss/KakaoBank 등은 "이체"라는 단어 없이 자연어 송금 문구를 보내는 경우가 있습니다.
  static const _bankTransferPhrases = [
    '보냈어요',
    '받았어요',
    '받는분',
    '보낸분',
    '받는 사람',
    '보낸 사람',
    '님에게',
    '님이',
  ];

  // 선불/지역화폐 충전은 지출의 원천 이동일 뿐, 최종 소비가 아니므로 별도 제외합니다.
  static const _storedValueTopUpKeywords = [
    '동백전 충전',
    '지역화폐 충전',
    '페이머니 충전',
    '머니 충전',
    '포인트 충전',
    '캐시 충전',
    '선불 충전',
    '잔액 충전',
  ];

  ClassificationResult classify({
    required List<TransactionCandidate> candidates,
    required List<String> rawTexts,
  }) {
    final joinedText = rawTexts.join(' ');
    final isStoredValueTopUp = _storedValueTopUpKeywords.any(
      joinedText.contains,
    );
    final hasBankTransferPhrase = _bankTransferPhrases.any(joinedText.contains);
    final isTransferLike =
        isStoredValueTopUp ||
        hasBankTransferPhrase ||
        _transferKeywords.any(joinedText.contains);
    final isDuplicate = _hasDuplicateSignal(candidates);
    final hasStableCandidate = candidates.any(
      (candidate) =>
          candidate.parseStatus == ParseStatus.parsed &&
          candidate.amount > 0 &&
          candidate.merchantName.isNotEmpty,
    );
    final isExpense = hasStableCandidate && !isTransferLike;
    final requiresReview = isTransferLike || !hasStableCandidate;

    return ClassificationResult(
      id: 'classification-${candidates.map((candidate) => candidate.id).join('-')}',
      candidateIds: candidates.map((candidate) => candidate.id).toList(),
      isDuplicate: isDuplicate,
      isTransferLike: isTransferLike,
      isExpense: isExpense,
      requiresReview: requiresReview,
      reasonCodes: [
        if (isDuplicate) 'duplicate_candidate_group',
        if (isTransferLike) 'transfer_like_keyword',
        if (hasBankTransferPhrase) 'bank_transfer_phrase',
        if (isStoredValueTopUp) 'stored_value_top_up',
        if (isExpense) 'stable_payment_signal',
        if (!hasStableCandidate) 'weak_parse_signal',
      ],
      confidence: isExpense ? 0.9 : 0.7,
      createdAt: DateTime.now(),
      userFeedback: null,
    );
  }

  bool _hasDuplicateSignal(List<TransactionCandidate> candidates) {
    if (candidates.length < 2) {
      return false;
    }

    for (var i = 0; i < candidates.length; i += 1) {
      for (var j = i + 1; j < candidates.length; j += 1) {
        final left = candidates[i];
        final right = candidates[j];
        final sameAmount = left.amount == right.amount;
        final sameMerchant = left.merchantName == right.merchantName;
        final closeTime =
            left.occurredAt.difference(right.occurredAt).abs().inMinutes <= 5;
        if (sameAmount && sameMerchant && closeTime) {
          return true;
        }
      }
    }

    return false;
  }
}
