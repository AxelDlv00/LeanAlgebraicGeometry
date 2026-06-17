# Iter-132 (Archon canonical) — review

## Outcome at a glance

- **META-PATTERN TRIPWIRE PASSED — prover lane fired and CLOSED its target.**
  Iter-132 was the iter-128→iter-131 4-iter watch on the central declaration
  `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`: would the iter-131
  `Classical.choose`-chain body shape unblock a sorry-elimination dispatch
  (the rank lemma) without surfacing a third opacity-class defect?
  **Yes** — the prover closed `cotangentSpaceAtIdentity_finrank_eq` in 1
  substantive Edit (a ~40-LOC proof body placed inline at line 244 of the
  same file) plus 1 cosmetic edit (`show` → `change` to silence the Lean
  linter on the carrier-shifting tactic). Per `progress-critic-iter132`'s
  meta-pattern framing, Route 1 (`Cotangent/GrpObj.lean`) **flips from
  CHURNING to CONVERGING** with this iter.
- **Substantive structural change via 1 prover + 2 plan-phase
  blueprint-writers (already landed in plan phase) + 3 plan-phase critics
  + 2 review-phase audits**:
  - The **prover** added a new top-level theorem
    `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (lines
    244–282 of `AlgebraicJacobian/Cotangent/GrpObj.lean`), closing the
    goal `Module.finrank k (cotangentSpaceAtIdentity G) = n` against the
    iter-131 chart-base-changed body via the "parallel-extraction" route:
    reproduce the body's `Classical.choose`-chain on
    `Scheme.smooth_locally_free_omega`, extract `hfree`/`hrank` from the
    existential, `change` the goal to the underlying `TensorProduct`
    carrier (via `ModuleCat.ExtendScalars.obj'`'s definitional reduction),
    then `rw [Module.finrank_baseChange]` + `exact Module.finrank_eq_of_rank_eq hrank`.
    File grew from 219 LOC (iter-131 close) → 284 LOC (post iter-132).
  - The **iter-132 plan-phase blueprint-writers**
    (`rigiditykbar-piecei-realign-iter132` + `rigiditykbar-uses-cleanup-iter132`)
    re-aligned `RigidityKbar.tex` § Piece (i) prose to the iter-131
    `Classical.choose`-chain body shape: rank-lemma proof rewritten as
    Steps 1+2 on the live closure path; bridge demoted to Step 3
    (deferred alternative); narrow `\uses{}` cleanups (3 blocks);
    line 88 "deferred to iter-130+" sentence updated to identify the
    rank lemma as the iter-132 prover-lane target.
  - **Plan-phase critics**: `strategy-critic-iter132` CHALLENGE (5
    must-fix + 4 alternatives + 3 sunk-cost flags + 2 SOUND); all
    absorbed via STRATEGY.md edits (3 ADOPTED, 2 DEFERRED-with-explicit-
    scheduling) + the prover directive's `Classical.choose`
    parallel-extraction guidance + the parallel blueprint-writers.
    `blueprint-reviewer-iter132` HARD GATE GREEN-LIGHT-WITH-PARALLEL-WRITER;
    `Jacobian.tex` C.2.a–C.2.e soft drift deferred iter-133+
    informational. `progress-critic-iter132` CHURNING on Route 1
    with META-PATTERN TRIPWIRE armed; iter-132 outcome flips to
    CONVERGING; "Iter-133 branch (concrete fallback)" tree adopted
    naming the explicit non-promise no-body-reshape commitment.
  - **Review-phase audits** (dispatched this iter):
    `lean-auditor-review132` (whole-project, 13 files audited) and
    `lean-vs-blueprint-checker-cotangent-grpobj-review132` (the only
    prover-touched Lean file vs `RigidityKbar.tex` § Piece (i.a)).
    Findings folded into `recommendations.md` and the Knowledge Base.
- **Net sorry change**: **3 → 3** (substantive content is the *new
  theorem closed with no `sorry`*, not a `sorry`-elimination of a
  pre-existing scaffold). Per-file at close:
  - `Jacobian.lean:192` — `genusZeroWitness` (unchanged scaffold).
  - `Jacobian.lean:213` — `nonempty_jacobianWitness` (unchanged; Phase-C
    OFF-LIMITS).
  - `RigidityKbar.lean:87` — `rigidity_over_kbar` (unchanged scaffold).
  - `Cotangent/GrpObj.lean` — **0** sorries (preserved; rank lemma adds
    a closed declaration, not a scaffolded one).
