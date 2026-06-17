# Blueprint Writer Report

## Slug
d2-balancing

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
- **Revised** proof body of `\label{lem:stalk_tensor_commutation}`, stage (iv) "The reverse
  map" — replaced the single closing sentence ("...and `R_x`-bilinearity reduces to the
  germ–scalar compatibility of (i)/(iii).") with three expository paragraphs that convey, in
  textbook prose restated in the project's notation, the three required mathematical points:
  1. **Balancing proved at the STALK level.** Stated the explicit stalk-level identity
     `revBihom((germ_x r)·germ_x a, germ_x b) = (germ_x r)·revBihom(germ_x a, germ_x b)`
     with the scalar `germ_x r` staying in `R_x = R.stalk x` throughout, justified by the
     germ–scalar compatibility `germ_x(r·s) = (germ_x r)·(germ_x s)` (the same one used in
     stages (i)/(iii); the Lean identifier `germ_smul` is named once as that lemma, as the
     directive permitted). Emphasised that because the whole computation lives over the
     single ring `R_x`, no carrier identification intervenes.
  2. **Why NOT to reduce to a section-level identity.** Explained that pushing the scalar
     through the presheaf restriction to a common neighbourhood `W` forces the identity to
     be read in `A(W) ⊗_{R(W)} B(W)`, where the scalar action lives over the `RingCat`
     carrier `(R ∘ forget₂)(W)` rather than the `CommRingCat` carrier `R(W)` annotating the
     section tensor — the same stage-(iii) carrier-duality obstacle, compounded by an extra
     restriction-of-scalars wrapper, so `TensorProduct.smul_tmul'` does not apply directly.
  3. **The carrier-duality bridge is the stage-(iii) one.** Cross-referenced
     `\cref{lem:stalk_tensor_linear_map}` (the `stalkTensorDescU_smul`/`stalkTensorLinearMap`
     step) as the identical canonical `RingEquiv` bridge for any unavoidable
     CommRingCat-vs-RingCat identification, so the reader sees the balancing reuses that
     resolved technique.

The existing five-stage structure, the stage (i)/(ii)/(iii)/(v) prose, and the Stacks
SOURCE QUOTE are untouched. No `\leanok`/`\mathlibok` markers added or removed.

## Cross-references introduced
- `\cref{lem:stalk_tensor_linear_map}` reused in stage (iv) prose — label confirmed present
  in this same chapter at the `\label{lem:stalk_tensor_linear_map}` block.

## References consulted
None — this is an expansion of an Archon-original / project-bespoke proof sketch (the
d.2 stalk–tensor commutation). No external citation block was added, so no `references/`
file was opened. The retained Stacks SOURCE QUOTE elsewhere in the lemma was left intact
and unmodified.

## Macros needed (if any)
None — only existing macros and `\mathtt{...}` typewriter notation already used throughout
the chapter.

## Notes for Plan Agent
- The prose names the Lean identifier `germ_smul` once (as the directive explicitly
  permitted) as the germ–scalar compatibility lemma; the surrounding text stands as
  mathematics. No other Lean tactic strings were introduced.
- Stage (iv) refers to `\mathtt{revBihom}` as the reverse bilinear map; this matches the
  identifier used in the prover-facing memory and the stage's existing nested-colimit
  description. If the formalized name diverges, only the typewriter token needs adjusting.

## Strategy-modifying findings
None.
