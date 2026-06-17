/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability
import AlgebraicJacobian.Genus

/-!
# The identity component of the Picard scheme (A.3)

This file is the **A.3** sub-build chapter for the project's positive-genus arm
of `nonempty_jacobianWitness`. It scaffolds the abstract identity-component
substrate for a `k`-group scheme locally of finite type and specialises it to
`G = Pic_{C/k}`, packaging:

1. the open-and-closed subgroup-scheme structure of the identity component,
2. the degree map `Pic_{C/k}(k) → ℤ`,
3. the abelian-variety identification of `Pic⁰_{C/k}` (the Jacobian variety
   of `C` when `C/k` is a smooth proper geometrically integral curve of
   positive genus).

## Status (iter-185 NEW file-skeleton)

This file is the **iter-185 IdentityComponent** file-skeleton (NEW lane,
blueprint-reviewer HARD GATE cleared for the iter-184 plan-phase chapter
`Picard_IdentityComponent.tex`). Each of the five blueprint-pinned
declarations carries the *intended* substantive type signature (matching the
`\lean{...}` pin in `Picard_IdentityComponent.tex`) with a `sorry` body. The
bodies are iter-186+ work; iter-185's mandate is the mechanical scaffold only.

The 5 pinned declarations are:

1. `AlgebraicGeometry.GroupScheme.IdentityComponent` (def, ~5 LOC) — the
   **identity component** `G^0` of a `k`-group scheme `G` locally of finite
   type, as a `k`-scheme (an `Over (Spec k)`-object). Abstract substrate
   reusable outside the Picard context; not yet in Mathlib.
2. `AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme`
   (theorem, ~10 LOC) — the bundled statement that `G^0` is an open and
   closed subscheme of `G` via an open immersion `G^0 ↪ G`.
3. `AlgebraicGeometry.Scheme.Pic0Scheme` (def, ~5 LOC) — the **identity
   component of the Picard scheme** `Pic⁰_{C/k}`, obtained by applying
   `IdentityComponent` to `G = PicScheme C`.
4. `AlgebraicGeometry.Scheme.PicScheme.degree` (def, ~5 LOC) — the **degree
   map** `Pic_{C/k}(k) → ℤ`, extracting the leading coefficient of the
   Hilbert polynomial of a representing invertible sheaf relative to a fixed
   degree-one polarisation `O_C(1)`.
5. `AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety` (theorem, ~10 LOC)
   — the **abelian-variety identification** of `Pic⁰_{C/k}`: smooth, proper,
   geometrically irreducible `k`-group scheme of dimension `g(C)` --- the
   Jacobian variety of `C`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
pinned declaration carries a substantive, non-tautological type:

- `IdentityComponent G : Over (Spec (.of k))` — a `k`-scheme, not the
  tautological `G` itself.
- `IdentityComponent.isOpenSubgroupScheme G` — asserts the *existence* of an
  open immersion morphism `IdentityComponent G ⟶ G` whose underlying map of
  schemes is both an open and a closed immersion (clopen subscheme).
- `Pic0Scheme C : Over (Spec (.of k))` — a `k`-scheme.
- `PicScheme.degree C : (Spec (.of k) ⟶ (PicScheme C).left) → ℤ` —
  a genuine function from `k`-points to `ℤ`, not a constant.
- `Pic0Scheme.isAbelianVariety C` — asserts the conjunction of the four
  abelian-variety properties (proper, smooth, geometrically irreducible,
  group-object structure); not vacuous because each conjunct is a genuine
  property/structure on the (typed-sorry) `Pic0Scheme C`.

## References

Blueprint: `blueprint/src/chapters/Picard_IdentityComponent.tex` (560 LOC,
5 pins). Sources:
- Kleiman, "The Picard scheme", §5, Lem.~`lem:agps` (identity component
  substrate) + Prp.~`prp:pic0` (specialisation to `Pic_{C/k}`) +
  Thm.~`th:qpp&p` (quasi-projectivity/projectivity) + Cor.~`cor:sm`
  (smoothness/dimension) + Ex.~`ex:jac` + Rmk.~`rmk:Jac`
  (arXiv:math/0504020 pp. 36, 38, 47, 50–51);
- Milne, "Abelian Varieties" (course notes, 2008), §III.1
  (def. of abelian variety, p. 8; dimension equals genus, Rmk. III.1.4(e),
  p. 86).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The identity component of a group scheme — abstract substrate

The identity component is an abstract feature of `k`-group schemes locally of
finite type. We package the definition + open-and-closed-subgroup-scheme
structure in the `GroupScheme` namespace so they are reusable outside the
Picard context.

