# Lean↔blueprint check — CechTermAcyclic.lean

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechTermAcyclic.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated; relevant blocks: lem:cech_term_pushforward_acyclic @11636, lem:rightAcyclic_finite_prod)

## Check
- Does the Lean `cechTerm_pushforward_acyclic` (CechTermAcyclic.lean:699) signature match its blueprint statement? Lean now carries `[S.IsSeparated]` + `hres : ∀ σ, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules`; the blueprint (≈L11645) states only "f separated and quasi-compact". Flag the missing S-separated / affine-diagonal hypothesis and the `hres` caveat as a blueprint-correctness gap (blueprint statement currently FALSE without it).
- Are the 17 new helper decls (overOpens*, presentation*, modulesOverOpensEquivalence, isQuasicoherent_pullback_opens, etc.) backed by blueprint entries, or missing (coverage debt)?
- Any fake/placeholder statements.
