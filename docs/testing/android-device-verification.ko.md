# BillLearn Android 기기 검증 체크리스트

이 문서는 실제 Android 기기에서 BillLearn MVP의 핵심 경로를 검증하기 위한 절차입니다.

작성 기준: 2026-05-21 현재 Flutter/Android MVP 구현 상태

주의: 현재 Android native 수집기는 raw event를 SharedPreferences pending queue에 먼저 저장하고, Flutter 시작 시 `drainPendingRawEvents`로 회수한다. 다만 실제 제조사 기기에서 NotificationListenerService/SMS receiver가 백그라운드 또는 강제 종료 상태에서도 실행되는지는 아직 검증하지 않았다.

## 검증 목표

- 앱이 실제 기기에 설치된다.
- 알림 접근 권한 설정 화면으로 이동할 수 있다.
- SMS runtime 권한을 요청할 수 있다.
- Android 알림/SMS raw event가 Flutter pipeline으로 전달된다.
- 결제성 raw event가 SQLite에 저장되고 설정 화면의 수집 진단에 표시된다.
- raw event가 파싱 후보와 판별 결과로 이어지는지 확인한다.
- 실제 지출은 홈 화면, 내역 화면, 상세 화면에 표시된다.
- 이체/충전/취소/환불성 알림은 실제 지출에서 제외된다.
- 상세 화면에서 사용자용 판별 설명, 수집된 원본 알림, 개발자용 reason code를 확인한다.

## 준비물

- Android 10 이상 실제 기기 권장
- USB 디버깅 활성화
- Windows PC에서 기기 RSA 디버깅 허용
- 테스트용 카드/결제 앱 알림 또는 수동 SMS 테스트 환경
- 테스트 전 BillLearn 앱 알림 권한이 차단되어 있지 않은지 확인
- 가능하면 삼성, Pixel, 샤오미/중국 제조사 계열처럼 배터리 정책이 다른 기기를 분리해서 기록

기록할 기기 정보:

- 제조사/모델명
- Android 버전
- One UI/MIUI 등 제조사 OS 버전
- 테스트 앱 버전 또는 git commit
- 알림 접근 권한 상태
- SMS 권한 상태
- 배터리 최적화 예외 여부

## 1. 기기 연결 확인

```powershell
Set-Location E:\workspace\BillLearn\app
..\.tools\android-sdk\platform-tools\adb.exe devices
```

성공 기준:

- `device` 상태의 기기가 1대 이상 표시된다.
- `unauthorized`가 표시되면 기기에서 RSA 디버깅 허용을 누른 뒤 다시 실행한다.

## 2. APK 빌드

```powershell
Set-Location E:\workspace\BillLearn\app
$env:ANDROID_HOME=(Resolve-Path ..\.tools\android-sdk).Path
$env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
$env:GRADLE_USER_HOME=(Resolve-Path ..\.tools\gradle).Path
..\.tools\flutter\bin\flutter.bat build apk --debug
```

성공 기준:

- `build\app\outputs\flutter-apk\app-debug.apk`가 생성된다.

## 3. APK 설치

```powershell
Set-Location E:\workspace\BillLearn\app
..\.tools\android-sdk\platform-tools\adb.exe install -r build\app\outputs\flutter-apk\app-debug.apk
```

성공 기준:

- `Success`가 출력된다.

## 4. 앱 실행

```powershell
Set-Location E:\workspace\BillLearn\app
..\.tools\android-sdk\platform-tools\adb.exe shell monkey -p com.billlearn.app 1
```

성공 기준:

- BillLearn 앱이 기기에서 실행된다.
- 홈, 내역, 설정 탭이 표시된다.
- 홈 상단 카드에 `이번 달 총 지출`, `월 지출 한도`, 진행률, 검토할 알림 수가 표시된다.

## 5. 권한 UX 확인

설정 탭에서 확인한다.

- `알림 접근 권한` 항목이 표시된다.
- `설정 열기` 버튼을 누르면 Android 알림 접근 권한 설정 화면으로 이동한다.
- BillLearn 알림 접근 권한을 켠 뒤 앱으로 돌아오면 상태가 `켜짐`으로 갱신된다.
- `SMS 권한` 항목이 표시된다.
- `SMS 권한 요청` 버튼을 누르면 Android 권한 요청 dialog가 표시된다.
- 허용 후 상태가 `켜짐`으로 갱신된다.

실패/주의 기록:

- 일부 제조사는 알림 접근 권한 화면의 경로와 문구가 다를 수 있다.
- SMS 권한을 거부한 뒤 다시 요청하면 Android 정책상 dialog가 바로 뜨지 않을 수 있다. 이 경우 앱 정보의 권한 화면에서 직접 허용해야 한다.
- Google Play 배포를 전제로 하면 SMS 권한은 민감 권한 심사 대상이다. MVP 검증 통과와 Play 배포 가능성은 별도 판단해야 한다.

## 6. 로그 확인

