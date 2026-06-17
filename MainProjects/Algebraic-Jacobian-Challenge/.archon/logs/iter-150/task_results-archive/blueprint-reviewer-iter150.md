# Blueprint Review Report

## Slug

iter150

## Iteration

150

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition": every load-bearing block is structurally present (chart-algebra (α) `algebra_isPushout_of_affine_product`; chart-algebra (β-core) `df_zero_factors_through_constant_on_chart`; the four (S3.*) sub-claims; KDM `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`; (β-aux) `constants_integral_over_base_field`; (β-aux-chart) `KaehlerDifferential_constants_in_chart_of_proper_curve`; scheme-level lift `Scheme_Over_ext_of_diff_zero`). No mathematically missing blocks in this section relative to the strategy.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` proof block (lines 2058–2065): the closure logic conflates two distinct chase steps. Sentence "Its nilradical reduction $(F \otimes_k \bar k) / \mathrm{Nil}$ has the same prime spectrum and, with the unique-minimal-prime hypothesis, is an Artinian integral domain finite over $\bar k$ --- hence a field finite over $\bar k$" elides the step that the nilradical reduction is a *product* of Artinian local domains, then uses unique-min-prime to force a single factor. The blueprint proof in (S3.sep.2) (`lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`, lines 2010–2017) does articulate the product-of-fields decomposition explicitly; the (S3.pi.2) block should mirror that articulation. Soon-severity nudge for the writer: add one sentence on "Artinian + unique minimal prime ⇒ local" (the prover-side comment at `ChartAlgebraS3.lean:291–295` makes this explicit; the blueprint should match).
- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart` proof Step 3 (lines 1952–1964): "chart-uniform existence is automatic" elides why the standard-smooth presentation of $\Omega_{A/k}$ on $W$ propagates to all preimages of $W$ in $C$ with the *same* generators $b_1, \ldots, b_g$. A reader would expect a short justification (presumably: pull the chart presentation back along $f$, and use that the basis $\{db_i\}$ is preserved by base change of Kähler modules). One sentence would suffice.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper}` (line 2024): the prover-side signature in `ChartAlgebraS3.lean:194` packages the conclusion as `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(X_K))`. The blueprint prose says "the canonical comparison map ... is an isomorphism" without specifying that the Lean target is the `Nonempty`-wrapped existence statement (and the implicit `pullback`-flavoured $X_K$ rather than a generic base-change object). The blueprint's existing Lean-target stub in `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` records the four target names but not the signatures. **soon-severity** since the prover-side scaffolding is already correct; the writer-side nudge is to add a Lean-signature stub comment in `RigidityKbar.tex:2023–2032` describing the `Nonempty (… ≃ₐ[K] …)` wrapper and `pullback` flavour of $X_K$.

### Multi-route coverage

