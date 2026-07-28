/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.ExtensionUniformity

/-!
# Axiom probe for `RiemannRoch/Ledger/ExtensionUniformity.lean`

Run with `lake env lean scripts/ajcrr-extuniformity-axioms.lean`.

## Why this probe needs a control, and a specific one

`Ledger/ExtensionUniformity.lean` imports `RiemannRoch/CurveBaseChange.lean`, whose own import
closure reaches `Picard/FGAPicRepresentability.lean` and `Picard/QuotFunctorDef.lean` — three
**real** `sorry`s (the build reports them on every run).  So this file sits, for the first time
in the `Ledger` layer, downstream of a subtree that genuinely carries `sorryAx`.  A clean
reading here is therefore worth nothing unless a control confirms the probe would *see* a
`sorryAx` if one were reachable.

§1 below is that control, and it uses **two** declarations, one from each sorry-carrying module
in the closure.  Both **must** report `sorryAx`.  If either fails to resolve or reads clean, the
probe is misconfigured (wrong import, stale olean, or a mistyped name) and every other line
below is void.

A calibration note worth keeping, because this probe hit it **twice**: a control that fails to
*resolve* is not a passing control.  The first run printed twelve clean lines while its control
errored `unknown constant` on `AlgebraicGeometry.fgaPicardRepresentability`; the second run fixed
that to `…Scheme.PicScheme.fgaPicardRepresentability` and it errored again, because the
`PicScheme` namespace *closes* at `FGAPicRepresentability.lean:227` and the theorem sits after
it, at `:339` — so the name is `AlgebraicGeometry.Scheme.fgaPicardRepresentability`.  Two rounds
of clean readings, zero calibration, and the second guess was wrong in the opposite direction
from the first.  Namespace nesting is not inferable from indentation; read the `end` lines.
Check every control for resolution before reading any silence as evidence.

## Measured at a synthesis site, not at the declaration

Per the standing workspace warning, a theorem quantifying over an instance reports clean axioms
as stated and only picks up `sorryAx` where the instance is *synthesised*.  The `probe_*_curve`
lines below are the ones that matter: they instantiate the statements at a curve bundle where
`Lean` must actually build `GeometricallyIrreducible (baseChangeField C κ).hom` and the two
`Module.Finite` cohomology binders, rather than receiving them from a caller.

## Scratch-path caveat (unchanged from the rest of this layer)

`Ledger/ExtensionUniformity.lean` is **outside the root import cone**: the root roll-up
`AlgebraicJacobian.lean` is out of this lane's write scope, so no axiom line measured here
travels through the root.  The readings are honest for this module and its closure and are not
a statement about the project's root-reachable axiom frontier.
-/

open CategoryTheory Limits AlgebraicGeometry Scheme

universe u

section Probe

variable {k : Type u} [Field k]

/-! ## §1. The controls — BOTH MUST print `sorryAx`

One per sorry-carrying module in the import closure.  Read these first: if either errors or
reads clean, stop, because §2–§5 are then uncalibrated. -/

#print axioms AlgebraicGeometry.Scheme.fgaPicardRepresentability
#print axioms AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso

/-! ## §2. §1 of the module: the missing instance -/

#print axioms AlgebraicGeometry.Scheme.geometricallyIrreducible_hom_baseChangeField

/-! ## §3. The free half, witnessed at `C_κ` -/

#print axioms AlgebraicGeometry.vanishing_baseChangeField
#print axioms AlgebraicGeometry.riemannRoch_baseChangeField
#print axioms AlgebraicGeometry.chi_moduleKSheaf_baseChangeField

/-! ## §4. The open half: the two named statements and the reduction -/

#print axioms AlgebraicGeometry.UniformVanishing
#print axioms AlgebraicGeometry.UniformBaseDivisor
#print axioms AlgebraicGeometry.uniformVanishing_of_uniform_base_of_genus_invariant
#print axioms AlgebraicGeometry.vanishing_baseChangeField_of_uniformVanishing
#print axioms AlgebraicGeometry.exists_deg_ge

/-! ## §5. The synthesis-site readings

Each theorem below instantiates a §3/§4 statement at an actual curve bundle, so that every
instance in its signature — in particular the `GeometricallyIrreducible` on `C_κ` added by §1 of
the module, and the two cohomology finiteness binders discharged by `ChiCurve` — is built here
rather than assumed.  A `sorryAx` in the `Picard` closure would surface on these lines. -/

/-- Synthesis site for the free half: nothing is left for a caller to instantiate. -/
theorem probe_vanishing_curve (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) 1) :=
  vanishing_baseChangeField C κ

/-- Synthesis site for exact Riemann–Roch at `C_κ`. -/
theorem probe_riemannRoch_curve (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      (Sheaf.h0 ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) : ℤ)
        = 1 - genus (Scheme.baseChangeField C κ) + CurveDivisor.deg κ D :=
  riemannRoch_baseChangeField C κ

/-- Synthesis site for the reduction. -/
theorem probe_reduction_curve (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {d : ℤ} {g : ℕ} (hbase : UniformBaseDivisor C d)
    (hgenus : ∀ (κ : Type u) [Field κ] [Algebra k κ],
      genus (Scheme.baseChangeField C κ) = g) :
    UniformVanishing C :=
  uniformVanishing_of_uniform_base_of_genus_invariant C hbase hgenus

#print axioms probe_vanishing_curve
#print axioms probe_riemannRoch_curve
#print axioms probe_reduction_curve

end Probe
