# Lean Audit Report

## Slug
iter008

## Iteration
008

## Scope
- files audited: 7
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator (5 lines). No declarations.

---

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - Line 93: `show` used to change the proof goal rather than merely indicate it;
    the style linter warns to use `change` instead. Pure cosmetic.
  - `base_change_regroup_linearEquiv` is fully proved (no `sorry`). The
    `map_smul'` proof handles all three induction cases (`zero`, `add`, `tmul`)
    by `TensorProduct.induction_on`. Logic is sound.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 23 flagged (22 deprecated API + 1 style lint)
- **excuse-comments**: none
- **notes**:
  - **Deprecated API (22 sites)**: `CategoryTheory.Sheaf.val` is deprecated;
    Mathlib now requires `ObjectProperty.obj`. LSP emits 22 deprecation warnings
    at lines 294, 333, 336, 340, 370, 384, 386, 434, 485, 512, 515, 523, 572,
    577, 579, 580, 583, 584, 586, 605, 615. This is a systematic bad-practice
    finding, not a one-off.
  - **Stale section comment (lines 184–247)**: The `/-! ## Project-local Mathlib
    supplement — affine tilde dictionary -/` section opens with a
    `STATUS (iter-234) / UPDATE (iter-236)` development-history block describing
    blockers that have since been resolved. The code that follows (route (b) via
    `gammaPushforwardIso`) is correct and axiom-clean; the blocker prose is stale.
  - **Line 972**: `show` tactic used to change the goal; linter recommends
    `change`.
  - **Sorry declarations (4)**:
    - Line 854 (`base_change_mate_regroupEquiv`): contains 2 `sorry` tactics —
      the `zero` and inner `zero` branches of the `map_smul'` induction
      (lines 951 and 960). Each reduces to `r' • 0 = 0`; `smul_zero` is blocked
      by the opaque `Module ↑R'` instances (`_aux_3`/`_aux_5`) on the
      `extendScalars`/`restrictScalars` carrier. The substantive generator
      computation (`tmul` branch) and `R'`-additivity (`add` branch) are fully
      proved. The `sorry`s are honest bookkeeping scaffolding.
    - Line 1000 (`base_change_mate_generator_trace_eq`): the genuine crux —
      mate-unwinding coherence over the pullback square. Accurately documented.
    - Line 1128 (`affineBaseChange_pushforward_iso`): affine reduction step;
      Mathlib-absent restriction-compatibility of `pushforwardBaseChangeMap`.
      Accurately documented.
    - Line 1168 (`flatBaseChange_pushforward_isIso`): Čech-cohomology
      infrastructure missing from Mathlib. Accurately documented.
  - **`map_smul'` tactic chain audit** (directive focus):
    The `tmul a s` branch (lines 963–982) is sound:
    (1) `erw [ModuleCat.ExtendScalars.smul_tmul, ...]` reduces the `R'`-action
        on the source (the `includeRight` factor) to `a ⊗ₜ (r' * s)` via
        `tmul_mul_tmul` and `one_mul`;
    (2) `show ...` unfolds `g` to the concrete `cancelBaseChange` expression
        (the `eT` bridge is the identity on elements, so it drops out at `rfl`);
    (3) `rw [cancelBaseChange_tmul, comm_tmul]` on both sides; then
        `rw [smul_tmul', smul_eq_mul]` closes the LHS = RHS comparison.
    The chain is mathematically sound. The `add` branches close by `erw` +
    `congrArg₂`. The two `sorry`s in the `zero` branches are honest scaffolding
    (bookkeeping, not content).
  - **NOTE at line 851** (actionable observation): The comment states that
    `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` would
    close the ENTIRE `base_change_mate_regroupEquiv` (bypassing both zero-branch
    `sorry`s and all of `map_smul'`) once `base_change_regroup_linearEquiv` is in
    a *separate compiled module*. `RegroupHelper.lean` is now that separate
    module (imported by `FlatBaseChange.lean`). This avenue should be attempted
    at the start of the next iter before building route (b). If the one-liner
    works, both `sorry`s become unnecessary.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`gf_generic_rank_ses` (lines 529–627)** — new substantive proof this iter.
    Proof strategy: set `P = A[X₁,…,X_d]`, `K = Frac P`, `NK = N_K`; take
    `m = finrank K NK`; lift basis vectors via `IsLocalizedModule.surj`,
    establish K-linear independence (unit multiples of a basis), descend to
    P-linear independence via `restrict_scalars`, then show the cokernel is
    torsion by clearing denominators of the K-coefficients. The proof is sound.
    `Module.finBasis K NK` requires `FiniteDimensional K NK`; this is synthesized
    by Lean from `Module.Finite P N` + `K = Frac P` (fraction field of a domain)
    — no compilation errors observed.
  - **`gf_clear_one_denominator` (lines 409–465)** — new fully proved lemma.
    Uses `IsLocalization.exist_integer_multiples` to clear the finitely many
    coefficients of `p ∈ K[X₁,…,X_n]`. The coeff computation at the end
    (lines 451–465) is correct: the support-membership case uses `hs`; the
    non-support case derives `a i = 0` from injectivity of the fraction-field
    map and `coeff i p = 0`. Proof is sound.
  - **`gf_torsion_reindex` (lines 634–649)** — new `sorry`-bodied theorem.
    The signature carries module instances in the existential (unusual but valid
    in Lean 4). The `sorry` is honest; comments are accurate (denominator-clearing
    for the torsion support-dimension drop, the genuine Mathlib-absent content).
  - **`exists_free_localizationAway_polynomial` universe change** — `(A N : Type u)`
    replacing `Type*`. The change is **sound**: the strong induction
    `generalizing A N` requires the IH to apply at `A_g = Localization.Away g :
    Type u` (which holds since `A : Type u` ⟹ `Localization.Away g : Type u`).
    With `Type*` the IH universe could vary and the application at `A_g` might
    not typecheck. The restriction is a slight weakening (non-universe-polymorphic
    statement) but the correct choice for this induction.
  - **Induction structure** (lines 682–734): base case `d = 0` uses
    `MvPolynomial.isEmptyAlgEquiv` to reduce to `Module.Finite A N`. Inductive
    step: torsion sub-case delegates to `exists_free_localizationAway_of_torsion`;
    generic-rank sub-case calls `gf_generic_rank_ses` (new this iter, now
    in scope), then defers to `sorry` pending `gf_torsion_reindex`. The comment
    at lines 712–714 correctly describes the structural fix. No compilation
    errors.
  - **Sorry declarations (5)**: all honestly documented with accurate blockers:
    `exists_localizationAway_finite_mvPolynomial` (L4 denominator-clearing, Mathlib-absent),
    `gf_torsion_reindex` (L5b support-dimension drop),
    `exists_free_localizationAway_polynomial` (dévissage pending L5b),
    `genericFlatnessAlgebraic` (wiring L3/L4/L5),
    `genericFlatness` (geometric assembly, pending algebraic core).

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 57–59 (stale docstring)**: The per-iteration note inside the docstring
    of `affineChart` reads: "For the iter-007 file-skeleton the body is a typed
    `sorry`." The body is, in fact, the correct definition
    `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial ...))`. The claim is
    factually false. Previously flagged in prior iters; repeated briefly here per
    directive. The code itself is correct.
  - No compiler warnings or errors. Clean compilation.

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Sorry declarations (4)**: `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
    `Grassmannian.representable` — all file-skeleton `sorry` placeholders with
    accurate docstrings noting "iter-177+ body" and the specific infrastructure
    (graded Euler characteristic, Snapper's Lemma, gluing cocycle) that is needed.
  - **`SheafOfModules.IsLocallyFreeOfRank`** (lines 253–257): substantive `def`,
    no `sorry`. The definition correctly requires an index type `ι : Type u`,
    a cover `U : ι → X.Opens`, and per-open isomorphisms to `SheafOfModules.free
    (ULift (Fin d))`. Sound.
  - **`Module.annihilator_isLocalizedModule_eq_map`** (lines 289–349): fully proved.
    The proof of `Ann_Rₚ(Mₚ) ⊆ (Ann_R M).map` clears generators via
    `IsLocalization.mk'_surjective`, collects a common denominator over the finite
    generating set with a product-of-annihilators construction, then maps the
    product back. The reverse inclusion is standard. Proof is sound.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No compiler warnings or errors. Fully proved.
  - `RelativeSpec` and `structureMorphism` bodies correctly use
    `AffineZariskiSite.relativeGluingData`.glued/.toBase`.
  - `UniversalProperty` proof is sound: uses
    `isAffineHom_of_forall_exists_isAffineOpen`, identifies the preimage of each
    affine `U` with the `opensRange` of the gluing cover inclusion
    (`toBase_preimage_eq_opensRange_ι`), then concludes affineness from
    `isAffineOpen_opensRange`.
  - Lines 228–231 and 275–277 contain "iter-174+: refine..." notes indicating the
    current `IsAffineHom` type of `UniversalProperty` is a weaker form of the
    full Yoneda-bijection statement. The current type is non-tautological and
    correct; the notes are future-work markers, not excuse-comments.

---

## Must-fix-this-iter

None.

No finding meets the must-fix bar. All `sorry`s are:
- Openly documented honest scaffolding for Mathlib-absent infrastructure, or
- Pure `r' • 0 = 0` bookkeeping with a documented technical blocker (opaque
  `Module ↑R'` instances on the `extendScalars`/`restrictScalars` carrier).