앱 실행 중 별도 터미널에서 로그를 확인한다.

```powershell
Set-Location E:\workspace\BillLearn\app
..\.tools\android-sdk\platform-tools\adb.exe logcat | Select-String "BillLearn|billlearn|Flutter"
```

확인할 것:

- 앱 실행 중 Flutter crash가 없어야 한다.
- 알림 접근 권한 또는 SMS 권한 요청 후 native exception이 없어야 한다.
- 알림 수신 시 `BillLearn`, `billlearn`, `AndroidRuntime`, `NotificationListenerService`, `SmsReceiver` 관련 예외가 없어야 한다.

## 7. 설정 화면 수집 진단 확인

설정 탭의 `수집 진단` 카드를 확인한다.

초기 성공 기준:

- `수집 진단` 카드가 표시된다.
- 아직 테스트 알림을 받기 전이면 `최근 수집 0건` 또는 `아직 수집된 원천 알림이 없습니다.`가 표시된다.

테스트 알림 수신 후 성공 기준:

- `최근 수집 N건`의 숫자가 증가한다.
- `마지막 수집` 아래에 raw 알림 본문이 표시된다.
- `파싱 결과` 아래에 가맹점명과 금액이 표시된다.
- `판별 결과` 아래에 `실제 지출` 또는 `지출 제외` 상태가 표시된다.
- reason code가 표시된다. 예: `stable_payment_signal`, `transfer_like_keyword`, `cancellation_or_refund`
- 상세 화면의 `판별 근거`에서 같은 원본 알림 body가 다시 확인된다.

이 카드의 목적:

- raw 수집 실패인지, 파싱 실패인지, 분류 실패인지 빠르게 구분한다.
- 실제 Android 기기에서 제조사/권한/백그라운드 제한 문제를 진단한다.

## 8. 결제 알림 수집 확인

테스트 방법:

- 카드 앱 또는 간편결제 앱에서 실제 결제 알림을 발생시킨다.
- 또는 테스트 기기에 결제 승인 형태의 SMS를 수신시킨다.

예시 문자:

```text
[신한카드 승인] 12,300원 스타벅스 05/14 12:30
```

성공 기준:

- 설정 화면 `수집 진단`에서 raw 본문, 파싱 결과, 판별 결과가 표시된다.
- 홈 화면 `이번 달 총 지출` 금액이 증가한다.
- 홈 화면 `최근 거래`에 가맹점명과 금액이 표시된다.
- 내역 화면에서 해당 날짜 그룹 아래에 거래가 표시된다.
- 상세 화면에서 `판별 근거`에 사용자용 설명, 후보 ID, 원본 알림 body, reason code가 표시된다.
- 동일 앱 세션에서 앱을 재시작해도 SQLite 저장 데이터가 유지된다.

추가 확인:

- 같은 결제를 카드 앱 푸시와 SMS가 동시에 보낼 경우, 중복 저장 여부를 기록한다.
- 현재 일반 결제의 같은 가맹점/같은 금액 반복 결제는 자동 제외하지 않고 별도 거래로 유지하는 것이 기대 동작이다.
- 계좌이체/충전성 이벤트는 실제 지출 저장보다 제외 또는 확인 필요로 분류되는 것이 기대 동작이다.

## 9. 이체/충전/취소 제외 확인

아래 샘플은 실제 지출로 저장되면 안 된다.

### 계좌 이체

```text
토스뱅크 홍길동님에게 50,000원 보냈어요
```

성공 기준:

- 설정 화면 `수집 진단`에는 raw와 판별 결과가 표시된다.
- 판별 reason code에 `bank_transfer_phrase`가 표시된다.
- 홈 화면 `이번 달 총 지출` 금액은 증가하지 않는다.

### 지역화폐 충전

```text
동백전 충전 5,000원
```

성공 기준:

- 판별 reason code에 `stored_value_top_up`이 표시된다.
- 실제 지출로 저장되지 않는다.
- 상세 화면에 표시될 경우 `지출에서 제외하는 편이 안전해요` 같은 사용자용 설명이 표시된다.

### 승인취소/환불

```text
[신한카드 승인취소] 12,300원 스타벅스
```

성공 기준:

- 판별 reason code에 `cancellation_or_refund`가 표시된다.
- 같은 금액/가맹점의 기존 원결제가 있으면 내역에서 `제외됨`으로 바뀐다.
- 원결제가 없으면 새 지출은 생성되지 않는다.

## 10. 백그라운드/종료 상태 수집 확인

현재 구현 한계를 확인하기 위한 별도 테스트다. 실패해도 MVP 기능 실패로 단정하지 않고 개선 과제로 기록한다.

### 앱이 화면에 열린 상태

성공 기준:

- 알림/SMS 수신 후 설정 화면 수집 건수가 증가한다.
- 홈/내역에 결과가 반영된다.

### 앱이 백그라운드에 있는 상태

테스트 방법:

