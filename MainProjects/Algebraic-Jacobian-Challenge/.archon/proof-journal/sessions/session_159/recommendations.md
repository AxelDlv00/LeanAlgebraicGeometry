# Recommendations for the next plan iteration (post iter-159)

## HIGH — blueprint gate before the next AVR prover lane

1. **Dispatch a `blueprint-writer` for `AbelianVarietyRigidity.tex`** (one chapter) to:
   - Add a `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` statement block
     (e.g. `lem:rigidity_eqOn_saturated_open_to_affine`) hosting the existing "Bridge 2"
     prose (currently embedded only inside `lem:rigidity_eqOn_dense_open`'s proof, chapter
     lines ~98-121 / ~269-290), and add a `\uses{...}` edge from `lem:rigidity_eqOn_dense_open`'s
     proof to it.
     - **Why this is HIGH, not cosmetic:** without the block there is no `\uses` edge, so the
       `\leanok`-tagged proofs of `thm:rigidity_lemma` + `lem:rigidity_eqOn_dense_open` render
       as fully proven in the dependency graph even though both verify with transitive `sorryAx`.
       This is a marker-graph laundering vector (lean-vs-blueprint-checker Q1/Q4, major).
   - Refresh the stale status prose in `rmk:rigidity_lemma_decomposition` ("the two residual
     sorries inside `rigidity_eqOn_dense_open`") → "one residual sorry, extracted to the named
     helper `rigidity_eqOn_saturated_open_to_affine`". (Prose; review agent already refreshed the
     adjacent `% NOTE`.)
   - (Minor, optional) promote `rigidity_core` and `snd_left_isClosedMap` to blocks.
   - **HARD GATE:** after the writer returns and `lake build` is green, the same-iter fast path
     (scoped blueprint-reviewer on this chapter) must clear `complete + correct` before a prover
     is sent to `rigidity_eqOn_saturated_open_to_affine`.

## HIGH — next prover target (after the gate clears)

2. **`rigidity_eqOn_saturated_open_to_affine`** (the lone Rigidity-chain sorry, AVR L124-141).
   Route B (recipe `analogies/rigidity-affineconst.md`), decomposed:
   - (1) per-closed-point slice-constancy sub-lemma: `ext_of_isAffine` into `U₀`; `Γ(slice)=k̄`
     from `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closed;
   - (2) the "dense closed points ⟹ hom-ext" connective: coproduct
     `∐_{x∈closedPoints U} Spec κ(x) ⟶ U` dominant via `closure_closedPoints`, then
     `ext_of_isDominant_of_isSeparated'`.
   - Needs `[GeometricallyIrreducible X.hom]` / X reduced for slice integrality (derivable from
     the `(X ⊗ Y)` instances but itself a sub-step).
   - **DO NOT** attempt the relative Stein-factorisation / `f_*𝒪 = 𝒪` framing — confirmed
     Mathlib gap (recorded across iters 157-159). Analogist estimate: ~1-2 prover iters.
   - This is genuinely deep but **necessary regardless of route** and shared with the
     positive-genus Albanese path.

## MEDIUM — cheap Lean-side cleanup (lean-auditor, 2 major)

3. **`Cotangent/GrpObj.lean` stale section docstrings** (a one-shot prover/refactor cleanup,
   no math): L297-327 and L428-451 describe a three-step chain culminating in
   `mulRight_globalises_cotangent` and a base-change `sorry` step that were **EXCISED iter-145**
   (EXCISE notes at L552-560, L624-629). The file has **zero live sorries**, but a reader
   scanning these blocks would conclude otherwise. Trim both blocks to match the surviving
   Step-3 declaration. (No blueprint impact; the file is `\leanok`.)

## LOW — notes

- `Cotangent/ChartAlgebra.lean:20-26` header NOTE references long-removed iter-145
  `: True := sorry` placeholders — harmless historical residue, trim when convenient.
- `Cohomology/MayerVietorisCover.lean` `HasAffineCechAcyclicCover` is an unbacked
  deferred-obligation Prop class on the genus-finiteness ladder (no in-tree producer; honest,
  disclosed). Track when that ladder becomes the active route.
- **Tooling:** `mathlib-analogist` recipes cite namespaces that may be wrong even when stamped
  "LSP-verified" (this iter: `Scheme.Pullback.image_preimage_eq_of_isPullback` → actually in
  `AlgebraicGeometry.Scheme`). Re-verify cited fully-qualified names before relying on them.

## Do NOT
- Do NOT re-assign `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma` — all
  `sorry`-free in their own bodies; the chain's only open content is the extracted helper.
- Do NOT pivot the route — route (c) (char-free AV rigidity) remains sound; the residual is a
  single, honest, isolated geometric obligation.
- Do NOT attempt bridge 2 via Stein / proper-pushforward (Mathlib gap).
