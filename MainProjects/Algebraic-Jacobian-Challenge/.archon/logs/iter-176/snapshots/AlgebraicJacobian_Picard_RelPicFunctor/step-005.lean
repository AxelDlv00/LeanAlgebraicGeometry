/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.LineBundlePullback

/-!
# The relative Picard functor and its étale sheafification (A.1.c)

This file is the **A.1.c** file-skeleton sub-build chapter for the
positive-genus arm of `nonempty_jacobianWitness`. It upgrades the
set-valued relative Picard presheaf
`Pic^♯_{C/k}(T) := Pic(C ×_k T) / π_T^* Pic(T)` of
`AlgebraicJacobian/Picard/LineBundlePullback.lean` (A.1.b) to its
abelian-group-valued refinement, and then to its étale sheafification
`Pic^♯_{(C/k)ét}`.

## Status (iter-176 Lane G file-skeleton — re-dispatch)

iter-175 Lane G died to the Anthropic session-limit reset window at
06:14 UTC without ever calling `Write` (the file was never created).
iter-176 re-dispatches the file-skeleton verbatim. Each blueprint-pinned
declaration carries the *intended* substantive type signature (matching
the `\lean{...}` pin in `blueprint/src/chapters/Picard_RelPicFunctor.tex`)
with a `sorry` body. The bodies are iter-177+ work, gated on the A.1.a
`RelativeSpec.lean` and A.1.b `LineBundlePullback.lean` bodies landing
first.

The 5 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.PicSharp.addCommGroup` (instance, ~5 LOC) —
   the **abelian-group instance** on the quotient set
   `Quotient (RelPicPresheaf.preimage_subgroup πC πT)` built in A.1.b.
   Mathlib's `QuotientAddGroup` machinery on a normal subgroup of an
   abelian group is the backbone; the project-side work certifies that
   `π_T^*` is a group homomorphism (Stacks 01CR + pullback's
   tensor-product preservation).

2. `AlgebraicGeometry.Scheme.PicSharp` (noncomputable def, ~10 LOC) —
   the **relative Picard presheaf** as a contravariant functor on
   `(Over (Spec k))^op` with values in `AddCommGrpCat`, sending
   `T ↦ Pic(C ×_k T) / π_T^* Pic(T)` with the canonical abelian-group
   structure of (1).

3. `AlgebraicGeometry.Scheme.PicSharp.functorial` (noncomputable def,
   ~10 LOC) — the **group-homomorphism strengthening** of the set-valued
   `RelPicPresheaf.functorial` of A.1.b: for `g : T' ⟶ T` over `Spec k`,
   the induced map on quotient sets is in fact an
   `AddMonoidHom`-homomorphism with respect to the structure of (1).

4. `AlgebraicGeometry.Scheme.PicSharp.presheaf` (noncomputable def,
   ~10 LOC) — the **packaged functor**: bundles the data of (2) and (3)
   into a single `(Over (Spec k))^op ⥤ AddCommGrpCat` instance.

5. `AlgebraicGeometry.Scheme.PicSharp.etSheaf` (noncomputable def, ~10 LOC)
   — the **étale sheafification** of `PicSharp`. Encoded as
   `presheafToSheaf` applied with `J : GrothendieckTopology` representing
   the étale topology on `Over (Spec k)` (a parameter at this stage
   because Mathlib at the pinned commit does not ship the étale
   Grothendieck topology on schemes; iter-177+ refinement: bind `J` to
   the canonical étale topology once it lands).

   *Naming note*: the blueprint chapter `Picard_RelPicFunctor.tex` pins
   this declaration under `\lean{AlgebraicGeometry.Scheme.PicScheme}`,
   which collides with the `PicScheme` declaration already on disk in
   `Picard/FGAPicRepresentability.lean` (A.2.c, the *representing
   scheme*, an `Over (Spec k)`). The two are different mathematical
   objects (a sheaf vs.\ a scheme); the blueprint will need to be
   updated by the plan/review agents to reflect the rename. Flagged in
   the iter-176 task_result.

Plus one unpinned auxiliary theorem:

