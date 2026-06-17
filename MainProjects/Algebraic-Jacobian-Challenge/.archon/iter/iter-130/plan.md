# Iter-130 (Archon canonical) plan-agent run

## Headline outcome

Iter-129 closed plan-only with a critical mathlib-analogist discovery: the
iter-128 body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`
provably computes the zero `k`-module for every consumer-class smooth
proper geometrically irreducible group scheme `G/k` with relative dim
`n ≥ 1` — kernel-clean but mathematically degenerate. The iter-130 prover
lane fires to **swap the body to Replacement (B)** (affine-chart base
change via `smooth_locally_free_omega` + `rank_kaehlerDifferential`)
per `analogies/lieAlgebra-rank-bridge.md`.

This iter is a **plan + parallel-writer + prover** iter (not plan-only):
the prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean` is GREEN-LIT
by the iter-130 blueprint-reviewer's HARD GATE check, and a same-iter
parallel blueprint-writer dispatch re-aligns `RigidityKbar.tex` § Piece (i)
prose from the iter-129 (A)-flavoured framing to Replacement (B)'s
chart-base-change framing.

## Subagent dispatches this iter (4 total)

| Wave | Subagent | Slug | Verdict | Outcome |
|---|---|---|---|---|
| 1 (parallel) | `strategy-critic` | iter130 | CHALLENGE (5 must-fix + 3 alternatives + 2 SOUND M1/M3) | All 5 must-fix addressed via STRATEGY.md edits + prover directive acceptance test + parallel writer (see "Response to critics" below) |
| 1 (parallel) | `blueprint-reviewer` | iter130 | 1 must-fix on `RigidityKbar.tex` § Piece (i); HARD GATE GREEN-LIGHT for prover with parallel writer | Must-fix absorbed via Wave-2 writer dispatch this iter |
| 1 (parallel) | `progress-critic` | iter130 | 3 UNCLEAR (Route 1 fresh-with-correction-cycle; Routes 2/3 deferred-by-design) | Proceed with iter-130 prover lane; mandatory acceptance test added to prover directive |
| 2 (parallel-with-prover) | `blueprint-writer` | rigiditykbar-piecei-realign-iter130 | COMPLETE | `RigidityKbar.tex` § Piece (i) re-aligned to Replacement (B): `lem:GrpObj_cotangentSpace` proof rewritten; `lem:GrpObj_cotangent_bridge` marked `\notready` + LHS hedged + "tautological" dropped; `lem:GrpObj_lieAlgebra_finrank` proof gained iter-130 closure-path note with 4 verified Mathlib names |

## Response to critics

### `strategy-critic-iter130` → CHALLENGE — addressed

