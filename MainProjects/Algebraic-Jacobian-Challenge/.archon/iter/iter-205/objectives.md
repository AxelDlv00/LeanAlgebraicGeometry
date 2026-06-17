# Iter-205 objectives (per-lane detail)

## Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

Mode: **mathlib-build**. Priority-1, sole productive Route A lane;
bottom-up spine TS → RPF → FGA → A.2.c.

**Mathematical content (reference-driven).** The category
`Scheme.Modules X` is the sheafification localization of
`PresheafOfModules R`. Mathlib supplies:
- `PresheafOfModules.sheafification.IsLocalization W` for
  `W := J.W.inverseImage (toPresheaf R)`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization`) [verified];
- `CategoryTheory.Localization.Monoidal.toMonoidalCategory` /
  `instMonoidalCategoryLocalizedMonoidal`
  (`Mathlib.CategoryTheory.Localization.Monoidal.Basic`) [verified] —
  yields `MonoidalCategory` on the localized category from
  `[L.IsLocalization W]` + `[W.IsMonoidal]` + a unit iso;
- `CategoryTheory.MorphismProperty.IsMonoidal` [verified].

**Single gap to build**: `MorphismProperty.IsMonoidal W` for the relative
`⊗_R` on `PresheafOfModules R`. The Sheaf-site `IsMonoidal` instances
(`Sites/Monoidal.lean`) are for the ambient/cartesian tensor on
`Sheaf J A`, NOT the relative module tensor — they do not apply.

**Ordered targets**: `IsMonoidal W` (axiom-clean) → `monoidalCategory`
(via the transport, drop the contamination-guard sorry only when fully
closed) → `tensorObj_restrict_iso` / `tensorObj_isLocallyTrivial`
(same transport supplies the strong-monoidal pullback) →
`exists_tensorObj_inverse` (Stacks 01CR dual + contraction) →
`addCommGroup_via_tensorObj`.

**Dead-ends (iter-204)**: `Scheme.Hom.resLE` not `homOfLE` for
unit-pullback chart-chases; pass `IsIso` explicitly to `@asIso`;
ascribe to `AddCommGrpCat` (not deprecated `AddCommGrp`).

**HARD BAR (mathlib-build invariant)**: `IsMonoidal W` axiom-clean OR a
precise axiom-clean decomposition of the obstruction — no sorry in output.

## Held / paused (no dispatch)

- COE — PAUSED pending USER escalation (Stacks 02JK Step A2).
- RPF / FGA — held (re-open post TS `addCommGroup_via_tensorObj`).
- WD terminal — USER-blocked sig strengthening.
- T32 — gated on COE L1262.
- Route C (RR chain), Lane RCI — USER-paused.
