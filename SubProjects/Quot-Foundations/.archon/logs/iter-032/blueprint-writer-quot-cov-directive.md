# Blueprint-writer directive — QUOT coverage debt (slug: quot-cov)

Chapter: `blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file).

## Context

The iter-031 QUOT prover closed gap1 bridge C: it built FOUR new Lean declarations. One
(`overRestrictIso`) is already pinned by `lem:over_restrict_iso`. The other THREE have no blueprint
block (coverage debt — `lean_aux`/unmatched). Add a block for each. They are **project-bespoke**
infra (no external source) — omit `% SOURCE` lines; statement + short informal proof suffices. Do NOT
add `\leanok`. Place all three in/near the `OverRestrictBridge` section that already houses
`lem:over_restrict_iso` (grep its `\section`/surrounding labels).

## Blocks to add

1. **`def:over_restrict_equiv`** — `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}`
   - Statement: the step-3 module-category equivalence
     `SheafOfModules (X.ringCatSheaf.over U) ≌ U.toScheme.Modules`.
   - `\uses{def:overEquivalence_sheafCongr` (or the actual labels of the 6 over-site topological-layer
     blocks added iter-030 — grep for `overEquivalence`), `lem:pushforwardPushforwardEquivalence_mathlib`
     if such an anchor exists (else cite the section narrative)`}.
   - Proof: apply `SheafOfModules.pushforwardPushforwardEquivalence` to the site equivalence
     `Opens.overEquivalence U`, with the two ring-sheaf comparison morphisms = the whiskered unit of the
     site equivalence and the identity (legal because the geometric ring sheaf is DEFINITIONALLY the
     transport of the sliced one — step 2 holds by `rfl`); orient via `.symm`.

2. **`lem:over_restrict_functor_iso`** — `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}`
   - Statement: the functor-level identification
     `(SheafOfModules.pushforward (𝟙 _)) ⋙ (overRestrictEquiv U).functor ≅ restrictFunctor U.ι`
     (equivalently `(over · U) ⋙ overRestrictEquiv.functor ≅ restrictFunctor U.ι`).
   - `\uses{def:over_restrict_equiv}` (+ the Mathlib anchors `pushforwardComp`/`pushforwardCongr` if
     anchored, else narrative).
   - Proof: both sides are `SheafOfModules.pushforward` along the SAME opens functor
     (`eqv.inverse ⋙ Over.forget U = U.ι.opensFunctor`, by `rfl`); identify via `pushforwardComp ≪≫
     pushforwardCongr` of the ring-morphism equality (closed by `cat_disch`).

3. **`lem:over_restrict_pullback_iso`** — `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}`
   - Statement: the pullback form
     `(overRestrictEquiv U).functor.obj (M.over U) ≅ (Scheme.Modules.pullback U.ι).obj M`.
   - `\uses{lem:over_restrict_iso, lem:modules_pullback_mathlib}` (and the `restrictFunctorIsoPullback`
     Mathlib anchor if one exists).
   - Proof: compose `overRestrictIso U M` with `(restrictFunctorIsoPullback U.ι).app M`.
   - NOTE in prose that this is the form consumed by the P1 transport
     `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`.

## Secondary task — verify the P1 block is dispatch-ready

`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (the P1 node, pin
`AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen` — a BUILD target, does not yet
exist) is the next prover objective. Its proof sketch is already detailed. Do TWO checks (report only;
fix only if trivially within this chapter):
- Confirm every label in its `\uses{}` resolves to an existing block in this chapter
  (`lem:presentation_map_mathlib`, `lem:quasicoherentData_bind_mathlib`, `lem:modules_pullback_mathlib`,
  `lem:isIso_fromTildeΓ_of_presentation_mathlib`, `lem:isLocalization_basicOpen_mathlib`,
  `lem:exists_finite_basicOpen_cover_le_quasicoherentData`). Report any missing.
- Add `lem:over_restrict_pullback_iso` to its `\uses{}` (the P1 transport consumes the pullback form,
  per the iter-031 prover handoff) if not already present.

## Out of scope
- Do NOT edit `lem:over_restrict_iso`, `lem:section_localization_descent` (D keystone), or any of the
  Mathlib-anchor blocks beyond adding the one `\uses` edge above.
- Do NOT touch the 4 protected stubs or SNAP/annihilator blocks.

Report any label you had to invent and any P1 `\uses` label that does not resolve.
