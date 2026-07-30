/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat

/-!
# The divisor-support quasi-finiteness binder, reduced to its geometric core

`AJC.picrep.divlocallyclosed`.

## The obligation this file is about

`Picard/DivPushforwardFlat.lean` carries, on every one of its theorems, the instance
binder

```
[LocallyQuasiFinite (schematicSupportι x.F ≫ pullback.snd π T.hom)]
```

— "the divisor `D ⊆ X_T` has finite fibres over `T`" — and says of it, in its own
module docstring, that it "has no producer in this project", that
`LocallyQuasiFinite` "occurs nowhere else in `Picard/`", and that it is
"kernel-checked NOT derivable from `DivFamily`'s other fields". All three
statements are true at HEAD and none of them is weakened here.

What *was* never measured is **how much of that binder is geometry**. This file
measures it, and the answer is that the binder is one topological statement away
from free: two of the three inputs the mathlib criteria want are supplied by
`DivFamily.properSupport`, which every family already carries.

## What is proved here

* `Scheme.Modules.locallyOfFiniteType_schematicSupportι_comp` and
  `Scheme.Modules.quasiCompact_schematicSupportι_comp` — from
  `HasProperSupport` alone, the support map is locally of finite type and
  quasi-compact. Both by synthesis once `IsProper` is in scope; recorded as named
  theorems because `HasProperSupport` is a `def`, not a class, so a consumer
  writing `haveI := hps` gets **no** instance and the synthesis silently fails
  (measured: `infer_instance` fails on both goals with the `def` in scope and
  succeeds with the `IsProper` restatement).

* `Scheme.Modules.locallyQuasiFinite_schematicSupportι_comp_iff_finite_fibers` —
  the binder **is equivalent** to finiteness of each set-theoretic fibre of the
  divisor over the base, for an arbitrary module with proper support over an
  arbitrary morphism. No curve, no smoothness, no relative dimension, no
  `DivFamily`.

* `Scheme.Modules.locallyQuasiFinite_schematicSupportι_comp_iff_isFinite_fiber` —
  the same equivalence in the scheme-theoretic form, against
  `IsFinite (…).fiberToSpecResidueField t`.

* `Scheme.Modules.locallyQuasiFinite_schematicSupportι_comp_of_finite_fibers` —
  the direction a producer needs, as a standalone implication.

* `Scheme.DivFamily.locallyQuasiFinite_of_finite_fibers` and
  `Scheme.DivFamily.locallyQuasiFinite_iff_finite_fibers` — the same statements
  at a `DivFamily`, where `properSupport` is a field, so the hypothesis list is
  *only* the fibre finiteness.

* `Scheme.Modules.locallyQuasiFinite_schematicSupportι` — for contrast, and
  because it is the fact that makes the composite's failure informative: the
  support immersion **on its own** is always locally quasi-finite, for every
  module on every scheme, by `IsPreimmersion`. So nothing about the annihilator
  or the support is what the binder is asking for; the whole content sits in the
  projection to `T`.

## What this does NOT do, stated because it is the natural over-reading

* It does **not** produce the binder for any family. The remaining obligation is
  the fibre finiteness, and that is where relative dimension one enters: on the
  curve fibre `C_t` the divisor `D_t` is the zero scheme of a regular section of
  an invertible ideal (`Picard/DivDegree.lean` has that fibre short exact
  sequence in full — `isLocallyTrivial_fiber_kernel`, `mono_fiber_kernel_ι`,
  `fiberKernelIso`, `fiberCokernelIso`), hence `0`-dimensional, hence finite. That
  step is genuinely absent and is not attempted here.

* It does **not** close `AJC.picrep.divlocallyclosed`. D3′ proper is the
  `ExistsUnique` statement about the Grassmannian locus; this file is upstream of
  it.

* It does **not** inhabit `Scheme.DivFamily`. `Picard/DivFamilyZero.lean`'s
  `DivFamily.zero` is the tree's only producer, so every statement here is
  testable at exactly one family.

* It closes **no** `sorry`, and `Scheme.fgaPicardRepresentability` is untouched.
  A shorter hypothesis list on the divisor side is not progress on the seam's
  `rep`, and this file is verified with that theorem as a `sorryAx` control.

