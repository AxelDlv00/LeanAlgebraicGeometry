---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.scalarEnd_pullback_iso
docstring: 'Iso-conjugated form of the scalar-endomorphism pullback atom `scalarEnd_pullback`:

  `(pullback p).map (scalarEnd a) = Q.hom ≫ scalarEnd (p.appTop a) ≫ Q.inv`, with

  `Q = pullbackUnitIso p`.  The rank-one analogue of `matrixEnd_pullback`.'
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.scalarEnd_pullback_iso
type: lean
updated: '2026-07-16T21:14:28'
---
lemma scalarEnd_pullback_iso {T S : Scheme.{0}} (p : T ⟶ S) (a : Γ(S, ⊤)) :
    (pullback p).map (scalarEnd a)
      = (pullbackUnitIso p).hom ≫ scalarEnd (p.appTop a) ≫ (pullbackUnitIso p).inv := by
  have key : (pullback p).map (scalarEnd a) ≫ (pullbackUnitIso p).hom
      = (pullbackUnitIso p).hom ≫ scalarEnd (p.appTop a) :=
    scalarEnd_pullback p a
  rw [← Category.assoc, ← key, Category.assoc, Iso.hom_inv_id, Category.comp_id]

/-- Closed zig-zag: `Q_φ⁻¹ ≫ pullbackCongr(h).app ≫ Q_ψ = 𝟙` for equal base
morphisms `φ = ψ`.  Rank-one mirror of `pullbackFreeIso_inv_congr_hom`. -/
@[reassoc]