In this project, a "`k`-group scheme" is encoded as an
`Over (Spec (.of k))`-object `G` carrying a `[GrpObj G]` instance (the
group-object structure in the over-category). The locally-of-finite-type
hypothesis is the `[LocallyOfFiniteType G.hom]` instance on the structural
morphism to the base.

Blueprint references: `def:identity_component_group_scheme` +
`thm:identity_component_open_subgroup` (Kleiman §5 Lem.~`lem:agps`). -/

namespace GroupScheme

/-- The **identity component** `G^0` of a `k`-group scheme `G` locally of
finite type.

Encoded as a `k`-scheme: an object of `Over (Spec (.of k))`, carrying the
intended substantive identity "this is the connected component of `|G|`
containing the identity section `e`, equipped with the open-subscheme
structure inherited from `G`". The associated open immersion
`IdentityComponent G ⟶ G` is the content of
`IdentityComponent.isOpenSubgroupScheme`.

iter-186+: the body constructs the identity component as the open subscheme
of `G` whose underlying topological space is the connected component of `|G|`
at the image of the identity section. The construction uses
`ConnectedComponents.mk` on the underlying topological space, then the
open-subscheme structure (EGA I 6.1.9: locally Noetherian spaces have open
connected components). For the iter-185 file-skeleton the body is a typed
`sorry`. -/
noncomputable def IdentityComponent {k : Type u} [Field k]
    (_G : Over (Spec (.of k)))
    [GrpObj _G] [LocallyOfFiniteType _G.hom] :
    Over (Spec (.of k)) :=
  sorry

/-- **The identity component is an open and closed subgroup scheme.**

The bundled statement of Kleiman §5 Lem.~`lem:agps`~(3): the identity
component `G^0 = IdentityComponent G` of a `k`-group scheme `G` locally of
finite type comes with a morphism `IdentityComponent G ⟶ G` (in
`Over (Spec (.of k))`) whose underlying scheme morphism is both an open
immersion and a closed immersion (i.e. the inclusion of a clopen
subscheme).

The full Kleiman conclusion also packages the group-subscheme property (the
inclusion is a homomorphism of `k`-group schemes), finite-type-ness over `k`
(`LocallyOfFiniteType` + quasi-compactness), geometric irreducibility, and
base-change-commutation. Those refinements live as separate instances /
follow-up lemmas in iter-186+; the file-skeleton pins only the clopen
open-immersion conclusion as a Nonempty-witness.

