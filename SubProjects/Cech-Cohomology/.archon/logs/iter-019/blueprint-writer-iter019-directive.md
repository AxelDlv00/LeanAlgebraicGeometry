# Blueprint-writer directive — iter-019

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter).

Four edits. Do ONLY these; do not touch other blocks' mathematical content. Do NOT add `\leanok`
anywhere (it is managed deterministically elsewhere).

You may READ these prover task-result files for the precise helper roles (they each have a
"## Needs blueprint entry" section): `.archon/task_results/CechAcyclic.md`,
`.archon/task_results/CechBridge.md`, `.archon/task_results/FreePresheafComplex.md`,
`.archon/task_results/HigherDirectImagePresheaf.md`.

---

## Edit 1 — Re-sign `lem:higher_direct_image_presheaf` to the resolution form (P5a)

At `\label{lem:higher_direct_image_presheaf}` (≈ line 1745):

- Change the `\lean{}` pin from `AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology`
  to **`AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology`** (the decl that was
  actually built, axiom-clean, iter-018).
- **Delete** the stale `% NOTE (review iter-018): ... PLANNER DECISION PENDING ...` comment block
  (the decision is now MADE — option 1, the resolution form).
- Rewrite the **statement prose** to the resolution form actually proved: choosing an injective
  resolution `G → I^•` in `X.Modules`, the higher direct image `Rⁿf_*G = (f_*).rightDerived n (G)`
  is isomorphic to the **sheafification of the presheaf of objectwise homology** of the pushed
  complex `f_* I^•`, i.e. `Rⁿf_*G ≅ sheafify(V ↦ Hⁿ((f_*I^•)(V)))`. Keep, as a closing remark, the
  affine-local vanishing corollary (Rⁿf_*G vanishes iff that presheaf-homology vanishes on a basis
  of opens, e.g. the affines) — this is the form the downstream consumers
  (`lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`) consume. Note honestly
  in the prose that the last-mile identification `Hⁿ((f_*I^•)(V)) = Hⁿ(f⁻¹V, G)` with absolute
  cohomology of the preimage is supplied at point-of-use (it needs the restricted resolution to be
  acyclic over `f⁻¹V`) and is not part of this lemma's Lean content.
- Keep the existing `% SOURCE` / `% SOURCE QUOTE` (Stacks 01XJ, `lemma-describe-higher-direct-images`)
  and the visible `\textit{Source: ...}` line — this is the same theorem, stated in its
  resolution-internal form.
- Update `\uses{}` to `\uses{def:higher_direct_image, def:cohomology_sheaf_is_sheafify_homology}`
  (the new engine block from Edit 2).
- The proof block below it already argues the sheafify-of-objectwise-homology route; align its prose
  to reference the engine block and `pushforwardResolutionPresheafComplex`; no `\delta`-functor.

## Edit 2 — Add the reusable 01XJ engine block (NEW)

Insert, immediately BEFORE `lem:higher_direct_image_presheaf`, a new lemma/definition pair capturing
the reusable engine the iter-018 prover built (see `HigherDirectImagePresheaf.md`):

- A `\begin{lemma}` with `\label{def:cohomology_sheaf_is_sheafify_homology}`,
  `\lean{PresheafOfModules.homologyIsoSheafify}`, stating: for a cochain complex `K` of presheaves of
  modules over a site with sheafification, the `i`-th homology of the sheafified complex is the
  sheafification of the `i`-th objectwise (presheaf-level) homology of `K` — because the
  sheafification/inclusion adjunction is exact (preserves the finite limits and colimits computing
  kernels and cokernels). One-line informal proof: sheafification is exact (left adjoint, plus
  preserves finite limits), hence commutes with taking homology; chase through
  `K.homology i ≅ (sheafify K).homology i ≅ sheafify(K.homology i)`. SOURCE: this is the engine
  underlying Stacks 01XJ (you may cite Tag 01XJ, `references/stacks-cohomology.tex`); if you want a
  cleaner verbatim anchor for "sheafification is exact", that is standard — a one-line informal proof
  with the 01XJ pointer suffices since the Lean decl is project-built, not a Mathlib re-export.
- Bundle into THIS block's `\lean{...}` list the supporting helpers:
  `PresheafOfModules.homologyIsoSheafify`, `PresheafOfModules.counitComplexIso`,
  `PresheafOfModules.sheafificationAdditive`, `CategoryTheory.Functor.mapHomologyIso'`.

