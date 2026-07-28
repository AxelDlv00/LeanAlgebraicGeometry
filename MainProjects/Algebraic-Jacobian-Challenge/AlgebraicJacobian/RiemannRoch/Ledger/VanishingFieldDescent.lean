/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.GenusFieldInvariance
import AlgebraicJacobian.RiemannRoch.Ledger.GenusBridge

/-!
# `H¹(𝒪)` vanishing is a base-field-invariant property, and the first producer for
`UniformBaseDivisor`

`Ledger/GenusFieldInvariance.lean` closed **input (1)** of the extension-uniformity reduction
(the genus is base-field invariant) and left **input (2)** — `UniformBaseDivisor C d` — as the
single open antecedent.  Its closing docstring measured the *shape* of that gap with the
producer/consumer test and recorded the verdict: `UniformBaseDivisor` is a `def` with five
consumers and **no producer anywhere in AJC**.

This file supplies a producer.  It is a genuine one — `uniformBaseDivisor_zero_of_subsingleton`
below concludes `UniformBaseDivisor C 0` from a hypothesis about `C` alone, with no `κ` in it —
and it is **narrow**: its hypothesis is `Subsingleton (H¹(𝒪_C))`, which for AJC's curve means
`genus C = 0`.  Read the scope section before citing it, because the distance between "a
producer exists" and "the input is discharged" is exactly where this cluster has gone wrong
before.

## The mathematical content: faithfully flat descent, in both directions

The engine is one observation the previous round did not use.  `GenusFieldInvariance`'s
comparison `h1CokₗBaseChangeField` is a `κ`-linear equivalence

`κ ⊗[k] Ȟ¹(S, 𝒪_C) ≃ₗ[κ] Ȟ¹(S_κ, 𝒪_{C_κ})`,

and a field extension `κ/k` is **faithfully flat** (`κ` is a nontrivial free `k`-module, so
mathlib's `Module.FaithfullyFlat.instOfNontrivialOfFree` applies — checked, it is not a direct
instance and needs that route).  Faithful flatness makes `κ ⊗[k] −` reflect *and* preserve
triviality (`Module.FaithfullyFlat.subsingleton_tensorProduct_iff_right`), so the comparison
upgrades from an isomorphism of modules to an **equivalence of vanishing statements**:

`Subsingleton (H¹(𝒪_C))  ↔  Subsingleton (H¹(𝒪_{C_κ}))`.

Both directions are new here.  The previous round only ever used the comparison for its
`finrank`, which gives the genus identity but *not* the `Subsingleton` statement: `finrank`
reads `0` on an infinite-dimensional space, so a dimension equality cannot by itself decide
vanishing (this is the standing `Subsingleton`-vs-`finrank` distinction of
`Ledger/DegreeVanishing.h1_eq_zero_of_deg_ge`, and it is why the ascent below is not a
corollary of `genus_baseChangeField`).

The descent direction (`←`) is the one with no analogue anywhere in the workspace: it says a
vanishing established over *any* single extension — however large, e.g. `k̄` — descends to `k`.

## What is proved, and what it does and does not give

* `subsingleton_h1_unit_baseChangeField_iff` — the equivalence above, on a cover.  No hypothesis
  on `κ/k`: not finiteness, not separability, not perfectness, not algebraic closedness.
* `subsingleton_h1_unit_baseChangeField_iff_curve` — the same with the cover discharged, so it
  carries the three curve binders and nothing else.
* `uniformBaseDivisor_zero_of_subsingleton` — **the producer**: `UniformBaseDivisor C 0` from
  `Subsingleton (H¹(𝒪_C))`.  The witness at each `κ` is the zero divisor: `deg_κ 0 = 0 ≤ 0`, and
  its `H¹` vanishes by the ascent composed with `divisorSheafZeroIso`.
* `uniformVanishing_of_subsingleton_h1` — chaining it through
  `GenusFieldInvariance.uniformVanishing_of_uniformBaseDivisor_curve`: **`UniformVanishing C` is
  a theorem when `H¹(𝒪_C)` vanishes.**  This is the first unconditional instance of
  `UniformVanishing` in AJC — previously it had none, only the reduction.

## SCOPE: what this does NOT do, stated precisely

