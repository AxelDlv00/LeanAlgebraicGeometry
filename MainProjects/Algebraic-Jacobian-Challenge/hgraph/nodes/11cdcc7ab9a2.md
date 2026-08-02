---
author: sync
content_type: theorem
created: '2026-08-03T02:07:57'
decl: AlgebraicGeometry.Scheme.exists_affineOpen_of_subset_isHQuasiProjective_opens
docstring: 'The H-quasi-projective form of the piecewise transport: a finite set lying

  in one H-quasi-projective open piece over an affine base lies in an affine open

  of the ambient scheme.  Unlike the globally projective hypothesis of §5, this

  is compatible with an ambient infinite coproduct of quasi-projective pieces.'
file: AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_affineOpen_of_subset_isHQuasiProjective_opens
type: lean
updated: '2026-08-03T02:07:57'
---
theorem exists_affineOpen_of_subset_isHQuasiProjective_opens {X : Scheme.{u}}
    (U : X.Opens) {S : Scheme.{u}} [IsAffine S] {π : U.toScheme ⟶ S}
    (hqp : π.IsHQuasiProjective) {s : Set X} (hs : s.Finite) (hsub : s ⊆ U.1) :
    ∃ V : X.affineOpens, s ⊆ V.1 :=
  exists_affineOpen_of_subset_finiteInAffine_opens U
    (finiteInAffine_of_isHQuasiProjective hqp) hs hsub

/-! ## §7. `FiniteInAffine` is closed under coproducts — the repair of §5's refutation

`§5.5` shows the antecedent `PointedPicSharpRepProjective` — projectivity of the scheme
representing the *whole* of `picSharp` — is FALSE at its intended object, because
`Pic_{C/k} = ∐_{d ∈ ℤ} Pic^d` is a countable disjoint union and projectivity of it would
force `CompactSpace` (`compactSpace_of_isProjective`), which `Pic_{C/k}` is not
(`not_isProjective_of_infinite_disjoint_open_cover`).  The usable replacement is a
coproduct of components that each carry an H-quasi-projective witness.  Constructing
those component witnesses is a separate producer obligation.

`FiniteInAffine`, unlike `IsProjective` or `CompactSpace`, **is** closed under such
coproducts: a finite set meets only finitely many components, each hit in an affine open,
and finitely many disjoint affine opens have an affine `iSup`
(`IsAffineOpen.biSup_of_disjoint`).  So this section turns the refuted globally-projective
antecedent into a degree-graded substrate — `FiniteInAffine` of the ambient coproduct
follows from H-quasi-projectivity of each supplied component, which is exactly the
geometric adapter a future degree assembly can consume.  This file does not construct
that assembly or any Picard representer.

Everything here is about coproducts of arbitrary schemes and carries **no** hypothesis
about the curve; nothing closes the seam.  It is the substrate the earlier sections said
was missing ("degree-invariance of the semilinear action, together with the degree-graded
decomposition of `PicSchemeEt`" — the second half). -/

section Coproduct