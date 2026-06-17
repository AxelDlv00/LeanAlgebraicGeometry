/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Albanese.CodimOneExtension

/-!
# Milne Theorem 3.2: a rational map from a nonsingular variety to an abelian
variety extends (A.4.c)

This file is the **A.4.c** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the single
theorem of Milne's *Abelian Varieties* §I.3, Theorem 3.2:
**a rational map from a nonsingular variety to an abelian variety extends,
uniquely, to a regular morphism**. This is the input that the Albanese
universal-property build (A.4.d, `Albanese/AlbaneseUP.lean`) consumes when
promoting the symmetric-product rational map
`C^{(g)} ⇢ A` to a regular morphism `J → A`.

Milne's proof is two lines: combine Theorem 3.1 (the codim-$\geq 2$ extension
result for rational maps from a normal variety to a complete variety —
project-side `thm:codim_one_extension` of
`Albanese/CodimOneExtension.lean`, A.4.a) with Lemma 3.3 (the
pure-codim-$1$ indeterminacy structure for rational maps into a group variety
— project-side `lem:milne_codim1_indeterminacy` of the same chapter). The
combination forces the indeterminacy locus of `f` to be simultaneously of
codimension `≥ 2` and pure codimension `1`, hence empty, so `f` is everywhere
defined.

## Status (iter-175 Lane J file-skeleton)

This file is the **iter-175 Lane J** file-skeleton: the single pinned
declaration carries the intended substantive type signature (matching the
blueprint `\lean{...}` pin in
`chapters/Albanese_Thm32RationalMapExtension.tex` line 50) with a `sorry`
body. The body is iter-176+ work, gated on the sibling chapters
`Albanese/CodimOneExtension.lean` (A.4.a) and
`Albanese/AuslanderBuchsbaum.lean` (A.4.b) landing their substantive
statements.

The 1 pinned declaration is:

1. `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` (theorem, ~10 LOC)
   — Milne Theorem 3.2: for `X` a smooth (= nonsingular) variety over an
   algebraically closed field `k̄`, `A` an abelian variety over `k̄`, and
   `f : X ⇢ A` a rational map, there exists a *unique* regular morphism
   `g : X ⟶ A` whose induced rational map equals `f`.

## Note on type expressivity

