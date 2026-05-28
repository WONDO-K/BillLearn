# Figma Free Assets Inventory

Last updated: 2026-05-26

## Source

- Figma: https://www.figma.com/design/X4EdqDtwwZ6DXpFVL6s0d1/Crypto-Wallet-App-Template--Community-?node-id=101-833&t=GaCuGBDFhTbxMbBv-0
- Local path: `docs/assets/figma-free-assets`

## Files

| File | Size | Current decision | Reason |
| --- | ---: | --- | --- |
| `Branding/Crypto Wallet App Template (Community).svg` | 345 KB | Reference only | Crypto wallet domain asset. Useful for gradient/card composition reference, not BillLearn brand asset. |
| `Component/Crypto Wallet App Template (Community).svg` | 208 KB | Reference only | Possible component spacing/icon style reference. Do not bundle directly until individual reusable elements are extracted and reviewed. |
| `Cover/Crypto Wallet App Template (Community).svg` | 6.6 MB | Do not bundle | Large cover artwork. Too heavy for app runtime asset and not product-specific. |
| `Gradient/Crypto Wallet App Template (Community) (1).svg` | 345 KB | Reference only | Can inform purple gradient treatment, but BillLearn should keep its own palette. |
| `Wireframes/Crypto Wallet App Template (Community) (1).svg` | 17.8 MB | Do not bundle | Very large wireframe export. Useful only as design reference. |
| `source-links.md.txt` | 127 B | Keep | Tracks source URL for attribution and later license review. |

## Adoption Rule

These files should stay under `docs/assets` as design references. Do not register the full SVG exports in `app/pubspec.yaml`.

If a specific visual element is useful, extract a small, app-specific asset first, then review:

- visual fit with BillLearn's white/purple identity
- file size and render cost
- license/attribution requirements
- whether the asset is generic enough to avoid crypto-wallet domain mismatch

## Useful Direction For BillLearn

- Purple gradient cards can influence the home summary card depth and glow.
- Rounded icon containers can influence empty states and review rows.
- Large crypto-specific illustrations, wallet cards, coin symbols, and crypto copy should not be used in the product.