The three cluster-P statements stay apart, and so do the three things this file could be
mistaken for.

1. **It does not close input (2) in general.**  `UniformBaseDivisor C d` for `d` large is what a
   positive-genus curve needs, and this file produces only the `d = 0` case under a hypothesis
   that forces `genus C = 0`.  For `genus C ≥ 1`, `Subsingleton (H¹(𝒪_C))` is **false**
   (`Ledger/GenusBridge.moduleFinite_genus_carrier` makes `genus C` the dimension of an honestly
   finite-dimensional space, so it is nonzero exactly when that space is nontrivial), and the
   producer says nothing.  So the gap named by the previous round is **narrowed, not closed**:
   it now has a producer with a restrictive hypothesis rather than no producer at all.
2. **It is not extension-uniformity for positive genus.**  `uniformVanishing_of_subsingleton_h1`
   is `UniformVanishing C` under a genus-0 hypothesis.  The general statement remains open, and
   its residue is still exactly `UniformBaseDivisor C d` for a `d` that the geometry has to
   produce — the "missing production from geometry" verdict is unchanged in the case that
   matters.
3. **It says nothing about global generation.**  Cluster-P item 3 is a single-field statement
   (`FiberBound.exists_bound_generated_of_isFinite_toP1`) and nothing here makes it uniform over
   extensions.  The descent equivalence is about `H¹` of `𝒪` only; it is not about `H⁰`, not
   about a general divisor sheaf, and not about generation at a point.

One further limit worth naming because it bounds the method rather than the statement: the
descent equivalence is proved for the **unit** module.  `h1CokₗBaseChangeField` is stated at
`SheafOfModules.unit`, so the argument does not transport a vanishing for `𝒪(D)` with `D ≠ 0`.
That is the reason the producer's `d` is `0` and not something larger: it is not that a larger
`d` was hard to reach from here, but that there is no divisor-level base-change comparison in
AJC to reach it with.  A general-module `h1CokₗBaseChangeField` is the brick that would move
this, and it does not exist in AJC (AJCR has one — `datum_subsingleton_h1_baseChange`, arbitrary
datum and arbitrary ring map — but on its glued-datum carrier, behind an 88-file cone and the
unbridged `AffineTwoCover`/`AffineCoverMVSquare` and `relCurve`/`baseChangeField` boundaries;
measured this round, not portable).

## Provenance

**Rederived in AJC's abstractions; not a port.**  The faithful-flatness step is mathlib
(`Module.FaithfullyFlat.subsingleton_tensorProduct_iff_right` plus the `instOfNontrivialOfFree`
route to the instance), applied to AJC's own `h1CokₗBaseChangeField`.  AJCR does not contain
this statement: it has no `UniformBaseDivisor`, no `UniformVanishing`, and its vanishing
transport (`WindowFieldTransport.subsingleton_h1_windowN`) goes the *other* way — `k`-side
hypothesis to `K`-side conclusion for a specific window divisor — and never descends.  The
universe hop between the two `H¹` carriers (`Sheaf.HModule` at `u+1`, `Scheme.HModule` at `u+2`)
is `Ledger/GenusBridge`'s `Abelian.Ext.chgUnivLinearEquiv`, reused rather than redone.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace TensorProduct

namespace AlgebraicGeometry

namespace Scheme

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable (κ : Type u) [Field κ] [Algebra k κ]

/-! ## §1. A field extension is faithfully flat

Not an instance in mathlib on the nose: `Module.FaithfullyFlat k κ` does not synthesise from
`[Field k] [Field κ] [Algebra k κ]` (checked — it fails), because it goes through
`Module.Free k κ`, which needs the vector-space basis instance.  Named here so the two descent
lemmas below can `letI` it rather than each rediscovering the route. -/

/-- **A field extension is faithfully flat.**  `κ` is a nontrivial free `k`-module, so
`Module.FaithfullyFlat.instOfNontrivialOfFree` applies.

Stated as a `lemma` and used via `letI` rather than declared an `instance`: it is mathlib's fact
about mathlib's classes, and AJC should not be the project that globally instances it. -/
lemma faithfullyFlat_of_field_extension : Module.FaithfullyFlat k κ :=
  Module.FaithfullyFlat.instOfNontrivialOfFree k κ

