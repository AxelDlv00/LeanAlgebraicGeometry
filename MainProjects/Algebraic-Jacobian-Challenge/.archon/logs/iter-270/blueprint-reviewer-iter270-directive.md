# Blueprint Reviewer Directive (iter-270, DAG phase)

Perform your standard whole-blueprint audit (per-chapter completeness +
correctness checklist, Lean-target well-formedness, multi-route coverage,
STRATEGY phase coverage, and the `### Dependency & isolation findings` section).

This iteration's DAG work was a **dependency-transcription pass**: four
`dag-walker`s added ~50 `\uses{}` edges and pinned the 16 previously-unpinned
non-remark gap declarations across these chapters:
- `Cohomology_StructureSheafModuleK.tex`, `Cohomology_FlatBaseChange.tex`
- `Picard_TensorObjSubstrate.tex`, `Picard_RelPicFunctor.tex`
- `Picard_QuotScheme.tex`, `Picard_FlatteningStratification.tex`
- `Albanese_CodimOneExtension.tex`, `Albanese_Thm32RationalMapExtension.tex`,
  `RigidityKbar.tex`
No proven statements/proofs were rewritten.

## Specific adjudications requested in your `### Dependency & isolation findings`

Tag each of the following `wire-up` (name the missing edge), `remove` (justify),
or `keep` (justify why honestly isolation-exempt):

1. **Duplicate label `rational_map_to_av_extends`.** Two blocks carry the SAME
   `\lean{}` pin `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`:
   - `thm:rational_map_to_av_extends` (`Albanese_Thm32RationalMapExtension.tex`)
     — wired, used by `thm:albanese_universal_property`.
   - `lem:rational_map_to_av_extends` (`AbelianVarietyRigidity.tex` ~L764) —
     isolated, a Route-A retained copy. Two nodes pinned to one Lean decl is a
     defect; advise whether to `remove` the `lem:` duplicate.

2. **Descoped (S3) substeps** `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`
   and `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`
   (`RigidityKbar.tex`). The cohomology/rigidity walkers found these are the
   "path (b)" substeps of `lem:constants_integral_over_base_field`, which the
   iter-152 alg-closed pivot rewrote to "path (a)" — the live proof invokes
   neither, so they are honestly orphaned, UNPROVED, retained as general-over-k
   Mathlib-PR fodder. Advise `remove` vs `keep`.

3. **By-design supplement** `lem:isiso_sheafification_map_of_W`
   (`Picard_TensorObjSubstrate.tex`) — the substrate walker reports it is a
   superseded standalone supplement with no consuming block. Advise `remove` vs
   `keep`.

4. **Stale-pin abandoned cluster** in `Cohomology_StructureSheafModuleK.tex`:
   `thm:Scheme_IsAffineHModuleHomFinite`,
   `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`,
   `thm:Scheme_module_finite_HModule_prime_of_affine`,
   `thm:Scheme_module_finite_HModule_prime_of_affine_curve`. The cohomology
   walker found their `\lean{}` pins point to DELETED Lean declarations (the
   per-affine-open Hom-finiteness approach abandoned per
   `StructureSheafModuleK/Carriers.lean:28`, because Γ(U,𝒪)=k[t] is
   ∞-dimensional). They wrongly still carry `\leanok`. The live engine uses the
   wholespace carrier `thm:Scheme_IsHModuleHomFinite` instead. Advise whether to
   `remove` these four, or `keep` + repin to a TODO placeholder (the walker added
   `% NOTE` flags but did not touch the pins/`\leanok`).

Your `remove`/`keep`/`wire-up` tags gate the next writer pass; be decisive.
