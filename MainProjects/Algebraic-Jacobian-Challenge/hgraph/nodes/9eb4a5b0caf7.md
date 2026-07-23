---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Adelic.module_finite_h1_p1BaseChange
docstring: '**`H¹`-finiteness of the ℙ¹_A Čech complex** (work item 2, `H¹` half,

  concrete form): for a finitely presented module `M` on `ℙ¹_A`, the cokernel

  of the base-linear Čech difference map of the standard 2-chart cover

  `p1BaseChangeCoverSquare` is a finite `Γ(Spec A, ⊤)`-module — the

  `Module.Finite A (M1 ⧸ range d)` input of the two-term finite replacement

  `exists_twoTermFiniteReplacement`.  No finiteness of `A` is needed.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1Engine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.module_finite_h1_p1BaseChange
type: lean
updated: '2026-07-24T03:02:11'
---
theorem module_finite_h1_p1BaseChange
    (M : (Limits.pullback (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    [M.IsFinitePresentation] :
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₁
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₂
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        ((p1BaseChangeCoverSquare A).U₁ ⊓ (p1BaseChangeCoverSquare A).U₂)
    Module.Finite Γ(Spec (CommRingCat.of A), ⊤)
      (Γ(M, (p1BaseChangeCoverSquare A).U₁ ⊓ (p1BaseChangeCoverSquare A).U₂) ⧸
        LinearMap.range ((p1BaseChangeCoverSquare A).moduleSectionDiffBase
          (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M)) :=
  (p1BaseChangeRelLaurentChartData A).module_finite_h1 M
    (Scheme.Modules.module_finite_sections_of_isFinitePresentation M
      ⟨(p1BaseChangeCoverSquare A).U₁, (p1BaseChangeCoverSquare A).isAffineOpen_U₁⟩)

end P1BaseChange

/-! ## §5. The endgame skeleton: the two-term finite replacement on the
ℙ¹_A Čech complex

The abstract `TwoTermFiniteFree` machinery applied to the base-linear Čech
complex `d = moduleSectionDiffBase` of `p1BaseChangeCoverSquare`.  All the
module-theoretic hypotheses of the Mumford brick are now discharged for
finitely presented, base-flat `M`:

* flatness of `M⁰ = Γ(M, U₁) × Γ(M, U₂)` and `M¹ = Γ(M, U₁ ⊓ U₂)` — from
  the pinned `CoherentSheafFlat` hypothesis
  (`flat_baseSections_of_coherentSheafFlat` + `TwoTerm.flat_prod`);
* finite generation of `H¹ = coker d` — the A-coefficient Laurent ladder
  (`module_finite_h1_p1BaseChange`);
* noetherianity of the base ring `Γ(Spec A, ⊤) ≅ A` — Hilbert basis.

**Audited remaining leaf (see the module docstring)**: finite generation of
`H⁰ = ker d (= Γ(ℙ¹_A, M))` is Serre-finiteness-grade and is consumed as
the named hypothesis `hH0`; the geometric bridges (fibrewise
`FiberH1Vanishing` at scheme points ⟹ surjectivity of `d ⊗ κ(𝔪)` at maximal
ideals, and `ker d` finite projective ⟹ `p_* M` locally free of rank
`fiberH0`, shaped as `P1RigidPushforwardStatement`) are the remaining B3
sessions' work. -/

section Endgame

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the instance-heavy `letI` environment (fleet recipe).