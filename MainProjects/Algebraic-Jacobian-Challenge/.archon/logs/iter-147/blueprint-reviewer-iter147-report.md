# Blueprint Review Report

## Slug
iter147

## Iteration
147

## Top-level summaries

### Incomplete parts

None. All 11 chapters carry the mathematical content the strategy
snapshot requires.

The two iter-146 must-fix chapters are re-confirmed complete:

- `RigidityKbar.tex`: KDM (p1) 4-substep recipe (p1.a–p1.d) lands as a
  concrete Cartier-direction decomposition citing Stacks Tag 07F4
  (L2042–L2058). New first-class helper
  `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` at
  L1997–L2021 absorbs the previously-hidden chart-of-proper-curve
  hypothesis of KDM step (p3). β-core Step 3 (L1916–L1938) is now a
  2-chart Čech argument citing
  `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` plus
  the chart-algebra (α) helper, with a Step 3.aux paragraph
  constructing the 2-chart cover (Stacks Tag 0F8L). The Genus.lean
  "H¹=0 phantom precedent" citation is replaced by a concrete pointer
  to `chap:Cohomology_MayerVietoris`.
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: 87 LOC, disposition
  paragraph at L10–L36 accurately catalogs the surviving in-tree
  declarations (3 piece (i.a) closed + 3 orphan public helpers + 2
  private internal helpers); zero sorry-bodied declarations claim
  matches the actual Lean state (file has 9 `sorry` matches but all
  are in docstrings/comments — confirmed by grep).
- `Cohomology_MayerVietoris.tex`: post-iter-147 plan-agent fix, all
  five flagged empty `\uses{}` lines are gone (L132–137, L139–142,
  L180–185, L187–190, L627–635). Each of the three definitions
  (`def:Scheme_ModuleCat_free_isLeftAdjoint`,
  `def:Scheme_ModuleCat_free_preservesMonomorphisms`,
  `def:Abelian_Ext_chgUnivLinearEquiv`) and their proof blocks is now
  cleanly free-standing.

### Proofs lacking detail

None at must-fix-this-iter severity. Two `informational` items:

- `RigidityKbar.tex` / `lem:Scheme_Over_ext_of_diff_zero` proof
  (L2099–L2115): Steps 1 (`d(μ ∘ ⟨f, ι ∘ g⟩) = 0`), 2 (per-chart
  chart-by-chart), and 3 (sheaf-assembly + `ext_of_eqOnOpen` packaging)
  are sketched but a NOTE block at L2074–L2088 explicitly discloses
  that the iter-146 Lean signature is *not* the blueprint statement:
  the Lean signature drops `df = dg` and takes `eqOnOpen` directly.
  The NOTE flags the iter-147+ refinement that would re-encode `df =
  dg`. This is documented divergence, not a defect.
- `Jacobian.tex` / `def:positiveGenusWitness` proof block (L430–L442):
  body is a one-paragraph pointer to Route A of
  `thm:nonempty_jacobianWitness`. Given M3 is off-critical-path and
  scheduled iter-170+, this is adequate as a scaffold proof; the
  detailed A.1–A.4 substep decomposition lives in
  `thm:nonempty_jacobianWitness` Route A above.

### Lean difficulty quality

All 12 active `\lean{...}` hints in `RigidityKbar.tex` (i.e., not
commented out as iter-146 dispositions) point to real Lean
declarations of the correct shape:

- `AlgebraicGeometry.rigidity_over_kbar` — present in
  `RigidityKbar.lean:75`.
- `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (+ companions
  `cotangentSpaceAtIdentity_eq_extendScalars`,
  `cotangentSpaceAtIdentity_finrank_eq`) — present in
  `Cotangent/GrpObj.lean`.
- `AlgebraicGeometry.GrpObj.shearMulRight`,
  `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility`,
  `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`
  — all three orphan public helpers present in
  `Cotangent/GrpObj.lean`.
- `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product`,
  `AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart`
  (sorry-bodied), `AlgebraicGeometry.constants_integral_over_base_field`
  (partial), `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  (sorry-bodied), `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`
  (signature-reduced thin renaming) — all five present in
  `Cotangent/ChartAlgebra.lean`.

