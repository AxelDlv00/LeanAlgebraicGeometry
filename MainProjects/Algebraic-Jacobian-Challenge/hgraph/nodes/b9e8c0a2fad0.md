---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.dual
docstring: '**The sheaf-level dual `M^∨ := ℋom_{𝒪_X}(M, 𝒪_X)`** of an `𝒪_X`-module.


  For a scheme `X` and `M : X.Modules`, the dual `dual M : X.Modules` is the

  sheafification of the presheaf-of-modules dual `PresheafOfModules.dual` of the

  underlying presheaf of `M` (the internal hom into the structure presheaf,

  `M^∨(U) = ℋom_{𝒪_X|_U}(M|_U, 𝒪_X|_U)`).


  Construction = the **exact dual analogue of `tensorObj`** (this file, `tensorObj`):

  apply the sheafification functor `PresheafOfModules.sheafification (𝟙 …)` on the

  small Zariski site of `X` to the (axiom-clean, sub-step-3) presheaf dual

  `PresheafOfModules.dual M.val`. The scheme''s structure presheaf `X.presheaf` is

  `CommRingCat`-valued over the single-universe topological site `Opens X`, hence
  is

  exactly the base `R₀ : Dᵒᵖ ⥤ CommRingCat.{u}` that `PresheafOfModules.dual`

  requires (the value `M^∨(U) = M|_U ⟶ R|_U` is an `R(U)`-module, needing

  commutativity) — no CommRingCat/RingCat re-bridging is needed, since

  `tensorObj` already takes `(R := X.presheaf)` over the same CommRingCat presheaf

  and `X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` definitionally.


  The sheafification functor already lands in `SheafOfModules`, so no manual

  `Presheaf.IsSheaf` / sheaf-condition descent is needed (sheafifying an already-sheaf

  gives an iso object; this is the file''s convention, matching `tensorObj`).


  Per blueprint `lem:internal_hom_isSheaf` (§`sec:tensorobj_dual_infra`); Stacks

  tags 01CM (internal hom into a sheaf is a sheaf) / 01CR item 2. This is the

  `⊗`-inverse candidate of an invertible sheaf, feeding `exists_tensorObj_inverse`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.dual
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) :
    SheafOfModules X.ringCatSheaf)