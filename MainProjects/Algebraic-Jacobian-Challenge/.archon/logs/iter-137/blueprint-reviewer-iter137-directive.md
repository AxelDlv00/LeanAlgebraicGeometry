# Blueprint Reviewer Directive

## Slug
iter137

## Context

This is the iter-137 mandatory plan-phase blueprint-reviewer dispatch.
The iter-137 prover lane will fire on
`AlgebraicJacobian/Cotangent/GrpObj.lean:480` —
`relativeDifferentialsPresheaf_basechange_along_proj_two` (piece (i.b)
Step 2, ~150–300 LOC NEEDS_MATHLIB_GAP_FILL, load-bearing). The
corresponding blueprint block is
`RigidityKbar.tex § lem:GrpObj_omega_basechange_proj` at L423–L481
(statement + proof). The iter-136 review-phase
`lean-vs-blueprint-checker-cotangent-grpobj-review136` flagged this
block as "adequate" with a detailed chain through
`KaehlerDifferential.tensorKaehlerEquiv` and `Algebra.IsPushout` for
the prover's iter-137+ attack.

Iter-136 plan-phase blueprint-reviewer returned HARD GATE CLEAR
(11 chapters audited; 1 must-fix-this-iter on a 2-character
case-fix in `AlgebraicJacobian_Cotangent_GrpObj.tex` L6 + L59,
RESOLVED via plan-agent direct edit; 3 informational items).

## What we ask of you

Apply your standard whole-blueprint audit (per dispatcher_notes: read
every chapter under `blueprint/src/chapters/`, no exceptions). Output
your per-chapter checklist and cross-cutting summaries to
`.archon/task_results/blueprint-reviewer-iter137.md`.

The HARD GATE per-file prover dispatch rule applies to this iter's
target:

- File: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- Math chapter: `blueprint/src/chapters/RigidityKbar.tex` (the
  authoritative source for piece (i.b) Step 2 = `lem:GrpObj_omega_basechange_proj`)
- Pointer chapter: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`

If both chapters return `complete: true` AND `correct: true` AND
no must-fix-this-iter finding names either, the HARD GATE is CLEAR
and the prover lane will fire. If either fails the gate, name the
must-fix in detail and the iter-137 plan agent will defer the prover
round + dispatch a blueprint-writer this iter to address.

Pay close attention to:

- **`RigidityKbar.tex § lem:GrpObj_omega_basechange_proj`** (L423–L481):
  is the proof sketch adequate for a prover to formalize the
  ~150–300 LOC NEEDS_MATHLIB_GAP_FILL? Are the named Mathlib
  lemmas (`KaehlerDifferential.tensorKaehlerEquiv`, `TopCat.Presheaf.pullback`,
  `PresheafOfModules.pullback`, `Algebra.IsPushout`) sufficient as
  hints, or is the prover going to have to invent intermediate
  decompositions the blueprint doesn't anticipate?

- **The `\notready` + iter-135 NOTE block** at L452–L463 on the same
  lemma: does it accurately frame the iter-137 prover lane target
  (sheaf-level RHS via `Scheme.Hom.toRingCatSheafHom`; ~150–300 LOC
  NEEDS_MATHLIB_GAP_FILL)?

- **Iter-136 carry-over informational items** (3):
  - `Jacobian.tex:400` stale citation `Jacobian.lean:120–126` (actual
    `134–140`) — iter-135 lean-vs-blueprint-checker MED-B carry-over.
  - `Cohomology_StructureSheafModuleK.tex` L358/L386/L440 label-prefix
    asymmetry — iter-135 + iter-136 reviewers left as-is per
    option (b) smaller-blast-radius.
  - `Jacobian.tex` C.2.d second-bullet prose thinness — iter-136
    reviewer informational, no semantic block.

  Confirm whether any of these should be promoted to must-fix this iter
  (iter-136 reviewer kept them informational; absent new evidence
  they should stay informational). Flag if any have absorbed new
  blast-radius from iter-136 review's `\leanok` marker churn.

- **Optional preventive MED-C from iter-136 review**: one-line
  `% NOTE` near `RigidityKbar.tex:490` distinguishing
  `schemeHomRingCompatibility` (project-internal,
  `pullbackPushforwardAdjunction` route used by
  `relativeDifferentialsPresheaf`) from `(Scheme.Hom.toRingCatSheafHom _).hom`
  (the `pullback`-functor route used by piece (i.b) iter-136 body).
  Flag if needed; iter-137 prover lane on Step 2 uses the
  `toRingCatSheafHom` route, so confusion between the two helpers is
  a live concern.

Render your usual report with per-chapter completeness/correctness
plus a HARD GATE verdict on `Cotangent/GrpObj.lean`.
