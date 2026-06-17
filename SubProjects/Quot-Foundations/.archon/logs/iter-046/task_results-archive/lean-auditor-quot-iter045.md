# Lean Audit Report

## Slug
quot-iter045

## Iteration
045

## Scope
- files audited: 8
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 4 flagged (pre-existing open obligations)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **New: `keystoneAdjR` (~L1755).** Genuine `noncomputable def`. Body is a depth-3 adjunction chain `(extendRestrictScalarsAdj inclA.hom).comp ((tilde.adjunction …).comp (pullbackPushforwardAdjunction e.hom))` assembled with explicit `letI` algebra instances. No sorry. Non-trivial and correctly typed. The use of `letI` in the `where`-style anonymous function is standard for providing algebra instances in adjunction compositions.
  - **New: `keystoneBeta` (~L1772).** Genuine `noncomputable def`. Returns a natural isomorphism built from `Functor.isoWhiskerRight (pushforwardComp e.hom (Spec.map inclA)).symm ≪≫ Functor.associator … ≪≫ isoWhiskerLeft _ (gammaPushforwardNatIso inclA) ≪≫ (Functor.associator …).symm`. No sorry. Non-trivial.
  - **L1749–1793: docstrings for `keystoneAdjR`/`keystoneBeta`.** Accurately describe the role: both feed the conjugate-pair machinery for `base_change_mate_fstar_reindex_legs_conj`. No stale or misleading claims.
  - **L1926–1933: iter-045 progress comment.** Claims "`conjugateEquiv adjL (keystoneAdjR ψ φ)` typechecks (verified)". Accurate for this iter. Not aspirational.
  - **L1949: `sorry` in `base_change_mate_fstar_reindex_legs_conj`.** Pre-existing parked crux. The surrounding comment correctly labels it "REMAINING GAP … PARKED per the armed kill-criterion, progress-critic-endorsed, no second reprieve." The scaffolding (`hunitL`, `huce`, `adjL`, `adjR=keystoneAdjR`, `β=keystoneBeta`) is all axiom-clean. Not an excuse-comment; an honest roadmap.
  - **L2338–2339: comment "currently sorry-backed (its …legs apparatus carries a dead sorry)."** Refers to `base_change_mate_fstar_reindex`. This is accurate: `_fstar_reindex` calls `_fstar_reindex_legs` which calls `_legs_conj` (sorry at L1949). The label "sorry-backed" is correct.
  - **L2416: `sorry` in `base_change_mate_gstar_transpose`.** Pre-existing. Surrounding comments describe a verified scaffold (conjugate-counit calculus with `huce`, `hcounitL`, `hcounitR`) with the "REMAINING CRUX (recipe steps 2–3)" clearly documented.
  - **L2437–2439 and L2508–2510: "transitively sorry-backed" labels.** `pushforward_base_change_mate_cancelBaseChange` and the wrapper above it both correctly document that their bodies have no inline sorry but are transitively backed through `base_change_mate_gstar_transpose`. Accurate.
  - **L2597: `sorry` in `affineBaseChange_pushforward_iso`.** Pre-existing. Comments correctly identify the missing affine-reduction step (restriction-compatibility of `pushforwardBaseChangeMap`, Mathlib-absent).
  - **L2619: `sorry` in `flatBaseChange_pushforward_isIso`.** Pre-existing. The main theorem; comment describes the full Čech route.
  - **`set_option maxHeartbeats` overrides at L979, L1637, L1796, L1953, L2003.** Each has a nearby one-line rationale comment (whnf cost of conjugate normalization, post-`subst` reduction, defeq matching). Not new this iter. Sound justification.
  - **`base_change_mate_fstar_reindex_legs` (L1962).** No inline sorry; its proof is the thin `▸`/`exact` wrapper over `_legs_conj`. The comment "THIN WRAPPER" is accurate. No false claim of completeness.

### AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - All 6 declarations (`exists_finite_affineCover_inter_isQuasiCompact`, `gammaIsLimitSheafConditionFork`, `exists_finite_affineCover_isLimit_sheafConditionFork`, `gammaTopEquivEqLocus`, `rhoU_comp`, `baseChangeGammaEquiv`) have complete proofs with no sorry.
  - `gammaTopEquivEqLocus` proof uses `eq_of_locally_eq'` and `existsUnique_gluing'` correctly for the sheaf-condition bijection.
  - `baseChangeGammaEquiv` is a clean composition of `gammaTopEquivEqLocus` and `LinearMap.tensorEqLocusEquiv`. Sound.

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - `base_change_regroup_linearEquiv` has a complete proof using `TensorProduct.comm`, `cancelBaseChange`, and a `map_smul'` verification on generators. Axiom-clean. The docstring accurately describes the construction.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 1 flagged (stale iter-number references, see below)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (pre-existing open obligations)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **New import `import AlgebraicJacobian.Picard.QuotScheme`.** Acyclic (QuotScheme does not import FlatteningStratification). Correct.
  - **New: `finite_localizedModule_of_isLocalizedModule` (~L2173).** Genuine non-trivial theorem. Statement correctly transfers `Module.Finite Rₚ N` (for any model `Rₚ` localizing `R` at `S`) to the canonical `Module.Finite (Localization S) (LocalizedModule S M)`. Proof uses `IsLocalizedModule.linearEquiv` to get `e : N ≃ₗ[R] LocalizedModule S M`, `IsLocalization.algEquiv` for `ψ : Rₚ ≃ₐ[R] Localization S`, constructs `hsemi` (showing `e (a • x) = ψ a • e x`) via the injection trick (`hbij.injective`), then transfers the finite generating set by `Submodule.span_induction`. Complete, no sorry. Sound.
  - **New: `gf_finite_sections_of_basicOpen_finite_cover` (~L2231).** Genuine non-trivial theorem. Statement: affine-open `W`, finset `t` spanning the unit ideal of `Γ(X, W)`, finiteness on each `D(g)` ⟹ finiteness on `W`. Proof: `Module.Finite.of_localizationSpan_finite t ht`, then for each `g ∈ t`:
    - `letI : Module Γ(X, W) Γ(F, X.basicOpen g.val) := Module.compHom _ (algebraMap …)` — sound local-instance pattern; introduces the `Γ(X, W)`-module structure by restriction of scalars.
    - `haveI : IsScalarTower Γ(X, W) Γ(X, X.basicOpen g.val) Γ(F, X.basicOpen g.val)` — correctly derived.
    - `haveI : IsLocalization.Away (g.val) Γ(X, X.basicOpen g.val)` — from `hW.isLocalization_basicOpen`.
    - `haveI := Scheme.Modules.isLocalizedModule_basicOpen F hW g.val` — the gap2 keystone.
    - Final application: `finite_localizedModule_of_isLocalizedModule (Submonoid.powers g.val) (Rₚ := Γ(X, X.basicOpen g.val)) (Scheme.Modules.restrictBasicOpenₗ F g.val)`. Typing: `φ = restrictBasicOpenₗ F g.val : Γ(F, W) →ₗ[Γ(X, W)] Γ(F, X.basicOpen g.val)` with `IsLocalizedModule (powers g.val) φ` from the keystone, `Module.Finite Rₚ N` from `H g.val g.2`. The conclusion `Module.Finite (Localization.Away g.val) (LocalizedModule (powers g.val) Γ(F, W))` is exactly what `of_localizationSpan_finite` requires. Sound.
  - **L2269, L2273, L2279: "iter-177+:" comments in `genericFlatness` docstring.** The original repo's iteration numbering (iter-177+) is stale relative to this extracted project (currently at iter-045). A reader of this project would find iter-177 confusing. Minor stale issue; no mathematical harm.
  - **L2371: `sorry` in `genericFlatness`.** Pre-existing. Comment correctly states "the construction terminates in an honest sorry here rather than committing to an unjustified open." The two documented gaps (G1 and G3) are accurately described.
  - **`genericFlatnessAlgebraic` (~L1982).** Primary route (module-finite over A case) is axiom-clean via `GenericFreeness.exists_free_localizationAway_of_finite`. The surviving residue (non-module-finite case) has a sorry via the dévissage's `B/𝔭` branch, which still requires the polynomial-ring core. The comment at L1957 ("Surviving residue (sorry this iter)") is accurately factual, not an excuse-comment.
  - **`set_option synthInstance.maxHeartbeats 1000000 in` (L483) and `set_option maxHeartbeats 4000000 in` (L485, L966, L971).** All have nearby one-line rationale comments. Sound.
  - **GenericFreeness namespace (L96–1140, approximately).** The sub-lemmas L1–L5 and the dévissage chain appear axiom-clean based on grep (no sorry in these sections). The chain is well-structured.

