---
author: sync
content_type: theorem
created: '2026-07-29T22:37:03'
decl: AlgebraicGeometry.Scheme.DivFamily.isFinitePresentation_pushforward
docstring: '**`q_* O_D` is finitely presented** — the input

  `flatLocusStratification_universal` actually asks for.


  Reduced by `isFinitePresentation_of_finite_sections` to `Module.Finite` of the

  sections over each affine `V`, where the finiteness of the support map is spent:

  `Γ(T,V) → Γ(D,W)` is finite by `IsFinite.finite_app` (this is what quasi-finiteness

  bought), `Γ(D,W) → Γ(N,W)` by `finite_sections_preimage_of_isAffineHom`, and the
  two

  compose. The transport back to `Γ(q_* O_D, V)` is available because the two `Γ`

  identifications are `rfl` and the ambient action is `compHom` along `q.app V`.'
file: AlgebraicJacobian/Picard/DivPushforwardFlat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.isFinitePresentation_pushforward
type: lean
updated: '2026-07-29T22:37:03'
---
theorem Scheme.DivFamily.isFinitePresentation_pushforward
    {S X : Scheme.{u}} {π : X ⟶ S} [IsProper π] {T : Over S}
    [IsLocallyNoetherian (T.left : Scheme.{u})] (x : Scheme.DivFamily π T)
    [LocallyQuasiFinite
      (Scheme.Modules.schematicSupportι x.F ≫ pullback.snd π T.hom)] :
    ((Scheme.Modules.pushforward (pullback.snd π T.hom)).obj x.F).IsFinitePresentation := by
  letI := x.isFinitePresentation
  haveI := x.isQuasicoherent_pushforward
  refine Scheme.Modules.isFinitePresentation_of_finite_sections _ (fun V hV => ?_)
  let q := pullback.snd π T.hom
  let i := Scheme.Modules.schematicSupportι x.F
  haveI : IsProper (i ≫ q) := x.properSupport
  haveI : IsFinite (i ≫ q) := IsFinite.of_isProper_of_locallyQuasiFinite _
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom (Scheme.Modules.annihilator x.F).subschemeι)
  let D := Scheme.Modules.schematicSupport x.F
  let W : D.Opens := (i ≫ q) ⁻¹ᵁ V
  let N : D.Modules := (Scheme.Modules.pullback i).obj x.F
  haveI : N.IsFinitePresentation :=
    Scheme.Modules.isFinitePresentation_pullback_schematicSupportι x.F x.isFinitePresentation
  -- the finiteness tower over the affine `V`
  letI : Algebra Γ(T.left, V) Γ(D, W) := (Scheme.Hom.app (i ≫ q) V).hom.toAlgebra
  letI : Module Γ(T.left, V) Γ(N, W) :=
    Module.compHom _ (Scheme.Hom.app (i ≫ q) V).hom
  haveI : Module.Finite Γ(T.left, V) Γ(D, W) := IsFinite.finite_app (i ≫ q) V hV
  haveI : Module.Finite Γ(D, W) Γ(N, W) :=
    Scheme.Modules.finite_sections_preimage_of_isAffineHom (i ≫ q) N hV
  haveI : IsScalarTower Γ(T.left, V) Γ(D, W) Γ(N, W) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  haveI htrans : Module.Finite Γ(T.left, V) Γ(N, W) :=
    Module.Finite.trans Γ(D, W) _
  -- transport along the descent isomorphism; both `Γ`-identifications are `rfl`
  have hdesc : x.F ≅ (Scheme.Modules.pushforward i).obj N :=
    Scheme.Modules.schematicSupportDescentIso x.F
  -- the two directions of the descent iso, at the section level over `V`
  have hcomp : (((Scheme.Modules.pushforward q).map hdesc.hom).app V ≫
      ((Scheme.Modules.pushforward q).map hdesc.inv).app V) =
      𝟙 Γ((Scheme.Modules.pushforward q).obj x.F, V) := by
    rw [← Scheme.Modules.Hom.comp_app, ← Functor.map_comp, hdesc.hom_inv_id]
    simp
  refine Module.Finite.of_surjective
    ({ toFun := fun n => ((Scheme.Modules.pushforward q).map hdesc.inv).app V n
       map_add' := fun a b => map_add _ a b
       map_smul' := fun r n =>
         Scheme.Modules.Hom.app_smul
           ((Scheme.Modules.pushforward q).map hdesc.inv) r n } :
      Γ(N, W) →ₗ[Γ(T.left, V)]
        Γ((Scheme.Modules.pushforward q).obj x.F, V)) (fun z => ?_)
  exact ⟨((Scheme.Modules.pushforward q).map hdesc.hom).app V z,
    congrArg (fun f => f z) hcomp⟩