# Blueprint Writer Report

## Slug
csi067

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:mapHC_augment_iso}`/`\lean{AlgebraicGeometry.mapHC_augment_iso}`
  — an additive functor `Φ` commutes with `CochainComplex.augment` via an identity-component iso.
  Proof sketch: same underlying graded object (deg 0 = `ΦY`, deg `n+1` = `ΦCⁿ`),
  `isoOfComponents` with all-identity components, squares close by unfolding `augment`.
  `\uses{lem:map_augment_cond}` (the transported augmentation condition).
- **Added lemma** `\lemma`/`\label{lem:map_augment_cond}`/`\lean{AlgebraicGeometry.map_augment_cond}`
  — additive `Φ` preserves the augmentation condition `f·d⁰ = 0 ⟹ Φ(f)·d⁰ = 0`. Proof: reshape
  `(ΦC).d⁰ = Φ(d⁰)` definitionally, then `Φ(f)·Φ(d⁰) = Φ(f·d⁰) = Φ(0) = 0`. Empty `\uses{}` (generic).
- **Added lemma** `\lemma`/`\label{lem:augmentCochainIso}`/`\lean{AlgebraicGeometry.augmentCochainIso}`
  — glues an iso of augmented complexes from a base iso `φ`, a node iso `eY`, and the deg-0
  compatibility square `f·φ₀ = eY·f'`. Proof: `isoOfComponents` (deg 0 = `eY`, deg `n+1` = `φₙ`);
  deg-0 square = supplied compat, deg-`n+1` squares = `φ.comm` via `augment_d_succ_succ`. Empty `\uses{}`.
  - All three placed immediately BEFORE `lem:cechSection_complex_iso` (the consumer that cites them).
- **Revised** `lem:cechSection_complex_iso` (proof block) — added `lem:mapHC_augment_iso,
  lem:map_augment_cond, lem:augmentCochainIso` to its proof `\uses{}`; inserted an "Augmentation
  bookkeeping (peeling the node)" paragraph spelling out the twice-`mapHC_augment_iso` peel +
  `augmentCochainIso` glue, naming the reduced **non-augmented** `coreIso : (G_V∘Ψ)(Č•(𝒰,F)) ≅
  Č•(𝒰′,F)` and stating that the differential-match steps apply to that reduced goal (advisory note #3).
- **Revised** `lem:cechSection_complex_iso` (proof, "Augmentation differential" paragraph) — added the
  sentence that `hcompat` is **definitional up to the section-functor adapter**: after unfolding
  `Ψ = forget·restrictScalars(id)` then `G_V = toPresheaf·ev_V`, `G_V(Ψ(cechAugmentation))` IS the
  restriction product `ε`, so the square closes by `Iso.refl`/definitional reduction — the deg-0
  instance of `coreIso`'s differential match (sketch-expansion #2).

## Cross-references introduced
- `\uses{lem:map_augment_cond}` in proof of `lem:mapHC_augment_iso` — target added in this same chapter.
- `\uses{lem:mapHC_augment_iso, lem:map_augment_cond, lem:augmentCochainIso}` added to proof of
  `lem:cechSection_complex_iso` — all three defined in this same chapter (verified via leandag).

## References consulted
None. All three helpers are Archon-original generic homological-algebra facts (no external source);
SOURCE lines correctly omitted per directive. (Lean statements/proofs read from
`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean:1374-1418` for accurate `\lean{}` pins,
statements, and proof shapes; namespace confirmed `AlgebraicGeometry` at line 428.)

## Macros needed (if any)
None.

## leandag verification
`leandag build --json`: `unknown_uses = 0`, all three new labels matched to their real Lean
declarations (`mapHC_augment_iso`, `map_augment_cond`, `augmentCochainIso` — not in `unmatched_lean`),
and `leandag show isolated` reports none of the new/edited labels isolated. No broken edges introduced.

## Notes for Plan Agent
- The two open `sorry`s in `cechSection_complex_iso` remain `coreIso` (non-augmented degreewise iso +
  differential match) and `hcompat` (deg-0 compat square). The blueprint now states explicitly that
  `hcompat` closes definitionally through the adapter and is the deg-0 instance of `coreIso` — so a
  next prover should treat them as one residual (the non-augmented core), the augmentation bookkeeping
  being fully discharged by the three helpers.
- No statement/`% NOTE:`/`\lean{}` of the two main lemmas was changed; `cechSection_contractible`
  untouched.

## Strategy-modifying findings
None.
