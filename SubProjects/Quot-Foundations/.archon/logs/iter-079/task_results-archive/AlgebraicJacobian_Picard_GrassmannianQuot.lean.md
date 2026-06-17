# AlgebraicJacobian/Picard/GrassmannianQuot.lean — iter-078

## isIso_pullback_isoLocus_map (was L2160) — **RESOLVED**
### Attempt 1
- **Approach:** Blueprint's stalk-wise route, entirely on Mathlib API: each point of the
  iso-locus has a neighbourhood `U` with `φ|_U` invertible; `Scheme.Modules.restrictStalkNatIso`
  shows restriction along an open immersion preserves abelian-presheaf stalks, so the stalk of
  `φ` is invertible at every locus point; the same comparison for the locus inclusion makes the
  restriction stalkwise invertible; `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` upgrades to
  an isomorphism of `Ab`-sheaves; `Scheme.Modules.toPresheaf` reflects isomorphisms;
  `restrictFunctorIsoPullback` transports `restrictFunctor` to `pullback`.
- **Result:** RESOLVED (~60 lines, no new sorries, verified by cold `lake build`).
- **Key insight:** Mathlib's `Scheme.Modules.restrictFunctor` + `restrictStalkNatIso`
  (AlgebraicGeometry/Modules/Sheaf.lean) make the stalk argument essentially free — no
  module-sheaf stalk theory needed, only `Ab`-presheaf stalks.
- **Note:** the previously `sorry`-backed instance `isIso_pullback_chartLocus_map` and all the
  `chartMatrixHom`/`chartMatrix`/`chartMorphism` machinery downstream are now sorry-free.

## chartLocus_isOpenCover (was L2147) — **RESOLVED**
### Attempt 1 (the Nakayama covering step, Nitsure §1)
- **Approach:** New pipeline, replacing the blueprint's stalkwise-surjectivity sketch with an
  affine-local splitting argument that needs NO stalk theory for sheaves of modules (which the
  SNAP notes record as ABSENT):
  1. **Epi between free sheaves on `Spec R` splits** (`exists_section_of_epi_free_spec`):
     conjugate through `AlgebraicGeometry.tildeFinsupp : tilde (ι →₀ R) ≅ free ι`; the fully
     faithful `tilde.functor` reflects the epi to `ModuleCat R` where epi = surjective
     (`ModuleCat.epi_iff_surjective`); `Module.projective_lifting_property` (free ⇒ projective)
     gives a module-level section; transport back through `tilde.map`.
     **Defeq check that makes this work: `CommRingCat.of ↥R = R` is `rfl`,** so
     `tildeFinsupp` applies literally over `(Spec R).ringCatSheaf`.
  2. **Matrix right inverse over `Spec R`** (`exists_rightInverse_of_epi_matrixEndRect_spec`):
     present the section by `matrixEndRect_unitEndSection`, compose with the new fully
     rectangular law `matrixEndRect_comp_rect`, conclude `M * G = 1` by the new
     `matrixEndRect_injective`.
  3. **Affine transport** (`exists_rightInverse_of_epi_matrixEndRect`): conjugate along
     `S.isoSpec.inv` with `pullback_conj_matrixEndRect`; pull the right inverse back along the
     ring iso `appTop`.
  4. **Pointwise (Nitsure):** trivialise `x.F` on an affine `W ∋ t` (affine-opens basis refining
     the local-freeness cover), present `ι_W^* x.q` by a matrix `MW` (epi: pullback is a left
     adjoint), get `MW * G = 1`; evaluate at the residue field of the stalk at `t`
     (`χ := residue ∘ germ`); `exists_isUnit_submatrix` (new, pure linear algebra:
     columns span by right inverse, `exists_linearIndependent`, basis cardinality,
     `Matrix.linearIndependent_cols_iff_isUnit`) gives a size-`d` subset `I` with invertible
     residue minor; the minor determinant `f0` has unit germ (residue ≠ 0 ⇒ outside the maximal
     ideal), so `t ∈ W.basicOpen f0`; on that basic open the minor matrix is invertible
     (`RingedSpace.isUnit_res_basicOpen` + `Matrix.nonsing_inv`), so the chart composite —
     identified chart-locally with `matrixEndRect (MW.submatrix id σ_I)` via
     `pullback_map_freeMap_pullbackFreeIso` and the new `freeMap_matrixEndRect` — pulls back to
     an isomorphism; transport along `(Wb.ι ≫ W.ι).opensRange` factorisation into
     `mem_isoLocus`.