Note: the new helper
`lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
(L1997–L2021) carries no `\lean{...}` hint, by design: it is a
blueprint-only forward declaration that the iter-147+ KDM ring-side
prover lane will close as a black-box helper at consumer-site
invocation. Acceptable.

### Multi-route coverage

- **Route C — chart-algebra piece (ii)** (iter-144 committed, M2
  critical path): **PASS**. Covered in `RigidityKbar.tex`
  § "Chart-algebra piece (ii) first-class decomposition" (L1828–L2115)
  with five first-class declaration blocks (α / β-core / β-aux
  constants / β-aux-chart helper / scheme-lift). The β-core Step 3
  cohomological invocation routes cleanly to
  `chap:Cohomology_MayerVietoris` via
  `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`.
  Per-substep LOC envelopes are documented; Mathlib status is
  marked `[verified]` / `[gap]` per piece.
- **Route A — Picard scheme via FGA** (iter-144 committed, M3
  off-critical-path): **PASS**. Covered in `Jacobian.tex` § "Route A
  --- Picard scheme" (L255–L284) with A.1–A.4 sub-step decomposition
  and Mathlib-status itemisation; further consumed in
  `def:positiveGenusWitness` (L420–L442) as the gated body closure.
- **Route B — Symmetric powers + Stein factorisation** (historical
  alternative, NOT pursued): **N/A**. Documented as historical-only at
  `Jacobian.tex` L286–L313, with explicit "not pursued" labels at L286,
  L370, L374, L437. The strategy snapshot does not list Route B as
  active, so its inactive-coverage status is intentional and correct.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 89 LOC. Three named blocks (`def:ofCurve`, `lem:comp_ofCurve`,
    `thm:exists_unique_ofCurve_comp`) each backed by a single
    Albanese-witness projection. Classical line-bundle description is
    recorded as remarks. Cross-references to
    `thm:nonempty_jacobianWitness`, `def:IsAlbanese`,
    `thm:rigidity_over_kbar` all resolve.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 87 LOC. Iter-146 Wave 2 writer absorption: disposition paragraph
    + 3 surviving public orphan-helper bullets + acknowledgment of
    2 private structural helpers. Each orphan bullet carries an
    "Iter-146+ cleanup candidate" marker.
  - Minor informational discrepancy with STRATEGY.md's "5 orphan
    helpers" framing: pointer chapter counts the
    `shearMulRight` companions as one bullet (so 3 public orphan
    bullets); STRATEGY.md's bullet list reads
    `shearMulRight + companions, schemeHomRingCompatibility,
    isIso_of_app_iso_module,
    relativeDifferentialsPresheaf_restrict_along_identity_section` (4
    items). The chapter's classification of
    `isIso_of_app_iso_module` as a *private* internal helper (which
    the actual Lean code confirms: `private theorem` at the
    declaration site) is arguably more accurate than STRATEGY.md's
    counting it as a top-level orphan. Either framing is defensible;
    flagging for the strategy-critic but not as a blueprint-side
    defect.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 942 LOC. Post-iter-147 plan-agent empty-`\uses{}` removal at L136,
    L141, L186, L191, L634 verified clean. All three foundational
    definitions and their proof blocks are now free-standing (no
    upstream dependencies expected for the free-`k`-module functor's
    adjoint property, monomorphism preservation, or the
    universe-bump linear equivalence). Plastex builds should now
    succeed.
  - `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` at
    L516 is the load-bearing import consumed by RigidityKbar.tex
    β-core Step 3 (L1930, L1938, L1948, L1950).

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: 40 LOC; single auxiliary theorem
  `thm:HasSheafCompose_forget` with clean two-step preservation proof.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: 78 LOC; Phase-A scaffold delivering sheafification,
  `Ext`, and `toAbSheaf`. All three blocks clean.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: 655 LOC. The longest auxiliary chapter, structured as
  Phase-A step 5 plus the wholespace Hom-finiteness producer.
  Cross-references to MV chapter (X₄ corner bridge, `HasCechToHModuleIso`
  carrier) resolve cleanly. Self-consistent.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**: 209 LOC. `def:relative_kaehler_presheaf`,
  `lem:relative_kaehler_presheaf_obj`,
  `thm:smooth_locally_free_omega` are the live consumers (the last
  consumed by both `lem:GrpObj_cotangentSpace` and
  `lem:GrpObj_lieAlgebra_finrank` in RigidityKbar). The M4 false-iff
  counter-example and M5–M8 deferred-list both honest. Standalone
  Kähler-localisation utilities (`kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`) preserved as upstream-PR
  candidates.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: 69 LOC. `def:genus` cleanly defined as
  `Module.finrank k (HModule k toModuleKSheaf C 1)`. The chapter
  honestly disclaims that the genus is *defined* but not *computed*;
  Serre finiteness gap explicit. **Cross-reference correctness:** the
  iter-146 RigidityKbar β-core (L1938) explicitly REPAIRS the
  pre-iter-146 mis-citation that called Genus.lean's `H¹(C, O_C) = 0`
  computation "the running model" — Genus.tex contains no in-tree
  `H¹` vanishing computation; the iter-146 fix correctly redirects the
  invocation to the abstract MV theorem
  `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**: 452 LOC. Twelve declaration blocks
  (`def:IsAlbanese` + extraction trio + uniqueness theorem +
  Jacobian definition + four `Jacobian.*` properties +
  `def:JacobianWitness` + `thm:nonempty_jacobianWitness` + the two
  genus-arm scaffolds). Route A (active M3 commitment) + Route B
  (historical) + genus-0 sub-case (C.1–C.3) all decomposed. The
  iter-127 over-k commitment is correctly reflected:
  C.2.f (Galois descent) is documented as DROPPED, and the genus-0
  arm's `def:genusZeroWitness` routes through `thm:rigidity_over_kbar`
  directly over `k`.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**: 71 LOC. `thm:GrpObj_eq_of_eqOnOpen` is the iter-125
  scheme-level packaging of dominant-source / separated-target
  rigidity, consumed by both the M2.a chart-algebra scheme-lift
  (`lem:Scheme_Over_ext_of_diff_zero`) and the uniqueness half of
  the Albanese property (`thm:exists_unique_ofCurve_comp`). Mathlib
  citation `ext_of_isDominant_of_isSeparated'` is verified.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2132 LOC. Largest chapter, hosting (a) the named declaration
    `thm:rigidity_over_kbar`, (b) the shared cotangent-vanishing
    pile pieces (i)–(iv) with detailed sub-lemma decomposition, (c)
    the iter-144 chart-algebra pivot disposition + envelope, (d)
    iter-145 bundled-route EXCISE disposition keeping blueprint
    blocks as auditable history, (e) the iter-146 first-class
    five-block chart-algebra piece (ii) decomposition at
    L1828–L2115, (f) the iter-146 KDM (p1) 4-substep recipe + new
    `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
    helper.
  - **Iter-146 must-fix items re-verified resolved:** (1) KDM (p1)
    expansion lands as substeps (p1.a)–(p1.d) at L2042–L2058 with
    concrete Mathlib-name pointers (D_add, D_mul,
    `Algebra.IsStandardSmooth.free_kaehlerDifferential`,
    rank_kaehlerDifferential, character-p Cartier-direction
    `c := ∑ c_{pβ}^{(p)} x^β`). (2) New helper at L1997–L2021
    extracts the chart-of-proper-curve hypothesis; KDM step (p3)
    at L2060 explicitly invokes it. (3) β-core Step 3 rewrite at
    L1916–L1938 cites 2-chart cover existence (Stacks 0F8L) +
    chart-algebra (α) gluing + abstract MV theorem
    `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`,
    replacing the iter-145 mis-cited Genus.lean "phantom
    precedent". (4) 8 broken `\lean{...}` hints to
    iter-145-EXCISED declarations are stripped as iter-146 NOTE
    blocks; the EXCISE disposition paragraph at L489–L490 preserves
    the blocks as `\notready` auditable record.
  - **Active `\lean{...}` cross-check:** 12 active hints, all resolve
    to existing declarations in `Cotangent/GrpObj.lean`,
    `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`. No broken
    references.
  - **Iter-146 signature-vs-blueprint disclosed divergences:**
    `Scheme.Over.ext_of_diff_zero` (signature drops `df = dg`),
    `constants_integral_over_base_field` (carries explicit
    `[IsReduced X]`). Both documented in NOTE blocks at L2074–L2088
    and L1957–L1965 respectively with explicit iter-147+ refinement
    plans. Acceptable as iter-146 prover-lane closures.

## Cross-chapter notes

- The `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  citation from `RigidityKbar.tex` (β-core Step 3, four occurrences
  at L1893, L1930, L1938, L1948–1950) resolves correctly to
  `Cohomology_MayerVietoris.tex:516`. The MV chapter's
  `\HasCechToHModuleIso` + `\HasAffineCechAcyclicCover` carrier
  framework supplies the abstract instance the β-core consumer
  needs.