iter-186+: the body constructs the inclusion morphism via the open-subscheme
structure of `IdentityComponent G`, applies EGA I 6.1.9 (locally Noetherian
⟹ open connected components) for the open-immersion conclusion, and applies
the "closure of a connected subspace is connected" elementary argument for
the closed-immersion conclusion. For the iter-185 file-skeleton the body is
a typed `sorry`. -/
theorem IdentityComponent.isOpenSubgroupScheme {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    Nonempty {f : IdentityComponent G ⟶ G //
        IsOpenImmersion f.left ∧ IsClosedImmersion f.left} :=
  sorry

end GroupScheme

/-! ## §2. The identity component of the Picard scheme

We specialise the abstract identity-component substrate to
`G = PicScheme C`, the Picard scheme of a smooth proper geometrically
integral curve `C/k` (from sibling `Picard/FGAPicRepresentability.lean`).

Blueprint reference: `def:pic_zero_subscheme` (Kleiman §5 opening + Prp.
`prp:pic0`). -/

namespace Scheme

/-- The **identity component of the Picard scheme** `Pic⁰_{C/k}`.

Defined as the identity component
`GroupScheme.IdentityComponent (PicScheme C)` of the Picard scheme
`Pic_{C/k}` (from sibling `Picard/FGAPicRepresentability.lean`,
`AlgebraicGeometry.Scheme.PicScheme`). By
`GroupScheme.IdentityComponent.isOpenSubgroupScheme`, `Pic⁰_{C/k}` is an
open and closed subgroup scheme of `Pic_{C/k}` of finite type over `k`,
geometrically irreducible, and its formation commutes with extension of the
base field.

iter-186+: the body unwinds to `GroupScheme.IdentityComponent (PicScheme C)`
once the `[LocallyOfFiniteType (PicScheme C).hom]` instance lands on
`PicScheme C` (it follows from the Kleiman §4 structure: `Pic_{C/k}` is
locally of finite type as the disjoint union of open quasi-projective
`k`-subschemes). For the iter-185 file-skeleton the body is a typed `sorry`. -/
noncomputable def Pic0Scheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    Over (Spec (.of k)) :=
  sorry

/-! ## §3. The degree map

The disjoint-union structure of `Pic_{C/k}` (a disjoint union of open
quasi-projective `k`-subschemes, indexed by Hilbert polynomial via
`PicScheme.smoothProperQuotient`) stratifies its `T`-points by the leading
coefficient of the Hilbert polynomial of a representing invertible sheaf
relative to a fixed degree-one polarisation. On `k`-points this gives the
**degree map** `Pic_{C/k}(k) → ℤ`.

Blueprint reference: `def:divisor_degree_pic` (Milne III.1, p.~88). -/

namespace PicScheme

/-- The **degree map** `Pic_{C/k}(k) → ℤ`.

Sends a `k`-point `λ ∈ Pic_{C/k}(k)` --- a morphism
`Spec k ⟶ (PicScheme C).left` --- to the leading coefficient of the
Hilbert polynomial of a representing invertible sheaf `L` on `C` (relative
to a fixed degree-one polarisation `O_C(1)`). By Riemann--Roch,
`χ(C, L ⊗ O_C(n)) = n · deg L + 1 - g`, so the degree is the leading
coefficient of `Φ_L(n)`, well-defined on the isomorphism class `[L]` and on
the `k`-point `λ` (because `PicScheme C` represents the étale-sheafified
relative Picard functor).

The degree map is a group homomorphism for the additive structure on
`Pic_{C/k}(k)` (tensor product on `L`) and the standard `(ℤ, +)`. The full
group-homomorphism refinement / functoriality in `k` lives as a follow-up
lemma in iter-186+; the file-skeleton pins only the underlying function.

iter-186+: the body extracts the representing invertible sheaf from
`(PicScheme.representable C)`, forms its Hilbert polynomial via the project's
Hilbert-polynomial machinery (sibling `Picard/QuotScheme.lean`), and returns
the leading coefficient. For the iter-185 file-skeleton the body is a typed
`sorry`. -/
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  sorry

end PicScheme

/-! ## §4. `Pic⁰_{C/k}` is an abelian variety

The terminal statement of the chapter identifies `Pic⁰_{C/k}` with an
abelian variety of dimension `g(C)` --- the Jacobian variety of `C`. In
this project, "abelian variety" is the conjunction of the four properties
`[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`
threaded through `AlgebraicJacobian.AbelianVarietyRigidity` and consumed by
`AlgebraicJacobian.Albanese.AlbaneseUP`.

Blueprint reference: `thm:pic_zero_is_abelian_variety` (Kleiman §5
Ex.~`ex:jac` + Rmk.~`rmk:Jac`; cf. Milne §I.1, Rmk. III.1.4(e)). -/

namespace Pic0Scheme

/-- **`Pic⁰_{C/k}` is an abelian variety.**

For `C/k` a smooth proper geometrically integral curve of genus `g = g(C)`
over a field `k`, the identity component `Pic⁰_{C/k}` of the Picard scheme
is an *abelian variety over* `k`: a smooth, proper, geometrically
irreducible `k`-group scheme. (Commutativity follows automatically from
Milne §I.1, Cor. 1.4, and is not separately stated here.)

The bundled statement: the four pieces `[IsProper] ∧ [Smooth] ∧
[GeometricallyIrreducible] ∧ Nonempty (GrpObj _)` hold on
`(Pic0Scheme C).hom` and `(Pic0Scheme C)` respectively.

Dimension `g = g(C)`: not stated separately at the file-skeleton level
(it requires `dim_k (Pic0Scheme C).left = AlgebraicGeometry.genus C`, which
involves the Krull-dimension API on the underlying scheme); iter-186+
follow-up.

iter-186+: the body assembles the four conjuncts from
- `GroupScheme.IdentityComponent.isOpenSubgroupScheme` (clopen subscheme of
  `PicScheme C`),
- Kleiman §5 Thm.~`th:qpp&p` (`X/k` projective + geom. integral ⟹
  `Pic⁰_{X/k}` quasi-projective; upgrade to projective when geom. normal,
  which holds for smooth proper curves of positive genus),
- Kleiman §5 Cor.~`cor:sm` + Ex.~`ex:jac` (smoothness of `Pic_{X/k}` at the
  identity for smooth proper curves; hence smooth of dimension
  `dim_k H¹(C, O_C) = g(C)` everywhere by uniform smoothness on the open
  identity component).
For the iter-185 file-skeleton the body is a typed `sorry`. -/
theorem isAbelianVariety {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  sorry

end Pic0Scheme

end Scheme

end AlgebraicGeometry
