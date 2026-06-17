# Strategy Critic Report

## Slug
iter047

## Iteration
047

## Routes audited

### Route: FBC

- **Goal-alignment**: PASS — produces the i=0 base-change iso `g^* f_* F ≅ f'_* g'^* F` named in `## Goal`.
- **Mathematical soundness**: PASS — module-level reduction to `regroupEquiv` (DONE) is correct; the section mate honestly funnels both the conjugate calculus and the abandoned tilde-transport attempt into the single `_legs_conj` crux, and the per-layer legs (conj-2b/2c/2d) are reported axiom-clean.
- **Sunk-cost reasoning detected**: no — the route is justified on merits (no element normal form for `pullback.fst`), not "we already invested."
- **Infrastructure-deferral detected**: yes (low severity) — FBC is one of the three goal targets (`lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`) yet FBC-A1 is labeled `PARKED` and "Off critical path." It carries a concrete `2–4` iter estimate and the keystone is built, so this is a *tracked* deferral, not an unresolved gap — BUT the strategy states no un-park trigger. "Off critical path" means "blocks no other route," NOT "not required by goal"; the 29-node zero-sorry end-state is impossible without FBC. Risk: silent abandonment.
- **Phantom prerequisites**: none — the conjugate API (`conjugateEquiv_symm_comp`, `conjugateEquiv_whiskerLeft/Right`) is real Mathlib.
- **Effort honesty**: reasonable, mild tension — "residual mechanical" sits oddly next to "large structurally-known φ/ψ Spec-layer transport" with a `2–4` iter / `~200–400` LOC tail. If the legs are truly axiom-clean and assembly is a `conjugateEquiv_symm_comp` chain, 200–400 LOC of residual is not "mechanical." Either the estimate is honest and the assembly is not mechanical, or vice versa.
- **Parallelism under-exploited**: no — FBC-A2 is correctly marked parallelisable and independent of A1.
- **Verdict**: CHALLENGE — parking is the right *triage* (goal-required leaf that blocks nothing, deprioritised behind the dependency-bearing GF/QUOT lanes), but the strategy must record an explicit un-park trigger so a parked goal target does not decay into a goal weakening.

### Route: GF

- **Goal-alignment**: PASS — geometric `genericFlatness` wraps the DONE algebraic core; the affine-patch + `of_localizationSpan` assembly is the standard Nitsure §4 → geometric lift.
- **Mathematical soundness**: PARTIAL — the **base case** framing is where a fresh reader stalls (detail below).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the base case is the live frontier, not deferred).
- **Phantom prerequisites**: `Module.Finite.of_localizationSpan` VERIFIED; the *exact functor* invoked by "exact-functor transport across the gap1/gap2 qcoh≃Mod descent" is the questionable one — see below.
- **Effort honesty**: reasonable (`3–5` iters / `~150–350` LOC) IF the base-case crux is genuinely a transport; under-counted if the sheaf-epi⟹module-epi surjectivity must be built from H¹-vanishing.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — the base case is described as a "mechanical exact-functor transport," but the project deliberately built the qcoh≃Mod descent *object-wise* ("WITHOUT global QCoh≃Mod", per `## Completed` gap1/gap2 rows) precisely to dodge the global equivalence. Object-level isos `Γ(F) ≅ M` and `Γ(O^I) ≅ B^I` do **not** by themselves give that `Γ` *preserves the epimorphism* `O^I ↠ F`. Preserving a sheaf epi under `Γ` on an affine is `H¹(Spec B, ker) = 0` (qcoh cohomology vanishing) — a separate ingredient the strategy never names. There is no "exact functor" sitting in the codebase to transport across; there is a family of object isos. The planner must name where surjectivity of `B^I → Γ(F)` comes from (qcoh H¹-vanishing on the affine, or a direct LocalizedModule surjectivity argument) — that step IS the crux, not a wrapper. **Second, latent case-split**: producing a *finite-index* global epi `O^I ↠ F` on the affine from a *finite-type* (i.e. locally finitely generated) sheaf is itself nontrivial — finite type only gives generators on a basic-open cover, so the base case 01PB internally re-invokes a localization-span/quasi-compactness step. Confirm the Lean `IsFiniteType` encoding supplies the global finite epi, or the base case is not "single-affine, done" but carries its own `of_localizationSpan`.

