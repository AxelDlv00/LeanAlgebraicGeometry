/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Albanese.RationalMapFunctionField

/-!
# Milne Lemma 3.3, Substep 3: the spreading criterion for rational-map domains

Per `informal/m33-spec.md` (D4). The heart is the **abstract spreading
criterion** `Scheme.RationalMap.mem_domain_of_fromSpecStalk`: for a rational
map `F : Y ⤏ Z` of `S`-schemes out of an integral scheme with `Z` locally of
finite type over `S`, a point `P ∈ Y` lies in the domain of `F` as soon as
the generic morphism `Spec K(Y) ⟶ Z` of `F` factors through
`Spec 𝒪_{Y,P} ⟶ Z` compatibly with the structure morphisms. This rides on
Mathlib's spreading-out engine (`Scheme.PartialMap.ofFromSpecStalk`,
`spread_out_of_isGermInjective'`) and the germ-injectivity of integral
schemes.

Supporting API:

* `Scheme.isGermInjectiveAt_of_isIntegral` — integral schemes are
  germ-injective at every point (instance; feeds the spreading engine).
* `Scheme.Opens.fromSpecStalkOfMem_specializes`,
  `Scheme.PartialMap.fromSpecStalkOfMem_specializes` — the stalk-to-scheme
  morphisms of a partial map are compatible with specialisation inside the
  domain; this is what re-anchors the spread-out morphism at the generic
  point.

