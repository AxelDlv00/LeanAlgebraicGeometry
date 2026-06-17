# Blueprint-writer directive — QUOT coverage debt (iter-035)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (covers `AlgebraicJacobian/Picard/QuotScheme.lean` and
`GradedHilbertSerre.lean`).

## Task
Six prover-created Lean declarations landed axiom-clean in iter-034 (the gap1 P1 keystone
`isIso_fromTildeΓ_restrict_basicOpen` and its slice-/iso-transport machinery) but have NO blueprint
block — they are isolated `lean_aux` nodes. Restore the 1-to-1 Lean↔blueprint correspondence: add ONE
block per declaration with `\label{}`, `\lean{<exact name>}`, accurate `\uses{}`, and a one-line informal
proof. These are project-bespoke `Scheme.Modules` infrastructure — no external SOURCE QUOTE needed (the
math is Mathlib presentation/pullback bookkeeping); a short internal justification suffices.

Place them in the gap1 section near `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (the P1 keystone
block, which already exists and is their consumer).

## The six declarations (exact Lean names — all in namespace `AlgebraicGeometry.Scheme.Modules`)
1. `presentationPullbackιRestrict` — a presentation of `(W.ι^* (q.X i).ι^* M)` for any open
   `W ⊆ (q.X i).toScheme`. `\uses` the existing `lem:presentationPullbackιOfQuasicoherentData` (or its
   label), `lem:over_restrict_presentation` (`overRestrictPresentation`), and the Mathlib
   `SheafOfModules.Presentation.map` anchor.
2. `opensMapEquivOfIso` — for a scheme iso `φ`, `Opens.map φ.inv.base` is an equivalence of opens sites.
   `\uses` Mathlib `Opens.mapComp`/`Opens.mapId`/`Opens.mapIso`, `Scheme.Hom.comp_base`. One-line:
   `φ.inv.base` is a homeomorphism so its opens map is an equivalence.
3. `opensMap_final_of_schemeIso` — that opens functor is `Final`. `\uses{}` block (2). One-line: an
   equivalence of categories is final.
4. `pullbackSchemeIsoUnitIso` — pullback along a scheme iso sends `unit` to `unit`
   (`IsIso (pullbackObjUnitToUnit φ.inv.toRingCatSheafHom)`). `\uses` blocks (2),(3) + Mathlib
   `SheafOfModules.pullbackObjUnitToUnit`.
5. `presentationPullbackOfSchemeIso` — transport a presentation across pullback by a scheme iso (the
   affine-identification step). `\uses` block (4) + Mathlib `Presentation.map` along `pullback` and
   `leftAdjoint_preservesColimits`.
6. `isIso_fromTildeΓ_presentationPullback` — **general keystone**: `M` restricts to a tilde on EVERY
   affine open `W` of a cover member `q.X i`. `\uses` blocks (1),(5) + the existing
   `lem:isIso_fromTildeΓ_of_presentation` and Mathlib `IsAffineOpen.isoSpec`. NOTE in the block that this
   is STRICTLY MORE GENERAL than the pinned basic-open keystone `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`
   and is the form the gap1 descent (D, `lem:section_localization_descent`) should consume per affine
   cover member.

Then wire `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`'s `\uses` to include
`isIso_fromTildeΓ_presentationPullback`'s new label (it is the general lemma the basic-open case instantiates).

## Constraints
- Do NOT add `\leanok`.
- Do NOT touch any other chapter.
- Grep the chapter to confirm the exact labels of the existing blocks you `\uses`
  (`lem:isIso_fromTildeΓ_of_presentation`, `lem:over_restrict_presentation`,
  `lem:presentationPullbackιOfQuasicoherentData`, `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`)
  before wiring; if a label differs, use the actual one. Add a `% NOTE:` if a needed label is absent
  rather than inventing one.
- Keep blocks tight; the `\uses` edges are the goal.
