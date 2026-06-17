# AlgebraicJacobian/Picard/GlueDescent.lean (iter-078)

## glueOverlapBaseChangeIso β_ij coherence (was L1170)

### Attempt 1
- **Approach:** The `pushforwardCongr` obligation is an equality of ring-sheaf morphisms;
  after `ext V x` it is the elementwise form of a CommRingCat-level equation between the
  two composite section maps of the overlap square. Proved a standalone helper
  `glueData_overlap_appIso_compat` by the `appLE` calculus: `Iso.eq_comp_inv` +
  `Iso.inv_comp_eq` move the two `appIso` factors to `appLE` form
  (`appIso_hom'`, `app_eq_appLE`, `appLE_map_assoc`, `appLE_comp_appLE`), and the two
  sides become `appLE` of the two composites of the glue square, equal by a generic
  morphism-transport helper `appLE_congr_mor` (`subst`) over
  `(t_ij ≫ f_ji) ≫ ι_j = f_ij ≫ ι_i`. The sorry closes with
  `exact congr($(glueData_overlap_appIso_compat D i j (unop V)) x)` — the Mathlib
  `restrictFunctorAdjCounitIso` template.
- **Result:** RESOLVED (first try).
- **Key insight:** all `Scheme.Hom.app`-level lemmas (`appIso_hom'`, `appLE_*`) are
  rfl-or-simp friendly at CommRingCat level; the RingCat/forget₂ wrapper is crossed by
  elementwise `congr($(…) x)`, never by `rw`.

## isIso_glueRestrictionHom keystone (was L1207)

### Attempt 1
- **Approach:** Full decomposition per the scoped route. New defs:
  `glueOverlapFactorIso` (β in pullback form, conjugated by `restrictFunctorIsoPullback`),
  `glueChartComponent` (the σ_i components `unit_{f_ij} ≫ (f_ij)_* g_ij ≫ β⁻¹`),
  `glueChartFamily` (Pi.lift through `glueRestrictProdIso`), `glueRestrictionInv`
  (equalizer lift through `glueRestrictEqualizerIso`). Comparison algebra fully proven:
  `glueRestrict_proj_compat` (equalizer/product comparisons vs `glueProj`),
  `glueRestrictionInv_pullback_map_glueProj` (lift ≫ restricted projection = component),
  `glueRestrict_hom_ext` (joint detection by restricted projections, via
  `Iso.cancel_iso_hom_right` + `equalizer.hom_ext` + `Pi.hom_ext`). The keystone body is
  **complete**: `⟨glueRestrictionInv, hom_inv via glueRestrict_hom_ext + obligation 3,
  inv_hom via obligation 2⟩`.
- **Result:** RESOLVED at the assembly level; reduced to 3 named obligations (2 closed,
  see below).

## Obligation 2: glueChartComponent_self_counit (C1 + counit triangle) — CLOSED

### Attempt 1
- **Approach:** New adjunction bridges (`Adjunction.unit_leftAdjointUniq_hom_app` /
  `leftAdjointUniq_hom_app_counit` specialised to `restrictFunctorIsoPullback`):
  `restrictAdjunction_unit_app_iso`, `restrictFunctorIsoPullback_hom_app_counit`,
  `restrictFunctorIsoPullback_congr` (+ `pullbackCongr_hom_app_eqToHom`,
  `restrictFunctorCongr_rfl_hom_app`). hC1 collapses the middle three pullback-level
  factors to one site-level `restrictFunctorCongr` cast (`hC`/`hmid`); `erw` fires the
  unit bridge (plain `rw` CANNOT match the comp nodes across provenances — see dead
  ends); a pure-unification `calc` substitutes the bridges; the residue is a cycle of
  four presheaf restrictions, closed by `ext V x` + `← Functor.map_comp` folding +
  `Subsingleton.elim` + `congr($(htot) x)`.
- **Result:** RESOLVED.
- **Key insight:** `glueOverlapBaseChangeIso`'s inverse/hom act on sections as a single
  `eqToHom` restriction — `glueOverlapBaseChangeIso_inv_app_app` / `_hom_app_app` are
  `ext x; rfl`!

## Obligation 3: glueRestrictionHom_glueChartComponent (pair condition transposed) — CLOSED modulo mate core

### Attempt 1
- **Approach:** Three layers, all landed:
  (1) `glueRestriction_overlap_compat` — the `(i,j)`-component of the equalizer
  condition, fed through the PROVEN `glueLift_cond_iff` with `c k := glueRestrictionHom k`
  (transposes fold by `Equiv.apply_symm_apply`); the component extraction is a
  pure-unification calc over `Pi.lift_π` (the backward direction needs the `Pi.lift`
  lambda EXPLICIT — HO unification cannot guess it).
  (2) `glueOverlapFactor_mate` — mate recognition: `Equiv.injective` twice,
  `homEquiv_naturality_left`, the conjugate calculus
  (`conjugateEquiv_comm` + `conjugateEquiv_pullbackComp_inv` + `Iso.hom_comp_eq_id`,
  exactly the `pullbackObjUnitToUnit_comp` pattern), the file's
  `homEquiv_comp_unit_pushforwardComp` / `homEquiv_comp_pushforwardCongr`, and
  `Adjunction.comp_homEquiv`+`rfl`. FULLY PROVEN modulo `glueOverlapFactor_transpose`.
  (3) The T2 assembly: unit naturality + `hZ` (iso-rearranged compat + mate) +
  pure-unification whisker/assoc chain.
