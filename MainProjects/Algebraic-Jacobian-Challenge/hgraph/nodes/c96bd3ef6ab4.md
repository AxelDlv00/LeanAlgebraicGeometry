---
author: sync
content_type: definition
created: '2026-07-29T22:29:09'
decl: AlgebraicGeometry.Scheme.Pic0Et.identityCotangentSpace
docstring: The Zariski cotangent space `m_e/m_e²` at the identity of `Pic⁰_{C/k}`.
file: AlgebraicJacobian/Picard/Pic0EtTangentSpace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.identityCotangentSpace
type: lean
updated: '2026-07-29T22:29:09'
---
noncomputable abbrev identityCotangentSpace (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :=
  CotangentSpace ((Pic0SchemeEt C).left.presheaf.stalk ((identitySection C).base default))

/-! ## §2. The two legs of Kleiman §5 Thm. `thm:tgtsp`, étale formulation -/