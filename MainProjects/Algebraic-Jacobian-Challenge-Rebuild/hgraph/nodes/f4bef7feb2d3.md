---
author: sync
content_type: definition
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageModelScalarExtensionSemiring
docstring: "A finite-presentation model ring after extension to the final finite subextension.\
  \ -/\nnoncomputable abbrev Pic0FiniteStageFinalModelRing\n    {F : Type u} [Field\
  \ F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (N : DatG0.FinSubext M.1 k)\n    (j : Pic0FiniteStageRingIndex\
  \ C) : Type u :=\n  N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j\n\n\
  /-!\nThe nested tensor aliases above hide the carrier instances that `cancelBaseChange`\n\
  needs.  Keep the witnesses named and local to this module, mirroring the explicit\n\
  overlap instances in `Pic0FiniteStageGluePackage`.\n-/\n@[reducible] noncomputable\
  \ instance pic0FiniteStageModelRingCommRing\n    {F : Type u} [Field F] [Algebra\
  \ F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex C ->\
  \ Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n \
  \   (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex C) :\n    CommRing\
  \ (Pic0FiniteStageModelRing C L n m relation M j) := by\n  dsimp only [Pic0FiniteStageModelRing]\n\
  \  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n    Algebra.TensorProduct.leftAlgebra\n\
  \      (R := L.1) (S := M.1) (A := M.1)\n      (B := DatG0.FiniteRelationAlgebra\
  \ L.1 (n j) (m j) (relation j))\n  exact Algebra.TensorProduct.instCommRing\n\n\
  @[reducible] noncomputable instance pic0FiniteStageModelRingAlgebra\n    {F : Type\
  \ u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex C) :\n    Algebra\
  \ M.1 (Pic0FiniteStageModelRing C L n m relation M j) := by\n  dsimp only [Pic0FiniteStageModelRing]\n\
  \  exact Algebra.TensorProduct.leftAlgebra\n    (R := L.1) (S := M.1) (A := M.1)\n\
  \    (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))\n\n@[reducible]\
  \ noncomputable instance pic0FiniteStageFinalModelRingCommRing\n    {F : Type u}\
  \ [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (N : DatG0.FinSubext M.1 k)\n    (j : Pic0FiniteStageRingIndex\
  \ C) :\n    CommRing (Pic0FiniteStageFinalModelRing C L n m relation M N j) := by\n\
  \  dsimp only [Pic0FiniteStageFinalModelRing]\n  letI : Algebra M.1 (Pic0FiniteStageModelRing\
  \ C L n m relation M j) :=\n    Algebra.TensorProduct.leftAlgebra\n      (R := L.1)\
  \ (S := M.1) (A := M.1)\n      (B := DatG0.FiniteRelationAlgebra L.1 (n j) (m j)\
  \ (relation j))\n  letI : CommRing (Pic0FiniteStageModelRing C L n m relation M\
  \ j) :=\n    pic0FiniteStageModelRingCommRing C L n m relation M j\n  letI : CommSemiring\
  \ (Pic0FiniteStageModelRing C L n m relation M j) :=\n    (inferInstance : CommRing\
  \ (Pic0FiniteStageModelRing C L n m relation M j)).toCommSemiring\n  exact @Algebra.TensorProduct.instCommRing\
  \ M.1 N.1\n    (Pic0FiniteStageModelRing C L n m relation M j)\n    (inferInstance\
  \ : CommSemiring M.1)\n    (inferInstance : CommRing N.1)\n    (inferInstance :\
  \ Algebra M.1 N.1)\n    (pic0FiniteStageModelRingCommRing C L n m relation M j).toCommSemiring\n\
  \    (pic0FiniteStageModelRingAlgebra C L n m relation M j)\n\n@[reducible] noncomputable\
  \ instance pic0FiniteStageFinalModelRingCommSemiring\n    {F : Type u} [Field F]\
  \ [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (N : DatG0.FinSubext M.1 k)\n    (j : Pic0FiniteStageRingIndex\
  \ C) :\n    CommSemiring (Pic0FiniteStageFinalModelRing C L n m relation M N j)\
  \ :=\n  (pic0FiniteStageFinalModelRingCommRing C L n m relation M N j).toCommSemiring\n\
  \n@[reducible] noncomputable instance pic0FiniteStageFinalModelRingAlgebra\n   \
  \ {F : Type u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m\
  \ : Pic0FiniteStageRingIndex C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial\
  \ (Fin (n j)) L.1)\n    (M : DatG0.FinSubext L.1 k)\n    (N : DatG0.FinSubext M.1\
  \ k)\n    (j : Pic0FiniteStageRingIndex C) :\n    Algebra N.1 (Pic0FiniteStageFinalModelRing\
  \ C L n m relation M N j) := by\n  dsimp only [Pic0FiniteStageFinalModelRing]\n\
  \  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n    Algebra.TensorProduct.leftAlgebra\n\
  \      (R := L.1) (S := M.1) (A := M.1)\n      (B := DatG0.FiniteRelationAlgebra\
  \ L.1 (n j) (m j) (relation j))\n  exact Algebra.TensorProduct.leftAlgebra\n   \
  \ (R := M.1) (S := N.1) (A := N.1)\n    (B := Pic0FiniteStageModelRing C L n m relation\
  \ M j)\n\nattribute [instance 2000] pic0FiniteStageFinalModelRingAlgebra\n\n@[reducible]\
  \ noncomputable def pic0FiniteStageModelRingBaseAlgebra\n    {F : Type u} [Field\
  \ F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex C) :\n    Algebra\
  \ L.1 (Pic0FiniteStageModelRing C L n m relation M j) := by\n  exact @Algebra.TensorProduct.instAlgebra\
  \ L.1 M.1\n    (DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j))\n    (inferInstance\
  \ : CommSemiring L.1)\n    (inferInstance : Semiring M.1)\n    (inferInstance :\
  \ Algebra L.1 M.1)\n    (inferInstance : Semiring\n      (DatG0.FiniteRelationAlgebra\
  \ L.1 (n j) (m j) (relation j)))\n    (inferInstance : Algebra L.1\n      (DatG0.FiniteRelationAlgebra\
  \ L.1 (n j) (m j) (relation j)))\n\nattribute [local instance] pic0FiniteStageModelRingBaseAlgebra\n\
  \nset_option synthInstance.maxHeartbeats 400000 in\n-- Register the fixed tensor\
  \ actions so dependent `restrictScalars` declarations see this tower.\nset_option\
  \ maxHeartbeats 6400000 in\nnoncomputable instance pic0FiniteStageModelRingIsScalarTower\n\
  \    {F : Type u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n\
  \ m : Pic0FiniteStageRingIndex C -> Nat)\n    (relation : forall j, Fin (m j) ->\
  \ MvPolynomial (Fin (n j)) L.1)\n    (M : DatG0.FinSubext L.1 k)\n  (j : Pic0FiniteStageRingIndex\
  \ C) :\n    IsScalarTower L.1 M.1 (Pic0FiniteStageModelRing C L n m relation M j)\
  \ := by\n  letI : Algebra L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n\
  \    pic0FiniteStageModelRingBaseAlgebra C L n m relation M j\n  letI : Algebra\
  \ M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n    pic0FiniteStageModelRingAlgebra\
  \ C L n m relation M j\n  letI : SMul M.1 (Pic0FiniteStageModelRing C L n m relation\
  \ M j) :=\n    TensorProduct.leftHasSMul\n  letI : SMul L.1 (Pic0FiniteStageModelRing\
  \ C L n m relation M j) :=\n    TensorProduct.instSMul\n  refine { smul_assoc :=\
  \ ?_ }\n  intro x y z\n  induction z using TensorProduct.induction_on with\n  |\
  \ zero => simp\n  | add z₁ z₂ ih₁ ih₂ => simp [ih₁, ih₂]\n  | tmul a b =>\n    \
  \  simp [Algebra.smul_def, TensorProduct.smul_tmul', ← mul_assoc]\n\nattribute [instance\
  \ 100000] pic0FiniteStageModelRingIsScalarTower\n\n/-\nThe source maps below are\
  \ indexed by `q`, so elaborating `restrictScalars` directly\ncan select a different\
  \ tensor-product action for the dependent source and target\nmodels.  Freeze those\
  \ actions at this private boundary.  The wrapper has the same\ncarrier map as `AlgHom.restrictScalars`;\
  \ only its implicit algebra structures are\nmade explicit.  The original proof and\
  \ public statement remain archived in the\npreceding Horizon attempts.\n-/\nnoncomputable\
  \ abbrev pic0FiniteStageModelRingSMulLM\n    {F : Type u} [Field F] [Algebra F k]\n\
  \    (L : DatG0.FinSubext F k) (M : DatG0.FinSubext L.1 k) : SMul L.1 M.1 :=\n \
  \ IntermediateField.instSMulSubtypeMem_1 M.1\n\nnoncomputable abbrev pic0FiniteStageModelRingSMulM\n\
  \    {F : Type u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n\
  \ m : Pic0FiniteStageRingIndex C -> Nat)\n    (relation : forall j, Fin (m j) ->\
  \ MvPolynomial (Fin (n j)) L.1)\n    (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex\
  \ C) :\n    SMul M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n  TensorProduct.leftHasSMul\n\
  \nnoncomputable abbrev pic0FiniteStageModelRingSMulL\n    {F : Type u} [Field F]\
  \ [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex C) :\n    SMul\
  \ L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n  TensorProduct.instSMul\n\
  \n@[reducible] noncomputable def pic0FiniteStageModelRingTowerExplicit\n    {F :\
  \ Type u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (j : Pic0FiniteStageRingIndex C) :\n    @IsScalarTower\
  \ L.1 M.1 (Pic0FiniteStageModelRing C L n m relation M j)\n      (pic0FiniteStageModelRingSMulLM\
  \ L M)\n      (pic0FiniteStageModelRingSMulM C L n m relation M j)\n      (pic0FiniteStageModelRingSMulL\
  \ C L n m relation M j) := by\n  letI : Algebra L.1 (Pic0FiniteStageModelRing C\
  \ L n m relation M j) :=\n    pic0FiniteStageModelRingBaseAlgebra C L n m relation\
  \ M j\n  letI : Algebra M.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n\
  \    pic0FiniteStageModelRingAlgebra C L n m relation M j\n  letI : SMul L.1 M.1\
  \ := pic0FiniteStageModelRingSMulLM L M\n  letI : SMul M.1 (Pic0FiniteStageModelRing\
  \ C L n m relation M j) :=\n    pic0FiniteStageModelRingSMulM C L n m relation M\
  \ j\n  letI : SMul L.1 (Pic0FiniteStageModelRing C L n m relation M j) :=\n    pic0FiniteStageModelRingSMulL\
  \ C L n m relation M j\n  refine { smul_assoc := ?_ }\n  intro x y z\n  induction\
  \ z using TensorProduct.induction_on with\n  | zero => simp\n  | add z1 z2 ih1 ih2\
  \ => simp [ih1, ih2]\n  | tmul a b =>\n      simp [Algebra.smul_def, TensorProduct.smul_tmul',\
  \ ← mul_assoc]\n\nnoncomputable def pic0FiniteStageModelRestrictScalarsExplicit\n\
  \    {F : Type u} [Field F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n\
  \ m : Pic0FiniteStageRingIndex C -> Nat)\n    (relation : forall j, Fin (m j) ->\
  \ MvPolynomial (Fin (n j)) L.1)\n    (M : DatG0.FinSubext L.1 k)\n    (j1 j2 : Pic0FiniteStageRingIndex\
  \ C)\n    (f : @AlgHom M.1\n      (Pic0FiniteStageModelRing C L n m relation M j1)\n\
  \      (Pic0FiniteStageModelRing C L n m relation M j2)\n      (inferInstance :\
  \ CommSemiring M.1)\n      (pic0FiniteStageModelRingCommRing C L n m relation M\
  \ j1).toSemiring\n      (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring\n\
  \      (pic0FiniteStageModelRingAlgebra C L n m relation M j1)\n      (pic0FiniteStageModelRingAlgebra\
  \ C L n m relation M j2)) :\n    @AlgHom L.1\n      (Pic0FiniteStageModelRing C\
  \ L n m relation M j1)\n      (Pic0FiniteStageModelRing C L n m relation M j2)\n\
  \      (inferInstance : CommSemiring L.1)\n      (pic0FiniteStageModelRingCommRing\
  \ C L n m relation M j1).toSemiring\n      (pic0FiniteStageModelRingCommRing C L\
  \ n m relation M j2).toSemiring\n      (pic0FiniteStageModelRingBaseAlgebra C L\
  \ n m relation M j1)\n      (pic0FiniteStageModelRingBaseAlgebra C L n m relation\
  \ M j2) := by\n  exact @AlgHom.restrictScalars\n    L.1 M.1\n      (Pic0FiniteStageModelRing\
  \ C L n m relation M j1)\n      (Pic0FiniteStageModelRing C L n m relation M j2)\n\
  \      (inferInstance : CommSemiring L.1)\n      (inferInstance : CommSemiring M.1)\n\
  \      (pic0FiniteStageModelRingCommRing C L n m relation M j1).toSemiring\n   \
  \   (pic0FiniteStageModelRingCommRing C L n m relation M j2).toSemiring\n      (inferInstance\
  \ : Algebra L.1 M.1)\n      (pic0FiniteStageModelRingAlgebra C L n m relation M\
  \ j1)\n      (pic0FiniteStageModelRingAlgebra C L n m relation M j2)\n      (pic0FiniteStageModelRingBaseAlgebra\
  \ C L n m relation M j1)\n      (pic0FiniteStageModelRingBaseAlgebra C L n m relation\
  \ M j2)\n      (pic0FiniteStageModelRingTowerExplicit C L n m relation M j1)\n \
  \     (pic0FiniteStageModelRingTowerExplicit C L n m relation M j2)\n      f\n\n\
  /- The outer scalar extension sees these inner tensors as dependent carriers.\n\
  \   Name their canonical instances so the nested map in the theorem header does\n\
  \   not synthesize a fresh, incoherent `Semiring` structure for each `q`."
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageModelScalarExtensionSemiring
type: lean
updated: '2026-08-25T10:27:23'
---
@[reducible] noncomputable def pic0FiniteStageModelScalarExtensionSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    Semiring (N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j) :=
  @Algebra.TensorProduct.instSemiring M.1 N.1
    (Pic0FiniteStageModelRing C L n m relation M j)
    (inferInstance : CommSemiring M.1)
    (inferInstance : Semiring N.1)
    (inferInstance : Algebra M.1 N.1)
    (pic0FiniteStageModelRingCommRing C L n m relation M j).toSemiring
    (pic0FiniteStageModelRingAlgebra C L n m relation M j)

attribute [local instance] pic0FiniteStageModelScalarExtensionSemiring