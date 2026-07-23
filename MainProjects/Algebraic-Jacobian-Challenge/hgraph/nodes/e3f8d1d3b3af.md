---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition
docstring: '**D1 — the presheaf pullback Lan decomposition** (blueprint `lem:pullback_lan_decomposition`).

  For `φ : S ⟶ F.op ⋙ R` presenting a pushforward of presheaves of modules, the presheaf

  pullback factors as extension of scalars followed by the topological inverse image,

  `pullback φ ≅ extendScalars φ ⋙ pullback₀`. This is the left-adjoint reversal of
  the

  definitional factorisation `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`,
  obtained

  from `Adjunction.leftAdjointCompIso` (uniqueness of left adjoints). Project-local.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def pullbackLanDecomposition (φ : S ⟶ F.op ⋙ R) :
    PresheafOfModules.pullback φ ≅ extendScalars φ ⋙ pullback0 F R :=
  (Adjunction.leftAdjointCompIso
    (extendScalarsAdjunction φ) (pullback0Adjunction F R)
    (PresheafOfModules.pullbackPushforwardAdjunction φ)
    (Iso.refl (PresheafOfModules.pushforward φ))).symm

end PullbackLanDecomposition

/-! ## Project-local Mathlib supplement — D1'–D4' loc-triv pullback–tensor comparison

The locally-trivial-restricted upgrade of the oplax comparison map
`pullbackTensorMap` (`f^*(M ⊗ N) ⟶ f^*M ⊗ f^*N`) to an isomorphism, blueprint
§`sec:tensorobj_pullback_monoidality`, sub-lemmas D1'–D4'. -/

section LocTrivPullbackTensor