## Edit 3 — Fix the broken `\uses{}` (blueprint-doctor finding)

Two occurrences of the raw Lean name `AlgebraicGeometry.CombinatorialCech.depDiff_exact` appear in
`\uses{}` lists (≈ lines 696 and 767). The actual declaration is in the `Dependent` namespace:
replace BOTH with **`AlgebraicGeometry.CombinatorialCech.Dependent.depDiff_exact`**.

## Edit 4 — Clear the 44-node coverage debt by bundling helpers into `\lean{...}` lists

Append each helper name below to the multi-name `\lean{...}` list of the indicated existing block
(create the comma-separated list if the block currently has a single `\lean{}`). These are
infrastructure helpers; bundling carries their dependency edges. Do not invent new statements — just
extend the `\lean{...}` lists.

**Into `lem:section_cech_homology_exact`** (the localisation algebra, 22):
`AlgebraicGeometry.AwayComparison.Inverts`, `AlgebraicGeometry.AwayComparison.Inverts.isUnit_powers`,
`AlgebraicGeometry.AwayComparison.Inverts.mul`, `AlgebraicGeometry.AwayComparison.Inverts.of_dvd`,
`AlgebraicGeometry.AwayComparison.comparison`, `AlgebraicGeometry.AwayComparison.comparison_apply`,
`AlgebraicGeometry.AwayComparison.comparison_comp`,
`AlgebraicGeometry.AwayComparison.comparison_comp_apply`,
`AlgebraicGeometry.AwayComparison.comparison_comp_structure`,
`AlgebraicGeometry.AwayComparison.comparison_self`, `AlgebraicGeometry.AwayComparison.comparison_unique`,
`AlgebraicGeometry.CechLocalized.cechCoeff`,
`AlgebraicGeometry.CechLocalized.cechCoeff_transport_eq_comparison`,
`AlgebraicGeometry.CechLocalized.cechCoface`, `AlgebraicGeometry.CechLocalized.cechLocalized_exact`,
`AlgebraicGeometry.CechLocalized.cechPrepend`, `AlgebraicGeometry.CechLocalized.cech_hcomm`,
`AlgebraicGeometry.CechLocalized.cech_hsh`, `AlgebraicGeometry.CechLocalized.cech_hu`,
`AlgebraicGeometry.CechLocalized.sprod`, `AlgebraicGeometry.CechLocalized.sprod_cons`,
`AlgebraicGeometry.CechLocalized.sprod_succAbove_dvd`.

**Into `def:cover_structure_presheaf`** (the O_𝒰 augmentation, 10):
`AlgebraicGeometry.cechFreeAug`, `AlgebraicGeometry.cechFreeComplexAug`,
`AlgebraicGeometry.cechFreeComplexAug_f_zero`, `AlgebraicGeometry.cechFreeSimplicial_δ_comp_aug`,
`AlgebraicGeometry.cechFree_d_comp_aug`, `AlgebraicGeometry.cechFree_d_comp_factorThruImage`,
`AlgebraicGeometry.freeYonedaAug`, `AlgebraicGeometry.freeYonedaAug_app_freeMk`,
`AlgebraicGeometry.freeYonedaHomEquiv_freeYonedaAug`, `AlgebraicGeometry.freeYoneda_map_comp_aug`.

**Into `lem:cech_complex_hom_identification`** (the bridge core, 6):
`AlgebraicGeometry.homCechComplex`, `AlgebraicGeometry.homCechCosimplicial`,
`AlgebraicGeometry.homCechSectionIsoApp`, `AlgebraicGeometry.homCechSectionIsoApp_hom_π`,
`AlgebraicGeometry.pi_mapIso_hom_eq`, `AlgebraicGeometry.freeYonedaHomAddEquiv_naturality`.

**Into `lem:higher_direct_image_presheaf`** (the remaining P5a helper, 1):
`AlgebraicGeometry.pushforwardResolutionPresheafComplex`.
(The other 5 P5a helpers go into the new engine block per Edit 2 — that accounts for all 44.)

---

After all edits, re-read the chapter once to confirm: every `\lean{...}` name above appears exactly
once across the chapter, the two `depDiff_exact` refs are fixed, and the P5a block names the
resolution-form decl. Report which blocks you edited.