### AlgebraicJacobian/Picard/GradedHilbertSerre.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - All declarations axiom-clean. `rationalHilbert_antidiff`, `IsRatHilb` toolkit, and `subquotient_hilbertSeries_rational` build the Hilbert–Serre rationality machinery correctly.

### AlgebraicJacobian/Picard/GrassmannianCells.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - All declarations axiom-clean. `affineChart`, `universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`, `universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`, `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self` are complete with no sorry.
  - The "Planner note" comment block (L33–44) is a design note, not a workflow comment. Acceptable.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 2 flagged (aspirational "iter-177+" and "iter-176 file-skeleton" references)
- **suspect definitions**: 0 flagged (signatures are substantive)
- **dead-end proofs**: 4 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged (the skeleton labels are honest, not concealing)
- **notes**:
  - `hilbertPolynomial` (L123): `sorry` body. Signature is non-trivial (`S → Polynomial ℚ`). The docstring "iter-176 file-skeleton the body is a typed sorry" is factually honest about the scaffold state.
  - `QuotFunctor` (L161): `sorry` body. Signature is a genuine contravariant functor `(Over S)ᵒᵖ ⥤ Type u`.
  - `Grassmannian` (functor, L198): `sorry` body. Genuine functor signature.
  - `Grassmannian.representable` (L225): `sorry` body. Genuine representability claim.
  - "iter-177+: the body …" aspirational comments: these carry the original repo's iteration numbering, confusing relative to this project's iter-045. Minor stale issue; no mathematical harm.
  - The `isLocalizedModule_basicOpen` and other gap-N declarations referenced in `task_results` appear to be imported through the QuotScheme leaf — this is consistent with the iter-044 memory entry noting the gap2 closure.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 1 flagged (aspirational "iter-174+: refine the type signature")
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged (no sorry in Lean code)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - The module-level docstring mentions "iter-173 Lane B scaffolded … sorry bodies" — this is historical context (those bodies are now replaced), not an active excuse-comment.
  - `RelativeSpec` body: `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`. Non-sorry. Sound Mathlib-aligned body.
  - `RelativeSpec.structureMorphism` body: `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`. Non-sorry. Sound.
  - `UniversalProperty` body: `apply isAffineHom_of_forall_exists_isAffineOpen` → `cover.toBase_preimage_eq_opensRange_ι` → `isAffineOpen_opensRange`. Complete proof. Sound.
  - `affine_base_iff`: `exact isAffine_of_isAffineHom (RelativeSpec.structureMorphism 𝒜)` after `UniversalProperty`. Complete. Sound.
  - "iter-174+: refine the type signature to the full Yoneda-bijection…": aspirational forward-planning comment on `UniversalProperty`. The current signature (`IsAffineHom`) is a genuine substantive weakening of the full representability statement. Not a critical issue (the current signature is documented as intentional); minor aspirational comment.

---

## Must-fix-this-iter

The 4 new declarations introduced this iter (`keystoneAdjR`, `keystoneBeta`, `finite_localizedModule_of_isLocalizedModule`, `gf_finite_sections_of_basicOpen_finite_cover`) are all sorry-free and genuinely non-trivial. No new wrong code was introduced this iter.

Per the strict must-fix rule (`:= sorry` on a load-bearing substantive claim), the following pre-existing open obligations are flagged. They are ALL documented, tracked proof obligations known to the project; the classification is per the auditor severity rule, not a signal of hidden issues.