- **Result:** RESOLVED (~600 lines incl. helpers, verified by cold `lake build`, 0 axioms).
- **Dead ends / warnings for future provers:**
  - `Epi → IsLocallySurjective` for `SheafOfModules` does NOT exist in Mathlib and the
    presheaf-image/balanced route is expensive — the tilde splitting above is the cheap
    substitute on affines; reuse it.
  - `simp only [Category.assoc]` and `rw` of `CommRingCat.hom_comp` FAIL silently across the
    `X.Modules`/`SheafOfModules` instance diamond in several spots (consistent with
    `gr-pullback-instance-diamond`); the fixes were term-mode assoc chains, `show` for
    rfl-equalities of ring-hom applications, and `inferInstanceAs (IsIso (… ≪≫ …).hom)` with
    explicitly assembled isos instead of `infer_instance` on compositions.
  - `matrixEnd M = matrixEndRect M` is `rfl` for square `M` (`matrixEnd_eq_matrixEndRect`), and
    `Matrix.submatrix_map` is `rfl` — used to make `matrixToFreeIso` apply definitionally where
    instance search across the diamond fails.
  - `Opens.isBasis_iff_nbhd` returns `TopologicalSpace.Opens ↥T`, not `T.Opens` — re-obtain
    through an ascribed existential or dot-notation (`W.toScheme`, `W.ι`) fails.

## grPointOfRankQuotient overlap compatibility (sorry at ~L3180 after edits) — PARTIAL
- **State:** still `sorry`, but the matrix heart of the proof is now FORMALIZED and compiling:
  - `pullbackFreeIso_inv_freeMap` — inverse form of the index-map intertwiner.
  - `presentedMatrix x j I hI` — the presented matrix of the quotient along any `j : P ⟶ T`
    where `j^* c_I` is invertible (generalises `chartMatrix`, which is the case
    `j = (chartLocus x I hI).ι`).
  - `matrixEndRect_presentedMatrix`, `matrixEndRect_presentedMatrix_minor` — the presentation
    identities (the `J`-minor presents `j^*c_J` against `(j^*c_I)⁻¹`).
  - `presentedMatrix_changeOfBasis` — **Nitsure's `M^I = M^I_J · M^J`** over any such `j`.
  - `isUnit_of_isIso_matrixEndRect` — converse matrix-unit bridge; with
    `matrixEndRect_presentedMatrix_minor` (whose right side is a composite of isos when both
    chart composites are invertible) it yields `IsUnit (M^I_P)_J`, hence
    `IsUnit (det (M^I_P)_J)` via `Matrix.isUnit_iff_isUnit_det` — exactly the unit needed for
    the `IsLocalization.Away.lift` step.
- **Remaining for the sorry itself (steps 1, 4, 5 of the route below):**
  1. Both sides are `toSpecΓ ≫ Spec.map (classifying)` composites: `p1 ≫ chartMorphism I =
     P.toSpecΓ ≫ Spec.map (classifying_I ≫ appTop p1)` by `Scheme.toSpecΓ_naturality`
     (exact pattern of the proven `chartMorphism_rel`).
  2. **Change-of-basis matrix identity over the intersection `P`** (the jewel): with both chart
     composites invertible after pullback to `P`, the presented matrices satisfy
     `M^I_P = (M^I_P)_J * M^J_P`, by the morphism computation
     `matrixEndRect (M^J_P) ≫ matrixEnd ((M^I_P).submatrix id σ_J) =
      [Qr.inv ≫ q ≫ (c_J)⁻¹ ≫ Qd.hom] ≫ [Qd.inv ≫ c_J ≫ (c_I)⁻¹ ≫ Qd.hom]
      = matrixEndRect (M^I_P)` + `matrixEndRect_comp` + `matrixEndRect_injective`
     (all three now in-file). The J-minor identification
     `freeMap σ_J ≫ matrixEndRect M^I_P = Qd.inv ≫ (pb)c_J ≫ inv((pb)c_I) ≫ Qd.hom`
     follows from `pullback_map_freeMap_pullbackFreeIso` + `(pb)(freeMap σ_J) ≫ (pb)q = (pb)c_J`.
  3. `IsUnit (det (M^I_P)_J)`: the minor's `matrixEndRect` is the iso of step 2; present its
     inverse (`matrixEndRect_unitEndSection`) and use `matrixEndRect_comp_rect` + injectivity to
     get a two-sided matrix inverse, then `Matrix.isUnit_iff_isUnit_det`.
  4. Factor `p1 ≫ chartMorphism I` through `chartIncl` (= the away-localisation `Spec.map`):
     `IsLocalization.Away.lift` at `P^I_J ↦ det (M^I_P)_J` (unit by step 3); equality of the
     two factorisations after `chartTransition` reduces by `Spec.map`-functoriality +
     `IsLocalization.ringHom_ext` + `MvPolynomial.ringHom_ext` to step 2's matrix identity
     against `universalMatrix_map_transitionPreMap` (GrassmannianCells, proven).
  5. Conclude with `Scheme.GlueData.glue_condition`.
