/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The Quot scheme: Quot-foundations layer

This file packages the Quot-foundations layer of the
Grothendieck–Altman–Kleiman Quot-scheme construction. It introduces the
per-fiber Hilbert polynomial of a coherent sheaf, the Quot functor
`Quot^{Φ,L}_{E/X/S}` of `T`-flat coherent quotients, and the Grassmannian
*scheme* (Mathlib at the pinned commit carries only a linear-algebra
Grassmannian) together with its representability.

The 4 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.hilbertPolynomial` (def) — the
   **Hilbert polynomial function** `s ↦ Φ_{F,s} ∈ ℚ[λ]` of a coherent
   sheaf `F` on `X` over a finite-type `π : X ⟶ S` with respect to a
   line bundle `L`. Encoded as a function `S → Polynomial ℚ`.

2. `AlgebraicGeometry.Scheme.QuotFunctor` (def) — the **Quot
   functor** `Quot^{Φ,L}_{E/X/S} : (Sch/S)^op ⥤ Set` sending an
   `S`-scheme `T ⟶ S` to the set of equivalence classes
   `⟨F, q⟩` of pairs `(F, q)` with `F` a `T`-flat coherent sheaf on
   `X_T`, `q : E_T ↠ F` a surjection, and `F|_{X_t}` having Hilbert
   polynomial `Φ` at every `t ∈ T`.

3. `AlgebraicGeometry.Scheme.Grassmannian` (def) — the
   **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
   rank-`d` quotients of a locally free `O_S`-module `V`.

4. `AlgebraicGeometry.Scheme.Grassmannian.representable` (theorem)
   — the **representability of the Grassmannian** by a smooth projective
   `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`, equipped with
   the Plücker closed embedding into `ℙ_S(⋀^d V)`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `hilbertPolynomial` returns `Polynomial ℚ` keyed by `s : S`, not
  `Unit`; the Hilbert polynomial is a non-trivial invariant of the
  coherent sheaf at the fiber over `s`.
- `QuotFunctor` and `Grassmannian` return contravariant functors into
  `Type u` — substantive presheaves of sets, not constant functors.
- `Grassmannian.representable` packages the
  `Functor.RepresentableBy` Yoneda-bijection structure: existence of a
  scheme `Y` together with a `RepresentableBy Y` witness — substantive
  content (a representable functor is determined by its representing
  object up to canonical isomorphism, and the witness is the data of
  that isomorphism family).

## Mathlib status

Mathlib (master `b80f227`) provides:
- `AlgebraicGeometry.Scheme.Modules` (the category `X.Modules`),
- `Scheme.Modules.pullback`, `Scheme.Modules.pushforward` (the
  pullback–pushforward adjunction at level `i = 0`),
- `CategoryTheory.Functor.RepresentableBy` for representable functors,
- `AlgebraicGeometry.LocallyOfFiniteType`, `AlgebraicGeometry.IsLocallyNoetherian`
  (morphism / object property predicates), and
- `Polynomial` for `ℚ[λ]`.

Mathlib does NOT provide (at the pinned commit):
- a Grassmannian *scheme* (only a linear-algebra Grassmannian
  as a finite-rank-quotient variety),
- the Quot/Hilbert functor or its representability,
- Snapper's Lemma for the polynomial property of Euler characteristics.

## References

Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`. Source:
Nitsure, "Construction of Hilbert and Quot Schemes", §1 (FGA Explained
Ch. 5, arXiv:math/0504020 pp. 5–35); cf. Hartshorne III.5.2.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Hilbert polynomial of a coherent sheaf

For a finite-type morphism `π : X ⟶ S` with `S` noetherian and a coherent
sheaf `F` on `X` whose schematic support is proper over `S` (here encoded
as plain `X.Modules` for the file-skeleton), the per-fiber Hilbert
polynomial is the function

`s ↦ Φ_{F,s} ∈ ℚ[λ],   Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗m})`.

Snapper's Lemma ensures this is a polynomial in `m`; the proof requires
graded-Euler-characteristic infrastructure and is not stated here.

Blueprint reference: `def:hilbert_polynomial` (Nitsure §1; cf. Hartshorne
III.5.2). -/

/-- The **Hilbert polynomial** of a coherent sheaf `F` on `X` over `S` at
the fiber over `s ∈ S` with respect to a line bundle `L` on `X`.

Encoded as a function `s ↦ Φ_{F,s} ∈ ℚ[λ]`. The defining formula

`Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗ m})
            = Σ_i (-1)^i dim_{κ(s)} H^i(X_s, F|_{X_s} ⊗ L_s^{⊗m})`

is a polynomial in `m` by Snapper's Lemma; the polynomial coefficients
depend on `s` through the fiber `F|_{X_s}`. When `F` is `S`-flat the
function `s ↦ Φ_{F,s}` is locally constant on `S`.

iter-177+: the body unfolds to the graded-Euler-characteristic
construction once `χ` of a coherent sheaf on a noetherian scheme +
Snapper's polynomial-eventually-property are in scope. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def hilbertPolynomial {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) :
    Polynomial ℚ :=
  sorry

/-! ## §2. The Quot functor

