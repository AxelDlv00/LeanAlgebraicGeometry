# Blueprint Review Report

## Slug
iter108

## Iteration
108

## Top-level summaries

### Incomplete parts
- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 2 (lines 1162–1166): "Identification of the localized complex" gives the mathematical content (localization at `f` identifies the factor at `(f₀,…,fₙ)` with `O_X(U)[1/(f·f₀⋯fₙ)]` and rebuilds the slice-cover Čech complex) but does **not** preview the four Mathlib-API plumbing pieces the prover demonstrably needs at `BasicOpenCech.lean` L1846 — `Finset.inf'` image-bridge, `Scheme.basicOpen_res`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `IsLocalizedModule.pi` (plus the `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` adapter). The carryover from iter-107 lean-vs-blueprint-checker was "soon → should-fix-soon"; the iter-108 directive escalates the question because two consecutive prover iterations hit Steps 1c–4 as a structural blocker at this exact site. Severity is conditional on the plan agent's Phase A escape-valve choice (see Severity summary). The chapter is mathematically complete and structurally sound; the gap is in the operational level of prose detail at one proof block.

### Proofs lacking detail
- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 2: see the bullet above. The chapter's `\uses{...}` graph at L1155 *does* correctly list `basicOpenCover_finset_inf_eq_basicOpen_prod`, `basicOpenCover_finset_inf_le`, `basicOpenCover_finset_inf_isLocalization`, `splitEpi_pi_lift_of_injective`, and the cochain-exactness reducer — the dependency map is fine. The deficit is purely in the inline explication: Step 2 jumps from "localizing identifies the factor" to "Reassembling … naturally isomorphic to the Čech complex of `D(f)`" without spelling out the per-coordinate `IsLocalization.Away` (via `IsAffineOpen.isLocalization_of_eq_basicOpen` + `Scheme.basicOpen_res`), the finite-product lift (`IsLocalizedModule.pi`), and the `Function.Exact` ladder transport. The prover's exact stuck point at L1781–L1846 matches this gap.
- `Cohomology_MayerVietoris.tex` § "Use in the project" (L1182–L1184): closes by claiming the chain delivers `\IsAffineHModuleVanishing` and Phase A step 6, but does not flag that the substantive theorem currently rests on a `sorry` whose closure is the gating obstruction. A one-line status acknowledgement would make the chapter self-contained on the current project state.
- `Differentials.tex` / `\lem:cotangent_exact_structure` `\emph{Exactness at the middle}` (lines 92–93): the deferral note is detailed and accurate, but the prose does not say what the current Lean status of the `sorry` is or which iter introduced/reverted it; the `% NOTE (iter-086+iter-087)` is comprehensive but still narrating actions from 20+ iters ago. This is a presentation hygiene item, not a correctness issue.

### Lean difficulty quality
- All sampled `\lean{...}` hints resolve cleanly to declarations of matching signature. Spot-checked:
  - `AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf` → BasicOpenCech.lean:1170 ✓
  - `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization` → BasicOpenCech.lean:330 ✓
  - `AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt` → BasicOpenCech.lean:404 ✓
  - `AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective` → BasicOpenCech.lean:362 ✓
  - `AlgebraicGeometry.Scheme.HModule` / `HModule'` → StructureSheafModuleK.lean:248,295 ✓
  - `AlgebraicGeometry.Scheme.instCommGroupLineBundle` → Picard/LineBundle.lean:96 ✓
  - `AlgebraicGeometry.Scheme.PicardFunctor.representable` → Picard/Functor.lean:185 ✓
  - `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` → Differentials.lean:517 ✓
  - `AlgebraicGeometry.Jacobian.instGrpObj` → Jacobian.lean:209 ✓
  - `AlgebraicGeometry.nonempty_jacobianWitness` → Jacobian.lean:176 ✓
  - `AlgebraicGeometry.Jacobian.ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp` → AbelJacobi.lean:51,62,82 ✓
- No "poor quality" hints observed.