- **Blockers:** none mathematical; it is volume (est. 400–800 lines in this file's diamond-safe
  style) + GrassmannianCells API archaeology (`chartIncl`/`chartTransition`/`transitionPreMap`
  spellings). Next prover should start from this map.

## tautologicalQuotient_epi (sorry at ~L2470) — OPEN, pinned on lane 1
- `pullback_map_jointly_faithful` (= `lem:gr_modules_glue_unique`) is now PROVEN in
  GlueDescent.lean, which gives the cancellation reduction `u = v ⟸ ∀ I, ι_I^* u = ι_I^* v`.
- The remaining ingredient is `Epi (ι_I^* tautologicalQuotient)`. Via
  `pullback_map_glueLift_glueRestrictionHom` the composite
  `ι_I^* taut ≫ glueRestrictionHom I` is (conjugate to) the split-epi `chartQuotientMap`; this
  yields `Epi (glueRestrictionHom I)` for free, but transferring epi-ness to `ι_I^* taut`
  needs **`Mono (glueRestrictionHom I)`** (then balanced ⇒ iso) — and mono-ness is exactly the
  separation half of the still-sorried keystone `isIso_glueRestrictionHom` (it needs the β_ij
  overlap identification `glueOverlapBaseChangeIso_inv_app_app`, also still sorried in lane 1).
  Writing the epi proof now would silently rest on lane 1's sorries; left pinned per the
  iter-078 directive ("attempt after an import refresh if lane 1 lands it, else leave pinned").
- **Concrete trigger for next iter:** as soon as `isIso_glueRestrictionHom` (or just a
  `Mono (glueRestrictionHom i)` half) compiles sorry-free in GlueDescent, the epi proof is
  ~30 lines: `constructor; intro Z u v h; exact pullback_map_jointly_faithful _ (fun I => by
  …cancel against the iso…)`.

## represents left_inv/right_inv (sorries at ~L3687/L3692) — OPEN
- Ride on the overlap sorry above (the glued morphism must exist sorry-free first) plus the
  uniqueness argument of `thm:grassmannian_universal_property`. Not attempted.

## Needs blueprint entry
All in `AlgebraicJacobian/Picard/GrassmannianQuot.lean`; the reviewer/planner should add
`\label`/`\lean`/`\uses` blocks (chapter `Picard_GrassmannianQuot.tex`) to keep 1-to-1:
- `matrixEnd_eq_matrixEndRect` — rfl bridge square `matrixEnd` = `matrixEndRect`. Uses: defs only.
- `matrixEndRect_one` — identity law. Uses: `matrixEnd_one`.
- `matrixEndRect_comp_rect` (+ private `biproduct_matrix_comp_rect₂`) — fully rectangular
  composition law. Uses: `scalarEnd_comp`, `scalarEnd_sum`, biproduct matrix calculus.
- `matrixEndRect_injective` — uniqueness of the presenting matrix. Uses:
  `ιFree_matrixEndRect_projFree`, `unitEndSection_scalarEnd`.
- `freeMap_matrixEndRect` — column restriction law. Uses: `ιFree_freeMap`,
  `ιFree_matrixEndRect_projFree`, `isColimitFreeCofan`.
- `exists_section_of_epi_free_spec` — epis between free sheaves on `Spec R` split. Uses:
  Mathlib `tildeFinsupp`, `tilde.fullyFaithfulFunctor`, `ModuleCat.epi_iff_surjective`,
  `Module.projective_lifting_property`.