- **Compile-verified**: yes. `lean_diagnostic_messages` returns 0 items
  on `AlgebraicJacobian/Cotangent/GrpObj.lean`. `lake env lean
  AlgebraicJacobian/Cotangent/GrpObj.lean` exits silently.
  `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq`
  returns `{propext, Classical.choice, Quot.sound}` — kernel-only, no
  `sorryAx`, no named axioms, no new project axioms.
- **No new axioms.** `archon-protected.yaml` unchanged (9 protected
  declarations).
- **Stage**: stays at `prover` for iter-133. Per `recommendations.md`,
  iter-133's primary dispatches are (a) a HIGH-A refactor lane to refresh
  the 5 stale-framing docstring sites in `Cotangent/GrpObj.lean` (flagged
  by `lean-auditor-review132`); (b) a HIGH-B mathlib-analogist consult
  on piece (i.b) `mulRight_globalises_cotangent` BEFORE any prover lane
  dispatch (per `strategy-critic-iter131` Q3 must-fix carry-over);
  (c) the MED-A fibre-free unconditional evaluation; (d) reinstating
  over-k ground (iv) in STRATEGY.md as iter-132 (not iter-131)
  tractability evidence (per `strategy-critic-iter132` M1). The
  iter-132 META-PATTERN TRIPWIRE explicitly forbids a 4th body reshape
  on `cotangentSpaceAtIdentity`.

## What the prover did, in detail

### Target: `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq`

**Goal closed**:
```
Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n
```
under
```
[Field k] (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
{n : ℕ} [SmoothOfRelativeDimension n G.hom]
[IsProper G.hom] [GeometricallyIrreducible G.hom]
```

**Approach** (per `task_results/AlgebraicJacobian_Cotangent_GrpObj.lean.md`):
the prover used the directive's authorised "alternative cleaner" route —
*parallel `Classical.choose`-chain extraction* matching the body's
`let h := smooth_locally_free_omega …; let U := h.choose; …`. The
chain is definitionally identical to the body's, so the goal's
`cotangentSpaceAtIdentity G` and the proof's
`(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])` share the
same underlying carrier — exposable via `change` (the linter-clean
sibling of `show` when the goal is genuinely changing shape) to the
explicit `TensorProduct Γ(G.left, V) k Ω[…]` form via `ModuleCat.ExtendScalars.obj'`'s definitional unfolding. Then:

- **Step 1 (chart-side Kähler rank)** — `Module.finrank_eq_of_rank_eq hrank`
  where `hrank : Module.rank Γ(G.left, V) Ω[…] = ↑n` is extracted from
  the existential's `.2.2.2.2`. Folded inline into the `exact` clause.
- **Step 2 (base-change preserves finrank)** —
  `rw [Module.finrank_baseChange (R := k) (S := Γ(G.left, V)) (M' := Ω[…])]`
  pushes `Module.finrank k (TensorProduct Γ(G,V) k Ω[…])` to
  `Module.finrank Γ(G.left, V) Ω[…]`. The `Module.Free Γ(G.left, V) Ω[…]`
  hypothesis is discharged via `hfree` extracted from the existential's
  `.2.2.2.1`. The `StrongRankCondition Γ(G.left, V)` instance is
  discharged via Mathlib's `commRing_strongRankCondition` instance,
  consuming `haveI : Nontrivial ↥Γ(G.left, V) := ψV.hom.domain_nontrivial`
  (the source of a ring map into a field is nontrivial).

**Attempts** (per `attempts_raw.jsonl`):

1. **Attempt 1** (lines 244–282): drafted the full ~40-LOC proof body
   with `show`. Lean linter warned: "The `show` tactic should only be
   used to indicate intermediate goal states for readability. However,
   this tactic invocation changed the goal." Clean compile otherwise;
   no proof error.
2. **Attempt 2** (lines 276–277 only): `show` → `change`. Warning
   cleared; `lean_diagnostic_messages` returns `[]` and
   `lean_verify` returns kernel-only axioms.