- **Result:** RESOLVED modulo `glueOverlapFactor_transpose` (see open items).

## pullback_map_jointly_faithful (lem:gr_modules_glue_unique core) — CLOSED

### Attempt 1
- **Approach:** Joint faithfulness of chart restrictions for morphisms on the glued
  scheme: transfer `pullback`-agreement to `restrictFunctor` by `NatIso.naturality_2`
  conjugation, then `ext O x` + `TopCat.Sheaf.eq_of_locally_eq'` on the target's
  Ab-sheaf over the cover `{ι_i''(ι_i⁻¹O)}` (`D.ι_jointly_surjective`), with
  `mapPresheaf.naturality` moving the restriction inside the apps; the chart-image
  agreement is `hres i` evaluated on sections (defeq through `restrict_obj`).
- **Result:** RESOLVED (first try). This is the engine lane 2 needs for
  `tautologicalQuotient_epi` (GrassmannianQuot.lean L2066): from `q ≫ u = q ≫ v`,
  restrict to charts where `ι_I^* q` is epi, conclude with this lemma.

## OPEN: glueOverlapFactor_transpose (mate core, L~1609)
- m-free, cocycle-free site-level identity: transpose along `ι_i` of
  `glueOverlapFactorIso.hom` = the four-functor comparison
  `(ι_j)_*(unit_{tf}) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp⁻¹`.
- PARTIAL: `hRHS` (transpose expansion; `leftAdjointUniq` conjugation of the chart
  comparison cancels, leaving site-level β) is PROVEN; `h_a` (unit bridge at `tf`) and
  the three naturality squares `n₁`–`n₃` are PROVEN as haves. Remaining: assemble
  (whisker/assoc discipline) and close the site-level core by `ext V x` +
  `glueOverlapBaseChangeIso_hom_app_app` + the `Subsingleton` restriction-cycle fold —
  EXACTLY the `glueChartComponent_self_counit` ending. Estimated ≤ 60 lines, no new math.

## OPEN: glueChartFamily_equalizes (C2 transported, L~1406)
- The only remaining genuinely-new infrastructure. Route documented in-code at the
  sorry: componentwise via `piComparison`, transpose along the triple-overlap immersion
  `pullback.fst (D.f i p) (D.f i q) ≫ D.f i p` exactly as `glueOverlapFactor_mate`,
  needing (a) a triple-overlap opens identity (analogue of `glueData_preimage_image_eq`),
  (b) a triple β (same 4-factor recipe + `appIso_compat` pattern), (c) the transposed
  component IS `hC2 i p q` (the `glueData_bridge_*` endpoints were designed for this).
  Degenerate pairs use hC1 via `pullbackCongr_hom_app_eqToHom`.

## Dead ends (do NOT retry)
- **`rw`/`simp` with comp-node patterns across provenances** (`Functor.map_comp`,
  `Category.assoc`, `Functor.mapIso_refl`, `Functor.map_id`, reassoc-lemmas): fails
  silently or "no progress" under the `X.Modules` diamond even when the goal PRINTS the
  pattern verbatim. Working levers: `erw` for single closed-head rewrites (but it can
  whnf-timeout on big terms — prefer the next two), `exact`/`refine` with
  whisker_eq/eq_whisker/Category.assoc TERM chains (unification crosses the diamond),
  and freshly-quantified generic `have`s closed by `simp` then applied by unification
  (`hcancel` pattern; pin the category CONCRETELY — `Type _` leaks universe mvars that
  poison the enclosing elaboration with bogus `Trans Eq Eq ?m` calc errors).
- `Equiv.eq_symm_apply` as `rw` on homEquiv goals: coercion form mismatch; use
  `apply (….homEquiv …).injective` + `refine Eq.trans ?_ (Equiv.apply_symm_apply _ _).symm`.
- `Pi.π _ (i, j)` with the family as `_` inside calc steps: leaves stuck mvars →
  `Trans Eq Eq ?m`; always spell the indexed family.
- Backward `Pi.lift_π` (`.symm`): HO unification cannot synthesize the lambda; pass it
  explicitly.
- `rw [← h_f]` on opens-image equalities: motive failure (the `IsOpenImmersion`
  instance depends on the morphism); go through `TopologicalSpace.Opens.ext` +
  `change … .base '' _ = …` first.

