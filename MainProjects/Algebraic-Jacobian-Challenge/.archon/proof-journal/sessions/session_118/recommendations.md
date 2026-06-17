# Recommendations for the next plan-agent iteration (iter-119)

## CRITICAL (must-fix-this-iter)

1. **Dispatch the iter-119 prover lane on `AlgebraicJacobian/Differentials.lean:87` `smooth_locally_free_omega`** against the pre-verified 5-step Mathlib chain. The iter-118 refactor + blueprint rewrite landed cleanly; the lean-vs-blueprint-checker-differentials-review118 audit returns **0 must-fix / 0 major / 0 minor** on the post-refactor pair (Lean signature and chapter `thm:smooth_locally_free_omega` in mutual agreement). All 5 named Mathlib closure pieces verified to exist in the pinned `.lake/packages/mathlib/` snapshot:
   - `AlgebraicGeometry.smoothOfRelativeDimension_iff` (auto-generated `@[mk_iff]` on the `SmoothOfRelativeDimension` class)
   - `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` (`Mathlib/RingTheory/Smooth/StandardSmooth.lean:102`)
   - `Algebra.IsStandardSmooth.free_kaehlerDifferential` (instance; `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`)
   - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (theorem; same file)
   - `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler` (project-local at `Differentials.lean:58`)

   Bridge bridge: `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra` is the chart-level glue between the `RingHom.*` hypothesis produced by `smoothOfRelativeDimension_iff` and the `Algebra.*` Kähler API (added to STRATEGY.md Phase C this iter per strategy-critic-iter118).

   Expected outcome: COMPLETE in 1-3 prover iters / 100-300 LOC. The forward direction is straightforward Jacobian-criterion + rank pin; the only non-trivial step is bridging from algebra-side `Ω[S⁄R]` to the project's `(relativeDifferentialsPresheaf f).presheaf.obj` via the project-local `relativeDifferentialsPresheaf_obj_kaehler` (type equality, body `rfl`).

   **Watch criteria committed by progress-critic-iter118** (resolve the UNCLEAR verdict at iter-120 plan-phase):
   - If iter-119 returns COMPLETE: iter-117 trim was vindicated; mark route CONVERGING; advance to `polish` stage.
   - If iter-119 returns PARTIAL/INCOMPLETE *with a new recurring blocker phrase*: iter-120 verdict is CHURNING; primary corrective = `mathlib-analogist` on the named verified Mathlib chain.
   - If iter-119 returns PARTIAL *without* a new blocker (ergonomics-only): iter-120 may proceed with polish lane; verdict stays UNCLEAR-trending-CONVERGING.

2. **Delete the iter-043-admitted dead `IsAffineHModuleHomFinite` chain in `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`.** The lean-auditor-review118 returns this as **must-fix-this-iter** — the iter-043 docstring at L530–543 explicitly classifies the iter-041 class as "dead scaffolding — admits no producer instance on a non-trivial proper curve," yet the four declarations remain in the file:
   - `IsAffineHModuleHomFinite` class (L458–466)
   - `module_finite_HModule'_zero_of_isAffineHModuleHomFinite` consumer (L476–487)
   - `module_finite_HModule'_of_affine` combined consumer (L497–507)
   - `module_finite_HModule'_of_affine_curve` curve specialisation (L512–519)

   Project-wide grep confirms no caller outside this file — the live route through `Genus.lean`'s `genus` uses `HModule` (wholespace), not `HModule'` (per-open). Deletion is zero-cost on the protected chain. Plan-agent action: dispatch a `refactor` agent for `StructureSheafModuleK.lean` to remove these four declarations (and any orphaned comments). Recommended slug: `dead-iaffhomfinite-iter119`.

   This is concurrent-able with the iter-119 prover lane on `Differentials.lean` (different files; no cross-dependency).

## HIGH

3. **Decide on the two `MayerVietorisCover.lean` scaffolding classes** (`HasCechToHModuleIso` L490-514 and `HasAffineCechAcyclicCover` L675-682). Lean-auditor-review118 flags both as **major**: `Prop`-class wrappers around `Nonempty (data)` extracted via `Classical.choice`, with no producer instances anywhere in the project. The downstream instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699-709) inherits the unsatisfied-instance gap and propagates it. Two options:
   - **(a) Downgrade** both to explicit-argument theorems (as in iter-049 `subsingleton_HModule_of_isCechAcyclicCover_top`), removing the "instance available globally without ever being produced" hazard.
   - **(b) Delete** entirely if the cohomology infrastructure is not load-bearing for the surviving active surface. Project-wide grep can verify: `cechToHModuleIso`, `HasAffineCechAcyclicCover`, and `subsingleton_HModule_of_isCechAcyclicCover_top` callers outside `MayerVietorisCover.lean` itself.

   Not blocking for iter-119, but should not carry past iter-120 unaddressed. Lean-auditor's recommendation favours option (a) ("Consider downgrading to an explicit-argument theorem until a real producer is realistic").

4. **Trim redundant typeclass arguments on `Rigidity.lean:62-67 GrpObj.eq_of_eqOnOpen`** (lean-auditor-review118 major). The declaration's docstring explicitly admits the six typeclass hypotheses are redundant with the strengthened iter-003 hypothesis (`ext_of_isDominant_of_isSeparated'` does the work). Every call site pays the typeclass-synthesis cost. Either delete the dead arguments or document them as deliberately decorative; current "kept to preserve the declaration's 'abelian-variety' intent" is the hardening-dead-code pattern the auditor's stance disallows.

