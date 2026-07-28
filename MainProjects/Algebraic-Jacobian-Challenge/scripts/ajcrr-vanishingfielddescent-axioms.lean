/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.VanishingFieldDescent

/-!
# Axiom probe for `Ledger/VanishingFieldDescent.lean`

Measured **at synthesis sites**, not at the declarations.  The distinction is the whole point of
this file and it is the specific error the task warned about: a theorem quantifying over a gate
instance reports clean axioms *as stated* and only picks up `sorryAx` where the instance is
actually synthesised.  So every probe below instantiates the statement at AJC's curve binders,
forcing the instance stack to be built, and only then prints axioms.

Run: `lake env lean scripts/ajcrr-vanishingfielddescent-axioms.lean`

## Controls

Two negative controls are included and **must** report `sorryAx`.  Without them a clean reading
proves nothing — a probe that tests names that do not exist, or that measures a statement whose
instances were never forced, reads clean for the wrong reason.  (This lane shipped phantom
declaration names three times; the controls are the guard against a fourth.)
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Scheme

section Synthesis

-- The curve binder block, exactly as the `Ledger` statements bind it.  Instantiating the probes
-- against these variables is what forces instance synthesis.
variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyIntegral C.hom]
variable (κ : Type u) [Field κ] [Algebra k κ]

/-! ### §1 the faithful-flatness step -/

/-- Synthesis site: the field extension is faithfully flat. -/
theorem probeFaithfullyFlat : Module.FaithfullyFlat k κ :=
  Scheme.faithfullyFlat_of_field_extension κ

/-! ### §2 the descent/ascent equivalence, both carriers -/

-- NOTE on probe shape: each probe below **returns the statement**, it does not merely `have` it
-- and close with `trivial`.  A `True`-valued probe that discards the term does not retain its
-- axiom dependencies, so `#print axioms` on it measures nothing.  (Caught in this very file: an
-- earlier draft used the `have _ := …; trivial` shape and three probes then read `sorryAx` from a
-- syntax error elsewhere in the script rather than from the theorems — the controls are what
-- exposed it.)

omit [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
  [GeometricallyIntegral C.hom] in
/-- Synthesis site: the Čech-carrier equivalence, at a produced cover.  The `omit` is informative:
§2's Čech-level equivalence genuinely needs **no** curve hypothesis — only the cover — which is
what makes it the faithful-flatness statement rather than a geometric one. -/
theorem probeH1CokIff (S : C.left.AffineCoverMVSquare) :
    Subsingleton ((S.baseChangeField κ).H1Cokₗ (Scheme.baseChangeField C κ)
        (SheafOfModules.unit (Scheme.baseChangeField C κ).left.ringCatSheaf)) ↔
      Subsingleton (S.H1Cokₗ C (SheafOfModules.unit C.left.ringCatSheaf)) :=
  Scheme.subsingleton_h1Cokₗ_unit_baseChangeField_iff κ S

omit [GeometricallyIrreducible C.hom] in
/-- Synthesis site: the `Sheaf.HModule`-carrier equivalence, at a produced cover.  Geometric
irreducibility is not needed once a cover is supplied — it is `nonempty_affineCoverMVSquare_of_curve`
that consumes it, i.e. the cover *production*, not the comparison. -/
theorem probeHModuleIff (S : C.left.AffineCoverMVSquare) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) 1) ↔
      Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
  Scheme.subsingleton_hModule_one_moduleKSheaf_baseChangeField_iff κ S

/-- Synthesis site: the cover-discharged form.  This is the one that matters — it binds only the
three curve hypotheses, so the whole `AffineCoverMVSquare` production runs here. -/
theorem probeIffCurve :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) 1) ↔
      Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
  subsingleton_hModule_one_baseChangeField_iff_curve C κ

/-! ### §3 the producer and the `UniformVanishing` instance -/

/-- Synthesis site: the producer for `UniformBaseDivisor`. -/
theorem probeProducer
    (h : letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
         Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1)) :
    UniformBaseDivisor C 0 :=
  uniformBaseDivisor_zero_of_subsingleton C h

/-- Synthesis site: the first `UniformVanishing` instance. -/
theorem probeUniformVanishing
    (h : letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
         Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1)) :
    UniformVanishing C :=
  uniformVanishing_of_subsingleton_h1 C h

/-! ### Negative controls -/

/-- **Control 1** — must report `sorryAx`.  Guards against a probe that reads clean because it
measured nothing.  Stated in the *same shape* as the real probes (returns its statement) so it
tests the same measurement path they use. -/
theorem probeControlOne :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) := sorry

/-- **Control 2** — must report `sorryAx`.  A control living in the *same* section, under the same
binders, so it also confirms the binder block itself is not what launders the reading. -/
theorem probeControlTwo : UniformBaseDivisor C 37 := sorry

end Synthesis

/-! ## The readings -/

#print axioms probeFaithfullyFlat
#print axioms probeH1CokIff
#print axioms probeHModuleIff
#print axioms probeIffCurve
#print axioms probeProducer
#print axioms probeUniformVanishing

-- The two consumed statements this file's results are composed with, measured here too so the
-- report does not have to cite another script for them.
#print axioms AlgebraicGeometry.Scheme.h1CokₗBaseChangeField
#print axioms AlgebraicGeometry.Scheme.genus_baseChangeField
#print axioms AlgebraicGeometry.genus_baseChangeField_curve
#print axioms AlgebraicGeometry.uniformVanishing_of_uniformBaseDivisor_curve
#print axioms AlgebraicGeometry.Scheme.divisorSheafZeroIso
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cokₗ_unit
#print axioms AlgebraicGeometry.nonempty_affineCoverMVSquare_of_curve

-- CONTROLS: these two MUST print sorryAx.  If they do not, the probe is broken, not clean.
#print axioms probeControlOne
#print axioms probeControlTwo
