# Session 200 — Review of iter-200

## Session metadata

- **Session number**: 200 (= iter-200)
- **Sorry count before**: 78 (iter-199 close)
- **Sorry count after**: 78 (unchanged — substrate-only iter)
- **Project axioms**: 0 → 0 (**20th consecutive zero-axiom build streak**)
- **Targets attempted**: 3 prover lanes — all returned `done` clean
  (no API 529)
  - Lane WD-A4a Sub-build 1 on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  - Lane AB-gap1-HasPdLT on `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
  - Lane COE-stage6-iiB on `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- **Iteration shape**: 3-lane substrate-only iter under USER 2026-05-28
  standing directive (ROUTE C PAUSE permanent; Route A bottom-up;
  reference-driven mathlib-build).

## Outcome at a glance

- **`lake build AlgebraicJacobian` GREEN** per
  `.archon/logs/iter-200/meta.json` (`prover.status: done`,
  `planValidate.objectives: 3`).
- **19 axiom-clean substrate declarations added across 3 files**
  (8 in WD; 4 in AB `RingTheory.Module`; 7 private in COE
  `AlgebraicGeometry.Scheme`). Each verified via `lean_verify` to
  depend only on the kernel triple `{propext, Classical.choice,
  Quot.sound}`.
- **Sorry trajectory**: WD 3 → 3, AB 1 → 1, COE 3 → 3. **Net 0**;
  matches the iter-200 plan's worst-case projection (78 → 77-78,
  substrate-only). No closures; no new sorries.
- **HARD BAR landings**: 2 of 3 lanes met HARD BAR via substantive
  structural advance.
  - Lane WD: **MET** (steps 1-4 incl. PUSH-BEYOND step 4
    `IsRegularInCodimensionOne.instOpen` axiom-clean).
  - Lane COE: **MET** (Step 1+2 fully axiom-clean + Step 3 partial
    substrate; capstone `ringKrullDim_localization_atMaximal_MvPolynomial`
    collapses Steps 1+2 into a single consumer call).
  - Lane AB: **NOT MET** (Steps (i)+(ii) closed axiom-clean but Step
    (iii) inductive assembly blocked on Stacks 00MF + ℕ∞
    arithmetic; 4 helpers landed, body scaffolded ending in trailing
    sorry).
- **Plan trajectory** (per iter-200 plan): best 78 → ~75-76, realistic
  78 → ~77-78, worst 78 → ~77-78. **Lands worst-case band** with
  substantive HARD BAR landings on 2 of 3 lanes.
- **No placeholder body / headline-laundering risk** this iter — every
  new declaration is honest mathematical content with full axiom-clean
  bodies; the trailing sorries are precisely-typed substrate gaps
  named in the prover reports.

## Per-target attempts (drawn from `attempts_raw.jsonl`)

### Lane WD — `Scheme.PrimeDivisor` open-immersion descent substrate

- **Attempt** (single, succeeded): follow `wd-stacks02iz`
  mathlib-analogist recipe verbatim. 8 axiom-clean substrate decls
  at L153, L162, L174, L182, L187, L195, L210, L305 inside the
  file's `namespace AlgebraicGeometry.Scheme` ambient.
- **Friction**: `noncomputable` marker required on `stalkIso`
  (one-line correction).
- **Key Lean handles used**: `Scheme.Opens.stalkIso`,
  `Order.coheight_eq_of_isOpenEmbedding` (from iter-183 CoheightBridge
  substrate), `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`,
  `Pi.basisFun.constr`.
- **What was learned**: `IsLocallyNoetherian U.toScheme` is automatic
  via typeclass propagation; `IsIntegral U.toScheme` is NOT — threaded
  explicitly in `instOpen`. Realized cost +120 LOC (analogist
  estimated 150-250).
- **Result**: HARD BAR MET; PUSH-BEYOND step 4 MET; trailing sorries
  at L535/L843/L1413 untouched per SCOPE FENCE.

### Lane AB — `auslander_buchsbaum_formula_succ_pd` body

