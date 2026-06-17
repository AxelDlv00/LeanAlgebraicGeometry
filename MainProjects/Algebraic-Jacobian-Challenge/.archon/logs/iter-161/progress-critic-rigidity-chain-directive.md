# Progress-Critic Directive

## Slug
rigidity-chain

## Active route under assessment

**Route: char-free abelian-variety Rigidity-Lemma chain**
(single active prover file: `AlgebraicJacobian/AbelianVarietyRigidity.lean`).
Chain: `rigidity_lemma → rigidity_core → rigidity_eqOn_dense_open →
rigidity_eqOn_saturated_open_to_affine → (Step1) rigidity_eqAt_closedPoint_of_proper_into_affine`,
globalised by `(Step2) morphism_eq_of_eqAt_closedPoints`. This is the only file receiving
prover lanes; all other open sorries (`Jacobian.lean`, `RigidityKbar.lean`, three deferred
cube/Riemann–Roch scaffolds) are intentionally off-limits / gated.

## Last 4 iters' signals (extracted)

| iter | prover status | chain-region sorry count | helpers added | structural advance | recurring blocker phrase |
|---|---|---|---|---|---|
| 157 | PARTIAL (later found UNSOUND) | 1 (`rigidity_lemma` landed but laundering) | +several (categorical) | `rigidity_lemma` stated; but `_hf` dropped → false-as-stated helpers | "collapse hypothesis" |
| 158 | PARTIAL | 2 internal (in `eqOn_dense_open`) | +1 (`snd_left_isClosedMap`, axiom-clean) | soundness REPAIRED (`_hf` threaded); bridge 1 BUILT axiom-clean; Mumford construction wired | "bridges must be BUILT not FOUND" |
| 159 | PARTIAL | 1 (chain dropped 2→1) | +1 (`rigidity_eqOn_saturated_open_to_affine` extracted) | `hfib` CLOSED axiom-clean; bridge 2 isolated into named helper | "deep residual / route B" |
| 160 | PARTIAL | 2 (chain rose 1→2: Step1 stub + JacobsonSpace instance) | +2 (`morphism_eq_of_eqAt_closedPoints` PROVEN axiom-clean; `rigidity_eqAt_closedPoint` stub) | Step 2 PROVEN axiom-clean; SIGNATURE GAP surfaced + honestly isolated | "signature gap / finite-type / Jacobson density" |

Net over the 4 iters: chain residual oscillated 1↔2 but each iter closed a genuine
load-bearing piece (soundness repair → bridge 1 → `hfib` → Step 2), narrowing the residual
to ONE deep geometric sorry (`rigidity_eqAt_closedPoint_of_proper_into_affine`, Step 1) plus
one instance sorry that the iter-160 audit diagnosed as a fixable signature gap, not new
mathematics. No new axioms in any iter. All advances `lean_verify` axiom-clean.

## This iter's (iter-161) planned action — NOT a prover round on the residual

The plan agent is NOT firing the prover at the deep residual blindly. iter-161 is a
**signature-fix iter**: (a) a refactor threads `[LocallyOfFiniteType (X ⊗ Y).hom]` across
the 5 chain lemmas (the iter-160-audit-prescribed fix, which makes both remaining chain
sorries provable-as-typed — Mathlib facts already verified to exist:
`LocallyOfFiniteType.jacobsonSpace`, `JacobsonSpace.of_isOpenEmbedding`, `Spec` of a field is
Jacobson); (b) a blueprint-writer amends the chapter to match + adds the two missing
`\lean{}` blocks; (c) a scoped blueprint-reviewer clears the HARD GATE. THEN the prover lane
(iter-161 or 162) discharges the now-routine `JacobsonSpace U` instance + attacks Step 1.

## PROGRESS.md `## Current Objectives` proposal for iter-161

1 file: `AlgebraicJacobian/AbelianVarietyRigidity.lean` — single deep lane: after the
signature thread + blueprint clear, prove `rigidity_eqAt_closedPoint_of_proper_into_affine`
(Step 1, the lone deep residual) and discharge the routine `JacobsonSpace U` instance.

## Strategy estimate for this route (verbatim from STRATEGY.md `## Phases & estimations`)

- Phase: "genus-0 rigidity (committed route (c))". Iters-left cell:
  "cube-dominated: rigidity_lemma 1–2; full arm ~10–18 (cumulative keystone ≈8 elapsed + this)".
- LOC cell: "~2500–5000 · 0/it".
- The `rigidity_lemma`/chain sub-phase entered at iter-157/158 (route (c) committed iter-156).
  So ~4 iters elapsed on the `rigidity_eqOn_*` heart vs the "1–2" cell for `rigidity_lemma`
  (the heart turned out heavier than the cell; the full-arm "~10–18" still has the theorem of
  the cube + Riemann–Roch entirely unstarted ahead of it).

## Question for you

Is this route CONVERGING (closing the rigidity chain), or has it become CHURNING (each iter
adds a helper but the residual never actually shrinks toward zero)? In particular: is the
1↔2 chain-sorry oscillation genuine forward motion (each iter closing a real piece) or a
helper-treadmill? And: does the elapsed-vs-estimate gap on the `rigidity_eqOn_*` heart
(≈4 iters vs the "1–2" cell) signal a needed re-estimate or an OVER_BUDGET risk for the
full arm, given the cube + Riemann–Roch are still entirely unstarted?
