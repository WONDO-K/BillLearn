# BillLearn UI Screenshots

이 문서는 에뮬레이터에서 확인한 현재 BillLearn UI 상태를 고정해두는 기준 자료입니다.

- 기준 기기: Android emulator `emulator-5554`
- 목적: 화면 polish 전후 비교, README/PR 설명, 다음 UI 개선 우선순위 판단
- 데이터 상태: `설정 > 개발자 도구 > 샘플 거래 생성`으로 생성한 debug sample 포함

## Current Main Flow

### Home

홈 화면은 확정 지출 총액, 확인 필요 거래, 최근 지출을 한 화면에서 확인하는 진입점입니다.

![BillLearn home with sample data](screenshots/billlearn-home-seeded.png)

확인 포인트:

- 확정 지출 총액 `29,000원`
- 확인 필요 거래 `동백전 충전`
- 최근 확정 지출 `스타벅스`, `배달의민족`

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

초기 UI 상태 비교용으로 보관한 빈 상태 캡처입니다.

![BillLearn home empty state](screenshots/billlearn-home.png)

![BillLearn history empty state](screenshots/billlearn-history.png)

## Current UI Gaps

- 상세 화면의 `판별 근거` 하단 전체를 보여주는 추가 스크롤 캡처가 필요합니다.
- 마스코트 SVG를 홈 빈 상태나 안내 카드에 활용하면 브랜드성이 더 강해집니다.
- UI 스크린샷을 README에 일부 노출할지, 문서 링크만 유지할지 결정이 필요합니다.
