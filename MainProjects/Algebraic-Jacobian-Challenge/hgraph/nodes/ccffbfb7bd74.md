---
author: sync
content_type: structure
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.PicSharp.Rigidification
docstring: 'A **rigidification** of a line bundle `L` on `C ×_S T` along a section
  `σ` of the

  projection is a trivialisation of the restriction `σ^* L ≅ 𝒪_T`.'
file: AlgebraicJacobian/Picard/RigidifiedPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicSharp.Rigidification
type: lean
updated: '2026-07-24T17:02:57'
---
structure Rigidification {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    (σ : T ⟶ Limits.pullback πC πT) (L : LineBundle.OnProduct πC πT) where
  /-- The trivialising isomorphism `σ^* L ≅ 𝒪_T`. -/
  triv : (Scheme.Modules.pullback σ).obj L.carrier ≅ SheafOfModules.unit T.ringCatSheaf

/-! ## §3. Existence of a rigidified representative (`lm:fff`) -/