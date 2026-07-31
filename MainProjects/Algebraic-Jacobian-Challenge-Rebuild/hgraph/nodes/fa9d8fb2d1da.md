---
author: sync
content_type: lemma
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.ord_functionFieldMap_germ_of_isIso
docstring: '**`ord` transport along an isomorphism, germ form**: for an isomorphism
  `f : W ⟶ X`

  of curve bundles, a closed point `z` of `W`, and a section `s` near `f(z)` with
  nonzero

  germ, the order of the pulled-back rational function `f^♯(germ_η s)` at `z` equals
  the

  order of `germ_η s` at `f(z)`.  Both orders are the adic valuations of the DVR stalks,

  compared through the stalk isomorphism `f.stalkMap z`.'
file: AlgebraicJacobian/RiemannRoch/DegreeIsoTransport.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.ord_functionFieldMap_germ_of_isIso
type: lean
updated: '2026-07-31T20:15:28'
---
private lemma ord_functionFieldMap_germ_of_isIso (f : W ⟶ X) [IsIso f]
    (hgen : f.base (genericPoint W) = genericPoint X)
    {z : W} (hz : z ≠ genericPoint W) (hfz : f.base z ≠ genericPoint X)
    {U : X.Opens} (hηU : genericPoint X ∈ U) (hfzU : f.base z ∈ U) (s : Γ(X, U))
    (hs : (X.presheaf.germ U (f.base z) hfzU).hom s ≠ 0) :
    Scheme.ord (W ↘ Spec (CommRingCat.of K)) hz
        ((f.functionFieldMap hgen).hom ((X.presheaf.germ U (genericPoint X) hηU).hom s))
      = Scheme.ord (X ↘ Spec (CommRingCat.of K)) hfz
          ((X.presheaf.germ U (genericPoint X) hηU).hom s) := by
  letI := isDiscreteValuationRing_stalk (W ↘ Spec (CommRingCat.of K)) hz
  letI := isDedekindDomain_stalk (W ↘ Spec (CommRingCat.of K)) hz
  letI := isDiscreteValuationRing_stalk (X ↘ Spec (CommRingCat.of K)) hfz
  letI := isDedekindDomain_stalk (X ↘ Spec (CommRingCat.of K)) hfz
  have hzU' : z ∈ f ⁻¹ᵁ U := hfzU
  have hηU' : genericPoint W ∈ f ⁻¹ᵁ U := by
    change f.base (genericPoint W) ∈ U
    rw [hgen]
    exact hηU
  set c : X.presheaf.stalk (f.base z) := (X.presheaf.germ U (f.base z) hfzU).hom s with hcdef
  have hΦ : (f.functionFieldMap hgen).hom ((X.presheaf.germ U (genericPoint X) hηU).hom s)
      = (W.presheaf.germ (f ⁻¹ᵁ U) (genericPoint W) hηU').hom ((f.app U).hom s) :=
    f.functionFieldMap_germ hgen U hηU hηU' s
  have hW : (W.presheaf.germ (f ⁻¹ᵁ U) (genericPoint W) hηU').hom ((f.app U).hom s)
      = algebraMap (W.presheaf.stalk z) W.functionField
          ((W.presheaf.germ (f ⁻¹ᵁ U) z hzU').hom ((f.app U).hom s)) :=
    Scheme.germ_generic_eq_algebraMap_germ hηU' hzU' _
  have hψ : (W.presheaf.germ (f ⁻¹ᵁ U) z hzU').hom ((f.app U).hom s)
      = (f.stalkMap z).hom c :=
    (f.germ_stalkMap_apply U z hfzU s).symm
  have hX : (X.presheaf.germ U (genericPoint X) hηU).hom s
      = algebraMap (X.presheaf.stalk (f.base z)) X.functionField c :=
    Scheme.germ_generic_eq_algebraMap_germ hηU hfzU s
  have hordW : Scheme.ord (W ↘ Spec (CommRingCat.of K)) hz
      = (stalkHeightOne W z).valuation W.functionField := rfl
  have hordX : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hfz
      = (stalkHeightOne X (f.base z)).valuation X.functionField := rfl
  calc Scheme.ord (W ↘ Spec (CommRingCat.of K)) hz
        ((f.functionFieldMap hgen).hom ((X.presheaf.germ U (genericPoint X) hηU).hom s))
      = (stalkHeightOne W z).valuation W.functionField
          (algebraMap (W.presheaf.stalk z) W.functionField ((f.stalkMap z).hom c)) := by
        rw [hordW, hΦ, hW, hψ]
    _ = (stalkHeightOne W z).intValuation ((f.stalkMap z).hom c) :=
        (stalkHeightOne W z).valuation_of_algebraMap ((f.stalkMap z).hom c)
    _ = (stalkHeightOne X (f.base z)).intValuation c :=
        intValuation_ringEquiv _ rfl _ rfl
          ((asIso (f.stalkMap z)).commRingCatIsoToRingEquiv) hs
    _ = Scheme.ord (X ↘ Spec (CommRingCat.of K)) hfz
          ((X.presheaf.germ U (genericPoint X) hηU).hom s) := by
        rw [hordX, hX, (stalkHeightOne X (f.base z)).valuation_of_algebraMap c]

end OrdTransport

/-! ## Transport of the residue degree along a `K`-isomorphism -/

section ResidueTransport

attribute [local instance] Scheme.residueFieldOverModule

variable (K : Type u) [Field K] {W X : Scheme.{u}}
  [W.Over (Spec (CommRingCat.of K))] [X.Over (Spec (CommRingCat.of K))]