/-! ## §2. Vanishing of `Ȟ¹(𝒪)` is invariant under base field extension

The upgrade of `GenusFieldInvariance.h1CokₗBaseChangeField` from an isomorphism to an
equivalence of vanishing statements.  Both directions come from the same faithful-flatness
iff, read the two ways. -/

/-- **`Ȟ¹(𝒪)` vanishes at `C_κ` iff it vanishes at `C`** (★★), on a 2-affine cover, for every
field extension `κ/k`.

The `→` direction is **descent**: a vanishing established over any single extension, however
large, descends to the base field.  The `←` direction is **ascent**.  Neither is a corollary of
the genus identity `genus C_κ = genus C`: that is an identity of `finrank`s, and `finrank` reads
`0` on an infinite-dimensional space, so it cannot decide `Subsingleton` in either direction.

No hypothesis on `κ/k` and none on `C` beyond carrying the cover — in particular no properness,
no smoothness, and no finiteness of the cohomology, since the faithful-flatness step needs none
of them. -/
theorem subsingleton_h1Cokₗ_unit_baseChangeField_iff (S : C.left.AffineCoverMVSquare) :
    Subsingleton ((S.baseChangeField κ).H1Cokₗ (baseChangeField C κ)
        (SheafOfModules.unit (baseChangeField C κ).left.ringCatSheaf)) ↔
      Subsingleton (S.H1Cokₗ C (SheafOfModules.unit C.left.ringCatSheaf)) := by
  letI : Module.FaithfullyFlat k κ := faithfullyFlat_of_field_extension κ
  rw [← (Module.FaithfullyFlat.subsingleton_tensorProduct_iff_right k κ
    (N := S.H1Cokₗ C (SheafOfModules.unit C.left.ringCatSheaf)))]
  exact (Scheme.h1CokₗBaseChangeField κ S).toEquiv.subsingleton_congr.symm

/-- **`H¹(𝒪)` vanishes at `C_κ` iff it vanishes at `C`**, on the `Sheaf.HModule` carrier that
the `Ledger` divisor statements bind.

`subsingleton_h1Cokₗ_unit_baseChangeField_iff` transported across two bridges AJC already owns:
`hModuleOneEquivH1Cokₗ_unit` (gate-free, every cover, every field) and the universe annotation
hop `Abelian.Ext.chgUnivLinearEquiv` of `Ledger/GenusBridge.lean`. -/
theorem subsingleton_hModule_one_moduleKSheaf_baseChangeField_iff
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (S : C.left.AffineCoverMVSquare) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    letI : (baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (baseChangeField C κ).hom
    Subsingleton (Sheaf.HModule ((baseChangeField C κ).left.moduleKSheaf κ) 1) ↔
      Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  letI : (baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (baseChangeField C κ).hom
  calc Subsingleton (Sheaf.HModule ((baseChangeField C κ).left.moduleKSheaf κ) 1)
      ↔ Subsingleton (Scheme.HModule κ (Scheme.toModuleKSheaf (baseChangeField C κ)) 1) :=
        (Abelian.Ext.chgUnivLinearEquiv (R := κ)).toEquiv.subsingleton_congr
    _ ↔ Subsingleton ((S.baseChangeField κ).H1Cokₗ (baseChangeField C κ)
          (SheafOfModules.unit (baseChangeField C κ).left.ringCatSheaf)) :=
        ((S.baseChangeField κ).hModuleOneEquivH1Cokₗ_unit
          (baseChangeField C κ)).toEquiv.subsingleton_congr
    _ ↔ Subsingleton (S.H1Cokₗ C (SheafOfModules.unit C.left.ringCatSheaf)) :=
        subsingleton_h1Cokₗ_unit_baseChangeField_iff κ S
    _ ↔ Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
        ((Abelian.Ext.chgUnivLinearEquiv (R := k)).toEquiv.subsingleton_congr.trans
          (S.hModuleOneEquivH1Cokₗ_unit C).toEquiv.subsingleton_congr).symm

end Scheme

/-! ## §3. The producer for `UniformBaseDivisor`, and the first `UniformVanishing` instance

§2 with the cover discharged (`GenusFieldInvariance.nonempty_affineCoverMVSquare_of_curve`) and
composed with `divisorSheafZeroIso` to land on the carrier `UniformBaseDivisor` binds.

Read §"SCOPE" of the module docstring on what the hypothesis costs: for AJC's curve
`Subsingleton (H¹(𝒪_C))` is `genus C = 0`, so these are genus-0 statements. -/

section Producer

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyIntegral C.hom]

/-- **`H¹(𝒪)` vanishing is base-field invariant, cover discharged** (★★): on the three curve
binders and nothing else, `H¹(𝒪_{C_κ})` vanishes iff `H¹(𝒪_C)` does, for every field extension.

The cover is produced rather than assumed (`nonempty_affineCoverMVSquare_of_curve`), so this is
an unqualified claim about AJC's curve rather than one about curves that happen to come with a
cover — the distinction `GenusFieldInvariance` had to make for the genus identity, made again
here for the same reason. -/
theorem subsingleton_hModule_one_baseChangeField_iff_curve (κ : Type u) [Field κ] [Algebra k κ] :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) 1) ↔
      Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) := by
  obtain ⟨S⟩ := nonempty_affineCoverMVSquare_of_curve C
  exact Scheme.subsingleton_hModule_one_moduleKSheaf_baseChangeField_iff κ S

