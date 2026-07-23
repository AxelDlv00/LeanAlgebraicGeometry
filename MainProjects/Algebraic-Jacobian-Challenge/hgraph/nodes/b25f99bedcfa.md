---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.descent_overlap_agree
docstring: '**Overlap agreement for the surjectivity field.**  If a section `br` on
  `D(r)` satisfies the

  normalized identity `ρ[D(r), D(f) ⊓ D(r)] br = f^N • (y|_{D(f) ⊓ D(r)})`, then for
  any open

  `U ≤ D(r)` its restriction to `U`, pushed down to `D(f) ⊓ U`, equals `f^N • (y|_{D(f)
  ⊓ U})`.

  Specializing `U` to an overlap `D(r) ⊓ D(r'')` shows the normalized sections of
  two cover members

  agree there after restriction to `D(f) ⊓ (D(r) ⊓ D(r''))`, which (via the per-overlap
  localization)

  makes a common `f`-power glue them.  Project-local bookkeeping for `descent_surj`.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.descent_overlap_agree
type: lean
updated: '2026-07-24T03:02:11'
---
private lemma descent_overlap_agree {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R) (r : R)
    (N : ℕ) (U : (Spec R).Opens) (hUr : U ≤ PrimeSpectrum.basicOpen r)
    (y : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op (PrimeSpectrum.basicOpen f))))
    (br : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op (PrimeSpectrum.basicOpen r))))
    (hbr : ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen r)).op).hom br
        = f ^ N • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen f)).op).hom y)) :
    ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ U ≤ U)).op).hom
      (((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hUr).op).hom br)
    = f ^ N • (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ U
          ≤ PrimeSpectrum.basicOpen f)).op).hom y) := by
  have hCB : PrimeSpectrum.basicOpen f ⊓ U
      ≤ PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r := inf_le_inf_left _ hUr
  have e1 := res_comp (modulesSpecToSheaf.obj M)
      (A := PrimeSpectrum.basicOpen r) (B := U) (C := PrimeSpectrum.basicOpen f ⊓ U)
      hUr inf_le_right (inf_le_right.trans hUr) br
  have e2 := res_comp (modulesSpecToSheaf.obj M) (A := PrimeSpectrum.basicOpen r)
      (B := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r)
      (C := PrimeSpectrum.basicOpen f ⊓ U) inf_le_right hCB (inf_le_right.trans hUr) br
  have e3 := res_comp (modulesSpecToSheaf.obj M) (A := PrimeSpectrum.basicOpen f)
      (B := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r)
      (C := PrimeSpectrum.basicOpen f ⊓ U) inf_le_left hCB inf_le_left y
  have hms := LinearMap.map_smul ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hCB).op).hom
      (f ^ N) (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
          ≤ PrimeSpectrum.basicOpen f)).op).hom y)
  exact e1.trans (e2.symm.trans ((congrArg _ hbr).trans (hms.trans (congrArg (f ^ N • ·) e3))))