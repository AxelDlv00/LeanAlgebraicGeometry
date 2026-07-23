---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coprodToProd_isIso_option
docstring: '`Option`-adjoining step of the finite induction: given the result for
  `α`, deduce it for

  `Option α`, via the slice `Option`-coproduct split (`overSigmaOptionIso`), the binary

  decomposition (`pushPull_binary_coprod_prod`), the induction hypothesis, and the
  dual

  product split (`piOptionIso`).  Project-local.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coprodToProd_isIso_option
type: lean
updated: '2026-07-16T21:14:26'
---
private theorem coprodToProd_isIso_option (F : X.Modules) {α : Type u}
    (ih : ∀ (legs : α → Over X), IsIso (coprodToProdMap F legs))
    (legs : Option α → Over X) : IsIso (coprodToProdMap F legs) := by
  -- The reference iso through: the slice `Option`-coproduct split, the binary decomposition,
  -- the induction hypothesis on the `some`-part, and the dual `Option`-product split.
  -- Bind the restricted family `ls := legs ∘ some` to a local definition so that the `none`-split
  -- binary leg `Y₁ = Over.mk (Sigma.desc (ls ·).hom)` and the induction-hypothesis comparison
  -- `coprodToProdMap F ls` share *syntactically identical* product objects (otherwise the unreduced
  -- `(fun a => legs (some a)) i` beta-redex blocks the `prod.lift`/`prod.map` projection rewrites).
  let ls : α → Over X := fun a => legs (some a)
  haveI := ih ls
  let refIso : pushPullObj F (Over.mk (Limits.Sigma.desc (fun o => (legs o).hom))) ≅
      ∏ᶜ fun o => pushPullObj F (legs o) :=
    pushPullObjCongr F (overSigmaOptionIso legs) ≪≫
      pushPull_binary_coprod_prod F (legs none)
        (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom))) ≪≫
      Limits.prod.mapIso (Iso.refl _) (asIso (coprodToProdMap F ls)) ≪≫
      (piOptionIso (fun o => pushPullObj F (legs o))).symm
  -- It remains to identify the canonical comparison `coprodToProdMap F legs` with `refIso.hom`
  -- (both are `Pi.lift`s of push–pull maps); then `IsIso` is immediate.  This final coherence
  -- check — matching each projection via the per-leg push–pull coherence
  -- (`pushPull_binary_leg_coherence` for the `none`/`some` inclusions) — is the residual.
  have hcanon : coprodToProdMap F legs = refIso.hom := by
    show coprodToProdMap F legs =
      (pushPullObjCongr F (overSigmaOptionIso legs) ≪≫
        pushPull_binary_coprod_prod F (legs none)
          (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom))) ≪≫
        Limits.prod.mapIso (Iso.refl _) (asIso (coprodToProdMap F ls)) ≪≫
        (piOptionIso (fun o => pushPullObj F (legs o))).symm).hom
    refine Limits.Pi.hom_ext _ _ (fun o => ?_)
    rw [coprodToProdMap, Limits.Pi.lift_π, Iso.trans_hom, Iso.trans_hom, Iso.trans_hom,
      pushPullObjCongr_hom, pushPull_binary_coprod_prod_hom, Iso.symm_hom,
      Limits.prod.mapIso_hom, Iso.refl_hom, asIso_hom]
    cases o with
    | none =>
      simp only [Category.assoc]
      rw [piOptionIso_inv_π_none, Limits.prod.map_fst, Category.comp_id]
      erw [Limits.prod.lift_fst, ← pushPullMap_comp]
      refine congrArg (fun g => pushPullMap F g) ?_
      apply Over.OverMorphism.ext
      simp only [coprodOverIncl, overSigmaOptionIso, Over.isoMk_inv_left, Over.comp_left,
        Over.homMk_left, sigmaOptionIso]
      erw [Limits.coprod.inl_desc]
    | some a =>
      -- Reassociate the LHS inclusion through the binary split and the `some` coproduct leg, then
      -- expand with the *forward* `pushPullMap_comp` (syntactic head-match — the reverse fold blows
      -- up `whnf` on the push–pull composites).
      have heq : coprodOverIncl legs (some a) =
          (coprodOverIncl ls a ≫ (Over.homMk Limits.coprod.inr
              (Limits.coprod.inr_desc (legs none).hom (Limits.Sigma.desc (fun a => (ls a).hom))) :
              (Over.mk (Limits.Sigma.desc (fun a => (ls a).hom)) : Over X) ⟶
                Over.mk (Limits.coprod.desc (legs none).hom
                  (Limits.Sigma.desc (fun a => (ls a).hom)))))
            ≫ (overSigmaOptionIso legs).inv := by
        apply Over.OverMorphism.ext
        simp only [coprodOverIncl, overSigmaOptionIso, Over.isoMk_inv_left, Over.comp_left,
          Over.homMk_left, sigmaOptionIso, Category.assoc]
        erw [Limits.coprod.inr_desc, Limits.Sigma.ι_desc]
      simp only [Category.assoc]
      rw [piOptionIso_inv_π_some, Limits.prod.map_snd_assoc]
      erw [Limits.prod.lift_snd_assoc, coprodToProdMap_comp_π F ls a]
      rw [heq, pushPullMap_comp, pushPullMap_comp]
  rw [hcanon]
  infer_instance