# Session 129 — iter-129 review

## Metadata

- **Archon iteration**: 129 (= session_129)
- **Iteration shape**: plan-phase-only by design; no prover dispatch (`planValidate.status: ok_intentional_skip / objectives: 0`; `prover.durationSecs: 0`; `plan.durationSecs: 3415 s ≈ 57 min`).
- **Sorry count before (iter-128 close)**: 3 (`Jacobian.lean:174`, `Jacobian.lean:194`, `RigidityKbar.lean:87`).
- **Sorry count after (iter-129 close)**: 3 (`Jacobian.lean:188`, `Jacobian.lean:208`, `RigidityKbar.lean:75`).
- **Net change**: 0. Refactor lane was signature/header-only; line numbers shifted because of header expansion in `Jacobian.lean` and chapter rename in `Cotangent/GrpObj.lean`.
- **Targets attempted**: none directly (no prover). Refactor lane updated `Cotangent/GrpObj.lean` (signature + docstring) and `Jacobian.lean` (file header).
- **Compile-verified at close**: yes (`lake build`: 8330/8330 jobs; only carry-over sorry warnings + 2 pre-existing long-line linter warnings).
- **`lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`**: kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`). No `sorryAx`. No named axioms.
- **`attempts_raw.jsonl`**: present but stale (timestamps `2026-05-17T12:29–12:42Z` predate iter-129 start at `13:09Z`; events describe the iter-128 prover lane closure of `lieAlgebra`. Iter-129 itself ran no prover.) Treat as iter-128 carry-over; no `code_change` events apply to a session-129 target.

## Session-level scope

Iter-129 was a fix-up + audit iter, not a proof-filling iter:

1. **Refactor lane** (`refactor-cotangent-grpobj-fixup-iter129`) addressed three iter-128 review must-fix items in one bundle:
   - rename `AlgebraicGeometry.GrpObj.lieAlgebra` → `cotangentSpaceAtIdentity` (body-vs-docstring convention mismatch);
   - relax `[SmoothOfRelativeDimension 1 G.hom]` → `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` (hardcoded dim-1 unsuitable for downstream `rigidity_over_kbar` consumer at arbitrary rel-dim `g`);
   - rewrite `Jacobian.lean` file header to enumerate the two `sorry`-bodied declarations (was "single remaining sorry" — stale since iter-127 added `genusZeroWitness`).
2. **Two blueprint-writer lanes** (parallel):
   - `blueprint-writer-rigiditykbar-iter129` rewrote `RigidityKbar.tex` with the matching lemma rename, an added bridge lemma `lem:GrpObj_cotangent_bridge`, a 4-step Mathlib-anchored rank-lemma proof, and corrected `Ideal.IsLocalRing.CotangentSpace` everywhere (the previously-cited `IsRegularLocalRing.cotangentSpace` was phantom).
   - `blueprint-writer-orphan-chapters-iter129` deleted 4 orphan chapters (522 lines): `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`. Blueprint chapter count 14 → 10. Retained chapters have zero dangling cross-references.
3. **Mathlib-analogist lane** (`mathlib-analogist-lieAlgebra-rank-bridge-iter129`) made the critical iter-129 discovery — see § "Critical iter-129 discovery" below.
4. **3 mandatory plan-phase critics + 3 review-phase audits** ran:
   - Plan-phase: strategy-critic (5 must-fix, all addressed); blueprint-reviewer (3 must-fix, all addressed); progress-critic (3 UNCLEAR, 0 CHURNING/STUCK).
   - Review-phase: `lean-auditor-review129` (0 must-fix; 5 major; 1 minor); `lean-vs-blueprint-checker-cotangent-grpobj-review129`; `lean-vs-blueprint-checker-jacobian-review129`. See recommendations.md.

## Critical iter-129 discovery (mathlib-analogist)

The iter-128 body of `cotangentSpaceAtIdentity` (formerly `lieAlgebra`)
**computes the zero `k`-module** for every smooth proper geometrically
irreducible group scheme `G/k` with relative dimension `n ≥ 1`, i.e.
for every consumer in the target class. The rank lemma
`finrank cotangentSpaceAtIdentity = n` is therefore **provably FALSE
as stated** against this body for `n ≥ 1`.

5-step diagnostic (full detail in `analogies/lieAlgebra-rank-bridge.md`):

1. `(relativeDifferentialsPresheaf G.hom).obj (op ⊤) = CommRingCat.KaehlerDifferential (φ'.app (op ⊤))` by `relativeDifferentials'_obj` (rfl).
2. `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op ⊤)` is a colimit over `{V : Opens(Spec k) | f.base(⊤) ⊆ V}`. Because `Spec k` is single-point (only opens are `∅` and `⊤`), the indexing diagram is `{V = ⊤}` and the colimit collapses to `Γ(Spec k, ⊤) ≅ k`.
3. Smooth + proper + geometrically irreducible ⇒ geometrically integral ⇒ `Γ(G, ⊤) = k` (Stacks 0BUG / Hartshorne III.10.7; in Mathlib via `AlgebraicGeometry.isField_of_universallyClosed` + geom-irreducibility).
4. So `φ'.app (op ⊤) : k → k`, the structure map. By `KaehlerDifferential.subsingleton_of_surjective`, `Ω[k/k] = 0`.
5. `(ModuleCat.extendScalars ψ.hom).obj 0 = 0` (`k`-module zero).