- `Genus.tex`'s honest "this chapter does not compute `H¹`" framing
  pairs correctly with RigidityKbar's iter-146 redirect of the
  β-core Step 3 invocation to the abstract MV theorem rather than
  to a non-existent Genus.lean precedent.
- The MV-chapter producer-status disclosure (L942: "the two carrier
  classes are currently unproduced; the project's autonomous-loop
  scope does not include a producer instance for either") is
  consistent with the project's no-Serre-finiteness-named-theorem
  commitment. RigidityKbar β-core consumes the abstract sequence
  exact theorem directly without instantiating
  `HasCechToHModuleIso`, which is the right idiom for the genus-0
  chart-Čech case.

## Strategy-modifying findings

None. The strategy snapshot from the directive is internally
consistent with the chapter content. No re-strategy needed.

## Severity summary

- **must-fix-this-iter** — none.
  - All 11 chapters are `complete: true / correct: true`.
  - Both iter-146 Wave-2 writer-revised chapters
    (`RigidityKbar.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`)
    re-confirmed compliant; iter-147 watch criterion #1 is GREEN.
  - `Cohomology_MayerVietoris.tex` post-iter-147 plan-agent empty-
    `\uses{}` fix is verified correct; no new finding.
  - Multi-route coverage: Route A PASS, Route C PASS, Route B N/A
    (intentionally historical).
  - No broken `\uses{}` cross-references; no Lean-difficulty-quality
    poor-target findings.
- **soon** — none.
- **informational**:
  - Minor framing mismatch between the pointer chapter
    (3 public + 2 private orphan helpers) and STRATEGY.md
    (4 orphan-helper bullet list, conflating
    `isIso_of_app_iso_module` as top-level). The pointer chapter's
    classification is more accurate (the Lean file has
    `isIso_of_app_iso_module` as `private theorem`); a future
    STRATEGY.md cleanup pass could reconcile.
  - The iter-146 signature reductions in `ChartAlgebra.lean`
    (`Scheme.Over.ext_of_diff_zero` drops `df = dg`;
    `constants_integral_over_base_field` carries explicit
    `[IsReduced X]`) are well-documented in NOTE blocks with
    iter-147+ refinement plans. Provers should consult the blueprint
    NOTE blocks (L2074–L2088, L1957–L1965) before re-targeting these
    declarations.

**Overall verdict:** All 11 chapters audited at
`complete: true / correct: true`; both iter-146 must-fix chapters
re-confirmed clean post Wave-2 writer + iter-147 plan-agent MV fix;
multi-route coverage is in place; no must-fix items for this iter,
HARD GATE clears for the iter-147+ β-core + KDM prover lane.
