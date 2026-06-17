# Blueprint-reviewer directive — slug `iter033`

Whole-blueprint audit (read all chapters under `blueprint/src/chapters/`). Per-chapter
completeness + correctness checklist as usual.

## Gate decisions I need from you this iter
I am about to dispatch provers at these targets — give an explicit complete+correct verdict and any
must-fix-this-iter findings for the blocks backing them (all in the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`):

1. **`lem:toSheaf_preservesFiniteColimits`** (NEW this iter, `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}`)
   and **`lem:to_sheaf_preserves_epi`** (`\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}`,
   proof rewritten this iter to the sheafification-square / `PreservesFiniteColimits` route — the
   previous "left adjoint" proof was wrong). Also the downstream **`lem:affine_surj_of_vanishing`**
   and **`def:affine_cover_system`** that consume them. → backs prover lane on `AffineSerreVanishing.lean`.

2. **`lem:tilde_preserves_kernels`** (`\lean{AlgebraicGeometry.tildePreservesFiniteLimits}`,
   stalkwise-flatness informal proof written iter-032, NOT yet gate-reviewed). → backs a NEW prover
   lane on `TildeExactness.lean` (file to be scaffolded). Is the informal proof detailed and correct
   enough to formalize (stalk of `~M = M_𝔭`, localization flat/exact, kernels checked on stalks)?

Confirm whether each block is `complete: true` + `correct: true` with no must-fix, or flag the
specific gap. Also: per the dispatcher fast-path, your verdict on these blocks this iter decides
whether the provers run now or wait.

## Known-deferred (do not block on these; just confirm they are honestly marked)
- `lem:isQuasicoherent_restrict_basicOpen` (P1a) — geometry infra absent from Mathlib, scheduled for
  an effort-breaker next iter; not dispatched this iter.
- The two protected/superseded sorries (`CechHigherDirectImage.lean`, `CechAcyclic.lean`).
