import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expense = ref.watch(expenseByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('상세')),
      body: expense.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('거래를 찾을 수 없습니다'));
          }
          return _TransactionDetailContent(expense: item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('거래 정보를 불러오지 못했어요')),
      ),
    );
  }
}

class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent({required this.expense});

  final ExpenseTransaction expense;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          expense.merchantName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          '${currencyFormat.format(expense.amount)}원',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              _DetailRow(label: '결제 시간', value: _formatDate(expense.spentAt)),
              _DetailRow(label: '상태', value: _statusText(expense)),
              _DetailRow(label: '확인 방식', value: _confirmedByText(expense)),
              _DetailRow(label: '동기화', value: _syncStatusText(expense)),
              if (expense.categoryId != null)
                _DetailRow(label: '카테고리', value: expense.categoryId!),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _FeedbackActions(expense: expense),
        const SizedBox(height: 16),
        _ClassificationEvidenceCard(candidateIds: expense.candidateIds),
      ],
    );
  }

  String _formatDate(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.year}.${value.month}.${value.day} $hour:$minute';
  }

  String _statusText(ExpenseTransaction expense) {
    return switch (expense.confirmationStatus) {
      ConfirmationStatus.confirmed => '확정됨',
      ConfirmationStatus.needsReview => '확인 필요',
      ConfirmationStatus.rejected => '제외됨',
    };
  }

  String _confirmedByText(ExpenseTransaction expense) {
    return switch (expense.confirmedBy) {
      ConfirmedBy.rule => '자동 규칙',
      ConfirmedBy.user => '사용자',
      ConfirmedBy.import => '가져오기',
    };
  }

  String _syncStatusText(ExpenseTransaction expense) {
    return switch (expense.syncStatus) {
      SyncStatus.localOnly => '로컬 저장',
      SyncStatus.pendingUpload => '업로드 대기',
      SyncStatus.synced => '동기화됨',
      SyncStatus.conflict => '충돌',
    };
  }
}

class _ClassificationEvidenceCard extends StatelessWidget {
  const _ClassificationEvidenceCard({required this.candidateIds});

  final List<String> candidateIds;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '판별 근거',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (candidateIds.isEmpty)
              const Text('연결된 후보가 없습니다')
            else
              for (final candidateId in candidateIds) ...[
                _CandidateEvidence(candidateId: candidateId),
                if (candidateId != candidateIds.last) const Divider(height: 24),
              ],
          ],
        ),
      ),
    );
  }
}

class _CandidateEvidence extends ConsumerWidget {
  const _CandidateEvidence({required this.candidateId});

  final String candidateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidate = ref.watch(transactionCandidateByIdProvider(candidateId));
    final classification = ref.watch(
      classificationResultByCandidateIdProvider(candidateId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '후보: $candidateId',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        candidate.when(
          data: (item) {
            if (item == null) {
              return const Text('후보 정보를 찾을 수 없습니다');
            }
            return _CandidateSummary(candidate: item);
          },
          loading: () => const Text('후보 정보를 불러오는 중입니다'),
          error: (error, stackTrace) => const Text('후보 정보를 불러오지 못했어요'),
        ),
        const SizedBox(height: 8),
        classification.when(
          data: (item) {
            if (item == null) {
              return const Text('판별 결과를 찾을 수 없습니다');
            }
            return _ClassificationSummary(classification: item);
          },
          loading: () => const Text('판별 결과를 불러오는 중입니다'),
          error: (error, stackTrace) => const Text('판별 결과를 불러오지 못했어요'),
        ),
      ],
    );
  }
}

class _CandidateSummary extends StatelessWidget {
  const _CandidateSummary({required this.candidate});

  final TransactionCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return Column(
      children: [
        _DetailRow(label: '가맹점', value: candidate.merchantName),
        _DetailRow(
          label: '금액',
          value: '${currencyFormat.format(candidate.amount)}원',
        ),
        _DetailRow(
          label: '결제 수단',
          value: candidate.paymentMethodHint ?? '알 수 없음',
        ),
        _DetailRow(
          label: '파싱 상태',
          value:
              '${_parseStatusText(candidate.parseStatus)} · '
              '${_percentText(candidate.parseConfidence)}',
        ),
      ],
    );
  }

  String _parseStatusText(ParseStatus status) {
    return switch (status) {
      ParseStatus.parsed => '파싱됨',
      ParseStatus.unsupported => '미지원',
      ParseStatus.failed => '실패',
    };
  }

  String _percentText(double value) {
    return '${(value * 100).round()}%';
  }
}

class _ClassificationSummary extends StatelessWidget {
  const _ClassificationSummary({required this.classification});

  final ClassificationResult classification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _EvidenceChip(label: classification.isExpense ? '실제 지출' : '지출 제외'),
            _EvidenceChip(
              label: classification.isDuplicate ? '중복 의심' : '중복 아님',
            ),
            _EvidenceChip(
              label: classification.isTransferLike ? '이체/충전 의심' : '이체/충전 아님',
            ),
            _EvidenceChip(
              label: classification.requiresReview ? '검토 필요' : '검토 불필요',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '신뢰도 ${(classification.confidence * 100).round()}%',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final reasonCode in classification.reasonCodes)
              _ReasonCode(label: reasonCode),
          ],
        ),
      ],
    );
  }
}

class _EvidenceChip extends StatelessWidget {
  const _EvidenceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), visualDensity: VisualDensity.compact);
  }
}

class _ReasonCode extends StatelessWidget {
  const _ReasonCode({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _FeedbackActions extends ConsumerWidget {
  const _FeedbackActions({required this.expense});

  final ExpenseTransaction expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _updateStatus(ref, ConfirmationStatus.rejected),
            child: const Text('아니요'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () => _updateStatus(ref, ConfirmationStatus.confirmed),
            child: const Text('맞아요'),
          ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(WidgetRef ref, ConfirmationStatus status) async {
    final updated = expense.copyWith(
      confirmationStatus: status,
      confirmedBy: ConfirmedBy.user,
      updatedAt: DateTime.now(),
    );
    await ref.read(expenseRepositoryProvider).updateExpense(updated);
    ref.invalidate(expenseByIdProvider(expense.id));
    ref.invalidate(expensesProvider);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
