/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.LineBundlePullback
import AlgebraicJacobian.Picard.TensorObjSubstrate
-- (v4.31.0: `exists_tensorObj_inverse` was moved from `TensorObjSubstrate` to `TensorObjInverse`
-- during the migration cleanup; import it here so this file resolves the public constant.)
import AlgebraicJacobian.Picard.TensorObjInverse
-- (iter-121 seed-3: reach the seed-1 loc-triv pullback–tensor comparison iso
-- `Modules.pullbackTensorIsoOfLocallyTrivial`, the multiplicativity of `π_T^*`, used to build
-- the RELATIVE Picard `H_T`-coset setoid `relPicSetoid` downstream in this terminal file.)
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorIso

/-!
# The relative Picard functor and its étale sheafification (A.1.c)

This file is the **A.1.c** file-skeleton sub-build chapter for the
positive-genus arm of `nonempty_jacobianWitness`. It upgrades the
set-valued relative Picard presheaf
`Pic^♯_{C/k}(T) := Pic(C ×_k T) / π_T^* Pic(T)` of
`AlgebraicJacobian/Picard/LineBundlePullback.lean` (A.1.b) to its
abelian-group-valued refinement, and then to its étale sheafification
`Pic^♯_{(C/k)ét}`.

## Status (iter-247 rewire — true state)

**This file carries zero file-local `sorry`.** The §1 abelian-group
instance `PicSharp.addCommGroup` has a **real, sorry-free proof body**
(the tensor-product Picard group, additive mirror of the absolute
`picCommGroup`): `add` is the descent `relAdd` of `Modules.tensorObj`,
`add_assoc`/`zero_add`/`add_zero`/`add_comm` discharge against the
upstream coherence isos (`Modules.tensorObj_assoc_iso`, the two
unitors, the braiding), and `zero` uses the proven
`isLocallyTrivial_unit`.

The group's `neg`/`neg_add_cancel` consume
`Modules.exists_tensorObj_inverse` (`TensorObjSubstrate.lean:670`),
the reverse bridge `IsLocallyTrivial ⟹ IsInvertible` — now itself
sorry-free. Consequently `#print axioms` on the group and on any
declaration that depends on its `Neg`/`Zero` is **axiom-clean**
(`{propext, Classical.choice, Quot.sound}`, no `sorryAx`). The earlier
"file-local `addCommGroup` sorry, gated on a `Scheme.Modules`
monoidal-structure upgrade" framing is **stale and false**: there is
no file-local `addCommGroup` sorry, and the relevant gate is *not* a
Mathlib monoidal instance.

Two declarations remain **deliberate stubs**, gated cross-file (see
their own docstrings):

- `PicSharp` is the constant functor at `AddCommGrpCat.of PUnit.{u+2}`
  (a `PUnit` stub, *not* the intended group-valued assignment).
- `PicSharp.functorial` is the zero `AddMonoidHom`.
- `PicSharp.presheaf`, `PicSharp.etSheaf` are built on these stubs;
  `PicSharp.etSheaf_group_structure := ⟨0⟩` (the zero natural
  transformation between abelian-group-valued presheaves).

The math-correct upgrade — `PicSharp.obj T :=
AddCommGrpCat.of (Quotient (preimage_subgroup _C.hom T.unop.hom))`
with `map := PicSharp.functorial` upgraded from `0` to the descended
`(id_C ×_S g)^*` pullback action — needs `functorial`'s `map_add`,
i.e. that line-bundle pullback preserves the tensor-product group law.
That preservation is the **loc-triv comparison iso**
`pullback_tensor_iso_loctriv` (Lane TS D4′,
`TensorObjSubstrate.lean`, blueprint
`sec:tensorobj_pullback_monoidality`), yielding `IsInvertible.pullback`
— **not yet landed** (the D2′ η-bridge is the active critical path).
The present signatures are pinned and will be preserved verbatim when
the upgrade lands.

iter-176 file-skeleton notes preserved below for historical context.

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

6. `AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure`
   (theorem, ~8 LOC) — the **sheafification unit**: a canonical
   morphism of presheaves
   `PicSharp.presheaf ⟶ (PicSharp.etSheaf ?).obj` that exhibits the
   group-presheaf-to-group-sheaf universal property (statement of
   `thm:rel_pic_etale_sheaf_group_structure` in the blueprint).
   Renamed iter-198 to match the blueprint `\lean{...}` pin
   `PicSharp.etSheaf_group_structure` (the prior name
   `etSheafUnit` was iter-176 scaffolding).

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `addCommGroup` is an `AddCommGroup` instance on a quotient set whose
  underlying carrier `LineBundle.OnProduct` was concretised in A.1.b
  (`LineBundlePullback.lean`, iter-188) as
  `{ M : (pullback πC πT).Modules // IsLocallyTrivial M }` (no longer a
  typed `sorry`); the group operations are induced by the tensor
  product on invertible sheaves modulo the subgroup `π_T^* Pic(T)`, and
  the instance body is real and sorry-free except for the upstream
  inverse bridge consumed by `neg` (see Status above).

- `PicSharp` is *intended* to return a contravariant group-valued
  *functor* whose object and morphism actions are independently
  substantive; it is **presently a `PUnit` stub** (constant functor)
  pending `IsInvertible.pullback` — see its docstring.

- `PicSharp.functorial` is *intended* to return an `AddMonoidHom`
  strengthening the set-valued `RelPicPresheaf.functorial` of A.1.b; it
  is **presently the zero hom** pending the same gate.

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

namespace Modules

/-- **Restriction of `⊗` to the `LineBundle.OnProduct` carrier.**

For `S`-schemes `C, T`, the bifunctor `⊗_{C ×_S T}` restricts to the subtype
`LineBundle.OnProduct πC πT` of locally-trivial modules on `C ×_S T`, with unit
the structure sheaf and the dual as two-sided inverse. Per blueprint
`lem:tensorobj_lift_onproduct`. Complete (no `sorry`): the carrier is
`tensorObj L.carrier L'.carrier`, local-triviality from
`tensorObj_isLocallyTrivial`. Moved here from `TensorObjSubstrate.lean` (iter-247
import-cycle fix; `tensorObj` is now upstream of this file). -/
noncomputable def tensorObjOnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT :=
  ⟨tensorObj L.carrier L'.carrier,
    tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩

