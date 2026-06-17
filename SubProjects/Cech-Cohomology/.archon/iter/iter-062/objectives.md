# Iter-062 objectives (detail)

## Lane 1 — `CechSectionIdentification.lean` (mathlib-build) — Stub 2 via L2
- Start at **L2 `pushPull_binary_coprod_prod`** (L1 + helpers done iter-061). Use the blueprinted `% NOTE`
  fix verbatim (do NOT repeat iter-061's dead end):
  - Reflect via `isIso_modules_of_toPresheaf`, but check the iso on `SheafOfModules.evaluation V` (NOT
    `toPresheaf ⋙ evaluation` — no `PreservesLimitsOfShape` instance), reduce via
    `Scheme.Modules.Hom.isIso_iff_isIso_app`.
  - `q⁻¹(V)` = disjoint union of `inl/inr` traces ⟹ `coprodPresheafObjIso` + `isProductOfDisjoint` give the
    Ab-limit; reflect to ModuleCat via `isLimitOfReflects (forget₂ (ModuleCat R) Ab)`; close with
    `isIso_prodLift_of_isLimit`. Cone legs ↔ `restrictAdjunction_unit_app_app` (rfl); `⊥`/sup ↔ `h₂`/`h₁`
    fields of `coprodPresheafObjIso`. Comparison map = `coprodDecompMap`.
- Then `pushPull_coprod_prod` (finite-index induction; `∐_{Option ι}` reassociation) → `pushPull_sigma_iso`
  (Stub 2, line ~729; specialize to `Y_p = ∐_σ U_σ` via the done `cechBackbone_left_sigma`).
- WATCH: progress-critic — if Stub 2 doesn't close (sorry stays 4), Route A reverts to CHURNING.

## Lane 2 — `OpenImmersionPushforward.lean` (mathlib-build) — `hqc` via the `pullback ψ_r` chain
- **(1) `slice_structureSheaf_hom`** — the genuine wall: continuous opens-equivalence `F` (`Uᵢ`-site vs
  `Vᵢ = φ.inv⁻¹ᵁ Uᵢ`-site, `[F.IsContinuous]`, `[F.Final]`) + `ψ_r : 𝒪_{Uᵢ} ⟶
  (F.sheafPushforwardContinuous RingCat _ _).obj 𝒪_{Vᵢ}` (`Sheaf _ RingCat`), `[(pushforward ψ_r).IsRightAdjoint]`.
  Restrict `φ.hom`'s structure-sheaf comparison to the over-category via `Over.post_forget_eq_forget_comp`
  (rfl) modulo the `postEquiv.inverse` adjustment. The instance discharge is the hard part.
- **(2) `pushforward_slice_pullback_iso`** — `(pullback ψ_r).obj (H.over Uᵢ) ≅ (Φ H).over Vᵢ` via
  `pullbackObjUnitToUnit ψ_r` (iso by `F.Final`) + `F.obj Uᵢ = Vᵢ` (rfl on the opens).
- **(3) `pushforward_iso_preserves_qcoh`** — transport each presentation `pᵢ` via `(pullback ψ_r).Presentation.map`
  (colimit-preserving, left adjoint) + (2) `Presentation.ofIsIso` → per-slice qcoh →
  `pushforward_iso_qcoh_of_slice_qcoh`. Then `case hqc => exact …` (line ~588).
- Do NOT build the `pushforwardPushforwardEquivalence` quadruple (superseded). If (1) stalls on instances,
  hand off the precise residual (do NOT brute-force).

## Out of scope this iter
- CSI Stubs 4/5/6; `CechAugmentedResolution` hSec; P5b (line-780); EnoughInjectives connector (owed at the
  `_comp` seam once `hqc` lands); dead `CechAcyclic.affine` deletion (refactor cleanup).