| Critic finding | Adoption status |
|---|---|
| Q1: Sunk-cost ground (i) in over-k re-defense ("iter-128 prover lane closed lieAlgebra kernel-clean" as positive evidence for over-k tractability) — empty evidence given iter-129 analogist's degeneracy verdict | **ADOPTED**: STRATEGY.md § "Over-k re-defense on revised numbers" — ground (i) STRUCK with explicit `~~strikethrough~~` and rationale. Remaining grounds (ii) cleanliness + (iii) auto-revert trigger now explicitly carry the over-k commitment alone. |
| Q2: Replacement (B) vs (A) decision should be re-opened (piece (i.b) shear-iso names cotangent at identity as fibre object; (B)'s chart-dependent fibre may require a (B)→canonical bridge that resurfaces the bridge cost (B) was supposed to avoid) | **PARTIALLY ADOPTED**: STRATEGY.md § "Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned" — Q2 deferred-bridge concern documented; trigger (a') strengthened to also fire if piece-(i.b) closure under (B) requires inline (B)→(A) bridge (~300–600 LOC); fibre-free piece (i) reformulation added as backup trigger. The strategy does NOT re-open (B) vs (A) now (iter-129 analogist's verdict remains the active body decision; iter-130 forward motion preserved); the auto-revert wiring monitors the concern in production. |
| Q3: piece (iii) honest-LOC accounting (800–1500 LOC for scheme-level absolute Frobenius) — clean, no user-hint blanket-warrant abuse | **NO ACTION** (already SOUND per critic). |
| Q4: over-k path structurally sound (iter-128 was isolated implementation bug); CHALLENGE attaches to iter-129 body-choice (Q2 concern) | **ADOPTED** via Q2 trigger (a') strengthening above. |
| Q5: M2 closure under-counts terminal-object instance cluster on `Spec k` for `genusZeroWitness` (~200–500 LOC / 2–3 iter) + iter-130 body-swap refactor itself (~100–200 LOC) + C(k)=∅ vacuity-branch encoding (~20–50 LOC). Honest M2 closure: iter-149+ → iter-152+ to iter-172+ | **ADOPTED**: STRATEGY.md § Sequencing table — M2.b body closure row revised from "1 iter / 100–200 LOC" to "2–4 iter / 320–750 LOC"; M2 closure iter shifted 154+ → 156+; honest closure window 149+ → 152+ to 172+. |
| Alternative: "fibre-free piece (i)" reformulation (prove `Ω_{G/k}` globally free of rank n via shear iso applied to differential sheaf directly, without naming a cotangent at identity object) | **DOCUMENTED as backup option**: STRATEGY.md § Q2 trigger entry. Activation trigger: iter-131+ piece (i.b) closure fails under both (B) AND (A); dispatch mathlib-analogist on fibre-free reformulation before iter-132 prover work. NOT activated this iter. |
| Alternative: Formally-unramified path replaces Frobenius iteration for piece (iii) | **NOT ADOPTED** (critic flagged speculative; iter-126/127/128 analogists committed Option A Frobenius; alternative would require its own analogist consult. Recorded informational; no active trigger). |
| Alternative: ℙ¹-specific rigidity hedge for C(k) ≠ ∅ branch | **ALREADY DOCUMENTED** in STRATEGY.md § "C(k) ≠ ∅ branch ℙ¹-specific rigidity hedge"; activation trigger (pile exceeds 2000 LOC at iter-145+) preserved. |
| Verification request: `Module.Free.tensorProduct` + `Module.finrank_baseChange` exist in the ring-changing form needed by Replacement (B) | **VERIFIED iter-130** by plan-agent `lean_loogle` / `lean_leansearch`: `Module.finrank_baseChange` exact match in `Mathlib.LinearAlgebra.Dimension.Constructions`; `Algebra.TensorProduct.instFree` in `Mathlib.RingTheory.TensorProduct.Free` is the canonical Mathlib name for the Free-side requirement. Closure chain for Replacement (B) is now `[verified]` end-to-end. Recorded in PROGRESS.md "Mathlib name tags" + the parallel blueprint-writer chapter prose. |

### `blueprint-reviewer-iter130` → 1 must-fix absorbed; HARD GATE GREEN

The reviewer's must-fix: `RigidityKbar.tex` § Piece (i) (lines 92–161) frames the iter-128 body as the canonical realisation of `η_G^* Ω_{G/k}` and the bridge lemma as "tautological" — both wrong under the iter-129 analogist's degeneracy verdict. The reviewer explicitly recommends GREEN-LIGHT for the iter-130 prover lane on body swap, in parallel with a same-iter blueprint-writer to re-align Piece (i) prose to Replacement (B). **Adopted verbatim**: Wave-2 blueprint-writer dispatched this iter (slug `rigiditykbar-piecei-realign-iter130`); writer returned COMPLETE with the prose now aligned to Replacement (B); HARD GATE is green for the prover lane on `Cotangent/GrpObj.lean`.

Reviewer's "soon" items (stale line refs in `Jacobian.tex:398/410`, `AbelJacobi.tex` Galois-descent residuals, `kbar` → `k` rename) — recorded for iter-131+ low-priority cleanup; not blocking.

### `progress-critic-iter130` → 3 UNCLEAR (proceed); acceptance test required

The critic UNCLEAR on Route 1 (`cotangentSpaceAtIdentity`): sorry-count metric is non-informative because the body went from "vacuous-but-kernel-clean" to "about-to-be-replaced". Both other routes deferred-by-design. Critic explicitly green-lights iter-130 prover dispatch with a **standing watch** for second-vacuous-close failure mode.

**Acceptance test absorbed verbatim into PROGRESS.md prover directive**: the body MUST reference `smooth_locally_free_omega` AND `Algebra.IsStandardSmoothOfRelativeDimension` (or one of its rank/freeness consequences); a close in ≤30 LOC using only `simp` / `rfl` / `Classical.choice` is a regression and must be rejected as PARTIAL. Watch signatures for accidental vacuity: simp-only collapse to 0; ≤50 LOC body despite 200–400 LOC budget; "trivial"/"unexpectedly easy" prover self-report. If any fire, iter-131 verdict shifts to CHURNING and a mathlib-analogist consult on Replacement (B) construction itself must dispatch before iter-131 prover work.

META-PATTERN: iter-127 plan / iter-128 prover / iter-129 plan / iter-130 prover. Critic explicitly verdict: healthy correction-cycle alternation, not stuck loop. Would only flip to CHURNING if iter-130 again produces vacuous body and iter-131 must again be plan-only repair (second cycle in a row).

## Lean Mathlib name verifications this iter (plan-agent direct)

Two `[expected]` names from `analogies/lieAlgebra-rank-bridge.md` were upgraded to `[verified]` via `lean_loogle` / `lean_leansearch`:

- `Module.finrank_baseChange` — exact match in `Mathlib.LinearAlgebra.Dimension.Constructions`. Signature: `∀ {R S M'} [Semiring R] [CommSemiring S] [...] [Algebra S R], Module.finrank R (TensorProduct S R M') = Module.finrank S M'`. Perfect fit for the iter-130 rank-lemma closure step.
- `Module.Free.tensorProduct` — exact name not found; canonical Mathlib equivalent is `Algebra.TensorProduct.instFree` in `Mathlib.RingTheory.TensorProduct.Free` (instance form: `∀ R A M [...], Module.Free A (TensorProduct R A M)`). The companion `Module.Free.tensor` instance in `Mathlib.LinearAlgebra.TensorProduct.Basis` also works. Either supplies the Free-side typeclass automatically; the rank-lemma prover lane can rely on instance synthesis.

The PHANTOM call on `Scheme.frobenius` / `Scheme.absoluteFrobenius` was re-verified: `lean_loogle` / `lean_leansearch` return only `WittVector.frobenius`, `Mathlib.Algebra.CharP.Lemmas.frobenius`, `Mathlib.Algebra.CharP.Frobenius.frobenius_def`. The strategy's iter-128 honest-LOC accounting for piece (iii) (800–1500 LOC because the project must build scheme-level absolute Frobenius from scratch) remains correct.

## STRATEGY.md edits this iter

3 substantive edits, all in response to `strategy-critic-iter130`:

1. **§ "Over-k re-defense on revised numbers"** — ground (i) STRUCK (sunk-cost; iter-128 close is mathematically wrong, not validation evidence). Remaining grounds (ii) cleanliness + (iii) auto-revert trigger now explicitly carry the over-k commitment alone. Phrasing updated to make clear that future iters MUST NOT cite the iter-128 close as evidence of tractability.

2. **§ "Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned"** — extended with iter-130 Q2 deferred-bridge concern. Trigger (a') strengthened to also fire on inline (B)→(A) bridge cost in piece (i.b). Fibre-free piece (i) reformulation added as backup option with explicit activation trigger.

3. **§ Sequencing table** — M2.b body closure row revised from "1 iter / 100–200 LOC" to "2–4 iter / 320–750 LOC" (terminal-object instance cluster on `Spec k` + C(k)=∅ vacuity-branch encoding). M2 closure iter shifted 154+ → 156+. Honest M2 closure window updated 149+ → 152+ to 172+.

## PROGRESS.md edits this iter

- ## Current Objectives now contains exactly one prover-touch file: `AlgebraicJacobian/Cotangent/GrpObj.lean`. The body-swap directive references the analogist file for the body sketch + Mathlib closure chain.
- The prover directive includes:
  - **Constraints** (signature preserved, off-limits files, no new axioms, no sorry-replacement of a sorry-less declaration)
  - **Docstring refresh requirement** absorbed from `lean-auditor-review129` 5 major findings: lines 28–39 file-level status block + lines 62–101 declaration docstring must be updated to describe Replacement (B), not iter-128 body. The 2 stale `Jacobian.lean` docstrings (lines 195, 226) are off-limits this iter — recorded for future refactor.
  - **Mandatory acceptance test** per `progress-critic-iter130` to rule out a second vacuous outcome
  - **Optional Wave-2** rank lemma scaffold + closure if body swap closes early

## Blueprint edits this iter (via `blueprint-writer-rigiditykbar-piecei-realign-iter130`)

Three precise edits to `blueprint/src/chapters/RigidityKbar.tex` § Piece (i):

- `proof of lem:GrpObj_cotangentSpace` (lines 112–120): rewritten to describe Replacement (B) chart-base-change body with canonicity caveat. New prose names `\cref{thm:smooth_locally_free_omega}` as the source of the affine chart, states the definition $\mathfrak g^\vee := k \otimes_{\Gamma(G, V)} \Omega_{\Gamma(G,V)/\Gamma(\Spec k, U)}$, cites `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` for rank, and adds an emph "Caveat on canonicity" paragraph forwarding to `lem:GrpObj_cotangent_bridge` as a deferred future bridge.

- `lem:GrpObj_cotangent_bridge` (lines 122–161): `\notready` added (parallel to rank lemma's `\notready`); LHS framing in statement changed from "iter-128 evaluate-then-extend-scalars Lean body" to "iter-130+ chart-base-changed Kähler Lean body"; "tautological" framing in proof body replaced with explicit acknowledgment that the bridge is non-trivial (localisation + standard $k \otimes_R \Omega_{R/k} \cong \mathfrak m/\mathfrak m^2$) at ~300–600 LOC, deferred until a non-rigidity consumer requires canonicity. Steps 1 + 2 of the proof preserved (they are the correct chain).

- `proof of lem:GrpObj_lieAlgebra_finrank` (lines 163–199): appended new emph "Iter-130 closure path under Replacement (B)" paragraph recording the iter-130 body shape `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V)/Γ(Spec k, U)])` and 4 verified Mathlib closure-chain names: `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Module.finrank_baseChange`, `Algebra.TensorProduct.instFree`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`.

(i.b)/(i.c) trio and rank-lemma statement preserved per directive scoping. Writer flagged 3 minor cleanup items for a future iter (signature-stub comments still reference iter-128 body; Step 4 cross-check prose references to "iter-128 body") — non-blocking, recorded.

## What the iter-130 prover lane will see

Single file `AlgebraicJacobian/Cotangent/GrpObj.lean` with:
- 1 declaration (`cotangentSpaceAtIdentity`), no sorries, body to be REPLACED (not filled).
- File-level Status block + declaration docstring to be REFRESHED in the same Edit.
- Read-only-aware of: `AlgebraicJacobian/Differentials.lean` (`smooth_locally_free_omega`); `analogies/lieAlgebra-rank-bridge.md` (body sketch + closure chain); `blueprint/src/chapters/RigidityKbar.tex` (post-iter-130 writer pass; Replacement-(B)-aligned).
- Mandatory acceptance test wired in the directive: body must reference both `smooth_locally_free_omega` AND `Algebra.IsStandardSmoothOfRelativeDimension`-or-consequence; vacuity signatures trigger PARTIAL.

## Risks and watch criteria for iter-131

1. **Acceptance test failure**: if the iter-130 prover close again has vacuity signatures (simp-only collapse, ≤50 LOC body, "trivial" self-report), Route 1 flips to CHURNING. iter-131 must dispatch mathlib-analogist on Replacement (B) construction itself BEFORE any further prover work.

2. **Trigger (a') strengthened**: applies iter-131+ at piece (i.b) prover lane. Two arms: (a) functorial-shear failure (revert to over-`k̄` + M2.c); (b) inline (B)→(A) bridge cost ≥300 LOC (re-open (A)-vs-(B) decision; consider fibre-free reformulation).

3. **Wave-2 rank lemma**: if iter-130 lands body swap with budget, rank-lemma scaffold + closure is natural follow-up. Verified end-to-end. Iter-131 may then proceed directly to piece (i.b) scaffold.

4. **Strategy-critic re-verification**: iter-131 strategy-critic must re-verify the 3 new STRATEGY.md claims (ground (i) struck, Q2 trigger strengthened, Q5 sequencing).

5. **META-PATTERN**: iter-127 plan / iter-128 prover / iter-129 plan / iter-130 prover. Per progress-critic, this is healthy. Would only flip to CHURNING if iter-130 produces another vacuous body and iter-131 again plan-only on same declaration (second cycle in a row).

## Out of scope this iter (recorded for iter-131+)

- `AlgebraicJacobian/Jacobian.lean` lines 195 + 226 docstring "single remaining sorry" stale phrasing (lean-auditor-review129 majors #4–#5). Will clean in next refactor lane that touches Jacobian.lean.
- `RigidityKbar.tex` `kbar` → `k` rename (cleanup, deferred since iter-127).
- `Jacobian.tex:398/410` stale line refs (cleanup, deferred since iter-129).
- `AbelJacobi.tex` § "Galois descent" residual mentions (lines 82 + 87), non-load-bearing per iter-127 over-k commitment.
- Writer's 3 minor flags from this iter's report (signature-stub comments + Step 4 cross-check phrasing). Non-blocking; cleanup pass when convenient.

## Fallback if no user response

Iter-130 does NOT raise a user-escalation banner. `TO_USER.md` is the
review agent's domain and will not be written by plan. USER_HINTS.md
remains empty. The autonomous loop proceeds without user input required.

If iter-130 prover lane fails the acceptance test (vacuity regression):
iter-131 plan agent (without user input) must dispatch mathlib-analogist
on Replacement (B) construction itself + defer the piece-(i.b) scaffold;
the loop continues on the M2 critical path with corrective signal from
the analogist. No user input is required for that fallback.

If iter-130 prover lane succeeds AND Wave-2 rank lemma scaffolds:
iter-131 plan agent (without user input) green-lights piece (i.b) scaffold
(`mulRight_globalises_cotangent`); the loop continues on the M2 critical
path.
