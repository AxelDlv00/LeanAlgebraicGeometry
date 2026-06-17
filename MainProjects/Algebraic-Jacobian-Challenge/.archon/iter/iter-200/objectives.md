# Iter-200 prover objectives — per-lane detail

## Dispatch shape

3 prover lanes (Route A bottom-up; mathlib-build default mode;
reference-anchored per USER 2026-05-28 directive).

## Lane WD-A4a-Sub-build-1: PrimeDivisor open-immersion bijection on existing CoheightBridge substrate

**PIVOT iter-200**: original recipe was "build a fresh Stacks 02IZ/005X bridge from scratch". Per the mathlib-analogist `wd-stacks02iz` verdict, the project ALREADY ships the bridge at `AlgebraicJacobian/Albanese/CoheightBridge.lean` (237 LOC axiom-clean, iter-183). Actual work is a thin (~50-90 LOC) PrimeDivisor bijection on top.

- **File**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Mode**: `mathlib-build`
- **Helper budget**: 2
- **Priority**: 1 (A.4.a root)
- **Reference anchors**:
  - Stacks 02IZ + 005X (already in project at `Albanese/CoheightBridge.lean`)
  - iter-200 mathlib-analogist `wd-stacks02iz` (full report at `task_results/mathlib-analogist-wd-stacks02iz.md` + persistent `analogies/wd-stacks02iz.md`)
- **Recipe (~50-90 LOC, per analogist)**:
  1. **~1 LOC**: `import AlgebraicJacobian.Albanese.CoheightBridge`.
  2. **~30-50 LOC**: `Scheme.PrimeDivisor.restrictToOpen` + `Scheme.PrimeDivisor.ofOpen` + `Scheme.PrimeDivisor.equivOpen` — the open-immersion bijection on `PrimeDivisor`s, consuming `Order.coheight_eq_of_isOpenEmbedding`. Follow the `CoheightBridge.lean` L175-185 defeq cast pattern for the `↥U` vs `U.toScheme.carrier` alignment.
  3. **~5-10 LOC**: `Scheme.PrimeDivisor.stalkIso` via Mathlib's `AlgebraicGeometry.Scheme.Opens.stalkIso`.
  4. **PUSH-BEYOND ~10-20 LOC**: `Scheme.IsRegularInCodimensionOne` open-immersion descent (combine 1-3).
- **Mathlib + project pieces (named)**:
  - `AlgebraicJacobian.Albanese.CoheightBridge.Order.coheight_eq_of_isOpenEmbedding` (project iter-183)
  - `AlgebraicJacobian.Albanese.CoheightBridge.Scheme.ringKrullDim_stalk_eq_coheight` (project iter-183)
  - `AlgebraicGeometry.Scheme.Opens.stalkIso` (Mathlib `Mathlib.AlgebraicGeometry.Restrict`)
  - `AlgebraicGeometry.Scheme.PrimeDivisor` (project, existing)
- **HARD BAR**: land steps (1)-(3) axiom-clean.
- **PUSH-BEYOND**: step (4) + Sub-build 2 preview work on `Ring.ordFrac` naturality across stalk iso (iter-201+ scope per analogist).
- **SCOPE FENCE**: do NOT touch L538, L1108 (RR.1 / Route C); do NOT strengthen public signature of `rationalMap_order_finite_support`.
- **Mathlib gap (Sub-build 2 only, iter-201+)**: `Ring.ordFrac` lacks a naturality lemma across a ring iso at `b80f227`; ~30-50 LOC project-side via `IsFractionRing.ringEquivOfRingEquiv` + `Ring.ordMonoidWithZeroHom`.
- **Blueprint**: `chapters/RiemannRoch_WeilDivisor.tex`, `lem:rationalMap_order_finite_support` (iter-199 standalone block).

## Lane AB-gap1-HasPdLT-Descent: SES descent via Mathlib's `HasProjectiveDimensionLT`

**PIVOT iter-200**: from "literal `ChainComplex ℕ (ModuleCat R)` build" to "SES descent via `hasProjectiveDimensionLT_X₁`" per the mathlib-analogist `ab-natrecursive` ALIGN_WITH_MATHLIB verdict.

