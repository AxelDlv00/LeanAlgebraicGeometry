# Strategy Critic Report

## Slug
iter016

## Iteration
016

## Routes audited

### Route: FBC (affine lemma + globalization)

- **Goal-alignment**: PASS — proves `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`, the named goal nodes.
- **Mathematical soundness**: PASS — direct-on-sections (Stacks 02KH part 2) through the proved tilde dictionaries + `regroupEquiv` is the right cohomology-free route; the H⁰-as-equalizer globalization with flat `−⊗B` preserving the degree-0/1 sheaf equalizer is correct (flat preserves finite kernels).
- **Sunk-cost reasoning detected**: no — but see wording note below.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none — `Module.Flat.ker_lTensor_eq` VERIFIED (`Mathlib.RingTheory.Flat.Equalizer`).
- **Effort honesty**: reasonable (optimistic low end) — Seam 2 is the live risk (see below); 1–3 honestly brackets it.
- **Verdict**: SOUND

One internal-consistency wrinkle the planner should tidy (not a soundness defect): the Routes prose says all three seams "are **conjugate-adjunction unit coherences** with a Mathlib idiom after all" (`unit_conjugateEquiv_symm`), then immediately says "**Seam 2 (`fstar_reindex`) is a different construction** — the generic-pullback-square pseudofunctor reindex … NOT an adjunction-unit identity." Those two framings of Seam 2 contradict each other. Since Seam 2 is the only open construction-level item on the live FBC frontier (Seam 1 closed; Seams 2→3 cascade the four already-proved-mod-Seam-3 lemmas), the planner should state unambiguously which calculus Seam 2 actually uses — the 1–3 estimate hinges on whether it inherits Seam 1's idiom or is a genuinely new reindex.

### Route: GF (algebraic core + geometric wrapper)

- **Goal-alignment**: PASS — `genericFlatnessAlgebraic` + re-signed `genericFlatness` are the goal nodes.
- **Mathematical soundness**: PASS — the Nitsure §4 induction on variable count `d` with the base domain `A` reverted into the `Nat.strong_induction_on` motive is the correct dévissage; the observation that the reindex changes the base ring to `A_g` (so the IH must be stated at an arbitrary base domain) is exactly right and is the standard subtlety of this proof.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none flagged (the single-variable Nagata elimination engine is new *project* material, honestly listed under Mathlib gaps, not assumed-in-Mathlib).
- **Effort honesty**: reasonable but most optimistic of the three — the surviving residue `lem:gf_polynomial_core` (L5) **is** the heart of generic flatness, and 1 iter for it is aggressive; the 3-iter upper bound is the honest figure. Supporting atoms (`gf_torsion_reindex` closed, generic-rank SES recipe, elimination-engine spec) genuinely de-risk it.
- **Verdict**: SOUND

### Route: QUOT-defs (functor / Grassmannian / predicates)

