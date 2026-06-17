# Lean ↔ Blueprint checker — FlatBaseChange (iter-039)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## What changed this iter
Two new conjugate-side atoms were added and proved axiom-clean:
- `base_change_mate_reindex_conj_pullbackLeg` (~1625) — "conj-2b", pullback-side leg.
- `base_change_mate_reindex_conj_crossLayer` (~1652) — "conj-2d", cross-layer affine-unit transport.

The crux `base_change_mate_fstar_reindex_legs_conj` (~1757, `sorry` @~1822) was NOT closed —
the single-`conjugateEquiv`-component reframing keystone remains open. `gstar_transpose`
(~2289) remains gated behind it; the affine-reduction `sorry`s (~2470, ~2492) are unrelated.

## Check
- Do the blueprint blocks for conj-2b / conj-2d exist, with `\lean{...}` matching the actual
  Lean names? (The dag shows these two are NOT in the unmatched list, so blocks likely exist —
  verify the `\lean{}` targets and statements match.)
- Is the blueprint honest that `_legs_conj` and `gstar_transpose` are still open (no premature
  `\leanok`-implying prose / no fake "done")?
- Is the chapter detailed enough to have guided the reframing keystone, or is the keystone
  under-specified in the blueprint (a blueprint-side gap)?
