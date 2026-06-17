# Blueprint-reviewer directive — iter-056 whole-blueprint audit

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter checklist:
completeness, correctness, proof-sketch depth, well-formed `\lean{}` targets, accurate `\uses{}`, and
which chapters are ready to gate prover dispatch.

## Context for this iter (do not let it narrow your whole-blueprint view)
The two files about to receive prover work this iteration are:
- `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` — the NEW Sub-brick A chain
  (`lem:cech_backbone_left_sigma` … `lem:cechSection_contractible`), 6 stubs to be PROVEN this iter.
- `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` — `lem:open_immersion_pushforward_comp`
  and the `_acyclic` leaf.
Both are covered by the consolidated chapter `Cohomology_CechHigherDirectImage.tex`. Confirm whether
that chapter is `complete: true` AND `correct: true` for the Sub-brick A section and the
open-immersion-pushforward section, with NO must-fix-this-iter finding — this gates the prover dispatch.

## Specific things to check
1. **Sub-brick A chain** (`lem:cech_backbone_left_sigma`, `lem:pushPull_sigma_iso`,
   `lem:pushPull_leg_sections`, `lem:pushPull_eval_prod_iso`, `lem:cechSection_complex_iso`,
   `lem:cechSection_contractible`): are the statements + proof sketches detailed enough to formalize?
   Are the `\uses{}` sets accurate (in particular: `lem:cechSection_contractible`'s
   `\uses{lem:cech_acyclic_affine}` is ONLY the Lean home of the `Dependent` engine, NOT a math
   dependency — flag if this is misleading in the prose)?
2. **Open-immersion pushforward** (`lem:open_immersion_pushforward_comp` and its `_acyclic` half):
   the residual now needs (a) `coyoneda.rightDerived ≅ Ext^q` reindexing and (b) a **change-of-scheme
   Serre vanishing for a general affine open** of an affine scheme. Does the chapter blueprint (b) at
   all? If not, flag it as missing coverage that needs a writer this iter (this is the dominant blocker
   of that lane and currently has no informal proof).
3. **Coverage debt** — these prover-created helpers currently have NO blueprint entry (isolated nodes):
   `isZero_homology_of_iso_homotopy_id_zero`, `rightDerivedNatIso`, `sectionsFunctorCorepIso`,
   `sectionsFunctor_additive`, `toPresheafOfModules_additive`. Note in your report which chapter each
   belongs under so a writer can author the entries.

## Output
Your standard per-chapter checklist + the HARD-GATE verdict for the two target chapters/sections + any
`## Unstarted-phase blueprint proposals` (especially the change-of-scheme Serre vanishing, if missing).
