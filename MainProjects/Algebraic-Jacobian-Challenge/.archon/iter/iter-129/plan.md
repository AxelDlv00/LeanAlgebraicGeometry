# Iter-129 (Archon canonical) plan-agent run

## Headline outcome

Iter-128 closed with META-PATTERN flipped to CONVERGING (prover lane on
`AlgebraicGeometry.GrpObj.lieAlgebra` returned COMPLETE). The iter-128
review-phase flagged 3 must-fix-iter-129 items on the closed work
(hardcoded `1` in signature; body-vs-docstring convention mismatch; stale
file header in `Jacobian.lean`).

**Iter-129 was scoped as a plan-phase-only fix-up iter** to absorb the
iter-128 review findings + the broader iter-129 strategy/blueprint/progress
audit. It dispatched **7 subagents** (3 mandatory critics + 1 refactor +
2 blueprint-writers + 1 mathlib-analogist) and landed every must-fix item
identified by the critics, plus 1 critical discovery from the mathlib-
analogist.

The critical iter-129 discovery: **the iter-128 body of
`cotangentSpaceAtIdentity` (formerly `lieAlgebra`) is mathematically wrong
— it computes the zero `k`-module** for every smooth proper geometrically
irreducible group scheme `G/k` with relative dimension `n ≥ 1`. The
mathlib-analogist supplied a 5-step proof (presheaf-vs-sheaf collapse:
`Spec k` is single-point ⇒ pullback presheaf at `⊤` collapses to `k`;
proper geom-integral `G/k` ⇒ `Γ(G, ⊤) = k` ⇒ `Ω[k/k] = 0` ⇒ extendScalars
of `0` is `0`). The iter-130 prover lane must swap the body to Replacement
(B), affine-chart base change, before any rank-lemma dispatch can proceed.

The iter-128 body was kernel-clean but vacuously closed against a false
mathematical statement. This is exactly the failure mode the
strategy-critic-iter129's presheaf-vs-sheaf challenge anticipated.

Project sorry count unchanged at 3 (refactor was signature-only). No
prover lane this iter by design.

## Iter-129 deliverables

### Wave 1: mandatory critics (parallel)

| Subagent | Slug | Verdict | This-iter response |
|---|---|---|---|
| `strategy-critic` | iter129 | CHALLENGE (5 must-fix + 2 alternatives + 5 SOUND) | All 5 must-fix addressed via STRATEGY.md updates this iter; 2 alternatives folded into the strategy (revert-trigger retarget; ℙ¹-specific rigidity hedge). |
| `blueprint-reviewer` | iter129 | 3 must-fix + 4 soon | All 3 must-fix landed this iter via parallel writer dispatches (RigidityKbar must-fix bundle + orphan-chapter deletion). |
| `progress-critic` | iter129 | 3 UNCLEAR; 0 CHURNING / 0 STUCK | All three UNCLEAR verdicts are healthy: piece (i) is fresh-with-COMPLETE; the other two are deliberately deferred. Confirmed: iter-129 refactor lane is the right response to iter-128 must-fix list (not duplicate helper round). |

### Wave 2: refactor + 2 blueprint-writers + 1 mathlib-analogist (parallel)

| Subagent | Slug | Verdict | LOC / impact |
|---|---|---|---|
| `refactor` | cotangent-grpobj-fixup-iter129 | COMPLETE | `AlgebraicGeometry.GrpObj.lieAlgebra` → `cotangentSpaceAtIdentity`; signature `[SmoothOfRelativeDimension 1 G.hom]` → `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`; docstring align to cotangent convention; `Jacobian.lean` stale header rewritten. Project sorry count unchanged (3). `lake build` clean. `lean_verify` kernel-only. |
| `blueprint-writer` | rigiditykbar-iter129 | COMPLETE | `RigidityKbar.tex` rewrite: rename `lem:GrpObj_lieAlgebra` → `lem:GrpObj_cotangentSpace`; add bridge lemma `lem:GrpObj_cotangent_bridge`; rewrite rank-lemma 4-step proof with Mathlib anchors; fix phantom `IsRegularLocalRing.cotangentSpace` → `Ideal.IsLocalRing.CotangentSpace`; add inline signature stubs to 3 `\lean{...}` hints; update all `\uses{}` cross-references. |
| `blueprint-writer` | orphan-chapters-iter129 | COMPLETE | Deleted 4 orphan chapters (522 lines total): `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`. Zero dangling `\cref`/`\uses` in retained chapters. Blueprint count 14 → 10. |
| `mathlib-analogist` | lieAlgebra-rank-bridge-iter129 | **ALIGN_WITH_MATHLIB on body / PROCEED on unbundle** | **Critical discovery**: iter-128 body computes zero (5-step diagnostic). Replacement (B) chart-base-change chosen as the iter-130 prover-lane target; piece (i) bundled estimate (800–1500 LOC) retained; standalone-cotangent-sheaf (C) NOT activated. Persistent file `analogies/lieAlgebra-rank-bridge.md`. |

**Total subagents this iter: 7** (3 critics + 4 wave-2).

### STRATEGY.md changes landed this iter

