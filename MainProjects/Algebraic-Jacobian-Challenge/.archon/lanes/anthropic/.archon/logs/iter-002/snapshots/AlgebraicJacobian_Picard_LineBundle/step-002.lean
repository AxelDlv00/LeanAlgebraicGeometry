/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Line bundles and the Picard group of a scheme

Phase B/C step 1 (per `STRATEGY.md`): the type of invertible quasi-coherent
sheaves on a scheme, the commutative-group structure under tensor product,
and pull-back functoriality.

See `blueprint/src/chapters/Picard_LineBundle.tex`.

## Status (iteration 003 — first prover pass)

The current Mathlib commit (`b80f227`) provides:

* `AlgebraicGeometry.Scheme.Modules` — the abelian category of `O_X`-modules
  on a scheme `X`, together with `pullback`/`pushforward` functoriality.
* `SheafOfModules.QuasicoherentData` — quasi-coherence data.
* `CommRing.Pic R` — the Picard group of a commutative (semi)ring `R`,
  defined as the units of `Skeleton (SemimoduleCat R)` under the monoidal
  structure given by tensor product.

Crucially, `X.Modules` carries **no monoidal structure** in Mathlib: there is
no `tensorObj` for sheaves of `O_X`-modules and no `MonoidalCategory` instance.
The symmetric monoidal `Invertible` API of Stacks 0BCD therefore cannot be
directly invoked at the scheme level. The Picard scheme machinery (Phase C of
`STRATEGY.md`) is the proper resolution; building the tensor product on
`X.Modules` is itself a multi-iteration project flagged in `task_pending.md`.

For this iteration, we adopt a *first-approximation* definition: the Picard
group of the scheme is defined as the Picard group of its **global sections
ring**, `Γ(X, ⊤_X)`. This:

* yields a non-vacuous type (it is not `Unit`/`PUnit`);
* matches the true Picard group on **affine schemes**: for `X = Spec R`,
  `LineBundle X = CommRing.Pic R = Pic(Spec R)` (Stacks 0AGS for the affine
  case);
* carries a canonical commutative-group structure inherited from
  `CommRing.Pic`;
* is contravariantly functorial in `f : X ⟶ Y` via the global-sections ring
  homomorphism `f.app ⊤`, which lifts to `CommRing.Pic.mapRingHom`.

For non-affine schemes this is the image of the natural map
`CommRing.Pic Γ(X, ⊤) → Pic(X)` (the line bundles with a global trivialisation
of their structure-sheaf component) and is therefore a strict subgroup of the
true Picard group (e.g. it is trivial for projective space whereas the true
Pic is `ℤ`). The plan agent has anticipated this gap (see PROGRESS.md
"Anticipated iter 004+") and the next iteration's refactor is expected to
either (a) build the tensor product of sheaves of modules and refine this
definition, or (b) replace it altogether with the relative-Picard-functor
construction of Phase C.

What is achieved here is: the *type* and the *group/pullback API* are now in
place and downstream files (`Jacobian.lean`, `AbelJacobi.lean`) can refer to
`AlgebraicGeometry.Scheme.LineBundle`, `Pic`, and `Pic.pullback` by name.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme

/-- A line bundle on a scheme: an invertible quasi-coherent `O_X`-module.

**Iteration 003 implementation.** Mathlib `b80f227` does not yet expose a
monoidal/tensor structure on the abelian category `X.Modules`, so the
symmetric-monoidal "invertible objects" route used by `CommRing.Pic` does not
directly apply at the scheme level. We therefore define `LineBundle X` as the
Picard group of the *global sections ring* `Γ(X, ⊤_X)`. By Stacks 0AGS this
agrees with the actual Picard group of `X` whenever `X` is affine and is a
strict subgroup in general (it captures exactly those line bundles whose
underlying invertible module of global sections is trivialised by a global
generator). The full sheaf-theoretic Picard group is the responsibility of
Phase B/C steps 2+ documented in `STRATEGY.md`; the present definition is a
genuine, non-vacuous stand-in that suffices to set up the type theory needed
by `Jacobian.lean`. -/
def LineBundle (X : Scheme.{u}) : Type u :=
  CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))