### Route: QUOT

- **Goal-alignment**: PASS — `def:hilbert_polynomial` via `Polynomial.existsUnique_hilbertPoly` (VERIFIED, `[CharZero]`) + DONE `gradedHilbertSerre`; `Grassmannian := QuotFunctor` and the GR-cells/glue/sep/proper completed rows align with `def:grassmannian_scheme` / `thm:grassmannian_representable`.
- **Mathematical soundness**: PASS — Route-2 ambient-subquotient rationality (Stacks 00K1) is DONE; the chosen-f.g.-presentation SNAP-S1 input correctly sidesteps the doubtful "Γ_*(F) f.g." lemma.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — QUOT-repr is `BLOCKED` but with a concrete decomposition (GR-quot → GR-repr via `thm:relative_spec_univ`) and `6–12` iter estimate, not an open-ended punt.
- **Phantom prerequisites**: the chosen-presentation route (a) depends on a "cited Serre m≫0 agreement" the strategy itself flags as unverified ("Hartshorne II.5.17 attribution likely wrong") — correctly tracked as Q1 with a reference-retriever planned; the RelativeSpec tag (Q4) is likewise pinned as a fence. Both are honest open citations, not phantom Lean infra.
- **Effort honesty**: reasonable; one correction below on the SNAP "absent monoidal infra" claim.
- **Parallelism under-exploited**: no — SNAP (tensor-powers, ACTIVE-blueprint) is correctly decoupled from the Q1-gated SNAP-S1/S3, and from GF and the annihilator/P2 consumer lane.
- **Verdict**: SOUND.

On the directive's Q4 (is Q1 a real fork to decide before scaffolding?): **No.** The `def:sectionGradedRing` tensor-powers infra is common to both (a) and (b) — both define `Φ_s` from `m ↦ dim Γ(X_s, F_s ⊗ L_s^m)`. Scaffolding the tensor-power build now while deferring the (a)/(b) canonicity decision to gate only S1/S3 is correct sequencing with no wasted work.

## Format compliance

- **Size**: ~125 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — the SNAP row's Risks cell ends "...`Picard_SectionGradedRing.tex` being authored + decomposed **this iter**." "this iter" is per-iter narrative and belongs in the iter sidecar, not STRATEGY.md.
- **Accumulation detected**: no — `## Completed` has 9 rows (within the ~12 bound); no completed phase lingers in the active table.
- **Table discipline**: PARTIAL — `LOC` cells are ranges (good), but several `Status` cells carry parenthetical prose rather than a short inline tag: `PARKED (unknowns resolved; residual mechanical)`, `ACTIVE (G1 base case is live blocker)`, `ACTIVE (parallelisable)`. The qualifier belongs in Risks; Status should read `PARKED` / `ACTIVE`.
- **Format verdict**: DRIFTED — one "this iter" narrative leak + prose-laden Status cells. Both are quick in-place fixes.

## Infrastructure-deferral findings

### Deferred: FBC i=0 base-change isomorphism (`thm:flat_base_change_pushforward`)

- **Required by goal**: yes — explicitly listed under `## Goal`; the zero-sorry 29-node closure cannot complete without it.
- **Current plan for building it**: factored `_legs_conj` discharge via composite adjunctions `adjL`/`adjR` + `conjugateEquiv_symm_comp` leg-chain; keystone reported built, residual = Spec-layer transport.
- **Timeline**: concrete (FBC-A1 `2–4` iters; FBC-B `2–5` gated on A1).
- **Verdict**: CHALLENGE — acceptable as deprioritised work *because* a timeline and decided route exist, but "PARKED / Off critical path" with no un-park trigger is the inaction-deferral risk. Add a one-line un-park condition (e.g. "resume once GF base case + SNAP land, or by iter NNN").

## Alternative routes (suggested)

### Alternative: GF base case via explicit qcoh H¹-vanishing on the affine