Per the must-fix queue from `strategy-critic-iter129` + the analogist verdict:

1. **§ Sequencing ▸ revert trigger (a)** — retargeted from iter-128 piece
   (i.a) to iter-130+ piece (i.b). The original trigger was unfireable
   because the iter-128 close didn't use the shear iso; the shear iso is
   the iter-130+ piece (i.b) hinge, where the over-k functorial-vs-pointwise
   distinction actually matters.

2. **§ Sequencing ▸ over-k re-defense on revised numbers** — the iter-128
   net savings collapsed to a lower bound of 0/0; over-k commitment now
   defended on 3 non-LOC grounds (iter-128 empirical evidence; cleaner
   blueprint; iter-129 analogist trigger).

3. **§ Sequencing ▸ ℙ¹-specific rigidity hedge** — documented as a
   `C(k) ≠ ∅`-branch hedge for M2.b if the over-k pile blows past 2000
   LOC at iter-145+.

4. **§ Sequencing ▸ Standalone scheme-level cotangent sheaf — iter-129
   trigger engaged AND returned** — full analogist verdict folded in.
   Replacement (B) chosen; (C) deferred indefinitely. Piece (i) LOC
   envelope holds at 800–1500 LOC.

5. **§ M2 decomposition ▸ M2.body-pile row** — added iter-129 must-fix
   on signature relax + body presentation; named the verified Mathlib
   anchor `Ideal.IsLocalRing.CotangentSpace` (replacing the phantom).

## Response to critics

### `strategy-critic-iter129` → CHALLENGE (5 must-fix) — all addressed

| Issue | Critic verdict | Plan-agent response |
|---|---|---|
| `lieAlgebra` signature hardcoded `1` | must-fix | ADOPTED via `refactor-cotangent-grpobj-fixup-iter129`: relaxed to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`. |
| Presheaf-vs-sheaf bridge re-enters via rank lemma | must-fix | ADOPTED + DEEPER: dispatched `mathlib-analogist-lieAlgebra-rank-bridge-iter129` which discovered the issue is sharper than the critic anticipated — the iter-128 body is provably zero, not merely "has a bridge cost". Strategy revised; iter-130 body swap to Replacement (B) is the corrective. |
| Revert trigger (a) mis-targeted | must-fix | ADOPTED: STRATEGY.md § Sequencing trigger (a) → trigger (a'), retargeted to iter-130+ piece (i.b) shear-iso lane. |
| Direct ℙ¹-specific rigidity hedge for `C(k) ≠ ∅` | major alternative | ADOPTED as a STRATEGY.md hedge (not the active path; revisit if over-k pile blows past 2000 LOC). |
| Standalone scheme-level cotangent sheaf re-evaluation | major alternative | ADOPTED: iter-129 trigger engaged via the mathlib-analogist dispatch; the trigger returned PROCEED (do NOT unbundle; Replacement (B) gives the same rank lemma at lower cost). |
| Phantom `IsRegularLocalRing.cotangentSpace` | minor | ADOPTED: blueprint-writer-rigiditykbar-iter129 replaced with `Ideal.IsLocalRing.CotangentSpace` everywhere in `RigidityKbar.tex`. |
| Sunk-cost on over-k commitment | major | ADOPTED: STRATEGY.md § Sequencing ▸ "over-k re-defense on revised numbers" added with 3 non-LOC grounds. |

### `blueprint-reviewer-iter129` → 3 must-fix + 4 soon — all 3 must-fix addressed

| Issue | Reviewer verdict | Plan-agent response |
|---|---|---|
| RigidityKbar.tex (i.a) `\lean{...}` hint signature stub | must-fix | ADOPTED via `blueprint-writer-rigiditykbar-iter129`: inline signature stubs added to (i.a), rank lemma, and the new bridge lemma `\lean{...}` hints. |
| RigidityKbar.tex (i.a) rank-lemma bridge between evaluate-first body and `𝔪/𝔪²` stalk | must-fix | ADOPTED via the writer: new bridge lemma `lem:GrpObj_cotangent_bridge` authored; 4-step rank-lemma proof rewritten with Mathlib anchors. **Caveat**: the writer's bridge framing is closer to Replacement (A) canonical stalk-side; the iter-130 prover lane will implement Replacement (B) chart-side; chapter prose may need iter-131+ alignment if the discrepancy bites a future reader. |
| 4 orphan chapters (`Modules_Monoidal`, `Picard_*`) | must-fix | ADOPTED via `blueprint-writer-orphan-chapters-iter129`: all 4 deleted; zero dangling cross-references. |
| Jacobian.tex § C.2.a over-`k̄` prose stale | soon | DEFERRED iter-131+ (not blocking iter-130 prover lane). |
| RigidityKbar.tex rank-lemma cross-reference to Differentials.tex | soon | INCLUDED in the iter-129 writer rewrite — the new rank-lemma proof step 4 references `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` and `thm:smooth_locally_free_omega`. |
| RigidityKbar.tex pieces (ii)+(iii) decomposition | soon | DEFERRED iter-130+ when piece (i) closes. |
| RigidityKbar.tex legacy variable name `kbar` rename | informational | DEFERRED low-priority. |

### `progress-critic-iter129` → 3 UNCLEAR (no must-fix)

| Route | Verdict | Plan-agent response |
|---|---|---|
| M2.body-pile piece (i) | UNCLEAR (1 iter of data) | Acknowledged; iter-130 prover lane on body swap is the next data point. The iter-129 refactor lane is the right structural response to the iter-128 must-fix list (per critic's own note). |
| `rigidity_over_kbar` | UNCLEAR (deliberately dormant) | Acknowledged; no prover work expected until piece (i)+(ii)+(iii) close. |
| `genusZeroWitness` | UNCLEAR (deliberately dormant) | Acknowledged; gated on `rigidity_over_kbar`. |

Progress-critic answered the planner's Q1/Q2/Q3:
- Q1: piece (i) is UNCLEAR (fresh route, 1 iter of data); expect resolution iter-130.
- Q2: do NOT defer the prover wholesale; pick the lower-risk target.
  **Plan-agent rebuttal**: the iter-129 mathlib-analogist discovered the
  iter-128 body is wrong, which moves the iter-130 prover work from
  "rank lemma on existing body" to "swap body to Replacement (B)". The
  body-swap is the lower-risk target now (it has a fully named Mathlib
  closure chain in the analogist's persistent file); the shear iso (i.b)
  becomes iter-131+. **Iter-129 defers the prover lane to iter-130
  because of the body-swap precedence, not because of progress-critic's
  Q2 framing.**
- Q3: shear iso (b) has lower CHURNING risk than rank lemma (a).
  **Plan-agent rebuttal**: per Q2 response, the iter-130 target is
  neither (a) rank lemma nor (b) shear iso — it is the **body swap**
  per the analogist verdict. The shear iso target becomes iter-131+
  after the body-swap closes and the rank lemma (a) follows.

## Iter-130 prover lane staging (committed)

See PROGRESS.md § "Iter-130 staged objectives" for the full directive.
Headline: **iter-130 mandatory prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean`** — replace the
`cotangentSpaceAtIdentity` body with Replacement (B) (affine-chart base
change via `smooth_locally_free_omega`).

