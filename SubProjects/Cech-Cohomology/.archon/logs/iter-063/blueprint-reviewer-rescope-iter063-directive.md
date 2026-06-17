# Blueprint-reviewer directive — iter-063 (fast-path scoped re-review)

Run your normal whole-blueprint audit. The HARD-GATE decision this iter turns on ONE chapter:
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated; `% archon:covers`
`CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`). Both files are about to receive
prover lanes, so I need a current complete+correct verdict on this chapter.

A blueprint-writer + blueprint-clean pass this iter addressed the iter-062-review must-fix findings on
this chapter. Confirm each is resolved (these are the gate items):

1. **`lem:pushforward_slice_pullback_iso`** — the proof was WRONG (it used the unit-only
   `pullbackObjUnitToUnit` comparison, which does not give the general-`H` iso). It was rewritten onto the
   `leftAdjointUniq` route: `pullback ψ_r ≅ pushforward φ''` (reverse slice ring map) via
   `pushforwardPushforwardAdj` + `Adjunction.leftAdjointUniq`, then a section-identity iso. A new
   sub-lemma `lem:pushforward_slice_two_adjunction` surfaces the `Over.postEquiv`-inverse
   `Over.map (unitIso.inv)` correction (forced by the non-definitional open identity
   `φ.hom⁻¹ᵁ φ.inv⁻¹ᵁ Uᵢ = Uᵢ`). **Check:** is the rewritten proof mathematically correct and complete
   for general `H` (not just the unit), with the coherence correction made explicit rather than hidden?

2. **`lem:pushPull_binary_coprod_prod`** — expanded from the sections-only sketch (which only covered the
   now-done leaf `isIso_coprodDecompMap`) to the full `q_*`-coherence assembly: canonical
   `asIso (prod.lift (pushPullMap …))` matched against a chain iso, with a new sub-lemma
   `lem:pushPull_binary_leg_coherence` for the per-leg coherence (★). **Check:** is the decomposition
   sound and are the sub-lemma statements/proofs adequate to formalize?

3. Coverage debt: the new Lean helpers/instances (`isIso_coprodDecompMap`,
   `isIso_map_prodLift_of_isLimit`, `opensMapInvBase_isEquivalence`, `overPost_slice_isContinuous`,
   `sliceStructureSheafHom_pre_isRightAdjoint`, `sliceStructureSheafHom_isRightAdjoint`) were bundled into
   their parent `\lean{...}` lists. **Check:** no remaining unmatched isolated nodes for this chapter.

Report per-chapter as usual. For this chapter specifically, give an explicit `complete:` / `correct:`
verdict and list any must-fix-this-iter finding that still touches it. If there are none, say so plainly
so the gate can clear and both covered files can receive provers this iter.