No weakened-wrong definitions, no excuse-comments, no parallel Mathlib APIs, no
`sorry` whose surrounding comment misrepresents its status.

---

## Major

- `FlatBaseChange.lean:294` (and 21 further sites: 333, 336, 340, 370, 384, 386,
  434, 485, 512, 515, 523, 572, 577, 579, 580, 583, 584, 586, 605, 615) —
  `CategoryTheory.Sheaf.val` is deprecated; Mathlib now requires
  `ObjectProperty.obj`. 22 deprecation warnings emitted by the LSP. API drift of
  this scale accumulates technical debt and risks breakage when the deprecated
  accessor is removed upstream.

- `GrassmannianCells.lean:57–59` — Docstring claims "the body is a typed `sorry`"
  when the body is the correct `AlgebraicGeometry.Spec (...)`. Factually
  incorrect. Previously flagged. Auditor cannot edit; re-flagging per directive.

- `FlatBaseChange.lean:851–853` — The NOTE inside `base_change_mate_regroupEquiv`'s
  docstring states that `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`
  would close the entire `map_smul'` obligation once `base_change_regroup_linearEquiv`
  is in a separate compiled module. That module (`RegroupHelper.lean`) now exists
  and is imported. If the one-liner works, the two `zero`-branch `sorry`s (lines
  951, 960) are avoidable — a complete proof is available but unused. This should
  be attempted at the start of the next prover session before pursuing route (b).

