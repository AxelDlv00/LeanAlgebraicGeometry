# Blueprint-writer directive — GrassmannianQuot coverage + functor coherence

Target chapter: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`.

## Action
Add blueprint blocks (statement + \label + \lean + accurate \uses + ≥1-line informal proof) for the
iter-053 prover helpers that are currently unblueprinted (dag coverage debt), AND blueprint the single
named coherence that the next prover will build to close `functor`.

### A. Coverage blocks for DONE, axiom-clean helpers (real \lean{} pins to existing decls)
All in `namespace AlgebraicGeometry.Scheme.Modules` unless noted:
1. `lem:gr_opensMap_final` → `AlgebraicGeometry.Scheme.Modules.opensMap_final` — for any scheme morphism
   `φ : T' ⟶ T`, the functor `Opens.map φ.base` is `Final`. Proof: over any open `V` of `T`, the
   structured-arrow category `{U : V ≤ φ⁻¹U}` has terminal object `⊤`, hence is connected. (General
   "pullback of free is free" unlock — note it is reusable across GF/QUOT.)
2. `lem:gr_pullbackFreeIso` → `...pullbackFreeIso` — `(pullback φ).obj (free I) ≅ free I` for arbitrary `φ`.
   \uses{lem:gr_opensMap_final}. Proof: `pullbackObjFreeIso` now synthesizes `Final` via (1).
3. `lem:gr_pullback_isLocallyFreeOfRank` → `...pullback_isLocallyFreeOfRank` — pullback preserves rank-`d`
   local freeness. \uses{lem:gr_pullbackFreeIso, def:is_locally_free_of_rank}. Proof: cover `{φ⁻¹ U_i}`,
   `pullbackComp` + `morphismRestrict_ι` factorisation + (2).
4. `def:gr_rankQuotient` → multi-name \lean listing
   `AlgebraicGeometry.Grassmannian.RankQuotient, AlgebraicGeometry.Grassmannian.RankQuotient.Rel,
   AlgebraicGeometry.Grassmannian.RankQuotient.rel_refl, ...rel_symm, ...rel_trans,
   AlgebraicGeometry.Grassmannian.rqSetoid, AlgebraicGeometry.Grassmannian.rqPullback,
   AlgebraicGeometry.Grassmannian.rqPullback_rel` — one rank-`d` quotient `q : O_T^r ↠ F` of the trivial
   bundle (epi, `IsLocallyFreeOfRank F d`); `Rel` = iso commuting with the quotient maps (an equivalence,
   `rqSetoid`); `rqPullback ψ` = pullback action (epi preserved via the left adjoint; local freeness via (3)),
   descending to the quotient by `rqPullback_rel`. \uses{lem:gr_pullback_isLocallyFreeOfRank,
   def:is_locally_free_of_rank}. (Use ONE consolidated block with the multi-name \lean — mirror the existing
   `lem:gr_glueData_bridges` style.)

### B. The functor coherence the next prover will build (planned decls — \lean names a target)
Add a block `lem:gr_pullbackObjUnitToUnit_id` →
`\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_id}` (the decl does NOT exist yet — name it as
the prover target): for the identity morphism, `pullbackObjUnitToUnit (𝟙 T) = ((pullbackId T).app unit).hom`,
plus the `pullbackComp` analogue (you may put the composite analogue in the same block or a sibling
`lem:gr_pullbackObjUnitToUnit_comp`). Informal proof: reduce via `Adjunction.homEquiv_unit` +
`Equiv.symm_apply_eq` to `unitToPushforwardObjUnit (𝟙) = adj.homEquiv ((pullbackId.app unit).hom)`, then
navigate `pullbackId = leftAdjointIdIso (pushforwardId)` and `conjugateEquiv_pullbackId_hom`. State that this
single unit coherence (+ a coproduct-`ext` over `free = ∐ unit`) closes both `functor` functoriality laws
(`map_id`/`map_comp`) — wire `def:grassmannian_functor`'s proof `\uses{}` to it.

## Constraints
- These are Archon-original (Grassmannian construction, Nitsure §1/§5 / FGA); `opensMap_final`/`pullbackFreeIso`
  are general SheafOfModules facts. No external SOURCE QUOTE needed for the bespoke gluing helpers; cite
  Nitsure §5 for the functor-of-points framing only where the chapter already does.
- Do NOT add `\leanok` (sync_leanok owns it). No Lean tactic strings in proofs.
- Keep blocks terse. `references/**` is in your write-domain only as a fallback; you likely need no new source.