## Needs blueprint entry
All new, in `AlgebraicJacobian/Picard/GlueDescent.lean`, namespace
`AlgebraicGeometry.Scheme.Modules` (reviewer/planner: add `\label`+`\lean`+`\uses`
blocks; the natural chapter is `Picard_GlueDescent.tex`, most as sublemmas of
`thm:isIso_glueRestrictionHom`):
- `appLE_congr_mor` — appLE transport along equal morphisms. Uses: nothing (subst).
- `glueData_overlap_appIso_compat` — structure-sheaf compatibility of the overlap
  square. Uses: `glueData_preimage_image_eq`, glue_condition, appLE calculus.
- `pullback_map_jointly_faithful` — joint faithfulness of chart restrictions
  (realises the core of `lem:gr_modules_glue_unique`; consider re-pointing that label
  or adding a dedicated block). Uses: `restrictFunctorIsoPullback`,
  `TopCat.Sheaf.eq_of_locally_eq'`, `ι_jointly_surjective`.
- `glueOverlapBaseChangeIso_inv_app_app`, `glueOverlapBaseChangeIso_hom_app_app` —
  sections of β_ij. Uses: `glueOverlapBaseChangeIso`, `glueData_preimage_image_eq`.
- `restrictAdjunction_unit_app_iso`, `restrictFunctorIsoPullback_hom_app_counit` —
  geometric/site-level adjunction bridges. Uses: `Adjunction.unit_leftAdjointUniq_hom_app`,
  `Adjunction.leftAdjointUniq_hom_app_counit` (Mathlib).
- `pullbackCongr_hom_app_eqToHom`, `restrictFunctorCongr_rfl_hom_app`,
  `restrictFunctorIsoPullback_congr` — congruence-cast compatibilities (subst lemmas).
- `glueOverlapFactorIso` (def) — β in pullback form. Uses: `glueOverlapBaseChangeIso`,
  `restrictFunctorIsoPullback`.
- `glueChartComponent` (def), `glueChartFamily` (def) — the candidate inverse data.
- `glueChartFamily_equalizes` (SORRIED) — obligation 1 (C2 transported).
- `glueRestrictionInv` (def) — the candidate inverse σ_i.
- `glueRestrict_proj_compat`, `glueRestrictionInv_pullback_map_glueProj`,
  `glueRestrict_hom_ext` — comparison algebra (equalizer/product preservation).
- `glueChartComponent_self_counit` — obligation 2 (C1 + counit), PROVEN.
- `glueOverlapFactor_transpose` (SORRIED) — mate core, m-free.
- `glueOverlapFactor_mate` — mate recognition, PROVEN modulo transpose core.
- `glueRestriction_overlap_compat` — overlap compatibility of the restriction
  morphisms (equalizer condition through `glueLift_cond_iff`), PROVEN.
- `glueRestrictionHom_glueChartComponent` — obligation 3, PROVEN modulo mate core.

## Summary
- Sorry count: 2 → 2, but the content moved decisively: BEFORE = {β_ij coherence,
  the ENTIRE keystone `isIso_glueRestrictionHom`}; AFTER = {`glueChartFamily_equalizes`
  (C2 transport, route scoped in-code), `glueOverlapFactor_transpose` (m-free site-level
  mate core, already half-proven in-body)}.
- Sorries closed outright: the β_ij `pushforwardCongr` obligation inside
  `glueOverlapBaseChangeIso`; plus, of the keystone's decomposition, obligations 2
  (`glueChartComponent_self_counit`) and 3-modulo-mate
  (`glueRestrictionHom_glueChartComponent`, `glueRestriction_overlap_compat`,
  `glueOverlapFactor_mate`) and ALL comparison/bridge algebra (19 new proven
  declarations). The keystone theorem body itself is complete and compiles.
- Adjacent work beyond assignment: `pullback_map_jointly_faithful` (the
  `lem:gr_modules_glue_unique` core PROGRESS asked to realize) — proven; directly
  unblocks lane-2 `tautologicalQuotient_epi`.
- `lake build AlgebraicJacobian.Picard.GlueDescent` passes (32s, no kernel timeouts,
  no new lint beyond the pre-existing long-line warnings in QuotScheme).
- Zero axioms introduced; no signatures changed; no other files touched.

## Why I stopped
`Real progress` (with two residual sorries): closed the β_ij coherence sorry and
replaced the keystone's bare sorry with a complete, compiling proof skeleton whose
remaining gaps are two precisely-named lemmas. 23 new declarations, 21 fully proven.
Stopped at the context/session budget after landing `hRHS`, `h_a`, `n₁`–`n₃` INSIDE
`glueOverlapFactor_transpose` (so its remaining gap is pure whisker-assembly + the
`ext V x` restriction-cycle ending, no new mathematics — highest-priority next-iter
pick, est. ≤ 60 lines). `glueChartFamily_equalizes` is the one genuinely new piece
left: it needs the triple-overlap analogues of the pair-level toolkit ((a) opens
identity, (b) triple β, (c) hC2 endpoint match), a session-scale task scoped precisely
in the in-code comment; attempting it after the mate-core machinery exists is strictly
easier (every needed pattern now has a worked in-file template). No planner input
needed: the decomposition is stable and both remaining sorries are independent.