- **File**: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- **Mode**: `mathlib-build`
- **Helper budget**: 2
- **Priority**: 1 (A.4.b root)
- **Reference anchors**:
  - Stacks 00LK (`lemma-add-trivial-complex`)
  - iter-200 mathlib-analogist `ab-natrecursive` Path A (full report at `task_results/mathlib-analogist-ab-natrecursive.md` + persistent `analogies/ab-natrecursive.md`)
- **Recipe (~40-80 LOC, Path A)**:
  1. **Bridge (~15 LOC)**: package the iter-199 `RingTheory.Module.exists_minimalSurjection_finite_localRing` output as `ShortComplex.ShortExact (ModuleCat R)`. Specifically: convert `(f : Fin n → R) →ₗ[R] M` + `Surjective f` to `ShortComplex.moduleCatMk` + `ShortComplex.ShortExact.mk'`. The kernel module is finite via `Module.FinitePresentation.fg_ker` + `Module.finitePresentation_of_finite` (using `[IsNoetherianRing R]` + `Module.Finite R M`).
  2. **Syzygy descent helper (~15-25 LOC)**: apply Mathlib's `CategoryTheory.hasProjectiveDimensionLT_X₁` to the above SES. The middle `(Fin n → R)` discharges `pd < 1` via `ModuleCat.projective_of_free` + `CategoryTheory.projective_iff_hasProjectiveDimensionLT_one`. Output: `HasProjectiveDimensionLT (ModuleCat.of R M) (k+2) → HasProjectiveDimensionLT (ModuleCat.of R (ker f)) (k+1)` — the syzygy descent.
  3. **Inductive assembly (~20-40 LOC)**: induct on `k` for `HasProjectiveDimensionLT (ModuleCat.of R M) (k+1)`. Translate the outer hypothesis `Module.projectiveDimension R M = (k+1 : WithBot ℕ∞)` via `projectiveDimension_lt_iff`. The depth side uses `depth_of_short_exact` (already axiom-clean iter-198) on the same SES.
- **Mathlib pieces (named)**:
  - `CategoryTheory.HasProjectiveDimensionLT` + `hasProjectiveDimensionLT_X₁` (Mathlib.CategoryTheory.Abelian.Projective.Dimension)
  - `CategoryTheory.projective_iff_hasProjectiveDimensionLT_one`
  - `ModuleCat.projective_of_free` + `Module.Projective.of_free`
  - `ShortComplex.moduleCatMk` + `ShortComplex.ShortExact.mk'`
  - `Module.FinitePresentation.fg_ker` + `Module.finitePresentation_of_finite`
  - `CategoryTheory.projectiveDimension_lt_iff`
