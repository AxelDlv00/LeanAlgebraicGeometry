# Blueprint Review Report

## Slug

iter115

## Iteration

115

## Top-level summaries

### Incomplete parts

- *(none)* — every chapter has all declarations the strategy requires for this iter present and detailed.

### Proofs lacking detail

- *(none rising to must-fix-this-iter)*. The Differentials chapter's `\lem:relative_kaehler_isSheafUniqueGluing` proof is now detailed enough for a prover: explicit Step 1 / Step 2 / Step 3 structure, Mathlib names with `[verified]` tags, and an honest `[gap]` callout naming the missing basis-to-X bridge. All other proof sketches retain the level of detail they had at iter-114's complete + correct verdict.

### Lean difficulty quality

- *(none rising to must-fix-this-iter)*. The 9 protected `\lean{...}` hints all point at named declarations matching `archon-protected.yaml`. The new iter-114-promoted target `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}` is well-formulated for the L175 prover lane: the underlying-type-valued sheaf-condition predicate `TopCat.Presheaf.IsSheafUniqueGluing` is named in the prose (Differentials.tex:27), the inputs (compatible family of K\"ahler differentials) are described, and the output (unique gluing) is stated — a prover can derive the Lean signature without ambiguity.

### Multi-route coverage

- Phase B unique-gluing closure route: **PASS** — `Differentials.tex:20–133` (`\lem:relative_kaehler_isSheafUniqueGluing`) carries the analogist-verified Step 1 / Step 2 / Step 3 recipe and feeds `\thm:relative_kaehler_isSheaf` (L143–160) via the framework `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` + `isSheaf_of_isSheafUniqueGluing_types` chain.
- Phase C3 exit (JacobianWitness exit policy): **PASS** — `Jacobian.tex:100–117` (`\thm:nonempty_jacobianWitness`) bundles all C3 representability content into one named hypothesis; the four Jacobian-instance theorems (L54–84) descend from it.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) are present with sketches that delegate cleanly to the Jacobian-chapter Albanese framework.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - L1196–1198 references to `BasicOpenCech.lean` line numbers (1781/1786/1834/1846) are iter-112-era line-refs noted in the directive as soon-severity / off-limits this iter. Confirmed present, not flagged as must-fix.
  - L1198 `instIsMonoidal_W` is at `Modules/Monoidal.lean:173`; the strategy directive references `Modules/Monoidal.lean:166`. Minor numeric drift inside the iter-112 disclosure paragraph; soon-severity informational since BasicOpenCech.lean is off-limits.
  - The chapter's 100+ `\lean{...}` hints (lines 17–1004) are uniformly well-formulated; protected declaration mapping is consistent throughout.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter; declaration and proof aligned with the strategy's Phase A step 1.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All Phase A step 2–4 declarations present with adequate sketches and correct `\uses{...}` cross-refs.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter (655 lines, ~50 declarations) for Phase A step 5–6 infrastructure; every `\lean{...}` hint points at a named project declaration; the `\uses{...}` graph is dense and consistent.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **iter-115 audit target.** The iter-114 two-pass writer round has landed: `\lem:relative_kaehler_isSheafUniqueGluing` (L20–33) is present as a first-class declaration with proof body L35–133 carrying the corrected Step 1 / Step 2 / Step 3 recipe.
  - **Mathlib names verified in prose**: `KaehlerDifferential.isLocalizedModule_map` (L58), `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` (L62), `Algebra.FormallyEtale.of_isLocalization` (L65), `AlgebraicGeometry.Modules.tilde` (L72), `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` (L76, L146), `isSheaf_iff_isSheafOpensLeCover` (L104), `isSheaf_iff_isSheafUniqueGluing_types` (L105–106), `isSheaf_of_isSheafUniqueGluing_types` (L157), `TopCat.Presheaf.Sheaf.eq_of_locally_eq` (L128), `KaehlerDifferential.span_range_derivation` (L131), `AlgebraicGeometry.Scheme.isBasis_affineOpens` (L46, L91). All carry `[verified]` annotations consistent with the iter-114 mathlib-analogist record.
  - **Sheaf-condition delegation**: `\thm:relative_kaehler_isSheaf` (L135–160) reduces via `isSheaf_iff_isSheaf_comp` + `isSheaf_of_isSheafUniqueGluing_types` to `\lem:relative_kaehler_isSheafUniqueGluing`. Delegation is correct and explicit.
  - **`[gap]` callout** (L111–118): honest disclosure that no off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X, and that the cofinality descent is hand-rolled this iter (mathlib-analogist-verified). Per directive, NOT flagged as must-fix.
  - **`\thm:serre_duality_genus` (L329–339)**: prose relaxed to "smooth proper integral curve over a field $k$" (no "geometrically irreducible"; no dimension-1 assertion). Remark `rem:serre_duality_geom_irred_gap` (L341–350) documents the geometric-irreducibility gap and the `IsIntegral` substitution. Matches iter-114 must-fix requirement.
  - **Stale iter-112 review notes**: none found. The two `% NOTE (iter-086+iter-087)` blocks at L227 and L232–238 document the named-deferred `h_exact` sub-claim and are historically correct contextual annotations, not stale review markers.
  - Minor stylistic observation (informational, not flagged): a few declaration blocks (`\thm:relative_kaehler_isSheaf` L135, `\thm:cotangent_exact_sequence` L271, `\thm:smooth_iff_locally_free_omega` proof L297, and several others) use `\begin{theorem}\n\n\n\leanok` rather than the compact `\begin{theorem}\leanok` form. Does not affect rendering or correctness.
  - One soon-severity-from-iter-114 item not opportunistically addressed: `\def:relative_kaehler_sheaf` (L162–168) still describes the sheaf as "morally quasi-coherent (... but the Lean object does not currently carry the IsQuasicoherent typeclass)". This was noted iter-114 as soon-severity prose softening; not blocking the L175 prover lane.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:genus` (L8–34) is the protected-declaration target; sketch aligned with the project's `HModule` carrier.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The five protected declarations (`def:Jacobian` and four `Jacobian.{instGrpObj, smoothOfRelativeDimension_genus, instIsProper, instGeometricallyIrreducible}`) are present and consistently delegate to the JacobianWitness existence theorem `\thm:nonempty_jacobianWitness`.
  - The Phase C3 exit policy is honest and load-bearing per strategy: classical Pic-route prose at L96–117 acknowledges Mathlib gaps, and the witness theorem bundles them into one named hypothesis.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `instIsMonoidal_W` named-deferral disclosure (Remark `rem:W_IsMonoidal_load_bearing`, L64–72) is explicit and traces the post-C1 load-bearing transition.
  - All five project-side declarations (`tensorObj`, monoidal-presheaf bridge, monoidal-sheaf instance, braided-presheaf, braided-sheaf) are present with correct `\lean{...}` hints.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:Pic_representable` is the C3-deferred named sorry; its `\uses{...}` cross-refs (L38) correctly point to the iter-109 pair `thm:SheafOfModules_pullback_tensorObj` + `thm:SheafOfModules_pullback_oneIso`.
  - Post-C1 dependency note (L77–88) is accurate and recent.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Directive flagged a potential "scaffolded" wording remnant from iter-112; not found in current text. The chapter prose post-iter-109 reads correctly.
  - All declarations carry correct `\lean{...}` hints and `\uses{...}` cross-refs.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The pair of named-deferred Mathlib gaps (`thm:SheafOfModules_pullback_tensorObj` at L122–138, `thm:SheafOfModules_pullback_oneIso` at L140–156) is documented with honest disclosure and explicit prose.
  - Load-bearing-disclosure paragraph (L24–25) correctly attributes the `instIsMonoidal_W` consumption.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter; sketch is detailed (equaliser-is-closed + irreducibility + reducedness chain) and lists Mathlib ingredients explicitly.