### Multi-route coverage
- Strategy is single-route this iter (no fork). The directive's two-option L1846 escape-valve menu is a routing decision about *deferral*, not about alternative mathematical proofs. Both options are blueprint-compatible:
  - **Option (i)** (defer L1846 as 4th Mathlib gap): requires Cohomology_MayerVietoris.tex Step 2 to gain a labelled named-Mathlib-gap sub-block — dispatch a writer this iter.
  - **Option (ii)** (fire C1 promotion): blueprint coverage is already in place (Modules_Monoidal.tex, Picard_LineBundle.tex § "Status note (Phase C1)", Picard_Functor.tex § "Forward-compatibility note"); no writer dispatch needed for this option.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:HasSheafCompose_forget` → `instHasSheafCompose_forget_CommRing_AddCommGrp`; statement and 5-line proof sketch are adequate for a prover. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three core declarations (`HasSheafify_Opens_AddCommGrp`, `HasExt_Sheaf_Opens_AddCommGrp`, `Scheme.toAbSheaf`) all well-specified. Proof sketches name the inferable Mathlib instances and the universe-pinning gymnastic. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655 lines, ~25 declarations, all `\lean{...}` hints sampled resolve. The two-flavour `HModule` / `HModule'` distinction is well-motivated (reducible-abbrev for instance synthesis); the carrier predicates `IsAffineHModuleVanishing`, `IsAffineHModuleHomFinite`, `IsHModuleHomFinite`, `IsCechAcyclicCover` are clearly stated. The Stein-finiteness / proper-curve `H⁰` chain is fully sketched. Mathlib gap acknowledgements are in place. No issues.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 1185 lines covering the abstract MV LES, two-affine cover specialisation, Čech-acyclicity / comparison-iso machinery, basic-open infrastructure, and the affine Čech-acyclicity substantive theorem. Cross-references and `\lean{...}` hints all check out.
  - **Step 2 of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is under-specified for the prover** — see Top-level "Proofs lacking detail". This is the carryover from iter-107 lean-vs-blueprint-checker; iter-108 prover's PARTIAL outcome on Steps 1c–4 confirms that the bare mathematical sketch is not enough operational guidance to formalize against current Mathlib without the four named API pieces.
  - "Use in the project" subsection (L1182) does not acknowledge that `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` currently rests on an unclosed `sorry` (`BasicOpenCech.lean` L1120 PAUSED, L1846 newly escape-valve-triggered); a status snippet would be useful.
  - All other sections (MV LES abstract construction, `AffineCoverMVSquare`, top-supremum bridge, instance-driven transport, basic-open intersection helpers) are correct and adequately detailed.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - The `\thm:cotangent_exact_sequence` and its decomposition into α/β + `cotangentExactSeq_structure` are well-developed. The Lean-side `case h_exact` deferral parallels the `instIsMonoidal_W` Mathlib gap and is appropriately flagged in the chapter prose (carryover from iter-086/087; chapter prose says "deferred upstream parallel to instIsMonoidal_W").
  - `\thm:smooth_iff_locally_free_omega` (`smooth_iff_locally_free_omega` at Differentials.lean:711) and `\cor:cotangent_at_section` (727) carry compact proof sketches that name the Jacobian criterion and Nakayama, but neither sketch covers the practical Mathlib API needed to formalize them. Marked partial because these are open prover targets in Phase B and the prose is at sketch level only.
  - `\thm:serre_duality_genus` (Differentials.lean:871) — the directive flags `serre_duality_genus` as variance-risk; the blueprint statement says only "the equality is the dimension-one case of Serre duality" with no Mathlib-API plan. This is a known forward-looking placeholder rather than an active iter-108 prover target, but if it enters PROGRESS.md its proof needs expansion before any prover dispatch.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:genus` is honestly closed at the definition level (`Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`) and the noncomputable-modifier authorisation note is in place. Equivalence statements (Riemann–Roch, Serre duality, complex topology) appropriately deferred. § "Mathlib gap" clearly identifies Serre finiteness as the remaining theorem-level obstruction. No issues.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:Modules_tensorObj`, `\thm:Modules_MonoidalCategory` (= `instMonoidalCategory`), `\def:Modules_Invertible` all well-stated. Remark on `W.IsMonoidal` deferral parallels `cotangentExactSeq_structure.h_exact` and is explicit about the absent Mathlib stalk-of-presheaf-tensor identification in the varying-ring case. Forward-compatibility hook to Picard_LineBundle.tex § C1 is in place. No issues.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-105+ flagged "missing acknowledgement of weakened-wrong approximation" issue has been addressed: § "Status note (Phase C1)" (lines 17–27) explicitly names `LineBundle X := CommRing.Pic Γ(X, ⊤)`, the Stacks 0AGS subgroup-only behaviour on non-affine schemes, the `Pic(ℙⁿ_k) = ℤ` vs. `CommRing.Pic(k) = trivial` witness, and the planned C1 refactor target (`MonoidalCategory.Invertible (X.Modules)`). Both downstream `\leanok` markers (on `Pic_commGroup` and `Pic_pullback`) are commented with re-confirmation notes for the post-C1 state. Forward-compatibility is correctly in place.
  - No further blueprint-side action needed *for the LineBundle chapter*. The substantive resolution lives in the Lean refactor (C1 promotion).

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:Pic_functor`, `\thm:Pic_representable` (= `PicardFunctor.representable`) signatures match; the representability sorry is openly acknowledged as a multi-iteration FGA-level Mathlib gap with the four-step C0–C3 decomposition. § "Forward-compatibility note (LineBundle approximation)" (lines 75–77) correctly names the strict-subgroup hazard on non-affine `S` and instructs that the representable sorry must not be attacked on the approximate definition. Consistent with Picard_LineBundle.tex. No issues.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three core declarations (`PicardFunctorAb`, `PicardFunctorAb.forgetCompare`, `PicardFunctorAb.etaleSheafified`) all resolve. The natural-iso forget-and-recover is correctly stated as "identity in disguise". Universe-pinning note (`{u+1}` lift before étale sheafification) is explicit. No issues.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:IsAlbanese`, `\def:Jacobian`, `\thm:nonempty_jacobianWitness`, and the four Albanese-projected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) all resolve to Jacobian.lean with matching signatures. The dual-route construction (Pic-scheme / Sym^g-Stein / genus-0 rigidity) is recorded with appropriate "Mathlib gap" wrapper. No issues.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:ofCurve`, `\lem:comp_ofCurve`, `\thm:exists_unique_ofCurve_comp` resolve cleanly. The bundled Albanese-framework route is explicit. § "Implementation route via the Albanese framework" correctly explains the choice of bundling everything into `nonempty_jacobianWitness` rather than via Pic-scheme. No issues.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:GrpObj_eq_of_eqOnOpen` (= `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`) statement and proof sketch are detailed enough for a prover round: equaliser-is-closed, separated target, irreducible source, reducedness from smoothness, group-object difference morphism. § "Mathlib ingredients" gives an explicit punch list. No issues.