/-- **The producer** (★★): `UniformBaseDivisor C 0` from vanishing of `H¹(𝒪_C)`.

This is the first declaration in AJC whose *conclusion* is `UniformBaseDivisor`, which is the
producer/consumer test `Ledger/GenusFieldInvariance.lean` applied to record that the type had
five consumers and none.  The witness at each `κ` is the **zero divisor**: `deg_κ 0 = 0 ≤ 0`, and
its `H¹` vanishes by §2's ascent composed with `divisorSheafZeroIso` at `κ`.

**Its hypothesis is restrictive and that is the honest content of the result.**  For AJC's curve
`Subsingleton (H¹(𝒪_C))` says `genus C = 0` (`Ledger/GenusBridge.moduleFinite_genus_carrier`
makes `genus C` the dimension of a genuinely finite-dimensional space, so it vanishes exactly
when that space is trivial).  So this closes input (2) for rational curves and says **nothing**
about `genus C ≥ 1`, where the input remains a missing production from geometry.  See the module
docstring §SCOPE item 1. -/
theorem uniformBaseDivisor_zero_of_subsingleton
    (h : letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
         Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1)) :
    UniformBaseDivisor C 0 := by
  intro κ _ _
  letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (Scheme.baseChangeField C κ).hom
  haveI : SmoothOfRelativeDimension 1
      ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
  refine ⟨0, ?_, by rw [Scheme.CurveDivisor.deg_zero]⟩
  have hκ : Subsingleton (Sheaf.HModule
      ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) 1) :=
    (subsingleton_hModule_one_baseChangeField_iff_curve C κ).mpr h
  exact (Sheaf.HModule.mapEquiv (Scheme.divisorSheafZeroIso κ) 1).toEquiv.subsingleton_congr.mpr
    hκ

/-- **`UniformVanishing C` is a theorem when `H¹(𝒪_C)` vanishes** (★★) — the first
unconditional instance of extension-uniform bounded vanishing in AJC.

Before this, `UniformVanishing` had **no** instances: `Ledger/ExtensionUniformity.lean` stated it
and `Ledger/GenusFieldInvariance.lean` reduced it to `UniformBaseDivisor`, but nothing produced
either.  The uniform threshold here is `0 + genus C = 0`.

**Genus 0, and the general case is untouched.**  Composing `uniformBaseDivisor_zero_of_subsingleton`
with `GenusFieldInvariance.uniformVanishing_of_uniformBaseDivisor_curve` inherits that theorem's
hypothesis exactly, so this is `UniformVanishing` for rational curves.  For `genus C ≥ 1` the
hypothesis is false and extension-uniformity remains open with the same residue as before. -/
theorem uniformVanishing_of_subsingleton_h1
    (h : letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
         Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1)) :
    UniformVanishing C :=
  uniformVanishing_of_uniformBaseDivisor_curve C (uniformBaseDivisor_zero_of_subsingleton C h)

end Producer

end AlgebraicGeometry
