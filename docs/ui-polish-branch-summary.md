# UI Polish Branch Summary

Branch: `feature/ui-polish-assets`

## Purpose

Bring the core BillLearn MVP screens closer to the provided white/purple brand direction while keeping the product scope focused on:

- automatic payment notification collection
- transfer/top-up/duplicate judgment
- real expense storage
- home/history/detail/settings confirmation flows

## Main Changes

### Home

- Reworked the top monthly spending hero card with a stronger purple gradient, mascot placement, glow, spending limit progress, and review count.
- Replaced the broad AI insight framing with a narrower MVP-safe `검토가 필요한 알림` panel.
- Polished recent transaction cards and merchant fallback visuals.
- Adjusted copy and spacing for larger font settings.

### History

- Matched summary and transaction group card depth with the home card style.
- Shortened review transaction helper copy for better large-font behavior.
- Kept `InkWell` interactions inside `Material` so tap behavior remains valid.

### Detail

- Matched the transaction detail hero, info, feedback, and evidence cards with the same rounded/soft-shadow visual language.
- Added one-line ellipsis behavior for long merchant names.

### Settings

- Matched settings hero and cards with the same rounded/soft-shadow visual language.
- Limited permission descriptions to three lines to avoid pushing the layout too far in larger font settings.
- Captured the polished settings screen after emulator verification.

### Design Assets

- Added Figma free assets under `docs/assets/figma-free-assets` as references only.
- Documented adoption rules in `docs/figma-free-assets-inventory.md`.
- Full SVG exports are not registered in `app/pubspec.yaml` and are not bundled into the app runtime.

## Verification

Latest full-branch verification:

- `flutter analyze`: passed
- `flutter test`: passed
- `flutter build apk --debug`: passed

Screenshots updated in `docs/ui-screenshots.md`:

- home UI polish
- home large-font pass
- history UI polish
- detail UI polish
- settings UI polish

## Residual Risks

- Screenshots are emulator-based. Real Android device checks are still needed for permission flows, background notification collection, and OEM restrictions.
- Figma reference SVGs add repository size under `docs/assets`; they are not runtime assets, but the team may later decide to keep only source links or extracted assets.
- UI polish is still first-pass. It improves consistency, but it is not a full design-system extraction.

## Suggested Next Step

Open a PR from `feature/ui-polish-assets` into `feature/billlearn-mvp`, review screenshots and branch size, then decide whether to merge as one UI polish batch or split docs assets from app UI changes.
