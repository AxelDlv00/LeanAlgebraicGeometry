/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Picard.Pic0EtStructure

/-!
# Headline obligation 3: what is free, what is a renaming, and what is left

Headline obligation 3 is `Scheme.Pic0Et.universallyClosed` (`Picard/Pic0Et.lean:228`,
a bare `sorry`): universal closedness of `Pic⁰_{C/k}` over an arbitrary base field.
`Picard/Pic0EtStructure.lean` reduced properness to that single residue and proved
three of its formulations equivalent (`valuativeCriterion_existence_iff_universallyClosed`),
leaving one question open in its own words: the **topological** `SpecializingMap`
route was recorded as a genuinely different attack and never costed.

This file costs it. The answer has three parts, and only the first is a gain.

## 1. Two ingredients of the residue are FREE, and one of them retires an argument

* `compactSpace` — `CompactSpace ↥(Pic⁰_{C/k})`, from the already-proved
  `Pic0Et.quasiCompact` and `Spec k` being a compact space. Unconditional.

  This matters beyond bookkeeping. `Picard/AmbientPicNotProper.lean` refutes the
  *ambient* properness route by exactly this invariant: `UniversallyClosed` forces
  `CompactSpace` on the source, and `Pic_{C/k}` is an infinite disjoint union over
  `deg ∈ ℤ`, so it cannot be universally closed. That file states in prose that
  `Pic⁰` escapes the refutation because it is quasi-compact. `compactSpace` below
  makes the escape a *compiler-checked* fact about the étale object rather than a
  sentence: the necessary condition that kills the ambient route is satisfied here.
  It is a non-vacuity datum for obligation 3, not a step towards it.

* `specializingMap` — `SpecializingMap` of the underlying map of
  `(Pic⁰_{C/k}).hom`, unconditionally, because the base `Spec k` is a
  **one-point** space: every specialization in the target is trivial, so the
  lift is the given point. No hypothesis on `C`, no geometry.

  Consequence, and this is the sharp localisation the properness row asked for:
  since `ValuativeCriterion.Existence = (topologically @SpecializingMap).universally`
  (mathlib `ValuativeCriterion.Existence.eq`), and the **un**quantified factor is
  free, the entire content of obligation 3 sits in the `universally` quantifier —
  in the base-changed maps `Pic⁰ ×_k T → T`, never in the map itself. A lane
  attacking the topological form should not spend any effort on the
  specialization property at `k`; it is the base change that carries everything.

## 2. Two reformulations are RENAMINGS, and both converses are exhibited

Neither of the following is a reduction, and each is shipped **with its converse**
so the equivalence is compiler-checked rather than asserted (the practice
`I-1149`/`I-1150` recommend after three rounds of unmeasured converses in this
workspace):

* `universallyClosed_of_universally_specializing` / `universally_specializing_of_universallyClosed`
  — the arbitrary-base-change `SpecializingMap` form. Equivalent to the class.
* `universallyClosed_of_proper_cover` / `exists_proper_cover_of_universallyClosed`
  — "some proper `k`-scheme surjects onto `Pic⁰` over `k`". Equivalent to the
  class, because when `Pic⁰` *is* universally closed the **identity** witnesses
  the cover. So the existential proper-cover form must not be reported as
  progress: it is obligation 3 with different words.

## 3. What the surjection lemma is actually good for

`universallyClosed_of_surjective_source` and `proper_of_surjective_source` are the
useful residue of the Abel-map idea: mathlib's `UniversallyClosed.of_comp_surjective`
transfers universal closedness along **any** surjection onto `Pic⁰`. These are
stated with the cover as an explicit argument rather than existentially, which is
what keeps them from collapsing into §2: a consumer must supply a *named* proper
source, and then the two other conjuncts of properness come free from
`Pic0Et.isSeparated` and `Pic0Et.locallyOfFiniteType`.

The intended source is Kleiman's Abel map `Div^d_{C/k} → Pic^d_{C/k}`. That is
**not available**, and the reason is not this file's: `Scheme.abelMapWitness`
(`Picard/FGAPicRepresentability.lean:932`) is a natural transformation of
*functors*, `divFunctor C ⟶ picSharp C`, and turning it into a morphism of schemes
needs representability of `Div^d` — the Quot input the board marks `rejected`.
So §3 is an interface waiting for a brick nobody holds, and it is recorded as such
rather than advertised as a route.

## Honest accounting

