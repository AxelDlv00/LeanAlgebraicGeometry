# Blueprint-writer directive — CREATE Picard_GlueDescent.tex (iter-077)

Target: NEW file `blueprint/src/chapters/Picard_GlueDescent.tex` (1:1 slug for
`AlgebraicJacobian/Picard/GlueDescent.lean`, which the iter-067 file-split created with NO chapter).
GlueDescent.lean has 2 open sorries (L1170 inner, L1207 keystone) and zero blueprint coverage; a
prover cannot be dispatched without this chapter.

Action: author the chapter with these declaration blocks IN DEPENDENCY ORDER (names = the real Lean
`\lean{}` pins; read the Lean docstrings at the cited lines for the intended proof shape):

1. `\definition{def:gr_glue_equalizer}` `\lean{AlgebraicGeometry.Scheme.Modules.glueProd}` — the
   equalizer-of-pushforwards object `glueProd ⇉ glueOverlapProd`.
2. `\lemma{lem:glueOverlapBaseChangeIso}` `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso}`
   (GlueDescent.lean L1148) — base-change iso β_ij: `ι_i^* (ι_j)_* M_j ≅ f_{ij}^* M_j` on overlaps.
   The inner sorry (L1170, inside `glueRestrictEqualizerIso`) bridges the equalizer structure to the
   pullback. \uses{lem:modules_restrictFunctorIsoPullback_mathlib}.
3. `\lemma{lem:glueRestrictionHom}` `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom}`
   (L1042) — restriction hom `ι_i^* (glue D M g) ⟶ M i` via the equalizer projection.
   \uses{def:gr_glue_equalizer, def:scheme_modules_glue}.
4. `\theorem{thm:isIso_glueRestrictionHom}` `\lean{AlgebraicGeometry.Scheme.Modules.isIso_glueRestrictionHom}`
   (sorry L1207) — EFFECTIVE DESCENT: `glueRestrictionHom` is an iso.
   \uses{lem:glueRestrictionHom, lem:glueOverlapBaseChangeIso, lem:isLimitPullbackCone_mathlib, lem:eq_of_locally_eq_mathlib}.
5. `\definition{def:glueRestrictionIso}` `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}`
   (L1214) — packaged iso form. \uses{thm:isIso_glueRestrictionHom}.

Main proof strategy (expand to textbook prose): `glue D M g` is the equalizer
`eq(glueLegA, glueLegB)` in `D.glued.Modules`; `glueRestrictionHom i` extracts the i-th component
via `glueProj`. `ι_i^*` is an equivalence on the open `U_i`; the equalizer restricted to a chart
recovers `M_i` because the overlap factors `ι_i^* (ι_j)_* M_j` are identified with `f_{ij}^* M_j`
via `glueOverlapBaseChangeIso`. Close via the sheaf equalizer / `isLimitPullbackCone_mathlib` +
`eq_of_locally_eq_mathlib`.

Mathlibok anchors: you MAY mark `\mathlibok` ONLY on the genuine Mathlib-backed anchor blocks
(`lem:modules_restrictFunctorIsoPullback_mathlib`, `lem:isLimitPullbackCone_mathlib`,
`lem:eq_of_locally_eq_mathlib`) — author each as a short anchor block stating the Mathlib result in
project notation with its real Mathlib `\lean{}`. Do NOT mark `\leanok` on anything (sync owns it).

References: read `AlgebraicJacobian/Picard/GlueDescent.lean` docstrings (L899, L1148, L1191);
`Picard_GrassmannianQuot.tex` `def:scheme_modules_glue` (the equalizer construction this extends).
Constraints: this chapter only; do NOT edit other chapters or content.tex (the planner wires the \input).
