# Directive — blueprint-reviewer `iter034b` (HARD GATE, whole blueprint)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). This is the gate-clearance review for the
iter-034 prover dispatch. Several chapters were edited this iter and have NOT been reviewed since:

## Chapters feeding live prover lanes this iter (gate these)
1. `Cohomology_FlatBaseChange.tex` (covers `FlatBaseChange.lean` + `FlatBaseChangeGlobal.lean`) — the
   **conjugate-side re-encoding** of `lem:base_change_mate_codomain_read_legs` and the downstream
   `lem:base_change_mate_fstar_reindex_legs` family (FBC-A lane), plus the H⁰-as-equalizer chain and the
   `LinearMap.tensorEqLocusEquiv`-fed eqLocus blocks (FBC-B lane). Confirm: (a) the re-encoded
   codomain-read-legs block is mathematically coherent and the `_legs` coherence is expressible as a
   `conjugateEquiv`-component identity (no positional-rewrite dependence); (b) the FBC-B equalizer chain
   is correct and `lem:flat_preserves_equalizer_mathlib`'s `\lean{LinearMap.tensorEqLocusEquiv}` pin is a
   real Mathlib decl (it is — confirmed via loogle in `Mathlib.RingTheory.Flat.Equalizer`).
2. `Picard_QuotScheme.tex` (covers `QuotScheme.lean` + `GradedHilbertSerre.lean`) — 3 new coverage blocks
   `def:over_restrict_unit_iso`, `def:over_restrict_presentation`,
   `def:presentation_pullback_iota_of_quasicoherentData`, wired into the P1 keystone
   `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`. Confirm complete + correct.
3. `Picard_GrassmannianCells.tex` (covers `GrassmannianCells.lean`) — 6 new `sec:gr_separated` coverage
   blocks (the surjective restricted-diagonal comorphism + `pullbackιIso`), wired into `lem:gr_separated`.
   Confirm complete + correct.

## Also re-audit (edited by the interrupted phase, not gating provers this iter)
`Picard_FlatteningStratification.tex` and `Picard_RelativeSpec.tex` were substantially expanded; report
their state but they do NOT gate a prover this iter (GF is gap1-gated; RelativeSpec is deep/blocked).

## Output
Your standard per-chapter checklist (`complete` / `correct` / must-fix-this-iter). For each of the three
gating chapters give an explicit verdict so the plan agent can clear or defer each prover lane. Flag any
broken `\uses{}`, fake/placeholder `\lean{}` pins, or proof prose too thin to formalize. Note: several
keystone `\lean{}` pins (`isIso_fromTildeΓ_restrict_basicOpen`, `Grassmannian.isSeparated`) name decls
that do NOT yet exist in Lean — that is expected (they are this iter's build targets), not a defect.
