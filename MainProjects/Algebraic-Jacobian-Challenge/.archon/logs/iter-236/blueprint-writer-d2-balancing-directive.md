# blueprint-writer — Picard_TensorObjSubstrate.tex, stage (iv) balancing guidance

## Scope (edit ONLY this chapter)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, the proof body of
`\begin{lemma}\label{lem:stalk_tensor_commutation}` (the d.2 stalk–tensor commutation),
**stage (iv) "The reverse map"** (currently around lines 1969–1986).

## Problem to fix (blueprint-reviewer ts236 must-fix #1)
Stage (iv) currently ends with the single sentence: "R_x-bilinearity reduces to the
germ–scalar compatibility of (i)/(iii)." A prover reading only the blueprint hit a wall
on the balancing condition `revBihom_balanced` (i.e. the bilinear map's `R_x`-balancing
`revBihom (r·a) b = revBihom a (r·b)`) precisely because the prose does not warn about
the carrier-duality obstacle nor name the technique that avoids it.

## Required addition (mathematical prose only — NO Lean tactic strings)
Expand the stage-(iv) bilinearity/balancing discussion so it conveys, in textbook prose
restated in the project's notation, the following three mathematical points. The math
content is the substance; phrase it as exposition, not as a Lean recipe:

1. **Prove the balancing at the STALK level, not the section level.** The `R_x`-balancing
   of the reverse bilinear map should be established as the identity
   `revBihom (germ_x r · a) b = (germ_x r) · revBihom a b` where the scalar `germ_x r`
   stays in the stalk ring `R_x = R.stalk x` throughout. The germ–scalar compatibility
   `germ_x (r · s) = (germ_x r) · (germ_x s)` (the same germ–scalar compatibility used in
   stages (i) and (iii)) is what makes this hold. Working at the stalk level keeps every
   scalar action over `R_x`.

2. **Why one must NOT reduce to a section-level identity.** If instead one passes the
   scalar through the presheaf restriction at a common neighbourhood `W` (using the
   module structure map of the presheaf-of-modules `A`), the resulting section-level
   identity must be read in `A(W) ⊗_{R(W)} B(W)`, and there the scalar action is the one
   that the presheaf-of-modules structure produces via restriction of scalars — it lives
   over the `RingCat` carrier `(R ∘ forget₂)(W)`, NOT over the `CommRingCat` carrier
   `R(W)` that annotates the section tensor. This is the same CommRingCat-vs-RingCat
   carrier-duality obstacle already met in stage (iii); at the section level it is
   compounded by an extra restriction-of-scalars wrapper, so the naive "move the scalar
   across the tensor" step does not apply directly. The stage-(iv) balancing should
   therefore be done at the stalk level (point 1), avoiding this section-level wrapper.

3. **The carrier-duality bridge is the same one used in stage (iii).** Where a
   `CommRingCat`-vs-`RingCat` carrier identification is unavoidable, it is the identical
   canonical bridge already invoked for the stage-(iii) `R_x`-linearity packaging
   (the `stalkTensorDescU_smul`/`stalkTensorLinearMap` step, `\cref{lem:stalk_tensor_linear_map}`):
   the two carriers are canonically identified but not definitionally equal, and the same
   bridge resolves the obstruction here. Cross-reference stage (iii) so the reader sees
   the balancing reuses that resolved technique rather than re-deriving it.

Keep the existing five-stage structure and the Stacks SOURCE QUOTE intact. This is an
expansion of the stage-(iv) prose only. Do NOT add/remove any `\leanok`/`\mathlibok`
markers (the deterministic sync owns `\leanok`). Do NOT introduce Lean tactic names as
the content — name the mathematical objects (germ–scalar compatibility, stalk ring `R_x`,
the carrier identification) and cross-reference stage (iii); you may mention the Lean
identifier `germ_smul` once as the germ–scalar compatibility lemma if helpful, but the
prose must stand as mathematics.

## Out of scope
Do not touch any other lemma block, the dead duplicate whisker lemma, or the FlatBaseChange
chapter.
