---
author: sync
content_type: theorem
created: '2026-07-28T23:10:51'
decl: AlgebraicGeometry.PicEtAff.degAff_map
docstring: '**Base-field invariance of the plus-class degree** (`w4-datb` §1.2 step
  2; the brick

  issue I-0614 named as absent).  For an arbitrary field extension `L/K` in a tower
  `k → K → L`,

  restricting a plus class along `K → L` does not change its degree.


  No finiteness, separability or algebraicity of `L/K` is assumed — see the file header
  for why

  the statement is *cheaper* than its prediction, and for the two reading fields the
  proof

  constructs (`N/K` from cofinality at `K`, and `P/L` a field factor of `L ⊗[K] N`,
  which is what

  makes a `K`-embedding `N → P` exist at all).'
file: AlgebraicJacobian/Picard/DegreeZeroBaseField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.degAff_map
type: lean
updated: '2026-07-30T15:46:01'
---
theorem PicEtAff.degAff_map {K : Type u} [Field K] [Algebra k K]
    (L : Type u) [Field L] [Algebra k L] [Algebra K L] [IsScalarTower k K L]
    (a : PicEtAff C K) :
    PicEtAff.degAff L (PicEtAff.map C L a) = PicEtAff.degAff K a := by
  induction a using PicEtAff.ind with
  | mk E x =>
    -- (1) the `K`-side reading field: cofinality of field covers at `K`
    obtain ⟨N, hNf, hNa, hNfin, hNsep, ⟨ℓ⟩⟩ := E.exists_finiteSeparableField_algHom
    letI := hNf
    letI := hNa
    letI := hNfin
    letI := hNsep
    letI hkN : Algebra k N := ((algebraMap K N).comp (algebraMap k K)).toAlgebra
    haveI : IsScalarTower k K N := .of_algebraMap_eq fun _ => rfl
    -- (2) the common field: a field factor of `L ⊗[K] N`, obtained by cofinality applied to
    -- the base change of the field cover of `N`.  This is the step that cannot be replaced by
    -- an arbitrary finite separable `P/L`.
    obtain ⟨P, hPf, hPa, hPfin, hPsep, ⟨q⟩⟩ :=
      ((Algebra.EtaleCover.ofField (K := K) N).baseChange L).exists_finiteSeparableField_algHom
    letI := hPf
    letI := hPa
    letI := hPfin
    letI := hPsep
    letI hkP : Algebra k P := ((algebraMap L P).comp (algebraMap k L)).toAlgebra
    haveI htowL : IsScalarTower k L P := .of_algebraMap_eq fun _ => rfl
    letI hKP : Algebra K P := ((algebraMap L P).comp (algebraMap K L)).toAlgebra
    haveI htowKLP : IsScalarTower K L P := .of_algebraMap_eq fun _ => rfl
    haveI htowkKP : IsScalarTower k K P := .of_algebraMap_eq fun r => by
      change algebraMap L P (algebraMap k L r)
        = algebraMap L P (algebraMap K L (algebraMap k K r))
      rw [← IsScalarTower.algebraMap_apply k K L r]
    -- (3) the refinement of the field cover of `N`, and the `K`-embedding `N → P` it carries
    set ℓ' : E.Carrier →ₐ[K] (Algebra.EtaleCover.ofField (K := K) N).Carrier :=
      (Algebra.EtaleCover.ofFieldEquiv (K := K) N).symm.toAlgHom.comp ℓ with hℓ'
    set σ : N →ₐ[K] P :=
      ((q.restrictScalars K).comp
          ((Algebra.EtaleCover.ofField (K := K) N).baseChangeInclude L)).comp
        (Algebra.EtaleCover.ofFieldEquiv (K := K) N).symm.toAlgHom with hσ
    -- (4) the `L`-side reading map, and the square that makes the two readings the same class
    set j : (E.baseChange L).Carrier →ₐ[L] P :=
      q.comp (Algebra.EtaleCover.baseChangeMap L ℓ') with hj
    have hsquare : (j.restrictScalars K).comp (E.baseChangeInclude L) = σ.comp ℓ := by
      have hbc := Algebra.EtaleCover.baseChangeMap_comp_baseChangeInclude
        (A := K) (A' := L) ℓ'
      have hstep : ((Algebra.EtaleCover.baseChangeMap L ℓ').restrictScalars K).comp
            (E.baseChangeInclude L)
          = ((Algebra.EtaleCover.ofField (K := K) N).baseChangeInclude L).comp ℓ' := hbc
      ext y
      have := AlgHom.congr_fun hstep y
      change q (Algebra.EtaleCover.baseChangeMap L ℓ' (E.baseChangeInclude L y)) = _
      rw [show Algebra.EtaleCover.baseChangeMap L ℓ' (E.baseChangeInclude L y)
          = ((Algebra.EtaleCover.ofField (K := K) N).baseChangeInclude L) (ℓ' y) from this]
      simp [hσ, hℓ']
    -- (5) read both sides at `P`, and cross the `P`/`N` step by E-iv-alg
    have hK : PicEtAff.degAff K (PicEtAff.mk C E x)
        = relPicDeg N (relPicAlgMap C (ℓ.restrictScalars k)
            (x : relPic C (overSpec k E.Carrier))) :=
      PicEtAff.degAff_mk E x N ℓ
    have hL : PicEtAff.degAff L (PicEtAff.map C L (PicEtAff.mk C E x))
        = relPicDeg P (relPicAlgMap C (j.restrictScalars k)
            (descentBaseChange C L E x : relPic C (overSpec k (E.baseChange L).Carrier))) := by
      rw [PicEtAff.map_mk]
      exact PicEtAff.degAff_mk (E.baseChange L) (descentBaseChange C L E x) P j
    rw [hL, hK, descentBaseChange_coe, ← relPicAlgMap_comp,
      show (j.restrictScalars k).comp ((E.baseChangeInclude L).restrictScalars k)
          = (σ.restrictScalars k).comp (ℓ.restrictScalars k) from
        AlgHom.ext fun y => AlgHom.congr_fun hsquare y,
      relPicAlgMap_comp]
    exact relPicDeg_relPicAlgMap (σ.restrictScalars k) _