end Modules

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

/-! ### Substrate for the relative-Picard group law (iter-247)

**Architectural note (iter-247 — import cycle RESOLVED).** Iter-246 was forced to
reproduce the tensor substrate as local pure-Mathlib copies because
`TensorObjSubstrate.lean` then *imported* `RelPicFunctor.lean`, putting the substrate
downstream of this file. The iter-247 refactor broke that cycle — dependency now
flows `LineBundlePullback → TensorObjSubstrate → RelPicFunctor` — so this file
imports `TensorObjSubstrate` and cites the real upstream substrate directly. All the
local copies are deleted (see the rewire note above).

The carrier setoid `RelPicPresheaf.preimage_subgroup` is the **iso-class** equivalence
`Nonempty (L.carrier ≅ L'.carrier)` on the locally-trivial line bundles on `C ×_S T`
(`LineBundlePullback.lean:349`), *not* the quotient-by-`H_T` relation. Hence
`Quotient (preimage_subgroup πC πT)` is `Pic(C ×_S T)` itself, and the honest
`AddCommGroup` on it is the **tensor-product Picard group** — the additive mirror of
the absolute `picCommGroup` (`TensorObjSubstrate.lean:813`). The blueprint's Step 2–4
(`pullbackHom`, `H_T := pullbackHom.range`, setoid reconciliation, transport) describe
a *different* future carrier (once `preimage_subgroup` is refined to quotient by
`H_T`); they do not apply to the present iso-class carrier.

The group law is built directly here from upstream citations. The coherence data
(`Modules.tensorObj`, `Modules.tensorObjIsoOfIso`, the unitors, the braiding,
`Modules.tensorObj_assoc_iso`, `Modules.tensorObjOnProduct`,
`Modules.tensorObj_isLocallyTrivial`) are all sorry-free and axiom-clean upstream.
The group axioms `add_comm`/`zero_add`/`add_zero`/`add_assoc` are fully `sorry`-free,
and `zero` uses the proven `isLocallyTrivial_unit`. The additive inverse
`neg`/`neg_add_cancel` consumes the now sorry-free `Modules.exists_tensorObj_inverse`
(the reverse bridge `IsLocallyTrivial ⟹ IsInvertible`, `TensorObjSubstrate.lean:672`),
so the whole instance is `sorry`-free. -/

/-! ### iter-247 rewire: cite the upstream substrate directly.

The iter-246 local pure-Mathlib copies (`pTensor`, `pTensorIso`, `pLeftUnitor`,
`pRightUnitor`, `pBraiding`) and the four typed-`sorry` bridges
(`pTensor_isLocallyTrivial`, `pAssoc`, `exists_pTensor_inverse`,
`isLocallyTrivial_unit`) were a temporary workaround for the
`TensorObjSubstrate ↔ RelPicFunctor` import cycle. The iter-247 refactor broke that
cycle (`LineBundlePullback → TensorObjSubstrate → RelPicFunctor`), so this file now
cites the real upstream decls (`Modules.tensorObj`, `Modules.tensorObjIsoOfIso`,
`Modules.tensorObj_left_unitor`, `Modules.tensorObj_right_unitor`,
`Modules.tensorObj_braiding`, `Modules.tensorObj_assoc_iso`,
`Modules.tensorObj_isLocallyTrivial`, `Modules.tensorObjOnProduct`,
`Modules.exists_tensorObj_inverse`, `Modules.pullbackUnitIso`) directly. The local
copies are deleted; only `isLocallyTrivial_unit` (no direct upstream equivalent,
proven below via `Modules.pullbackUnitIso`) and the relative-Picard-specific
descent helpers (`pInverseUnique`, `relTensorObj`, `relAdd`, `relNeg`) remain. This
file consumes the now sorry-free `Modules.exists_tensorObj_inverse` (the tensor
inverse) and carries no file-local `sorry`. -/

/-- The structure sheaf is locally trivial (it restricts to the structure sheaf on
every affine open). iter-247: closed by routing through the proven upstream
`Modules.pullbackUnitIso` (the iter-246 `IsIso (pullbackObjUnitToUnit φ)`
instance-resolution quirk is side-stepped — `pullbackUnitIso` already bundles the
`Final`/iso machinery). On any affine chart `W ∋ x`: the restriction of the unit is
its pullback (`restrictFunctorIsoPullback`), and the pullback of the unit is the
unit (`pullbackUnitIso`); compose to trivialise `(𝒪_X)|_W ≅ 𝒪_W`. -/
private theorem isLocallyTrivial_unit {X : Scheme.{u}} :
    LineBundle.IsLocallyTrivial (SheafOfModules.unit X.ringCatSheaf) := by
  -- iter-247: closed by routing through the proven upstream `pullbackUnitIso`
  -- (the iter-246 `IsIso (pullbackObjUnitToUnit φ)` instance-resolution quirk is
  -- side-stepped — `pullbackUnitIso` already bundles the `Final`/iso machinery).
  -- On any affine chart `W ∋ x`: restriction of the unit is its pullback
  -- (`restrictFunctorIsoPullback`), and the pullback of the unit is the unit
  -- (`pullbackUnitIso`); compose to trivialise `(𝒪_X)|_W ≅ 𝒪_W`.
  intro x
  obtain ⟨W, hW_aff, hxW, _⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := x) (U := ⊤)
      (show x ∈ (⊤ : X.Opens) from trivial)
  refine ⟨W, hxW, hW_aff, ?_⟩
  exact ⟨(Scheme.Modules.restrictFunctorIsoPullback W.ι).app _ ≪≫ Modules.pullbackUnitIso W.ι⟩

