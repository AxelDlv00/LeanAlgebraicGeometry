# Session 132 — Review of Archon iter-132

## Metadata
- **Iteration**: 132 (canonical)
- **Session id**: session_132 (matches iter-132)
- **Stage**: prover
- **Sorry count before**: 3 (`Jacobian.lean:188`, `Jacobian.lean:213` (`nonempty_jacobianWitness`), `RigidityKbar.lean:87`)
- **Sorry count after**: 3 (`Jacobian.lean:192`, `Jacobian.lean:213`, `RigidityKbar.lean:87`)
- **Targets attempted**: 1 substantive (`cotangentSpaceAtIdentity_finrank_eq`)
- **Prover wall-clock**: 347s (≈ 5.8 min)
- **Files edited**: `AlgebraicJacobian/Cotangent/GrpObj.lean` (only)
- **Compile status**: clean. `lean_diagnostic_messages` = `[]`. `lake env lean AlgebraicJacobian/Cotangent/GrpObj.lean` exits silently.
- **Axiom posture**: `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` returns `{propext, Classical.choice, Quot.sound}` — kernel-only, no `sorryAx`, no project axioms.

## Headline outcome

**META-PATTERN TRIPWIRE PASSED.** Iter-132 was the iter-128/129/130/131 4-iter watch on `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`: would the iter-131 `Classical.choose`-chain body shape unblock a sorry-elimination dispatch (the rank lemma) without surfacing a third opacity-class defect? **Yes.** The prover closed the new theorem `cotangentSpaceAtIdentity_finrank_eq` in 1 substantive Edit (a ~40-LOC proof block placed inline at line 244 of the same file) plus 1 style edit (`show` → `change` to silence the Lean linter on the carrier-shifting tactic). Per `progress-critic-iter132`'s META-PATTERN tripwire framing, Route 1 (`Cotangent/GrpObj.lean`) **flips from CHURNING to CONVERGING** with this iter.

The closure consumes the iter-131 strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` *implicitly* via the alternative "parallel-extraction" route: rather than `rw [_eq_extendScalars]`-ing the body to the explicit form, the proof reconstructs the same `Classical.choose`-chain that the body uses (`let h := Scheme.smooth_locally_free_omega …; set U := h.choose; …`) so the goal's carrier `cotangentSpaceAtIdentity G` and the proof's TensorProduct expression `TensorProduct Γ(G,V) k Ω[…]` reduce definitionally via `ModuleCat.ExtendScalars.obj'`. `change Module.finrank k (TensorProduct …) = n` is the bridging tactic. The proof then closes in two steps: `rw [Module.finrank_baseChange]` pushes finrank from `k`-side to `Γ(G,V)`-side; `exact Module.finrank_eq_of_rank_eq hrank` consumes the existential's rank witness.

## Per-target detail

### `cotangentSpaceAtIdentity_finrank_eq` — SOLVED

**Location**: `AlgebraicJacobian/Cotangent/GrpObj.lean:244–282` (new this iter).

**Goal closed**:
```
Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n
```
under `[Field k] (G : Over (Spec (.of k))) [GrpObj G] {n : ℕ}
       [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]`.

**Attempt 1 (first Edit)**: drafted the full ~40-LOC proof body using:
- `let`/`set` to extract `U, V, e, hxV, hfree, hrank` via the parallel
  `Classical.choose`-chain on `Scheme.smooth_locally_free_omega (n := n) G.hom x₀`.