- **Attempt 1** (succeeded for steps (i)+(ii)): ALIGN_WITH_MATHLIB
  pivot per `ab-natrecursive` mathlib-analogist Path A recipe.
  HasProjectiveDimensionLT SES descent via X₁ / X₃ pair.
  - `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` (L1290,
    ~5 LOC) via `CategoryTheory.projectiveDimension_lt_iff` single
    rewrite.
  - `hasProjectiveDimensionLT_ker_of_surjection` (L1311, ~10 LOC) via
    `LinearMap.shortExact_shortComplexKer` +
    `ModuleCat.projective_of_free (Pi.basisFun R (Fin n))` +
    `hasProjectiveDimensionLT_of_ge` + `hS.hasProjectiveDimensionLT_X₁`.
  - `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`
    (L1340, ~10 LOC) mirror via `hasProjectiveDimensionLT_X₃`.
  - `depth_ker_ge_min_of_surjection_finite_localRing` (L1376, ~22 LOC)
    via `depth_of_short_exact (3)` + `depth_pi_const_eq_depth_of_nonempty`.
- **Attempt 2** (partial): scaffold parent body using the 4 helpers,
  ending in trailing `sorry` at L1574-area. The scaffold compiles
  axiom-clean above the trailing sorry, demonstrating the substrate
  plugs in.
- **Why HARD BAR NOT MET**: even with the substrate, closing the
  body requires (a) base case `pd M > 0 ⟹ depth M < depth R` (Stacks
  00MF; ~150-200 LOC Mathlib gap candidate) and (b) ℕ∞ arithmetic
  reducing to `depth M + 1 ≤ depth R` — itself part of AB.
- **What was learned**: analogist Step (i) ~15-LOC estimate reduced to
  ~3 LOC inline use (no wrapping helper needed); the substantive gap
  is Step (iii)'s inductive assembly, which needs 00MF as external
  input or a refined LES analysis (Ext connecting-map injectivity).
- **Dead end (do NOT retry)**: literal `ChainComplex ℕ` carrier; the
  analogist verdict on `ab-natrecursive` is ALIGN_WITH_MATHLIB and the
  ChainComplex path is 3-4× over budget AND blocked on a separate
  termination-of-syzygy-tower lemma absent in Mathlib b80f227. The
  classical Stacks 090V path (induct on depth M; use 00MF base +
  snake lemma) is also gap-blocked at both ingredients.

### Lane COE — `isRegularLocalRing_stalk_of_smooth` substrate (Stage 6.B)

- **Attempt** (single, succeeded): follow `coe-stacks00oe`
  mathlib-analogist top suggestion. 7 axiom-clean private substrate
  theorems built lines ~688–~790 in `namespace
  AlgebraicGeometry.Scheme`:
  - Step 1: `ringKrullDim_localization_eq_height_atPrime` —
    re-export of `IsLocalization.AtPrime.ringKrullDim_eq_height`.
  - Step 2 lower (Fin n): `MvPolynomial.maximalIdeal_height_ge_card_of_field`
    — induction on `Fin n` via `MvPolynomial.finSuccEquiv` +
    `Polynomial.height_eq_height_add_one` +
    `Polynomial.isMaximal_comap_C_of_isJacobsonRing` (Jacobson
    contraction). **Substantive proof of the iter**.
  - Step 2 upper (general): `MvPolynomial.maximalIdeal_height_le_natCard_of_field`
    — composition of `Ideal.height_le_ringKrullDim_of_ne_top` +
    `MvPolynomial.ringKrullDim_of_isNoetherianRing` +
    `ringKrullDim_eq_zero_of_field`.
  - Step 2 combined: `MvPolynomial.maximalIdeal_height_eq_card`
    (Fin n) / `…_eq_natCard` (general, via `renameEquiv`).
  - Capstone: `ringKrullDim_localization_atMaximal_MvPolynomial` —
    Steps 1+2 in a single consumer call.
  - Step 3 additive: `ringKrullDim_quotient_add_eq_of_regular_sequence`
    — via `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`.
- **Friction**: Step 3 subtraction form attempted but rejected —
  `WithBot ℕ∞` has no `HSub` instance.
- **Why L1061 push-beyond NOT attempted**: closing
  `isRegularLocalRing_stalk_of_smooth` inline requires (a) explicit
  `SubmersivePresentation` extraction from
  `Algebra.IsStandardSmooth (Γ(Spec, U)) (Γ(X.left, V))` (Stage 3
  gives `IsStandardSmoothOfRelativeDimension`, not the presentation
  directly); (b) maximal-ideal-at-z identification; (c) Jacobian-
  regular-sequence witness (substantive iter-201+ residual).
- **Result**: HARD BAR MET (Step 1+2 fully + Step 3 partial); L1061
  remains the substantive iter-201+ closure target.

## Key findings / patterns discovered