Mathlib closure chain (per `analogies/lieAlgebra-rank-bridge.md`):
1. `AlgebraicGeometry.IsSmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` [verified].
2. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` [verified].
3. `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified].
4. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` [verified].
5. `Module.Free.tensorProduct` + `Module.finrank_tensorProduct` [expected — Mathlib has the pattern].
6. `Module.finrank_eq_rank'` [verified].
7. `Scheme.ΓSpecIso` [verified].

Estimated body-swap closure: 50–100 LOC. If body swap closes early,
optional Wave 2 in iter-130: scaffold + close
`cotangentSpaceAtIdentity_finrank_eq` rank lemma (additional 50–100 LOC).

## Verification (iter-129 close)

| Check | Status |
|---|---|
| Sorry count | unchanged at 3 (refactor was signature-only) |
| `archon-protected.yaml` | unchanged (9 protected declarations) |
| New axioms | none. `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` returns kernel-only |
| `USER_HINTS.md` | empty entering iter-129; unchanged this iter |
| `STRATEGY.md` | substantively revised this iter (4 strategic changes per `strategy-critic-iter129` + `mathlib-analogist-lieAlgebra-rank-bridge-iter129`) |
| `lake build` | green (8330/8330) per refactor agent's verification |
| Mandatory critics | 3 of 3 dispatched |
| Total subagents | 7 (3 critics + 1 refactor + 2 writers + 1 analogist) |
| Blueprint chapters | 14 → 10 (4 orphan deletions) |
| New analogies | 1 (`lieAlgebra-rank-bridge.md` written by analogist) |
| HARD GATE for iter-130 prover lane | DEFERRED iter-129 to iter-130: RigidityKbar must-fix items addressed by parallel writer pass; iter-130 mandatory blueprint-reviewer will green-light |

## Fallback if no user response

Iter-129 escalation channel is empty (no TO_USER banner needed; no
user-facing blocker materialised). If `USER_HINTS.md` is still empty at
iter-130 entry, the iter-130 plan-agent should auto-execute the iter-130
mandatory prover lane on body-swap per PROGRESS.md § "Iter-130 staged
objectives". No user input is required for iter-130 normal planning.

## Meta-pattern verdict

Per `progress-critic-iter129`'s framing: piece (i) is UNCLEAR (1 iter of
COMPLETE data; iter-129 refactor lane is structural escalation rather than
duplicate helper churn). The iter-130 prover lane on body-swap is the
next data point. If iter-130 body-swap closes, piece (i) flips to
CONVERGING (2 iters of substantive close). If iter-130 returns
PARTIAL/INCOMPLETE, the analogist's closure chain has a Mathlib gap that
the iter-129 verification did not catch — escalate.

Iter-129 is plan-only by design. This is iter-128 (prover) + iter-129
(plan) so the META-PATTERN tripwire is far from re-firing (would need
iter-130 + iter-131 + iter-132 all plan-only for the tripwire to fire
again).
