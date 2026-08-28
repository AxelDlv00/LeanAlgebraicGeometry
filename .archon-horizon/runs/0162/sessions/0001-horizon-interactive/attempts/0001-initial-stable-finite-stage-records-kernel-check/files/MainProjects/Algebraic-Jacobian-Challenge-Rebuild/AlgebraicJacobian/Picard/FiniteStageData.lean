/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.FinitePresentationAlgebraMapFiniteStage

/-!
# Stable finite-stage data

The first finite-stage files in this project expose several nested existential
packages.  That shape is convenient for proving existence, but it loses the
stage inclusion and makes every consumer reconstruct the same comparison
square.  This module provides small records for the data that is actually
used by consumers.  The records are additive: the original existential
theorems remain available, and the adapters below turn their output into the
records without introducing new hypotheses.
-/

set_option autoImplicit false

universe u

open TensorProduct

namespace AlgebraicGeometry.DatG0

/-! ## A finite stage and its canonical inclusion -/

/-- A finite intermediate stage of an algebraic field extension.

The finite-dimensionality witness is stored as a field instead of being
reconstructed by typeclass search at every use site.  The map to the ambient
field is canonical (`IntermediateField.val`), so tensor maps built from this
record have a stable type.
-/
structure FiniteStageData (F K : Type u) [Field F] [Field K] [Algebra F K] where
  stage : IntermediateField F K
  finiteWitness : FiniteDimensional F stage

namespace FiniteStageData

/-- Regard the packaged stage as an element of the old `FinSubext` index. -/
def toFinSubext {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) : FinSubext F K :=
  ⟨S.stage, S.finiteWitness⟩

/-- The canonical inclusion of a finite stage into the ambient field. -/
abbrev inclusion {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) : S.stage →ₐ[F] K := S.stage.val

@[simp]
theorem inclusion_apply {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) (x : S.stage) : S.inclusion x = (x : K) := rfl

theorem inclusion_injective {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) : Function.Injective S.inclusion := by
  intro x y h
  exact Subtype.ext h

/-- Package an existing finite-subextension witness. -/
def ofFinSubext {F K : Type u} [Field F] [Field K] [Algebra F K]
    (L : FinSubext F K) : FiniteStageData F K :=
  { stage := L.1
    finiteWitness := L.2 }

@[simp]
theorem ofFinSubext_toFinSubext {F K : Type u} [Field F] [Field K] [Algebra F K]
    (L : FinSubext F K) : (ofFinSubext L).toFinSubext = L := by
  rfl

@[simp]
theorem toFinSubext_stage {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) : S.toFinSubext.1 = S.stage := rfl

/-! ## Tensor maps attached to a stage -/

/-- The canonical scalar-extension map from a finite-stage tensor product to
the ambient tensor product. -/
noncomputable def tensorMap {F K A : Type u}
    [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra F A]
    (S : FiniteStageData F K) :
    S.stage ⊗[F] A →ₐ[F] K ⊗[F] A :=
  Algebra.TensorProduct.map S.inclusion (AlgHom.id F A)

@[simp]
theorem tensorMap_apply_tmul {F K A : Type u}
    [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra F A]
    (S : FiniteStageData F K) (x : S.stage) (a : A) :
    S.tensorMap (A := A) (x ⊗ₜ[F] a) = (x : K) ⊗ₜ[F] a := by
  rfl

end FiniteStageData

/-! ## Explicit inclusions between stages -/

/-- A pinned map between two finite stages, together with its ambient
compatibility equation. -/
structure FiniteStageInclusion {F K : Type u}
    [Field F] [Field K] [Algebra F K]
    (S T : FiniteStageData F K) where
  le : S.stage ≤ T.stage
  map : S.stage →ₐ[F] T.stage
  map_spec : ∀ x, T.inclusion (map x) = S.inclusion x

namespace FiniteStageInclusion

