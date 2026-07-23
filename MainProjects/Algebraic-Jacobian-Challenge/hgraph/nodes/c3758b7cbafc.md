---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.so.RelativeSpec.pullback_cocone
docstring: '**Cocone on `(relativeGluingData _).functor` with point

  `pullback g (structureMorphism 𝒜)`** (iter-183 Lane D helper 3,

  axiom-clean modulo naturality unfolding).


  The components are the `IsAffineOpen.fromSpec` maps of the pulled-back affine

  opens `q⁻¹U.1`. Naturality follows from `IsAffineOpen.map_fromSpec` once

  the relative-gluing-data functor''s `map` action is unfolded as

  `Spec.map (P.presheaf.map ((q.preimage_mono ...).op))`. The unfolding chase

  is intricate (deep definitional unfolding of `pushforward` and `rightOp`);

  deferred to iter-184+ as the only remaining work for axiom-clean closure

  of the entire base-change iso.'
file: AlgebraicJacobian/Picard/RelativeSpec.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.so.RelativeSpec.pullback_cocone
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def pullback_cocone {X T : Scheme.{u}} (g : T ⟶ X)
    (𝒜 : X.QcohAlgebra) :
    haveI : IsAffineHom (CategoryTheory.Limits.pullback.fst g
        (RelativeSpec.structureMorphism 𝒜)) :=
      QcohAlgebra.pullback_fst_isAffineHom g 𝒜
    Limits.Cocone (AffineZariskiSite.relativeGluingData
      (QcohAlgebra.pullback g 𝒜).coequifibered).functor :=
  haveI : IsAffineHom (CategoryTheory.Limits.pullback.fst g
      (RelativeSpec.structureMorphism 𝒜)) :=
    QcohAlgebra.pullback_fst_isAffineHom g 𝒜
  { pt := CategoryTheory.Limits.pullback g (RelativeSpec.structureMorphism 𝒜)
    ι :=
    { app := fun U => (U.2.preimage (CategoryTheory.Limits.pullback.fst g
        (RelativeSpec.structureMorphism 𝒜))).fromSpec
      naturality := fun U V x => by
        -- After unfolding `relativeGluingData.functor.map` through its
        -- `rightOp ⋙ Spec` template and the pushforward sheaf, the goal
        -- becomes `Spec.map ((pullback _ _).presheaf.map _) ≫
        --   (V.2.preimage q).fromSpec = (U.2.preimage q).fromSpec ≫ 𝟙 _`,
        -- which is `IsAffineOpen.map_fromSpec` + `Category.comp_id`.
        set q := CategoryTheory.Limits.pullback.fst g
          (RelativeSpec.structureMorphism 𝒜)
        simp only [AffineZariskiSite.relativeGluingData, Functor.comp_obj,
          Functor.comp_map, Functor.rightOp_map, Functor.const_obj_obj,
          Functor.const_obj_map]
        exact (V.2.preimage q).map_fromSpec (U.2.preimage q) _ } }