- `exists_rightInverse_of_epi_matrixEndRect_spec` — matrix right inverse on `Spec R`. Uses:
  previous + `matrixEndRect_unitEndSection`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`,
  `matrixEndRect_one`.
- `exists_rightInverse_of_epi_matrixEndRect` — affine case via `S.isoSpec`. Uses: previous +
  `pullback_conj_matrixEndRect`, `Scheme.isoSpec`, left-adjointness of `Scheme.Modules.pullback`.
- private `exists_isUnit_submatrix` — right-invertible matrix over a field has an invertible
  `orderIsoOfFin`-enumerated column minor. Uses: `Matrix.range_mulVecLin`,
  `exists_linearIndependent`, `Module.finrank_eq_card_basis`,
  `Matrix.linearIndependent_cols_iff_isUnit`.
- `pullbackFreeIso_inv_freeMap` — inverse index-map intertwiner. Uses:
  `pullback_map_freeMap_pullbackFreeIso`.
- `presentedMatrix` (def) — presented matrix along an arbitrary morphism with invertible
  `I`-chart composite. Uses: `unitEndSection`, `projFree`, `pullbackFreeIso`.
- `matrixEndRect_presentedMatrix` — presentation identity. Uses: `matrixEndRect_unitEndSection`.
- `matrixEndRect_presentedMatrix_minor` — `J`-minor presents `j^*c_J (j^*c_I)⁻¹`. Uses:
  `freeMap_matrixEndRect`, `pullbackFreeIso_inv_freeMap`.
- `presentedMatrix_changeOfBasis` — Nitsure overlap matrix identity `M^I = M^I_J · M^J`. Uses:
  the three above + `matrixEndRect_comp_rect`, `matrixEndRect_injective`.
- `isUnit_of_isIso_matrixEndRect` — converse of `matrixToFreeIso`. Uses:
  `matrixEndRect_unitEndSection`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`,
  `matrixEndRect_one`.
- (Moved, not new: `projFree`, `unitEndSection`, `unitEndSection_scalarEnd`,
  `scalarEnd_unitEndSection`, `ιFree_projFree`, `ιFree_matrixEndRect_projFree`,
  `matrixEndRect_unitEndSection`, `pullback_conj_matrixEndRect`,
  `pullback_map_freeMap_pullbackFreeIso` were relocated from the chart-transport section to the
  first namespace section so the covering proof can use them — text unchanged, no relabeling.)

## Summary
- Sorry count: **6 → 4** (file `AlgebraicJacobian/Picard/GrassmannianQuot.lean`).
- Closed: `isIso_pullback_isoLocus_map`, `chartLocus_isOpenCover` (both were planner-designated
  keystone-independent targets; `chartLocus_isOpenCover` was the lane's "do this first" item).
- Still open: `tautologicalQuotient_epi` (pinned on lane-1 keystone, see trigger above),
  `grPointOfRankQuotient` overlap compatibility (full route documented above),
  `represents.left_inv` / `represents.right_inv` (ride on the overlap).
- Adjacent work beyond assignment: built the reusable affine epi-splitting + matrix calculus
  (15 new declarations) including the **fully formalized overlap matrix identity**
  `presentedMatrix_changeOfBasis` and the unit bridge `isUnit_of_isIso_matrixEndRect` — the
  mathematical heart of the remaining overlap sorry; what is left there is Γ–Spec/localization
  plumbing (steps 1, 4, 5 of the route).
- Verified by cold `lake build AlgebraicJacobian.Picard.GrassmannianQuot` (success, 0 errors;
  only pre-existing style warnings + the 4 remaining sorry warnings). No axioms introduced.

## Why I stopped
`Real progress`: closed 2 sorries (`isIso_pullback_isoLocus_map`, `chartLocus_isOpenCover`);
sorry count 6 → 4; additionally landed 6 compiling lemmas that constitute the matrix core of
the remaining overlap sorry (`presentedMatrix*`, `isUnit_of_isIso_matrixEndRect`). The two
keystone-independent items in the directive are done. Of the rest:
`tautologicalQuotient_epi` is genuinely gated on lane 1's still-sorried
`isIso_glueRestrictionHom`/β_ij (building on it today would depend on a sorried foundation —
the directive says leave pinned in that case); the overlap compatibility's remaining content
(Γ–Spec naturality, `IsLocalization.Away.lift` factorisation through `chartIncl`, transition
comparison via `universalMatrix_map_transitionPreMap`, `glue_condition` assembly) is
mathematically unblocked and precisely mapped but is several hundred further lines of
GrassmannianCells API work that did not fit this session after the ~900 lines already landed —
partial unverifiable fragments would have broken the compile-clean invariant. The `represents`
laws ride on the overlap. No approaches were written down without being attempted except
overlap steps 1, 4, 5, which are scoped above with exact lemma names for the next session.