## Cross-chapter notes

- **`basicOpenCover` API consistency**: Cohomology_MayerVietoris.tex § "Basic-open cover infrastructure" (lines 941–1108) lists six helper theorems on `basicOpenCover` (`supr_of_span_eq_top`, `isAffineOpen`, `inter_eq_basicOpen_mul`, `inter_isAffineOpen`, `finset_inf_eq_basicOpen_prod`, `finset_inf_isAffineOpen`, `finset_inf_le`, `finset_inf_isLocalization`). All match BasicOpenCech.lean L55–L361. However the chapter's Step 2 prose for `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` does not invoke these helpers by name. Re-using the helper labels by name in Step 2's prose would close the operational gap without expanding the chapter substantively. (One sentence per helper.)
- **`Differentials.tex` ↔ `Modules_Monoidal.tex` parallel**: both chapters defer one substantive sorry to Mathlib upstream and structure the deferral the same way (named gap + status remark). Cross-references between the two are not currently explicit; an `\uses{}` from `\lem:cotangent_exact_structure` to the `W.IsMonoidal`-style status remark in Modules_Monoidal.tex would make the parallel structurally visible. Minor — not blocking.
- **`Picard_LineBundle.tex` ↔ `Modules_Monoidal.tex` ↔ `Picard_Functor.tex` forward-compatibility chain**: all three chapters now consistently flag the C1 refactor obligation. Picard_LineBundle.tex § "Status note (Phase C1)" (lines 17–27), Modules_Monoidal.tex § "Invertible objects and line bundles" (lines 65–72), Picard_Functor.tex § "Forward-compatibility note" (lines 75–77). The trio is internally consistent; no drift detected.

