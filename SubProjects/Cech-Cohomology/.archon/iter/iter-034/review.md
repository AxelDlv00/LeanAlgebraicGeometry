# iter-034 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead,
  `CechHigherDirectImage.lean:~679` frozen P5b). Both prover files 0-sorry.
- **Build**: GREEN. `AffineSerreVanishing.lean` + `TildeExactness.lean` both `lake env lean … EXIT 0`,
  diagnostics empty; all 6 new decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`
  (the two TildeExactness "opaque" source-scan hits are the word inside docstrings — false positives).
- **Lanes planned 2, ran 2** (both `mathlib-build`, 2 `session_start` events). **+6 axiom-clean decls**
  (Lane A +4, Lane B +2); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 3** (1 pre-existing dead `CechAcyclic.affine` + 2 new
  TildeExactness helpers).

## The headline: 02KG cover-system COMPLETE — and a real design flaw caught downstream of it
Lane A landed the entire 02KG cover-system chain (the build iter-033 set up via `analogies/tosheaf-epi.md`
and which then silently did not run): `toSheaf_preservesFiniteColimits` (the Mathlib right-exact gap-fill via
the sheafification square — universe-pinned `toSheaf.{v'}`, never through `forget`),
`toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing` (the `ses_cech_h1` affine instantiation, through
the non-reducible-`Scheme.Modules` `Epi`-synthesis gotcha resolved with explicit `@Functor.map_epi … .{u}`),
and `affineCoverSystem`. Four axiom-clean decls, the full lane.

But the review caught that `affineCoverSystem.Cov` was built **without its covering condition** — it is the
set of ALL finite basic-open families, not just covering ones. lean-auditor produced a decisive
counterexample (`Ȟ¹({D(x),D(y)}, O)` on `Spec k[x,y]` is nonzero), proving that `HasVanishingHigherCech`
over this over-broad Cov is FALSE for quasi-coherent sheaves, so the gated seed `affine_cech_vanishing_qcoh`
would be unprovable as is. The two review subagents **disagreed on the fix direction** — lvb-affine wanted
to relax the blueprint prose to match the Lean (its "broader-is-sound" reasoning conflates localized-section
exactness with Čech vanishing and is refuted by the counterexample); lean-auditor wanted to tighten the Lean.
**I adjudicated for the auditor**: the prose is the correct target, the Lean Cov must gain
`⨆ D(gᵢ) = D(f)`; field proofs are unaffected. The prover's own "broader Cov only strengthens" task-note is
wrong and must not be accepted. This is not must-fix-this-iter (nothing proved is corrupted; the seed is
gated and unbuilt) but is the top HIGH item for the planner before Lane 2. Documented via `% NOTE` on
`def:affine_cover_system`.

## Lane B: the named target collapsed to a single, sharply-located build
`tildePreservesFiniteLimits_of_toPresheaf` (via `preservesFiniteLimits_of_reflects_of_preserves`) **refuted
the feared "obstruction 2"** (right-exact + mono ⟹ left-exact glue) — the module docstring was rewritten to
retract that false claim (auditor confirmed accurate). Together with the germ-naturality crux
`tilde_stalkFunctor_map_toStalk` (public Ab-stalk path: `stalkFunctor_map_germ_apply` + `comapₗ_const`), the
named target `tildePreservesFiniteLimits` now reduces to ONE fact, `PreservesFiniteLimits (~ ⋙ toPresheaf)`,
~100–150 LOC, with the exact `HSMul`/`Module R` synthesis blocker recorded for the next prover. lvb-tilde
flagged the blueprint sketch as under-specified for that remaining build (3 missing sub-steps + the
dead-ModuleCat-path warning) — a blueprint-writer item before the next prover lane.

## This iter's analysis
- **No forced mathematics; clean stops.** Lane A delivered its full chain; Lane B stopped on a real, named
  obstruction. The catch is that Lane A's COMPLETE chain carries a latent design flaw in `Cov` that only the
  adversarial counterexample surfaced — exactly the value of running the auditor.
- **No must-fix-this-iter from any reviewer.** The Cov flaw and the lvb-tilde coverage/sketch gaps are all
  planner-actionable next iter, not corrections to anything currently green.
- **Process regression resolved.** iter-033's HIGH (a planned lane silently not launching) did not recur —
  both prover sessions started this iter.

## Markers / coverage
- **Manual marker edit (1 `% NOTE`)**: `def:affine_cover_system` — records the `Cov`-missing-covering-condition
  flaw, the counterexample, and the adjudication (tighten the LEAN, not the prose). No `\leanok` touched
  (`sync_leanok` iter=34, sha c529518, +3 on this chapter, consistent with the 4 new decls minus the
  still-incomplete `lem:tilde_preserves_kernels` block whose `\lean{}` includes the absent named target).
  No `\mathlibok` (the 6 new decls are project theorems). No `\lean{}` renames. No stale `\notready`.
- **Coverage debt = 3 unmatched**: 2 new TildeExactness decls (planner to blueprint into
  `lem:tilde_preserves_kernels`) + 1 pre-existing dead `CechAcyclic.affine`. Listed in recommendations.

## Blueprint-doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`/`\proves`, no `axiom` decls.

## Subagent skips
- progress-critic / strategy-critic / strategy-auditor / blueprint-reviewer / blueprint-writer /
  reference-retriever / mathlib-analogist / dag-walker / effort-breaker / lean-scaffolder / refactor:
  plan-phase or writer subagents, not part of the review phase. The two HIGHLY-RECOMMENDED review
  subagents (lean-auditor, lean-vs-blueprint-checker ×2 files) were all dispatched.