- **What it looks like**: rather than claiming an ambient "exact-functor transport," state the actual lemma that makes `Γ` preserve the epi `O^I ↠ F`: for qcoh `ker` on `Spec B`, `H¹(Spec B, ker) = 0`, hence `Γ(O^I) → Γ(F)` is surjective; then finite `I` ⟹ `Γ(F)` finite. Equivalently, work entirely in `LocalizedModule` land and prove surjectivity of the localized map directly, never lifting to a functor.
- **Why it might be cheaper or sounder**: it names the one missing ingredient instead of assuming an exact functor the project deliberately did not build, removing the "transport across a descent that exists only object-wise" sleight of hand. It also makes the finite-`I` provenance explicit.
- **What the current strategy may have rejected**: the strategy's own `## Completed` notes say the global `compHom` Module-instance route LOOPS — so the functorial framing was tried and failed; the object-wise/`of_localizationSpan` framing is the survivor, which is exactly why the base case should be phrased in `LocalizedModule`/vanishing terms, not "exact functor."
- **Severity of the omission**: major.

## Prerequisite verification

- `Module.Finite.of_localizationSpan`: VERIFIED (`Mathlib.RingTheory.Localization.Finiteness`).
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`, `[Field] [CharZero]`).
- SheafOfModules tensor-power / monoidal infra (claimed "absent"): PARTIALLY PRESENT — `PresheafOfModules.Monoidal.tensorObj` (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`) and `CategoryTheory.Sheaf.monoidalCategory` (`Mathlib.CategoryTheory.Sites.Monoidal`) exist. The strategy's "L_s^{⊗m} + lax-monoidal Γ absent" is overstated; the foundational monoidal scaffold exists and the SNAP build should reuse it. This makes the `~300–600` LOC / `4–8` iter estimate *more* defensible (the calibration vs the 1290-LOC GradedHilbertSerre row likely over-budgets), provided the build wires `PresheafOfModules.Monoidal` through to `SheafOfModules` over the scheme rather than re-deriving it.

## Must-fix-this-iter

- Route GF: CHALLENGE — the base case is not a mechanical "exact-functor transport." The project built the qcoh≃Mod descent object-wise to avoid the global equivalence, so no exact `Γ` functor exists to transport across. Name the actual ingredient that makes `Γ` preserve the sheaf epi (qcoh H¹-vanishing on the affine / direct LocalizedModule surjectivity), and confirm where the finite-index global epi `O^I ↠ F` comes from for a finite-type sheaf (latent `of_localizationSpan` inside 01PB). Either fix STRATEGY.md's GF route prose or rebut in plan.md.
- Route FBC: CHALLENGE — FBC is a goal target labeled PARKED/Off-critical-path with no un-park trigger. Add an explicit resume condition so a goal-required leaf is not silently abandoned.
- Alternative (GF base case via H¹-vanishing): major omission — adopt the explicit-vanishing phrasing in the GF route.
- Format: DRIFTED — remove "this iter" from the SNAP Risks cell; reduce the three prose-laden `Status` cells to short tags (move qualifiers to Risks). Quick in-place edits.

## Overall verdict

The leg-as-fan-of-independent-leaves structure is sound and the parallelism is genuinely exploited: GF base case, SNAP tensor-powers, the annihilator/P2 consumer lane, and FBC-A2 are correctly routed as concurrent lanes, and the Q1 SNAP fork is properly decoupled from the common tensor-power scaffold so scaffolding need not wait on it. Parking FBC is the right triage — it is a goal-required leaf that blocks nothing, and it retains a concrete route and iter estimate — but the strategy defers FBC with no un-park trigger, and FBC is required for the stated goal, so the planner must record a resume condition rather than let "Off critical path" harden into abandonment. The single substantive soundness gap is the GF base case: the strategy bills the sheaf-epi ⟹ module-epi step as "exact-functor transport across the gap1/gap2 qcoh≃Mod descent," but that descent was deliberately built object-wise without a global equivalence, so there is no exact functor to transport across — the surjectivity of `Γ` on the epi (qcoh H¹-vanishing on the affine) is an un-named separate ingredient and is the real crux. Prerequisite names check out (`of_localizationSpan`, `existsUnique_hilbertPoly` both VERIFIED), and the SNAP "absent monoidal infra" claim is overstated — `PresheafOfModules.Monoidal` and `Sheaf.monoidalCategory` exist and should anchor the SNAP build. Format is DRIFTED on two quick items ("this iter" leak; prose Status cells).
