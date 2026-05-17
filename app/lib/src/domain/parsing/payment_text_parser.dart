import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

class PaymentTextParser {
  static final _amountPattern = RegExp(r'([\d,]+)\s*원');
  static final _paymentMethodPattern = RegExp(
    r'\[?([가-힣A-Za-z\s]+(?:카드|페이|전))',
  );
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

    final merchant = _extractMerchant(raw);
    final method = _extractPaymentMethod(raw);

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

  String _extractMerchant(RawNotification raw) {
    final merchantAfterAmount = _merchantAfterAmountPattern
        .firstMatch(raw.body)
        ?.group(1)
        ?.trim();
    if (merchantAfterAmount != null && merchantAfterAmount.isNotEmpty) {
      return _cleanMerchantName(merchantAfterAmount);
    }

    final beforeAmount = raw.body.substring(
      0,
      _amountPattern.firstMatch(raw.body)!.start,
    );
    final cleaned = beforeAmount
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\[[^\]]+\]'), ' ')
        .replaceAll(RegExp(r'\b\d{1,2}/\d{1,2}\b'), ' ')
        .replaceAll(RegExp(r'\b\d{1,2}:\d{2}\b'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final tokens = cleaned
        .split(' ')
        .where((token) => token.trim().isNotEmpty)
        .toList(growable: false);
    final ignoredTokens = {
      '승인',
      '결제',
      '결제완료',
      '사용',
      '체크카드',
      '카드',
      '일시불',
      '출금',
      '입금',
    };
    final merchantTokens = tokens
        .where((token) => !ignoredTokens.contains(token))
        .where((token) => !token.endsWith('카드'))
        .where((token) => !token.endsWith('페이'))
        .toList(growable: false);
    if (merchantTokens.isEmpty) {
      return '';
    }
    return _cleanMerchantName(merchantTokens.last);
  }

  String? _extractPaymentMethod(RawNotification raw) {
    final fromBody = _paymentMethodPattern.firstMatch(raw.body)?.group(1);
    final method = fromBody ?? raw.title;
    if (method == null) {
      return null;
    }
    return method
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(RegExp(r'\s+승인.*$'), '')
        .replaceAll(RegExp(r'\s+결제.*$'), '')
        .trim();
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
        .replaceAll(RegExp(r'^(일시불|할부|승인|결제완료|결제)\s+'), '')
        .replaceAll(RegExp(r'\s+잔액.*$'), '')
        .replaceAll(RegExp(r'\s+승인번호\s+\S+.*$'), '')
        .replaceAll(RegExp(r'\s+승인\s+\S+.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}/\d{1,2}.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}:\d{2}.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}$'), '')
        .trim();
  }
}