**Acceptance test compliance** (per `progress-critic-iter132` and
`strategy-critic-iter132`'s prover directive):

- ✓ Body closes with no `sorry`.
- ✓ References `Module.finrank_baseChange` (final `rw`).
- ✓ References `Module.finrank_eq_of_rank_eq` (final `exact`).
- ✓ Consumes the same `Classical.choose`-chain witnesses as the body's
  iter-131 body, definitionally matching the
  `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])` head form.
- ✓ The `change` step demonstrates the body's carrier reduces to
  `TensorProduct Γ(G.left, V) k Ω[…]` (via `ModuleCat.ExtendScalars.obj'`'s
  definitional unfolding).
- ✓ ~40 LOC, well within the 50–100 LOC budget.

**Lemma chain consumed** (all `[verified]` in Mathlib `b80f227` + project):
- `AlgebraicGeometry.Scheme.smooth_locally_free_omega` (project's
  `Differentials.lean`; consumes
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` +
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`).
- `Module.finrank_baseChange` (`Mathlib.LinearAlgebra.Dimension.Constructions`).
- `Module.finrank_eq_of_rank_eq` (`Mathlib.LinearAlgebra.Dimension.Finrank`).
- `RingHom.domain_nontrivial` (`Mathlib.Algebra.Ring.Basic`).
- `commRing_strongRankCondition` (instance,
  `Mathlib.LinearAlgebra.FreeModule.StrongRankCondition`).
- `ModuleCat.ExtendScalars.obj'` (`Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`).

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (file `AlgebraicJacobian/Cotangent/GrpObj.lean:149`)

Untouched. Iter-131 closure preserved.

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars` (file `AlgebraicJacobian/Cotangent/GrpObj.lean:198`)

Untouched. Iter-131 strong acceptance lemma; remains as a defensive
convenience handle (the prover did NOT consume it, but it stays in
place for any iter-133+ consumer that prefers to rewrite the body
before computing).

### `AlgebraicGeometry.genusZeroWitness` (file `AlgebraicJacobian/Jacobian.lean:192`)

Untouched. Iter-127 scaffold `sorry`. Off-limits this iter.

### `AlgebraicGeometry.nonempty_jacobianWitness` (file `AlgebraicJacobian/Jacobian.lean:213`)

Untouched. Phase-C OFF-LIMITS. No prover work iter-132.

### `AlgebraicGeometry.rigidity_over_kbar` (file `AlgebraicJacobian/RigidityKbar.lean:87`)

Untouched. Iter-126 scaffold `sorry`. Off-limits this iter (gated on
pile pieces (i.b)+(i.c)+(ii)+(iii); piece (i.a) closed iter-132 — first
piece consumed by this scaffold's body).

## Review-phase audit findings

See `recommendations.md` for the full prioritised list.

- `lean-auditor-review132` (`task_results/lean-auditor-review132.md`):
  **0 must-fix + 5 major + 1 minor + 0 excuse-comments**. Verdict:
  project Lean is structurally clean; the 5 majors are all
  **stale-framing in `Cotangent/GrpObj.lean` docstrings** rendered
  inaccurate by the iter-132 rank-theorem addition that landed in the
  same file (file-level header lines 28–30; `## Status` block lines
  32–57; `cotangentSpaceAtIdentity` declaration docstring at lines
  96–99, 136–138, 144–148 — all assert the rank lemma is "deferred
  to iter-132+" or "in a follow-up declaration", but iter-132 placed
  it at line 244 of the very same file). The 1 minor is a style nit
  on unused `set ... with ..._def` clauses in the new proof. Verdict
  bumps the iter-133 HIGH-A refactor-lane priority.
- `lean-vs-blueprint-checker-cotangent-grpobj-review132`
  (`task_results/lean-vs-blueprint-checker-cotangent-grpobj-review132.md`):
  **0 must-fix + 0 major + 2 minor**. The Lean file faithfully
  implements the iter-131 Replacement (B) construction described in
  piece (i.a) of `RigidityKbar.tex`, and the iter-132 rank lemma's
  proof matches the blueprint's Steps 1+2 closure path verbatim.
  Both `\lean{...}`-referenced declarations
  (`cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_finrank_eq`)
  are signature-and-content matched against the blueprint.
  Minors: (1) `cotangentSpaceAtIdentity_eq_extendScalars` is named
  three times in chapter prose but lacks its own `\lean{...}` block
  (folded as MED-B); (2) the chapter's recommended downstream rewrite
  pattern (`obtain` + `rw [heq]` through the companion lemma) drifts
  from the iter-132 Lean's direct `change`-based route (folded as
  MED-C). Both non-blocking.

The two audits **agree on the structural soundness**: the rank lemma
closure is clean, the Lean-vs-blueprint mapping is precise, and the
only actionable findings are documentation hygiene items (5 stale
docstring sites + 2 minor blueprint adequacy items).

## Meta-pattern verdict (post-iter-132 outcome)

The iter-128 prover (vacuous-by-zero-collapse) / iter-129 plan-only
(diagnostic + repair + rename + relax) / iter-130 prover (opaque-past-
Nonempty) / iter-131 plan-only (Classical.choose-chain refactor + strong
acceptance lemma) / iter-132 prover (rank lemma close) sequence completes
the META-PATTERN watch:

- **5 body-shape interactions; 2 opacity-class defects (iter-128
  computes-zero; iter-130 opaque-past-Nonempty); 0 third defect class
  surfaced iter-132.**