- `FlatBaseChange.lean:1949` — `base_change_mate_fstar_reindex_legs_conj` has `sorry` body. The entire FBC chain (`_legs`, `_fstar_reindex`, `gstar_transpose`, `affineBaseChange`, `flatBaseChange`) is transitively blocked. Why must-fix: load-bearing crux that blocks the file's main theorems.
- `FlatBaseChange.lean:2416` — `base_change_mate_gstar_transpose` has `sorry` body. Blocks `pushforward_base_change_mate_cancelBaseChange` and downstream. Why must-fix: load-bearing for the main flat-base-change theorem.
- `FlatBaseChange.lean:2597` — `affineBaseChange_pushforward_iso` has `sorry` body. Why must-fix: load-bearing for `flatBaseChange_pushforward_isIso`.
- `FlatBaseChange.lean:2619` — `flatBaseChange_pushforward_isIso` has `sorry` body. The top-level theorem of the file. Why must-fix: the primary goal of the FBC chapter.
- `FlatteningStratification.lean:2371` — `genericFlatness` has `sorry` body. Top-level theorem of the flattening-stratification chapter. Why must-fix: the primary goal driving the Quot-scheme assembly.
- `QuotScheme.lean:126` — `hilbertPolynomial` has `sorry` body. Load-bearing scaffold for `QuotFunctor`. Why must-fix: sorry on a non-trivial definition.
- `QuotScheme.lean:165` — `QuotFunctor` has `sorry` body. Why must-fix: sorry on the primary functor definition.
- `QuotScheme.lean:201` — `Grassmannian` (functor) has `sorry` body. Why must-fix: sorry on a non-trivial definition.
- `QuotScheme.lean:228` — `Grassmannian.representable` has `sorry` body. Why must-fix: sorry on a substantive claim.

**Contextual note for the plan agent**: All 9 items above are pre-existing tracked open obligations, not newly introduced. None represent hidden or undocumented wrong code. The project's tracking system (PROGRESS.md, task_results) is aware of all of them.

---

## Major

- `FlatteningStratification.lean:1957 (comment)` — "Surviving residue (sorry this iter)" in `genericFlatnessAlgebraic` docstring. The phrase "this iter" is a floating reference. Low harm but mildly confusing across iter boundaries.
- `RelativeSpec.lean:229 (comment)` — "iter-174+: refine the type signature to the full Yoneda-bijection statement…" on `UniversalProperty`. The current signature (`IsAffineHom`) is a genuine weakening of the full representability statement; a future auditor should check whether the signature has been refined.

---

## Minor

- `FlatteningStratification.lean:2269,2273` — "iter-177+:" aspirational comments in `genericFlatness` docstring. The "iter-177" label refers to the original repo's iteration count (this project is at iter-045), creating confusion about project state.
- `QuotScheme.lean:122,156,197,224` — "iter-176 file-skeleton" and "iter-177+:" labels in docstrings of `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. The iter-176/177 references carry forward from the original repo; in this project (iter-045) these are misleading.
- `RelativeSpec.lean:216` — "iter-174+: refine the type signature…" minor forward-pointing comment; acceptable aspirational note.

---

## Excuse-comments (always called out separately)

None detected. No declaration in the project has a comment of the form "TODO: replace with real def," "placeholder," "temporary wrong definition," or similar. All sorry bodies are honestly labeled as sorry.

---

## Severity summary

- **must-fix-this-iter**: 9 — all pre-existing tracked open proof obligations (sorry bodies on substantive load-bearing claims). None are new this iter; listed per auditor severity rule. See contextual note above.
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

**Overall verdict**: Iter-045 is clean — the 4 new declarations (`keystoneAdjR`, `keystoneBeta`, `finite_localizedModule_of_isLocalizedModule`, `gf_finite_sections_of_basicOpen_finite_cover`) are all genuine, axiom-clean, and correctly typed; the `letI`/`haveI` compHom scalar-tower pattern in `gf_finite_sections_of_basicOpen_finite_cover` is sound; no new sorry bodies, no excuse-comments, no stale docstrings on new code. The 9 must-fix items are pre-existing tracked obligations carried forward from prior iters.
