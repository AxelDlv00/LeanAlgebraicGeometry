import AlgebraicJacobian.Picard.GrassmannianCells
import AlgebraicJacobian.Picard.QuotScheme

/-!
# The tautological quotient and the universal property of `Gr(r,d)`

This file adds, on top of the Grassmannian scheme `Gr(d,r)` built in
`GrassmannianCells.lean`, the tautological rank-`d` quotient
`u : O^r ↠ U` and the universal property making `Gr(d,r)` the fine moduli
space of rank-`d` locally free quotients of `O^r`.

Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (Nitsure §1).
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Grassmannian

/-! ## Project-local Mathlib supplement — scalar endomorphisms of the structure sheaf

To realise a matrix of regular functions as a morphism of free sheaves of modules we
need to turn a global section `a ∈ Γ(X, ⊤)` of the structure sheaf into a scalar
endomorphism of `O_X` (= `SheafOfModules.unit X.ringCatSheaf`). On the affine chart
`U^I = Spec R^I` the matrix entries of the universal matrix `X^I` live in `R^I`, and we
inject them into the global sections via `Scheme.ΓSpecIso`.

These helpers are project-local: Mathlib has no ready-made "matrix ↦ morphism of free
sheaves" primitive. -/

variable {X : Scheme.{u}}

/-- The global section of the structure sheaf `O_X` (as a sheaf of modules over itself)
determined by a section `a ∈ Γ(X, ⊤)` over the whole space, by restriction to every open.
Project-local helper for building scalar endomorphisms. -/
noncomputable def globalUnitSection (a : Γ(X, ⊤)) :
    (SheafOfModules.unit X.ringCatSheaf).sections :=
  PresheafOfModules.sectionsMk
    (fun Y => (X.ringCatSheaf.obj.map (homOfLE le_top).op a : X.ringCatSheaf.obj.obj Y))
    (by
      intro Y Z f
      change (X.ringCatSheaf.obj.map f) (X.ringCatSheaf.obj.map (homOfLE le_top).op a)
        = X.ringCatSheaf.obj.map (homOfLE le_top).op a
      rw [← CategoryTheory.comp_apply, ← X.ringCatSheaf.obj.map_comp]
      congr 1)

/-- The scalar endomorphism of `O_X` given by a global section `a ∈ Γ(X, ⊤)`:
multiplication by `a`. Project-local helper. -/
noncomputable def scalarEnd (a : Γ(X, ⊤)) :
    SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf :=
  (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv.symm (globalUnitSection a)

/-! ## The tautological quotient on the charts -/

/-- The **chart quotient** `u^I : O_{U^I}^r → O_{U^I}^d` (`def:gr_chart_quotient`):
left multiplication by the universal matrix `X^I` (`universalMatrix`). It is realised as
the morphism of free sheaves of modules whose matrix of components, in the standard bases
`(e_{i'})_{i' : Fin r}` and `(e_p)_{p : Fin d}`, is the universal matrix `X^I` injected
into the structure sheaf via `Scheme.ΓSpecIso`. Since the `I`-minor of `X^I` is the
identity, `u^I` is a split surjection onto the free rank-`d` sheaf.

Project-local: Mathlib has no "matrix ↦ morphism of free sheaves" primitive. -/
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

end AlgebraicGeometry.Grassmannian
