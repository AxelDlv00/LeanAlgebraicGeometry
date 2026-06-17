# Blueprint Writer Report

## Slug
acyclic-anchor

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Changes Made
- **Revised** `lem:homology_long_exact_sequence` — corrected the unfaithful Mathlib
  dependency anchor. The block asserts the FULL long exact homology sequence (exactness
  at all three positions plus the connecting map δ) and is consumed by both
  `lem:acyclic_dimension_shift` and `lem:acyclic_resolution_computes_derived`, but its
  `\lean{}` previously named only `CategoryTheory.ShortComplex.ShortExact.homology_exact₃`.
  Replaced the single-name `\lean{}` with the comma-separated list of all four Mathlib
  declarations the block actually states, keeping `\mathlibok`:
  - `CategoryTheory.ShortComplex.ShortExact.homology_exact₁`
  - `CategoryTheory.ShortComplex.ShortExact.homology_exact₂`
  - `CategoryTheory.ShortComplex.ShortExact.homology_exact₃`
  - `CategoryTheory.ShortComplex.ShortExact.δ`

Used the **preferred** approach from the directive (single block, comma-separated
`\lean{}`). Verified that leandag accepts the list: it splits on commas into four
separate lean names while the `\label` is unchanged, so every downstream
`\uses{lem:homology_long_exact_sequence}` edge stays valid (no split / umbrella-label
juggling needed). No prose change was required — the block already states the full long
exact sequence with the δ connecting morphism; only the `\lean{}` was unfaithful.

## Verification

### leandag DAG integrity
`archon dag-query node --node lem:homology_long_exact_sequence` after the edit:
```
lem:homology_long_exact_sequence
  \lean{...homology_exact₁, ...homology_exact₂, ...homology_exact₃, ...δ}
  (effort 0, deps 0, used-by 1) [mathlib]
```
Node remains `[mathlib]` with effort 0 (treated as done) and `used-by 1` — the `\uses{}`
edges resolve. `leandag build --json`: `unknown_uses: []`, `conflicts: []`. The four
names appear in `unmatched_lean` for this node, which is the expected/normal pattern for
a Mathlib anchor (the three sibling anchors in this chapter —
`isoRightDerivedObj`, `isZero_rightDerived_obj_injective_succ`, `rightDerivedZeroIsoSelf`
— all appear in `unmatched_lean` too, since the names live in Mathlib, not the project's
own Lean source; `\mathlibok` is what marks the node done).

### Mathlib existence check (anti-hallucination)
All four declarations confirmed live in Mathlib via loogle, module
`Mathlib.Algebra.Homology.HomologySequence`:
- `...homology_exact₁` — exactness at `S.X₃.homology i` (∂ → homologyMap S.f).
- `...homology_exact₂` — exactness at `S.X₂.homology i` (homologyMap S.f → homologyMap S.g).
- `...homology_exact₃` — exactness at `S.X₃.homology i` (homologyMap S.g → δ).
- `...δ` — connecting morphism `S.X₃.homology i ⟶ S.X₁.homology j`.

## Cross-references introduced
None. No `\uses{}` edges were added or changed; the `\label` is unchanged, so all
existing downstream references (`lem:injective_resolution_of_ses`,
`lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) continue to
resolve.

## References consulted
None this session — the single change is a Mathlib dependency anchor (the `\lean{}`
target is the citation; no `% SOURCE`/`% SOURCE QUOTE` is required for a Mathlib
re-export, per the directive's citation-discipline note). Existing
`% SOURCE`/`% SOURCE QUOTE` comments on the block were left untouched.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The four Mathlib `δ`/`homology_exact₁₂₃` declarations are indexed by an explicit
  degree pair `(i j : ι)` with `hij : c.Rel i j`, not by a single `n`. The chapter's
  prose writes the sequence with `δ^n : H^n(S.X_3) → H^{n+1}(S.X_1)`, which is the
  `ComplexShape.up ℤ` specialization (`c.Rel n (n+1)`). This is mathematically faithful
  and needs no change, but the prover wiring `rightDerivedShiftIsoOfAcyclic` will need to
  instantiate `i := n`, `j := n+1`, `hij := rfl`-style for the cochain shape — purely a
  Lean-side concern, flagged here only for awareness.

## Strategy-modifying findings
None.