This is exactly the presheaf-vs-sheaf coincidence cost the
strategy-critic-iter129 raised abstractly under its M2 CHALLENGE "hidden
presheaf-vs-sheaf bridge re-enters via the deferred rank lemma" — the
mathlib-analogist sharpened it from a "bridge cost" warning to a
"vacuity claim" with a Mathlib-named diagnostic chain.

**Resolution**: the iter-130 mandatory prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` will swap the body to
**Replacement (B)** (affine-chart base change): extract `V ∋ η(pt)` via
`smooth_locally_free_omega`; build `ψ_V : Γ(G, V) ⟶ k` from the
identity section restricted to `V`; define body as
`(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`.
Estimated 200–400 LOC; 1–2 prover iters.

Replacement (A) (stalk-side `IsLocalRing.CotangentSpace`, 500–1000 LOC,
canonical) and Replacement (C) (sheafified `Ω`, 800–2000 LOC, full
Mathlib-aligned) are deferred indefinitely — the rigidity-over-`k̄`
consumer only needs existence of a rank-`n` `k`-module.

## Per-target analysis (no prover this iter)

### Target: `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (file `AlgebraicJacobian/Cotangent/GrpObj.lean`)

- **Status**: refactored this iter (rename + signature relax); body unchanged.
- **No prover attempts.** Refactor agent performed a single Edit on the declaration line + docstring rewrite; `lake build` ✓; `lean_verify` ✓ kernel-only.
- **Critical context (out of band)**: the body is mathematically degenerate per the parallel mathlib-analogist. The Lean checks; the math is vacuous. iter-130 must swap.
- **Insight**: kernel-clean does not imply mathematically correct. A definition whose body type-checks can still encode the zero object when the math claims rank `n`. This is the iter-129 soundness lesson; folded into `PROJECT_STATUS.md § Knowledge Base` as pattern #3 (see below).

### Target: `AlgebraicGeometry.genusZeroWitness` (file `AlgebraicJacobian/Jacobian.lean:188`)

- **Status**: untouched. Iter-127 scaffold sorry; body closure gated on iter-138+ (`rigidity_over_kbar` body landing + downstream Albanese-witness packaging).
- **No prover attempts this iter.**

### Target: `AlgebraicGeometry.nonempty_jacobianWitness` (file `AlgebraicJacobian/Jacobian.lean:208`)

- **Status**: untouched. Phase-C OFF-LIMITS; gated on M2 + M3 closure (iter-148+).
- **No prover attempts this iter.**

### Target: `AlgebraicGeometry.rigidity_over_kbar` (file `AlgebraicJacobian/RigidityKbar.lean:75`)

- **Status**: untouched. Iter-126 scaffold sorry; body closure gated on iter-144+ (shared cotangent-vanishing pile pieces (i)+(ii)+(iii)).
- **No prover attempts this iter.** The iter-129 mathlib-analogist's critical finding pushes piece (i) closure 1–2 iters later than the iter-128 framing assumed (body swap + rank lemma must close before the consumer enters; revised honest ETA iter-144+ → iter-145+, but still inside the broad iter-149+ M2 closure envelope per STRATEGY.md).

## Key findings / proof patterns discovered

1. **Presheaf-pullback at top open of `Spec k` collapses to `k`**. The pointwise left Kan extension `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op ⊤)` is a colimit over `{V : Opens(Spec k) | f.base(⊤) ⊆ V}`. Because `Spec k` is single-point, the indexing diagram is a singleton and the colimit collapses to `Γ(Spec k, ⊤) ≅ k`. **Consequence**: evaluating a presheaf-of-modules pullback along a `Spec k → X` morphism at the top open of `X` loses all information except the `k`-side structure map. Anyone using `relativeDifferentialsPresheaf` at the top open over `k` must either (a) descend to an affine chart (Replacement B), (b) work stalk-side (Replacement A), or (c) sheafify first (Replacement C).
2. **Kernel-clean ≠ mathematically correct**. `lean_verify` returning kernel-only axioms certifies the proof uses only allowed axioms; it does NOT certify the statement is mathematical content. The iter-128 body of `cotangentSpaceAtIdentity` is kernel-clean but produces zero. Lesson: a `mathlib-analogist` consult is mandatory when a new declaration's construction differs structurally from the blueprint's proof sketch (here: evaluate-then-extend-scalars vs `𝔪/𝔪²` stalk presentation), even if the Lean body type-checks.
3. **`Ideal.IsLocalRing.CotangentSpace` is the verified Mathlib name** — defined as `(maximalIdeal R).Cotangent` in `Mathlib.RingTheory.Ideal.Cotangent`. The name `IsRegularLocalRing.cotangentSpace` (which strategy + blueprint prose referenced) does NOT exist in `b80f227`. Replace future references.

## Blueprint markers updated (manual)

None this iter. The blueprint-writer-rigiditykbar-iter129 dispatch handled all `\lean{...}` macro renames as part of its writer-domain work (`AlgebraicGeometry.GrpObj.lieAlgebra` → `cotangentSpaceAtIdentity`; new hints `cotangentSpaceAtIdentity_iso_localRingCotangent`, `cotangentSpaceAtIdentity_finrank_eq`). No new `\mathlibok` candidates (the renamed declaration is still project-internal content with a non-Mathlib body). No `% NOTE` annotations added by me. No `\notready` strips needed by me.

The deterministic `sync_leanok` phase handles `\leanok` markers; its commit (if any) is recorded separately as `archon[129/marker-sync]`.

## Review-phase audit results (incorporated into recommendations.md)

- **`lean-auditor-review129`** (`.archon/task_results/lean-auditor-review129.md`): **0 must-fix**, **5 major** (all docstring-drift items in `Cotangent/GrpObj.lean` and `Jacobian.lean` — the rank-`n` claim in the cotangent docstring is now stale per the analogist's degeneracy finding; the "single remaining sorry" prose in two `Jacobian.lean` per-declaration docstrings was missed by the iter-129 header rewrite), **1 minor** (residual dualisation paragraph in `Cotangent/GrpObj.lean:73–77` that the iter-129 docstring rewrite didn't fully strip).
- **`lean-vs-blueprint-checker-cotangent-grpobj-review129`** (`.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review129.md`): **0 must-fix**, **1 major**, **2 minor**. Lean signature matches the blueprint stub verbatim; body construction matches prose recipe; no `sorry` / placeholder / excuse-comment / axiom. The major finding (per the directive's explicit "flag this drift" instruction) is that the chapter prose frames the iter-128 body as the canonically-correct realisation of `η_G^* Ω_{G/k}` and the new bridge lemma as a tautological identification — both positively wrong if the iter-128 body is degenerate. Minor: Lean docstring missing the bridge-lemma forward-reference; bridge lemma has no `\notready` marker.
- **`lean-vs-blueprint-checker-jacobian-review129`** (`.archon/task_results/lean-vs-blueprint-checker-jacobian-review129.md`): **0 must-fix**, **0 major**, **2 minor** (stale line references in `Jacobian.tex:398/410` pointing at pre-iter-129-header file positions). PASS overall.

## Recommendations for next session (iter-130)

See `recommendations.md` for full detail. Headline:
- **MANDATORY iter-130 prover lane**: swap `cotangentSpaceAtIdentity` body to Replacement (B). Per analogist's named Mathlib closure chain.
- **HARD GATE**: iter-130 mandatory `blueprint-reviewer` must green-light first (the iter-129 RigidityKbar writer pass addressed the iter-128 blocking items; the writer's caveat about Replacement-A-vs-B framing in the bridge lemma may need a minor iter-130 chapter alignment, but this is non-blocking for the body swap itself).
- **Concurrent docstring refresh** (lean-auditor majors): refresh `Cotangent/GrpObj.lean` line 28 / 70 / 99 + `Jacobian.lean` line 195 / 226 docstrings as part of the body-swap refactor, so a fresh reader doesn't take stale rank-`n` / "single remaining sorry" claims at face value.
- **Iter-129 fallback rule does NOT trigger** (its condition was iter-128 INCOMPLETE; iter-128 was COMPLETE per the kernel-clean test, regardless of math-content degeneracy that the iter-129 analogist uncovered later).