- **HARD BAR**: land the SES-descent path axiom-clean closing `auslander_buchsbaum_formula_succ_pd` body.
- **PUSH-BEYOND**: if HARD BAR met, gaps (1)/(2)/(3) substrate work substantially reduces (Path A is minimality-blind; AB doesn't need the Stacks 00LK trim lemma at all).
- **Mathlib gap**: NONE — Path A is fully discharged from current Mathlib + iter-199 axiom-clean substrate.
- **Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`, `lem:exists_minimalSurjection_finite_localRing` (iter-200 standalone block) + `\subsec:succ_pd_gap_sequence` (gap (1) Nat-recursive bullet should be updated post-iter-200 to reflect the Path A pivot).

## Lane COE-stage6-iiB: 3-step Mathlib-chain Krull-dim formula + regular-sequence witness

**REFINEMENT iter-200**: prior ~200-300 LOC estimate tightened by the mathlib-analogist `coe-stacks00oe` to ~80-120 LOC via a 3-step composition of existing Mathlib analogues. The substantive residual is the regular-sequence witness (Stacks 00SW/00OW).

- **File**: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- **Mode**: `mathlib-build`
- **Helper budget**: 2
- **Priority**: 2 (A.4.c.0)
- **Reference anchors**:
  - Stacks 00OE (`lemma-smooth-locally-finite-type-equidimensional`)
  - Stacks 00SW / 00OW (regular-sequence side: Jacobian invertible ⟹ relations Koszul-regular at closed point)
  - iter-200 mathlib-analogist `coe-stacks00oe` cross-domain-inspiration (report at `task_results/mathlib-analogist-coe-stacks00oe.md` + persistent `analogies/coe-stacks00oe.md`)
- **Recipe (~80-120 LOC, per analogist)**:
  - **Step 1 — Krull-dim ⇒ height (Analogue 4, trivial)**: `rw [IsLocalization.AtPrime.ringKrullDim_eq_height]` reduces `ringKrullDim S_m = n` to `m.height = n`.
  - **Step 2 — Polynomial-ring height (Analogue 1, ~30 LOC)**: iterate `Polynomial.height_eq_height_add_one` `#ι` times over the base field `k` (with `(0 : Ideal k).height = 0` via `ringKrullDim_eq_zero_of_field`) on the preimage `m'` in `MvPolynomial ι k`.
  - **Step 3 — Drop by regular-sequence length (Analogue 2, ~50-90 LOC)**: apply `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` in `R'_{m'}` with the relations `(f_j)_{j ∈ σ}` of the `SubmersivePresentation` from iter-198 substrate. Solve for `n = #ι − #σ`.
- **Substantive residual obligation (Step 3)**: construct `RingTheory.Sequence.IsRegular R'_{m'} (f_j)_{j ∈ σ}` — Stacks 00SW / 00OW. ~30-60 LOC project-side build against `Algebra.SubmersivePresentation.jacobian_isUnit` + `RingTheory.Sequence.isRegular_cons_iff` + `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`.
- **Mathlib pieces (named)**:
  - `IsLocalization.AtPrime.ringKrullDim_eq_height` (Mathlib.RingTheory.Ideal.Height)
  - `Polynomial.height_eq_height_add_one` (Mathlib.RingTheory.KrullDimension.Polynomial)
  - `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` (Mathlib.RingTheory.KrullDimension.Regular)
  - `ringKrullDim_eq_zero_of_field`
  - `Algebra.SubmersivePresentation.jacobian_isUnit` (project, iter-198 substrate)
- **HARD BAR**: land the 3-step Krull-dim formula axiom-clean, OR Step 1+2 plus partial Step 3 substrate if the regular-sequence witness exceeds budget.
- **PUSH-BEYOND**: if (ii.B) closes, attempt the trailing sorry at L1101 cold; cascade Lane T32 re-engagement noted in iter-201 commitments.
- **Cascade opportunity**: closing (ii.B) closes L1101 AND triggers Lane T32 re-engagement (binding trigger condition).
- **Blueprint**: `chapters/Albanese_CodimOneExtension.tex`, `subsec:stage6_subgap_decomposition` 6.A (`lem:smooth_algebra_krull_dim_formula`).

## Held lanes — explicit rationale

- **Lane RPF**: HELD; iter-200 plan-phase blueprint-writer `tensorobj-substrate-chapter` creates the iter-201+ source chapter.
- **Lane FGA**: HELD; iter-199 carrier-soundness refactor closed Sorry 4; remaining 7 ⟨sorry⟩ instances are A.1.c-gated or Route-C-blocked.
- **Lane T32**: HELD; Lane COE derivative; binding trigger = `COE Stage 6.B Krull-dim formula closed`.
- **Lane RCI**: HELD per USER directive (Route C PAUSED permanent).

## Sorry projection

Entering iter-200: 78 sorries. 3 lanes.

- Best case: 78 → ~74-76 (−2 to −4 closures via cascade)
- Realistic: 78 → ~77-78 (substrate-only; (ii.B) is the largest unknown)
- Worst case: 78 → ~77-78 (substrate-only across the board)

## Mode selection rationale

All 3 lanes use `mathlib-build` per USER directive #3 + the descriptor's guidance:

- WD Sub-build 1 builds project-side substrate for a Mathlib-absent operation (open-immersion stalk-bridge for prime divisors); the goal is forward-compatible substrate, not closing a sorry directly.
- AB gap (1) Nat-recursive iterates an axiom-clean substrate to build a project-side `ChainComplex ℕ (ModuleCat R)` substrate; again, building axiom-clean infrastructure, not closing.
- COE Stage 6.B builds the Stacks 00OE Krull-dim formula axiom-clean; not in Mathlib at the pinned revision.

`prove` mode is wrong here: every lane's HARD BAR is substrate growth, not sorry closure. `fine-grained` mode is wrong: the substrate has a single mathematical sentence per lane; no need to decompose further.