`Pic0Et.universallyClosed` is **untouched**; nothing here witnesses it for any
curve. Every declaration binds `[HasPicSchemeEt C]`, whose instance projects the
seam `sorry` `fgaPicardRepresentability`, so all of it is sorry-*reachable* on
instantiation even though this file adds no `sorry`. What is genuinely new is
§1: two unconditional facts, one of which is the invariant that decides the
ambient refutation does not apply here.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace AlgebraicGeometry.Scheme.Pic0Et

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] [HasPicSchemeEt C]

/-! ### §1. The two free ingredients -/

/-- **`Pic⁰_{C/k}` has a compact underlying space** — unconditional.

`UniversallyClosed` forces `CompactSpace` on the source over an affine base, and
that is precisely the invariant by which `Picard/AmbientPicNotProper.lean` refutes
the *ambient* properness route (`Pic_{C/k}` is an infinite disjoint union over
`deg ∈ ℤ`, hence not quasi-compact, hence not universally closed). This theorem
records that `Pic⁰` **passes** that necessary condition, from the already-proved
`Pic0Et.quasiCompact` plus compactness of `Spec k`.

So the ambient refutation does not transport to the étale identity component, and
that is now checked rather than argued in prose. It is a non-vacuity datum for
obligation 3, **not** a step towards it: compactness is necessary, not sufficient. -/
theorem compactSpace : CompactSpace (Pic0SchemeEt C).left := by
  haveI := quasiCompact C
  exact QuasiCompact.compactSpace_of_compactSpace (Pic0SchemeEt C).hom

/-- **Specialization-lifting for `Pic⁰_{C/k} → Spec k` is free**, because the base
is a one-point space.

Every specialization `x ⤳ y` in `Spec k` is trivial (`Subsingleton ↥(Spec k)`), so
the given point lifts itself. No hypothesis on `C` is used beyond what names the
object.

**Why this is worth a name.** Mathlib's `ValuativeCriterion.Existence.eq` identifies
the properness residue with `(topologically @SpecializingMap).universally`. Since
the un-quantified factor is free, the whole of obligation 3 lives in the
`universally` — in the base-changed maps `Pic⁰ ×_k T → T` — and none of it in the
structure map. The topological route that `Picard/Pic0EtStructure.lean` recorded as
uncosted is costed by this observation: it does not make the obligation smaller,
but it says exactly where the obligation is not. -/
theorem specializingMap : SpecializingMap (Pic0SchemeEt C).hom.base := by
  intro x y _
  exact ⟨x, specializes_rfl, Subsingleton.elim _ _⟩

/-- The `MorphismProperty` spelling of `specializingMap`, for composing with
mathlib's `universally` API. -/
theorem topologically_specializingMap :
    (topologically @SpecializingMap) (Pic0SchemeEt C).hom :=
  specializingMap C

/-! ### §2. Two renamings, each with its converse -/

/-- Universal closedness from specialization-lifting on **every** base change.

This is `ValuativeCriterion.Existence.eq` composed with the free `QuasiCompact`
(`Pic0Et.quasiCompact`), so it needs no valuation rings. It is **not** a
reduction — see `universally_specializing_of_universallyClosed` for the converse,
which makes the pair an equivalence. -/
theorem universallyClosed_of_universally_specializing
    (h : ∀ {T : Scheme.{u}} (g : T ⟶ Spec (.of k)),
      SpecializingMap (pullback.fst g (Pic0SchemeEt C).hom).base) :
    UniversallyClosed (Pic0SchemeEt C).hom := by
  haveI := quasiCompact C
  refine UniversallyClosed.of_valuativeCriterion _ ?_
  rw [ValuativeCriterion.Existence.eq]
  exact MorphismProperty.universally_mk' _ _ (fun {T} g _ => h g)

/-- **The converse**: universal closedness gives specialization-lifting back on
every base change, so the hypothesis of
`universallyClosed_of_universally_specializing` is *equivalent* to the conclusion
and that lemma is a change of vocabulary, not a discharge of anything. -/
theorem universally_specializing_of_universallyClosed
    (h : UniversallyClosed (Pic0SchemeEt C).hom)
    {T : Scheme.{u}} (g : T ⟶ Spec (.of k)) :
    SpecializingMap (pullback.fst g (Pic0SchemeEt C).hom).base := by
  haveI := h
  haveI hpb : UniversallyClosed (pullback.fst g (Pic0SchemeEt C).hom) := inferInstance
  have hcm : IsClosedMap (pullback.fst g (Pic0SchemeEt C).hom).base :=
    MorphismProperty.universally_le (topologically @IsClosedMap) _
      (universallyClosed_eq ▸ hpb)
  exact hcm.specializingMap