- **First downstream sorry-elimination dispatch** (the rank lemma)
  passed cleanly — not just by literal acceptance-test compliance but
  by full content-bearing closure: the rank witness `hrank` is consumed
  directly, the freeness witness `hfree` is consumed directly, and the
  base-change closure is via the canonical `Module.finrank_baseChange`
  Mathlib lemma.
- **The iter-127/128/129/130/131 META-PATTERN TRIPWIRE — third
  corrective cycle on same declaration — is NOT armed.** Iter-131 was
  the first fix-up iter; iter-132 is the success-branch outcome, not a
  second fix-up iter. The route is past the watch window.

**Per `progress-critic-iter132`'s explicit watch**: Route 1 flips from
CHURNING to **CONVERGING**. Routes 2 + 3 remain UNCLEAR (intentionally
deferred; no signal change). The iter-132 META-PATTERN TRIPWIRE
non-promise commitment (no 4th body reshape on `cotangentSpaceAtIdentity`
under any iter-133 branch) remains binding even now that the route is
CONVERGING — the next prover lane on this file, if any, should target
a *new* declaration (e.g. `Module.Free k cotangentSpaceAtIdentity`
companion lemma, the bridge, or piece (i.b) consumer), not a re-shape
of the existing body.

## Blueprint markers (manual this iter)

- `RigidityKbar.tex`, `lem:GrpObj_lieAlgebra_finrank` (line 191
  statement block): stripped stale `\notready`. The iter-132 prover
  lane closed the corresponding Lean theorem
  `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (no
  `sorry`, kernel-only axioms); the lemma is no longer `\notready`.

The plan-phase blueprint-writers
(`rigiditykbar-piecei-realign-iter132` +
`rigiditykbar-uses-cleanup-iter132`) handled all other prose,
`\uses{}`, and historical-narration updates as part of their writer-
domain work. The deterministic `sync_leanok` phase (run before review-
agent) is expected to add `\leanok` on both the statement and proof
blocks of `lem:GrpObj_lieAlgebra_finrank` (the rank lemma) now that
the stale `\notready` is gone and the Lean theorem
`cotangentSpaceAtIdentity_finrank_eq` is `sorry`-free and compiles.
No `\mathlibok` candidates (the rank theorem is project-internal, not
a Mathlib re-export). No `\lean{...}` renames flagged. The chapter's
existing `\lean{cotangentSpaceAtIdentity_finrank_eq}` hint already
matches the iter-132 Lean name verbatim.

The four remaining `\notready` markers in `RigidityKbar.tex`
(`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_mulRight_globalises`,
`lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) are correctly
retained — those lemmas have NOT landed and are intentionally deferred
per STRATEGY.md.

## Files and artefacts

- **Prover task result**:
  `.archon/task_results/AlgebraicJacobian_Cotangent_GrpObj.lean.md`.
- **Subagent reports (plan-phase + review-phase)**:
  - `task_results/strategy-critic-iter132.md`
  - `task_results/blueprint-reviewer-iter132.md`
  - `task_results/progress-critic-iter132.md`
  - `task_results/blueprint-writer-rigiditykbar-piecei-realign-iter132.md`
  - `task_results/blueprint-writer-rigiditykbar-uses-cleanup-iter132.md`
  - `task_results/lean-auditor-review132.md` (review-phase)
  - `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review132.md`
    (review-phase)
- **Session journal**: `proof-journal/sessions/session_132/` (this iter).
- **Iter sidecars**: `iter/iter-132/plan.md` (plan agent) + this file.
- **TO_USER.md**: left empty (no impasse; META-PATTERN passed; iter-133
  is routine plan+refactor+analogist+critics work, no user escalation
  candidate).

## Subagent budget this iter

- Plan-phase: 3 mandatory critics + 2 blueprint-writers + 0 mathlib-analogist
  + 0 refactor + 0 reference-retriever = **5 plan-phase dispatches**.
- Review-phase: 1 lean-auditor + 1 lean-vs-blueprint-checker (the only
  prover-touched file) = **2 review-phase dispatches**.
- **Total iter-132**: **7 subagent dispatches**.

## `meta.json` and durations

- `meta.json planValidate.status: ok / objectives: 1`.
- `plan.durationSecs: 2371` (≈ 40 min).
- `prover.durationSecs: 347` (≈ 5.8 min — fast close).
- `attempts_raw.jsonl`: 35 events (1 file-read + 2 edits + 4 diagnostic checks + 9 lemma searches + various lean_run_code/lean_hover_info probes + 1 lean_verify + 2 grep/wc).
