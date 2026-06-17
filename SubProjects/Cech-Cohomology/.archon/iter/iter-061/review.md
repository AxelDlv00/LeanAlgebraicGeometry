# iter-061 review

## Overall progress this iter
- **Total real sorry: 9 → 9 (FLAT, no closures, 0 forced/papered).** `grep -c sorry` reports 10 but
  one is the word "sorry" inside a `CechAcyclic.lean:18` docstring. Open holes:
  `OpenImmersionPushforward:588` (`hqc`) + `:654` (`_comp`),
  `CechSectionIdentification:729/820/890/949` (Stubs 2/4/5/6), `CechAugmentedResolution:229`,
  `CechHigherDirectImage:780` (frozen P5b), `CechAcyclic:110` (dead).
- **Build:** GREEN — re-verified first-hand, `lake env lean` EXIT 0 on BOTH prover files (only the
  expected sorry warnings). All 5 new decls `#print axioms`-clean per the prover log
  (`{propext, Classical.choice, Quot.sound}`).
- **Lanes planned 2, ran 2. BOTH PARTIAL, neither moved a sorry. +5 axiom-clean decls** (3 CSI +
  2 OpenImm); one CSI keystone (`isIso_coprodDecompMap`) attempted, blocked, and removed (no new sorry).
- **dag-query:** gaps = 0; unmatched = 5 (4 new helpers + dead `affine`). sync_leanok ran iter-061
  (sha `5ac991b`, +1/−2). **blueprint-doctor: no findings.**

## Headline — this is a foundation iter that did NOT convert two CHURNING routes
The progress-critic flagged BOTH lanes CHURNING entering iter-061. The planner executed the prescribed
correctives (effort-break the CSI monolith; mathlib-analogist on the OpenImm final leaf) and dispatched
both provers. Both came back PARTIAL with **zero sorry movement** — the predicted CHURNING outcome. The
work landed is real and useful (foundations under the assembly holes), but the headline for the next
planner is that *another bare re-dispatch is not the move* — both routes now need the next level of
structural action (detailed in `session_61/recommendations.md`).

### Route A (CSI Stub 2): L1 + 2 helpers landed; L2 base case hit a precise instance trap
`isIso_modules_of_toPresheaf` (blueprint L1, one-liner `isIso_of_reflects_iso`),
`isIso_prodLift_of_isLimit`, and `coprodDecompMap` are axiom-clean. The L2 base case
`isIso_coprodDecompMap` was blocked: the natural reduction `toPresheaf ⋙ (evaluation _ Ab).obj V` gets
NO composite `PreservesLimitsOfShape` instance (codomain is the `TopCat.Presheaf Ab` def-wrapper). The
prover removed the decl rather than sorry it and left a `/- Handoff -/` block with the concrete FIX
(switch to `SheafOfModules.evaluation V`, which lands in `ModuleCat` with a direct instance). This is a
single concrete leaf with a known fix — one targeted re-dispatch is justified, but if the
`isProductOfDisjoint` cone bookkeeping stalls, re-break it (do NOT brute-force).

### Route B (OpenImm `hqc`): the `of_coversTop` reduction is DONE; residual is one Mathlib-absent hom
`coversTop_preimage_of_iso` + `pushforward_iso_qcoh_of_slice_qcoh` reduce `hqc` to per-slice qcoh,
axiom-clean. Every surrounding fact is verified-feasible. The lone residual is the cross-ring slice
ring hom `ψ_r` (~100–150 LOC, genuinely absent from Mathlib — only the same-ring `bind` slice exists).
The prover found a SIMPLER route (`pullback ψ_r`, a single left-adjoint hom) than the blueprint's
`pushforwardPushforwardEquivalence` quadruple. Next iter needs `effort-breaker` on `ψ_r` +
`blueprint-writer` to retarget `lem:pushforward_iso_preserves_qcoh` to the single-hom route BEFORE a
prover round.

## Soundness — confirmed, no papering
- **Review first-hand:** both `lake env lean` EXIT 0; only expected sorry warnings.
- **lean-auditor `iter061`** + **lvb-csi** + **lvb-openimm:** see `## Subagent verdicts` below
  (finalized after reports landed).
- No kernel-soundness trap this iter (no thin-cat `ext`/`congr` laundering; the removed
  `isIso_coprodDecompMap` was deleted, not laundered).

## Markers I changed
None. The `% NOTE: build target` markers on `lem:pushforward_iso_preserves_qcoh` and
`lem:pushforward_commutes_restriction` remain accurate (both unbuilt). No `\lean{}` correction, no
stale `\notready`, no `\mathlibok` (no new Mathlib-backed leaf this iter).

## Subagent verdicts
- **lean-auditor `iter061`** — 0 must-fix / 0 major / 2 minor. Both files clean; all 5 new decls
  genuine (not Subsingleton/defeq launders), all sorries honest with accurate surrounding comments, no
  excuse-comments, heartbeat bumps correctly `in`-scoped. Minors: a no-op heartbeat bump on the
  `sorry`-bodied `pushPull_sigma_iso:723`; the `isZero_of_faithful_preservesZeroMorphisms` duplication
  (import-constraint, documented).
- **lvb-csi** — 1 major / 0 must-fix. All Stub types match the blueprint (Stubs 5/6 AUGMENTED form
  confirmed intact); `isIso_modules_of_toPresheaf` matches `lem:isIso_modules_of_toPresheaf` exactly.
  MAJOR = `lem:pushPull_binary_coprod_prod`'s proof sketch is under-specified (omits the instance trap +
  Ab→ModuleCat bridge the prover hit) → blueprint-writer `% NOTE:` next iter.
- **lvb-openimm** — 2 major / 0 must-fix. `hqc`/`_comp` sorries honest and undisguised. MAJOR ×2 =
  (a) `lem:pushforward_iso_preserves_qcoh` prescribes the harder quadruple route, should be retargeted to
  the prover's simpler `pullback ψ_r` single-hom route; (b) `pushforward_iso_qcoh_of_slice_qcoh` needs a
  blueprint node. Both are next-iter blueprint-writer actions BEFORE a prover round on `hqc`.

**Net:** zero must-fix-this-iter, zero Lean unsoundness. All three majors are blueprint-adequacy /
coverage items that the next planner should clear via blueprint-writer + the coverage-debt entries —
folded into `session_61/recommendations.md`. A minor `\leanok` sync-attribution ambiguity (lvb-csi
flagged proof-block `\leanok` missing on the closed `isIso_modules_of_toPresheaf`/`pushPull_leg_sections`
and statement-block `\leanok` missing on `cechSection_complex_iso`, despite sync running iter=61 sha
`5ac991b`) is left for the next sync run / planner to verify — review does not touch `\leanok`.