- **Goal-alignment**: PASS — `def:quot_functor`, `def:grassmannian_scheme`, predicates; `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`.
- **Mathematical soundness**: PASS — P1 done axiom-clean via `IdealSheafData.ofIdeals`/`.subscheme`; P2 rank-`r` local-freeness predicate is a clean next step.
- **Infrastructure-deferral detected**: yes — `lem:qcoh_section_localization_basicOpen` (the QCoh→`IsLocalizedModule` basic-open bridge, gated on `isIso_fromTildeΓ_of_isQuasicoherent`). **Required by goal: yes** (its only consumer is QUOT-repr's universal-property support check, and `thm:grassmannian_representable` is a goal node). **But it is an accepted dependency, not avoidance**: the strategy gives a concrete project-side route (try the LOCAL derivation from `tildeRestriction_isLocalizedModule` + cover-local presentation + sheaf condition *before* the heavy global sub-build, gated by a bounded existence search) and a timeline (bundled inside the QUOT-repr 6–12 iter estimate), and the P2 predicate chain proceeds independently. The deferral is sequencing-justified because the consumer phase is itself BLOCKED and far out.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND — but the "**OFF the current critical path; defer it**" framing understates that the bridge *is* on the goal's critical path (via QUOT-repr). Keep it tracked, not lost.

### Route: SNAP / QUOT graded-rationality (Route 2 — the focus this iter)

This block splits into S2 (the pivoted rationality engine) and S1 (the f.g.-input pinning), which differ in soundness.

**S2 — Route 2 ambient subquotient induction** (the pivot):

- **Goal-alignment**: PASS — yields `gradedModule_hilbertSeries_rational`, feeding `existsUnique_hilbertPoly` to extract `Φ_s`.
- **Mathematical soundness**: PASS — I checked it against the verbatim Stacks 00K1 proof (`hilbert-serre-algebra.tex` L13907–13948) and it is a **sound, and in fact cleaner, realization**:
  - *ker/coker closure*: for a subquotient `N/N'` of the fixed ambient `M` and degree-1 endo `x`, `ker = (N ⊓ x⁻¹(N'))/N'` and `coker = N/(N'+x·N)` — both ambient subquotient pairs, both annihilated by `x` (so both live in the (r−1)-endo IH domain), and both preserved by the remaining endos `t_i` (since `t_i` commutes with `x`: `t_i(x⁻¹N') ⊆ x⁻¹N'`, `t_i(x·N) ⊆ x·N`). Verified.
  - *(⊤,⊥) recovers `dim_κ Mₙ`*: `hilb(n) = finrank(⊤⊓ℳn) − finrank(⊥⊓ℳn) = finrank(ℳn)`. Verified.
  - *degreewise difference D6*: the 4-term degreewise exact sequence `0→(ker x)_n→ℳn→ℳ(n+1)→(coker x)_{n+1}→0` gives `dim ℳ(n+1) − dim ℳn = dim coker_{n+1} − dim ker_n`, i.e. `hilb_M(n+1)−hilb_M(n) = hilb_C(n+1)−hilb_K(n)` — the analog of Stacks 00JZ via the landed `IsRatHilb.ofDiffEq`. **Notably this avoids the Stacks nilpotent / non-nilpotent case split entirely** (Stacks reduces to `x` injective and uses a 3-term SES; Route 2's 4-term sequence with both `ker` and `coker` as IH objects subsumes both cases). Sound and simpler.
  - *base `r=0`*: `M` f.g. over `κ` ⇒ finite-dim ⇒ `hilb` eventually 0 ⇒ `IsRatHilb.ofEventuallyZero`. Matches Stacks base case.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — and critically, this is a **genuine pivot, not a renamed problem**. The hardest prerequisite of the dropped route (a `DirectSum.Decomposition` on a quotient/subtype carrier → the `coeAddMonoidHom` whnf runaway) is *structurally eliminated*, not relocated: every object Route 2 forms has the shape `Naux ⊓ ℳn` (a submodule of the fixed ambient `M`), exactly the family G1 already proved safe. The pivot passes the "same-hardest-prerequisite" avoidance test.
- **Hidden hypotheses (directive question)**: all accounted — finite-dim components and a `Module.Finite` witness are carried in `SubquotientHilb`; the `r` degree-1 endos come from a κ-basis of `R₁` (legitimate since `S₊` generated in degree 1 ⇒ generated by `S₁`); the f.g.-down-a-generator transfer uses `Submodule.FG.restrictScalars_of_surjective` (VERIFIED) + `Module.Finite.quotient`. No missing hypothesis found.
- **Phantom prerequisites**: none — `Submodule.FG.restrictScalars_of_surjective`, `DirectSum.Decomposition.ofLinearMap` (fallback), `Polynomial.existsUnique_hilbertPoly` (`[CharZero]` as noted) all VERIFIED.
- **Effort honesty**: reasonable — 6 new lemma-groups (data, closure, D6, FG transfer, P(r), (⊤,⊥) bridge) over 2–3 iters with G1/D5/`IsRatHilb` landed; consistent with realized velocity of comparable Completed rows (~150–280 LOC). Optimistic only in that the homogeneity-preservation proofs (`N⊓x⁻¹N'`, `N'+x·N`) and the induction wiring are fiddly; 2–4 would be safer but the range is honest.
- **Verdict**: SOUND

**S1 — f.g.-graded-module input / cohomology-freeness pinning**:

- **Goal-alignment**: PARTIAL — the goal object `def:hilbert_polynomial` is *defined* via `m ↦ dim_{κ(s)} Γ(X_s, F_s⊗L_s^m)`, so the pinning to `M := im(S^N → ⊕Γ)` is only legitimate if `dim_κ M_m = dim_κ Γ(F_s⊗L_s^m)` for `m≫0`.
- **Mathematical soundness**: PARTIAL — the equality is *asserted* ("`dim_κ M_m = dim_κ Γ … for m≫0`, pinning to M is legitimate") but the supporting fact is not named. The honest justification is Serre finite-generation of `Γ_*(F)` for coherent `F` (Hartshorne II.5.17) — which, chosen with `N` covering a generating set, makes `M = Γ_*` outright (so the equality holds in all degrees, not just `m≫0`). That II.5.17 lives in Hartshorne **chapter II, before cohomology**, so the route *is* plausibly Čech-independent — but the strategy's stated justification ("f.g. … by Noetherian descent from `S^N`") is loose and does not establish the `M_m = Γ_m` equality on its own. A fresh reader cannot tell from the prose whether the cohomology-free finite-generation input has actually been secured or smuggles in Serre vanishing.
- **Verdict**: CHALLENGE — name the cohomology-free finite-generation lemma (`lem:sectionGradedModule_fg` = Serre II.5.17, ch-II) that yields `dim M_m = dim Γ(F_s⊗L_s^m)` for `m≫0`, and state explicitly why it does not re-introduce `H¹`. This is on the goal's critical path (the goal object is defined via `Γ`, not `M`) and is currently a "step needs X, X not established" gap.

### Route: QUOT-repr (`thm:grassmannian_representable`)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — decomposed (GR-cells done; GR-glue/quot/repr) with RelativeSpec strengthened to `RepresentableBy` via `representableByEquiv` (VERIFIED, `Mathlib.CategoryTheory.Yoneda`).
- **Infrastructure-deferral detected**: no — honestly marked BLOCKED with a wide 6–12 iter / ~400–1000+ LOC estimate and a concrete sub-phase decomposition; this is appropriate for the deepest target, not stagnation.
- **Effort honesty**: reasonable for a BLOCKED deep target.
- **Verdict**: SOUND

## Format compliance

- **Size**: 196 lines / 18,494 bytes — **over budget** (~12 KB ceiling; the file is ~50% over on bytes despite being under the line cap, due to long multi-clause table cells and dense Routes prose).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order; `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: yes — pervasive in prose and table cells, e.g. `"Seam 1 (unit_value) CLOSED iter-014"`, `"**PIVOT iter-016**"`, `"D5 landed iter-015"`, `"**G2/G3/G4 … DROPPED iter-016**"`, `"**Decision (iter-014): take the STRENGTHEN route**"`, `"reaffirmed iter-014"`. (~10 sites; the `## Completed` table's `Iters` cells like `011 · 4` are the allowed ledger form and are fine.)
- **Accumulation detected**: no — completed phases are in `## Completed`, the table is 4 rows (within bound), no excised routes linger.
- **Table discipline**: PASS — both tables well-formed with the required columns; `Status` uses inline tags; cells are long but tabular.
- **Format verdict**: DRIFTED

The skeleton is intact, so this is DRIFTED rather than NON-COMPLIANT — but it is a *material* drift: 50%-over byte budget plus pervasive iter-narrative. Both are fixable in-place this iter by converting iter-stamped prose to present-tense status (`"Seam 1 CLOSED"`, `"G2/G3/G4 DROPPED — Route 2 supersedes"`) and tightening the risk/Routes cells. The iter stamps carry no strategic content a fresh reader needs.

## Infrastructure-deferral findings

### Deferred: `lem:qcoh_section_localization_basicOpen` (QCoh→`IsLocalizedModule` basic-open bridge)

- **Required by goal**: yes — sole consumer is QUOT-repr's support check, and `thm:grassmannian_representable` is a goal node.
- **Current plan for building it**: concrete — LOCAL derivation from `tildeRestriction_isLocalizedModule` + cover-local presentation + sheaf condition, attempted before the heavy global `isIso_fromTildeΓ_of_isQuasicoherent`; choice gated by a bounded existence search.
- **Timeline**: concrete-ish — bundled into the QUOT-repr 6–12 iter estimate; P2 predicate chain proceeds independently meanwhile.
- **Verdict**: CHALLENGE (mild / accepted-dependency) — this clears the rubric's bar for an accepted dependency (plan + timeline + independent progress elsewhere), so it does **not** require building this iter. The only ask: drop the "OFF the critical path" phrasing, which is true only relative to the current frontier, not relative to the goal.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`; requires `[CharZero F]`, as the strategy states).
- `Submodule.FG.restrictScalars_of_surjective`: VERIFIED (`Mathlib.RingTheory.Finiteness.Basic`).
- `DirectSum.Decomposition.ofLinearMap`: VERIFIED (`Mathlib.Algebra.DirectSum.Decomposition`; the documented Route-1 fallback).
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib.RingTheory.Flat.Equalizer`).
- `CategoryTheory.Functor.representableByEquiv`: VERIFIED (`Mathlib.CategoryTheory.Yoneda`) — confirms the RelativeSpec-strengthen route.

## Must-fix-this-iter

- Route SNAP-S1: CHALLENGE — name the cohomology-free finite-generation lemma establishing `dim_κ M_m = dim_κ Γ(F_s⊗L_s^m)` for `m≫0` (Serre/Hartshorne II.5.17, chapter II), and state why pinning to `M` does not re-admit `H¹`. The goal object is defined via `Γ`, so this equality is load-bearing and currently only asserted.
- Format: DRIFTED → fix in-place — (1) trim to ≤ ~12 KB (currently 18.5 KB) by tightening the long risk/Routes cells; (2) scrub the ~10 per-iter-narrative sites (`CLOSED iter-014`, `PIVOT iter-016`, `landed iter-015`, `DROPPED iter-016`, `Decision (iter-014)`, `reaffirmed iter-014`) to present-tense status. Iter history belongs in `iter/iter-NNN/plan.md`.
- Route QUOT-defs (minor): reword the qcoh-bridge "OFF the current critical path; defer it" to acknowledge it is goal-required (via QUOT-repr) and merely deferred in sequencing — it has an accepted plan + timeline, so no build is required this iter.
- Route FBC (minor): resolve the Seam-2 framing contradiction ("conjugate-adjunction unit coherence" vs "a different construction — NOT an adjunction-unit identity"); the FBC-A 1–3 estimate depends on which is true.

## Overall verdict

The iter-016 pivot is the strategy's strongest move: **Route 2 is a sound — and cleaner-than-canonical — realization of graded Hilbert–Serre rationality (Stacks 00K1)**. The subquotient class is genuinely closed under ker/coker of a degree-1 endo (both as ambient subquotient pairs annihilated by the killed endo and preserved by the rest), the `(⊤,⊥)` instantiation recovers `dim_κ Mₙ`, no hypothesis is missing, and — decisively — it is a *real* pivot rather than a renamed problem: the dropped route's hardest prerequisite (a `DirectSum.Decomposition` on a quotient/subtype carrier, the whnf runaway) is structurally eliminated, since every object Route 2 forms is an ambient `Naux ⊓ ℳn` of the shape G1 proved safe. FBC, GF, QUOT-defs, and QUOT-repr are each sound; all five spot-checked Mathlib prerequisites verified with exact signatures. Two things must be addressed this iter. First, a soundness CHALLENGE on **SNAP-S1**: the strategy pins the Hilbert polynomial to `M = im(S^N → ⊕Γ)` and asserts `dim M_m = dim Γ(F_s⊗L_s^m)` for `m≫0` without naming the cohomology-free finite-generation lemma that secures it — and since the goal object is *defined* via `Γ`, this equality is load-bearing and must be justified cohomology-free (plausibly Hartshorne II.5.17, chapter II) lest the Čech-independent constraint be breached. Second, the document is **DRIFTED**: 50% over the byte budget and threaded with ~10 per-iter-narrative sites that belong in iter sidecars. The `lem:qcoh_section_localization_basicOpen` bridge is required by the goal (via QUOT-repr) but is an accepted dependency with a concrete plan and timeline, so it needs only a wording fix, not a build, this iter. Estimates (FBC-A 1–3, GF-alg 1–3, SNAP-S2 2–3) are honest ranges, optimistic at the low end, with GF-alg's L5 polynomial core and FBC's Seam 2 the genuine schedule risks — both covered by the ranges' upper bounds.
