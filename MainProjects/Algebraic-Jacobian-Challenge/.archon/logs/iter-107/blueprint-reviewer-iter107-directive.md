# Blueprint Reviewer Directive

## Slug
iter107

## Strategy snapshot

Project end-state: complete the nine declarations in `archon-protected.yaml`
(`Genus`, `Jacobian`, `ofCurve`, four `Jacobian` instances, `AbelJacobi`)
following Christian Merten's challenge.

Phase split:
- **Phase A — Čech acyclicity** (`BasicOpenCech.lean`): 6 syntactic sorries
  remaining. The iter-107 (Archon iter-107) substantive prover lane will close
  `h_loc_exact` at `BasicOpenCech.lean:L1802` via the mathlib-analogist Q1
  ALIGN_WITH_MATHLIB recipe (per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen`
  + `IsLocalizedModule.pi` + `IsLocalizedModule.iso` +
  `Function.Exact.iff_of_ladder_linearEquiv`, ~100-110 LOC bounded). The L1120
  `cechCofaceMap_pi_smul` lane stays PAUSED.
- **Phase B — Cotangent sheaves** (`Differentials.lean`): 5 sorries. OFF-LIMITS
  this iter (Mathlib-gap-blocked routes deferred per `h_exact` policy).
- **Phase C0** — `instIsMonoidal_W` (Modules/Monoidal.lean L173): Mathlib gap.
- **Phase C1 — LineBundle refactor** scheduled iter-109+ pending iter-107 outcome.
- **Phase C2 — PicardFunctor re-derivation** after C1.
- **Phase C3 — DEFERRED via JacobianWitness exit policy** (Hilbert/Quot
  schemes + finite-group scheme quotients absent from Mathlib b80f227).
- **Phases D, E** content-level BLOCKED-ON-C3-WITNESS; file-level closed.

## Routes

Single primary route this iter: close `h_loc_exact` at
`BasicOpenCech.lean:L1802`. The mathlib-analogist's recipe lives in
`analogies/finite-product-localisation-and-cech-r-linearity.md` (Q1 +
Q2 paths). The corresponding chapter is
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` (Čech-acyclicity
section).

## References

- `references/challenge.lean`: original AI challenge file by Christian Merten —
  the authoritative formal statement of the missing definitions and theorems
  for the Jacobian of an algebraic curve. The Lean skeleton in
  `AlgebraicJacobian/` is a decomposition of this file; signatures here are
  frozen and listed in `archon-protected.yaml`.

## Focus areas (optional)

- `Cohomology_MayerVietoris.tex` — does the Čech-acyclicity prose adequately
  cover the L1802 `h_loc_exact` step? The prover this iter will execute the
  4-step analogist recipe inline (per-coord `IsLocalization.Away` +
  `IsLocalizedModule.pi` + `IsLocalizedModule.iso` + ladder transport).
  Is the prose clear that this exactness is a *local-to-global* application
  (`exact_of_localized_span`) and the local step is the analogist's recipe?
- All other chapters are downstream of Phase A this iter; standard read.

## Known issues

- `Cohomology_StructureSheafModuleK.tex:474` typo fix (`thm:` → `def:` for
  `Scheme_toModuleKSheaf`) landed last iter — should be clean.
- `Differentials.tex` is `complete: partial` (3 auxiliary lemmas without
  `\leanok` — `lem:sheafOfModules_exact_iff_stalkwise`,
  `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:derivation_postcomp_comp`).
  These are honest Mathlib-gap deferrals; no operational impact this iter
  since Phase B is OFF-LIMITS. Do not flag this as must-fix-this-iter
  unless you find a new structural issue.
- `Picard_LineBundle.tex` carries a "Lean-state status note" indicating
  the Lean side's `CommRing.Pic`-based approximation. Phase C1 will rewrite
  this; the note is the iter-105 disclosure. Not must-fix-this-iter.
