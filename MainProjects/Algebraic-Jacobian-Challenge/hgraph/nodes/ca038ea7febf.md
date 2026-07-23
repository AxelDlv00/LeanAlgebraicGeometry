---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.chartQuotientMap
docstring: 'The **chart quotient** `u^I : O_{U^I}^r → O_{U^I}^d` (`def:gr_chart_quotient`):

  left multiplication by the universal matrix `X^I` (`universalMatrix`). It is realised
  as

  the morphism of free sheaves of modules whose matrix of components, in the standard
  bases

  `(e_{i''})_{i'' : Fin r}` and `(e_p)_{p : Fin d}`, is the universal matrix `X^I`
  injected

  into the structure sheaf via `Scheme.ΓSpecIso`. Since the `I`-minor of `X^I` is
  the

  identity, `u^I` is a split surjection onto the free rank-`d` sheaf.


  Project-local: Mathlib has no "matrix ↦ morphism of free sheaves" primitive.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.chartQuotientMap
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def chartQuotientMap (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin r) ⟶
      SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d) :=
  let A := CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
  let R := (affineChart d r I).ringCatSheaf
  haveI : HasFiniteBiproducts (SheafOfModules R) :=
    HasFiniteBiproducts.of_hasFiniteProducts
  let M : ∀ (_ : Fin r) (_ : Fin d), SheafOfModules.unit R ⟶ SheafOfModules.unit R :=
    fun i' p => scalarEnd ((Scheme.ΓSpecIso A).inv.hom ((universalMatrix d r I hI) p i'))
  (biproduct.isoCoproduct (fun _ : Fin r => SheafOfModules.unit R)).symm.hom ≫
    biproduct.matrix M ≫
    (biproduct.isoCoproduct (fun _ : Fin d => SheafOfModules.unit R)).hom