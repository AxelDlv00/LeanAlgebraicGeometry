/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Albanese.CodimOnePerfectField
import AlgebraicJacobian.Picard.RigidPushforwardP1Witness
import AlgebraicJacobian.Picard.RigidPushforwardInstance

/-!
# The perfect-field Milne chain is non-vacuous: witnesses at `ℙ¹_ℚ` and `ℙ¹_{𝔽₅}`

`Albanese/CodimOnePerfectField.lean` weakens `[IsAlgClosed k]` to
`[PerfectField k]` throughout the Milne 3.1 chain.  A weakened binder buys
nothing if the *remaining* binders force the field closed anyway, and that is
the failure mode this file rules out — by **instantiation**, not by argument.

Each declaration below applies a perfect-field theorem to a concrete object over
a concrete field that is perfect and **not** algebraically closed.  Every
instance in each binder set is discharged by synthesis from the project's own
`Adelic.p1Over` instance stack (`GeometricallyIntegral`, `SmoothOfRelativeDimension 1`,
`IsProper`, `IsIntegral` — all stated over an arbitrary field), so nothing here
is hypothesised.  If the chain had secretly needed algebraic closure, these
would not elaborate.

## What this does and does not show

* It **does** show the five theorems of `CodimOnePerfectField.lean` are not
  vacuous, and that the widening is not a re-spelling of the closed case: `ℚ`
  and `𝔽₅` are genuinely outside `IsAlgClosed`.
* It does **not** touch `isAlbanese_pic0Et` (headline obligation 5) or witness
  any antecedent of it.  `ℙ¹` is a curve, but the obligation is about
  `Pic⁰_{C/k}` and the Albanese universal property, neither of which appears
  here.  What the file bounds is the *scope* of the perfect-field chain, nothing
  more.
* The imperfect case is genuinely excluded, not merely unaddressed:
  `PerfectField (RatFunc (ZMod p))` does not hold, so `𝔽_p(t)` — the field the
  headline's "arbitrary `k`" also covers — is outside all five theorems.  That
  gap is real and is stated in the sibling file's docstring.
-/

universe u

open CategoryTheory Limits AlgebraicGeometry AlgebraicGeometry.Adelic

namespace AlgebraicGeometry

namespace Scheme

/-- `ℚ` is perfect (characteristic zero) and is the base field of the witnesses
below.  Recorded as a named theorem so the non-vacuity argument does not rest on
an unstated instance. -/
theorem perfectField_rat : PerfectField ℚ := inferInstance

/-- **Non-vacuity of `isRegularLocalRing_stalk_of_smooth_perfectField`**: Stacks
`00TT` at every point of `ℙ¹_ℚ`.  The whole binder set — `Smooth`,
`GeometricallyIrreducible`, `IsSeparated`, `LocallyOfFiniteType`, `IsIntegral`,
`IsReduced` — is synthesized at `p1Over ℚ`, over a field that is not
algebraically closed. -/
theorem isRegularLocalRing_stalk_p1Over_rat (z : (p1Over ℚ).left) :
    IsRegularLocalRing ((p1Over ℚ).left.presheaf.stalk z) :=
  isRegularLocalRing_stalk_of_smooth_perfectField (p1Over ℚ) z

/-- **Non-vacuity of `localRing_dvr_of_codim_one_perfectField`** at `ℙ¹_ℚ`. -/
theorem localRing_dvr_p1Over_rat (z : (p1Over ℚ).left) (hz : Order.coheight z = 1) :
    IsDiscreteValuationRing ((p1Over ℚ).left.presheaf.stalk z) :=
  localRing_dvr_of_codim_one_perfectField (p1Over ℚ) z hz

/-- **Non-vacuity of `isReduced_of_smooth_perfectField`** at `ℙ¹_ℚ`.  Note this
one is *also* available from the in-tree `IsIntegral` instance, so it is the
weakest of the four as a witness; it is included because the perfect-field
reducedness proof is the one that needed a different route from the in-tree
`IsAlgClosed` version, and this checks that route fires on real data. -/
theorem isReduced_p1Over_rat : IsReduced ((p1Over ℚ).left) :=
  isReduced_of_smooth_perfectField (p1Over ℚ)

namespace RationalMap

/-- **Non-vacuity of Milne 3.1 over a perfect field**: the codim-`≥2`
indeterminacy conclusion for a rational self-map of `ℙ¹_ℚ` over `ℚ`.  Both
source and target binder sets are synthesized. -/
theorem indeterminacy_codimGe2_p1Over_rat
    (f : (p1Over ℚ).left.RationalMap (p1Over ℚ).left)
    (hf : f.compHom (p1Over ℚ).hom = (p1Over ℚ).hom.toRationalMap) :
    ∀ z ∈ indeterminacyLocus f, 2 ≤ Order.coheight z :=
  indeterminacy_codimGe2_of_smooth_of_complete_perfectField f hf

end RationalMap

/-- **The characteristic-`p` half of the non-vacuity claim**: the same binder set
at `ℙ¹` over the finite field `𝔽₅`, which is perfect and not algebraically
closed.  Stated with the primality `Fact` as an explicit hypothesis so the
declaration needs no ambient instance. -/
theorem isRegularLocalRing_stalk_p1Over_zmod
    (p : ℕ) [hp : Fact (Nat.Prime p)] (z : (p1Over (ZMod p)).left) :
    IsRegularLocalRing ((p1Over (ZMod p)).left.presheaf.stalk z) :=
  isRegularLocalRing_stalk_of_smooth_perfectField (p1Over (ZMod p)) z

end Scheme

end AlgebraicGeometry
