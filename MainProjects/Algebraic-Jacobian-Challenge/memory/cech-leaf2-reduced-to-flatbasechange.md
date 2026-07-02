---
name: cech-leaf2-reduced-to-flatbasechange
description: iter-304 leaf-2 Čech base change reduced to the cosimplicial iso e, which is the FlatBaseChange.lean frontier
metadata:
  type: project
---

iter-304 (`CechHigherDirectImageUnconditional.lean`): leaf-2 plumbing **landed
axiom-clean** and the file's own sorries are gone except the one irreducible iso.
Built (all axiom-clean): `mapAlternatingCofaceMapComplexIso` (additive functor commutes
with `alternatingCofaceMapComplex` = step b), `map_alternatingCofaceMapComplex_objD`,
`pullback_cechComplex_alternatingIso`, and the factoring lemma
`cechComplex_baseChange_iso_of_cosimplicialIso`. Re-wired `cech_flatBaseChange`
(now sorry-free body, via `pullback_mapHC_homologyIso` + `homologyMapIso`) and
`cechComplex_baseChange_iso` (`:= …of_cosimplicialIso … sorry`). **File sorry 3→2.**

**The whole leaf-2 residual is now the single cosimplicial iso `e`:**
`g^*∘f_*∘drop(CechNerve 𝒰 F) ≅ f'_*∘g'^*∘drop(CechNerve 𝒰' (g'^*F))`. `e` IS the
Beck–Chevalley pushforward natural iso whiskered through the nerve = exactly
`affineBaseChange_pushforward_iso`/`flatBaseChange_pushforward_isIso` (**still `sorry` in
`Cohomology/FlatBaseChange.lean`**, NOT this file) + the affine-reduction-on-`S` wall.
So leaf 2 cannot advance further from this file: it is downstream of the FlatBaseChange
frontier. Next: a sorry-free `pushforward f ⋙ pullback g ≅ pullback g' ⋙ pushforward f'`
natural iso in FlatBaseChange (concrete-tilde route), then whisker + twisted-nerve id.

**Reusable API trick (alternating/homological complexes):** the complex's `.X i` projection
is defeq but NOT syntactically `Y.obj ⟨i⟩` / `F.obj (K.X i)`, which silently blocks
`rw [Category.id_comp]`, `rw […map…]`, and `Functor.map_sum` matching (they report the lemma
"unused"/"pattern not found"). Fix: prove the differential equality as a clean-typed standalone
lemma, discharge the `isoOfComponents` square's `have` with `exact` (up-to-defeq) not `rw`, and
clear the leftover identities with **`erw [Category.id_comp, Category.comp_id]`**.
`((alternatingCofaceMapComplex C).obj Y).d n (n+1) = objD Y n` via
`simp [alternatingCofaceMapComplex, AlternatingCofaceMapComplex.obj, CochainComplex.of_d]`.
