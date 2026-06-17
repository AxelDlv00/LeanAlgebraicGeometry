# Blueprint-reviewer directive — iter-016 whole-blueprint gate

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) as usual — per-chapter completeness +
correctness checklist, proof-sketch depth, well-formedness of Lean targets, broken/​missing `\uses`.

## Context for the gate (not a scope limiter — still audit everything)
This iteration the consolidated chapter `Cohomology_CechHigherDirectImage.tex` was edited:
1. The proof of `lem:cech_acyclic_affine` gained an **L1 categorical→module bridge paragraph**
   (identification `Γ(D(s_σ),F)=M_{s_σ}`, differential compatibility, iso of cochain complexes),
   sourced verbatim to Stacks Schemes Tag 01HV (`references/stacks-schemes.tex`).
2. Three `\lean{...}` lists gained bundled helper names (coverage-debt bundling):
   `lem:cech_acyclic_affine` (+9 `CombinatorialCech.*`), `lem:cech_complex_hom_identification`
   (+`freeYonedaHomEquiv`), `lem:injective_cech_acyclic` (+`injective_toPresheafOfModules`).

## Files about to receive provers (gate these specifically)
- `CechAcyclic.lean` ← `lem:cech_acyclic_affine` (with the new L1 paragraph). Is the proof now
  complete + correct enough to formalize L1 (the abstract→concrete identification)?
- `PresheafCech.lean` ← `def:section_cech_complex`, `lem:cech_complex_hom_identification`.
- `FreePresheafComplex.lean` (new) ← `def:cech_free_presheaf_complex`, `lem:cech_free_complex_quasi_iso`.

Report per-chapter `complete: true|false`, `correct: true|false`, and any must-fix-this-iter
findings, exactly as your checklist format requires.
