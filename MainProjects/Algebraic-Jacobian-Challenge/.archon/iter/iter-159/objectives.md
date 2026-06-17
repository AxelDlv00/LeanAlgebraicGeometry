# Iter-159 objectives detail

## Prover lane (1 file, single DEEP lane)

### `AlgebraicJacobian/AbelianVarietyRigidity.lean` — `rigidity_eqOn_dense_open`

Ordered sub-tasks (a)→(d). Blueprint: `chapters/AbelianVarietyRigidity.tex`
(`lem:rigidity_eqOn_dense_open` + the iter-159 "Formalization notes" addendum;
`rmk:rigidity_lemma_decomposition`). Recipes: `analogies/rigidity-hfib.md`,
`analogies/rigidity-affineconst.md`.

- **(a) sig change [mechanical].** `[IsAlgClosed kbar]` onto `rigidity_eqOn_dense_open` (L111),
  `rigidity_core` (L243), `rigidity_lemma` (L324). Instances flow down the call chain; downstream
  consumers already carry it. Keep the build green.
- **(b) `hfib` (L154) [mechanical via skeleton].** 7-step `IsPullback`-pasting +
  `image_preimage_eq_of_isPullback` per `analogies/rigidity-hfib.md`. NO `Triplet`/`carrierEquiv`/
  residue fields. Char-free; no `[IsAlgClosed]` needed for this step.
- **(c) docstring cleanup [mechanical].** rigidity_core docstring (≈L213–242): bridge 1 BUILT
  (`snd_left_isClosedMap`), only bridge 2 remains. Module docstring (≈L21–22): `rigidity_lemma`
  proven modulo helper. rigidity_eqOn_dense_open docstring (≈L106/L110): drop "both bridges
  discharged" / "sole remaining sorry" overclaim.
- **(d) bridge 2 — agreement equation (L181) [DEEP focus].** Route B
  (`analogies/rigidity-affineconst.md`): per-closed-slice constancy (`ext_of_isAffine` +
  `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closed triviality);
  globalize over dense closed points (`closure_closedPoints`/Jacobson) via
  `ext_of_isDominant_of_isSeparated'`. AVOID relative Stein/`f_*O=O` (confirmed Mathlib gap).
  PARTIAL acceptable; land any non-closing sub-lemma as a clean top-level `sorry` with a precise
  docstring + concrete continuation.

Off-limits: the 3 deferred scaffolds (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
`rigidity_genus0_curve_to_grpScheme`); all protected signatures; `Jacobian.lean`,
`RigidityKbar.lean`, Route A.

## Disproof / soundness pass

Not re-run this iter: `rigidity_eqOn_dense_open` is TRUE-as-stated (iter-158 soundness repair
threaded + consumed `_hf`; verified by two independent review subagents). The two residual sorries
are genuine sub-facts of a true lemma, not suspect statements. No new disproof obligation.
