---
author: sync
content_type: theorem
created: '2026-08-13T22:44:24'
decl: AlgebraicGeometry.canonicalRankOneDivisorOfMem_unique
docstring: Any Abel-correct widened divisor class equals the canonical rank-one divisor.
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorFree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.canonicalRankOneDivisorOfMem_unique
type: lean
updated: '2026-08-13T22:44:24'
---
theorem canonicalRankOneDivisorOfMem_unique
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A)))
    (F : DivFamZarAff C A (genus C))
    (hF : abelDivAffPlus C A F = picEtAffineEquiv C A lam.1) :
    F = canonicalRankOneDivisorOfMem pi hpi hlam :=
  (existsUnique_abel_divFamZarAff_of_mem pi hpi hlam).choose_spec.2 F hF