# lean-vs-blueprint-checker — FlatteningStratification (iter-022)

Bidirectional check of ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## This iter's prover work
- `genericFlatnessAlgebraic` (`thm:generic_flatness_algebraic`): CLOSED axiom-clean
  this iter (§4 dévissage assembly). Verify the Lean proof matches the blueprint
  route and the statement matches the lemma. Note: the Lean decl is now
  single-universe `(A B M : Type u)` (was `Type*`).
- `exists_localizationAway_finite_mvPolynomial` (L4, `lem:gf_noether_clear_denominators`):
  signature STRENGTHENED — a 4th existential conjunct added (the `algBg ↔ A→B→B_g`
  tower-compatibility `∀ a, …`). Verify the chapter's recorded signature/notes now
  match the landed Lean conclusion (a `% NOTE` was added this iter).
- Confirm no fake/weakened statements; report bidirectionally.
