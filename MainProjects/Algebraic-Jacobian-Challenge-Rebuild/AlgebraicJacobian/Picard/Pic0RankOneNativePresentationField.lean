/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartTwistSplit

/-!
# Field-extension stability for rank-one presentation witnesses

The rank-one layer delivered by the translated-cover construction is a class over a field.
Testing its pullback over an arbitrary affine algebra reads that class at residue fields, which
are arbitrary extensions of the original field.  This file proves that the split-witness
condition survives every such extension.

The proof does not reuse the original splitting field directly.  If `N / K` is the finite
separable splitting supplied by the witness and `L / K` is arbitrary, a field factor `P / L`
of `L \otimes[K] N` is finite separable over `L` and receives `N`.  The presenting Cech class
and its `H^1` witness are then transported from `N` to `P`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsFinite pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

set_option maxHeartbeats 1600000 in
/-- A split witness remains a split witness after an arbitrary extension of its reading field.

The output splitting field is not the original one: it is a finite-separable field factor of
the base change of the original field cover.  Consequently no finiteness, separability, or
algebraicity assumption is imposed on the reading-field extension itself. -/
theorem isSplitWitness_map_overSpecMap_of_algHom
    {K L : Type u} [Field K] [Algebra k K] [Field L] [Algebra k L]
    (e : K →ₐ[k] L) (nu : picEt C (overSpec k K))
    (h : IsSplitWitness C nu) :
    IsSplitWitness C (picEtMap C (Over.overSpecMap e) nu) := by
  obtain ⟨N, hNf, hkN, hKN, htowkKN, hNfin, hNsep, M, hM, W, hW, hW1⟩ := h
  letI := hNf
  letI := hkN
  letI := hKN
  letI := htowkKN
  letI := hNfin
  letI := hNsep
  letI hKL : Algebra K L := e.toRingHom.toAlgebra
  haveI htowkKL : IsScalarTower k K L :=
    .of_algebraMap_eq fun x => (e.commutes x).symm
  obtain ⟨P, hPf, hLP, hPfin, hPsep, ⟨q⟩⟩ :=
    ((Algebra.EtaleCover.ofField (K := K) N).baseChange L)
      .exists_finiteSeparableField_algHom
  letI := hPf
  letI := hLP
  letI := hPfin
  letI := hPsep
  letI hkP : Algebra k P := ((algebraMap L P).comp (algebraMap k L)).toAlgebra
  haveI htowkLP : IsScalarTower k L P := .of_algebraMap_eq fun _ => rfl
  letI hKP : Algebra K P := ((algebraMap L P).comp e.toRingHom).toAlgebra
  haveI htowKLP : IsScalarTower K L P := .of_algebraMap_eq fun _ => rfl
  haveI htowkKP : IsScalarTower k K P := .of_algebraMap_eq fun x => by
    change algebraMap L P (algebraMap k L x) = algebraMap L P (e (algebraMap k K x))
    rw [e.commutes]
  set sigma : N →ₐ[K] P :=
    ((q.restrictScalars K).comp
        ((Algebra.EtaleCover.ofField (K := K) N).baseChangeInclude L)).comp
      (Algebra.EtaleCover.ofFieldEquiv (K := K) N).symm.toAlgHom with hsigma
  letI hNP : Algebra N P := sigma.toRingHom.toAlgebra
  haveI htowKNP : IsScalarTower K N P :=
    .of_algebraMap_eq fun x => (sigma.commutes x).symm
  haveI htowkNP : IsScalarTower k N P := .of_algebraMap_eq fun x => by
    rw [← IsScalarTower.algebraMap_apply k K N,
      ← IsScalarTower.algebraMap_apply K N P,
      IsScalarTower.algebraMap_apply k K P]
  obtain ⟨D, hD⟩ :=
    BasicOpenCocycleDatum.exists_cechPicClass_eq (C := C) (B := N) (π := pi) M
  have hid : Scheme.CechPic.map (relCurveMap C N N) D.cechPicClass
      = D.cechPicClass := by
    have hmap : relCurveMap C N N = 𝟙 (relCurve C N) := by
      rw [relCurveMap]
      have hbase : overSpecMap (k := k) N N = 𝟙 (overSpec k N) :=
        Over.OverMorphism.ext (by simp)
      rw [hbase, MonoidalCategory.whiskerLeft_id]
      rfl
    rw [hmap, Scheme.CechPic.map_id]
    rfl
  have hWitnessN : D.HasWitnessH1Vanishing N :=
    ⟨W, by rw [hid, hD, hW], hW1⟩
  obtain ⟨W', hW', hW1'⟩ :=
    (D.hasWitnessH1Vanishing_iff_of_fieldExtension N P).mp hWitnessN
  have hMP : PicEtAff.map C P (picEtAffineEquiv C K nu)
      = PicEtAff.unit C P
          (relPicMk C (overSpec k P) (Scheme.CechPic.map (relCurveMap C N P) M)) := by
    have hmap := congrArg (PicEtAff.map C P) hM
    rw [PicEtAff.map_map, PicEtAff.map_unit, relPicAlgMap_mk] at hmap
    exact hmap
  refine isSplitWitness_of_presenting_witness C _
    (Scheme.CechPic.map (relCurveMap C N P) M) ?_ W' ?_ hW1'
  · rw [picEtAffineEquiv_naturality]
    change PicEtAff.map C P (PicEtAff.map C L (picEtAffineEquiv C K nu)) = _
    rw [PicEtAff.map_map]
    exact hMP
  · rw [hW', hD]

end

end AlgebraicGeometry