/-- The canonical inclusion associated to an order relation. -/
def ofLE {F K : Type u} [Field F] [Field K] [Algebra F K]
    {S T : FiniteStageData F K} (h : S.stage ≤ T.stage) :
    FiniteStageInclusion S T :=
  { le := h
    map := IntermediateField.inclusion h
    map_spec := by
      intro x
      rfl }

@[simp]
theorem ofLE_map {F K : Type u} [Field F] [Field K] [Algebra F K]
    {S T : FiniteStageData F K} (h : S.stage ≤ T.stage) :
    (ofLE h).map = IntermediateField.inclusion h := rfl

theorem map_eq_canonical {F K : Type u} [Field F] [Field K] [Algebra F K]
    {S T : FiniteStageData F K} (i : FiniteStageInclusion S T) :
    i.map = IntermediateField.inclusion i.le := by
  apply DFunLike.ext _ _
  intro x
  apply T.inclusion_injective
  rw [i.map_spec]
  rfl

/-- Composition of pinned stage inclusions. -/
def comp {F K : Type u} [Field F] [Field K] [Algebra F K]
    {S T U : FiniteStageData F K}
    (i : FiniteStageInclusion S T) (j : FiniteStageInclusion T U) :
    FiniteStageInclusion S U :=
  { le := i.le.trans j.le
    map := j.map.comp i.map
    map_spec := by
      intro x
      calc
        U.inclusion ((j.map.comp i.map) x) = U.inclusion (j.map (i.map x)) := rfl
        _ = T.inclusion (i.map x) := j.map_spec _
        _ = S.inclusion x := i.map_spec _ }

/-- Identity inclusion at a stage. -/
def refl {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) : FiniteStageInclusion S S :=
  ofLE le_rfl

@[simp]
theorem refl_map {F K : Type u} [Field F] [Field K] [Algebra F K]
    (S : FiniteStageData F K) :
    (refl S).map = AlgHom.id F S.stage := by
  apply DFunLike.ext _ _
  intro x
  rfl

end FiniteStageInclusion

/-
/-! ## Presented models at one stage -/

/-- A finite-presentation model of a `K`-algebra at one finite stage. -/
structure FiniteStageModelData
    (F K A : Type u) [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra K A] where
  stage : FiniteStageData F K
  generators : Nat
  relationCount : Nat
  relation : Fin relationCount →
    MvPolynomial (Fin generators) stage.stage
  comparison :
    K ⊗[stage.stage] FiniteRelationAlgebra stage.stage generators
      relationCount relation ≃ₐ[K] A

namespace FiniteStageModelData

/-- The finite algebra represented by a model package. -/
abbrev model {F K A : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra K A]
    (D : FiniteStageModelData F K A) : Type u :=
  FiniteRelationAlgebra D.stage.stage D.generators D.relationCount D.relation

/-- Adapter from the raw single-algebra finite-presentation existential. -/
theorem exists_of_raw
    {F K A : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K]
    [CommRing A] [Algebra K A]
    [Algebra.FinitePresentation K A] :
    Nonempty (FiniteStageModelData F K A) := by
  obtain ⟨L, n, m, relation, ⟨e⟩⟩ :=
    exists_finSubext_finitePresentation_algebra_model (F := F) (K := K) (A := A)
  exact ⟨{
    stage := FiniteStageData.ofFinSubext L
    generators := n
    relationCount := m
    relation := relation
    comparison := e }⟩

end FiniteStageModelData

/-- A simultaneous family of finite-presentation models at one common stage. -/
structure FiniteStageModelFamilyData
    (F K : Type u) [Field F] [Field K] [Algebra F K]
    {ι : Type*} (A : ι → Type u)
    [∀ i, CommRing (A i)] [∀ i, Algebra K (A i)] where
  stage : FiniteStageData F K
  generators : ι → Nat
  relationCount : ι → Nat
  relation : ∀ i, Fin (relationCount i) →
    MvPolynomial (Fin (generators i)) stage.stage
  comparison : ∀ i,
    K ⊗[stage.stage] FiniteRelationAlgebra stage.stage
      (generators i) (relationCount i) (relation i) ≃ₐ[K] A i