- BillLearn을 한 번 실행한 뒤 홈 버튼으로 백그라운드 전환한다.
- 결제 알림 또는 SMS를 발생시킨다.
- 앱으로 돌아와 설정 화면 `수집 진단`을 확인한다.

기록할 것:

- 수집 성공 여부
- 제조사 배터리 제한 알림 여부
- 앱이 OS에 의해 정리됐는지 여부

### 앱을 강제 종료한 상태

테스트 방법:

- 최근 앱 목록에서 BillLearn을 종료하거나 `adb shell am force-stop com.billlearn.app`을 실행한다.
- 결제 알림 또는 SMS를 발생시킨다.
- 앱을 다시 실행해 수집 여부를 확인한다.

현재 기대:

- native pending queue가 있으므로 receiver/service가 실행되기만 하면 다음 앱 시작 시 회수되는 것이 기대 동작이다.
- 단, `force-stop` 이후 Android가 receiver/service 자체를 막는 제조사/OS 정책이 있으면 여전히 누락될 수 있다.

## 11. 실패 시 분기

알림이 수집되지 않는 경우:

- Android 설정에서 BillLearn 알림 접근 권한이 켜져 있는지 확인한다.
- 제조사 배터리 최적화가 알림 listener를 제한하는지 확인한다.
- 결제 앱 알림이 실제 Android notification으로 표시되는지 확인한다.
- 설정 화면 `수집 진단`의 수집 건수가 증가하는지 확인한다.
- 앱이 강제 종료된 상태라면 receiver/service가 실행됐는지와 pending queue 회수 여부를 분리해서 기록한다.
- receiver/service는 실행됐지만 앱 재시작 후 수집 진단에 안 보이면 pending queue drain 문제로 기록한다.

SMS가 수집되지 않는 경우:

- SMS 권한이 허용되어 있는지 확인한다.
- 테스트 문자가 기본 SMS provider를 통해 수신되는지 확인한다.
- Android 4.4 이후 기본 SMS 앱이 아니어도 `SMS_RECEIVED` broadcast 수신 가능 여부가 제조사 정책에 막히는지 확인한다.
- Google Play 배포를 고려할 경우 SMS 권한 정책 리스크를 별도로 검토한다.

홈 화면에 지출이 표시되지 않는 경우:

- 설정 화면 `수집 진단`에서 raw 본문이 표시되는지 먼저 확인한다.
- raw는 표시되지만 `파싱 결과`가 없으면 parser fixture에 새 샘플을 추가한다.
- 파싱 결과는 있지만 `지출 제외`로 판별되면 reason code를 확인한다.
- 문자/알림 본문에 `원` 단위 금액과 가맹점명이 포함되어 있는지 확인한다.
- 이체, 송금, 충전 등 이체성 키워드가 포함되어 review 또는 제외 처리되는지 확인한다.
- 파서 샘플을 추가해야 하는 카드사/은행 포맷인지 기록한다.

상세 화면에서 원본 알림이 표시되지 않는 경우:

- `TransactionCandidate.rawNotificationId`가 실제 저장된 `RawNotification.id`와 연결되어 있는지 확인한다.
- 설정 화면 수집 진단에는 raw가 보이지만 상세에만 안 보이면 raw ID 조회 provider 또는 repository 조회를 확인한다.
- 테스트 샘플 데이터인지 실제 수집 데이터인지 구분한다.

## 12. Google Play SMS 권한 정책 리스크

MVP 개발 검증에서는 SMS receiver를 사용하지만, Google Play 배포 단계에서는 다음 항목을 별도 검토해야 한다.

- SMS 권한이 앱 핵심 기능에 필수인지 설명할 수 있어야 한다.
- 사용자가 SMS 권한 없이도 앱을 제한적으로 사용할 수 있는지 정리한다.
- SMS 본문은 민감 정보이므로 개인정보 처리방침에 수집 목적, 저장 위치, 보관 기간, 삭제 방법을 명시해야 한다.
- 가능하면 SMS 없이도 알림 접근, 카드사/금융 API, MyData, 수동 입력으로 대체 가능한 경로를 준비한다.
- Play Console 권한 선언 양식에 맞는 스크린샷과 사용자 설명 문구가 필요하다.

## 현재 미검증 항목

이 문서 작성 시점에는 현재 작업 환경에 연결된 Android 기기가 없어 실제 기기 설치/권한/수집 검증은 아직 수행하지 못했다.

추가 미검증 항목:

- 제조사별 배터리 최적화가 NotificationListenerService를 제한하는지 여부
- 앱 강제 종료 후 NotificationListenerService/SMS receiver 실행 여부
- native pending queue가 실제 기기에서 앱 재시작 후 정상 drain되는지 여부
- 실제 카드사/은행/간편결제 앱별 알림 포맷 정확도
- Google Play SMS 권한 심사 가능성
- 장기간 사용 시 SQLite 데이터 증가와 중복 raw event 처리 안정성
