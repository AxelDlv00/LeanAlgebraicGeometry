# Iter 051 — Objectives detail

## Lane 1 — GF `FlatteningStratification.lean` (mathlib-build) — G1 ONLY
Primary: `gf_qcoh_finite_sections_of_genSections` (`lem:gf_qcoh_finite_sections_of_genSections`).
Gap1-hard X.Modules↔Spec transport; bottom-up sub-steps:
- (a) transport `(pullback D.ι).obj F` to `(Spec Γ(X,D)).Modules` via `hD.isoSpec.inv`, `IsIso fromTildeΓ`
  (recipe: `analogies/quot-gap1-closed-opaque-immersion`).
- (b) free-epi transport `σ.π → (tilde N) ⟶ F'`, `N = R^{σ.I}`: `(pullback isoSpec.inv).obj (free σ.I) ≅
  free σ.I` (finality) + `free σ.I ≅ (tilde R).obj (R^{σ.I})` (tilde preserves coproducts + `tilde R ≅ unit`).
- (c) `moduleSpecΓFunctor.obj F' ≅ Γ(F,D)` as `Γ(X,D)`-modules. Close via `gf_qcoh_finite_sections_of_free_epi`.
Then assemble `gf_qcoh_fintype_finite_sections` (consumes the iter-050 assembly + iter-045 locality gluing).
**FORBIDDEN this iter:** G3, genericFlatness close (CHURNING corrective).

## Lane 2 — GR-quot `GrassmannianQuot.lean` (mathlib-build)
Primary: `chartQuotientMap_epi` (`lem:gr_chartQuotientMap_epi`) — split epi via
`freeMap inclFn ≫ chartQuotientMap = 𝟙`, minor identity `universalMatrix_submatrix_self`
(GrassmannianCells.lean:150), biproduct↔coproduct bridge (`biproduct.ι_matrix`/`matrix_π`), `scalarEnd`
ring-hom packaging, `Cofan.IsColimit.hom_ext`. Full recipe: task_result "Epi chartQuotientMap" §.
Must-fix: `glue` signature — add cocycle hyps C1 (`g_{ii}=id`) / C2 (`g_{jk}∘g_{ij}=g_{ik}`); update sorry
call sites. Stretch: glue-independent `functor` (Setoid + pullback functoriality; reuse `IsLocallyFreeOfRank`).

## Lane 3 — SNAP `SectionGradedRing.lean` (mathlib-build)
Primary: crux `isIso_sheafification_whiskerRight_unit` (`lem:isIso_sheafification_whiskerRight_unit`) —
`W_iff_isIso_map_of_adjunction` → abelian `W.monoidal` via relative-tensor coequalizer (SCOUT the
presentation first; `analogies/snap-route.md`). Then `tensorObjAssoc` (`cor:sheafTensorObjAssoc`) →
`tensorPowAdd` (`lem:sheafTensorPow_add`). Fallback = scope change (grace expired).