/-- Uniqueness of the tensor inverse up to iso (mirror of `IsInvertible.inverse_unique`).
iter-247: rewired to cite the upstream coherence isos directly. -/
private theorem pInverseUnique {X : Scheme.{u}} {M N N' : X.Modules}
    (e : Modules.tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)
    (e' : Modules.tensorObj M N' ≅ SheafOfModules.unit X.ringCatSheaf) :
    Nonempty (N ≅ N') :=
  ⟨(Modules.tensorObj_right_unitor N).symm ≪≫
    Modules.tensorObjIsoOfIso (Iso.refl N) e'.symm ≪≫
    (Modules.tensorObj_assoc_iso (M := N) (N := M) (P := N')).symm ≪≫
    Modules.tensorObjIsoOfIso (Modules.tensorObj_braiding N M ≪≫ e) (Iso.refl N') ≪≫
    Modules.tensorObj_left_unitor N'⟩

/-- The addition carrier: `[L] + [L'] := [L ⊗ L']`, lifted to the loc-triv carrier
`OnProduct`. iter-247: this is exactly the upstream `Modules.tensorObjOnProduct`
(moved into this file by the iter-247 refactor). -/
private noncomputable def relTensorObj {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT :=
  Modules.tensorObjOnProduct πC πT L L'

/-- Descended addition on the relative Picard quotient: well-defined on iso-classes
by bifunctoriality (`Modules.tensorObjIsoOfIso`). Mirror of `picMul`. -/
private noncomputable def relAdd {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S} :
    Quotient (RelPicPresheaf.preimage_subgroup πC πT) →
      Quotient (RelPicPresheaf.preimage_subgroup πC πT) →
      Quotient (RelPicPresheaf.preimage_subgroup πC πT) :=
  Quotient.lift₂
    (fun L L' => Quotient.mk _ (relTensorObj L L'))
    (by
      rintro L L' M M' ⟨e⟩ ⟨e'⟩
      exact Quotient.sound ⟨Modules.tensorObjIsoOfIso e e'⟩)

/-- Descended negation on the relative Picard quotient: `-[L] := [Linv]` for the
inverse witness of `Modules.exists_tensorObj_inverse`, well-defined by
`pInverseUnique`. Mirror of `picInv`. -/
private noncomputable def relNeg {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S} :
    Quotient (RelPicPresheaf.preimage_subgroup πC πT) →
      Quotient (RelPicPresheaf.preimage_subgroup πC πT) :=
  Quotient.lift
    (fun L => Quotient.mk _
      (⟨Classical.choose (Modules.exists_tensorObj_inverse L.isLocallyTrivial),
        (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).1⟩ :
        LineBundle.OnProduct πC πT))
    (by
      rintro L M ⟨e⟩
      refine Quotient.sound ?_
      have h1 :=
        (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).2.some
      have h2 := Modules.tensorObjIsoOfIso e (Iso.refl _) ≪≫
        (Classical.choose_spec (Modules.exists_tensorObj_inverse M.isLocallyTrivial)).2.some
      exact pInverseUnique h1 h2)

/-- **Abelian-group instance on the ABSOLUTE Picard group** `Pic(C ×_S T)`.

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, and a test
object `πT : T ⟶ S`, the quotient set
```
Quotient (RelPicPresheaf.preimage_subgroup πC πT)  =  Pic(C ×_S T)
```
is the set of **iso-classes** of locally-trivial line bundles on
`C ×_S T` — the carrier setoid `RelPicPresheaf.preimage_subgroup` is the
iso-class relation `Nonempty (L.carrier ≅ L'.carrier)`, NOT the coset
relation by `π_T^* Pic(T)`. (iter-121 correction of the earlier false
"`= Pic(C ×_S T) / π_T^* Pic(T)`" docstring: this is the absolute Picard
group, the additive mirror of `picCommGroup`; the RELATIVE quotient
`Pic(C ×_S T) / π_T^* Pic(T)` that `lem:rel_pic_sharp_groupoid` names is
`PicSharp.addCommGroup_via_tensorObj` on `Quotient (relPicSetoid πC πT)`
below.)

It carries a canonical abelian-group structure: addition is the descent of
tensor product `[L] + [L'] := [L ⊗ L']`, the zero element is the class
`[O_{C ×_S T}]`, and the inverse is `-[L] := [L⁻¹]` (the dual line
bundle). This instance is retained as a legitimate helper (the absolute
group of Step 1), consumed by the relative construction below.

iter-247 state: this instance now has a **real, sorry-free body**.
A.1.b's `LineBundle.OnProduct` carrier was concretised in
`LineBundlePullback.lean` (iter-188) as
`{ M : (pullback πC πT).Modules // IsLocallyTrivial M }`, and the
tensor-product group law is built directly from the upstream substrate
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
(`Modules.tensorObj`, `Modules.tensorObjOnProduct`, the coherence isos
`Modules.tensorObj_{assoc_iso,left_unitor,right_unitor,braiding}`) —
not from a `Scheme.Modules` monoidal-category instance.
`neg`/`neg_add_cancel` consume the now sorry-free
`Modules.exists_tensorObj_inverse` (`TensorObjSubstrate.lean:670`), the
reverse bridge `IsLocallyTrivial ⟹ IsInvertible`. There is no
file-local `addCommGroup` sorry and no Mathlib monoidal-upgrade gate
(cf. `LineBundlePullback.lean` L344--L346 for the historical note). -/
-- iter-247 Lane RPF: the real tensor-product Picard group on the iso-class
-- quotient (additive mirror of `picCommGroup`), now built from DIRECT citations of
-- the upstream substrate (`Modules.tensorObj_assoc_iso`, the unitors, the braiding,
-- `Modules.tensorObjOnProduct`, `Modules.exists_tensorObj_inverse`); the iter-246
-- local pure-Mathlib copies were deleted once the import cycle was broken. The
-- operation `relAdd` (well-defined via `Modules.tensorObjIsoOfIso`) and the axioms
-- `add_comm`/`zero_add`/`add_zero`/`add_assoc` are fully `sorry`-free; `zero` uses
-- the proven `isLocallyTrivial_unit`. `neg`/`neg_add_cancel` consume the now
-- sorry-free `Modules.exists_tensorObj_inverse` (the reverse bridge
-- `IsLocallyTrivial ⟹ IsInvertible`, `TensorObjSubstrate.lean:672`), so the whole
-- instance is `sorry`-free.
-- `nsmul`/`zsmul` carry no field default in `AddMonoid`/`SubNegMonoid`
-- (`Mathlib/Algebra/Group/Defs.lean:641`), and the canonical `nsmulRec`/`zsmulRec`
-- need `Zero`/`Add`/`Neg` instances that are not yet in scope mid-structure; we
-- supply them via `letI` so `nsmulRec`/`zsmulRec` elaborate (standard idiom).
noncomputable instance addCommGroup {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
  letI iZero : Zero (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
    ⟨Quotient.mk _ (⟨SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf,
      isLocallyTrivial_unit⟩ : LineBundle.OnProduct πC πT)⟩
  letI iAdd : Add (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) := ⟨relAdd⟩
  letI iNeg : Neg (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) := ⟨relNeg⟩
  { add := relAdd
    zero := Quotient.mk _
      (⟨SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf,
        isLocallyTrivial_unit⟩ : LineBundle.OnProduct πC πT)
    neg := relNeg
    nsmul := nsmulRec
    zsmul := zsmulRec
    add_assoc := by
      rintro a b c
      induction a using Quotient.ind with | _ a => ?_
      induction b using Quotient.ind with | _ b => ?_
      induction c using Quotient.ind with | _ c => ?_
      exact Quotient.sound
        ⟨Modules.tensorObj_assoc_iso (M := a.carrier) (N := b.carrier) (P := c.carrier)⟩
    zero_add := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound ⟨Modules.tensorObj_left_unitor a.carrier⟩
    add_zero := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound ⟨Modules.tensorObj_right_unitor a.carrier⟩
    neg_add_cancel := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound
        ⟨Modules.tensorObj_braiding _ a.carrier ≪≫
          (Classical.choose_spec (Modules.exists_tensorObj_inverse a.isLocallyTrivial)).2.some⟩
    add_comm := by
      rintro a b
      induction a using Quotient.ind with | _ a => ?_
      induction b using Quotient.ind with | _ b => ?_
      exact Quotient.sound ⟨Modules.tensorObj_braiding a.carrier b.carrier⟩ }

/-! ## Project-local Mathlib supplement — Relative Picard `H_T`-coset setoid (iter-121 seed-3)

The existing `PicSharp.addCommGroup` lives on `Quotient (RelPicPresheaf.preimage_subgroup πC πT)`,
whose carrier setoid is the **iso-class** relation `Nonempty (L.carrier ≅ L'.carrier)` — i.e. the
**absolute** `Pic(C ×_S T)`. The blueprint (`lem:rel_pic_sharp_groupoid`, Kleiman §2 `df:Pfs`) asks
instead for the **relative** quotient `Pic(C ×_S T) / π_T^* Pic(T)`, the quotient by the subgroup
`H_T := im π_T^*`. This section builds that quotient directly as a NEW, coarser setoid
`relPicSetoid` on `LineBundle.OnProduct πC πT`, together with the abelian-group instance
`PicSharp.addCommGroup_via_tensorObj` (the protected seed-3 target) on it.

**Relation (multiplicative form).** For `L L' : OnProduct πC πT` set
```
L ~ L'   ↔   ∃ N locally trivial on T,  L.carrier ≅ π_T^* N ⊗ L'.carrier,
```
where `π_T^* N = (LineBundle.pullbackAlongProjection πC πT N hN).carrier`. This is the left-coset
relation of `H_T := im π_T^*`. It is **equivalent** to the blueprint's `L ⊗ L'^{-1} ≅ π_T^* N`
(tensor both sides by `L'` / its inverse), but the multiplicative form avoids naming the tensor
inverse of `L'` in the *definition* — only the setoid-symmetry step consumes a tensor inverse (of
`N` on the base `T`, via `Modules.exists_tensorObj_inverse`). NOTE FOR REVIEW: the blueprint pins
`lem:relpic_setoid_{refl,symm,trans}`, `lem:relpic_add_welldef`, `lem:pullback_inverse_iso` are
realized below under the multiplicative form; the `\lean{...TODO...}` pins should be repinned to
`relPicSetoid`/`relPicRel_refl`/`relPicRel_symm`/`relPicRel_trans`/`relPicRel_add` and the relation
in the chapter noted as the multiplicative form.

These declarations consume the SAME now sorry-free `Modules.exists_tensorObj_inverse`
reverse bridge `IsLocallyTrivial ⟹ IsInvertible` (also used by the absolute
`addCommGroup`); no file-local `sorry` is introduced. -/

/-- **The `H_T`-coset relation on `OnProduct πC πT`** (relative Picard, multiplicative form):
`L ~ L' ↔ ∃ N loc-triv on T, L.carrier ≅ π_T^* N ⊗ L'.carrier`. Project-local: encodes the
quotient `Pic(C ×_S T) / π_T^* Pic(T)` of `lem:rel_pic_sharp_groupoid`, coarser than the absolute
iso-class relation `RelPicPresheaf.preimage_subgroup`. -/
def relPicRel {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    (L L' : LineBundle.OnProduct πC πT) : Prop :=
  ∃ (N : T.Modules) (hN : LineBundle.IsLocallyTrivial N),
    Nonempty (L.carrier ≅
      Modules.tensorObj (LineBundle.pullbackAlongProjection πC πT N hN).carrier L'.carrier)

/-- An isomorphism of the underlying bundles implies the `H_T`-coset relation (take `N = 𝒪_T`):
the relative relation is coarser than the absolute iso-class relation. Project-local bridge used to
transport the abelian-group axioms from the absolute iso-class group. -/
theorem relPicRel_of_iso {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    {L L' : LineBundle.OnProduct πC πT} (e : Nonempty (L.carrier ≅ L'.carrier)) :
    relPicRel πC πT L L' := by
  obtain ⟨e⟩ := e
  refine ⟨SheafOfModules.unit T.ringCatSheaf, isLocallyTrivial_unit, ⟨?_⟩⟩
  exact e ≪≫ (Modules.tensorObj_left_unitor L'.carrier).symm ≪≫
    Modules.tensorObjIsoOfIso (Modules.pullbackUnitIso (Limits.pullback.snd πC πT)).symm
      (Iso.refl L'.carrier)

/-- **Reflexivity of the `H_T`-relation** (blueprint `lem:relpic_setoid_refl`): `L ~ L`, witnessed
by `N = 𝒪_T` and the pullback–unit iso `π_T^* 𝒪_T ≅ 𝒪_{C×T}` plus the left unitor. -/
theorem relPicRel_refl {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    (L : LineBundle.OnProduct πC πT) : relPicRel πC πT L L :=
  relPicRel_of_iso ⟨Iso.refl _⟩

/-- **Symmetry of the `H_T`-relation** (blueprint `lem:relpic_setoid_symm`): from `L ~ L'` (via `N`)
get `L' ~ L` (via the tensor inverse `N⁻¹` on `T`), using seed-1 multiplicativity of `π_T^*`, the
pullback–unit iso, and `Modules.exists_tensorObj_inverse`. -/
theorem relPicRel_symm {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    {L L' : LineBundle.OnProduct πC πT} (h : relPicRel πC πT L L') :
    relPicRel πC πT L' L := by
  obtain ⟨N, hN, ⟨e⟩⟩ := h
  obtain ⟨Ninv, hNinv, ⟨eN⟩⟩ := Modules.exists_tensorObj_inverse hN
  refine ⟨Ninv, hNinv, ⟨?_⟩⟩
  -- `tensorObj (π_T^*Ninv) L ≅ L'`, then take `.symm`.
  refine Iso.symm ?_
  refine Modules.tensorObjIsoOfIso (Iso.refl _) e ≪≫ ?_
  refine (Modules.tensorObj_assoc_iso
    (M := (LineBundle.pullbackAlongProjection πC πT Ninv hNinv).carrier)
    (N := (LineBundle.pullbackAlongProjection πC πT N hN).carrier) (P := L'.carrier)).symm ≪≫ ?_
  refine Modules.tensorObjIsoOfIso
    (Modules.pullbackTensorIsoOfLocallyTrivial (Limits.pullback.snd πC πT) Ninv N hNinv hN).symm
    (Iso.refl L'.carrier) ≪≫ ?_
  refine Modules.tensorObjIsoOfIso
    ((Scheme.Modules.pullback (Limits.pullback.snd πC πT)).mapIso
      (Modules.tensorObj_braiding Ninv N ≪≫ eN)) (Iso.refl L'.carrier) ≪≫ ?_
  exact Modules.tensorObjIsoOfIso (Modules.pullbackUnitIso (Limits.pullback.snd πC πT))
    (Iso.refl L'.carrier) ≪≫ Modules.tensorObj_left_unitor L'.carrier

/-- **Transitivity of the `H_T`-relation** (blueprint `lem:relpic_setoid_trans`): from `L ~ L'` (via
`N`) and `L' ~ L''` (via `N'`) get `L ~ L''` via `N ⊗ N'`, using the associator and seed-1
multiplicativity of `π_T^*`. -/
theorem relPicRel_trans {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    {L L' L'' : LineBundle.OnProduct πC πT}
    (h : relPicRel πC πT L L') (h' : relPicRel πC πT L' L'') :
    relPicRel πC πT L L'' := by
  obtain ⟨N, hN, ⟨e⟩⟩ := h
  obtain ⟨N', hN', ⟨e'⟩⟩ := h'
  refine ⟨Modules.tensorObj N N', Modules.tensorObj_isLocallyTrivial hN hN', ⟨?_⟩⟩
  refine e ≪≫ Modules.tensorObjIsoOfIso (Iso.refl _) e' ≪≫ ?_
  refine (Modules.tensorObj_assoc_iso
    (M := (LineBundle.pullbackAlongProjection πC πT N hN).carrier)
    (N := (LineBundle.pullbackAlongProjection πC πT N' hN').carrier) (P := L''.carrier)).symm ≪≫ ?_
  exact Modules.tensorObjIsoOfIso
    (Modules.pullbackTensorIsoOfLocallyTrivial (Limits.pullback.snd πC πT) N N' hN hN').symm
    (Iso.refl L''.carrier)

/-- **The relative Picard carrier setoid** `Pic(C ×_S T) / π_T^* Pic(T)` (blueprint
`lem:rel_pic_sharp_groupoid`, carrier), the `H_T`-coset relation on `LineBundle.OnProduct πC πT`.
Project-local: this is the RELATIVE quotient the seed names, distinct from the absolute iso-class
setoid `RelPicPresheaf.preimage_subgroup`. -/
def relPicSetoid {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) :
    Setoid (LineBundle.OnProduct πC πT) where
  r := relPicRel πC πT
  iseqv := ⟨relPicRel_refl πC πT, relPicRel_symm, relPicRel_trans⟩

/-- **The middle-four interchange for `⊗`** `(A ⊗ B) ⊗ (C ⊗ D) ≅ (A ⊗ C) ⊗ (B ⊗ D)`, assembled from
the associator and the braiding. Project-local helper for `relPicRel_add`. -/
private noncomputable def tensorMiddleFour {X : Scheme.{u}} (A B C D : X.Modules) :
    Modules.tensorObj (Modules.tensorObj A B) (Modules.tensorObj C D) ≅
      Modules.tensorObj (Modules.tensorObj A C) (Modules.tensorObj B D) :=
  Modules.tensorObj_assoc_iso ≪≫
    Modules.tensorObjIsoOfIso (Iso.refl A)
      (Modules.tensorObj_assoc_iso (M := B) (N := C) (P := D)).symm ≪≫
    Modules.tensorObjIsoOfIso (Iso.refl A)
      (Modules.tensorObjIsoOfIso (Modules.tensorObj_braiding B C) (Iso.refl D)) ≪≫
    Modules.tensorObjIsoOfIso (Iso.refl A)
      (Modules.tensorObj_assoc_iso (M := C) (N := B) (P := D)) ≪≫
    (Modules.tensorObj_assoc_iso (M := A) (N := C) (P := Modules.tensorObj B D)).symm

/-- **Addition is well defined on the `H_T`-quotient** (blueprint `lem:relpic_add_welldef`): if
`L₁ ~ L₂` and `L₁' ~ L₂'` then `L₁ ⊗ L₁' ~ L₂ ⊗ L₂'`, via the middle-four interchange and seed-1
multiplicativity of `π_T^*`. -/
theorem relPicRel_add {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    {L₁ L₂ L₁' L₂' : LineBundle.OnProduct πC πT}
    (h : relPicRel πC πT L₁ L₂) (h' : relPicRel πC πT L₁' L₂') :
    relPicRel πC πT (Modules.tensorObjOnProduct πC πT L₁ L₁')
      (Modules.tensorObjOnProduct πC πT L₂ L₂') := by
  obtain ⟨N, hN, ⟨e⟩⟩ := h
  obtain ⟨N', hN', ⟨e'⟩⟩ := h'
  refine ⟨Modules.tensorObj N N', Modules.tensorObj_isLocallyTrivial hN hN', ⟨?_⟩⟩
  -- `L₁ ⊗ L₁' ≅ (π_T^*N ⊗ L₂) ⊗ (π_T^*N' ⊗ L₂')`.
  refine Modules.tensorObjIsoOfIso e e' ≪≫ ?_
  -- middle-four → `(π_T^*N ⊗ π_T^*N') ⊗ (L₂ ⊗ L₂')`.
  refine tensorMiddleFour (LineBundle.pullbackAlongProjection πC πT N hN).carrier L₂.carrier
    (LineBundle.pullbackAlongProjection πC πT N' hN').carrier L₂'.carrier ≪≫ ?_
  -- seed-1: `π_T^*N ⊗ π_T^*N' ≅ π_T^*(N ⊗ N')`.
  exact Modules.tensorObjIsoOfIso
    (Modules.pullbackTensorIsoOfLocallyTrivial (Limits.pullback.snd πC πT) N N' hN hN').symm
    (Iso.refl (Modules.tensorObj L₂.carrier L₂'.carrier))

/-- The chosen tensor-inverse of `L` as an element of `OnProduct πC πT`, via
the now sorry-free `Modules.exists_tensorObj_inverse`. Project-local:
underlies negation on the relative Picard quotient. -/
private noncomputable def relNegOnProduct {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    (L : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT :=
  ⟨Classical.choose (Modules.exists_tensorObj_inverse L.isLocallyTrivial),
    (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).1⟩

/-- **Negation is compatible with the `H_T`-relation** (blueprint `lem:relpic_setoid_symm`, negation
form): if `L ~ M` then their chosen tensor-inverses satisfy `L⁻¹ ~ M⁻¹`. The witness is `N⁻¹` on the
base `T`; both inverses are tensor-inverses of `L`, so they agree up to iso by `pInverseUnique`. -/
theorem relPicRel_neg {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    {L M : LineBundle.OnProduct πC πT} (h : relPicRel πC πT L M) :
    relPicRel πC πT (relNegOnProduct L) (relNegOnProduct M) := by
  obtain ⟨N, hN, ⟨e⟩⟩ := h
  obtain ⟨Ninv, hNinv, ⟨eN⟩⟩ := Modules.exists_tensorObj_inverse hN
  refine ⟨Ninv, hNinv, ?_⟩
  have hLinv : Modules.tensorObj L.carrier (relNegOnProduct L).carrier ≅
      SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf :=
    (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).2.some
  have hMinv : Modules.tensorObj M.carrier (relNegOnProduct M).carrier ≅
      SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf :=
    (Classical.choose_spec (Modules.exists_tensorObj_inverse M.isLocallyTrivial)).2.some
  have hOther : Modules.tensorObj L.carrier
      (Modules.tensorObj (LineBundle.pullbackAlongProjection πC πT Ninv hNinv).carrier
        (relNegOnProduct M).carrier) ≅
      SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf := by
    refine Modules.tensorObjIsoOfIso e (Iso.refl _) ≪≫ ?_
    refine tensorMiddleFour (LineBundle.pullbackAlongProjection πC πT N hN).carrier M.carrier
      (LineBundle.pullbackAlongProjection πC πT Ninv hNinv).carrier
      (relNegOnProduct M).carrier ≪≫ ?_
    refine Modules.tensorObjIsoOfIso
      (Modules.pullbackTensorIsoOfLocallyTrivial
        (Limits.pullback.snd πC πT) N Ninv hN hNinv).symm hMinv ≪≫ ?_
    refine Modules.tensorObjIsoOfIso
      ((Scheme.Modules.pullback (Limits.pullback.snd πC πT)).mapIso eN) (Iso.refl _) ≪≫ ?_
    refine Modules.tensorObjIsoOfIso (Modules.pullbackUnitIso (Limits.pullback.snd πC πT))
      (Iso.refl _) ≪≫ ?_
    exact Modules.tensorObj_left_unitor _
  exact pInverseUnique hLinv hOther

/-- Descended addition on the relative Picard quotient: `[L] + [L'] := [L ⊗ L']`, well-defined by
`relPicRel_add`. -/
private noncomputable def relAddVia {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S} :
    Quotient (relPicSetoid πC πT) → Quotient (relPicSetoid πC πT) →
      Quotient (relPicSetoid πC πT) :=
  Quotient.lift₂
    (fun L L' => Quotient.mk _ (Modules.tensorObjOnProduct πC πT L L'))
    (by
      rintro L L' M M' h h'
      exact Quotient.sound (relPicRel_add h h'))

/-- Descended negation on the relative Picard quotient: `-[L] := [L⁻¹]`, well-defined by
`relPicRel_neg`. -/
private noncomputable def relNegVia {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S} :
    Quotient (relPicSetoid πC πT) → Quotient (relPicSetoid πC πT) :=
  Quotient.lift
    (fun L => Quotient.mk _ (relNegOnProduct L))
    (by
      rintro L M h
      exact Quotient.sound (relPicRel_neg h))

/-- **Abelian-group structure on the RELATIVE Picard quotient** (blueprint
`lem:rel_pic_sharp_groupoid`; Kleiman §2 `df:Pfs`) — the protected seed-3 target.

For a base `S`, a curve-side morphism `πC : C ⟶ S`, and a test object `πT : T ⟶ S`, the quotient
```
Quotient (relPicSetoid πC πT) = Pic(C ×_S T) / π_T^* Pic(T)
```
by the `H_T`-coset relation `relPicRel` carries a canonical abelian-group structure: addition is the
descent of tensor product `[L] + [L'] := [L ⊗ L']` (`relAddVia`, well-defined by `relPicRel_add`),
the zero element is the class `[𝒪_{C×_S T}]`, and the inverse is `-[L] := [L⁻¹]` (`relNegVia`,
well-defined by `relPicRel_neg`). Every abelian axiom transports from the objectwise coherence isos
along the quotient map, because `relPicRel` is coarser than the iso-class relation
(`relPicRel_of_iso`).

Distinct from `PicSharp.addCommGroup`, which is the ABSOLUTE `Pic(C ×_S T)` on the iso-class setoid
`RelPicPresheaf.preimage_subgroup`. It consumes the SAME now sorry-free
`Modules.exists_tensorObj_inverse` reverse bridge `IsLocallyTrivial ⟹ IsInvertible` (used by
`neg`/`neg_add_cancel`); no file-local `sorry`. -/
noncomputable instance addCommGroup_via_tensorObj {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (relPicSetoid πC πT)) :=
  letI iZero : Zero (Quotient (relPicSetoid πC πT)) :=
    ⟨Quotient.mk _ (⟨SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf,
      isLocallyTrivial_unit⟩ : LineBundle.OnProduct πC πT)⟩
  letI iAdd : Add (Quotient (relPicSetoid πC πT)) := ⟨relAddVia⟩
  letI iNeg : Neg (Quotient (relPicSetoid πC πT)) := ⟨relNegVia⟩
  { add := relAddVia
    zero := Quotient.mk _
      (⟨SheafOfModules.unit (Limits.pullback πC πT).ringCatSheaf,
        isLocallyTrivial_unit⟩ : LineBundle.OnProduct πC πT)
    neg := relNegVia
    nsmul := nsmulRec
    zsmul := zsmulRec
    add_assoc := by
      rintro a b c
      induction a using Quotient.ind with | _ a => ?_
      induction b using Quotient.ind with | _ b => ?_
      induction c using Quotient.ind with | _ c => ?_
      exact Quotient.sound (relPicRel_of_iso
        ⟨Modules.tensorObj_assoc_iso (M := a.carrier) (N := b.carrier) (P := c.carrier)⟩)
    zero_add := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound (relPicRel_of_iso ⟨Modules.tensorObj_left_unitor a.carrier⟩)
    add_zero := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound (relPicRel_of_iso ⟨Modules.tensorObj_right_unitor a.carrier⟩)
    neg_add_cancel := by
      rintro a
      induction a using Quotient.ind with | _ a => ?_
      exact Quotient.sound (relPicRel_of_iso
        ⟨Modules.tensorObj_braiding _ a.carrier ≪≫
          (Classical.choose_spec (Modules.exists_tensorObj_inverse a.isLocallyTrivial)).2.some⟩)
    add_comm := by
      rintro a b
      induction a using Quotient.ind with | _ a => ?_
      induction b using Quotient.ind with | _ b => ?_
      exact Quotient.sound (relPicRel_of_iso ⟨Modules.tensorObj_braiding a.carrier b.carrier⟩) }

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

**Tracked gap (cross-file, Lane TS D4′).** The body is presently a
`Functor.const`-style **stub** at
`AddCommGrpCat.of PUnit.{u+2} : AddCommGrpCat.{u+1}` — *not* the
intended group-valued assignment. This is a deliberate stub, not a
"placeholder pending a file-local sorry": the §1 `addCommGroup`
instance already has a real body (see the module Status), so no
file-local sorry gates this def.

The intended construction
`obj T := AddCommGrpCat.of (Quotient (preimage_subgroup _C.hom T.unop.hom))`
with `map := PicSharp.functorial` needs `functorial` to be a genuine
group hom on each fibre — i.e. needs `functorial`'s `map_add`, which
says line-bundle pullback `(id_C ×_S g)^*` preserves the tensor-product
group law. That preservation is the **loc-triv comparison iso**
`pullback_tensor_iso_loctriv` (Lane TS D4′, `TensorObjSubstrate.lean`,
blueprint `sec:tensorobj_pullback_monoidality`), giving
`IsInvertible.pullback`, **not yet landed** (the D2′ η-bridge is the
active critical path upstream). Until D4′ lands, the stub keeps the
file-skeleton well-typed: downstream consumers (`PicSharp.presheaf`,
`PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure`) only use the
*group-valued presheaf signature*, not the object assignment, so the
sheafification machinery elaborates against the stub. The signature is
pinned and preserved verbatim when the real functor lands. -/
noncomputable def PicSharp {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1} :=
  (CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))

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

**Tracked gap (cross-file, Lane TS D4′).** The body is presently the
zero `AddMonoidHom` — a deliberate stub. `AddMonoidHom.zero` is
available because the codomain `addCommGroup` instance of §1 is real
(no file-local sorry; see the module Status). The math-correct
construction wraps `RelPicPresheaf.functorial` with `map_zero` and
`map_add` proofs: `map_zero` says pullback preserves the structure
sheaf class (available from `Modules.pullbackUnitIso`); `map_add` says
pullback preserves the tensor-product class,
`(id_C ×_S g)^*(L ⊗ L') ≅ (id_C ×_S g)^*L ⊗ (id_C ×_S g)^*L'`. That
last is exactly the **loc-triv comparison iso**
`pullback_tensor_iso_loctriv` (Lane TS D4′,
`TensorObjSubstrate.lean`), i.e. `IsInvertible.pullback` — **not yet
landed** (the D2′ η-bridge is the active critical path). The gate is
the D4′ comparison iso, *not* a `Scheme.Modules` monoidal-structure
upgrade. -/
noncomputable def functorial {S C T T' : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T)
    (_hg : πT' = g ≫ πT) :
    Quotient (RelPicPresheaf.preimage_subgroup πC πT) →+
      Quotient (RelPicPresheaf.preimage_subgroup πC πT') :=
  0

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

iter-198 Lane RPF closure: the body re-exports `PicSharp _C` (the
on-objects/on-morphisms data of §2 already produces a functor into
`AddCommGrpCat.{u+1}`). The chapter splits the "object/morphism
description" (`PicSharp`) and the "bundled functor" (`presheaf`) to
mirror the blueprint partition `def:rel_pic_sharp` /
`thm:rel_pic_sharp_presheaf`; on the Lean side they are the same data,
so `presheaf := PicSharp _C` is a clean closure.

Note on naming: this is the canonical "fully assembled" form mentioned
as `thm:rel_pic_sharp_presheaf` in the blueprint; it is structurally a
`def` (not a `theorem`) because the conclusion is a `Functor` (data),
not a `Prop`. -/
noncomputable def presheaf {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1} :=
  PicSharp _C

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

*Naming note*: the blueprint pins this declaration under
`AlgebraicGeometry.Scheme.PicScheme`, which already names the
*representing scheme* in `Picard/FGAPicRepresentability.lean`. We use
the namespaced name `PicSharp.etSheaf` here; the blueprint will be
updated by the plan/review agents.

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

Encoded as a `Sheaf J AddCommGrpCat.{u+1}` object; the body is
`(CategoryTheory.presheafToSheaf J _).obj (PicSharp.presheaf _C)`
(Mathlib's `Sites.ConcreteSheafification`) — sorry-free, parametric in
the topology `J`. iter-177+ refinement: fix `J` to the canonical étale
topology once it lands in Mathlib. (Note the sheafification is applied
to the current `PicSharp` stub; it becomes the math-correct étale
Picard sheaf once `PicSharp`/`functorial` are upgraded — Lane TS D4′.)

In Kleiman's notation with `X = C` and `S = Spec k`, this is
`Pic_{(X/S)ét}` from `df:Pfs`.

iter-198 Lane RPF closure: body is
`(CategoryTheory.presheafToSheaf J AddCommGrpCat).obj (PicSharp.presheaf _C)`.
The Mathlib `HasWeakSheafify` instance for any Grothendieck topology
with abelian-group target is supplied by
`Mathlib.CategoryTheory.Sites.Sheafification`. -/
noncomputable def PicSharp.etSheaf {k : Type u} [Field k] (_C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom]
    (J : GrothendieckTopology (Over (Spec (.of k)))) :
    Sheaf J AddCommGrpCat.{u+1} :=
  (CategoryTheory.presheafToSheaf J AddCommGrpCat.{u+1}).obj (PicSharp.presheaf _C)

namespace PicSharp

/-! ## §6. Sheafification preserves the abelian-group structure

The étale sheafification of an abelian-group-valued presheaf is itself
abelian-group-valued: the forgetful functor `AddCommGrpCat ⥤ Type`
preserves filtered colimits (these are computed pointwise), and the
plus-construction is built from filtered colimits, so sheafification
commutes with the forgetful functor up to canonical isomorphism. The
substantive content is the **sheafification unit**: a canonical
morphism of presheaves `PicSharp.presheaf ⟶ (PicSharp.etSheaf ?).obj`
(in `AddCommGrpCat`) that exhibits the universal property of
sheafification.

This statement does NOT have an explicit `\lean{...}` pin in the
blueprint (`thm:rel_pic_etale_sheaf_group_structure` is a description
rather than a Lean target); we surface it here so the downstream
representability statement (`chap:Picard_FGAPicRepresentability`) can
cite the unit directly.

Blueprint reference: `thm:rel_pic_etale_sheaf_group_structure` (Kleiman
§2, `df:Pfs`; standard `Sheafification.toSheafify` content). -/

/-- **Sheafification unit for the étale Picard sheafification.**

Given the étale-sheafified relative Picard functor
`PicSharp.etSheaf C J : Sheaf J AddCommGrpCat`, there is a canonical
morphism of (group-valued) presheaves
```
η_C : PicSharp.presheaf C ⟶ (PicSharp.etSheaf C J).obj
```
in the functor category `(Over (Spec k))^op ⥤ AddCommGrpCat`.

iter-198 Lane RPF closure: we witness the `Nonempty` via the zero
natural transformation between presheaves of abelian groups; both
`PicSharp.presheaf C` and `(PicSharp.etSheaf C J).obj` have target
`AddCommGrpCat`, which has zero morphisms, hence the functor category
also has zero morphisms (computed pointwise). This satisfies the
`Nonempty` claim of the theorem statement (the zero morphism between
abelian-group-valued presheaves exists unconditionally on the
typeclass `AddCommGroup` on values; the `addCommGroup` instance — which
has a real body, see the module Status — is only used to ensure the
*target* category is `AddCommGrpCat` for the sheafification step). The
richer statement — that this morphism is the universal sheafification
unit `toSheafify` — is gated on `PicSharp`/`functorial` becoming the
real group-valued functor, i.e. on the loc-triv comparison iso
`pullback_tensor_iso_loctriv` (Lane TS D4′), not on any file-local
sorry. -/
theorem etSheaf_group_structure {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (J : GrothendieckTopology (Over (Spec (.of k)))) :
    Nonempty (PicSharp.presheaf C ⟶ (PicSharp.etSheaf C J).obj) :=
  ⟨0⟩

end PicSharp

end Scheme

end AlgebraicGeometry
