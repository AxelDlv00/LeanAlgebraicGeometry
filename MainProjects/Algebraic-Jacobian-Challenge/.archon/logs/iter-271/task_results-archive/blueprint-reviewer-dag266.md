# Blueprint Review Report

## Slug
dag266

## Iteration
266

## Top-level summaries

### Proofs lacking detail

- `Albanese_CodimOneExtension.tex` / `lem:smooth_algebra_krull_dim_formula`: proof derives the
  dimension formula from Stacks 00OE correctly, but only covers the standard-smooth / closed-point
  specialisation. The general point case (arbitrary `trdeg`) is sketched in the "Geometric
  application" paragraph but the derivation step "for a standard-smooth presentation of relative
  dimension n, `dim_z Spec S = n` via `lem:rank_kaehler_localization_eq_relative_dim`" skips the
  link: the K\"{a}hler-rank lemma (Stage 5b) gives rank = n on the Kähler module, not directly
  `dim_z Spec S = n`; the missing bridge is the global-complete-intersection characterisation of
  dim cited as "Stacks `lemma-relative-global-complete-intersection-smooth`". This is not a
  blocking gap (the chapter prose documents the residual), but a prover would need to supply
  that bridge separately.

- `RigidityKbar.tex` / `thm:rigidity_over_kbar` proof step (C.2.d): the proof is stated
  **conditionally on the route (a)/(b) gating choice** (correct, per the strategic disposition),
  so the argument is incomplete by design. The conditional framing is explicit in the prose; no
  mathematical claim is made that the condition holds.

- `Albanese_AlbaneseUP.tex` / `thm:albanese_universal_property`: proof says "the birational
  morphism `Sym^g C ⇢ J` inverts to a rational map `J ⇢ A`" but does not spell out the
  birational-isomorphism step or why it inverts; relies on citing `thm:rational_map_to_av_extends`
  without giving the domain of the rational map or the density argument. Adequate for a
  blueprint-level sketch, but the birational-inversion step could be more explicit.

### Lean difficulty quality

- `Cohomology_StructureSheafModuleK.tex` / `thm:Scheme_IsAffineHModuleHomFinite`,
  `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`,
  `thm:Scheme_module_finite_HModule_prime_of_affine`,
  `thm:Scheme_module_finite_HModule_prime_of_affine_curve`: four `\lean{}` hints are
  **unmatched** in leandag — the named Lean declarations do not exist in the current tree. The
  blueprint nodes carry `\leanok` despite the mismatch; the prover cannot use these hints
  to verify work.

- `Cohomology_MayerVietoris.tex` / `def:Abelian_Ext_chgUnivLinearEquiv`: `\lean{CategoryTheory.Abelian.Ext.chgUnivLinearEquiv}` is **unmatched** (25 total unmatched lean entries in the build; see Dependency & isolation findings).

- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial`: `\lean{AlgebraicGeometry.hom_Ga_to_av_trivial}` **unmatched** (actual declaration may have been renamed).

- `AbelianVarietyRigidity.tex` / `lem:hom_from_Ga_trivial`: `\lean{AlgebraicGeometry.morphism_Ga_to_av_const}` **unmatched** (different name from blueprint label; likely renamed).

- `Picard_LineBundlePullback.tex` (inferred from leandag): `lem:pullback_compatible_with_tensorobj`,
  `lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`, `lem:pullback_tensor_iso_loctriv`,
  `lem:isinvertible_implies_locallytrivial`, `lem:isinvertible_pullback` — six entries all
  **unmatched** to their stated Lean names (`AlgebraicGeometry.Scheme.Modules.*`).

- `Picard_TensorObjSubstrate.tex` / `Picard_RelPicFunctor.tex` (inferred): `thm:rel_pic_addcommgroup_via_tensorobj`, `lem:baseMap_pullbackComp_apply`, `lem:baseMap_pullback_comp_apply`, `lem:baseMap_pullbackCongr_apply`, `lem:baseMap_inv_step3_open_immersion` — five entries **unmatched**.

- `Albanese_AlbaneseUP.tex` / `thm:albanese_universal_property`: `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` **unmatched** — the target Lean name does not match the chapter's own preferred name
  `AlgebraicGeometry.Pic0.albanese_universal_property`; this needs correction.

- `Albanese_CodimOneExtension.tex` / `lem:smooth_algebra_krull_dim_formula`: `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` **unmatched** (Lean declaration for Stage 6.A not yet landed).

- Several `lem:S3_sep_1`, `lem:S3_sep_2`, `lem:S3_pi_1`, `lem:S3_pi_2` in `RigidityKbar.tex`
  (or a related chapter): four S3-separation-lemma hints are **unmatched** to their actual Lean
  names (`AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`, etc.). Source chapter TBD.

### Dependency & isolation findings

**leandag build stats (iter-266):**
- Blueprint nodes: 543 · Lean aux nodes: 430 · Proved: 447 · With sorry: 90
- Edges: 348 · Isolated: 741 (blueprint + lean_aux combined)
- `unknown_uses: []` — **zero broken `\uses{}` edges**
- `unmatched_lean`: **25 entries** (see `Lean difficulty quality` above for the full list)
- `conflicts: []`

**Disposition of isolated blueprint nodes.** The `leandag show isolated` output shows that the
bulk of isolated nodes are proved infrastructure items with zero effort remaining (cohomology
sheafification, k-module structure sheaf, structural abelian-group/Ext plumbing, etc.) — these
are **keep** dispositions: they are standalone terminal or foundational nodes with no downstream
consumers in the current graph, but they are not dead scaffolding.

The one **wire-up** finding from the iter-266 focus areas:

- `Picard_IdentityComponent.tex` / `lem:geometricallyConnected_of_connected_of_section` proof
  carries `\uses{thm:identity_component_open_subgroup}`. The proof body (Stacks 037Q /
  04KV argument on clopen partitions and section existence) **does not invoke**
  `thm:identity_component_open_subgroup` (the clopen-subscheme theorem). The edge is spurious.
  The proof uses only the hypothesis that `|X|` is connected and that a k-rational section
  exists; it needs no identity-component machinery. **wire-up**: remove
  `\uses{thm:identity_component_open_subgroup}` from this proof block.

All 25 `unmatched_lean` entries are **fix** dispositions: the blueprint `\lean{}` hints name
Lean declarations that are absent from the current tree. They are almost certainly name-drift
from renames or moves (not fabrications), but must be corrected before the corresponding provers
can validate their work. Most appear pre-existing and not caused by iter-266 changes.

## Per-chapter

### `blueprint/src/chapters/Picard_IdentityComponent.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - The four per-theorem proof splits are mathematically sound; `\uses{}` edges are accurate
    for all four abstract-substrate theorems and all three Pic-zero theorems.
  - **Spurious `\uses{}` wire-up** (see Dependency & isolation findings): `lem:geometricallyConnected_of_connected_of_section` proof incorrectly lists `\uses{thm:identity_component_open_subgroup}`; the proof never invokes that theorem. Remove this edge.
  - `\lean{AlgebraicGeometry.GroupScheme.geometricallyConnected_of_connected_of_section}`:
    namespace correctly set to `AlgebraicGeometry.GroupScheme.…` per directive — confirmed.
  - `thm:pic_zero_is_abelian_variety` `\uses{}` could optionally add `def:genus` for step (iv)
    (smoothness via arithmetic-genus formula), but the omission is minor.

