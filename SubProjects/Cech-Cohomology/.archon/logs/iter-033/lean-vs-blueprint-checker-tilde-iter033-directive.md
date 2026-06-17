# Directive: verify TildeExactness.lean against its blueprint

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter declares `% archon:covers ... QcohTildeSections.lean` and is the
blueprint home for the tilde-exactness material; the relevant blocks are
`lem:tilde_preserves_kernels` at ~L4216 pinning `AlgebraicGeometry.tildePreservesFiniteLimits`,
plus the surrounding Route-P P3 prose).

## What to check (bidirectional)
1. Lean → blueprint: the file delivers THREE axiom-clean theorems —
   `tilde_preservesFiniteColimits` (`:= inferInstance`),
   `tilde_toStalk_map_injective` (`IsLocalizedModule.map_injective` application), and
   `tilde_preservesFiniteLimits_of_preservesKernels` (reduction wrapper via
   `Functor.preservesFiniteLimits_of_preservesKernels`). Are these GENUINE (not placeholder /
   vacuous / circular)? In particular: is `tilde_preservesFiniteLimits_of_preservesKernels`
   non-vacuous given its hypothesis `H` is consumed by typeclass resolution? Is
   `tilde_toStalk_map_injective` actually stating injectivity of the localized stalk map (not a
   trivial restatement)?
2. The NAMED target `AlgebraicGeometry.tildePreservesFiniteLimits` (the blueprint pin of
   `lem:tilde_preserves_kernels`) is DELIBERATELY ABSENT from the Lean file — the prover stopped
   on two stated obstructions (Ab-stalk germ-naturality transport; missing categorical
   "right-exact + preserves-monos ⟹ left-exact" lemma). Confirm the blueprint's `% NOTE` at
   ~L4241 honestly records this absence and that no `\leanok` falsely claims the named target is
   done.
3. blueprint → Lean: is the chapter's informal proof detailed enough to guide the eventual
   formalization of the named target, or is it too thin? Flag if inadequate.

Report must-fix-this-iter findings explicitly. Output to your task_results file.