Blueprint reference: `lem:milne_codim1_indeterminacy` (Milne, *Abelian
Varieties*, §I.3 Lemma 3.3, pp. 17–18; `abelian-varieties:page-0023/0024`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace IsLocalRing

namespace AlgebraicGeometry

/-- **Integral schemes are germ-injective at every point**: any affine open
`U ∋ x` has `Γ(Y, U)` a domain and `Γ(Y, U) ⟶ 𝒪_{Y,x}` a localization map,
hence injective (`germ_injective_of_isIntegral`). Feeds Mathlib's
spreading-out engine (`spread_out_of_isGermInjective'`). -/
instance (priority := 100) Scheme.isGermInjectiveAt_of_isIntegral
    {Y : Scheme.{u}} [IsIntegral Y] (P : ↥Y) : Y.IsGermInjectiveAt P := by
  obtain ⟨_, ⟨U, hU, rfl⟩, hPU, -⟩ :=
    Y.isBasis_affineOpens.exists_subset_of_mem_open (Set.mem_univ P) isOpen_univ
  exact ⟨⟨U, hPU, hU, germ_injective_of_isIntegral Y P hPU⟩⟩

/-- The stalk-to-subscheme morphisms of an open are compatible with
specialisation: `Spec 𝒪_Q ⟶ Spec 𝒪_P ⟶ U` is `Spec 𝒪_Q ⟶ U` for `Q ⤳ P`
both in `U`. -/
lemma Scheme.Opens.fromSpecStalkOfMem_specializes
    {Y : Scheme.{u}} (U : Y.Opens) {P Q : ↥Y} (hsp : Q ⤳ P)
    (hP : P ∈ U) (hQ : Q ∈ U) :
    Spec.map (Y.presheaf.stalkSpecializes hsp) ≫ U.fromSpecStalkOfMem P hP
      = U.fromSpecStalkOfMem Q hQ := by
  rw [← cancel_mono U.ι, Category.assoc, Scheme.Opens.fromSpecStalkOfMem_ι,
    Scheme.Opens.fromSpecStalkOfMem_ι, Scheme.SpecMap_stalkSpecializes_fromSpecStalk]

/-- The stalk-to-target morphisms of a partial map are compatible with
specialisation inside the domain. -/
lemma Scheme.PartialMap.fromSpecStalkOfMem_specializes
    {Y Z : Scheme.{u}} (g : Y.PartialMap Z) {P Q : ↥Y} (hsp : Q ⤳ P)
    (hP : P ∈ g.domain) (hQ : Q ∈ g.domain) :
    Spec.map (Y.presheaf.stalkSpecializes hsp) ≫ g.fromSpecStalkOfMem hP
      = g.fromSpecStalkOfMem hQ := by
  change Spec.map (Y.presheaf.stalkSpecializes hsp)
      ≫ g.domain.fromSpecStalkOfMem P hP ≫ g.hom
    = g.domain.fromSpecStalkOfMem Q hQ ≫ g.hom
  rw [← Category.assoc, Scheme.Opens.fromSpecStalkOfMem_specializes g.domain hsp hP hQ]

/-- **The abstract spreading criterion.** Let `F : Y ⤏ Z` be a rational map
of `S`-schemes with `Y` integral and `Z` locally of finite type over `S`. If
the generic morphism `Spec K(Y) ⟶ Z` of `F` factors through a morphism
`φ : Spec 𝒪_{Y,P} ⟶ Z` compatible with the structure morphisms, then
`P ∈ Dom F` — `φ` spreads out to a partial map defined at `P` representing
`F` (Milne's "`Φ` is defined at `P` as soon as `𝒪_{G,e}` pulls back into
`𝒪_{Y,P}`", substep 3 of Lemma 3.3). -/
theorem Scheme.RationalMap.mem_domain_of_fromSpecStalk
    {Y Z S : Scheme.{u}} [IsIntegral Y] (qY : Y ⟶ S) (qZ : Z ⟶ S)
    [LocallyOfFiniteType qZ] (F : Y.RationalMap Z) (P : ↥Y)
    (φ : Spec (Y.presheaf.stalk P) ⟶ Z)
    (hcomp : φ ≫ qZ = Y.fromSpecStalk P ≫ qY)
    (hgen : Spec.map (Y.presheaf.stalkSpecializes (genericPoint_specializes P)) ≫ φ
      = F.fromFunctionField) :
    P ∈ F.domain := by
  set ψP := Scheme.PartialMap.ofFromSpecStalk qY qZ φ hcomp with hψdef
  have hPψ : P ∈ ψP.domain := Scheme.PartialMap.mem_domain_ofFromSpecStalk qY qZ φ hcomp
  -- The generic point lies in both domains.
  have hηψ : genericPoint ↥Y ∈ ψP.domain :=
    (genericPoint_specializes _).mem_open ψP.domain.2
      ψP.dense_domain.nonempty.choose_spec
  obtain ⟨g, hg⟩ := F.exists_rep
  have hηg : genericPoint ↥Y ∈ g.domain :=
    (genericPoint_specializes _).mem_open g.domain.2
      g.dense_domain.nonempty.choose_spec
  -- Both restrict to the generic morphism of `F` at the generic point.
  have hψη : ψP.fromSpecStalkOfMem hηψ = F.fromFunctionField := by
    have hφ : ψP.fromSpecStalkOfMem hPψ = φ :=
      Scheme.PartialMap.fromSpecStalkOfMem_ofFromSpecStalk qY qZ φ hcomp
    rw [← Scheme.PartialMap.fromSpecStalkOfMem_specializes ψP
      (genericPoint_specializes P) hPψ hηψ, hφ, hgen]
  have hgη : g.fromSpecStalkOfMem hηg = F.fromFunctionField := by
    rw [← hg, Scheme.RationalMap.fromFunctionField_toRationalMap]
  -- Hence the spread-out partial map represents `F`, and `P` is in its domain.
  have hequiv : ψP.equiv g :=
    Scheme.PartialMap.equiv_of_fromSpecStalkOfMem_eq ψP g hηψ hηg
      (hψη.trans hgη.symm)
  exact Scheme.RationalMap.mem_domain.mpr
    ⟨ψP, hPψ, (Scheme.PartialMap.toRationalMap_eq_iff.mpr hequiv).trans hg⟩

end AlgebraicGeometry
