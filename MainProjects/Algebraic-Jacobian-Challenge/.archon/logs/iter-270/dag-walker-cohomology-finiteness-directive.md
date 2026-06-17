# DAG Walker Directive

## Slug
cohomology-finiteness

## Seed
thm:Scheme_module_finite_gammaObj_of_isProper

## Strategy context
This cone is the finiteness engine behind the curve's cohomology: H⁰ and H¹ of
the structure sheaf (as a sheaf of k-modules) are finite-dimensional over the
base field k. It backs the genus computation and the properness/Riemann–Roch
lanes (`thm:Scheme_module_finite_globalSections_of_isProper` feeds genusZero +
witness body). The chapter "Sheaves of k-modules: sheafification, Ext, and the
structure sheaf as a sheaf of k-modules" (file
`Cohomology_StructureSheafModuleK.tex`) plus `Cohomology_FlatBaseChange.tex`.

## Depth / scope
Walk the whole cone of the seed across `Cohomology_StructureSheafModuleK.tex` and
`Cohomology_FlatBaseChange.tex`. Your PRIMARY job is **dependency
transcription**: the chapter has 68 labelled blocks but only 17 `\uses{}` edges,
so the finiteness theorems are isolated (no edges in or out) even though their
mathematics plainly chains together. Make the cone honestly wired.

### Isolated nodes that must be wired into the cone (add the `\uses{}` edges that
their mathematics actually realises — both the intra-chapter chain AND the edge
from each consumer down to them):
- def:Scheme_cechCochain_OC, def:Scheme_cechCohomology_OC
- def:Scheme_cechCochain, thm:Scheme_cechCochain_OC_eq, thm:Scheme_cechCohomology_OC_eq
- thm:Scheme_module_finite_HModule_prime_zero
- thm:Scheme_module_finite_HModule_zero_curve, thm:Scheme_module_finite_HModule_prime_zero_curve
- thm:Scheme_module_finite_HModule_prime_of_isAffineHModuleVanishing
- thm:Scheme_IsAffineHModuleHomFinite
- thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite
- thm:Scheme_module_finite_HModule_prime_of_affine
- thm:Scheme_module_finite_HModule_prime_of_affine_curve
- thm:Scheme_IsHModuleHomFinite
- thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite
- thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite_curve
- thm:Scheme_module_finite_gammaObj_of_isProper (the seed)
- lemma:Adjunction_left_adjoint_linear, lemma:Adjunction_right_adjoint_linear
- def:Adjunction_homLinearEquiv, def:Scheme_homFromOne_linearEquiv
- inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf

For each, read its statement + proof on disk, determine exactly which other
blueprint blocks its mathematics relies on, and add those to its `\uses{}`. Read
the proof of each *_curve / *_of_isProper / *_of_affine theorem: it specialises
or assembles the more primitive finiteness lemmas — declare those edges. These
are all already proved sorry-free in Lean, so their effort is 0; the ONLY defect
is the missing wiring. Do NOT rewrite their statements or proofs.

### Gap nodes in `Cohomology_FlatBaseChange.tex` that need a `\lean{}` pin:
- lem:base_change_map_affine_local
- lem:pushforward_base_change_mate_cancelBaseChange
For each, check the covered Lean file for a real declaration name; if one exists,
pin `\lean{<real.name>}`. If no Lean declaration exists yet (it is a blueprint
decomposition step), pin a placeholder `\lean{AlgebraicGeometry.TODO.<label>}`
per DAG integrity rule 1 — never leave it unpinned. Also wire these two into the
cone via `\uses{}` (they depend on the flat-base-change machinery in their own
chapter and feed the higher-direct-image results).

## Out of scope
Do NOT touch remark blocks (`rem:`/`rmk:`) — they are exempt from wiring. Do NOT
add `\leanok`. Do NOT edit statements/proofs of the already-proved finiteness
theorems beyond their `\uses{}` and (where missing) `\lean{}` lines.

## References
- `references/stacks-coherent.md` (tag 02KH, flat base change of Rⁱf_*) — for the
  FlatBaseChange blocks if a citation line is missing.
- `references/stacks-varieties.md` (tag 0BUG, H⁰(X,𝒪) finiteness) — for the
  global-sections finiteness blocks if a citation line is missing.
Only add/adjust citation lines where a block derived from these sources lacks one;
do not rewrite existing well-cited prose.
