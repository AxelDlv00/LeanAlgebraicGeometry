# Lean ↔ Blueprint Checker Directive

## Slug
gf-iter006

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Notes
This file received prover edits this iter restructuring `exists_free_localizationAway_polynomial` (L5) to `induction d using Nat.strong_induction_on generalizing N` — the skeleton landed axiom-clean, with the residual sorry being the generic-rank dévissage SES (`0 → A_g[X]^⊕m → N_g → T → 0`, IH on T). No new declarations. Verify bidirectionally: (A) the Lean follows the chapter (signatures match, no fake statements); (B) whether the chapter's dévissage proof sketch is detailed enough to guide the next-iter effort-break into the generic-rank SES + torsion-reindex sub-lemmas, and likewise whether the L4 (`exists_localizationAway_finite_mvPolynomial`) Step-2 denominator-clearing is detailed enough — or whether the chapter needs a blueprint-writer expansion first. Also confirm the L4 `% LEAN SIGNATURE` block matches the landed declaration (it was reportedly corrected in a prior iter).