The signature is encoded against Mathlib's existing
`AlgebraicGeometry.Scheme.RationalMap` (a partial-map equivalence class on
dense opens) and `Scheme.Hom.toRationalMap` (the canonical "regular morphism
yields a rational map" coercion). The substantive claim is the existence
and uniqueness of a `g : X.left ⟶ A.left` with `g.toRationalMap = f`. The
type is non-tautological: the existence is the content of Milne 3.2;
uniqueness is the standard reduced-and-separated agreement principle
(`AlgebraicGeometry.ext_of_isDominant`).

## Abelian-variety conventions

Throughout the project (cf. `AbelianVarietyRigidity.lean`, `Jacobian.lean`),
an **abelian variety over `k̄`** is encoded as an object
`A : Over (Spec (.of k̄))` carrying the four instances:

- `[GrpObj A]` (group-object structure on the over-category),
- `[IsProper A.hom]` (complete),
- `[Smooth A.hom]` (nonsingular),
- `[GeometricallyIrreducible A.hom]` (geometrically irreducible).

A **nonsingular variety over `k̄`** (in the convention of
`blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` §1) is an
object `X : Over (Spec (.of k̄))` carrying:

- `[Smooth X.hom]`,
- `[GeometricallyIrreducible X.hom]`,
- `[IsSeparated X.hom]`,
- `[LocallyOfFiniteType X.hom]`,
- `[IsIntegral X.left]`,
- `[IsReduced X.left]`.

These four-plus-two instances will normally be supplied by `inferInstance` at
the call site.

## References

Blueprint: `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
(250 LOC, 1 pin). Source: Milne, *Abelian Varieties*, §I.3, Theorem 3.2,
p. 17 (`references/abelian-varieties.pdf`, PDF page 23).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace RationalMap

/-! ## Milne Theorem 3.2 — rational maps to an abelian variety extend

Let `k̄` be an algebraically closed field. Let `X` be a nonsingular variety
over `k̄` (smooth, geometrically irreducible, separated, locally of finite
type, integral, reduced). Let `A` be an abelian variety over `k̄`
(a group object that is proper, smooth, and geometrically irreducible). For
every rational map `f : X ⇢ A` there is a *unique* regular morphism
`g : X ⟶ A` whose induced rational map equals `f`.

Milne's argument (`Albanese_Thm32RationalMapExtension.tex` §1.4, Theorem 3.2):
let `U ⊆ X` be a maximal open of definition of `f` and `Z := X ∖ U`.
By the codim-$\geq 2$ extension theorem (Theorem 3.1, project-side
`thm:codim_one_extension`) the closed subset `Z` has codimension `≥ 2`.
By the pure-codim-$1$ indeterminacy lemma for maps into a group variety
(Lemma 3.3, project-side `lem:milne_codim1_indeterminacy`), `Z` is either
empty or of pure codimension `1`. Both conditions force `Z = ∅`, so `U = X`
and `f` admits a regular representative on all of `X`. Uniqueness is the
standard reduced-and-separated agreement principle (cf.
`AlgebraicGeometry.ext_of_isDominant`): two regular morphisms `X ⟶ A` that
agree on a dense open of `X` agree everywhere.

Blueprint reference: `thm:rational_map_to_av_extends` (Milne, *Abelian
Varieties*, Theorem 3.2, §I.3, p. 17). The pin in the chapter is at
`Albanese_Thm32RationalMapExtension.tex` line 50.

iter-176+ proof skeleton:
1. Pick a `PartialMap` representative `φ : X.PartialMap A` of `f` (using
   `Scheme.RationalMap.toPartialMap`, which exists for `X` reduced and `A`
   separated; both hold from the abelian-variety + variety instances).
2. Show `φ.domain = ⊤` by combining `thm:codim_one_extension` (codim `≥ 2`
   complement) with `lem:milne_codim1_indeterminacy` (complement empty or
   pure codim `1`).
3. Read off `g := φ.hom` (the morphism on the full domain) and verify
   `g.toRationalMap = f`.
4. Uniqueness: two `g₁, g₂ : X ⟶ A` with `g₁.toRationalMap = g₂.toRationalMap`
   agree on a dense open of `X`, so by
   `AlgebraicGeometry.ext_of_isDominant` and reducedness of `X` they agree
   everywhere. -/

/-- **Milne Theorem 3.2 — a rational map from a nonsingular variety to an
abelian variety extends, uniquely, to a regular morphism.**

For `X` a nonsingular variety over an algebraically closed field `k̄`, and
`A` an abelian variety over `k̄`, every rational map `f : X ⇢ A` has a
*unique* regular extension `g : X ⟶ A` (i.e. `g.toRationalMap = f`).

This is the input the Albanese universal-property build
(`Albanese/AlbaneseUP.lean`, A.4.d) consumes when promoting the
symmetric-product rational map `C^{(g)} ⇢ A` to a regular morphism
`J → A`.

iter-176+: body combines `thm:codim_one_extension` (A.4.a; codim-$\geq 2$
extension to a normal variety target — here the abelian variety, which is
complete) with `lem:milne_codim1_indeterminacy` (A.4.a; pure-codim-$1$
indeterminacy for maps into a group variety). The two combine to force the
indeterminacy locus empty; uniqueness is the standard agreement principle
for reduced `X` and separated `A`. -/
theorem extend_to_av
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom]
    (f : X.left.RationalMap A.left) :
    ∃! (g : X.left ⟶ A.left), g.toRationalMap = f := by
  sorry

end RationalMap

end Scheme

end AlgebraicGeometry