---

## Minor

- `FlatBaseChange.lean:184–247` — Section comment contains embedded iter-234 /
  iter-236 development history (STATUS / UPDATE blocks) for blockers that are now
  resolved. The prose describes route (a) as a dead end and route (b) as
  "executed and axiom-clean" — both accurate — but the historical narrative is
  stale relative to the current codebase. Not misleading about correctness.

- `FlatBaseChange.lean:972` and `RegroupHelper.lean:93` — `show` tactic used to
  change the goal (not merely annotate it for readability). The style linter warns
  `change` is the correct tactic in both cases.

- `RelativeSpec.lean:228–231, 275–277` — "iter-174+: refine the type to the full
  Yoneda-bijection statement" notes in `UniversalProperty` and `affine_base_iff`
  docstrings. Current types are non-tautological and correct; these are
  unobjectionable future-work markers.

---

## Excuse-comments (always called out separately)

None. No declaration in the project carries an excuse-comment ("wrong but works",
"placeholder", "temporary", "will fix later"). All `sorry` bodies are accompanied
by accurate technical blockers.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The project is sound at iter-008; the new `map_smul'` generator
proof in `base_change_mate_regroupEquiv` is mathematically correct and the two
remaining `sorry`s are honest bookkeeping scaffolding — the main actionable finding
is a 22-site deprecated-API accumulation in `FlatBaseChange.lean` and a potentially
completable one-liner path (via `RegroupHelper.lean`) that should be tried next iter
before investing in route (b).
