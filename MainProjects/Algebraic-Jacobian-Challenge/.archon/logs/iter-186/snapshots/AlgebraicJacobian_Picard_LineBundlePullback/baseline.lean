/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Line-bundle pullback on a relative curve (A.1.b)

This file is the **A.1.b** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the line-bundle
pullback functor `π_T^* : Pic(T) → Pic(C ×_S T)` along the projection
`π_T : C ×_S T → T` of a relative curve, and the set-valued relative Picard
presheaf

```
Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)
```

as a functor on `(Sch/S)^op`.

## Status (iter-174 Lane E file-skeleton)

This file is the **iter-174 Lane E** file-skeleton: each of the five pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/Picard_LineBundlePullback.tex`) with a
`sorry` body. The bodies are iter-175+ work after the sibling chapters
`Picard_RelativeSpec.lean` (A.1.a) settles its `QcohAlgebra` body, and after
`Picard_RelPicFunctor.lean` (A.1.c) lands the étale-sheafification overlay.

The 5 pinned declarations are:

1. `AlgebraicGeometry.Scheme.LineBundle.OnProduct` (def, ~5 LOC) — the type of
   line bundles on the product `C ×_S T`.
2. `AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection`
   (noncomputable def, ~6 LOC) — the pullback map `Pic(T) → Pic(C ×_S T)`.
3. `AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq` (theorem, ~10 LOC)
   — composition of pullbacks `g_C^* ∘ π_T^* = π_{T'}^* ∘ g^*` (Stacks 01HG).
4. `AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup` (def, ~8 LOC)
   — well-definedness of the quotient `Pic(C ×_S T) / π_T^* Pic(T)`, encoded as
   the substantive `Setoid` on `OnProduct πC πT` that defines the equivalence
   relation `L ~ L' ↔ L ⊗ (L')⁻¹ ∈ π_T^* Pic(T)`.
5. `AlgebraicGeometry.Scheme.RelPicPresheaf.functorial`
   (noncomputable def, ~10 LOC) — for `g : T' ⟶ T` over `S`, the induced map
   `Pic^♯_{C/S}(T) → Pic^♯_{C/S}(T')` factoring `g_C^*` through the quotient.

## Note on type expressivity

Because Mathlib `b80f227` ships no `Module.Invertible`/`IsInvertible` predicate
on `Scheme.Modules` (the closest is `Module.Invertible R M` for `R : CommRing`),
the type `OnProduct` packaging *line bundles* (= invertible sheaves of
`O`-modules) on the product cannot yet be carved out of `Scheme.Modules` as a
subtype. Following the project rule "Never weaken the type to dodge the proof"
we encode `OnProduct` by a typed `sorry` at the type level: the iter-175+ body
will instantiate it as a structure pairing a `(pullback πC πT).Modules` carrier
with an `IsInvertible` witness once that predicate is in Mathlib (or proven
internally as the project-side definition).

The 4 pinned theorems/defs reference `OnProduct` as a typed-`sorry` carrier;
their signatures are still substantive (each declares a non-tautological claim:
a map between line-bundle types, a transitivity-of-pullback equality, an
equivalence relation on line bundles, an induced quotient map) and the bodies
collapse once `OnProduct` is unpacked.

## References

Blueprint: `blueprint/src/chapters/Picard_LineBundlePullback.tex` (444 LOC,
5 pins). Source: [Kleiman], "The Picard scheme", §2 (FGA Explained Ch.9 §9.2),
Definitions `df:aPf` (absolute Picard functor) and `df:Pfs` (relative Picard
functor). Stacks Project tags 01HG (pullback preserves invertibility),
01HH (functoriality of pullback), 01HK (invertible modules), 01CR
(Picard group of a scheme).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace LineBundle

/-! ## §1. Line bundles on a product

A *line bundle* on the relative curve `C ×_S T` is an invertible
`O_(C ×_S T)`-module, i.e. a sheaf of modules locally free of rank one. In
Mathlib `b80f227` the `Scheme.Modules` category is in place
(`Mathlib.AlgebraicGeometry.Modules.Sheaf`), but there is no `IsInvertible`
predicate on its objects yet (the closest is `Module.Invertible R M` for rings,
in `Mathlib.RingTheory.PicardGroup`). The iter-174 file-skeleton therefore
encodes the type of line bundles on the product by a typed `sorry` at the type
level; iter-175+ will instantiate it as a subtype of `(pullback πC πT).Modules`
cutting out invertibility.

Blueprint reference: `def:line_bundle_on_product` (Kleiman §2, "absolute Picard
functor"; Stacks tag 01HK). -/

/-- The type of **line bundles on the product** `C ×_S T`: invertible sheaves of
`O_(C ×_S T)`-modules, where the product is the categorical pullback of the
projections `πC : C ⟶ S` and `πT : T ⟶ S`. In Kleiman's notation with `X = C`
and base `S`, this is `Pic_C(T) = Pic(C ×_S T)`, the value of the absolute
Picard functor at `T`.

iter-175+: instantiate as a subtype of `(pullback πC πT).Modules` carrying an
invertibility witness — concretely either
```
structure OnProduct ... where
  sheaf : (pullback πC πT).Modules
  isInvertible : IsInvertible sheaf
```
or the quotient by isomorphism for the Picard *group* refinement. For the
iter-174 file-skeleton this is a typed `sorry` at the type level because
Mathlib `b80f227` ships no `IsInvertible` predicate on `Scheme.Modules`. -/
noncomputable def OnProduct {S C T : Scheme.{u}} (_πC : C ⟶ S) (_πT : T ⟶ S) :
    Type (u+1) :=
  sorry

/-! ## §2. The pullback functor along the projection

For a morphism of schemes `f : Y ⟶ Z` and an invertible `O_Z`-module `M`, the
pullback `f^* M` is an invertible `O_Y`-module (the pullback of an
open-cover-trivialisation of `M` trivialises `f^* M`, and the pullback of a free
module of rank one is free of rank one — Stacks tag 01HH). Specialising to the
projection `π_T = pullback.snd πC πT : C ×_S T ⟶ T` gives the pullback map
`π_T^* : Pic(T) → Pic(C ×_S T)`. Mathlib's underlying `Scheme.Modules.pullback`
functor (in `Mathlib.AlgebraicGeometry.Modules.Sheaf`) supplies the pullback on
the full category of sheaves of modules; iter-175+ will restrict it to
invertible sheaves once the `OnProduct` carrier is unpacked.

Blueprint reference: `def:pullback_along_projection` (Kleiman §2; Stacks tag
01HH). -/

/-- **Pullback along the projection** `π_T : C ×_S T ⟶ T` of a relative
curve. Sends an `O_T`-line bundle `N` to the `O_(C ×_S T)`-line bundle
`π_T^* N`, induced by the underlying `Scheme.Modules.pullback` functor on
`Scheme.Modules`.

iter-175+: instantiate as `(Scheme.Modules.pullback (pullback.snd πC πT)).obj N`
wrapped with the carried `IsInvertible` witness (the pullback of an invertible
sheaf is invertible, Stacks 01HH). For the iter-174 file-skeleton the body is
a typed `sorry` because the carrier type `OnProduct` is itself a typed `sorry`
(see §1). The signature is non-tautological: it asserts a *function*
`T.Modules → OnProduct πC πT`, which after unfolding `OnProduct` becomes the
concrete pullback functor restricted to invertible modules. -/
noncomputable def pullbackAlongProjection {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (_N : T.Modules) : OnProduct πC πT :=
  sorry

/-! ## §3. Composition of pullbacks

The composition law for line-bundle pullback (Stacks tag 01HG) says that for any
composable morphisms `f : X ⟶ Y, g : Y ⟶ Z` and any line bundle `M ∈ Pic(Z)`,
the natural isomorphism `(g ∘ f)^* M ≅ f^* g^* M` makes the pullback functor
into a (pseudo-)functor `Sch^op ⥤ Cat`.

Specialised to the relative curve setting: given `g : T' ⟶ T` over `S`, the
base-change morphism `g_C := id_C ×_S g : C ×_S T' ⟶ C ×_S T` satisfies
`π_T ∘ g_C = g ∘ π_{T'}` (definition of the fiber product). Therefore on
line bundles `g_C^* ∘ π_T^* = π_{T'}^* ∘ g^*`, with the equality realised as the
canonical natural isomorphism of pullback functors via the pseudo-functoriality
of `Scheme.Modules.pullback` (Mathlib `Modules.pullbackComp`).

Blueprint reference: `lem:pullback_compose` (Kleiman §2; Stacks tag 01HG). -/

/-- **Composition of line-bundle pullbacks** along the projection. For a base
scheme `S`, a curve-side morphism `πC : C ⟶ S`, test objects `T, T'` over `S`
via `πT : T ⟶ S` and `πT' : T' ⟶ S`, and a morphism `g : T' ⟶ T` over `S`
(encoded by the hypothesis `πT' = g ≫ πT`), set
`g_C := id_C ×_S g : C ×_S T' ⟶ C ×_S T`
(the base-change morphism, given by `pullback.map`). On the underlying
`Scheme.Modules.pullback` functors the two routes through the canonical
naturality square give canonically isomorphic objects:
```
            Scheme.Modules.pullback (pullback.snd πC πT)
  T.Modules  ─────────────────────────────────────────────►  (C ×_S T).Modules
       │                                                              │
       │ Scheme.Modules.pullback g            Scheme.Modules.pullback g_C
       ▼                                                              ▼
 T'.Modules  ─────────────────────────────────────────────►  (C ×_S T').Modules
            Scheme.Modules.pullback (pullback.snd πC πT')
```
i.e. for any `N : T.Modules`,
```
(Modules.pullback g_C).obj ((Modules.pullback (pullback.snd πC πT)).obj N)
  ≅
(Modules.pullback (pullback.snd πC πT')).obj ((Modules.pullback g).obj N).
```

This natural isomorphism is the substantive content of the
"line-bundle pullback functor is well-behaved under composition" fact
(Stacks tag 01HG). At the level of the `OnProduct` carrier (which is a typed
`sorry` in iter-174; see §1) it descends to equality of isomorphism classes
`[g_C^* π_T^* N] = [π_{T'}^* g^* N] ∈ OnProduct πC πT'`.

iter-175+: the body is `Modules.pullbackComp` composed twice (once on each
route) and patched together by the equation `πT' = g ≫ πT` (which gives
`π_T ∘ g_C = g ∘ π_{T'}` from the pullback square). For the iter-174
file-skeleton the body is a typed `sorry`. -/
theorem pullback_pullback_eq {S C T T' : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T)
    (hg : πT' = g ≫ πT) (N : T.Modules) :
    Nonempty
      ((Scheme.Modules.pullback
            (Limits.pullback.map πC πT' πC πT (𝟙 C) g (𝟙 S)
              (by rw [Category.comp_id, Category.id_comp]) (by rw [Category.comp_id, hg]))).obj
          ((Scheme.Modules.pullback (Limits.pullback.snd πC πT)).obj N) ≅
        (Scheme.Modules.pullback (Limits.pullback.snd πC πT')).obj
          ((Scheme.Modules.pullback g).obj N)) := by
  sorry

end LineBundle

namespace RelPicPresheaf

/-! ## §4. The relative Picard quotient (set-valued)

The relative Picard presheaf `Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)`
quotients the line-bundle group of the product by the subgroup pulled back from
the base. As a quotient of abelian groups it is a quotient set; equivalently,
the equivalence relation `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)` is captured by a
`Setoid` on the line-bundle type `OnProduct πC πT`. The quotient
`Quotient (preimage_subgroup πC πT)` is the underlying set of the relative
Picard presheaf at `T`.

The "preimage_subgroup" name follows the Kleiman/Stacks convention: the
quotient is by the preimage `π_T^* Pic(T) ⊆ Pic(C ×_S T)`, treated as a
subgroup (image of a group homomorphism); the project-side Lean encoding
extracts the *Setoid* that the quotient construction takes.

Blueprint reference: `thm:relative_pic_quotient_well_defined` (Kleiman §2,
Def. `df:Pfs`). -/

/-- **Well-definedness of the relative Picard quotient as a `Setoid`.**

The equivalence relation on `OnProduct πC πT` defining the relative Picard
presheaf
```
Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)
```
is the relation `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)`. This relation is reflexive
(`L ⊗ L⁻¹ = O_(C ×_S T) = π_T^* O_T ∈ π_T^* Pic(T)`), symmetric (the inverse of
a line bundle in `π_T^* Pic(T)` is in `π_T^* Pic(T)`), and transitive
(`L ⊗ L'⁻¹ ∈ π_T^* Pic(T)` and `L' ⊗ L''⁻¹ ∈ π_T^* Pic(T)` give
`L ⊗ L''⁻¹ ∈ π_T^* Pic(T)`); hence is an equivalence relation, encoded by a
`Setoid` on `OnProduct πC πT`.

The substantive content is the well-definedness of the quotient: the canonical
projection `OnProduct πC πT → Quotient (preimage_subgroup πC πT)` is the
set-theoretic underlying map of the relative Picard presheaf at `T`.

iter-175+: the body constructs the `Setoid` from the explicit relation `L ~ L'
↔ ∃ N : T.Modules, L ⊗ L'⁻¹ ≅ pullbackAlongProjection πC πT N`. For the
iter-174 file-skeleton this is a typed `sorry` because `OnProduct` itself is a
typed `sorry` (so the tensor product `L ⊗ L'⁻¹` on the carrier is not yet
typed). -/
noncomputable def preimage_subgroup {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    Setoid (LineBundle.OnProduct πC πT) :=
  sorry

/-! ## §5. Naturality in the test scheme — the relative Picard presheaf as a functor

For a morphism `g : T' ⟶ T` over `S` (encoded by the equality `πT' = g ≫ πT`),
the base-change `g_C := id_C ×_S g : C ×_S T' ⟶ C ×_S T` induces a map
`g_C^* : Pic(C ×_S T) → Pic(C ×_S T')` on line bundles, which (by
`lem:pullback_compose` = `pullback_pullback_eq` above) sends the subgroup
`π_T^* Pic(T)` into `π_{T'}^* Pic(T')`. Therefore it descends to a unique map
on quotients
```
g^♯ : Pic^♯_{C/S}(T) ⟶ Pic^♯_{C/S}(T'),    [L] ↦ [g_C^* L],
```
making `Pic^♯_{C/S} : (Sch/S)^op ⥤ Set` a presheaf.

For the iter-174 file-skeleton, we pin the **object-level** functorial action
(i.e. the induced map of quotient sets for a single test morphism `g`). The
full `Functor` packaging (with the identity / composition laws supplied as
`map_id`, `map_comp` fields) is iter-175+ work once `OnProduct` and the
`preimage_subgroup` carrier are unpacked.

Blueprint reference: `thm:pullback_natural` (Kleiman §2, "absolute Picard
functor" + Def. `df:Pfs`; Stacks tag 01HG). -/

/-- **The relative Picard presheaf is functorial in the test scheme.**

Object-level functorial action: for any morphism `g : T' ⟶ T` over `S`, there
is a canonical map
```
g^♯ : Pic^♯_{C/S}(T) ⟶ Pic^♯_{C/S}(T')
```
of quotient sets, factoring `g_C^*` through `preimage_subgroup πC πT` and
`preimage_subgroup πC πT'`. On representatives, `g^♯ [L] = [g_C^* L]` where
`g_C := id_C ×_S g`. The factorisation through the quotient is well-defined
because `g_C^*` sends `π_T^* Pic(T) ⊆ Pic(C ×_S T)` into
`π_{T'}^* Pic(T') ⊆ Pic(C ×_S T')` (this is the commutative-square content of
`pullback_pullback_eq`).

iter-175+: the body builds the map via `Quotient.lift` on the lifted `g_C^*`,
using the well-definedness from `pullback_pullback_eq`; the identity and
composition laws (giving the full `Functor (Sch/S)^op ⥤ Set` packaging) are
the lemmas `id_eq` and `comp_eq` of the quotient-induced map (immediate from
`Modules.pullbackId` and `Modules.pullbackComp`). For the iter-174 file-skeleton
the body is a typed `sorry`. The signature is non-tautological: it asserts a
map between two distinct quotient sets that depends on the morphism `g`. -/
noncomputable def functorial {S C T T' : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T) (_hg : πT' = g ≫ πT) :
    Quotient (preimage_subgroup πC πT) → Quotient (preimage_subgroup πC πT') :=
  sorry

end RelPicPresheaf

end Scheme

end AlgebraicGeometry
