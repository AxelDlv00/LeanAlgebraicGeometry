# Iter 049 — Review (Quot-Foundations)

## Verdict
**CONVERGING (both lanes) — +3 axiom-clean decls, 0 new sorry.** Both lanes hit precisely-named
Mathlib-absent walls (expected per plan's iter-050 ramp). FlatteningStratification diagnostics clean;
`lake build SectionGradedRing` GREEN (2417 jobs). All 3 decls lean_verify `{propext, Classical.choice,
Quot.sound}`. blueprint-doctor: **0 findings**. dag gaps=0, unmatched=10 (privatized SNAP helpers).
sync_leanok (iter-049, sha 8f75c23): **+2/-0** (`gf_affine_finite_standard_subcover`, `def:sectionMul`) —
plus 1 manual `\leanok` override (seam 1c, sync missed it). lean-auditor: 0 must-fix.

## Progress this iter (active `sorry` per file)
- **FlatteningStratification 1 → 1 (+2 axiom-clean decls; seam 1a + assembly BLOCKED, left ABSENT).**
  `gf_affine_finite_standard_subcover` (seam 1b, ~L2355 — affine cover → finite standard-basic-open subfamily;
  `TopologicalSpace.Opens.mem_iSup` fully-qualified fix) + `gf_finite_gen_iff_free_epi` (seam 1c, ~L2390 —
  definitional `GeneratingSections` repackaging, abstract `SheafOfModules.{u} R` generality). `genericFlatness`
  untouched (gated on G1).
- **SectionGradedRing 0 → 0 (+1 axiom-clean decl; 10 helpers privatized; `tensorPowAdd` ABSENT).**
  `sectionsMul` (~L178 — lax-monoidal Γ-multiplication via the sheafification unit; `ModuleCat ⟶` form dodges
  the ring-expression diamond).
- **QUOT / GR / FBC untouched.** FBC PARKED (un-park ≈iter-050).

## Strategic state
- **GF:** seam-1 collapses from 3 missing primitives to ONE — seam 1a `gf_localGenerators_restrict`. Its
  blocker is now precisely characterized: restriction-of-generation ≡ slice restriction preserving epi;
  generic `pushforward` (right adjoint) does NOT, left-adjoint `pullback` needs an absent Beck–Chevalley iso +
  `Over.map f` Finality. Sound iter-050 route = transport along the project's geometric `overRestrictPullbackIso`
  (QUOT gap1 plumbing). The assembly reduces entirely to 1a.
- **SNAP:** `sectionsMul` is the last associator-free target — DONE. Everything further (graded-ring assembly)
  is gated on the sheaf associator; both viable routes (LocalizedMonoidal → `MonoidalClosed(PresheafOfModules)`;
  bespoke local-iso → `IsLocallyFreeOfRank` + X.Modules local-iso criterion) rest on confirmed-absent Mathlib
  infra. iter-050 = infra-build, not a prover round. Note `IsLocallyFreeOfRank` is shared with GR-quot.
- **FBC:** parked, off critical path.

## Critic / auditor dispositions
- **lean-auditor `iter049`** (0 must-fix; 3 minor): both files clean, 3 decls genuine + axiom-clean, private
  markings appropriate, `genericFlatness` sorry honest. Minors → recommendations.md (cosmetic).
- **lean-vs-blueprint-checker `flat-iter049`** (3 MAJOR, all blueprint-side; Lean correct): seam 1c missing
  `\leanok` (FIXED — manual override), erroneous "quasi-coherent" qualification + absent typeclass hypotheses
  (`% NOTE:` added; planner blueprint-writer fix queued in recs §TOP).
- **lean-vs-blueprint-checker `snap-iter049`** (0 red flags; 2 minor): `sectionsMul` exact match,
  `tensorPowAdd` correctly absent. Minors → recommendations.md.

## Markers updated (manual)
- `Picard_FlatteningStratification.tex` `lem:gf_finite_gen_iff_free_epi`: **added `\leanok`** (manual override
  — sync_leanok missed it despite the decl being axiom-clean + green; corroborated by both review subagents +
  prover lean_verify). Added `% NOTE:` (iter-049) flagging the quasi-coherence over-qualification + absent
  typeclass hypotheses for the planner to rewrite (prose is the planner's domain).

## Subagent skips
- None. Both highly-recommended review subagents dispatched (lean-auditor whole-project; lean-vs-blueprint-checker
  per-file ×2 — both prover-touched files). progress-critic / strategy-critic are plan-phase subagents.