namespace FiniteStageModelFamilyData

/-- Adapter from the raw simultaneous finite-presentation existential. -/
theorem exists_of_raw
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] {ι : Type*} [Finite ι]
    (A : ι → Type u)
    [∀ i, CommRing (A i)] [∀ i, Algebra K (A i)]
    [∀ i, Algebra.FinitePresentation K (A i)] :
    Nonempty (FiniteStageModelFamilyData F K A) := by
  obtain ⟨L, hL⟩ :=
    exists_finSubext_finitePresentation_algebra_model_finite (F := F) (K := K) A
  choose n m relation he using hL
  let e : ∀ i,
      K ⊗[L.1] FiniteRelationAlgebra L.1 (n i) (m i) (relation i) ≃ₐ[K] A i :=
    fun i => Classical.choice (he i)
  exact ⟨{
    stage := FiniteStageData.ofFinSubext L
    generators := n
    relationCount := m
    relation := relation
    comparison := e }⟩

end FiniteStageModelFamilyData

/-! ## Comparison maps and map families -/

/-- One finite-stage map together with its ambient comparison square.  The
square is stored explicitly, so downstream code never has to re-infer the
restriction/tensor instances. -/
structure FiniteStageComparisonData
    (F K A B : Type u) [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra F A] [CommRing B] [Algebra F B] where
  stage : FiniteStageData F K
  ambientMap : K ⊗[F] A →ₐ[K] K ⊗[F] B
  stageMap : stage.stage ⊗[F] A →ₐ[stage.stage] stage.stage ⊗[F] B
  compatibility :
    (stage.tensorMap (A := B)).comp (stageMap.restrictScalars F) =
      (ambientMap.restrictScalars F).comp (stage.tensorMap (A := A))

namespace FiniteStageComparisonData

@[simp]
theorem compatibility_apply
    {F K A B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra F A] [CommRing B] [Algebra F B]
    (D : FiniteStageComparisonData F K A B) (x : D.stage.stage ⊗[F] A) :
    D.stage.tensorMap (A := B) (D.stageMap.restrictScalars F x) =
      D.ambientMap.restrictScalars F (D.stage.tensorMap (A := A) x) := by
  exact DFunLike.congr_fun D.compatibility x

/-- Adapter from the raw single-map finite-stage existential. -/
theorem exists_of_raw
    {F K A B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K]
    [CommRing A] [Algebra F A] [Algebra.FiniteType F A]
    [CommRing B] [Algebra F B]
    (phi : K ⊗[F] A →ₐ[K] K ⊗[F] B) :
    Nonempty (FiniteStageComparisonData F K A B) := by
  obtain ⟨L, phiL, hphi⟩ :=
    exists_finSubext_tensorProduct_algHom (F := F) (K := K) (A := A) (B := B) phi
  exact ⟨{
    stage := FiniteStageData.ofFinSubext L
    ambientMap := phi
    stageMap := phiL
    compatibility := hphi }⟩

end FiniteStageComparisonData

/-- A finite family of map comparisons sharing one stage. -/
structure FiniteStageMapFamily
    (F K : Type u) [Field F] [Field K] [Algebra F K]
    {ι : Type*} (A B : ι → Type u)
    [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)] where
  stage : FiniteStageData F K
  ambientMap : ∀ i, K ⊗[F] A i →ₐ[K] K ⊗[F] B i
  stageMap : ∀ i, stage.stage ⊗[F] A i →ₐ[stage.stage] stage.stage ⊗[F] B i
  compatibility : ∀ i,
    (stage.tensorMap (A := B i)).comp ((stageMap i).restrictScalars F) =
      ((ambientMap i).restrictScalars F).comp (stage.tensorMap (A := A i))

