/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.GenusFieldInvariance

/-!
# Axiom probe: `Ledger/SectionsFieldBaseChange.lean` + `Ledger/GenusFieldInvariance.lean`

Run with `lake env lean scripts/ajcrr-genusfieldinvariance-axioms.lean`.  Exit 0 with no
`sorryAx` on the twelve real declarations, and `sorryAx` on **both** controls.

## Read the measurement discipline before the output

The task this file serves requires axioms measured **at a synthesis site, not at the
declaration**: a theorem quantifying over a gate instance reports clean axioms *as stated* and
only picks up `sorryAx` where the instance is actually synthesised.  So the probe below does two
things rather than one:

1. `#print axioms` on each landed declaration (the declaration-site reading);
2. **§Synthesis** — instantiates `genus_baseChangeField` and
   `uniformVanishing_of_uniformBaseDivisor` at a concrete curve object with the instances
   *synthesised* rather than bound, and prints axioms of the resulting terms.  If any Λ-package
   instance or `χ`-ledger gate in the chain were sorry-backed, this is where it would surface and
   the declaration-site reading would not.

## Rootedness caveat — measured, disclosed, and NOT fixable from this lane

Both modules under audit are **outside the root import cone**: 262 modules are reachable from
`AlgebraicJacobian.lean`, and `Ledger/SectionsFieldBaseChange`, `Ledger/GenusFieldInvariance`,
`Ledger/ExtensionUniformity`, `Ledger/FiberBound` and `Ledger/DegreeVanishing` are all absent from
it (`CohomologyKit` and `CurveBaseChange`, which they import, *are* in it).  This is the
pre-existing condition of the whole `Ledger` vanishing chain, not something introduced here.

**What the caveat does and does not invalidate.**  It does *not* weaken the readings below:
`lake env lean` on this file elaborates the full import closure of the declarations named, so each
`#print axioms` is a faithful measurement of that declaration.  What it means is narrower and
still worth stating: a project-wide audit that walks axioms *starting from the root roll-up* will
not reach these declarations at all, so their cleanliness is invisible to that audit.

Rooting is one `import` line in `AlgebraicJacobian.lean`, which is **outside this task's write
scope**, so it is disclosed rather than fixed.

## The controls are live and MUST fire

Two negative controls are included, and both are checked to *resolve* (a control that fails to
elaborate is not a passing control — that error was made in this lane in an earlier round and
produced twelve meaningless clean readings).  `control_sorry` is a local `sorry`; `control_gate`
routes through AJC's known-sorry `Picard/FGAPicRepresentability` leaf, so it also demonstrates
that the probe *would* see a sorry reached through an import rather than only a local one.
-/

set_option autoImplicit false

universe u

open AlgebraicGeometry CategoryTheory Limits TensorProduct

/-! ## §1. SectionsFieldBaseChange -/

#print axioms AlgebraicGeometry.Scheme.algebraMap_sections_eq
#print axioms AlgebraicGeometry.Scheme.algebraMap_sections_baseChangeField_eq
#print axioms AlgebraicGeometry.Scheme.isPushout_algebraMap_sections_baseChangeField
#print axioms AlgebraicGeometry.Scheme.sectionsBaseChangeField
#print axioms AlgebraicGeometry.Scheme.sectionsBaseChangeField_tmul
#print axioms AlgebraicGeometry.Scheme.sectionsBaseChangeFieldₗ
#print axioms AlgebraicGeometry.Scheme.sectionsBaseChangeField_res
#print axioms AlgebraicGeometry.Scheme.finrank_sections_baseChangeField
#print axioms AlgebraicGeometry.Scheme.finrank_sections_baseChangeField_overlap

/-! ## §2. GenusFieldInvariance -/

#print axioms LinearMap.quotRangeBaseChangeField
#print axioms AlgebraicGeometry.Scheme.sectionDiffₗ_baseChangeField
#print axioms AlgebraicGeometry.Scheme.range_sectionDiffₗ_baseChangeField
#print axioms AlgebraicGeometry.Scheme.h1CokₗBaseChangeField
#print axioms AlgebraicGeometry.Scheme.h1_unit_baseChangeField_eq_h1_unit
#print axioms AlgebraicGeometry.Scheme.genus_baseChangeField
#print axioms AlgebraicGeometry.Scheme.chi_moduleKSheaf_baseChangeField_eq
#print axioms AlgebraicGeometry.uniformVanishing_of_uniformBaseDivisor

/-! ## §3. Synthesis sites

The declarations above bind their curve instances.  Here they are *supplied*, so every instance
in the Λ-package chain (`CurveBaseChange`'s named stack, the `GeometricallyIrreducible` transport
of `ExtensionUniformity` §1, the `χ`-ledger route through `ChiCurve`/`GenusBridge`) is resolved
by synthesis and any sorry behind one would be reached. -/

section Synthesis

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIntegral C.hom]
  [GeometricallyIrreducible C.hom]
variable (κ : Type u) [Field κ] [Algebra k κ]

/-- Synthesis site 1: the genus identity with the whole instance stack resolved. -/
theorem synth_genus (S : C.left.AffineCoverMVSquare) :
    genus (Scheme.baseChangeField C κ) = genus C :=
  Scheme.genus_baseChangeField κ S

/-- Synthesis site 2: the reduction, with `UniformBaseDivisor` still a hypothesis (it is open)
but everything else synthesised. -/
theorem synth_reduction (S : C.left.AffineCoverMVSquare) {d : ℤ}
    (h : UniformBaseDivisor C d) : UniformVanishing C :=
  uniformVanishing_of_uniformBaseDivisor C S h

/-- Synthesis site 3: the χ-ledger entry over `κ`, `κ`-independent. -/
theorem synth_chi (S : C.left.AffineCoverMVSquare) :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    Sheaf.chi ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) = 1 - (genus C : ℤ) :=
  Scheme.chi_moduleKSheaf_baseChangeField_eq κ S

end Synthesis

#print axioms synth_genus
#print axioms synth_reduction
#print axioms synth_chi

/-! ## §4. The controls — both MUST report `sorryAx`

If either of the next two lines reports a clean axiom set, the probe is broken and every reading
above is meaningless. -/

private theorem control_sorry : ∀ n : ℕ, n = n := by sorry

#print axioms control_sorry

section ControlGate

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))

/-- Control 2: routes through AJC's known-sorry FGA representability leaf, so a `sorryAx`
reached through an *import* is demonstrated to be visible to this probe — not only a local one. -/
private theorem control_gate [Scheme.HasRationalPoint C] [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyReduced C.hom] : Nonempty (Scheme.HasPicScheme C) :=
  ⟨Scheme.picSchemeOfHasRationalPoint C⟩

end ControlGate

#print axioms control_gate
