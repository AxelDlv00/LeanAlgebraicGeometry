# lean-vs-blueprint-checker directive — iter-249

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (for your orientation only — verify independently)

The prover added real proof code to the lemma `pullbackEtaUnitSquare` (the D2′ "unit square"),
assembling a mate-calculus telescope that now bottoms out in ONE remaining `sorry` — a concrete
presheaf-level identity labelled `(∗∗)`. The blueprint's step-7 block for this lemma was retyped
to the `.val` level (sheaf-level `Functor.LaxMonoidal.ε` removed) and a `rfl`-linchpin block
(`sheafificationCompPullback_eq_leftAdjointUniq`) was added in a prior plan phase.

## Report bidirectionally

(a) **Lean → blueprint**: do the Lean declarations (`pullbackEtaUnitSquare`,
   `pullbackTensorMap_unit_isIso`, `compHomEquivFactor`, `leftAdjointUniqUnitEta`,
   `presheafUnit_comp_map_eta`, `sheafificationCompPullback_eq_leftAdjointUniq`, and the
   step-7 target `epsilonPresheafToSheafUnit` if present) match their `\lean{...}` blocks in
   the chapter? Any fake/placeholder statement, signature mismatch, or a `\lean{...}` pointing
   at a name that does not exist (e.g. `epsilonPresheafToSheafUnit`, which the Lean file has NOT
   yet created — is it referenced in the chapter as if it exists)?

(b) **blueprint → Lean**: is the chapter's proof sketch for the unit square / the `(∗∗)` residual
   detailed enough to guide the final close, or too thin? Does the chapter accurately reflect that
   the `(∗∗)` residual is still open (one `sorry`)?

Report must-fix-this-iter items explicitly. Write your report to
`task_results/lean-vs-blueprint-ts249.md`.
