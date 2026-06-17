# Iter-197 — per-lane prover objectives

5 prover lanes (Lane RCI HELD, Lane G + Lane F + others deferred).
All HARD GATE-blocked lanes (H, E, BareScheme-via-ChartIso, A) are
CLEAR per scoped fastpath blueprint-reviewer `iter197-fastpath`.

## Lane: ChartIso per-chart smoothness closure

- **File**: `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
- **Prover mode**: `prove`
- **Sorries in scope**: `projectiveLineBar_smooth_chart_aux`
  (private, ~L406 post-relocation).
- **Closure recipe** (~10 LOC):
  - Reduce via `HasRingHomProperty.iff_of_isAffine` to a
    `RingHom.IsStandardSmoothOfRelativeDimension 1` on the composite
    `kbar → Γ(chart_i, ⊤) = HomogeneousLocalization.Away 𝒜 X_i`.
  - Apply
    `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` with
    `(homogeneousLocalizationAwayIso kbar i).toAlgEquiv`
    transferring rel dim 1 from `MvPolynomial (Fin 1) kbar` (via
    `mvPolynomialFin_isStandardSmoothOfRelativeDimension` in
    BareScheme.lean) to the chart ring.
- **HARD BAR**: close `projectiveLineBar_smooth_chart_aux`
  axiom-clean (chartwise instance). Cascade:
  `projectiveLineBar_smoothOfRelDim` becomes fully axiom-clean.
- **PUSH-BEYOND**: explore whether the cascade unlocks any other
  ChartIso.lean sorries (file has 1 sorry post-relocation; if it
  closes, file becomes fully sorry-free). Do NOT touch
  `projectiveLineBar_geomIrred` (~200-350 LOC Stacks 0BLW substrate;
  out of scope).
- **References**:
  - `task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md` (iter-196 prover task report)
  - `task_results/refactor-barescheme-smoothness-relocation.md` (iter-197 refactor outcome with prescribed closure form)
  - `blueprint/src/chapters/AbelianVarietyRigidity.tex` `lem:projectiveLineBar_smoothOfRelDim`

## Lane E: AbelianVarietyRigidity 3-helper + 2 consumer closures

- **File**: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- **Prover mode**: `prove`
- **Sorries in scope**:
  - `kbarChart1Ring_specMap_fac` (~L326)
  - `iotaGm_chart1_appIso_eval` (~L534)
- **New helpers to build (3, axiom-clean, ~25-45 LOC total)**:
  1. `Proj.basicOpenIsoSpec_inv_app_top` (~5-15 LOC) — the
     iter-196 prover's named missing intermediate; the blueprint
     writer landed the recipe at
     `chapters/AbelianVarietyRigidity.tex` `lem:basicOpenIsoSpec_inv_app_top`.
     Recipe: `Scheme.invApp` + `Proj.basicOpenIsoSpec_hom` +
     `Proj.basicOpenToSpec_app_top`.
  2. `Proj.awayι_app_basicOpen` (~10-15 LOC) — section-level formula.
     Recipe per blueprint
     `lem:awayi_app_basicOpen` (writer-rewrote Step 1 to use
     `Proj.awayι_eq_specMap_fromSpec`): rewrite via the bridge
     iso → `Scheme.Hom.comp_app` split → `fromSpec.app ⊤` (via
     Mathlib's `IsAffineOpen.fromSpec_app_self`) +
     `Spec.map(basicOpenIsoAway.inv).app _` (via `Spec.map_appTop`).
     This route AVOIDS the dependent-motive obstruction.
  3. `Proj.awayι_appIso_top_inv_apply_isLocElem` (~5-10 LOC) —
     point-value via `Scheme.Hom.appIso_inv_app` + `awayToSection_apply`
     + `Proj.awayι_app_basicOpen`.
- **HARD BAR**: close ≥1 of the 2 Lane E sorries axiom-clean. This
  is the iter where the 9-iter STUCK signal must end.
- **PUSH-BEYOND**: close BOTH + `kbarChart1Ring_pullback_collapse`
  (L439) via `pullbackSpecIso`. The iter-197 LOC budget is tight;
  if 2 of 2 closes, attempt the third as bonus.
- **References**:
  - `analogies/lane-e-proj-appiso-pivot.md`
  - `task_results/AlgebraicJacobian/AbelianVarietyRigidity.md`
  - `blueprint/src/chapters/AbelianVarietyRigidity.tex` Lane E
    recipe section (`lem:basicOpenIsoSpec_inv_app_top`,
    `lem:awayi_eq_specMap_fromSpec`, `lem:awayi_preimage_basicOpen_self`,
    `lem:awayi_app_basicOpen`, `lem:awayi_appIso_top_inv_apply_isLocElem`).

## Lane I: WeilDivisor `hy_ne_bot` closure

- **File**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Prover mode**: `prove`
- **Sorries in scope**:
  - `hy_ne_bot : y.asIdeal ≠ ⊥` (the single named residual inside
    `isRegularInCodimOneProjectiveLineBar`).
- **Closure recipe** (~5-10 LOC):
  - The point `y : Spec(Away 𝒜 X_i)` corresponds to `Y.point` of
    `(ProjectiveLineBar kbar).left` via the open immersion `𝒰.f i`.
    The `Y.coheight = 1` hypothesis is the coheight of `Y.point`
    in the Proj topology.
  - Step A: open immersion preserves coheight at points within its
    image (Stacks 02IZ — opens of locally Noetherian schemes
    preserve codimension data).
  - Step B: in `Spec(k̄[t])` (a 1-dim integral affine scheme),
    coheight-1 points are precisely the maximal ideals (Stacks
    005X — height/coheight reflect Krull dimension).
  - Step C: maximal ideals are non-zero (trivial in a non-field).
- **HARD BAR**: close `hy_ne_bot` axiom-clean;
  `isRegularInCodimOneProjectiveLineBar` becomes fully axiom-clean.
- **PUSH-BEYOND**: explore `degree_positivePart_principal_eq_finrank`
  body for structural advance. The Hartshorne I.6.12 function-field-
  determines-curve gap remains; do NOT attempt full closure (no
  Mathlib substrate `Scheme.Hom.ofFunctionFieldEmbedding` ships).
- **References**:
  - `task_results/AlgebraicJacobian_RiemannRoch_WeilDivisor.lean.md`
  - `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` §6

## Lane A: OCofP substrate-build sub-helper (i) algebraic Hartogs

- **File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- **Prover mode**: `mathlib-build`
- **Sorries in scope** (NOT iter-197 closure target — substrate-build):
  - `functionField_const_of_complete_curve_of_orderZero` (private,
    L1390) — Hartshorne I.3.4 / Stacks 02P0 gap.
- **iter-197 commit — sub-helper (i) algebraic Hartogs at codim-1**
  (~30-60 LOC):
  - Stacks 0BCK: for a locally Noetherian scheme `X` with
    `IsRegularInCodimensionOne X`, the global sections embed as
    `Γ(X, 𝒪_X) = ⋂_{Q : X.PrimeDivisor} 𝒪_{X, Q}` inside the
    function field.
  - Project-side construction: use the DVR-stalk identification
    from `Scheme.IsRegularInCodimensionOne` (already proven for
    `ProjectiveLineBar` via Lane I iter-196 Route 2) +
    `Subalgebra.toSubmonoid`-style API.
  - Statement candidate (named, typed, body open this iter):
    `functionField_mem_intersection_of_globalSection
    (X : Scheme.{u}) [IsIntegral X] [IsLocallyNoetherian X]
    [IsRegularInCodimensionOne X] (s : Γ(X, ⊤)) :
    ∀ Q : X.PrimeDivisor, 0 ≤ Scheme.RationalMap.order Q (toFunctionField s)`
    (or similar).
- **HARD BAR**: land sub-helper (i) `algebraic Hartogs at codim-1`
  axiom-clean OR `mathlib-build` mode delivers a precise sub-
  decomposition with no body-sorries (per mode invariant).
- **PUSH-BEYOND**: land sub-helper (ii) `Γ(C, 𝒪_C) = k̄` (the
  alg-closure argument with Hartshorne III.5.2 cohomology-finite-
  dimensionality input). If both land, `functionField_const_of_complete_curve_of_orderZero`
  closes; Lane A is fully axiom-clean.
- **Milestone**: parent helper closes by iter-200 after (i) + (ii)
  land. If iter-197 lands neither, the milestone rolls to iter-201.
- **References**:
  - `task_results/AlgebraicJacobian_RiemannRoch_OCofP.lean.md`
  - `blueprint/src/chapters/RiemannRoch_OCofP.tex` sub-claim (c)
    section + the new `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero`
    block.

## Lane H: H1Vanishing Route A OR Route B closure

- **File**: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- **Prover mode**: `mathlib-build`
- **Sorries in scope**:
  - `IsFlasque.constant_of_irreducible` non-empty branch (~L178).
  - `skyscraperSheaf_eq_pushforward_const` inner iso (~L855), gated
    on (or implementing) the new
    `skyscraperSheaf_iso_constantSheaf_punit` declaration.
- **Closure recipes** (prover's choice; both Mathlib-substrate-build):
  - **Route H-1**: provide
    `(constantSheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)).Full`
    + `.Faithful` instances for `[IrreducibleSpace X]` (~50-80 LOC).
    These are Mathlib upstreaming candidates. Cascade: the unit
    `η : (Functor.const Cᵒᵖ).obj A → ((constantSheaf J D).obj A).val`
    is iso on non-empty opens of irreducible X; lift any `y ∈ F(V)`
    via `η_V⁻¹`, push back via `η_U`. Closes non-empty branch.
  - **Route H-2**: construct
    `Scheme.skyscraperSheaf_iso_constantSheaf_punit` directly
    pointwise on the two opens of PUnit (~50-80 LOC). Forward map:
    `constantSheafAdj.homEquiv.symm` + `simp [skyscraperPresheaf]`.
    Inverse map: `IsTerminal.uniqueUpToIso` at `⊥` + constantSheaf-
    unit-iso at `⊤`. Naturality via `Subsingleton` of terminal.
    Closes the inner iso ⟹ `skyscraperSheaf_eq_pushforward_const`
    closes.
- **HARD BAR**: close ≥1 sorry axiom-clean. The 4-iter CHURNING
  signal must end this iter.
- **PUSH-BEYOND**: close BOTH (both routes together close 2 sorries
  + the third (`shortExact_app_surjective`-like assembly already
  axiom-clean iter-195) cascade).
- **References**:
  - `task_results/H1Vanishing.lean.md`
  - `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` —
    `lem:isFlasque_constant_irreducible` updated proof note
    (Mathlib-gap routes A/B) and the new
    `lem:skyscraperSheaf_iso_constantSheaf_punit` sub-lemma.
