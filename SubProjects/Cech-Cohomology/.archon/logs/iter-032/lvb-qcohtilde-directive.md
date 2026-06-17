# Lean-vs-blueprint check (one file)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(Relevant blocks: `lem:isLocalizedModule_of_span_cover`, `lem:qcoh_localized_sections`,
`lem:exists_finite_basicOpen_subcover`, `lem:qcoh_iso_tilde_sections` and the conditional/presentation forms.)

Report bidirectionally:
(a) Lean -> blueprint: does the landed `isLocalizedModule_of_span_cover` match `lem:isLocalizedModule_of_span_cover`
    (signature: g : M ->ₗ[R] N, f : R, s : Fin n -> R with Ideal.span (Set.range s) = ⊤, per-j hypothesis is
    IsLocalizedModule (powers f) of the (powers (s j))-localised map, conclusion IsLocalizedModule (powers f) g)?
    The 6-7 `private` helpers (exists_sum_pow_eq_one, mem_range_of_span_pow, eq_zero_of_span_pow, map_smul_endFun,
    bump_eq, per_j_surj, per_j_eq) have no blueprint blocks — confirm they are genuine proof-internal helpers.
(b) blueprint -> Lean: is the chapter detailed enough to have guided this formalization? Flag any thinness.
