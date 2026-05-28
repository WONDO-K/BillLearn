# PR: UI polish for core BillLearn MVP screens

## Summary

This PR polishes the core BillLearn MVP screens using the provided white/purple brand direction while keeping the product scope focused on automatic expense tracking from payment notifications.

Korean summary:

이 PR은 홈, 내역, 상세, 설정 화면의 1차 UI 완성도를 높입니다. 자동 결제 알림 수집, 중복/이체 제외 판별, 실제 지출 저장이라는 MVP 범위는 유지하고, 화면의 카드 표현과 브랜드 톤을 통일했습니다.

## Changes

- Polished the home screen hero card with a stronger purple gradient, mascot placement, spending limit progress, review count, and recent transaction card layout.
- Reworked the previous broad AI insight area into an MVP-safe `검토가 필요한 알림` panel.
- Matched the history summary and transaction group cards with the same rounded, soft-shadow visual language.
- Polished the transaction detail hero, info, feedback, and evidence cards.
- Polished the settings hero and permission/debug/diagnostic cards.
- Added emulator screenshots to `docs/screenshots` and linked them from `docs/ui-screenshots.md`.
- Added Figma reference assets under `docs/assets/figma-free-assets` and documented adoption rules in `docs/figma-free-assets-inventory.md`.
- Added `docs/ui-polish-branch-summary.md` as a branch-level review summary.

## Verification

- `flutter analyze`: passed
- `flutter test`: passed
- `flutter build apk --debug`: passed
- Emulator screenshots captured for home, history, detail, and settings.

## Screenshots

- `docs/screenshots/billlearn-home-ui-polish.png`
- `docs/screenshots/billlearn-home-ui-polish-font.png`
- `docs/screenshots/billlearn-history-ui-polish.png`
- `docs/screenshots/billlearn-detail-ui-polish.png`
- `docs/screenshots/billlearn-settings-ui-polish.png`

## Review Notes

- The Figma SVG exports are kept as documentation/reference assets only. They are not registered in `app/pubspec.yaml` and are not bundled into the app runtime.
- Real Android device validation is still required for notification access, SMS permission, background collection, and OEM restrictions.
- This is a first-pass UI polish, not a full design-system extraction.

## Suggested Merge Target

- Base: `feature/billlearn-mvp`
- Compare: `feature/ui-polish-assets`

PR URL:

https://github.com/WONDO-K/BillLearn/compare/feature/billlearn-mvp...feature/ui-polish-assets?expand=1
