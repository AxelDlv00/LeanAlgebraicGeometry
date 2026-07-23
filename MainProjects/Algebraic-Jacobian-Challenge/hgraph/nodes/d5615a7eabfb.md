---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.representable_of_iso_free
docstring: '**Representability of the relative Grassmannian, trivialised case**: for
  a

  globally trivialised module `V ≅ O_S^r` on a locally noetherian `S` and

  `1 ≤ d ≤ r`, the functor `Grass(V, d)` is representable by the base change

  `S ⨯ Gr(d, r)` of the absolute Grassmannian.  Complete proof: transport the

  representability of the pulled-back absolute functor

  (`prodRepresentableBy`) along the comparisons `congrIso` and `freeCompare`.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.representable_of_iso_free
type: lean
updated: '2026-07-16T21:14:27'
---
theorem representable_of_iso_free {V : S.Modules} {r : ℕ}
    (e : V ≅ SheafOfModules.free (R := S.ringCatSheaf) (Fin r)) {d : ℕ}
    (hd : 1 ≤ d) (hdr : d ≤ r) :
    ∃ (Y : Over S), Nonempty ((Scheme.Grassmannian V d).RepresentableBy Y) :=
  ⟨(Over.star S).obj (AlgebraicGeometry.Grassmannian.scheme d r),
    ⟨(prodRepresentableBy S d r hd hdr).ofIso
      ((Scheme.Grassmannian.congrIso e d ≪≫ freeCompare d r).symm)⟩⟩

end Grassmannian

/-! ## §5. Zariski descent of representability (moved)

The definitions `overRes` / `overResHom` / `overResLE` / `IsZariskiSheafOver`
and the descent theorem `Scheme.representable_of_openCover`
(EGA 0_I 4.5.4; Stacks 01JJ) now live in
`AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean`, where the