/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0AdmissibleAbelKernel
import Mathlib.AlgebraicGeometry.Sites.Proetale
import Mathlib.CategoryTheory.Sites.LocallyBijective
import Mathlib.CategoryTheory.Sites.RegularEpi

/-!
# The admissible Abel map after big-etale sheafification

The big etale site of `Scheme.{u}` requires type-valued sheafification in `Type (u + 1)`.
This module therefore applies `ULift` to the concrete admissible Abel transformation before
sheafifying it. Subcanonicity identifies the sheafified source with the actual representable
Yoneda sheaf of `divRepAffAdmissibleScheme C`.

The target here is deliberately the etale sheafification of `pic0SigmaFunctor C`; identifying
it with the original Picard functor is a separate mathematical step. No effective quotient or
representability conclusion is asserted in this module.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

/-! ## Subcanonicity of the big etale site -/

/-- The big etale topology on schemes is subcanonical. -/
instance Scheme.subcanonical_etaleTopology : Scheme.etaleTopology.{u}.Subcanonical :=
  GrothendieckTopology.Subcanonical.of_le Scheme.etaleTopology_le_proetaleTopology

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

/-! ## The sheafified concrete Abel map -/

/-- The big-etale sheafification of the universe-raised Picard Sigma presheaf. -/
noncomputable abbrev pic0SigmaEtaleSheafification :
    Sheaf Scheme.etaleTopology.{u} (Type (u + 1)) :=
  (presheafToSheaf Scheme.etaleTopology (Type (u + 1))).obj
    (pic0SigmaFunctor C ⋙ uliftFunctor.{u + 1})

/-- Subcanonicity identifies the universe-raised Yoneda sheaf of the admissible divisor
representer with the sheafification of its underlying representable presheaf. -/
noncomputable def admissibleAbelEtaleSourceIso :
    Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
        (divRepAffAdmissibleScheme C).left ≅
      (presheafToSheaf Scheme.etaleTopology (Type (u + 1))).obj
        (yoneda.obj (divRepAffAdmissibleScheme C).left ⋙ uliftFunctor.{u + 1}) :=
  (asIso ((sheafificationAdjunction Scheme.etaleTopology (Type (u + 1))).counit.app
    (Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
      (divRepAffAdmissibleScheme C).left))).symm

/-- The concrete admissible Abel transformation as a morphism from its representable
big-etale Yoneda source to the sheafification of the Picard Sigma presheaf. -/
noncomputable def admissibleAbelEtaleSheafMap :
    Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
        (divRepAffAdmissibleScheme C).left ⟶
      pic0SigmaEtaleSheafification C :=
  (admissibleAbelEtaleSourceIso C).hom ≫
    (presheafToSheaf Scheme.etaleTopology (Type (u + 1))).map
      (Functor.whiskerRight (abelSigmaChartAffAdmissible C) uliftFunctor.{u + 1})

end AlgebraicGeometry