## MEDIUM

5. **Blueprint chapter `Jacobian.tex` minor cleanups** (lean-vs-blueprint-checker-jacobian-review118):
   - Tighten the universal-property prose of `def:IsAlbanese` and `lem:IsAlbanese_exists_unique_ofCurve_comp`: blueprint says "morphism of group schemes", Lean asserts `J ⟶ A` (scheme morphism in the over-category). Mathematically equivalent under classical rigidity; the prose should say "morphism of schemes (necessarily of group schemes by classical rigidity)" for precision.
   - Either promote `jacobianWitness` to its own `\lean{...}`-tagged definition block in `Jacobian.tex`, or add a one-line `% NOTE:` in `def:Jacobian` clarifying that `jacobianWitness C` is the projection underlying the four `Jacobian.*` instances.
   - Delete the dead helper `geometricallyIrreducible_id_Spec` at `Jacobian.lean:120` (the doc-comment claims it is needed for the genus-0 case but the current witness-based `Jacobian` definition absorbs that into `nonempty_jacobianWitness` — no callers).

6. **Stale status-line headers** (lean-auditor-review118 minor):
   - `AlgebraicJacobian/AbelJacobi.lean:14` references iter-073 (current 118).
   - `AlgebraicJacobian/Genus.lean:14` references iter-011 (current 118).
   Both descriptive text bodies still match the code; only the iteration tag is stale. Optional cleanup; not blocking.

7. **`AlgebraicJacobian/Genus.lean:39-61` large commented-out historical sketch** (`OXAsAddCommGrpSheaf`, `H1OC` AddCommGrpCat route abandoned in favour of `Scheme.HModule`). Bloat that can be pruned in any future iter.

8. **`AlgebraicJacobian/Differentials.lean:92` stylistic note** (lean-auditor-review118 minor): `Module.rank R M = n` with `n : ℕ` uses the ℕ→Cardinal coercion; `Module.finrank R M = n` would read more naturally given the simultaneous `Module.Free` claim. Stylistic only; not a defect. Iter-119+ may consider tightening as a future polish step, ideally before the prover lane lands so the proof can use `Module.finrank` directly.

## LOW

- Two clusters of Mathlib gap-fills awaiting upstream PRs:
  - `Cohomology/StructureSheafModuleK.lean:47-101` — five `CategoryTheory.*` gap-fills (`Functor.const_additive`, `Functor.const_linear`, two `Adjunction.*_linear`, `Adjunction.homLinearEquiv`). General-purpose, upstreamable.
  - `Cohomology/MayerVietorisCore.lean:250-252, 341-346` — two `ModuleCat_free_*` gap-fills (`isLeftAdjoint`, `preservesMonomorphisms`). Upstreamable.

  Track separately as a future upstream-Mathlib effort; no autonomous-loop action.

## Stage decision for iter-119

**Stage**: `prover` (Phase C — close the forward implication on
`Differentials.lean:87`). After iter-119 either:

- **COMPLETE** outcome ⇒ Phase C closed; advance to `polish` for the
  iter-120+ residual cleanup work (dead `IsAffineHModuleHomFinite`
  chain, scaffolding-class decisions, blueprint prose tightening).
  Project ships with a single foundational `sorry` (the authorised
  hypothesis `nonempty_jacobianWitness`).
- **PARTIAL/INCOMPLETE** outcome ⇒ iter-120 follows the
  progress-critic-iter118 watch-criteria branching.

## Should NOT retry

- **Do not attempt to convert `nonempty_jacobianWitness` to an
  `axiom`.** Strategy-critic-iter118 CHALLENGEd with this suggestion;
  the plan agent's rebuttal (no-new-axioms hard rule;
  `.archon/prompts/plan.md` L43) is recorded in
  `iter/iter-118/plan.md`. If the user explicitly authorises in
  `USER_HINTS.md`, revisit; otherwise the `sorry` stays.
- **Do not re-attempt an iff signature on `smooth_locally_free_omega`.**
  The converse direction is mathematically false without
  `Subsingleton (Algebra.H1Cotangent A B)`; iter-118 demoted to
  forward-only with a documented Mathlib gap, and the user directive
  "no temporarily wrong" forbids reverting.
- **Do not write blueprint chapters for the deleted iter-117 routes**
  (unique-gluing, cotangent exact sequence h_exact, cotangent at
  section, Serre duality genus, Picard chain, Modules/Monoidal,
  BasicOpenCech). Those chapter files (or their orphan sections) may
  exist on disk but are not in `content.tex`'s active list; treat as
  historical-artefact prose and do not resurrect.
