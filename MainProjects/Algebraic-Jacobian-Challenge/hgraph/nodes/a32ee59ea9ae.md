---
author: sync
content_type: theorem
created: '2026-07-27T16:23:53'
decl: AlgebraicGeometry.nonempty_pullbackIsoFree_of_free_sections
docstring: '**A quasi-coherent module whose sections are free of rank `n` is the free

  sheaf of rank `n`** (Stacks 01I8 + 01HV).  For an open immersion of affines

  `j : Spec S ⟶ Spec R`, if `Γ(j^* N, ⊤)` is a free `S`-module of rank `n` (and `S`

  is nontrivial, so that the rank is the cardinality of a basis), then `j^* N` is

  isomorphic to `𝒪_{Spec S}^{⊕ n}`.


  Proof: quasi-coherence is stable under pullback

  (`pullback_isQuasicoherent_hom`), so the tilde–Γ counit of `j^* N` is invertible

  (`isIso_fromTildeΓ_of_quasicoherent`) and `j^* N ≅ (Γ(j^* N, ⊤))^~`

  (`qcoh_iso_tilde_sections`); a rank-`n` basis identifies the module of sections

  with `S^{⊕ n}`, whose tilde is the free sheaf (`tildeFinsupp`).'
file: AlgebraicJacobian/Picard/RigidPushforwardP1Sheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.nonempty_pullbackIsoFree_of_free_sections
type: lean
updated: '2026-07-27T16:23:53'
---
theorem nonempty_pullbackIsoFree_of_free_sections {R S : CommRingCat.{u}} (j : Spec S ⟶ Spec R)
    [IsOpenImmersion j] (N : (Spec R).Modules) (hN : N.IsQuasicoherent) (n : ℕ)
    (hnt : Nontrivial S)
    (hfree : Module.Free S Γ((Scheme.Modules.pullback j).obj N, ⊤))
    (hfin : Module.Finite S Γ((Scheme.Modules.pullback j).obj N, ⊤))
    (hrank : Module.finrank S Γ((Scheme.Modules.pullback j).obj N, ⊤) = n) :
    Nonempty ((Scheme.Modules.pullback j).obj N ≅
      _root_.SheafOfModules.free (R := (Spec S).ringCatSheaf) (ULift.{u} (Fin n))) := by
  haveI := hnt
  haveI : ((Scheme.Modules.pullback j).obj N).IsQuasicoherent :=
    AlgebraicGeometry.pullback_isQuasicoherent_hom j N hN
  haveI : IsIso (Scheme.Modules.fromTildeΓ ((Scheme.Modules.pullback j).obj N)) :=
    AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent ((Scheme.Modules.pullback j).obj N)
  have eK : (Scheme.Modules.pullback j).obj N
      ≅ tilde (moduleSpecΓFunctor.obj ((Scheme.Modules.pullback j).obj N)) :=
    qcoh_iso_tilde_sections ((Scheme.Modules.pullback j).obj N)
  haveI := hfree
  haveI := hfin
  let b : Module.Basis (ULift.{u} (Fin n)) S Γ((Scheme.Modules.pullback j).obj N, ⊤) :=
    (Module.finBasisOfFinrankEq S Γ((Scheme.Modules.pullback j).obj N, ⊤) hrank).reindex
      Equiv.ulift.symm
  have eM : moduleSpecΓFunctor.obj ((Scheme.Modules.pullback j).obj N)
      ≅ ModuleCat.of S (ULift.{u} (Fin n) →₀ S) := LinearEquiv.toModuleIso b.repr
  exact ⟨eK ≪≫ (tilde.functor S).mapIso eM ≪≫ tildeFinsupp (ULift.{u} (Fin n))⟩