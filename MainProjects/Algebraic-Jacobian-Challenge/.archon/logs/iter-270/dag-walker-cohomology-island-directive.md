# DAG Walker Directive

## Slug
cohomology-island

## Seed
thm:Scheme_module_finite_gammaObj_of_isProper
(also walk: thm:Scheme_module_finite_globalSections_of_isProper)

## Strategy context
The genus is defined (Genus.tex, `def:genus`) as
`finrank k (Scheme.HModule k (toModuleKSheaf C) 1)`, i.e. the dimension of the
`k`-module sheaf cohomology of a smooth proper geometrically irreducible curve.
For this to be the intended invariant (and for the Jacobian's properness /
dimension theorems downstream), the project needs the finite-dimensionality of
`H^0`/`H'` of a coherent sheaf on a proper `k`-scheme — the entire
`Scheme.module_finite_*` / Čech-cohomology machinery in
`Cohomology_StructureSheafModuleK.tex`. That chapter is presently a
DISCONNECTED ISLAND: it has 68 labelled blocks but only 17 `\uses{}` edges, so
22 of its declarations are graph-isolated and the whole H⁰-finiteness apex is
not wired into the goal cone (`thm:exists_unique_ofCurve_comp` and the
`thm:Jacobian_*` family).

## Depth / scope
Walk UP from the two seed apex theorems through the **entire**
`Cohomology_StructureSheafModuleK.tex` finiteness/Čech chain, and connect the
apex DOWNWARD into its real consumer in `Genus.tex` (and any
`RiemannRoch_RRFormula.tex` / Jacobian properness block that legitimately
depends on H⁰-finiteness).

Your job is **dependency transcription** (completeness condition 3), not new
mathematics: every block in this chapter already has a statement and is (mostly)
proved sorry-free in Lean — the proofs/`\leanok` exist. What is missing is the
`\uses{}` edges between them and the incoming edge from the genus/properness
consumer. Read each block's statement+proof on disk and add the `\uses{}` it
actually relies on.

The following 22 blocks in `Cohomology_StructureSheafModuleK.tex` are currently
graph-isolated (no edge in or out) — each must end up wired (an outgoing
`\uses{}` to its real dependencies AND, where it is itself a dependency, an
incoming edge from the block that uses it):

- def:Scheme_cechCochain, def:Scheme_cechCochain_OC, def:Scheme_cechCohomology_OC
- thm:Scheme_cechCochain_OC_eq, thm:Scheme_cechCohomology_OC_eq
- thm:Scheme_module_finite_HModule_prime_zero
- thm:Scheme_module_finite_HModule_zero_curve
- thm:Scheme_module_finite_HModule_prime_zero_curve
- thm:Scheme_module_finite_HModule_prime_of_isAffineHModuleVanishing
- thm:Scheme_IsAffineHModuleHomFinite
- thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite
- thm:Scheme_module_finite_HModule_prime_of_affine
- thm:Scheme_module_finite_HModule_prime_of_affine_curve
- thm:Scheme_IsHModuleHomFinite
- thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite
- thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite_curve
- thm:Scheme_module_finite_gammaObj_of_isProper
- lemma:Adjunction_left_adjoint_linear, lemma:Adjunction_right_adjoint_linear
- def:Adjunction_homLinearEquiv, def:Scheme_homFromOne_linearEquiv
- inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf

Also, while in the Cohomology chapters, **pin the two unpinned (`needs \lean{}`)
lemmas** in `Cohomology_FlatBaseChange.tex` if they are part of this cone:
`lem:base_change_map_affine_local` and
`lem:pushforward_base_change_mate_cancelBaseChange`. If they already carry a real
Lean name in the source, use it; otherwise add a placeholder
`\lean{AlgebraicGeometry.TODO.<name>}` (integrity rule 1) and wire their
`\uses{}` to the base-change lemma(s) they build on.

**Out of scope:** do NOT touch the Rigidity, Albanese, Picard-substrate, or
RiemannRoch-WeilDivisor chapters (a sibling walker handles those). Do NOT add
`\leanok`. Do NOT rewrite existing proof prose — only add/correct `\uses{}`,
add `\lean{}` placeholders where missing, and (only if a genuinely missing
intermediate block is needed to make an edge resolve) add a minimal statement
block.

## References
- This chapter is project-internal cohomology infrastructure (Čech computation
  of `H^i`, finiteness of `H^0` on proper schemes). The relevant external anchor
  is Stacks tag **02KH** (flat base change / `H^0`) — see
  `references/stacks-coherent.md` — and the finiteness-of-cohomology-on-proper
  results. Cite verbatim from the local file only if you add or restate an
  externally-sourced block; pure `\uses{}` transcription needs no new citation.