## Why the reduction is worth landing separately

Three rows bind this hypothesis or its cousin — D3′ here, D4′ downstream, and
`Scheme.HasLocallyConstantDivDeg` (`Picard/DivDegree.lean`), whose discharge route
the `DivPushforwardFlat` docstring pins on exactly this quasi-finiteness. Naming
the reduction means a lane closing the fibre statement discharges all three at
once, rather than re-deriving the mathlib plumbing at each site. And the
plumbing is not nothing: the two free binders are free only *after* the `def`/class
mismatch above is worked around, which is a failure that looks like missing
mathematics.

## References

Blueprint: the campaign's D3′ node.
Source: [Kleiman], "The Picard scheme" (arXiv:math/0504020), §3 Def. `df:red`,
Ex. `ex:DivC`. Mathlib: `AlgebraicGeometry/Morphisms/QuasiFinite.lean`
(`locallyQuasiFinite_iff_finite_preimage_singleton`,
`locallyQuasiFinite_iff_isFinite_fiber`,
`LocallyQuasiFinite.of_finite_preimage_singleton`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

variable {S X : Scheme.{u}}

/-! ## §1. The support immersion alone is always quasi-finite

This section exists to locate the content of the binder. A reader pricing
`LocallyQuasiFinite (schematicSupportι F ≫ pullback.snd π T.hom)` might expect the
difficulty to be about the annihilator ideal sheaf or the schematic support, both
of which are project-local primitives with a thin API
(`Picard/QuotScheme.lean` records that `annihilator_ideal` itself is blocked on the
QCoh localisation bridge). It is not: the support immersion is quasi-finite
outright. -/

/-- **The schematic-support immersion is always locally quasi-finite** — for every
sheaf of modules on every scheme, with no hypothesis whatever.

`schematicSupportι F` is `IdealSheafData.subschemeι` of the annihilator ideal
sheaf, and mathlib registers `IsPreimmersion` for every `subschemeι`
(`AlgebraicGeometry/IdealSheaf/Subscheme.lean`) together with a low-priority
`IsPreimmersion ⟹ LocallyQuasiFinite` instance.

**The `inferInstanceAs` is load-bearing and is not cosmetic.** Instance search
does not see through `schematicSupportι`: writing the goal at the
`schematicSupportι` spelling and calling `infer_instance` after `unfold`
**fails** with `synthInstanceFailed` (measured both ways in one probe), because
unfolding replaces the reducible definition by the `annihilator`-projection form
that the instance is *not* indexed on. Stated as a theorem so downstream sites
cite a name rather than rediscover that. -/
theorem locallyQuasiFinite_schematicSupportι (F : X.Modules) :
    LocallyQuasiFinite (schematicSupportι F) :=
  inferInstanceAs (LocallyQuasiFinite F.annihilator.subschemeι)

/-- **The schematic-support immersion is a preimmersion**, hence injective on
points. Same `inferInstanceAs` remark as above. Used below only through
`Scheme.Hom.isEmbedding`. -/
theorem isPreimmersion_schematicSupportι (F : X.Modules) :
    IsPreimmersion (schematicSupportι F) :=
  inferInstanceAs (IsPreimmersion F.annihilator.subschemeι)

/-! ## §2. Two of the three inputs are free from `properSupport` -/

section Composite

variable {T : Scheme.{u}} (f : X ⟶ T) (F : X.Modules)

/-- **The support map is locally of finite type, from proper support alone.**

`HasProperSupport f F` is by definition `IsProper (schematicSupportι F ≫ f)`
(`Picard/QuotScheme.lean`), and mathlib derives `LocallyOfFiniteType` from
`IsProper` by synthesis.

**The restatement of the hypothesis as an `IsProper` instance is required.**
`HasProperSupport` is a plain `def`, not a class, so `haveI := hps` registers
nothing that instance search can use: `infer_instance` on this very goal
**fails** with the `def` in scope and **succeeds** after
`haveI : IsProper _ := hps` (measured both ways). That is a defect-shaped
failure — it reads as "mathlib lacks `IsProper ⟹ LocallyOfFiniteType`", which is
false — so the workaround is recorded as a named theorem rather than repeated at
each consumer. -/
theorem locallyOfFiniteType_schematicSupportι_comp
    (hps : HasProperSupport f F) :
    LocallyOfFiniteType (schematicSupportι F ≫ f) :=
  haveI : IsProper (schematicSupportι F ≫ f) := hps
  inferInstance

/-- **The support map is quasi-compact, from proper support alone.** Same route
and same `def`-versus-class caveat as
`locallyOfFiniteType_schematicSupportι_comp`. -/
theorem quasiCompact_schematicSupportι_comp
    (hps : HasProperSupport f F) :
    QuasiCompact (schematicSupportι F ≫ f) :=
  haveI : IsProper (schematicSupportι F ≫ f) := hps
  inferInstance

/-! ## §3. The binder is exactly the fibre finiteness -/

/-- **The quasi-finiteness binder of the divisor side IS finiteness of the
fibres**, for an arbitrary module with proper support over an arbitrary
morphism of schemes.

Both mathlib criteria that could give this want binders the caller does not
obviously have: `locallyQuasiFinite_iff_finite_preimage_singleton` needs
`LocallyOfFiniteType` *and* `QuasiCompact`. §2 supplies both from
`HasProperSupport`, so the equivalence holds with **no** hypothesis beyond proper
support.

What this buys, and it is the point of the file: a lane producing the binder does
not need to touch `LocallyQuasiFinite`, the annihilator ideal sheaf, the
schematic support, or affine-local `RingHom.QuasiFinite` conditions at all. It
needs one topological statement about the fibres of `D → T`. On a relative curve
that statement is that a nonempty effective Cartier divisor on a `1`-dimensional
fibre is a finite set of points — which is where the relative-dimension-one
hypothesis genuinely enters, and it is *not* proved here. -/
theorem locallyQuasiFinite_schematicSupportι_comp_iff_finite_fibers
    (hps : HasProperSupport f F) :
    LocallyQuasiFinite (schematicSupportι F ≫ f) ↔
      ∀ t : T, ((schematicSupportι F ≫ f) ⁻¹' {t}).Finite :=
  haveI : IsProper (schematicSupportι F ≫ f) := hps
  locallyQuasiFinite_iff_finite_preimage_singleton

/-- **The scheme-theoretic form of the same equivalence**: the binder holds iff
every scheme-theoretic fibre of the divisor over the base is a finite scheme over
the residue field.

Stated alongside the point-set form because the two feed different producers. A
route through the fibre short exact sequence of `Picard/DivDegree.lean`
(`fiberCokernelIso`, which identifies `(O_D)_t` with the cokernel of the fibre
ideal inclusion) lands naturally on *this* shape, since it produces a statement
about the fibre as a scheme rather than about a preimage set. -/
theorem locallyQuasiFinite_schematicSupportι_comp_iff_isFinite_fiber
    (hps : HasProperSupport f F) :
    LocallyQuasiFinite (schematicSupportι F ≫ f) ↔
      ∀ t : T, IsFinite ((schematicSupportι F ≫ f).fiberToSpecResidueField t) :=
  haveI : IsProper (schematicSupportι F ≫ f) := hps
  locallyQuasiFinite_iff_isFinite_fiber

/-- **The producer direction, standalone.** Given proper support, finiteness of
the fibres *gives* the binder. Split out from the `iff` because a producer only
ever uses this half, and because it is the form that lets a use site avoid
naming `HasProperSupport` twice. -/
theorem locallyQuasiFinite_schematicSupportι_comp_of_finite_fibers
    (hps : HasProperSupport f F)
    (hfib : ∀ t : T, ((schematicSupportι F ≫ f) ⁻¹' {t}).Finite) :
    LocallyQuasiFinite (schematicSupportι F ≫ f) :=
  haveI : IsProper (schematicSupportι F ≫ f) := hps
  LocallyQuasiFinite.of_finite_preimage_singleton _ hfib

/-- **A fibre of the divisor injects into the corresponding fibre of the ambient
family.** The support immersion is a preimmersion, hence injective on points, and
the fibre of the composite is by definition the preimage of the ambient fibre.

Recorded because it is the shape in which the missing geometry will be consumed:
it reduces fibre finiteness for `D → T` to finiteness of a *subset* of the curve
fibre `C_t`, so a producer never has to reason about `D` as a scheme in its own
right. Note the hypothesis is finiteness of the ambient fibre, which for a
relative curve is **false** — so this lemma is a reduction tool for a cut-down
subset, not a route to the binder by itself. -/
theorem finite_fiber_schematicSupportι_comp_of_finite
    {t : T} (hfin : (f ⁻¹' {t}).Finite) :
    ((schematicSupportι F ≫ f) ⁻¹' {t}).Finite := by
  haveI := isPreimmersion_schematicSupportι F
  have hpre : ((schematicSupportι F ≫ f) ⁻¹' {t})
      = (schematicSupportι F).base ⁻¹' (f ⁻¹' {t}) := rfl
  rw [hpre]
  exact hfin.preimage (schematicSupportι F).isEmbedding.injective.injOn

end Composite

end Modules

/-! ## §4. At a `DivFamily`, where proper support is a field -/

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- **The binder at a divisor family: only the fibre finiteness remains.**

`DivFamily.properSupport` is a structure field, so instantiating §3 at a family
removes the proper-support hypothesis entirely. This is the statement a lane
closing the divisor side should aim at, and its hypothesis list is one item long.

Non-vacuity: the tree has exactly one `DivFamily` producer,
`DivFamily.zero` (`Picard/DivFamilyZero.lean`), whose support is **empty**
(`isEmpty_schematicSupport_of_isZero`), so at that family the fibre hypothesis is
satisfiable and the conclusion is a real instance rather than a statement about
an uninhabited carrier. That is a remark about testability, not evidence that the
hypothesis is weak at a nonempty divisor. -/
theorem locallyQuasiFinite_of_finite_fibers (x : DivFamily π T)
    (hfib : ∀ t : (T.left : Scheme.{u}),
      ((Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) ⁻¹' {t}).Finite) :
    LocallyQuasiFinite (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
  Modules.locallyQuasiFinite_schematicSupportι_comp_of_finite_fibers _ _
    x.properSupport hfib

/-- **The binder at a divisor family is equivalent to the fibre finiteness.**

The `iff` form, so that a lane can also read the binder *backwards*: any
consumer of `DivPushforwardFlat`'s theorems is entitled to finiteness of the
divisor's fibres, which is a usable fact in its own right and was not previously
extractable from the binder without redoing the mathlib plumbing. -/
theorem locallyQuasiFinite_iff_finite_fibers (x : DivFamily π T) :
    LocallyQuasiFinite (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) ↔
      ∀ t : (T.left : Scheme.{u}),
        ((Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) ⁻¹' {t}).Finite :=
  Modules.locallyQuasiFinite_schematicSupportι_comp_iff_finite_fibers _ _
    x.properSupport

/-- **The scheme-theoretic form at a family.** Same content as
`locallyQuasiFinite_iff_finite_fibers`, in the shape the fibre short exact
sequence of `Picard/DivDegree.lean` produces. -/
theorem locallyQuasiFinite_iff_isFinite_fiber (x : DivFamily π T) :
    LocallyQuasiFinite (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) ↔
      ∀ t : (T.left : Scheme.{u}),
        IsFinite ((Modules.schematicSupportι x.F ≫
          pullback.snd π T.hom).fiberToSpecResidueField t) :=
  Modules.locallyQuasiFinite_schematicSupportι_comp_iff_isFinite_fiber _ _
    x.properSupport

/-- **The support map of a family is locally of finite type**, from the
`properSupport` field. Exposed because `DivPushforwardFlat`'s finiteness tower
spends exactly this, and because the `def`-versus-class trap of §2 bites at every
site that tries to synthesise it. -/
theorem locallyOfFiniteType_support (x : DivFamily π T) :
    LocallyOfFiniteType (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
  Modules.locallyOfFiniteType_schematicSupportι_comp _ _ x.properSupport

/-- **The support map of a family is quasi-compact**, from the `properSupport`
field. -/
theorem quasiCompact_support (x : DivFamily π T) :
    QuasiCompact (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
  Modules.quasiCompact_schematicSupportι_comp _ _ x.properSupport

end DivFamily

end Scheme

end AlgebraicGeometry
