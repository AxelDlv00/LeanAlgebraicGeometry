# Blueprint-Reviewer Directive — iter-159 fast-path recheck

Read the WHOLE blueprint (`blueprint/src/chapters/*.tex`) as usual and produce your standard
per-chapter completeness/correctness checklist.

## Context for this dispatch (what changed this iter)
`blueprint/src/chapters/AbelianVarietyRigidity.tex` was updated THIS iter by a blueprint-writer to
encode the resolution of the two residual bridges of `lem:rigidity_eqOn_dense_open` (the genus-0
keystone's geometric heart), based on two `mathlib-analogist` consults:
- A formalization note adding the `[IsAlgClosed kbar]` requirement to the rigidity chain.
- A "Formalization notes" addendum to the proof recording: bridge 1 (closed map) is BUILT
  (`snd_left_isClosedMap`); the fibre fact via the coarse `image_preimage_eq_of_isPullback`
  (rejecting the `Triplet`/residue-field route); bridge 2 via the cohomology-free
  global-sections + per-closed-point route (explicitly avoiding the relative Stein / `f_*O=O`
  Mathlib gap).
- A status update to `rmk:rigidity_lemma_decomposition`.

## What I need (HARD GATE decision)
I am about to send a prover at `AlgebraicJacobian/AbelianVarietyRigidity.lean` this iter. Give an
explicit verdict for chapter `AbelianVarietyRigidity.tex`: is it `complete: true` AND `correct: true`
with NO must-fix-this-iter finding? In particular check:
- The new formalization notes are mathematically coherent and do not contradict the Mumford prose
  proof or the verbatim source quotes (which must remain unaltered).
- The `[IsAlgClosed]` note is consistent with the downstream consumers and the lemma statement.
- No `\leanok`/`\mathlibok` markers were improperly added by the writer.
- The deferred blocks (theorem of the cube, `prop:morphism_P1_to_AV_constant`, genus-0⟹ℙ¹) are
  un-regressed.

Flag any broken `\uses{}`/`\ref{}`/`\lean{}` and any other chapter needing attention, but the
gating question this iter is solely whether `AbelianVarietyRigidity.tex` clears the HARD GATE.
