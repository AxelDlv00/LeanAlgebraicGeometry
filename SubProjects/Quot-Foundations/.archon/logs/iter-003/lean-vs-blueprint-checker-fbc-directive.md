# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- Several decls carry `sorry` bodies by design: `base_change_mate_generator_trace` (L4 residue), `affineBaseChange_pushforward_iso` (affine reduction, downstream), `flatBaseChange_pushforward_isIso` (deferred lane). Statement-`\leanok` only is expected for these.
- The mate lemma `pushforward_base_change_mate_cancelBaseChange` is recorded as the `IsIso (Γ(α))` corollary form rather than a literal equality — this is a deliberate pin reconciled by a `% NOTE:` in the chapter (iter-002). Not a finding.
- Two NEW project-local helper defs `pullbackIsoEquivalenceOfIso` and `pullback_isEquivalence_of_iso` have no blueprint block yet (coverage debt, already tracked). You may note them under blueprint-adequacy but they are not must-fix.
- The prover used Mathlib's tensor order `A ⊗[R] R'` rather than the chapter's `R' ⊗_R A` in the new leg-identification lemmas — please assess whether this is a faithful re-orientation or a genuine signature divergence from the prose.
