# BillLearn 가맹점 로고 asset 적용 가이드

이 문서는 홈/내역/상세 거래 행에서 사용하는 가맹점 로고를 정식 asset으로 교체하는 절차를 정리한다.

## 현재 상태

- 현재 앱에는 정식 가맹점 로고 파일이 없다.
- `MerchantMark`는 `MerchantVisual` catalog를 통해 가맹점별 색상/라벨 fallback을 표시한다.
- `assetPath`가 있는 catalog entry는 `Image.asset`을 먼저 사용하고, 로딩 실패 시 기존 라벨 fallback으로 돌아간다.

## 권장 파일 위치

정식 로고가 준비되면 다음 위치에 둔다.

```text
app/assets/merchants/
  baemin.png
  starbucks.png
  naverpay.png
  coupang.png
  dongbaek.png
```

권장 규칙:

- 정사각형 PNG를 우선 사용한다.
- 투명 배경 또는 앱에서 쓰는 원형/rounded 배경과 충돌하지 않는 배경을 사용한다.
- 최소 128x128px 이상을 준비한다.
- 상표권 이슈가 있는 파일은 출처와 사용 권한을 별도로 기록한다.

## 적용 절차

1. `app/assets/merchants/`에 로고 파일을 추가한다.
2. `app/pubspec.yaml`의 `flutter.assets`에 해당 파일 또는 디렉터리를 등록한다.
3. `app/lib/src/features/shared/merchant_visuals.dart`의 catalog entry에 `assetPath`를 추가한다.
4. `flutter test test/features/shared/merchant_visuals_test.dart`를 실행한다.
5. 홈/내역/상세 화면을 에뮬레이터에서 확인하고 스크린샷을 갱신한다.

예시:

```dart
_MerchantCatalogEntry(
  aliases: ['스타벅스', 'starbucks'],
  visual: MerchantVisual(
    label: '★',
    assetPath: 'assets/merchants/starbucks.png',
    background: Color(0xFF006241),
    foreground: Colors.white,
    circular: true,
  ),
),
```

## 주의사항

- 로고 파일이 없는데 `assetPath`만 먼저 넣으면 런타임에서 asset 로딩 실패가 발생한다.
- `MerchantMark`는 실패 시 fallback 라벨을 보여주지만, 실제 배포 전에는 asset 누락 경고를 남기지 않도록 확인해야 한다.
- 브랜드 로고는 홈, 내역, 상세에서 같은 `MerchantMark`를 사용하므로 catalog 한 곳만 수정하면 된다.
- 새로운 가맹점이 늘어나면 alias를 먼저 추가하고, 실제 로고는 나중에 붙여도 된다.