namespace FiniteStageMapFamily

/-- Each family member is a first-class comparison package. -/
def comparison {F K : Type u} [Field F] [Field K] [Algebra F K]
    {ι : Type*} {A B : ι → Type u}
    [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)]
    (P : FiniteStageMapFamily F K A B) (i : ι) :
    FiniteStageComparisonData F K (A i) (B i) :=
  { stage := P.stage
    ambientMap := P.ambientMap i
    stageMap := P.stageMap i
    compatibility := P.compatibility i }

/-- Adapter from the raw simultaneous map-family existential. -/
theorem exists_of_raw
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] {ι : Type*} [Finite ι]
    (A B : ι → Type u)
    [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    [∀ i, Algebra.FiniteType F (A i)]
    [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)]
    (phi : ∀ i, K ⊗[F] A i →ₐ[K] K ⊗[F] B i) :
    Nonempty (FiniteStageMapFamily F K A B) := by
  obtain ⟨L, hL⟩ :=
    exists_finSubext_tensorProduct_algHom_finite
      (F := F) (K := K) A B phi
  choose phiL hphiL using hL
  exact ⟨{
    stage := FiniteStageData.ofFinSubext L
    ambientMap := phi
    stageMap := phiL
    compatibility := hphiL }⟩

end FiniteStageMapFamily

/-! ## Composition coherence -/

/-- A packaged three-map comparison used to reflect a composition identity
from the ambient extension back to a finite stage. -/
structure FiniteStageCompositionData
    (F K A B D : Type u) [Field F] [Field K] [Algebra F K]
    [CommRing A] [Algebra F A] [CommRing B] [Algebra F B]
    [CommRing D] [Algebra F D] where
  stage : FiniteStageData F K
  phiStage : stage.stage ⊗[F] A →ₐ[stage.stage] stage.stage ⊗[F] B
  psiStage : stage.stage ⊗[F] B →ₐ[stage.stage] stage.stage ⊗[F] D
  chiStage : stage.stage ⊗[F] A →ₐ[stage.stage] stage.stage ⊗[F] D
  phiAmbient : K ⊗[F] A →ₐ[K] K ⊗[F] B
  psiAmbient : K ⊗[F] B →ₐ[K] K ⊗[F] D
  chiAmbient : K ⊗[F] A →ₐ[K] K ⊗[F] D
  phi_compatibility :
    (stage.tensorMap (A := B)).comp (phiStage.restrictScalars F) =
      (phiAmbient.restrictScalars F).comp (stage.tensorMap (A := A))
  psi_compatibility :
    (stage.tensorMap (A := D)).comp (psiStage.restrictScalars F) =
      (psiAmbient.restrictScalars F).comp (stage.tensorMap (A := B))
  chi_compatibility :
    (stage.tensorMap (A := D)).comp (chiStage.restrictScalars F) =
      (chiAmbient.restrictScalars F).comp (stage.tensorMap (A := A))
  ambient_composition : psiAmbient.comp phiAmbient = chiAmbient

namespace FiniteStageCompositionData

/-- Reflect the ambient composition equation using the pinned comparison
fields. -/
theorem stage_composition
    {F K A B D : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K]
    [CommRing A] [Algebra F A] [CommRing B] [Algebra F B]
    [CommRing D] [Algebra F D]
    (P : FiniteStageCompositionData F K A B D) :
    P.psiStage.comp P.phiStage = P.chiStage := by
  apply tensorProduct_algHom_comp_eq_of_baseChange
    P.stage.toFinSubext P.phiStage P.psiStage P.chiStage
    P.phiAmbient P.psiAmbient P.chiAmbient
  · exact P.phi_compatibility
  · exact P.psi_compatibility
  · exact P.chi_compatibility
  · exact P.ambient_composition

end FiniteStageCompositionData

end AlgebraicGeometry.DatG0
-/
