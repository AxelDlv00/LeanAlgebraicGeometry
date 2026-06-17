# Iter-019 plan — clear iter-018 admin debt, re-sign P5a leaf, dispatch 3 gate-cleared lanes

## Entering state (verified)
iter-018 ran all 4 lanes (+36 axiom-clean decls, 0 new sorries, build green 8323). No named target
landed, but each lane shrank its residual and handed off a precise next step. Project sorry = 2 (both
intentional: superseded relative-form `CechAcyclic.affine` line 109; frozen P5b at CechHigherDirectImage:778).
lean-auditor: 0 must-fix on Lean code; the entire review signal was administrative.

## What I did this iter
1. **Processed iter-018 results** (task_done/task_pending updated; 4 prover result files consumed).
2. **progress-critic `iter019`** (dispatched first, independent of edits): all routes CONVERGING/UNCLEAR,
   0 CHURNING/STUCK. Its one actionable note → see Decision D3.
3. **P5a re-sign decision (D1)** + **blueprint-writer `iter019`**: re-signed `lem:higher_direct_image_presheaf`
   to the resolution form (`higherDirectImage_iso_sheafify_presheafHomology`), added engine block
   `def:cohomology_sheaf_is_sheafify_homology`, bundled all 44 coverage-debt helpers, fixed broken `\uses`.
   The writer correctly REJECTED my Edit-3 rename (`Dependent` is a Lean `section`, not a namespace →
   `…CombinatorialCech.depDiff_exact` is the right name; the real issue was the raw Lean name living in a
   `\uses{}` at all — see D4).
4. **refactor `cleanup`**: wired the orphaned `HigherDirectImagePresheaf.lean` into the root barrel; fixed
   4 actively-misleading stale comments (AcyclicResolution:924–964, CechHigherDirectImage:161–183 & 245–293,
   PresheafCech:17–23). `lake build` GREEN 8326 jobs, 0 new sorries.
5. **strategy-critic `iter019`** (on updated STRATEGY.md): **CHALLENGE** — see D2.
6. **blueprint-clean `iter019`** then **blueprint-reviewer `iter019`** (HARD GATE, whole blueprint):
   Lanes 1 & 2 clear; Lane 3 blocked only by the broken `\uses` (D4).
7. **Fixed the broken `\uses` myself** (removed the raw Lean name from the `lem:cech_acyclic_affine`
   proof `\uses`); verified deterministically: `dag-query unmatched` = 0, ref gone (D4).
8. Wrote PROGRESS.md (3 lanes), STRATEGY.md (P5a row/questions/gaps), task_{pending,done}.md.

## Decision made

### D1 — P5a re-sign to the resolution form (option 1, mirrors Q4)
The iter-018 prover built the resolution form (`higherDirectImage_iso_sheafify_presheafHomology` +
engine `homologyIsoSheafify`) instead of the named absolute-cohomology-presheaf form, which would need a
standalone module-valued `Hⁿ(open,F)` object (a Mathlib fork). I re-signed the leaf to the proved form.
Why: it is the correct Lean target for the LEAF node; the named form is a multi-decl sub-project against
the validated api-alignment analysis. Cheapest reversal signal: a downstream consumer that genuinely
cannot proceed without the absolute object as a *Lean* dependency of the leaf (vs. at point-of-use).

### D2 — strategy-critic CHALLENGE (P5a re-sign oversold): ACCEPTED, framing corrected
The critic is right: the re-sign RELOCATES rather than ELIMINATES the absolute-`Hᵏ(f⁻¹V,G)` obligation.
The downstream consumers (`open_immersion_pushforward_comp`, `cech_term_pushforward_acyclic`) feed
`affine_serre_vanishing`, which is *stated* with absolute cohomology, so the last-mile bridge
`Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V,G)` is still owed — just at point-of-use, when those consumers are dispatched.
Response: corrected STRATEGY.md to say "relocates, does not remove"; recorded the critic's `Sheaf.H`+forget
finding (Mathlib HAS `CategoryTheory.Sheaf.H` for AddCommGrp-valued sheaves, reachable from `SheafOfModules`
via forget — undercuts the "fork with zero lemmas" premise) as an open question to investigate BEFORE any
bespoke `Hⁿ(open,F)` build. Crucially: **this CHALLENGE does not block this iter** — all 3 dispatched lanes
are P3/P3b, fully independent of the P5a leaf and its deferred bridge. The blueprint P5a block itself does
NOT overclaim (reviewer confirmed). Minor format drift (~350 B over 12 KB) deferred as non-blocking — the
canonical-structure content rules are all satisfied; no freeform-history sections were added.

