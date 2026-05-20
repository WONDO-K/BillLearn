import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/features/shared/merchant_visuals.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _DetailHeroCard(expense: expense, currencyFormat: currencyFormat),
        const SizedBox(height: 16),
        _InfoCard(
          title: '거래 정보',
          children: [
            _DetailRow(label: '결제 시간', value: _formatDate(expense.spentAt)),
            _DetailRow(label: '상태', value: _statusText(expense)),
            _DetailRow(label: '확인 방식', value: _confirmedByText(expense)),
            _DetailRow(label: '동기화', value: _syncStatusText(expense)),
            if (expense.categoryId != null)
              _DetailRow(
                label: '카테고리',
                value: _categoryText(expense.categoryId!),
              ),
          ],
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

  String _categoryText(String categoryId) {
    return switch (categoryId) {
      'food' => '배달/음식',
      'cafe' => '카페',
      'shopping' => '쇼핑',
      _ => '기타',
    };
  }
}

class _DetailHeroCard extends StatelessWidget {
  const _DetailHeroCard({required this.expense, required this.currencyFormat});

  final ExpenseTransaction expense;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isRejected =
        expense.confirmationStatus == ConfirmationStatus.rejected;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, BillLearnColors.lightPurple],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MerchantMark(
                  merchantName: expense.merchantName,
                  categoryId: expense.categoryId,
                  large: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    expense.merchantName,
                    style: TextStyle(
                      color: isRejected ? Colors.black45 : BillLearnColors.ink,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                _StatusBadge(status: expense.confirmationStatus),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _heroDescription(expense.confirmationStatus),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '거래 금액',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${currencyFormat.format(expense.amount)}원',
              style: TextStyle(
                color: isRejected ? Colors.black45 : BillLearnColors.ink,
                decoration: isRejected ? TextDecoration.lineThrough : null,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _heroDescription(ConfirmationStatus status) {
    return switch (status) {
      ConfirmationStatus.confirmed => '결제 알림을 분석해 실제 지출로 저장했어요.',
      ConfirmationStatus.needsReview => '이체나 충전처럼 보이는 단서가 있어 확인이 필요해요.',
      ConfirmationStatus.rejected => '사용자 확인 또는 자동 판별로 지출에서 제외된 거래예요.',
    };
  }
}

// 원천 알림이 최종 지출로 이어진 근거를 사용자에게 설명하는 상세 영역입니다.
class _ClassificationEvidenceCard extends StatelessWidget {
  const _ClassificationEvidenceCard({required this.candidateIds});

  final List<String> candidateIds;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: '판별 근거',
      subtitle: '사용자용 설명과 개발자용 원본 정보를 나눠 보여줘요.',
      children: [
        if (candidateIds.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('연결된 후보가 없습니다'),
          )
        else
          for (final candidateId in candidateIds) ...[
            _CandidateEvidence(candidateId: candidateId),
            if (candidateId != candidateIds.last) const Divider(height: 24),
          ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  color: BillLearnColors.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            ...children,
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
        candidate.when(
          data: (item) {
            if (item == null) {
              return const Text('후보 정보를 찾을 수 없습니다');
            }
            return _CandidateSummary(candidate: item);
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('후보 정보를 불러오는 중입니다'),
          ),
          error: (error, stackTrace) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('후보 정보를 불러오지 못했어요'),
          ),
        ),
        const SizedBox(height: 8),
        classification.when(
          data: (item) {
            if (item == null) {
              return const Text('판별 결과를 찾을 수 없습니다');
            }
            return _ClassificationSummary(classification: item);
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('판별 결과를 불러오는 중입니다'),
          ),
          error: (error, stackTrace) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('판별 결과를 불러오지 못했어요'),
          ),
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

    return _DeveloperEvidencePanel(
      title: '수집된 알림 정보',
      children: [
        _DetailRow(label: '후보 ID', value: candidate.id),
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
              '${_parseStatusText(candidate.parseStatus)} · ${_percentText(candidate.parseConfidence)}',
        ),
        _RawNotificationSummary(rawNotificationId: candidate.rawNotificationId),
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

class _RawNotificationSummary extends ConsumerWidget {
  const _RawNotificationSummary({required this.rawNotificationId});

  final String rawNotificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raw = ref.watch(rawNotificationByIdProvider(rawNotificationId));

    return raw.when(
      data: (item) {
        if (item == null) {
          return _DetailRow(label: '원본 알림', value: rawNotificationId);
        }
        return _RawNotificationBody(raw: item);
      },
      loading: () => const _DetailRow(label: '원본 알림', value: '불러오는 중'),
      error: (error, stackTrace) =>
          const _DetailRow(label: '원본 알림', value: '불러오지 못함'),
    );
  }
}

class _RawNotificationBody extends StatelessWidget {
  const _RawNotificationBody({required this.raw});

  final RawNotification raw;

  @override
  Widget build(BuildContext context) {
    final source = switch (raw.sourceType) {
      RawNotificationSourceType.push => '푸시 알림',
      RawNotificationSourceType.sms => '문자 메시지',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: BillLearnColors.softGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$source · ${raw.sender ?? raw.sourceApp ?? '출처 알 수 없음'}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              if (raw.title != null) ...[
                Text(
                  raw.title!,
                  style: const TextStyle(
                    color: BillLearnColors.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                raw.body,
                style: const TextStyle(
                  color: BillLearnColors.ink,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassificationSummary extends StatelessWidget {
  const _ClassificationSummary({required this.classification});

  final ClassificationResult classification;

  @override
  Widget build(BuildContext context) {
    final explanation = _explanation(classification);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _UserDecisionNotice(
            title: explanation.title,
            body: explanation.body,
            accentColor: explanation.accentColor,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _EvidenceChip(
                label: classification.isExpense ? '실제 지출' : '지출 제외',
              ),
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
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '신뢰도 ${(classification.confidence * 100).round()}%',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '개발자용 reason code',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final reasonCode in classification.reasonCodes)
                _ReasonCode(label: reasonCode),
            ],
          ),
        ),
      ],
    );
  }

  _DecisionExplanation _explanation(ClassificationResult classification) {
    if (classification.isExpense && !classification.requiresReview) {
      return const _DecisionExplanation(
        title: '실제 지출로 저장했어요',
        body: '결제 금액과 가맹점 정보가 안정적으로 파싱됐고, 이체나 충전으로 볼 단서가 적어요.',
        accentColor: BillLearnColors.mainPurple,
      );
    }
    if (!classification.isExpense && classification.isTransferLike) {
      return const _DecisionExplanation(
        title: '지출에서 제외하는 편이 안전해요',
        body: '계좌이체, 충전, 환불처럼 실제 소비가 아닐 수 있는 단서가 있어요.',
        accentColor: Color(0xFF6B7280),
      );
    }
    if (classification.requiresReview) {
      return const _DecisionExplanation(
        title: '확인이 필요한 거래예요',
        body: '실제 결제일 수도 있지만 중복, 이체, 충전 가능성이 있어 사용자의 확인이 필요해요.',
        accentColor: BillLearnColors.mainPurple,
      );
    }
    return const _DecisionExplanation(
      title: '자동 판별 결과를 확인해주세요',
      body: '현재 규칙으로 분류했지만, 사용자의 선택이 이후 판별 품질을 높이는 기준이 됩니다.',
      accentColor: BillLearnColors.mainPurple,
    );
  }
}

class _DecisionExplanation {
  const _DecisionExplanation({
    required this.title,
    required this.body,
    required this.accentColor,
  });

  final String title;
  final String body;
  final Color accentColor;
}

class _UserDecisionNotice extends StatelessWidget {
  const _UserDecisionNotice({
    required this.title,
    required this.body,
    required this.accentColor,
  });

  final String title;
  final String body;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome_rounded, color: accentColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    body,
                    style: const TextStyle(
                      color: BillLearnColors.ink,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperEvidencePanel extends StatelessWidget {
  const _DeveloperEvidencePanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE7E3F5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: BillLearnColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _EvidenceChip extends StatelessWidget {
  const _EvidenceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.lightPurple,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: BillLearnColors.mainPurple,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ReasonCode extends StatelessWidget {
  const _ReasonCode({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.softGray,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이 거래가 실제 지출인가요?',
              style: TextStyle(
                color: BillLearnColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '답변은 다음 자동 판별 품질을 높이는 기준으로 사용됩니다.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _updateStatus(ref, ConfirmationStatus.rejected),
                    child: const Text('아니요'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        _updateStatus(ref, ConfirmationStatus.confirmed),
                    child: const Text('맞아요'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: BillLearnColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ConfirmationStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      ConfirmationStatus.confirmed => '확정됨',
      ConfirmationStatus.needsReview => '확인 필요',
      ConfirmationStatus.rejected => '제외됨',
    };
    final color = switch (status) {
      ConfirmationStatus.confirmed => BillLearnColors.mainPurple,
      ConfirmationStatus.needsReview => BillLearnColors.mainPurple,
      ConfirmationStatus.rejected => Colors.black45,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