- `letI` for the `Γ(Spec k, U) → Γ(G.left, V)` algebra structure (matches the body's `letI`).
- `letI` for the `Γ(G.left, V) → k` algebra structure (induced by the
  `ψV` ring map composed via `Scheme.ΓSpecIso`).
- `haveI : Nontrivial Γ(G.left, V) := ψV.hom.domain_nontrivial` to discharge the
  `StrongRankCondition Γ(G.left, V)` instance hypothesis of `Module.finrank_baseChange`
  via Mathlib's `commRing_strongRankCondition` instance.
- `show … = n` to expose the underlying `TensorProduct` carrier via
  `ModuleCat.ExtendScalars.obj'`'s definitional unfolding.
- `rw [Module.finrank_baseChange (R := k) (S := Γ(G.left, V)) (M' := Ω[…])]`
  to push finrank from `k`-side to `Γ(G.left, V)`-side, discharging
  `Module.Free Γ(G.left, V) Ω[…]` via `hfree`.
- `exact Module.finrank_eq_of_rank_eq hrank` to consume `hrank : Module.rank … = ↑n`.

**Error encountered**: Lean linter warning on the `show` tactic:
> The `show` tactic should only be used to indicate intermediate goal states for readability. However, this tactic invocation changed the goal.

**Attempt 2 (second Edit)**: replaced `show` with `change`. Both tactics share the
same defeq-on-goal semantics but Lean treats them differently for style — `show` is
meant for restating the goal verbatim; `change` is the right primitive when the
goal's carrier shifts to a definitionally-equal form (here via
`ModuleCat.ExtendScalars.obj'` reducing to `TensorProduct …`). Warning cleared.

**Final status**: COMPLETE; sorry-count delta 0 (the new theorem has no `sorry`);
project sorry total unchanged at 3 (the close is a *new* declaration, not a
closure of an existing `sorry`-bodied scaffold).

### `genusZeroWitness` — NOT ATTEMPTED (intentional defer)

Iter-127 scaffold sorry at `Jacobian.lean:192`. Per STRATEGY.md, body closure
scheduled iter-138+ when the cotangent-vanishing pile closes. Off-limits this
iter.

### `nonempty_jacobianWitness` — NOT ATTEMPTED (Phase C OFF-LIMITS)

`Jacobian.lean:213`. Gated on M2 closure + M3 scaffolding; iter-148+ at earliest.

### `rigidity_over_kbar` — NOT ATTEMPTED (M2.a scaffold)

`RigidityKbar.lean:87`. iter-126 scaffold. Gated on the pile pieces
(i.a)→(i.b)→(i.c)→(ii)→(iii). Iter-132 closes (i.a); pieces (i.b)+(i.c)+(ii)+(iii)
remain. Iter-144+ at earliest.

## Plan-phase subagent outcomes (already absorbed in plan.md; summarised here for the record)

| Subagent | Verdict | Action |
|---|---|---|
| `strategy-critic-iter132` | CHALLENGE (5 must-fix + 4 alternatives + 3 sunk-cost flags) | 3 ADOPTED via STRATEGY.md (ground (iv) strike, fibre-free unconditional evaluation, piece (iii) provisional flag); 2 DEFERRED with explicit scheduling (no-Frobenius analogist iter-140+, ℙ¹-hedge analogist iter-140+); 1 ADOPTED via prover directive (rank-lemma `Classical.choose` parallel-extraction guidance). |
| `blueprint-reviewer-iter132` | `RigidityKbar.tex` `correct: partial` (3 narrow items); `Jacobian.tex` `correct: partial` (soft drift, informational) | HARD GATE GREEN-LIGHT-WITH-PARALLEL-WRITER. Three narrow items absorbed via Wave-3 parallel writer `rigiditykbar-uses-cleanup-iter132`. `Jacobian.tex` drift deferred iter-133+ informational. |
| `progress-critic-iter132` | CHURNING on Route 1; UNCLEAR on Routes 2+3 (deferred-by-design) | Primary corrective ADOPTED via § "Iter-133 branch (concrete fallback)" + prover directive's explicit META-PATTERN TRIPWIRE acceptance test. Iter-132 outcome flips Route 1 to CONVERGING. |
| `blueprint-writer-rigiditykbar-piecei-realign-iter132` | COMPLETE | § Piece (i) prose re-aligned to iter-131 body shape; rank-lemma proof rewritten with Steps 1+2 on live closure path; bridge demoted to Step 3 (deferred alternative); new mini-section "Iter-131 `Classical.choose`-chain body shape". |
| `blueprint-writer-rigiditykbar-uses-cleanup-iter132` | COMPLETE (parallel with prover lane) | 3 narrow `\uses{}` cleanups + 1 line-88 sentence + `rem:piece_i_first_target` rewrite. |

