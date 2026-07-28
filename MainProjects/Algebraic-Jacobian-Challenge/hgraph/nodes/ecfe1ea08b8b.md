---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_affineCover
docstring: '**Open-cover gluing for the section-wise flat base change**

  (basis-locality reduction, Stacks 02KH(ii) corollary).


  If the section of the canonical base-change map is an iso over *every*

  affine open `V ⊆ S''`, then it is an iso over every open `U ⊆ S''` as well.


  PROVED (T12 session, 2026-07-06, Lane F fbc-leaves front). Route: the

  affine opens form a basis of `S''` (`Scheme.isBasis_affineOpens`); a

  morphism of sheaves of modules that is an iso on sections over every

  basic open is an iso of sheaves

  (`Modules.isIso_of_isIso_app_of_isBasis`, the sorry-free basis-locality

  engine from `AlgebraicJacobian.Cohomology.FlatBaseChange`, built on

  Mathlib''s stalkwise criterion `isIso_of_stalkFunctor_map_iso` plus

  `stalkFunctor_map_injective_of_isBasis` / `exists_mem_germ_eq_of_isBasis`);

  and Mathlib''s instance `IsIso φ → IsIso (φ.app U)` restores the

  section-wise claim at an arbitrary open `U`. No Mayer-Vietoris gluing and

  no `QuasiSeparated f` input is needed for this reduction step (the

  hypothesis is kept for signature stability with the consumer chain).'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_affineCover
type: lean
updated: '2026-07-28T13:22:16'
---
private theorem canonicalBaseChangeMap_app_app_isIso_of_affineCover
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) [F.IsQuasicoherent]
    (h_affine : ∀ V : S'.Opens, IsAffineOpen V →
        IsIso (((canonicalBaseChangeMap sq).app F).app V))
    (U : S'.Opens) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) := by
  -- Iso on the affine-opens basis ⟹ iso of sheaf morphisms ⟹ iso at `U`.
  haveI : IsIso ((canonicalBaseChangeMap sq).app F) :=
    Modules.isIso_of_isIso_app_of_isBasis
      (B := (Subtype.val : S'.affineOpens → S'.Opens))
      (by simpa [Subtype.range_val] using S'.isBasis_affineOpens)
      ((canonicalBaseChangeMap sq).app F)
      (fun V => h_affine V.1 V.2)
  infer_instance