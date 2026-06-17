Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: (1) Blueprint the module-level pullback base-change transport infra that `def:scheme_modules_glue` (C2) needs; (2) add coverage-debt blocks for three prover-created helpers.

Context: `Scheme.Modules.glue` currently carries only cocycle hyp C1; C2 (triple-overlap multiplicativity) cannot be stated/closed without a module-level pullback base-change transport along the glue datum's `t_fac`/`t'`. A naive `eqToHom` formulation is ill-typed (whnf runaway). The correct shape is `pullbackComp`-style base-change isos for the `Scheme.Modules.pullback` pseudofunctor.

(1) Add a `\uses`-linked group of blocks (Archon-original — NO external source lines):
  - `def:modules_pullbackComp` / `lem:modules_pullback_comp_iso`: for composable scheme morphisms `a ≫ b`, the iso `(pullback (a ≫ b)).obj M ≅ (pullback a).obj ((pullback b).obj M)` for `Scheme.Modules.pullback`. State + one-paragraph proof (pseudofunctoriality of pullback on sheaves of modules; the witness already used elsewhere is `Scheme.Modules.pullbackComp`). Mark `\mathlibok` ONLY if it is literally a Mathlib/project re-export under that name — otherwise leave unmarked with an informal proof.
  - `lem:modules_pullback_basechange_transport`: transport of a transition iso `g_{ij}` across the glue-datum triangle `t_fac`/`t'` to a common triple overlap `pullback (f i j) (f i k)`, packaged so the three `g`'s land on the same sheaf. State the transport map and its coherence (one informal proof paragraph, mirroring the scheme-level `GlueData.t'`/`t_fac`/`cocycle` shape).
  - Restate C2 (`def:scheme_modules_glue` block) so its triple-overlap equation is expressed via the transport above; repoint `\uses{}` to the two new blocks. Keep C1 as-is.
(2) Coverage-debt blocks (1-to-1; trivial entries OK):
  - `lem:gr_scalarEnd_one` `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}`: `scalarEnd 1 = 𝟙`. \uses{def:gr_scalarEnd}. One-line proof.
  - `lem:gr_scalarEnd_zero` `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}`: `scalarEnd 0 = 0`. \uses{def:gr_scalarEnd}. One-line proof.
  - `lem:gr_chartQuotientMap_iFree` `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}`: the I-column of the universal matrix is the identity (`ιFree (orderIso k) ≫ u^I = ιFree k`). \uses{def:gr_universal_matrix, def:gr_scalarEnd, lem:gr_scalarEnd_one, lem:gr_scalarEnd_zero, lem:gr_universalMatrix_submatrix_self}. Short proof = the "I-minor is identity" step; this is the proof content of `lem:gr_chartQuotientMap_epi`.

Constraints: NEVER add `\leanok`. Edit only this chapter (+ references/** if a source is needed — unlikely, infra is Archon-original). Keep prose textbook-level, no Lean tactics. Under 1 page per new block.