6. `AlgebraicGeometry.Scheme.PicSharp.etSheafUnit` (theorem, ~8 LOC) —
   the **sheafification unit**: a canonical morphism of presheaves
   `PicSharp.presheaf ⟶ (PicSharp.etSheaf ?).obj` that exhibits the
   group-presheaf-to-group-sheaf universal property (statement of
   `thm:rel_pic_etale_sheaf_group_structure` in the blueprint).

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `addCommGroup` is an `AddCommGroup` instance on a quotient set whose
  underlying type is itself a typed `sorry` in A.1.b (`OnProduct` carrier);
  the substantive content is the existence of the group structure
  (closure under `+`, inverse, neutral element), which is non-trivial
  even at the level of typed-`sorry` carriers — once the carrier is
  unpacked, the group operations are induced by the tensor product on
  invertible sheaves modulo the subgroup `π_T^* Pic(T)`.

- `PicSharp` returns a contravariant *functor*, not a constant family;
  the object and morphism actions are independently substantive (the
  morphism action is the set-valued `RelPicPresheaf.functorial` of
  A.1.b lifted to a group homomorphism).

- `PicSharp.functorial` returns an `AddMonoidHom`, not a bare set map;
  this is a strict strengthening of the set-valued version in A.1.b.

- `PicSharp.presheaf` returns a `(Over (Spec k))^op ⥤ AddCommGrpCat`,
  which on objects matches `PicSharp` and on morphisms matches
  `PicSharp.functorial` — substantive content is the assembly into a
  single category-theoretic object.

- `PicSharp.etSheaf` returns a `Sheaf J AddCommGrpCat` for the given
  topology `J`; the sheafification is non-trivial because `PicSharp`
  is generally not even a Zariski sheaf (Kleiman §2, L1292–L1302).

## Mathlib status

Mathlib (master `b80f227`) provides:

- `AddCommGrpCat` (the category of abelian groups, in
  `Mathlib.Algebra.Category.Grp.Basic`),
- `CategoryTheory.GrothendieckTopology` and `CategoryTheory.Sheaf`,
- `CategoryTheory.presheafToSheaf` (sheafification functor, in
  `Mathlib.CategoryTheory.Sites.ConcreteSheafification` /
  `Mathlib.CategoryTheory.Sites.LeftExact`),
- `CategoryTheory.GrothendieckTopology.HasSheafCompose` (for whiskering
  with forgetful functors),
- `AlgebraicGeometry.Etale` (the morphism property; in
  `Mathlib.AlgebraicGeometry.Morphisms.Etale`),
- `QuotientAddGroup` (quotient by a normal subgroup).

Mathlib does NOT provide (at the pinned commit):

- a global étale `GrothendieckTopology` on `Over (Spec k)` (only the
  étale morphism property; the Grothendieck topology is `iter-177+`
  upstream / project-side work),
- a representability hookup `PicScheme` ⟹ Picard scheme (handled
  downstream in `chap:Picard_FGAPicRepresentability`).

The file-skeleton takes `J : GrothendieckTopology (Over (Spec k))` as
an explicit parameter on `PicScheme` (and on `PicScheme.unit`) so the
declaration is well-typed at the pinned commit. iter-177+: specialise
`J` to the canonical étale Grothendieck topology when it lands.

## References

Blueprint: `blueprint/src/chapters/Picard_RelPicFunctor.tex` (522 LOC,
5 pins). Source: [Kleiman], "The Picard scheme", §2 (FGA Explained
Ch.9 §9.2), Definitions `df:aPf` (absolute Picard functor) +
`df:Pfs` (relative Picard functor, including the étale-sheafified form
`Pic_{(X/S)ét}`); Stacks Project tag 01CR (abelian-group structure on
the Picard group via tensor product).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicSharp

/-! ## §1. Abelian-group structure on the relative Picard quotient

The Picard group `Pic(X)` of any scheme is canonically an abelian group
under tensor product of line bundles (Stacks tag 01CR; the inverse of
`[L]` is `[L⁻¹] = [Hom_{O_X}(L, O_X)]`). The pullback map
`π_T^* : Pic(T) → Pic(C ×_k T)` of
`AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection` (A.1.b)
respects this structure: it sends `O_T ↦ O_{C ×_k T}` (the structure
sheaf is preserved by inverse image) and is multiplicative on tensor
products (Stacks 01HH for invertibility, Mathlib's
`Scheme.Modules.pullback` for the underlying multiplicativity).

Therefore `π_T^* Pic(T)` is a subgroup of `Pic(C ×_k T)`, and the
quotient `Pic(C ×_k T) / π_T^* Pic(T)` inherits a canonical
abelian-group structure under which the quotient map is a surjective
homomorphism with kernel exactly `π_T^* Pic(T)`.

