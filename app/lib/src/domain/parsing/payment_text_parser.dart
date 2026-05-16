import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

class PaymentTextParser {
  static final _amountPattern = RegExp(r'([\d,]+)\s*원');
  static final _paymentMethodPattern = RegExp(r'\[?([가-힣A-Za-z]+(?:카드|페이|전))');
  static final _merchantAfterAmountPattern = RegExp(
    r'[\d,]+\s*원\s+([가-힣A-Za-z0-9&._ -]+)',
  );

  TransactionCandidate parse(RawNotification raw) {
    final amountMatch = _amountPattern.firstMatch(raw.body);
    if (amountMatch == null) {
      return _unsupported(raw);
    }

    final amountText = amountMatch.group(1)!.replaceAll(',', '');
    final amount = int.tryParse(amountText);
    if (amount == null) {
      return _unsupported(raw);
    }

    final merchant =
        _merchantAfterAmountPattern.firstMatch(raw.body)?.group(1)?.trim() ??
        '';
    final method = _paymentMethodPattern.firstMatch(raw.body)?.group(1);

    return TransactionCandidate(
      id: 'candidate-${raw.id}',
      rawNotificationId: raw.id,
      amount: amount,
      merchantName: _cleanMerchantName(merchant),
      paymentMethodHint: method,
      occurredAt: raw.receivedAt,
      sourceType: raw.sourceType,
      parseConfidence: merchant.isEmpty ? 0.65 : 0.9,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime.now(),
    );
  }

  TransactionCandidate _unsupported(RawNotification raw) {
    return TransactionCandidate(
      id: 'candidate-${raw.id}',
      rawNotificationId: raw.id,
      amount: 0,
      merchantName: '',
      paymentMethodHint: null,
      occurredAt: raw.receivedAt,
      sourceType: raw.sourceType,
      parseConfidence: 0,
      parseStatus: ParseStatus.unsupported,
      createdAt: DateTime.now(),
    );
  }

  String _cleanMerchantName(String value) {
    return value
        .replaceAll(RegExp(r'\s+잔액.*$'), '')
        .replaceAll(RegExp(r'\s+승인번호\s+\S+.*$'), '')
        .replaceAll(RegExp(r'\s+승인\s+\S+.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}/\d{1,2}.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}:\d{2}.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}$'), '')
        .trim();
  }
}
