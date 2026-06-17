# Iter-156 (Archon canonical) — review

## Outcome at a glance

- **A prover lane FIRED on `Jacobian.lean` despite PROGRESS.md marking it
  off-limits** with a stated mechanical HARD GATE ("no prover dispatch this
  iter"). `meta.json`: `prover.status: done`, 332s, `provers.AlgebraicJacobian_Jacobian`.
  **This is the second consecutive iter the dispatch contradicted the plan**
  (iter-155 hit the same on `Jacobian.lean`). The prover behaved correctly: no
  scaffold, no laundering, no proof touched — it recorded a verified obstruction
  and stopped.
- **Sorry count 3 → 3 (NET 0).** No closure. The genuine contribution is the
  **triangulation and verification of three out-of-file blockers** on the
  genus-0 keystone `genusZeroWitness.key`.
- **Per-file bare-`sorry` tally** (re-verified `^\s*sorry\s*$`):
  - `Jacobian.lean` — **2**: `genusZeroWitness.key` (L265),
    `positiveGenusWitness` (L303, Route A off-path).
  - `RigidityKbar.lean` — **1**: `rigidity_over_kbar` (L88, NAMED GAP).
  - All other files: 0.
- Prover activity: 1 edit (comment-only), 1 goal check, 4 diagnostic checks,
  0 builds, 0 lemma searches. No protected signature touched; no new axioms.

## The contribution — three verified gates on the genus-0 keystone

`genusZeroWitness.key : f = toUnit C ≫ η[A]` is exactly `rigidity_over_kbar`'s
conclusion (`lean_goal` confirms). The prover tried to wire it via the blueprint
C.2.f descent route and surfaced three blockers, **all independently re-verified
this review**:

1. **IMPORT CYCLE (new finding).** `RigidityKbar → Rigidity → Jacobian`, so
   `Jacobian.lean` cannot import `rigidity_over_kbar`. Verified:
   `Rigidity.lean:6 import …Jacobian`; `RigidityKbar.lean:6 import …Rigidity`.
   Needs a plan-level relocation of the rigidity stack upstream of `Jacobian`.
2. **CHAR-`p` GAP.** `rigidity_over_kbar` carries `[IsAlgClosed kbar] [CharZero
   kbar]` (verified `RigidityKbar.lean:75-76`); `CharZero (AlgebraicClosure k)`
   unsynthesizable from `[Field k]`. Dropped only by route (c).
3. **BASE-CHANGE FUNCTOR MISSING.** No `Over (Spec k) → Over (Spec k̄)` functor in
   project or Mathlib `b80f227` (grep finds only `Module.finrank_baseChange`);
   only the final epi-cancellation (`Flat.epi_of_flat_of_surjective`) exists. A
   multi-iter sub-build.

The prover declined to add an unconsumable base-change stub (would inflate the
sorry count behind the cycle + char-`p`) and recorded the gates in-code
(`Jacobian.lean:234-263`). Honest call.

## Review-phase subagents (1 dispatched, COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-vs-blueprint-checker` | jacobian-iter156 | **PASS** (0 must-fix / 2 major / 2 minor) | Independently re-verified all 3 gates (import topology, signature, no base-change functor) — all correct. Both sorries are blueprint-named gaps, not laundered. **Major #1**: blueprint silently assumes `genusZeroWitness` consumes `rigidity_over_kbar` despite the import cycle. **Major #2**: blueprint bills the C.2.f descent as "∼2 lines" while it is a multi-iter base-change sub-build. Both blueprint-side; the Lean comments are more honest. Minors: 2 pending iter-155 `% NOTE:` items. |

`lean-auditor` skipped — see `## Subagent skips`.

## Blueprint-doctor

Flagged `RigidityKbar.tex`'s `% archon:covers RigidityKbar.lean
Cotangent/ChartAlgebra.lean` as covering nonexistent files. **Not a real orphan**
— both files exist under `AlgebraicJacobian/`; the `covers` paths are written
relative to the `AlgebraicJacobian/` source root but the doctor resolves them
relative to repo root. Surfaced to the plan agent to prepend `AlgebraicJacobian/`
so the dispatch gate routes correctly.

## Blueprint markers updated (manual)

- `Jacobian.tex`, `def:genusZeroWitness` proof: appended `% NOTE: (iter-156
  review …)` recording the two new majors (import-cycle obstruction + C.2.f
  descent under-costing). No `\leanok` touched.

## Independent verification

- Import cycle, `rigidity_over_kbar` hypotheses + conclusion, base-change-functor
  absence: all confirmed (see summary.md).
- Bare-`sorry` count = 3, matches PROGRESS.md. `Jacobian.lean` diagnostics: no
  errors, two `sorry` warnings only. No new axioms (comment-only edit).

## Subagent skips

- lean-auditor: the only `.lean` change this iter was a comment-only expansion at
  `Jacobian.lean:234-263` (no proof landed, no declaration/signature change); the
  two factual claims it adds (import cycle, char-`p` unsynthesizability) were
  verified directly this review; prior iter-155 lean-auditor returned 0 must-fix
  on the identical proof structure. No new code surface to audit.

## Forward (for iter-157 plan agent)

1. Fix the prover-dispatch gate so a prover does not fire on an off-limits file a
   third iter (loop-infrastructure; logged to debug-feedback).
2. Plan-level: blueprint the AV rigidity-lemma stack (Milne §I, route (c)) to
   prover-ready detail, and decide the rigidity-stack relocation that breaks the
   `RigidityKbar → Rigidity → Jacobian` cycle. Only then is a prover on the
   rigidity declarations dispatchable (blueprint-reviewer HARD GATE applies).
3. blueprint-writer on `Jacobian.tex` for the 2 majors + 2 pending iter-155 NOTEs.
4. Align `RigidityKbar.tex`'s `% archon:covers` paths.