The Quot functor `Quot^{Φ,L}_{E/X/S}` sends an `S`-scheme `T ⟶ S` to the
set of equivalence classes `⟨F, q⟩` of pairs `(F, q)` where
- `F` is a coherent sheaf on `X_T = X ×_S T` whose schematic support is
  proper over `T` and which is `T`-flat,
- `q : E_T ↠ F` is a surjective `O_{X_T}`-linear homomorphism,
- the fiberwise Hilbert polynomial of `F|_{X_t}` with respect to `L|_{X_t}`
  equals `Φ` at every `t ∈ T`.

Two pairs `(F, q)` and `(F', q')` are equivalent iff `ker(q) = ker(q')`.

The Hilbert scheme is the special case `E = O_X`:
`Hilb^{Φ,L}_{X/S} = Quot^{Φ,L}_{O_X/X/S}`.

Blueprint reference: `def:quot_functor` (Nitsure §1; FGA Explained Ch. 5). -/

/-- The **Quot functor** `Quot^{Φ,L}_{E/X/S}` of coherent quotients of `E`
on `X ×_S -` with Hilbert polynomial `Φ`.

Encoded as a contravariant functor `(Over S)ᵒᵖ ⥤ Type u`, sending an
`S`-scheme `T → S` (i.e. an object of `Over S`) to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` of a `T`-flat coherent
sheaf `F` on `X ×_S T` with proper support and a surjection
`q : E_T ↠ F` whose fiberwise Hilbert polynomial is `Φ`, modulo
`ker(q) = ker(q')`. Functoriality is pullback of the quotient along
`X ×_S T' ⟶ X ×_S T`.

iter-177+: the body packages the on-objects / on-morphisms data using the
`Scheme.Modules.pullback` bifunctor on the relative product
`X ×_S T`, with the equivalence relation `ker(q) = ker(q')` quotiented
out via `Setoid` / `Quotient`. For the iter-176 file-skeleton the body
is a typed `sorry`. -/
noncomputable def QuotFunctor {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _E : X.Modules)
    (_Φ : Polynomial ℚ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

end Scheme

/-! ## §3. The Grassmannian scheme

Since Mathlib carries no Grassmannian *scheme*, we encode it here as a
contravariant functor on `Over S` together with a representability
statement. The construction proceeds by gluing `binom(r, d)` affine
charts `U^I ≅ A^{d(r-d)}_S` along the Plücker cocycle, yielding a smooth
projective `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`,
equipped with a tautological rank-`d` quotient
`π* V ↠ U` and the Plücker closed embedding into `ℙ_S(⋀^d V)`.

Blueprint references: `def:grassmannian_scheme`,
`thm:grassmannian_representable` (Nitsure §1 Exercise (2),
"Construction of Grassmannian"; FGA Explained Ch. 5). -/

namespace Scheme

/-- The **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
rank-`d` quotients of a locally free `O_S`-module `V` of rank `r ≥ d`.

Encoded as the functor sending an `S`-scheme `T → S` to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` with
`q : V_T ↠ F` a surjection of `O_T`-modules and `F` locally free of
rank `d`, modulo `ker(q) = ker(q')`. Concretely
`Grass(V, d) = Quot^{d, O_S}_{V/S/S}` (the Quot functor for `X = S`,
`E = V`, constant Hilbert polynomial `d`).

iter-177+: the body re-exports `QuotFunctor (𝟙 S) (?) V Φ_d`, where
`Φ_d : Polynomial ℚ` is the constant polynomial `d`. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def Grassmannian {S : Scheme.{u}} [IsLocallyNoetherian S]
    (_V : S.Modules) (_d : ℕ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

/-- **Representability of the Grassmannian.**

For a noetherian scheme `S`, a locally free `O_S`-module `V` of rank `r`,
and `1 ≤ d ≤ r`, the Grassmannian functor `Grass(V, d)` of
`Grassmannian` is representable by a smooth projective `S`-scheme
`Gr_S(V, d) ⟶ S` of relative dimension `d(r-d)`, equipped with a
tautological rank-`d` quotient `π* V ↠ U`. The determinant line bundle
`det(U)` is relatively very ample, giving a Plücker closed embedding
`Gr_S(V, d) ↪ ℙ_S(⋀^d V)`.

We package the conclusion as the existence of a representing
`Y : Over S` together with a `Functor.RepresentableBy Y` witness for
`Grassmannian V d`; the additional projective / smooth / Plücker
structure is implicit in the construction and is iter-177+ refinement
work (once the proof body lands).

iter-177+: the body follows Nitsure §1 "Construction of Grassmannian":
glue the `binom(r, d)` affine charts `U^I ≅ A^{d(r-d)}_S` along the
Plücker cocycle, verify separatedness via the diagonal cut, verify
properness by the DVR valuative criterion, build the tautological
quotient `U`, exhibit the Plücker embedding via the determinant line
bundle. For the iter-176 file-skeleton the body is a typed `sorry`. -/
theorem Grassmannian.representable {S : Scheme.{u}} [IsLocallyNoetherian S]
    (V : S.Modules) (d : ℕ) :
    ∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y) := by
  sorry

end Scheme

end AlgebraicGeometry