- Route C (M2 critical path — chart-algebra piece (ii)): PASS — covered in `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" with the five-block decomposition (α, β-core, β-aux constants, β-aux-chart, β-core ring-side KDM, scheme-lift), plus the four (S3.*) sub-claims. The pointer chapter `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` correctly redirects.
- Route A (M3 off-critical-path — Picard scheme via FGA): PASS — covered in `Jacobian.tex` § "Existence of an Albanese variety" Route A. The four A-sub-steps (A.1 relative Picard functor; A.2 representability; A.3 identity component; A.4 Abel--Jacobi universal morphism) are present with `IsAlbaneseFor` consumer specification. Per the iter-144 disposition, Route B is documented as historical-only and explicitly NOT pursued — properly flagged.
- Alternative (over-$\bar k$ + Galois descent): PASS — documented at `STRATEGY.md` level with a rolling re-evaluation trigger; not formalised as a blueprint route because the trigger has not fired. No chapter coverage is required at iter-150 per strategy.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex

- **complete**: true
- **correct**: true
- **notes**:
  - The chapter is a pointer to `ChartAlgebraS3.lean` and correctly redirects mathematical content to `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition". The four (S3.*) sub-claim `\cref{...}` cross-references resolve correctly to labels in `RigidityKbar.tex` (lines 1985, 2002, 2023, 2050). The four `\texttt{...}` Lean targets named in the pointer match the actual declarations in `ChartAlgebraS3.lean` (lines 147, 256, 194, 306). The shared `gammaAlgebra` helper is correctly attributed to `ChartAlgebraS3.lean` and consumed by `ChartAlgebra.lean`.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **Undefined macro `\pr_1`, `\pr_2` in live prose** (lines 53, 59, 60): these are part of the "Lean declarations in this file" itemize block describing the post-iter-145 orphan helpers `shearMulRight` and its `_hom_fst`/`_hom_snd` companions. `\pr` is not declared in `blueprint/src/macros/common.tex`. KaTeX (used by the leanblueprint web dashboard) renders this as a literal `\pr_1` instead of $\mathrm{pr}_1$. Recommended fix: add `\DeclareMathOperator{\pr}{pr}` to `common.tex` (next to the existing `\DeclareMathOperator{\Sym}{Sym}` etc. block).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **Undefined macros `\HasCechToHModuleIso`, `\IsAffineHModuleVanishing`, `\HasAffineCechAcyclicCover` in live prose** (lines 809, 817, 825, 855, 885, 912, 923, 927, 940, 942): three carrier-class names are used inline as `$\HasCechToHModuleIso$` etc. but none are declared in `blueprint/src/macros/common.tex`. KaTeX renders them as the literal macro name. Recommended fix: add `\newcommand{\HasCechToHModuleIso}{\mathtt{HasCechToHModuleIso}}`, `\newcommand{\IsAffineHModuleVanishing}{\mathtt{IsAffineHModuleVanishing}}`, `\newcommand{\HasAffineCechAcyclicCover}{\mathtt{HasAffineCechAcyclicCover}}` to `common.tex` (matches the existing `\HasSheafify` / `\HasExt` / `\HasWeakSheafify` `\mathtt{...}` convention).
  - **`tikzcd` environment used at lines 66–69** for the abstract Mayer–Vietoris square. KaTeX (leanblueprint web) does not support `tikzcd`; the PDF version renders correctly via `tikz-cd`. Recommendation: either (a) ensure the project's leanblueprint web dashboard uses MathJax (which supports a `tikzcd`-like extension) rather than KaTeX, or (b) replace the `tikzcd` environment with a plain array-mode commutative square (matching the style of lines 1861–1867 of `RigidityKbar.tex`, which uses an `\begin{array}{ccc}` for an algebra-side pushout square). This is the same fix the user can apply uniformly to the one `tikzcd` site in the project. **soon-severity** — only one site, and only for web rendering; PDF is unaffected.
  - **Producer status** (line 942): the closing paragraph honestly documents that the two carrier classes `\HasCechToHModuleIso` and `\HasAffineCechAcyclicCover` are unproduced. This is correct conditional packaging and is not a correctness issue.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **Undefined macro `\Abelian` in live prose** at line 65: the sentence "$\Module.\mathtt{finrank}$, $\Abelian.\Ext.\mathtt{instModule}$, ..." uses `\Abelian` as if it were a namespace decoration, but `\Abelian` is not declared in `common.tex`. Recommended fix: add `\newcommand{\Abelian}{\mathrm{Abelian}}` to `common.tex` (matches the existing `\Module`, `\Algebra`, `\AlgCat` etc. convention). Or, alternatively, retypeset the offending line as `\mathtt{CategoryTheory.Abelian.Ext.instModule}` to match the actual Mathlib namespace.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **Invalid LaTeX `\thm{...}` cross-reference syntax** at line 10 (`$\thm{thm:nonempty_jacobianWitness}$`) and line 2319 (`$\thm{thm:rigidity_over_kbar}$`). `\thm` is not a valid cross-reference macro and is not declared in `common.tex`. KaTeX renders this as a literal `\thm{...}`. Recommended fix: replace each `$\thm{...}$` by `\cref{...}` (or `\ref{...}`); the labels themselves resolve correctly. Two surgical edits, ~30 seconds of writer work.
  - **Undefined macro `\app` in live prose** at lines 1549, 1552, 1562, 1577, 1579, 1701 (within the proof of `lem:GrpObj_omega_basechange_proj_inv_derivation`). The macro is used as `$\psi.\app\,X$` etc., presumably intended as Lean's `Scheme.Hom.app`. `\app` is not declared in `common.tex`. ~22 further occurrences exist inside `%`-comment blocks (which don't render but bloat the file). The live-prose lines are all inside the DESCOPED bundled-route helper lemma `lem:GrpObj_omega_basechange_proj_inv_derivation` (Iter-145 EXCISE disposition). Recommended fix: add `\newcommand{\app}{\mathrm{app}}` to `common.tex` (matches the existing `\toBiprod`, `\fromBiprod`, etc.). Alternatively, since the affected lemma is DESCOPED, the writer may strip the prose to `% NOTE:` comments (which would not render and would not require the macro fix).
  - **Undefined macro `\pr_1`, `\pr_2` in live prose** at lines 347, 348, 355, 357, 359, 434, 436, 453, 455, 459, 462, 545, 547, 549, 1533, 1761. All occurrences are in the DESCOPED bundled-route piece (i.b) Step 1–3 helper lemmas (`lem:GrpObj_shearMulRight`, `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`). Same fix as for `Cohomology_MayerVietoris.tex` / `AlgebraicJacobian_Cotangent_GrpObj.tex`: add `\DeclareMathOperator{\pr}{pr}` to `common.tex`.
  - **The "Chart-algebra piece (ii) first-class decomposition" section (lines 1828–2316) is rendering-clean**: I verified no `\app`, `\pr`, `\thm{...}`, `\HasCechToHModuleIso`, `\IsAffineHModuleVanishing`, `\HasAffineCechAcyclicCover`, `\Abelian` use in lines 1828–2316. The two iter-150 prover lanes (`ChartAlgebraS3.lean`, `ChartAlgebra.lean`) read against this section have no rendering blockers.
  - **`\lean{...}` ↔ Lean signature verification**: spot-checked the seven `\lean{...}` hints in the chart-algebra (ii) section against the actual prover-side declarations in `AlgebraicJacobian/Cotangent/{ChartAlgebra,ChartAlgebraS3}.lean`. All seven resolve to existing declarations with matching signatures: `algebra_isPushout_of_affine_product` (`ChartAlgebra.lean:86`), `df_zero_factors_through_constant_on_chart` (`ChartAlgebra.lean:222`), `isGeometricallyReduced_Gamma_of_smooth` (`ChartAlgebraS3.lean:147`), `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite` (`ChartAlgebraS3.lean:256`), `Gamma_baseChange_iso_tensor_of_proper` (`ChartAlgebraS3.lean:194`), `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange` (`ChartAlgebraS3.lean:306`), `constants_integral_over_base_field` (`ChartAlgebra.lean:279`), `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (`ChartAlgebra.lean:123`), `Scheme.Over.ext_of_diff_zero` (`ChartAlgebra.lean:492`).
  - **Citation surface for the four (S3.*) sub-claims and the (β-aux) `constants_integral_over_base_field` is honest and substantive**: each block has an explicit `\emph{Literature.}` paragraph citing Stacks Tags + Hartshorne/Bourbaki/Eisenbud sections. The chapter is in good citation health on this section.

## Cross-chapter notes

- The two pointer chapters `AlgebraicJacobian_Cotangent_GrpObj.tex` and `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` correctly route prose to `RigidityKbar.tex`. No content duplication. The pointer-chapter convention ("one chapter per Lean file") is followed consistently across the three `AlgebraicJacobian/Cotangent/*.lean` files.
- `Rigidity.tex` / `thm:GrpObj_eq_of_eqOnOpen` is consumed by `RigidityKbar.tex` / `lem:Scheme_Over_ext_of_diff_zero` (line 2260) and by `Jacobian.tex` / `def:genusZeroWitness` (line 403). The triangle of cross-references is consistent. The post-iter-125 scheme-level refactor (drop source-side group-object hypothesis) is properly documented at all three call sites.
- `Cohomology_MayerVietoris.tex` / `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` is consumed by `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3 (line 1925, 1958, 1978). The cross-reference resolves correctly; the strategic claim "the same MV theorem that `Genus.lean` consumes for $H^1(C, \mathcal O_C) = 0$, instantiated here at $\Omega_{C/k}^{\oplus g}$" is honestly disclaimed at lines 1921, 1966 ("Strategy-critic Q3 honesty note" + iter-146 correction that `Genus.lean` does not in fact run this computation).

## Severity summary

**must-fix-this-iter**:

- `RigidityKbar.tex` line 10 + line 2319: `$\thm{...}$` invalid cross-reference syntax. Replace with `\cref{...}` (~30 sec writer fix). Severity: high because (a) lines 10 and 2319 are in the chapter-introductory paragraph and the consumer-summary paragraph of the iter-150-active chapter, prominent to any reader (including the user); (b) the literal `$\thm{...}$` renders as broken syntax in any KaTeX/MathJax/PDF backend; (c) the fix is trivial.

- Add the following macro definitions to `blueprint/src/macros/common.tex` (~30-second writer fix; unblocks web rendering of every section of every chapter cited below):
  - `\newcommand{\HasCechToHModuleIso}{\mathtt{HasCechToHModuleIso}}`
  - `\newcommand{\IsAffineHModuleVanishing}{\mathtt{IsAffineHModuleVanishing}}`
  - `\newcommand{\HasAffineCechAcyclicCover}{\mathtt{HasAffineCechAcyclicCover}}`
  - `\newcommand{\Abelian}{\mathrm{Abelian}}`
  - `\newcommand{\app}{\mathrm{app}}`
  - `\DeclareMathOperator{\pr}{pr}`

  Severity: high because the live-prose uses span four chapters (`Cohomology_MayerVietoris.tex`, `Genus.tex`, `RigidityKbar.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`) and the user has explicitly flagged the rendering failure. The fix is six one-line additions to a single file, with no semantic risk.

**HARD GATE verdict on `RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` (chapters backing iter-150 prover lanes):**

- The two chapters' mathematical content (`complete: true`, `correct: true` modulo the per-chapter notes above) supports the iter-150 prover lanes. The "must-fix-this-iter" macro-definition findings above DO touch `RigidityKbar.tex` BUT the affected lines are all OUTSIDE the iter-150 prover-lane section (lines 1828–2316), which is rendering-clean. Strictly applying the severity rule "any chapter has `complete: partial | false` OR `correct: partial | false` ⇒ must-fix-this-iter ⇒ HARD GATE blocks the prover lane": **the HARD GATE technically blocks** because `RigidityKbar.tex` is flagged `correct: partial` on rendering grounds.

- **Recommended pragmatic disposition**: dispatch a one-shot blueprint-writer to do the six-line macro fix to `common.tex` + the two-line `\thm{...}` → `\cref{...}` fix in `RigidityKbar.tex`, then GREEN-LIGHT both iter-150 prover lanes against `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" + `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`. The prover-lane section itself is rendering-clean (verified) and the affected lines are all in DESCOPED bundled-route sections + chapter-introductory/consumer-summary paragraphs that the prover does not need to read. Total writer round: ~5 minutes. After the writer round, the HARD GATE clears and the prover lanes proceed without deferral.

- **Strict-rule disposition** (if the plan agent prefers no pragmatic override): defer both iter-150 prover lanes to iter-151 and dispatch the writer this iter. The 1-iter latency cost is small (~5 min writer + 1 iter) and the strategy is preserved.

**soon-severity**:

- `RigidityKbar.tex` / `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` proof block: add one sentence on "Artinian + unique minimal prime ⇒ local ring" to match the explicit articulation in (S3.sep.2). Writer task for iter-151.
- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart` proof Step 3: add one sentence justifying "chart-uniform existence is automatic" via base-change of the standard-smooth presentation.
- `RigidityKbar.tex` / `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` (line 2024): add Lean-signature stub comment describing the `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(X_K))` wrapper.
- `Cohomology_MayerVietoris.tex` lines 66–69: replace the one `tikzcd` site with an `array`-mode commutative square for KaTeX compatibility. Cosmetic but recommended for web-dashboard hygiene.

**Citation-adequacy assessment (one short line per chapter, non-blocking):**

- `AbelJacobi.tex`: GOOD. Hartshorne III.4 + FGA Explained Chapter 9 cited in classical-description remarks; project-internal route appropriately scoped.
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`: GOOD. Stacks Tags 0334, 04QM, 0BJF, 02KH, 05DH cited per sub-claim.
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: GOOD. Pointer chapter; main content cites at `RigidityKbar.tex`.
- `Cohomology_MayerVietoris.tex`: ADEQUATE. Project-internal infrastructure on top of Mathlib's `Ext` / `presheafToSheaf`. No external citations needed; explicit Mathlib lemma names are provided where load-bearing (e.g., `Algebra.FormallyUnramified.of_isLocalization`).
- `Cohomology_SheafCompose.tex`: ADEQUATE. Project-internal, thin Mathlib wrapper.
- `Cohomology_StructureSheafAb.tex`: ADEQUATE. Project-internal Mathlib instance plumbing.
- `Cohomology_StructureSheafModuleK.tex`: ADEQUATE. Mathlib citations interleaved; Stein's theorem invoked by name at the producer-instance section.
- `Differentials.tex`: GOOD. Explicit `[verified]` Mathlib lemma references at every load-bearing step (`Algebra.IsStandardSmooth.free_kaehlerDifferential`, etc.) + Stacks Tag 02G1 cross-reference + Hartshorne II.8 / Theorem II.5.2.
- `Genus.tex`: ADEQUATE. Serre / Riemann–Roch / topological-vs-algebraic comparison cited as future milestones; current iteration is a definition only.
- `Jacobian.tex`: GOOD. Hartshorne III.4, FGA Explained Chapter 9, Milne's *Abelian Varieties* Chapter III, Mumford's *Abelian Varieties* Chapter II §4, Fogarty/Mumford (symmetric-product computation), Hartshorne II.6 + II.7 (Pic of $\mathbb P^1$) all cited.
- `Rigidity.tex`: GOOD. Mumford's *Abelian Varieties* §4 cited; `analogies/rigidity-refactor.md` cited as the iter-125 refactor reference; explicit Mathlib lemma names (`ext_of_isDominant_of_isSeparated'`, etc.).
- `RigidityKbar.tex`: GOOD on the chart-algebra (ii) section (Stacks Tags 0334 + 04QM + 0BJF + 02KH + 0AY8 + 05DH + 030V + 0BUG + 0F8L + 07F4 + Bourbaki Algèbre Chap V + Eisenbud §16 + Hartshorne III.5/III.9/III.10 all cited per sub-claim). PARTIAL on the descoped piece (i.a-i.c) bundled-route section: Replacement (B) `Classical.choose`-chain history is preserved as auditable iter-141→iter-143 decision history but the section is iter-146+ cleanup candidate; citation surface is project-internal.

Overall verdict: 12 chapters audited, 11 mathematically clean; the two iter-150 prover-lane sections (`RigidityKbar.tex` § "Chart-algebra piece (ii)" + `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`) are rendering-clean and prover-ready. The four `correct: partial` chapter flags (`Cohomology_MayerVietoris.tex`, `Genus.tex`, `RigidityKbar.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`) reduce to a six-line macro fix in `common.tex` + two `\thm{...}` → `\cref{...}` edits — a ~5-minute writer round that unblocks every flagged finding simultaneously and clears the HARD GATE.