## Review-phase subagent dispatches this iter (2)

1. **`lean-auditor-review132`** (`task_results/lean-auditor-review132.md`) — **0 must-fix / 5 major / 1 minor / 0 excuse-comments**. Verdict: the project Lean is structurally clean; the 5 majors are all **stale-framing in `Cotangent/GrpObj.lean` docstrings** rendered inaccurate by the iter-132 rank-theorem addition that landed in the same file (4 sites in the file-level header + `## Status` block + 3 declaration-docstring spots). The 1 minor is a style nit on unused `set ... with ..._def` clauses in the new proof (the `_def` hypothesis names aren't consumed). Iter-133+ should land a refactor lane to refresh the docstrings; non-blocking for piece (i.b) work this iter.

2. **`lean-vs-blueprint-checker-cotangent-grpobj-review132`**
   (`task_results/lean-vs-blueprint-checker-cotangent-grpobj-review132.md`) — see report for full findings. Folded into recommendations.md.

## Recommendations (high-level — full prioritised list in `recommendations.md`)

- **HIGH (iter-133 refactor lane or blueprint-writer pass)**: refresh `Cotangent/GrpObj.lean` docstrings to reflect the in-file rank-lemma landing (5 stale sites flagged by `lean-auditor-review132`). Non-blocking; aesthetic-but-misleading.
- **HIGH (iter-133 prover-lane direction per § "Iter-133 branch" in plan.md)**: piece (i.b) `mulRight_globalises_cotangent` mathlib-analogist consult (`strategy-critic-iter131` Q3 must-fix on piece (i.b) feasibility before any prover lane).
- **MEDIUM (iter-133 plan-phase unconditional evaluation)**: fibre-free piece (i) reformulation evaluation per `strategy-critic-iter132` M4 (comparing projected (i.b)+(i.c) under (B) vs projected fibre-free cost).
- **MEDIUM (iter-133 reinstatement of ground (iv))**: per `strategy-critic-iter132` M1, the iter-132 rank-lemma close validates ground (iv) of the over-k defense — reinstate it as **iter-132 (not iter-131)** tractability evidence in the iter-133 strategy-critic re-verification.

## Blueprint markers updated (manual)

- `RigidityKbar.tex`, `lem:GrpObj_lieAlgebra_finrank` (line 191 statement
  block): stripped stale `\notready` marker. The iter-132 prover lane
  closed the corresponding Lean theorem
  `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (no
  `sorry`, kernel-only axioms); the lemma is no longer `\notready`.
  Deterministic `sync_leanok` is expected to add `\leanok` on both the
  statement and proof blocks (the proof block's `\leanok` was already
  placed by the iter-132 plan-phase blueprint-writer
  `rigiditykbar-piecei-realign-iter132`).

No other manual marker edits this iter. No `\mathlibok` candidates (the
new theorem is project-internal, not a Mathlib re-export). No
`\lean{...}` renames flagged. The rank lemma's blueprint counterpart
`lem:GrpObj_lieAlgebra_finrank` already has its
`\lean{cotangentSpaceAtIdentity_finrank_eq}` hint matching the iter-132
Lean name verbatim. The four remaining `\notready` markers
(`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_mulRight_globalises`,
`lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) are correctly
retained — those lemmas have NOT landed and are intentionally deferred
per STRATEGY.md.

## Notes (low-impact observations)

- The `set ... with ..._def` clauses at lines 252–254 introduce hypothesis names that are never used in the proof body. Style nit per `lean-auditor-review132` minor #1; iter-133+ refactor-lane candidate (non-blocking).
- The iter-132 prover's task result notes that the blueprint chapter file `AlgebraicJacobian_Cotangent_GrpObj.tex` does NOT exist — the actual blueprint content for piece (i.a) lives as § Piece (i.a) of `blueprint/src/chapters/RigidityKbar.tex`. The prover surfaced this as a suggestion to either create a stub cross-reference chapter or update the prover-task-seed pointer. Iter-133+ informational consideration.