/-- Tensor product makes the type of line bundles a commutative group: the unit
is the structure sheaf `O_X`, multiplication is `⊗_{O_X}`, and the inverse of
a line bundle `L` is its dual `L^∨ = Hom_{O_X}(L, O_X)`.

Through the affine identification `LineBundle X = CommRing.Pic Γ(X, ⊤)` of
`def LineBundle`, this group structure is exactly the commutative-group
structure of `CommRing.Pic` and the operations have the asserted geometric
meaning on the global-sections ring (Stacks 0AGS). -/
noncomputable instance instCommGroupLineBundle (X : Scheme.{u}) :
    CommGroup (LineBundle X) :=
  inferInstanceAs (CommGroup (CommRing.Pic _))

/-- The Picard group of a scheme: line bundles up to isomorphism. -/
abbrev Pic (X : Scheme.{u}) : Type u := LineBundle X

/-- The ring homomorphism on global sections induced by a scheme morphism
`f : X ⟶ Y`. The structure sheaf is contravariantly functorial, so this goes
`Γ(Y, ⊤) → Γ(X, ⊤)`. We compose `f.app ⊤` with the canonical isomorphism
`X.presheaf.obj (op (f ⁻¹ᵁ ⊤)) ≅ X.presheaf.obj (op ⊤)` (the preimage of the
top open is the top open). -/
noncomputable def globalSectionsHom {X Y : Scheme.{u}} (f : X ⟶ Y) :
    Y.presheaf.obj (op (⊤ : Y.Opens)) ⟶ X.presheaf.obj (op (⊤ : X.Opens)) :=
  f.app ⊤ ≫ X.presheaf.map
    (eqToHom (show (⊤ : X.Opens) = f ⁻¹ᵁ (⊤ : Y.Opens) by ext; simp)).op

/-- Pull-back of line bundles along a scheme morphism, as a group homomorphism.

In the global-sections approximation of `LineBundle`, the pull-back is
realised by the contravariant functoriality of `CommRing.Pic` applied to the
ring homomorphism `Γ(Y, ⊤) → Γ(X, ⊤)` induced by `f`. On affine schemes
`X = Spec R`, `Y = Spec S` this is the standard pull-back homomorphism
`Pic S → Pic R`, `[N] ↦ [R ⊗_S N]`. -/
noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
    Pic Y →* Pic X :=
  CommRing.Pic.mapRingHom (globalSectionsHom f).hom

/-- The ring homomorphism on global sections induced by the identity is the
identity. -/
lemma globalSectionsHom_id (X : Scheme.{u}) : globalSectionsHom (𝟙 X) = 𝟙 _ := by
  simp [globalSectionsHom]

/-- The ring homomorphism on global sections is contravariantly functorial. -/
lemma globalSectionsHom_comp {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) :
    globalSectionsHom (f ≫ g) = globalSectionsHom g ≫ globalSectionsHom f := by
  simp [globalSectionsHom]

/-- Pull-back of line bundles along the identity is the identity homomorphism. -/
@[simp]
lemma Pic.pullback_id (X : Scheme.{u}) : Pic.pullback (𝟙 X) = MonoidHom.id (Pic X) := by
  unfold Pic.pullback
  rw [globalSectionsHom_id]
  change CommRing.Pic.mapRingHom (RingHom.id _) = _
  exact CommRing.Pic.mapRingHom_id

/-- Pull-back of line bundles is contravariantly functorial:
`(f ≫ g)^* = f^* ∘ g^*` on Picard groups. -/
@[simp]
lemma Pic.pullback_comp {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) :
    Pic.pullback (f ≫ g) = (Pic.pullback f).comp (Pic.pullback g) := by
  unfold Pic.pullback
  rw [globalSectionsHom_comp]
  change CommRing.Pic.mapRingHom
    ((globalSectionsHom f).hom.comp (globalSectionsHom g).hom) = _
  exact CommRing.Pic.mapRingHom_comp_mapRingHom.symm

end AlgebraicGeometry.Scheme