## Cross-chapter notes

- The `\lean{...}` hints across all 13 chapters are internally consistent with `archon-protected.yaml` for the 9 protected declarations.
- `\uses{...}` cross-references checked end-to-end against declared `\label{...}` IDs: no broken references found. The `def:universal_derivation` reference at L36 inside `\lem:relative_kaehler_isSheafUniqueGluing`'s `\uses{...}` resolves to L179 of the same chapter — valid.
- Phase B closure chain: `\def:relative_kaehler_presheaf` (L13) → `\lem:relative_kaehler_isSheafUniqueGluing` (L20) → `\thm:relative_kaehler_isSheaf` (L135) → `\def:relative_kaehler_sheaf` (L162) is consistent and load-bearing for the iter-115 L175 prover lane.

## Strategy-modifying findings (if any)

*(none)*

## Severity summary

- **must-fix-this-iter**: *(none)*. No chapter is `complete: partial|false` or `correct: partial|false`. No route is MISSING. No broken `\uses{}` cross-references. The `Differentials.tex` audit confirms the iter-114 two-pass writer round delivered everything iter-115 needs to open the L175 prover lane.
- **soon**: 
  - `Cohomology_MayerVietoris.tex` L1198 carries a stale `Modules/Monoidal.lean:166` vs strategy-cited `Modules/Monoidal.lean:173` line-ref inside the iter-112 named-deferral disclosure. Per directive, non-blocking and BasicOpenCech.lean is off-limits.
  - `Differentials.tex` `\def:relative_kaehler_sheaf` (L162–168) retains the "morally quasi-coherent" prose. Soft, not blocking.
- **informational**:
  - A few `Differentials.tex` declaration blocks use `\begin{theorem}\n\n\n\leanok` rather than `\begin{theorem}\leanok`. Cosmetic only.

Overall verdict: blueprint is **complete + correct across all 13 chapters**; the `Differentials.tex` audit greenlights the iter-115 L175 prover lane on `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`.