### `blueprint/src/chapters/RigidityKbar.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - New proof of `thm:rigidity_over_kbar` is present and mathematically faithful to the C.2.b–C.2.e decomposition; conditional gating on route (a)/(b) is explicit.
  - All 11 `\uses{}` labels resolve (`unknown_uses: []` confirmed); cross-chapter reference to `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` is valid.
  - The proof correctly situates `H^0(C, Ω_{C/k̄}) = 0` via the Mayer–Vietoris carrier rather than packaged Serre duality, consistent with the strategic disposition.
  - No `\leanok` on the proof block: correct, as the Lean body remains a gated named gap (`sorry`).

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Assembled proofs for `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal`, and all three supporting sub-lemmas are present and mathematically detailed.
  - `Theorem~REF` and `Lemma~REF` in sub-lemma proof bodies are pending label-fill (cross-references not yet resolved to `\cref{}`); this is a cosmetic issue, not a mathematical error.
  - `\uses{def:coherent_sheaf_flat, lem:flat_locus_open, lem:nonflat_locus_proper, lem:noetherian_induction_strata, thm:generic_flatness}` on the main theorem correctly chains all four sub-lemmas.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:smooth_algebra_krull_dim_formula` (Stage 6.A, Stacks 00OE): new proof is present and
    mathematically sound for the key formula `dim_x(Spec S) = dim S_q + trdeg_k κ(q)` and the
    closed-point specialisation. The bridge from Kähler-rank to local Krull dim (the
    global-complete-intersection-smooth step) is sketched but not fully closed — the prover will
    need to supply this step from the Stacks 00SW substrate.
  - `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}`:
    **unmatched** — the declaration has not landed; the blueprint correctly documents this as a
    residual gap.
  - Stages 6.A/6.B/6.C proofs reference `lem:rank_kaehler_localization_eq_relative_dim` and
    `lem:cotangent_kahler_over_field` which have their own `\uses{}` chains; internal consistency
    is maintained.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - Short proof of `thm:Scheme_module_finite_HModule_prime_of_affine_curve` (new in iter-266)
    is present with `\uses{thm:Scheme_module_finite_HModule_prime_of_affine}`; content is sound.
  - Four `\lean{}` hints are **unmatched**: `thm:Scheme_IsAffineHModuleHomFinite`,
    `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`,
    `thm:Scheme_module_finite_HModule_prime_of_affine`,
    `thm:Scheme_module_finite_HModule_prime_of_affine_curve`. These blocks all carry `\leanok`
    but the Lean declarations are absent — pre-existing name drift.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Deletion of `lem:Scheme_AffineCoverMVSquare_corners` is confirmed clean: the label is absent
    from all `\uses{}` entries (`unknown_uses: []`), the four individual corner lemmas
    (`lem:Scheme_AffineCoverMVSquare_X1`–`_X4`) carry their own `\lean{}` hints and `\leanok`
    markers, and a `% NOTE (DAG iter-266)` comment block documents the removal.
  - `def:Abelian_Ext_chgUnivLinearEquiv` `\lean{CategoryTheory.Abelian.Ext.chgUnivLinearEquiv}`
    is **unmatched** — pre-existing name drift.

---

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - The two existence proof routes (A and C) are clearly labeled; Route A is documented as
    missing Mathlib infrastructure with explicit per-sub-step LOC budgets. The structure is
    intentionally a named gap (`thm:nonempty_jacobianWitness` carries `sorry`).

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:hom_Ga_to_av_trivial` / `lem:hom_from_Ga_trivial`: two `\lean{}` hints are
    **unmatched** (`AlgebraicGeometry.hom_Ga_to_av_trivial` and
    `AlgebraicGeometry.morphism_Ga_to_av_const`). These are off the genus-0 critical path per
    the chapter's own remarks, but the name drift should be corrected.
  - Rigidity Lemma chain (`thm:rigidity_lemma` through `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`)
    is all `\leanok` + axiom-clean per prior iter notes. Chain is complete.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - `thm:albanese_universal_property`: `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` is
    **unmatched**. The chapter header names the Lean target as
    `AlgebraicGeometry.Pic0.albanese_universal_property`; the `\lean{}` tag is inconsistent.
    Must be corrected — a prover will not find `AlgebraicGeometry.Scheme.Pic.albaneseUP`.
  - Proof is adequate for a blueprint sketch; the birational-inversion step could be more explicit
    (see "Proofs lacking detail" above).

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - The one-line proof (combine `thm:codim_one_extension` + `lem:milne_codim1_indeterminacy`)
    is minimal but correct at the blueprint level.

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Uses `Theorem~REF` / `Definition~REF` placeholders in several proof bodies (unfilled
    cross-references); not a mathematical issue at this stage.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex`
(already covered above)

### `blueprint/src/chapters/Picard_LineBundlePullback.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - Six `\lean{}` hints are **unmatched** (`AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`,
    `AlgebraicGeometry.Scheme.Modules.pullbackTensorIso`, `…pullback0TensorIso`,
    `…pullbackTensorIsoOfLocallyTrivial`, `IsInvertible.isLocallyTrivial`,
    `IsInvertible.pullback`). Pre-existing name drift from the A.1.c.sub refactor.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - `thm:rel_pic_addcommgroup_via_tensorobj`: `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` **unmatched**.

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - Five `\lean{}` hints **unmatched**: `lem:baseMap_pullbackComp_apply`,
    `lem:baseMap_pullback_comp_apply`, `lem:baseMap_pullbackCongr_apply`,
    `lem:baseMap_inv_step3_open_immersion` (all `AlgebraicGeometry.Scheme.Modules.*`), and
    `lem:push_pull_functor` (`AlgebraicGeometry.pushPullMap_comp`). Pre-existing.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_LineBundleCoherence.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex`
(already covered above)

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` through `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`: four `\lean{}` hints **unmatched** (actual Lean names differ from blueprint hints; e.g., `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth` not found). Pre-existing name drift from the S3-separation refactor.

