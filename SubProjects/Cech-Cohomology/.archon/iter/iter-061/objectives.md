# Iter-061 objectives (2 prover lanes, both mathlib-build, both HARD-GATE CLEAR)

## Lane 1 — `CechSectionIdentification.lean` (CSI Stub 2 chain)
Build the effort-broken disjoint-union chain bottom-up to close Stub 2 `pushPull_sigma_iso` (line ~657):
- L1 `isIso_modules_of_toPresheaf` — reflection wrapper (small/ready first leaf).
- L2 `pushPull_binary_coprod_prod` — binary disjoint-union base (substantive; re-break candidate if stalls).
- `pushPull_coprod_prod` — finite-index induction.
- `pushPull_sigma_iso` — specialize to backbone `Y_p = ∐_σ U_σ`.
Blueprint: `lem:isIso_modules_of_toPresheaf`, `lem:pushPull_binary_coprod_prod`, `lem:pushPull_coprod_prod`,
`lem:pushPull_sigma_iso` (all effort-broken/verified iter-061). Mathlib anchors verified.

## Lane 2 — `OpenImmersionPushforward.lean` (Need#1 `hqc`)
Build to discharge `case hqc` (line ~532):
- `pushforward_commutes_restriction` — comparison iso (from `pushforwardPushforwardEquivalence`).
- cover-transport helper — `CoversTop (φ.inv⁻¹ U_i)` from `CoversTop U_i`.
- `pushforward_iso_preserves_qcoh` — `of_coversTop` template (copy `QuasicoherentData.bind`, swap to
  `Over.iteratedSliceEquiv`).
Then if `_acyclic` closes, attempt `_comp` (line ~598) + EnoughInjectives connector.
Blueprint: `lem:pushforward_commutes_restriction`, `lem:pushforward_iso_preserves_qcoh` (gate CLEAR).
Recipe: `analogies/pushforward-commutes-restriction.md` (mathlib-analogist iter-061, PROCEED).

## Not lanes this iter
- `CechAugmentedResolution.lean` (hSec) — consumes CSI Stubs 5/6 (post-Stub-2).
- CSI Stubs 4/5/6 — downstream of Stub 2 (Stub 6 has the degree-0 augmentation blocker).
- All DONE files; frozen P5b; dead `CechAcyclic.affine`.
