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
it with the original Picard functor is a separate mathematical step. The categorical image
of the Abel map is the effective quotient of its kernel pair in the category of etale sheaves.
No Scheme representability conclusion is asserted in this module.
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

/-! ## The effective image quotient in etale sheaves -/

/-- The image sheaf of the concrete admissible Abel map. -/
noncomputable abbrev admissibleAbelEtaleImage :
    Sheaf Scheme.etaleTopology.{u} (Type (u + 1)) :=
  Sheaf.image (admissibleAbelEtaleSheafMap C)

/-- The canonical epimorphism from the admissible divisor source to the Abel image sheaf. -/
noncomputable abbrev admissibleAbelEtaleToImage :
    Scheme.etaleTopology.uliftYoneda.{u + 1}.obj
        (divRepAffAdmissibleScheme C).left ⟶
      admissibleAbelEtaleImage C :=
  Sheaf.toImage (admissibleAbelEtaleSheafMap C)

/-- The kernel pair of the map onto the Abel image is the pullback kernel pair of the original
concrete Abel sheaf map. -/
noncomputable def admissibleAbelEtaleImageKernelPair :
    IsKernelPair (admissibleAbelEtaleToImage C)
      (pullback.fst (admissibleAbelEtaleSheafMap C)
        (admissibleAbelEtaleSheafMap C))
      (pullback.snd (admissibleAbelEtaleSheafMap C)
        (admissibleAbelEtaleSheafMap C)) := by
  have hbig : IsKernelPair
      (admissibleAbelEtaleToImage C ≫
        Sheaf.imageι (admissibleAbelEtaleSheafMap C))
      (pullback.fst (admissibleAbelEtaleSheafMap C)
        (admissibleAbelEtaleSheafMap C))
      (pullback.snd (admissibleAbelEtaleSheafMap C)
        (admissibleAbelEtaleSheafMap C)) := by
    rw [Sheaf.toImage_ι]
    exact IsKernelPair.of_hasPullback (admissibleAbelEtaleSheafMap C)
  exact hbig.cancel_right_of_mono

/-- The Abel image sheaf is the effective coequalizer of the original concrete Abel kernel
pair. This is the sheaf-level quotient; representability of the relation and quotient by
schemes is a separate step. -/
noncomputable def admissibleAbelEtaleImageCoequalizer :
    IsColimit (Cofork.ofπ (admissibleAbelEtaleToImage C)
      (admissibleAbelEtaleImageKernelPair C).w) := by
  haveI : IsRegularEpi (admissibleAbelEtaleToImage C) :=
    IsRegularEpiCategory.regularEpiOfEpi _
  exact (admissibleAbelEtaleImageKernelPair C).toCoequalizer'

end AlgebraicGeometry
