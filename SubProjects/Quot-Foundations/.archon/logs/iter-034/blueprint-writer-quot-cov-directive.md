# Directive — blueprint-writer `quot-cov` (iter-034)

## Chapter to edit
`blueprint/src/chapters/Picard_QuotScheme.tex` ONLY.

## Task
Add **three coverage blocks** for prover-created helper declarations that currently have NO blueprint
entry (they are isolated `lean_aux` nodes corrupting the dependency graph). These are project-bespoke
infrastructure lemmas of the **gap1-C / P1** spine — no external source, so OMIT `% SOURCE` lines; the
blocks stand on their statement + one-paragraph informal proof. Each must carry `\label{}`, `\lean{}`,
and an **accurate** `\uses{}` reflecting the real Lean dependencies (given below).

Insert all three **immediately before** the line `% --- (P1) Per-element local-tilde transport ---`
(just before `\label{lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent}`), i.e. they are the
slice→geometric Presentation-transport machinery feeding the P1 keystone. After inserting, add the
first two as `\uses{}` of the P1 keystone proof block
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (append `def:over_restrict_presentation,
def:presentation_pullback_iota_of_quasicoherentData` to its existing `\uses{}` set — do NOT remove any
existing entry).

### Block 1 — `def:over_restrict_unit_iso`
- `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso}`
- `\uses{def:over_restrict_equiv}`
- Statement: for an open `U ⊆ X`, the step-3 slice equivalence functor `(overRestrictEquiv U).functor`
  sends the unit (structure-sheaf) module of the over-site `X.ringCatSheaf.over U` to the unit module of
  `U.toScheme.ringCatSheaf`:
  `(overRestrictEquiv U).functor.obj (unit (X.ringCatSheaf.over U)) ≅ unit U.toScheme.ringCatSheaf`.
- Proof (informal): the equivalence's functor is, by construction, `SheafOfModules.pushforward ψ₀` along
  the over-site/open-site comparison, where `ψ₀` is the identity ring comparison `homMk (𝟙 _)`. The
  canonical `unitToPushforwardObjUnit ψ₀ : unit S ⟶ (pushforward ψ₀).obj (unit R)` is an isomorphism
  whenever the ring comparison `ψ₀` is (a private helper
  `isIso_unitToPushforwardObjUnit_of_isIso'` supplies this: reflect through `toSheaf`/`sheafToPresheaf`,
  the component over each `V` is the functor-image of `ψ₀.app V`, hence iso); here `ψ₀ = homMk (𝟙)` is
  the identity, so the unit comparison is an iso, and its inverse is the asserted isomorphism. (Mathlib's
  `unitToPushforwardObjUnit`-iso requires an `F.Final` hypothesis; this `IsIso ψ`-driven form is the one
  the slice equivalence needs.)

### Block 2 — `def:over_restrict_presentation`
- `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPresentation}`
- `\uses{def:over_restrict_unit_iso, lem:over_restrict_pullback_iso, lem:presentation_map_mathlib}`
- Statement: transport of a slice presentation to a geometric one — for `U ⊆ X` and `M` on `X`, a
  presentation of the slice restriction `(M.over U)` yields a presentation of the geometric pullback
  `((pullback U.ι).obj M)`: `(M.over U).Presentation → ((pullback U.ι).obj M).Presentation`.
- Proof (informal): apply `SheafOfModules.Presentation.map` along the slice equivalence functor
  `(overRestrictEquiv U).functor`, using `def:over_restrict_unit_iso` to transport the structure-sheaf
  module, landing a presentation of the transported slice module; then transport across the pullback
  packaging isomorphism `lem:over_restrict_pullback_iso`
  (`(overRestrictEquiv U).functor.obj (M.over U) ≅ (U.ι)^* M`) via `Presentation.ofIsIso`.

### Block 3 — `def:presentation_pullback_iota_of_quasicoherentData`
- `\lean{AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData}`
- `\uses{def:over_restrict_presentation, lem:quasicoherentData_bind_mathlib}`
- Statement: from quasi-coherence data, the per-cover-member geometric presentation — for `M : X.Modules`,
  `q : M.QuasicoherentData`, and a cover index `i`, a presentation of the geometric pullback of `M` to the
  open subscheme `(q.X i)`: `((pullback (q.X i).ι).obj M).Presentation`.
- Proof (informal): the datum `q` provides a slice presentation `q.presentation i : (M.over (q.X i)).Presentation`;
  feed it to `def:over_restrict_presentation` at `U = q.X i`.

## Out of scope
Do NOT touch the P1 keystone STATEMENT or its proof prose (it is complete and gate-cleared); only append
to its `\uses{}`. Do NOT add `\leanok` (the deterministic sync owns it). Do NOT edit any other chapter.
The private helper `isIso_unitToPushforwardObjUnit_of_isIso'` is an implementation detail (private Lean
decl, `\lean{}` pin would not resolve) — do NOT give it its own block; mention it only inside Block 1's
prose as above.

## References
No new reference needed (project-bespoke). `references/**` authorized only as a safety valve.
