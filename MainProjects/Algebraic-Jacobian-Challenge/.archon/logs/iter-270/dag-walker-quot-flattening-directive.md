# DAG Walker Directive

## Slug
quot-flattening

## Seed
thm:quot_representable

## Strategy context
Phase A.2.c-engine — the Quot/Cartier representability engine (RR-free) and its
flattening-stratification input, the dominant pole of Route A. Chapters
`Picard_QuotScheme.tex` and `Picard_FlatteningStratification.tex`.

## Depth / scope
Walk the cone of the seed across both chapters. PRIMARY job: `\lean{}` pinning of
the gap nodes and wiring the isolated nodes via `\uses{}`. Do NOT rewrite proven
statements/proofs.

### Gap nodes needing a `\lean{}` pin:
In `Picard_QuotScheme.tex`:
- lem:quot_reduction_to_pi_star_W
- lem:quot_alpha_injective
- lem:quot_valuative_criterion
In `Picard_FlatteningStratification.tex`:
- thm:generic_flatness_algebraic
- lem:smooth_proper_curve_projective
- cor:flattening_stratification_curve

For each, inspect the covered Lean file for the real declaration name and pin
`\lean{<real.name>}` if it exists; otherwise pin a placeholder
`\lean{AlgebraicGeometry.TODO.<label>}` per DAG integrity rule 1. The QuotScheme
gaps (`quot_reduction_to_pi_star_W`, `quot_alpha_injective`,
`quot_valuative_criterion`) are the named blueprint sub-steps of the main
representability construction — pin them and add the `\uses{}` edge FROM the
construction theorem that consumes them (e.g. `thm:quot_representable` /
boundedness / valuative-criterion assembly) so they sit on the cone rather than
floating.

### Isolated nodes in `Picard_FlatteningStratification.tex` to wire:
- lem:smooth_proper_curve_projective and cor:flattening_stratification_curve
  (these are also gaps above) — wire them to their consumer
  (`thm:flattening_stratification_universal` / the curve specialisation) and to
  their own dependencies.

## Out of scope
Remarks (`rem:`/`rmk:`) are exempt. Do not add `\leanok`. Do not rewrite the
generic-flatness or stratification proof bodies beyond their `\uses{}`/`\lean{}`.

## References
- `references/nitsure-hilbert-quot.md` (Quot/Hilbert construction) and
  `references/stacks-algebra.md` (generic flatness) — only where a block lacks a
  citation line; do not rewrite existing cited prose.