## Strategy-modifying findings (if any)

None.

The two L1846 escape-valve options (defer-as-Mathlib-gap vs. fire-C1-promotion) are both already covered by existing strategy chapters and existing forward-compatibility notes. No definition is mis-stated; no `\lean{...}` hint pulls toward the wrong type. The plan agent's choice is a scheduling decision, not a strategy modification.

## Severity summary

- **must-fix-this-iter** — **conditional on the plan agent's Phase A escape-valve choice**:
  - **If Option (i) (defer L1846 as 4th named Mathlib gap)**: dispatch a `blueprint-writer` for `Cohomology_MayerVietoris.tex` this iter, targeting `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 2. The writer should (a) expand Step 2 to name the four Mathlib pieces (`Finset.inf'` image-bridge, `Scheme.basicOpen_res`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `IsLocalizedModule.pi`) and the `instIsLocalizedModuleToLinearMapToAlgHom...` adapter, (b) add a labelled named-Mathlib-gap sub-block explaining why L1846 is deferred to a future Mathlib upstream fix, and (c) add the missing status acknowledgement to the chapter's § "Use in the project". The hard gate fires because the chapter is marked `complete: partial` and `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is the active iter-108 prover target.
  - **If Option (ii) (fire C1 promotion)**: no must-fix items. The Cohomology_MayerVietoris.tex Step 2 finding drops to "soon" because the iter-109 prover dispatch on `BasicOpenCech.lean` is deferred behind the C1 refactor.
- **soon** — independent of escape-valve choice:
  - `Cohomology_MayerVietoris.tex` § "Use in the project" status acknowledgement of the open sorry at the substantive theorem.
  - `Differentials.tex` `\thm:smooth_iff_locally_free_omega` and `\cor:cotangent_at_section` proof sketches at the sketch-only level — fine for Phase B horizon, but should be expanded *before* either is added to PROGRESS.md as an active prover objective.
  - `Differentials.tex` `\thm:serre_duality_genus`: the directive flagged variance-risk; the blueprint statement has no Mathlib-API plan and currently only handwaves "dimension-one Serre duality". Promote to must-fix if and when this enters an active prover route.
  - `Differentials.tex` `\lem:cotangent_exact_structure` `% NOTE` is still narrating iter-086/087 actions; a one-line "Status (iter-108):" line referencing the current Lean-level status would freshen the prose without changing the math.
- **informational**:
  - Cross-chapter consistency between Differentials.tex `h_exact` and Modules_Monoidal.tex `W.IsMonoidal` is correct and could be made explicit via a `\uses{}` link, but the omission does not block any prover.
  - The Picard chain (LineBundle → Functor → FunctorAb) is internally consistent on the C1 forward-compatibility messaging.

**Overall verdict**: 13 chapters audited, 2 marked `complete: partial` (`Cohomology_MayerVietoris.tex`, `Differentials.tex`) and 11 fully clean; the only must-fix item is conditional on Phase A Option (i) and targets exactly one proof block — Cohomology_MayerVietoris Step 2 of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` — which the plan agent can resolve by dispatching a `blueprint-writer` with a tightly-scoped directive.
