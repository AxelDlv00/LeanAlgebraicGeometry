# Iter 050 — Review (Quot-Foundations)

## Verdict
**CONVERGING (GF) + new leaf landed (GR-quot) — +8 axiom-clean decls.** GF seam-1 MAKE-OR-BREAK gate
CLEARED: `gf_localGenerators_restrict` (1a) + assembly `gf_finiteType_affine_finite_cover_generated` both
axiom-clean via the predicted `overRestrictPullbackIso` route, on a new reusable engine
`GeneratingSections.map`/`map_I`/`map_isFiniteType`. GR-quot: NEW GrassmannianQuot.lean root-imported,
3 axiom-clean (`globalUnitSection`/`scalarEnd`/`chartQuotientMap`, biproduct.matrix route) + 5 planner
scaffolds. lean_verify on `gf_localGenerators_restrict`/`gf_finiteType_affine_finite_cover_generated`/
`chartQuotientMap`: all `{propext, Classical.choice, Quot.sound}`. Build GREEN (both lanes).
blueprint-doctor **0 findings**. dag gaps=0. sync_leanok (iter-050, sha 42ea31e): **+8 / -1**. unmatched=15.

## Progress this iter (active `sorry` per file)
- **FlatteningStratification 1 → 1 (+5 axiom-clean decls; G1/G3/genericFlatness left ABSENT).**
  Engine `GeneratingSections.map`/`map_I`/`map_isFiniteType` (~L2433/2447/2459) + `gf_localGenerators_restrict`
  (seam-1a, ~L2479) + `gf_finiteType_affine_finite_cover_generated` (assembly, ~L2526; dropped unused
  `[F.IsQuasicoherent]`). `genericFlatness` (~L2668) untouched (gated on G1+G3).
- **GrassmannianQuot 0 → 5 (NEW FILE; +3 axiom-clean decls + 5 scaffolds).** `globalUnitSection` (~L38),
  `scalarEnd` (~L52), `chartQuotientMap` (~L73, headline). Scaffolds: `Scheme.Modules.glue`,
  `universalQuotient`, `tautologicalQuotient`, `functor`, `represents` (all sorry, planner-requested).
- **QUOT / GR / SNAP / FBC untouched.** FBC PARKED.

## Strategic state
- **GF:** seam-1 CLOSED. `gf_qcoh_fintype_finite_sections` (G1) now reduces EXACTLY to the per-`g` base case
  `gf_qcoh_finite_sections_of_genSections` — the gap1-hard `X.Modules ↔ Spec` transport of a finite free epi
  across `IsAffineOpen.isoSpec` (sub-steps a/b/c, each gap1/gap2-level). Effort-break + dedicate one iter.
  G3 (`gf_flat_locality_assembly`, stalkwise flatness local-on-source) independent, separate iter.
- **GR-quot:** infra landed. `chartQuotientMap` realised via `biproduct.matrix` (sections have no module
  instance). Next: `Epi chartQuotientMap` (split-epi, ≥5-lemma chain, fully specified) — feeds
  `tautologicalQuotient`. `Scheme.Modules.glue` signature must be FIXED (cocycle hyps) before any body-fill;
  it bottlenecks 4 of 5 scaffolds. `functor` is glue-independent, parallelizable.
- **SNAP / FBC:** untouched. FBC parked, off critical path (un-park trigger ≈ now, but lanes are full).

## Critic / auditor dispositions
- **lean-auditor `iter050`** (0 must-fix on new decls; 6 sorries identified honest; 1 major / 2 minor): all 8
  new decls genuine + axiom-clean; dropped `[F.IsQuasicoherent]` confirmed unused; `genericFlatness` + 5
  GR-quot scaffolds honestly documented. MAJOR = `Scheme.Modules.glue` cocycle gap (signature fix before body).
- **lvb-checker `flat-iter050`** (0 red flags / 2 major blueprint-side): GeneratingSections engine missing
  blueprint block (coverage debt); spurious `[F.IsQuasicoherent]` in prose. → `% NOTE:` added + recs.
- **lvb-checker `grquot-iter050`** (2 major / 0 must-fix): `glue` cocycle hyps absent; `globalUnitSection`/
  `scalarEnd` unblueprinted. `chartQuotientMap`+`represents` (noncomputable def) faithful.

## Markers updated (manual)
- `Picard_FlatteningStratification.tex` `lem:gf_finiteType_affine_finite_cover_generated`: added `% NOTE:`
  (iter-050) — Lean dropped `[F.IsQuasicoherent]`; planner to remove "quasi-coherent" from prose hypotheses.
- No manual `\leanok` overrides (sync_leanok +8/-1 trusted).

## Subagent skips
- None. Both highly-recommended review subagents dispatched: lean-auditor (whole-project, 2 files) +
  lean-vs-blueprint-checker ×2 (both prover-touched files: FlatteningStratification, GrassmannianQuot).
