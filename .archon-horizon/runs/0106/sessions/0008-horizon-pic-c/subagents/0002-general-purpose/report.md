No sorry/axiom (grep exit 1 = no matches). Everything is complete.

## Summary

Created `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Algebra/LaurentBaseChange.lean`, mathlib-only, `set_option autoImplicit false`, in `namespace AlgebraicGeometry` with `variable {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]`.

Build: `lake env lean AlgebraicJacobian/Algebra/LaurentBaseChange.lean` → EXIT=0 (no warnings). All lines ≤ 100 chars. No `sorry`, no `axiom`, no added hypotheses.

Axioms (all 10 public theorems): `[propext, Classical.choice, Quot.sound]`.

Key naming note: there is no `LaurentPolynomial.map` in mathlib. The Laurent coefficient-change map is `AddMonoidAlgebra.mapRingHom (M := ℤ) (algebraMap k A)`, so `laurentBaseChange_tmul_one` targets that; the polynomial side uses `Polynomial.map (algebraMap k A)`.

Definitions:
- `polyBaseChange (k A) : k[X] ⊗[k] A ≃ₐ[k] A[X]`
- `laurentBaseChange (k A) : k[T;T⁻¹] ⊗[k] A ≃ₐ[k] A[T;T⁻¹]`

Theorems landed (all requested, exact signatures):
- `laurentBaseChange_tmul_one (x : LaurentPolynomial k) : laurentBaseChange k A (x ⊗ₜ[k] 1) = AddMonoidAlgebra.mapRingHom (M := ℤ) (algebraMap k A) x`
- `laurentBaseChange_C (c : k) : laurentBaseChange k A (LaurentPolynomial.C c ⊗ₜ 1) = LaurentPolynomial.C (algebraMap k A c)`
- `laurentBaseChange_T (n : ℤ) : laurentBaseChange k A (LaurentPolynomial.T n ⊗ₜ 1) = LaurentPolynomial.T n`
- `polyBaseChange_tmul_one (p : Polynomial k) : polyBaseChange k A (p ⊗ₜ[k] 1) = Polynomial.map (algebraMap k A) p`
- `polyBaseChange_C (c : k) : polyBaseChange k A (Polynomial.C c ⊗ₜ 1) = Polynomial.C (algebraMap k A c)`
- `polyBaseChange_X : polyBaseChange k A (Polynomial.X ⊗ₜ 1) = Polynomial.X`
- `mapRingHom_toLaurent (p : Polynomial k) : AddMonoidAlgebra.mapRingHom (M := ℤ) (algebraMap k A) (Polynomial.toLaurent p) = Polynomial.toLaurent (Polynomial.map (algebraMap k A) p)` (left-chart naturality)
- `mapRingHom_rightChart (p : Polynomial k) : AddMonoidAlgebra.mapRingHom (M := ℤ) (algebraMap k A) (Polynomial.eval₂RingHom LaurentPolynomial.C (LaurentPolynomial.T (-1)) p) = Polynomial.eval₂RingHom LaurentPolynomial.C (LaurentPolynomial.T (-1)) (Polynomial.map (algebraMap k A) p)` (right-chart naturality)
- `laurentBaseChange_toLaurent (p : Polynomial k) : laurentBaseChange k A (Polynomial.toLaurent p ⊗ₜ[k] 1) = Polynomial.toLaurent (Polynomial.map (algebraMap k A) p)` — the left ℙ¹ chart intertwining
- `laurentBaseChange_rightChart (p : Polynomial k) : laurentBaseChange k A (Polynomial.eval₂RingHom LaurentPolynomial.C (LaurentPolynomial.T (-1)) p ⊗ₜ[k] 1) = Polynomial.eval₂RingHom LaurentPolynomial.C (LaurentPolynomial.T (-1)) (Polynomial.map (algebraMap k A) p)` — the right ℙ¹ chart intertwining

Two `private` helper lemmas (`mapAlgEquiv_single`, `lbc_single`) support the proofs. Proof strategy for the `_tmul_one` results was ring-hom extensionality (`AddMonoidAlgebra.ringHom_ext` / `Polynomial.ringHom_ext`) on the composite with `includeLeftRingHom`, reduced to the `single`/generator computations; the two intertwining lemmas then follow by `rw [laurentBaseChange_tmul_one, mapRingHom_…]`.

Imports used: `Mathlib.Algebra.Polynomial.Laurent`, `Mathlib.RingTheory.TensorProduct.Maps`, `Mathlib.RingTheory.TensorProduct.MonoidAlgebra`, `Mathlib.RingTheory.PolynomialAlgebra`, `Mathlib.Algebra.MonoidAlgebra.MapDomain`.

I did not commit and did not touch any other file. The olean was built via `lake build` (needed for the axiom scratch check, now deleted); the file itself is left on disk.
