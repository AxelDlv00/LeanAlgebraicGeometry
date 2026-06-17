# Progress-critic directive — iter-158

Assess convergence of the single active route below. K = 4 (iters 155–158).

## Route: genus-0 / abelian-variety rigidity (route (c))
Files: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (the route-(c) AV-rigidity
stack, upstream of `Jacobian.lean`); downstream consumer `Jacobian.lean`
`genusZeroWitness.key` (gated).

Strategy estimate for this route (verbatim from the phase table):
- **Iters left:** "cube-dominated: rigidity_lemma 1–2; full arm ~10–18 (cumulative
  keystone ≈8 elapsed + this)".
- **Phase entered (current form):** iter-157 — the dedicated file/chapter
  `AbelianVarietyRigidity` was created iter-157; the genus-0 keystone in some framing
  has been open ≈8 iters (149–157).

### Per-iter signals (last 4)
- **iter-155:** global sorry 7→3 (ChartAlgebraS3.lean DELETED; `genusZeroWitness`
  bare-sorry → terminal-object skeleton, 6/7 fields closed). Prover PARTIAL (skeleton
  only). Keystone (`rigidity_*`) NOT advanced. Blocker phrase: "df=0 irreducibly
  global-sections; chart route refuted".
- **iter-156:** global sorry 3→3 (NET 0). Prover edit comment-only; verified three
  out-of-file blockers on the keystone (import cycle `RigidityKbar→Rigidity→Jacobian`;
  char-`p` gap; no base-change functor). No closure. Blocker phrase: "import cycle +
  char-p + missing base-change".
- **iter-157:** global sorry 3→7 (by design — NEW file `AbelianVarietyRigidity.lean`
  scaffolded with 4 sorries). Prover status "done" on the `rigidity_lemma` lane. One
  helper genuinely proven + axiom-clean (`rigidity_snd_lift`); signature of
  `rigidity_lemma` correctly hardened. BUT review found the decomposition **UNSOUND**:
  the helpers `rigidity_core` / `rigidity_eqOn_dense_open` dropped the collapse
  hypothesis `_hf` and are FALSE as stated (counterexample `f = fst`); the proof never
  consumed `_hf`. Blocker phrase: "laundered hypothesis / false deferred sorry".
- **iter-158 (this iter, proposed):** refactor to re-sign `rigidity_core` +
  `rigidity_eqOn_dense_open` so they carry `_hf` (makes the deferred sorry TRUE +
  consumed), then a prover lane on the corrected `rigidity_eqOn_dense_open` (the genuine
  geometric heart — Mumford's "closed-map ⇒ non-empty `V` + slice-constancy", two
  char-free Mathlib bridges).

### Helpers added per iter
- iter-155: terminal-object skeleton fields (6/7).
- iter-157: `rigidity_snd_lift` (proven), `rigidity_core`, `rigidity_eqOn_dense_open`
  (the latter two were the unsound ones).

## This iter's PROGRESS.md `## Current Objectives` proposal
- **1 file**: `AlgebraicJacobian/AbelianVarietyRigidity.lean` — fill the body of the
  CORRECTED `rigidity_eqOn_dense_open` (post-refactor), the sole genuine geometric gap
  of the Rigidity-Lemma chain. (Refactor + blueprint-writer + scoped blueprint re-review
  precede the prover lane, same iter, per the sanctioned fast path.)

## Question
Is this route CONVERGING / CHURNING / STUCK / UNCLEAR? In particular: does re-signing
the false helpers + a prover lane on the corrected `rigidity_eqOn_dense_open` constitute
genuine forward motion, or is this the same wall under a new name? If CHURNING/STUCK,
name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural
refactor / route pivot).