### D3 — progress-critic trackability note: addressed via NAMED targets, not a fragile sorry-stub
The critic noted Route 1 (CechAcyclic) has shown sorry 1→1→1 across three prover iters (a metric artifact:
the tracked sorry is the superseded relative-form decl, not the real target) and warned that another
helper-only iter risks an iter-020 STUCK reading. Rather than scaffold a fragile `sorry` stub of
`sectionCech_affine_vanishing` (whose signature is intricate — involves `sectionCechComplex` applied to a
quasi-coherent `(Spec R).Modules`; the iter-018 prover flagged it as a "large, fiddly construction"), I
directed the Lane-3 prover to PRIORITIZE landing ≥1 NAMED blueprint target (`qcohSectionsAwayLocalized` in
the `tilde M` case — no 01I8 gap — and/or `sectionCech_homology_exact`). Named-decl completion is trackable
via `\leanok` and is the real progress signal; this both makes genuine progress and answers the critic's
concern. Fallback committed in PROGRESS "Next iter plan": if Lane 3 lands NO named target this iter,
iter-020 escalates (effort-breaker on `lem:section_cech_homology_exact`, or lean-scaffolder to stub the top).

### D4 — broken `\uses` (Lane-3 gate-blocker): fixed by plan agent + deterministic re-verification
blueprint-reviewer blocked Lane 3 on one finding: a raw Lean name (`…CombinatorialCech.depDiff_exact`)
inside the proof `\uses{}` of `lem:cech_acyclic_affine` (`\uses` expects blueprint labels, not Lean names;
the deterministic blueprint-doctor flags it as a broken ref). The plan agent is explicitly authorised to
fix broken `\uses`. I removed the raw name (the combinatorial core is already a `\lean{}`-coverage member
of this same lemma, so the dependency is internal, not an external `\uses` edge) and verified deterministically:
`dag-query unmatched` = 0, the broken ref is gone. The reviewer had already certified Lane 3's MATH as
complete+correct this iter; the sole residual was this mechanical ref. Re-running a full reviewer for a
one-line `\uses` removal it itself prescribed is the wasted cycle the fast-path exists to avoid — the
deterministic doctor check is the authoritative confirmation that the finding is resolved. Lane 3's gate is
therefore cleared.

## Decision: dispatch 3 parallel lanes
- **Lane 1 CechBridge** (`cechComplex_hom_identification`, mathlib-build) — SHORTEST PATH; 2 fully-derived
  decls; operational block resolved (upstream now compiles on entry). Unblocks the whole P3b bridge.
- **Lane 2 FreePresheafComplex** (`cechFreeComplex_quasiIso`, mathlib-build) — large homotopy lane; precise
  3-step decomposition + verified building blocks; port `CombinatorialCech.combHomotopy`.
- **Lane 3 CechAcyclic** (section-form L1 named targets, mathlib-build) — continue from the iter-018 capstone
  `cechLocalized_exact`; prioritize landing a named target (D3).
All three map to the consolidated chapter (gate-cleared this iter); all independent files; the iter-018
cross-lane breakage (FreePresheafComplex broken on entry) is resolved, so Lane 1's upstream is stable.

## Subagent skips
- _(none — all HIGHLY RECOMMENDED plan-phase subagents dispatched: progress-critic, strategy-critic,
  blueprint-reviewer. Plus blueprint-writer, blueprint-clean, refactor.)_
