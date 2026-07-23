---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.SectionCechModule.map_dDiff_eq_locDiff
docstring: '`IsLocalizedModule.map` of `dDiff` is the bundled localised differential

  `locDiff` — by `IsLocalizedModule.ext`, the comparison reducing to `locDiff_fLoc`.

  Stated for an arbitrary away element `a` (with `s r = a`) so the spanning-element

  bookkeeping in `dDiff_exact` needs no `↑ρ`-rewrite inside the localised map.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SectionCechModule.map_dDiff_eq_locDiff
type: lean
updated: '2026-07-24T03:02:09'
---
lemma map_dDiff_eq_locDiff (r : ι) (m : ℕ) {a : R}
    [IsLocalizedModule (Submonoid.powers a) (fLoc s M r m)]
    [IsLocalizedModule (Submonoid.powers a) (fLoc s M r (m + 1))] :
    IsLocalizedModule.map (Submonoid.powers a) (fLoc s M r m) (fLoc s M r (m + 1))
        (dDiff s M m) = locDiff s M r m := by
  apply IsLocalizedModule.ext (Submonoid.powers a) (fLoc s M r m)
    (fun x => IsLocalizedModule.map_units (fLoc s M r (m + 1)) x)
  apply LinearMap.ext; intro t
  rw [LinearMap.comp_apply, LinearMap.comp_apply, IsLocalizedModule.map_apply, locDiff_fLoc]