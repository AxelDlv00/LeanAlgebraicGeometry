# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary

- **Declarations added (4, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `W_of_isIso_sheafification` (private helper, ~L1361) — the converse of
    `isIso_sheafification_map_of_W`: a sheafified iso lies in `J.W`. Read off the same
    morphism-property identity `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`.
  - `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (~L1395) — **the D2' δ-wrapping**:
    `IsIso (a_Y.map (η (pullback φ'))) → IsIso (a_Y.map (δ (pullback φ') 𝒪.val 𝒪.val))`.
  - `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (~L1436) — **D2' assembly**: chains
    the δ-wrapping into the reduction brick to get
    `IsIso (a_Y.map (η …)) → IsIso (pullbackTensorMap f 𝒪 𝒪)`.
  - `sheafifyUnitIso` (~L1475) — the counit iso `a_Y.obj 𝟙_ ≅ 𝒪_Y`, the right vertical of the
    remaining η-bridge square (reusable building block).
- **Declarations blocked (0 sorry pins added):** the η-bridge `IsIso (a_Y.map (η (pullback φ')))`
  itself is NOT added (would need a sorry) — left absent; reduced to a precise residual (below).
- **Sorry count across file: 2 → 2** (unchanged; the two deferred sorries `exists_tensorObj_inverse`
  L674 and `addCommGroup_via_tensorObj` L1512 were NOT touched, per guardrails). No new sorry pins.
- Build: `lean_diagnostic_messages` shows **0 errors**; only pre-existing deprecation/long-line
  warnings + the 2 deferred-sorry warnings.

## What landed and why it matters

The planner framed D2' as: (a) apply the reduction brick, (b) use `left_unitality_hom` to reduce
`δ 𝟙_ 𝟙_` to the η-bridge, then (c) prove the η-bridge (the sheafification-mate identification).
**This iter landed (a)+(b) fully axiom-clean** as `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`
+ `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`. The verified `(SheafOfModules.unit _).val
= 𝟙_` `rfl` (lean-auditor ts245 flag) is confirmed. The genuinely-new whiskering step
`a_Y.map (η F ▷ F.obj 𝟙_)` iso-from-`a_Y.map (η F)`-iso is handled by the new converse
`W_of_isIso_sheafification` + the flatness-free `W_whiskerRight_of_W` + `isIso_sheafification_map_of_W`
(no flatness, no stalkwise δ — guardrail-compliant).

## η-bridge (D2' remaining content) — RESOLVED to a precise residual (NOT YET BUILT)

Target: `IsIso (a_Y.map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))`.
It is the commuting square (`sheafifyUnitIso` is the right vertical, built this iter):

```
a_Y.map (η F) ≫ sheafifyUnitIso.hom
  = (pullbackValIso f 𝒪_X).hom ≫ SheafOfModules.pullbackObjUnitToUnit φ
```

Since `pullbackValIso`, `sheafifyUnitIso`, and `pullbackObjUnitToUnit φ` (= `pullbackUnitIso`, iso)
are all isos, the square ⟹ `IsIso (a_Y.map (η F))`.

**Transpose (verified to typecheck, reaches a concrete goal):** compose `pullbackValIso.inv` on the
left, then `apply (SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv _ _ |>.injective`;
`rw [pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit, Adjunction.homEquiv_unit,
Adjunction.leftAdjointOplaxMonoidal_η, Adjunction.homEquiv_counit]`. This leaves the **single
concrete sheafification-mate identity** (pushforward-side):

```
sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map (
    (pullbackValIso f 𝒪_X).inv ≫
    a_Y.map (pullback_pre.map ε_pre ≫ presheafAdj.counit.app 𝟙_) ≫
    sheafifyUnitIso.hom)
  = unitToPushforwardObjUnit φ
```

where `ε_pre = Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ.hom)`,
`presheafAdj = PresheafOfModules.pullbackPushforwardAdjunction φ.hom`,
`sheafAdj = SheafOfModules.pullbackPushforwardAdjunction φ`.

**Glue available for the next step (all confirmed in Mathlib):**
- `Adjunction.homEquiv_leftAdjointUniq_hom_app`, `Adjunction.unit_leftAdjointUniq_hom_app`,
  `Adjunction.leftAdjointUniq_hom_app_counit` — `pullbackValIso` is built from
  `SheafOfModules.sheafificationCompPullback` = `Adjunction.leftAdjointUniq` of two composite
  adjunctions; these relate its components to the presheaf/sheaf adjunction units/counits.
- `Functor.LaxMonoidal.ε (SheafOfModules.pushforward φ) = SheafOfModules.unitToPushforwardObjUnit φ`
  by `rfl` (verified). The presheaf analog `ε_pre` is the sectionwise structure-ring map.

This is the **unit-side analog of the proven `pullbackObjUnitToUnit_comp` (L904)** but crosses the
presheaf↔sheaf boundary (the extra `leftAdjointUniq` of `sheafificationCompPullback`). It is a
self-contained ~60–120 LOC mate chase; estimated next iter.

## `W_of_isIso_sheafification` (RESOLVED — axiom-clean)
- **Approach:** `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` is an EQUALITY of morphism
  properties (sheafification IS the localization at `J.W.inverseImage toPresheaf`); read it backwards
  to turn `IsIso (sheafification.map f)` into `J.W (toPresheaf.map f)`.

## `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (RESOLVED — axiom-clean)
- **Approach:** `left_unitality_hom F 𝟙_` gives
  `δ F 𝟙_ 𝟙_ ≫ (η F ▷ F.obj 𝟙_) ≫ (λ_).hom = F.map (λ_).hom`; sheafify; the unitor + `F.map (λ_)`
  factors are isos; the whiskered η factor is iso via `W_of_isIso_sheafification` →
  `W_whiskerRight_of_W` → `isIso_sheafification_map_of_W`; cancel.
- **Gotchas:** must `letI φ'` with the explicit `(X.presheaf ⋙ forget₂ …) ⟶ …` type to pin the keyed
  monoidal-category instances (else `MonoidalCategoryStruct (PresheafOfModules X.ringCatSheaf.obj)`
  fails / whnf-times-out); `change` (not `show`, linter) the unit-object to `𝟙_`; identifier `hIsoλ`
  fails the parser (`λ`), use `hIsoLam`. State the conclusion with `(unit X).val` (matches the
  reduction-brick hypothesis form exactly), interchangeable with `𝟙_` by `rfl`.

## η-bridge (NOT ADDED)
- **Approach 1:** full automation (`simp` with `pullbackValIso`/`sheafifyUnitIso`/adjunction lemmas)
  on the transposed residual — does NOT close (the deep two-level `leftAdjointUniq` chase).
- **Approach 2 (next step):** manual mate chase on the concrete residual above using the
  `leftAdjointUniq_hom_app*` glue. Not attempted to completion (≥60 LOC; out of session budget).
- **Informal agent:** not consulted — the obstruction is Mathlib-API mate calculus, not a math gap
  (the informal agent is not a Lean-API tool; memory `informal-agent-key-invalid` also flags 401).

## Secondary (stale comments) — DONE
- Updated the L100 sub-module-layout note (4 imported files incl. `StalkTensor`; the Vestigial
  route-(e) sorry was CLOSED iter-237).
- Rewrote the Phase-2 status comment (was "iso-ness requires the concrete model") → SUPERSEDED by the
  loc-triv chart-chase; no concrete inverse-image model is built for line bundles.
- Rewrote the `PullbackLanDecomposition` header (was "committed general build") → D1 is OFF-PATH but
  retained axiom-clean; do not extend toward the abandoned general route.
- Rewrote the D2'-onward handoff note to reflect the landed δ-wrapping + the precise η-bridge residual.

## Blueprint markers (for review agent)
- `lem:pullback_tensor_iso_unit` is now PARTIALLY realized: the δ-wrapping + assembly
  (`isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`) are axiom-clean; the η-bridge hypothesis
  remains. Suggest a `\lean{}` pin on `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` and a
  `% NOTE:` that the η-bridge is the residual. (Review/sync owns `\leanok`.)

## Why I stopped
**Partial progress — strong.** 4 axiom-clean declarations added (named above with line numbers): the
entire D2' δ-wrapping + assembly machinery the planner specified, plus the converse W-lemma and the
η-bridge codomain iso. The single remaining blocker is the η-bridge square, which I REDUCED (not just
described) to a precise concrete transposed residual with the exact Mathlib glue lemmas identified —
the unit-side analog of `pullbackObjUnitToUnit_comp` crossing the sheafification boundary. This is the
iter-247 CONVERGING diagnostic the progress-critic ts246 asked for: a named D2' brick DID land (the
δ-wrapping), and the residual is a concrete mate chase, NOT a new Mathlib-absent blocker.
