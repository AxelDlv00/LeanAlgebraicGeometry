# Blueprint Reviewer Directive

## Slug
iter128

## Strategy snapshot

The project's iter-128 plan-phase work is the META-PATTERN TRIPWIRE prover lane: refactor scaffold for `AlgebraicGeometry.GrpObj.lieAlgebra` (piece (i.a) of the shared cotangent-vanishing pile) in a new file `AlgebraicJacobian/Cotangent/GrpObj.lean`, then prover dispatch on it. The iter-127 plan-agent staged 5 named lemma blocks in `RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" for this purpose.

End-state target: zero inline `sorry` in the project; no named axioms. Current sorry sites:
- `Jacobian.lean:174` — `genusZeroWitness` (iter-127 scaffold)
- `Jacobian.lean:194` — `nonempty_jacobianWitness` (off-limits, queued post-M2+M3)
- `RigidityKbar.lean:87` — `rigidity_over_kbar` (iter-126 scaffold)

Iter-128 adds **2 new sorries** via the refactor (new file `Cotangent/GrpObj.lean` containing scaffolds `lieAlgebra` and `lieAlgebra_finrank_eq_dim` with sorry bodies); the prover then attempts to fill them.

## Routes

The strategy has multiple historical routes (M1 EXCISED iter-126; M2.c DROPPED iter-127); the active multi-route axis remaining is **over-k baseline vs over-k̄ fallback** within M2.a. Both routes are blueprint-covered: `RigidityKbar.tex` is the over-k chapter; over-k̄ remains a fallback if iter-128+ piece-(i) build encounters an over-k blocker (per the iter-127 over-k analogist's risk register). The active prover-lane route this iter is **piece (i.a) of the shared pile** within the over-k baseline.

## Focus areas this iter

Pay extra attention to:

1. **`RigidityKbar.tex`** — does the iter-127-added piece-(i) sub-decomposition (5 lemma blocks + 1 remark; lines ~81–178) give the iter-128 prover enough mathematical detail to formalize `lem:GrpObj_lieAlgebra` (`AlgebraicGeometry.GrpObj.lieAlgebra`)? In particular:
   - Does the proof sketch (lines 100–103) say enough for the prover to construct `eta_G^* Omega_{G/k}` as a Lean object and prove it's a finitely generated free `k`-module? Or does the prover need to invent helper machinery?
   - The proof sketch invokes "smoothness of G at η_G makes the local ring regular" — is this expanded enough, or is "regular local ring + cotangent = free module" assumed but never decomposed for the prover?
   - Are the references to Mathlib (project's `relativeDifferentialsPresheaf`, the `GrpObj` namespace per Yang+Merten 2026) precise enough?
2. **`Jacobian.tex`** — does the iter-127 `def:genusZeroWitness` block adequately cross-reference `RigidityKbar.tex`? Are there blueprint adequacy issues that the iter-127 lean-vs-blueprint-checker (review-phase) didn't catch?
3. **Multi-chapter coherence** — do `RigidityKbar.tex` and `Jacobian.tex` agree on the over-k commitment framing? Is there leftover over-k̄ prose in `Jacobian.tex` that the iter-127 writer dispatch missed?
4. **Orphan chapters** (`Modules_Monoidal.tex`, `Picard_*`) — not in `content.tex` but exist on disk. Are they cruft, future-route material, or dead weight? Recommend cleanup if dead weight.

## Per-chapter checklist requested

For each chapter under `blueprint/src/chapters/`, report:
- `complete: true | partial | false`
- `correct: true | partial | false`
- `must-fix-this-iter: <list of issues blocking iter-128 prover work; explicitly check the chapter `RigidityKbar.tex` for piece-(i) coverage adequacy>`
- `soon: <list of cleanup items deferrable past iter-128>`

## HARD GATE — per-file prover dispatch this iter

The plan agent is considering ONE new file for the iter-128 prover lane:

- **`AlgebraicJacobian/Cotangent/GrpObj.lean`** (new file, to be created by refactor): blueprint chapter would be `Cotangent_GrpObj.tex` (does NOT yet exist) — BUT the lemma blocks for the targets ARE staged inside `RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" (iter-127 NEW). 
  - Two `\lean{...}` targets are staged: `AlgebraicGeometry.GrpObj.lieAlgebra` and `AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim`.
  - Report whether the iter-127-staged blueprint coverage in `RigidityKbar.tex` is sufficient to greenlight a prover dispatch on the new Lean file, OR whether a fresh `Cotangent_GrpObj.tex` chapter should be authored this iter before the prover dispatch.

Apply the hard gate verbatim:
- If the staged piece-(i.a) lemma blocks in `RigidityKbar.tex` are `complete: true` + `correct: true` AND have no must-fix-this-iter findings, the prover dispatch on `Cotangent/GrpObj.lean` can proceed.
- Otherwise, drop the prover dispatch from iter-128, dispatch a `blueprint-writer` for `RigidityKbar.tex` (or a new `Cotangent_GrpObj.tex`) THIS iter, and record the deferral.

## Prior reviewer status

iter-127 blueprint-reviewer returned PARTIAL (3 must-fix items):
1. `RigidityKbar.tex` lacked piece-(i) sub-lemma decomposition — RESOLVED iter-127 by `blueprint-writer-rigiditykbar-piece-i-iter127` (+101 lines).
2. `Jacobian.tex` lacked `def:genusZeroWitness` block — RESOLVED iter-127 by `blueprint-writer-jacobian-iter127` (+31 lines).
3. Multi-route coverage missing (direct-over-k chapter) — RESOLVED by over-k analogist verdict + plan-agent inline rewrite of `RigidityKbar.tex` introduction.

**Re-verify all 3 fixes** in addition to the per-chapter audit.

## Out of scope

- Lean code correctness (lean-vs-blueprint-checker's territory; runs review phase).
- Strategy soundness (strategy-critic's territory).
- Per-iter progress signals (progress-critic's territory).
