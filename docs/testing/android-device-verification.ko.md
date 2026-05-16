# BillLearn Android 기기 검증 체크리스트

이 문서는 실제 Android 기기에서 BillLearn MVP의 핵심 경로를 검증하기 위한 절차입니다.

## 검증 목표

- 앱이 실제 기기에 설치된다.
- 알림 접근 권한 설정 화면으로 이동할 수 있다.
- SMS runtime 권한을 요청할 수 있다.
- Android 알림/SMS raw event가 Flutter pipeline으로 전달된다.
- 결제성 raw event가 SQLite에 저장되고 홈 화면의 실제 지출로 표시된다.

## 준비물

- Android 10 이상 실제 기기 권장
- USB 디버깅 활성화
- Windows PC에서 기기 RSA 디버깅 허용
- 테스트용 카드/결제 앱 알림 또는 수동 SMS 테스트 환경

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

## 5. 권한 UX 확인

설정 탭에서 확인한다.

- `알림 접근 권한` 항목이 표시된다.
- `설정 열기` 버튼을 누르면 Android 알림 접근 권한 설정 화면으로 이동한다.
- BillLearn 알림 접근 권한을 켠 뒤 앱으로 돌아오면 상태가 `켜짐`으로 갱신된다.
- `SMS 권한` 항목이 표시된다.
- `SMS 권한 요청` 버튼을 누르면 Android 권한 요청 dialog가 표시된다.
- 허용 후 상태가 `켜짐`으로 갱신된다.

## 6. 로그 확인

앱 실행 중 별도 터미널에서 로그를 확인한다.

```powershell
Set-Location E:\workspace\BillLearn\app
..\.tools\android-sdk\platform-tools\adb.exe logcat | Select-String "BillLearn|billlearn|Flutter"
```

확인할 것:

- 앱 실행 중 Flutter crash가 없어야 한다.
- 알림 접근 권한 또는 SMS 권한 요청 후 native exception이 없어야 한다.

## 7. 결제 알림 수집 확인

테스트 방법:

- 카드 앱 또는 간편결제 앱에서 실제 결제 알림을 발생시킨다.
- 또는 테스트 기기에 결제 승인 형태의 SMS를 수신시킨다.

예시 문자:

```text
[신한카드 승인] 12,300원 스타벅스 05/14 12:30
```

성공 기준:

- 홈 화면 `이번 달 실제 지출` 금액이 증가한다.
- `최근 내역`에 가맹점명과 금액이 표시된다.
- 동일 앱 세션에서 앱을 재시작해도 SQLite 저장 데이터가 유지된다.

## 8. 실패 시 분기

알림이 수집되지 않는 경우:

- Android 설정에서 BillLearn 알림 접근 권한이 켜져 있는지 확인한다.
- 제조사 배터리 최적화가 알림 listener를 제한하는지 확인한다.
- 결제 앱 알림이 실제 Android notification으로 표시되는지 확인한다.

SMS가 수집되지 않는 경우:

- SMS 권한이 허용되어 있는지 확인한다.
- 테스트 문자가 기본 SMS provider를 통해 수신되는지 확인한다.
- Google Play 배포를 고려할 경우 SMS 권한 정책 리스크를 별도로 검토한다.

홈 화면에 지출이 표시되지 않는 경우:

- 문자/알림 본문에 `원` 단위 금액과 가맹점명이 포함되어 있는지 확인한다.
- 이체, 송금, 충전 등 이체성 키워드가 포함되어 review 또는 제외 처리되는지 확인한다.
- 파서 샘플을 추가해야 하는 카드사/은행 포맷인지 기록한다.

## 현재 미검증 항목

이 문서 작성 시점에는 현재 작업 환경에 연결된 Android 기기가 없어 실제 기기 설치/권한/수집 검증은 아직 수행하지 못했다.
