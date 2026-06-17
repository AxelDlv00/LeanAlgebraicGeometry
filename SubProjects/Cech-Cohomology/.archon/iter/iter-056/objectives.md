# Iter-056 objectives — per-lane recipe detail

## Lane 1 — `CechSectionIdentification.lean` (Sub-brick A stubs) · mathlib-build
Fill the 6 stubs. Each has a `/- Planner strategy -/` block in-file with exact anchors. Order:
1. **Stub 3 `pushPull_leg_sections` (L171, LOW)** — `Γ(V,(j_σ)_*(j_σ)^*F)≅Γ(U_σ∩V,F)`:
   `pushforward_obj_obj`(rfl) ∘ `restrictFunctorIsoPullback` ∘ `restrict_obj`(rfl);
   final eq `j_σ ''ᵁ (j_σ⁻¹V)=U_σ∩V` via `IsOpenImmersion.image_preimage_eq_inf`/`Opens.image_preimage`.
   Already used in `QcohRestrictBasicOpen.lean:113–114,248`.
2. **Stub 6 `cechSection_contractible` (L323, MEDIUM)** — `Homotopy (𝟙 D') 0`: de-privatized
   `CombinatorialCech.depHomotopy`/`depHomotopy_spec`; prepend `i_fix` is identity since
   `coverOpen i_fix ⊓ V = V` (from `V≤coverOpen i_fix`). Purely combinatorial.
3. **Stub 1 `cechBackbone_left_sigma` (L80, MEDIUM)** — `(coverCechNerveOver).obj[p] ≅ ∐_σ Over.mk j_σ`
   in `Over X`; coproduct distributes over finite fibre products; open-immersion pullback-stability.
4. **Stub 2 `pushPull_sigma_iso` (L130, HARD — the lone new-infra leaf)** — `pushPullObj F Y_p ≅ ∏_σ …`
   via `toPresheaf` faithful/reflects-iso/preserves-limits + iterated
   `TopCat.Sheaf.isProductOfDisjoint`/`Scheme.coprodPresheafObjIso`. 01I8-comparable; if multi-iter,
   hand off a precise decomposition.
5. **Stub 4 `pushPull_eval_prod_iso` (L209, LOW)** — assemble Stub2 + `evaluationPreservesLimitsOfShape` + Stub3.
6. **Stub 5 `cechSection_complex_iso` (L266, MEDIUM)** — promote degreewise (Stub4) to `D≅D'`; differential
   via `sectionCech_objD_apply` (CechAcyclic:1513) + `sectionCechProductEquiv` (CechAcyclic:1438).
**Min success (progress-critic):** Stub 3 + Stub 1 (else route → STUCK). Consumer: `hSec` in
`CechAugmentedResolution.lean:229` closes by one line through `isZero_homology_of_iso_homotopy_id_zero`
once Stub 5 + Stub 6 land.

## Lane 2 — `AffineSerreVanishing.lean` (Need#2 general-affine-open Serre vanishing) · mathlib-build
Build the missing decl `affine_serre_vanishing_general_open` (blueprint TODO target):
`Ext^q(jShriekOU V, H)=0` for `V` ANY affine open of `Spec R`, `H` qcoh, `q≥1`.
- **Mechanism:** enlarge `affineCoverSystem`'s basis field `B` from `{D f}` to all affine opens; keep
  `Cov = i↦D(g i)`. `cech_eq_cohomology_of_basis s … V hV` then yields the vanishing (NO restriction).
- **Field re-proof load (analogist `change-of-scheme-cohomology`, verified):**
  - `faces_mem` — already covered (faces are `D(∏g)`, distinguished ⊆ affine).
  - `injective_acyclic` — unchanged (cover-agnostic `injective_cech_acyclicFam`).
  - `surj_of_vanishing` — generalize `affine_surj_of_vanishing` (`:233`) + `standard_cover_cofinal`
    (`:167`): swap `PrimeSpectrum.isCompact_basicOpen f` → `IsAffineOpen.isCompact` [verified].
- **Keep** the existing ⊤-case `affine_serre_vanishing` working (⊤ is an affine open → re-derives from the
  general sibling, or leave as-is and add the sibling). ~40–80 LOC, low risk, no new Mathlib gap.
- **DEAD END:** the open-subscheme `j⁻¹V≅SpecΓ(j⁻¹V)` transport (= restriction-injectives wall). Stay ambient.

## Deferred (not lanes this iter)
- `OpenImmersionPushforward.lean` — Need#1 whole-scheme `U≅SpecΓU` Ext transport (`Scheme.isoSpec`+
  `Scheme.Modules.pushforward` coherences + `Ext.mapExactFunctor`) + the final `_acyclic`/`_comp` assembly.
  Dispatch once Need#2 lands.
- `CechAugmentedResolution.lean` `hSec` — one-line consumer of Lane 1; closes when Sub-brick A lands.