/-- Universal closedness from a proper `k`-scheme surjecting onto `Pic⁰` over `k`.

Sound, and **not** a reduction in its existential form: see
`exists_proper_cover_of_universallyClosed`, where the identity supplies the cover
as soon as `Pic⁰` is universally closed. Useful only with a *named* source — which
is what `universallyClosed_of_surjective_source` in §3 is for. -/
theorem universallyClosed_of_proper_cover
    {W : Over (Spec (.of k))} [IsProper W.hom]
    (a : W.left ⟶ (Pic0SchemeEt C).left)
    (hsurj : Surjective a)
    (hover : a ≫ (Pic0SchemeEt C).hom = W.hom) :
    UniversallyClosed (Pic0SchemeEt C).hom := by
  haveI := hsurj
  haveI : UniversallyClosed (a ≫ (Pic0SchemeEt C).hom) := by
    rw [hover]; infer_instance
  exact UniversallyClosed.of_comp_surjective a (Pic0SchemeEt C).hom

/-- **The converse, and the reason the existential proper-cover form must not be
reported as progress**: if `Pic⁰` is universally closed then it is itself proper
(its other two conjuncts are theorems), so the **identity** is a proper surjection
onto it. Hence "there exists a proper cover" is *equivalent* to obligation 3. -/
theorem exists_proper_cover_of_universallyClosed
    (h : UniversallyClosed (Pic0SchemeEt C).hom) :
    ∃ (W : Over (Spec (.of k))) (_ : IsProper W.hom)
      (a : W.left ⟶ (Pic0SchemeEt C).left), Surjective a ∧
        a ≫ (Pic0SchemeEt C).hom = W.hom := by
  haveI := h
  haveI := isSeparated C
  haveI := locallyOfFiniteType C
  exact ⟨Pic0SchemeEt C, ⟨⟩, 𝟙 _, inferInstance, Category.id_comp _⟩

/-! ### §3. The named-cover interface (waiting on `Div^d` representability) -/

/-- **Transfer of universal closedness along a named surjection onto `Pic⁰`.**

Mathlib's `UniversallyClosed.of_comp_surjective`, instantiated at the étale
identity component. Unlike §2's existential form this does not collapse: the
cover `a` is an explicit argument, so a consumer must exhibit one.

The intended `a` is Kleiman's Abel map `Div^d_{C/k} → Pic^d_{C/k}`. It is **not
available at HEAD**: `Scheme.abelMapWitness` is a natural transformation of
functors (`divFunctor C ⟶ picSharp C`), and promoting it to a scheme morphism
requires representability of `Div^d`, i.e. the Quot input the board marks
`rejected`. Recorded as an interface, not a route. -/
theorem universallyClosed_of_surjective_source
    {W : Scheme.{u}} (a : W ⟶ (Pic0SchemeEt C).left)
    (hsurj : Surjective a)
    (huc : UniversallyClosed (a ≫ (Pic0SchemeEt C).hom)) :
    UniversallyClosed (Pic0SchemeEt C).hom :=
  UniversallyClosed.of_comp_surjective a (Pic0SchemeEt C).hom

/-- Properness of `Pic⁰` from a named surjection with universally closed
composite: the other two conjuncts are `Pic0Et.isSeparated` and
`Pic0Et.locallyOfFiniteType`, both theorems, so the cover only has to supply
universal closedness. -/
theorem proper_of_surjective_source
    {W : Scheme.{u}} (a : W ⟶ (Pic0SchemeEt C).left)
    (hsurj : Surjective a)
    (huc : UniversallyClosed (a ≫ (Pic0SchemeEt C).hom)) :
    IsProper (Pic0SchemeEt C).hom := by
  haveI := hsurj
  haveI := huc
  haveI : IsSeparated (Pic0SchemeEt C).hom := isSeparated C
  haveI : LocallyOfFiniteType (Pic0SchemeEt C).hom := locallyOfFiniteType C
  haveI : UniversallyClosed (Pic0SchemeEt C).hom :=
    UniversallyClosed.of_comp_surjective a (Pic0SchemeEt C).hom
  constructor

end AlgebraicGeometry.Scheme.Pic0Et