- **HasProjectiveDimensionLT SES descent (Mathlib-aligned)** for AB-
  style depth/pd arithmetic — see Knowledge Base addition below. The
  iter-200 ALIGN_WITH_MATHLIB pivot replaces the literal
  `ChainComplex ℕ (ModuleCat R)` construction with abstract syzygy
  descent via `hasProjectiveDimensionLT_X₁` / `_X₃`; obviates gap (3)
  (snake lemma on minimal resolution) entirely.
- **MvPolynomial height = n via finSuccEquiv + Jacobson contraction**
  for smooth-algebra Krull-dim formulas — see Knowledge Base addition
  below. Induction on `Fin n` (not generic `Finite ι`) is the
  cleanest route; rename-equiv transports to the general form.
- **Substrate-only iter as canonical response to multi-piece Mathlib
  gaps** (iter-199 KB pattern reinforced this iter for all 3 lanes):
  net-delta 0 sorries; substrate forward-compatible toward iter-201+
  closures. The strategic discipline is to commit precisely-typed
  axiom-clean substrate rather than re-dispatching the same prover
  lane after multi-approach exhaustion.
- **`Scheme.Opens.stalkIso` thin-wrap pattern** for prime-divisor
  open-immersion descent — see Knowledge Base addition below.

## Subagent reports (review-phase, dispatched in parallel)

Dispatched in this review phase (all 4 returned `done`):

- `lean-auditor iter200` — 44 files audited; **19 new iter-200
  substrate decls all clean** (no headline-laundering patterns);
  2 carry-over must-fix items (RelPicFunctor:266-269 +
  AlbaneseUP:179-183) UNRESOLVED. Full report at
  `.archon/task_results/lean-auditor-iter200.md`.
- `lean-vs-blueprint-checker wd-iter200` — 0 broken pins, 5 of 8
  new iter-200 decls lack `\lean{...}` pins, no blueprint section
  for open-immersion descent; `soon` (not must-fix). Full report at
  `.archon/task_results/lean-vs-blueprint-checker-wd-iter200.md`.
- `lean-vs-blueprint-checker ab-iter200` — 3 major (4 new HasPdLT
  helpers absent from chapter; ALIGN_WITH_MATHLIB pivot undocumented;
  gap (3) marked OBVIATED in Lean but listed "absent" in blueprint
  table) + 1 major Blueprint→Lean (`auslander_buchsbaum_formula_succ_pd`
  still `private` despite public pin — 2-iter-stale iter-199 NOTE).
  No must-fix-this-iter. Full report at
  `.archon/task_results/lean-vs-blueprint-checker-ab-iter200.md`.
- `lean-vs-blueprint-checker coe-iter200` — 0 broken pins, 7 new
  substrate decls absent from blueprint, Stage 6.A description stale;
  no must-fix-this-iter, 3 `soon`. Full report at
  `.archon/task_results/lean-vs-blueprint-checker-coe-iter200.md`.

All findings merged into `recommendations.md` LOW-3 + MED-5a. The
new MED-5a item addresses the `auslander_buchsbaum_formula_succ_pd`
private/public mismatch flagged 2 iters running.

## Recommendations for next session

See `recommendations.md`.

## Blueprint markers updated (manual)

- `Albanese_AuslanderBuchsbaum.tex`, `lem:auslander_buchsbaum_formula_succ_pd`:
  appended a follow-on `% NOTE iter-200 review` to the existing
  iter-199 NOTE block (now spans L418–L429), flagging that iter-200
  did not pick either of the two resolution options (drop `private`
  vs. drop the pin) named in iter-199; declaration now at L1517
  post-iter-200 substrate shift.

No `\mathlibok` additions (no decls this iter are pure Mathlib
re-exports without project-side wrapping). No `\lean{...}` corrections
(iter-199 plan-agent pins still resolve). No stale `\notready` strip
(project does not currently use `\notready`).

## Notes from blueprint doctor

`logs/iter-200/blueprint-doctor.md` reports **no structural findings**:
every chapter is `\input`'d by `content.tex`, every `\ref` / `\uses`
resolves, every annotation has a non-empty argument, and no `axiom`
declarations are present.

## Notes from sync_leanok

`sync_leanok-state.json`: iter=200, sha=`ad870cc4`, added=3,
removed=6, chapters_touched=`{Albanese_AuslanderBuchsbaum.tex,
Picard_TensorObjSubstrate.tex, RiemannRoch_WeilDivisor.tex}`. The
net-negative removals reflect deterministic stripping where the Lean
side either lost or never had the `\leanok`-eligible state (the
iter-200 plan agent created a new `Picard_TensorObjSubstrate.tex`
chapter and the writer's draft included `\leanok` candidates the sync
phase pruned because the corresponding decls don't exist yet).
