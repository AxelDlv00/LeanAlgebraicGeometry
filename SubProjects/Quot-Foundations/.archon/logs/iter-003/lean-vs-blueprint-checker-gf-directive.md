# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- A 5-lemma Nitsure §4 dévissage chain was scaffolded this iter. Expected sorry-bearing (statement-`\leanok` only): `exists_free_localizationAway_of_shortExact` (L3), `exists_localizationAway_finite_mvPolynomial` (L4), `exists_free_localizationAway_polynomial` (L5, inductive step only — base case proved), the `genericFlatnessAlgebraic` residue branch, and the deferred `genericFlatness` geometric wrapper. `exists_free_localizationAway_of_torsion` (L1) is fully proved/axiom-clean.
- **Please specifically assess** the L4 `\lean{...}` pin (`lem:gf_noether_clear_denominators` → `exists_localizationAway_finite_mvPolynomial`): the prover flagged its signature as bulky (binds instance-existentials `∃ (_ : Algebra ...) ...`) and asked whether the chapter prose matches that encoding or whether the chapter should be re-blueprinted to a cleaner form. Report both directions (Lean→blueprint and blueprint→Lean).