## Severity summary

**Must-fix-this-iter:**

1. **`Picard_IdentityComponent.tex` / `lem:geometricallyConnected_of_connected_of_section` proof
   `\uses{thm:identity_component_open_subgroup}`** — spurious dependency edge; the proof does not
   invoke the identity-component clopen theorem. Wire-up: remove this `\uses{}` entry. Affects
   the dependency-graph ordering for any prover relying on this edge.

2. **25 `unmatched_lean` entries** — `\lean{}` hints in 8+ chapters that name Lean declarations
   absent from the current tree. All 25 are listed in the Lean difficulty quality section.
   Each is a must-fix since provers cannot validate their work against a misnamed target.
   Priority: the 4 entries in `Cohomology_StructureSheafModuleK.tex` (active cohomology lane),
   the 6 in `Picard_LineBundlePullback.tex` (active A.1.c.sub lane), and
   `thm:albanese_universal_property` in `Albanese_AlbaneseUP.tex` (wrong Lean name).

**Soon (cross-cutting, no specific prover blocked now):**

3. `Theorem~REF` / `Lemma~REF` / `Definition~REF` placeholders in several proof bodies
   (`Picard_FlatteningStratification.tex`, `Picard_QuotScheme.tex`,
   `Albanese_Thm32RationalMapExtension.tex`) — unfilled `\cref{}` cross-references. Not broken
   (no unknown_uses), but degrade readability for provers.

4. `thm:pic_zero_is_abelian_variety` proof: consider adding `def:genus` to `\uses{}` for the
   smoothness step (iv) (arithmetic-genus formula). Minor completeness gap.

**Informational:**

5. `Cohomology_MayerVietoris.tex` / `def:Abelian_Ext_chgUnivLinearEquiv`: no proof block for
   this definition; the universe-bump equivalence proof body says "The underlying bijection is
   the standard universe-change equivalence…" which is thin. Adequate for blueprint level.

Overall verdict: Blueprint is in good shape for iter-266; the focus-area changes are all
mathematically sound and the `lem:Scheme_AffineCoverMVSquare_corners` deletion is clean. **25
pre-existing `unmatched_lean` entries** are the dominant must-fix items; none were introduced
by iter-266. The single new wire-up finding (spurious `\uses{}` in
`lem:geometricallyConnected_of_connected_of_section`) is minor. No unstarted phases require
blueprint proposals — all strategy phases have adequate chapter coverage.