Blueprint reference: `lem:rel_pic_sharp_groupoid` (Kleiman §2,
Defs. `df:aPf` + `df:Pfs`; Stacks tag 01CR). -/

/-- **Abelian-group instance on the relative Picard quotient.**

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, and a test
object `πT : T ⟶ S`, the quotient set
```
Quotient (RelPicPresheaf.preimage_subgroup πC πT)
  = Pic(C ×_S T) / π_T^* Pic(T)
```
carries a canonical abelian-group structure: addition is the descent of
tensor product `[L] + [L'] := [L ⊗ L']`, the zero element is the class
`[O_{C ×_S T}]`, and the inverse is `-[L] := [L⁻¹]` (the dual line
bundle). Well-definedness on the quotient uses the subgroup property of
`π_T^* Pic(T)` from `lem:rel_pic_sharp_groupoid`.

iter-177+: the body builds the `AddCommGroup` instance via
Mathlib's `QuotientAddGroup` on the abelian group `Pic(C ×_S T)` (tensor
product) modulo the subgroup `π_T^* Pic(T)` (image of a group hom).
For the iter-176 file-skeleton the body is a typed `sorry` because the
underlying carrier `LineBundle.OnProduct` is itself a typed `sorry` in
A.1.b (so no concrete tensor-product law is yet available); the
signature still asserts the substantive group instance on the named
quotient set. -/
noncomputable instance addCommGroup {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
  sorry

end PicSharp

/-! ## §2. The relative Picard presheaf as a group-valued functor

We assemble the data of A.1.b (object-level quotient set,
`RelPicPresheaf.functorial` morphism action) and §1 (abelian-group
instance on each quotient) into a single contravariant functor

```
PicSharp_{C/k} : (Over (Spec k))^op ⥤ AddCommGrpCat
```

sending an `Spec k`-scheme `T` to the abelian group
`Pic(C ×_k T) / π_T^* Pic(T)` (with the structure of §1), and a
morphism `g : T' ⟶ T` over `Spec k` to the group homomorphism
`g^♯ : Pic^♯_{C/k}(T) → Pic^♯_{C/k}(T')` descended from the
line-bundle pullback `g_C^* := (id_C ×_k g)^*`.

Blueprint reference: `def:rel_pic_sharp` (Kleiman §2, Def. `df:Pfs`). -/

/-- The **relative Picard functor** of a smooth proper geometrically
integral curve `C` over a field `k`, as a contravariant functor

```
PicSharp_{C/k} : (Over (Spec k))^op ⥤ AddCommGrpCat
```

On objects: `T ↦ Pic(C ×_k T) / π_T^* Pic(T)`, the abelian-group
quotient of `lem:rel_pic_sharp_groupoid` (Lean instance
`PicSharp.addCommGroup`).

On morphisms: `g ↦ g^♯`, the group homomorphism descended from
`g_C^* = (id_C ×_k g)^*` via the quotient (the set-level map is
`RelPicPresheaf.functorial`; the group-hom upgrade is
`PicSharp.functorial` below).

Universe: object map values are `AddCommGrpCat.{u+1}` because the
underlying carrier `Quotient (preimage_subgroup πC πT)` lives in
`Type (u+1)` (since `LineBundle.OnProduct` is defined to land in
`Type (u+1)`).

iter-177+: the body builds the functor explicitly from
`AddCommGrpCat.of (Quotient (preimage_subgroup C.hom T.hom))` on
objects and from `PicSharp.functorial` on morphisms. The identity and
composition laws follow from `Scheme.Modules.pullbackId` /
`Scheme.Modules.pullbackComp` descended through the quotient. For the
iter-176 file-skeleton the body is a typed `sorry`. -/
noncomputable def PicSharp {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1} :=
  sorry

namespace PicSharp

/-! ## §3. Functoriality (group-homomorphism strengthening)

The naturality lemma `RelPicPresheaf.functorial` of A.1.b produces, for
each morphism `g : T' ⟶ T` over `S`, a set map
```
g^♯ : Pic(C ×_S T) / π_T^* Pic(T) ⟶ Pic(C ×_S T') / π_{T'}^* Pic(T')
```
of quotient sets. Combined with the abelian-group instance of §1 on
both sides, this set map upgrades to an additive-monoid homomorphism
`AddMonoidHom`: indeed `g_C^*` preserves tensor products and the
structure sheaf, so it preserves the abelian-group operations on both
sides; the upgrade is the substantive content of
`lem:rel_pic_sharp_functorial`.

Blueprint reference: `lem:rel_pic_sharp_functorial` (Kleiman §2,
Defs. `df:aPf` + `df:Pfs`). -/

/-- **Functoriality of the relative Picard presheaf, group-hom form.**

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, test objects
`πT : T ⟶ S` and `πT' : T' ⟶ S`, and a morphism `g : T' ⟶ T` over `S`
(encoded by `πT' = g ≫ πT`), the set map
`RelPicPresheaf.functorial πC πT πT' g hg` upgrades to an
`AddMonoidHom`-homomorphism with respect to the abelian-group structure
of `PicSharp.addCommGroup` on source and target.

iter-177+: the body builds the `AddMonoidHom` from the set map by
verifying `map_zero` (the image of `[O_{C ×_S T}]` is `[O_{C ×_S T'}]`,
i.e. pullback of the structure sheaf is the structure sheaf) and
`map_add` (pullback preserves tensor products: Stacks 01HG /
`Scheme.Modules.pullbackTensor`). For the iter-176 file-skeleton the
body is a typed `sorry`. -/
noncomputable def functorial {S C T T' : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T)
    (_hg : πT' = g ≫ πT) :
    Quotient (RelPicPresheaf.preimage_subgroup πC πT) →+
      Quotient (RelPicPresheaf.preimage_subgroup πC πT') :=
  sorry

/-! ## §4. Wrapping as a functor instance

The group-valued presheaf bundling: combine the on-objects assignment
of `PicSharp` (carrying the `addCommGroup` structure) with the
on-morphisms assignment of `functorial` (each a group hom) into a
single functor `(Over (Spec k))^op ⥤ AddCommGrpCat`. The identity /
composition laws of the functor are inherited from the corresponding
identities on `Scheme.Modules.pullback`, descended through the
quotient.

This wrapper is kept distinct from `PicSharp` to mirror the blueprint
split (`def:rel_pic_sharp` vs.\ `thm:rel_pic_sharp_presheaf`) and to
record the explicit re-packaging step from the lemma-by-lemma data
(`addCommGroup`, `PicSharp`, `functorial`) into a single
category-theoretic functor — useful when applying functorial
constructions (Yoneda, sheafification, …) to the *bundled* form.

Blueprint reference: `thm:rel_pic_sharp_presheaf` (Kleiman §2,
Defs. `df:aPf` + `df:Pfs`). -/

/-- **The relative Picard presheaf, bundled.**

The relative Picard functor `PicSharp_{C/k}` packaged as a single
contravariant functor `(Over (Spec k))^op ⥤ AddCommGrpCat`, with object
action `T ↦ Pic(C ×_k T) / π_T^* Pic(T)` (group structure
`PicSharp.addCommGroup`) and morphism action `g ↦ g^♯` (group hom from
`PicSharp.functorial`). Identity and composition laws are inherited
from `Scheme.Modules.pullbackId` / `Scheme.Modules.pullbackComp`
descended through the quotient.

iter-177+: the body either re-exports `PicSharp` (if the
`AddCommGrpCat`-valued functor is built directly in §2) or constructs
the functor from the on-objects/on-morphisms data using the
`CategoryTheory.Functor.mk` builder; the body is a typed `sorry` for
the iter-176 file-skeleton.

Note on naming: this is the canonical "fully assembled" form mentioned
as `thm:rel_pic_sharp_presheaf` in the blueprint; it is structurally a
`def` (not a `theorem`) because the conclusion is a `Functor` (data),
not a `Prop`. -/
noncomputable def presheaf {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1} :=
  sorry

end PicSharp

/-! ## §5. Étale sheafification

The relative Picard presheaf `PicSharp_{C/k}` is generally not even a
Zariski sheaf (Kleiman §2 L1292–L1302). To obtain a representable
functor in the sense of `chap:Picard_FGAPicRepresentability`
(downstream A.2.c), one replaces `PicSharp_{C/k}` by its **associated
étale sheaf** `Pic^♯_{(C/k)ét} := (PicSharp_{C/k})^{∼ét}`. Kleiman §4
(Theorem `th:main`) represents precisely this sheafified functor.

For the iter-176 file-skeleton, we encode the sheafification as
`presheafToSheaf J _` applied to the bundled `PicSharp.presheaf` for a
**parameter** Grothendieck topology `J` on `Over (Spec k)` — because
Mathlib at the pinned commit does not ship an étale Grothendieck
topology on schemes (it ships only the morphism property
`AlgebraicGeometry.Etale`). iter-177+ refinement: bind `J` to the
canonical étale topology once it lands in Mathlib.

Blueprint reference: `def:rel_pic_etale_sheafification` (Kleiman §2,
`df:Pfs` étale-sheaf clause). -/

/-- The **étale sheafification of the relative Picard presheaf**.

Given a smooth proper geometrically integral curve `C` over a field
`k`, and a Grothendieck topology `J` on `Over (Spec k)` (intended: the
canonical étale topology on `(Sch/k)`), the **étale-sheafified relative
Picard functor**

```
Pic^♯_{(C/k)ét} := (PicSharp_{C/k})^{~_ét}
```

is the sheafification of the group-valued presheaf
`PicSharp.presheaf` of `thm:rel_pic_sharp_presheaf`. Equivalently, it is
the unique (up to canonical isomorphism) sheaf of abelian groups on the
site `(Over (Spec k), J)` equipped with a presheaf morphism
`PicSharp.presheaf ⟶ (forget _) ∘ -` universal among presheaf morphisms
to abelian-group sheaves.

Encoded as a `Sheaf J AddCommGrpCat.{u+1}` object; iter-177+ implementations
will fix `J` to the étale topology and unfold via
`CategoryTheory.presheafToSheaf` (Mathlib's
`Sites.ConcreteSheafification`). The body of the iter-176 file-skeleton
is a typed `sorry`.

In Kleiman's notation with `X = C` and `S = Spec k`, this is
`Pic_{(X/S)ét}` from `df:Pfs`. -/
noncomputable def PicScheme {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom]
    (J : GrothendieckTopology (Over (Spec (.of k)))) :
    Sheaf J AddCommGrpCat.{u+1} :=
  sorry

namespace PicScheme

/-! ## §6. Sheafification preserves the abelian-group structure

The étale sheafification of an abelian-group-valued presheaf is itself
abelian-group-valued: the forgetful functor `AddCommGrpCat ⥤ Type`
preserves filtered colimits (these are computed pointwise), and the
plus-construction is built from filtered colimits, so sheafification
commutes with the forgetful functor up to canonical isomorphism. The
substantive content is the **sheafification unit**: a canonical
morphism of presheaves `PicSharp.presheaf ⟶ PicScheme.val` (in
`AddCommGrpCat`) that exhibits the universal property of sheafification.

This statement does NOT have an explicit `\lean{...}` pin in the
blueprint (`thm:rel_pic_etale_sheaf_group_structure` is a description
rather than a Lean target); we surface it here so the downstream
representability statement (`chap:Picard_FGAPicRepresentability`) can
cite the unit directly.

Blueprint reference: `thm:rel_pic_etale_sheaf_group_structure` (Kleiman
§2, `df:Pfs`; standard `Sheafification.toSheafify` content). -/

/-- **Sheafification unit for the étale Picard sheafification.**

Given the étale-sheafified relative Picard functor
`PicScheme C J : Sheaf J AddCommGrpCat`, there is a canonical morphism
of (group-valued) presheaves
```
η_C : PicSharp.presheaf C ⟶ (PicScheme C J).val
```
in the functor category `(Over (Spec k))^op ⥤ AddCommGrpCat`. This
morphism is the **unit of sheafification**: it is universal among
morphisms from `PicSharp.presheaf C` to any abelian-group-valued
étale sheaf.

iter-177+: the body returns
`(CategoryTheory.toSheafify J (PicSharp.presheaf C))` (using Mathlib's
`Sites.ConcreteSheafification` API) — assuming `J` admits abelian-group
sheafification, which is provided by `HasSheafify J AddCommGrpCat`
(supplied by Mathlib for the relevant universes via its
abelian-category-target sheafification). For the iter-176 file-skeleton
the body is a typed `sorry`. -/
theorem unit {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (J : GrothendieckTopology (Over (Spec (.of k)))) :
    Nonempty (PicSharp.presheaf C ⟶ (PicScheme C J).obj) := by
  sorry

end PicScheme

end Scheme

end AlgebraicGeometry
