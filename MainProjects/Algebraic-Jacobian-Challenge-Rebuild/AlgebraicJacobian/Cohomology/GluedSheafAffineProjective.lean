/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.GluedSheafExtraction
import AlgebraicJacobian.Cohomology.GluedSheafModule
import AlgebraicJacobian.Cohomology.GluedSheafClass

/-!
# Finite projective sections of a cocycle-glued line bundle on an affine open

The cocycle pieces used to construct `gluedSheaf` need not contain an arbitrary affine
open.  Nevertheless, every affine open admits a finite basic-open refinement subordinate
to the canonical pointed cover by those pieces.  On each refined basic open the glued
sheaf is free of rank one.  The existing localization-span engine then proves that its
sections on the original affine open are finite projective.

`BasicOpenCocycleDatum.AffineSectionsModel` packages the quasi-coherent action chosen by
that internal refinement together with the finite and projective instances.  Returning a
`Nonempty` model keeps the refinement choice noncomputable while giving downstream code a
single datum from which it can install all three compatible instances.

This is the chart-free line-bundle substrate needed to restrict a positive theta twist to
the arbitrary affine pieces of `AffAdaptation`: the divisor cover is not required to lie in
either pinned theta chart.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

/-- A compatible quasi-coherent module structure on the sections of a cocycle-glued
line bundle over an affine open, together with its finite projective properties.

The module instance is written explicitly in the fields so that it is definitionally the
one induced by `qcoh`; a consumer may install `M.qcoh` and recover `M.finite` and
`M.projective` without any proof-irrelevance transport. -/
structure AffineSectionsModel (D : BasicOpenCocycleDatum C B pi)
    (V : (relCurve C B).Opens) where
  qcoh : Scheme.QcohOn D.sheaf V
  finite : @Module.Finite Γ(relCurve C B, V) (D.sheaf.obj.obj (op V))
    _ _ (@Scheme.QcohOn.moduleOfLE B _ (relCurve C B) V D.sheaf qcoh V (le_refl V))
  projective : @Module.Projective Γ(relCurve C B, V) _
    (D.sheaf.obj.obj (op V)) _
    (@Scheme.QcohOn.moduleOfLE B _ (relCurve C B) V D.sheaf qcoh V (le_refl V))

/-- Sections of a cocycle-glued line bundle on every affine open admit a compatible
finite projective module model.  The proof chooses a finite basic-open refinement of the
canonical pointed cover by cocycle pieces, installs `gluedQcohOn`, and applies the
localization-span finiteness and projectivity theorems. -/
theorem nonempty_affineSectionsModel (D : BasicOpenCocycleDatum C B pi)
    (V : (relCurve C B).Opens) (hV : IsAffineOpen V) :
    Nonempty (D.AffineSectionsModel V) := by
  classical
  obtain ⟨ι, fint, f, anchor, coeff, hP, hpart⟩ :=
    hV.exists_finite_basicOpen_refinement D.pointedCover
  letI : Fintype ι := fint
  let sigma : ι → D.index := fun i => D.pieceIndex (anchor i)
  have hP' : ∀ i : ι, (relCurve C B).basicOpen (f i) ≤ D.pieces (sigma i) := hP
  have hcov : V ≤ ⨆ i : ι, (relCurve C B).basicOpen (f i) :=
    le_iSup_basicOpen_of_sum_eq_one coeff f hpart
  let q : Scheme.QcohOn D.sheaf V :=
    gluedQcohOn B D.pieces D.unit D.isGluingCocycle hP' hcov
  letI : Scheme.QcohOn D.sheaf V := q
  let m : Module Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) :=
    Scheme.QcohOn.moduleOfLE (F := D.sheaf) (le_refl V)
  have hfin : @Module.Finite Γ(relCurve C B, V) (D.sheaf.obj.obj (op V)) _ _ m :=
    moduleFinite_glued B D.pieces D.unit hV D.isGluingCocycle
      (fun _ _ _ => rfl) hP'
      (Ideal.span_range_eq_top_of_sum_eq_one coeff f hpart)
  have hproj : @Module.Projective Γ(relCurve C B, V) _
      (D.sheaf.obj.obj (op V)) _ m :=
    projective_glued B D.pieces D.unit hV D.isGluingCocycle
      (fun _ _ _ => rfl) hP'
      (Ideal.span_range_eq_top_of_sum_eq_one coeff f hpart)
  exact ⟨⟨q, hfin, hproj⟩⟩

end BasicOpenCocycleDatum

end AlgebraicGeometry
