# BillLearn UI Screenshots

이 문서는 에뮬레이터에서 확인한 현재 BillLearn UI 상태를 고정해두는 기준 자료입니다.

- 기준 기기: Android emulator `emulator-5554`
- 목적: 화면 polish 전후 비교, README/PR 설명, 다음 UI 개선 우선순위 판단
- 데이터 상태: debug sample 포함 화면과 앱 데이터 초기화 후 빈 상태 화면을 함께 보관

## Current Main Flow

### Home

홈 화면은 확정 지출 총액, 확인 필요 거래, 최근 지출을 한 화면에서 확인하는 진입점입니다.

![BillLearn home with sample data](screenshots/billlearn-home-seeded.png)

#### Home Layout Review

시안의 상단 지출 요약 영역과 최근 거래 카드 구조에 맞춰 재구성한 홈 화면 캡처입니다.

![BillLearn home red yellow review](screenshots/billlearn-home-red-yellow-review.png)

확인 포인트:

- `이번 달 총 지출`, 예산, 진행률, 전월 대비 상태, 검토 알림 수를 한 카드에 배치
- 히어로 카드 오른쪽에 브랜드 마스코트 노출
- 최근 거래를 흰 rounded card 안에 compact list로 표시
- 가맹점 로고는 아직 실제 로고가 아닌 카테고리/가맹점 초성 placeholder

확인 포인트:

- 확정 지출 총액 `29,000원`
- 확인 필요 거래 `동백전 충전`
- 최근 확정 지출 `스타벅스`, `배달의민족`

#### Home Empty State

앱 데이터가 없는 첫 실행 상태에서 빈 거래 안내와 브랜드 마스코트가 함께 노출되는지 확인한 캡처입니다.

![BillLearn home empty state with mascot](screenshots/billlearn-home-mascot-empty.png)

확인 포인트:

- `AI가 헷갈린 거래`, `최근 내역` 빈 상태에 마스코트 SVG 노출
- 결제 알림 수집 전에도 홈의 브랜드 인지 유지
- bottom navigation과 빈 상태 카드 간 간섭 없음

### History

내역 화면은 확정/검토/제외 상태를 함께 보여주는 거래 리스트입니다.

![BillLearn history with sample data](screenshots/billlearn-history-seeded.png)

확인 포인트:

- 확정 지출 `2건`
- 검토 거래 `1건`
- `확인 필요` 상태 chip과 안내 문구

### Transaction Detail

상세 화면은 거래 금액, 거래 정보, 사용자 피드백, 판별 근거를 순서대로 보여줍니다.

![BillLearn transaction detail with sample data](screenshots/billlearn-detail-seeded.png)

확인 포인트:

- `동백전 충전`이 확인 필요 거래로 표시됨
- `맞아요` / `아니요` 피드백 동선
- 파싱 후보와 판별 근거 진입부

#### Transaction Detail Evidence

상세 화면을 하단까지 스크롤했을 때 파싱 후보, 판별 결과, reason code가 노출되는지 확인한 캡처입니다.

![BillLearn transaction detail evidence bottom](screenshots/billlearn-detail-evidence-bottom.png)

확인 포인트:

- 후보 ID와 가맹점/금액/결제 수단
- `지출 제외`, `중복 아님`, `이체/충전 의심`, `검토 필요` 판별 chip
- 신뢰도와 `debug_sample`, `stored_value_top_up` reason code

### Settings

설정 화면은 권한 상태, 개발자용 샘플 데이터 생성, 수집 진단을 확인하는 화면입니다.

![BillLearn settings polished](screenshots/billlearn-settings-polished.png)

확인 포인트:

- 알림 접근 권한 / SMS 권한 상태
- debug mode 전용 `샘플 거래 생성`
- 수집 진단 카드 진입부

### Settings Diagnostics

수집 진단 하단까지 스크롤했을 때 bottom navigation에 콘텐츠가 가리지 않는지 확인한 캡처입니다.

![BillLearn settings bottom padding](screenshots/billlearn-settings-bottom-padding.png)

확인 포인트:

- 최근 수집 건수
- 마지막 raw notification body
- 파싱 결과
- 판별 결과와 reason code

## Legacy Empty-State Captures

초기 UI 상태 비교용으로 보관한 이전 빈 상태 캡처입니다.

![BillLearn home empty state](screenshots/billlearn-home.png)

![BillLearn history empty state](screenshots/billlearn-history.png)

## Current UI Gaps

- UI 스크린샷을 README에 일부 노출할지, 문서 링크만 유지할지 결정이 필요합니다.
