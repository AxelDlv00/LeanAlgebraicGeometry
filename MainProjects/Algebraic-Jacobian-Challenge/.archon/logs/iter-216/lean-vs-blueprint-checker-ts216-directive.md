# lean-vs-blueprint-checker directive — iter-216

## The one Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Its blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter (for your bidirectional check)
The prover added 6 new declarations in the `RestrictScalarsRingIsoTensor` section
(`restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`,
`restrictScalarsRingIsoTensorEquiv_apply_tmul`, and `_of_bijective` companions). These
are the "H2 ModuleCat strong-monoidal core" of `lem:tensorobj_restrict_iso`.
No `sorry` was closed; the chapter's blueprint was rewritten this iter (pivot to a
direct-gluing associator + free-cover make-or-break for `lem:tensorobj_restrict_iso`).

## Report (bidirectional)
1. Lean → blueprint: do the 6 new Lean decls have corresponding blueprint blocks /
   `\lean{...}` hints, or are they unmentioned infrastructure? Are any blueprint
   statements fake/placeholder vs the Lean?
2. Blueprint → Lean: is the chapter detailed enough to guide the still-open
   `lem:tensorobj_restrict_iso` (H1 presheaf pushforward adjunction) and
   `lem:tensorobj_assoc_iso` (direct gluing)? Does the prover's make-or-break finding
   ("free-cover does NOT avoid H1; H1 is on the critical path via the arbitrary-module
   consumer `tensorObj_isLocallyTrivial`") contradict the chapter's free-cover claim?
   If so, flag the chapter as needing a writer correction.
Report any must-fix-this-iter items explicitly.
