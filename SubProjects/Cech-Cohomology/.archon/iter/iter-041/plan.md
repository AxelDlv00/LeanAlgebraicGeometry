# Iter-041 plan — B-chain leaves DONE; keystone descent was CIRCULAR → re-routed to the sheaf-axiom equalizer

## Entering state (verified)
iter-040's one lane closed the B3 object iso + B4: `QcohRestrictBasicOpen.lean` +4 axiom-clean
(`overBasicOpenIsoRestrict`, `presentationModulesRestrictBasicOpen`, `restrictBasicOpenUnitIso`,
`pullbackObjUnitToUnit_isIso_basicOpen`). The entire B-chain leaves B0–B4 are now DONE. Project
inline-sorry = 2 (both frozen/superseded). Build green. The keystone `qcoh_section_isLocalizedModule`
(decl does NOT exist) is the leandag frontier node, effort 3117 — THE critical path (02KG tops, P5a,
P5b all gate on it).

## What I did this phase
1. Processed iter-040 → task_done (+4, B-chain leaves complete); refreshed task_pending header to iter-041.
2. **Fixed the iter-040 blueprint findings on `Cohomology_CechHigherDirectImage.tex`:** realigned the B3
   `lem:restrict_over_compat` prose+proof to the ACTUAL Lean decl (B3b intermediate iso, not the
   over-claimed full B3c); folded the 2 coverage-debt helpers into B4's `\lean{}`; added
   `def:modules_over_basicOpen_equivalence` to B4 `\uses`; pruned the stale `% NOTE`. blueprint-clean `b3b4`
   purified.
3. **Ran the keystone soundness gate BEFORE dispatching the deep prover** (the load-bearing decision this
   iter): mathlib-analogist `keystone-descent`, progress-critic `routeb`, strategy-critic `keystone`,
   blueprint-reviewer `iter041` (all four in one batch). Results converged: the planned span-cover-descent
   keystone is **CIRCULAR** (analogist NEEDS_INGREDIENT, strategy-critic CHALLENGE, blueprint-reviewer
   HARD-GATE must-fix). progress-critic = CONVERGING (the analogist-first move was correct, not over-caution).
4. **Re-routed the keystone** (Decision D1 below): blueprint-writer `keystone-equalizer` replaced the circular
   proof with the sheaf-axiom equalizer route + decomposed into 4 sub-lemmas; blueprint-clean `keystone`
   purified; scoped fast-path blueprint-reviewer `keystone-rereview` → **HARD GATE CLEARS**.
5. Fixed the reviewer's one cheap "soon" blueprint finding (`affine_cech_vanishing_qcoh` missing
   `\uses{lem:qcoh_isIso_fromTildeGamma}`). Trimmed STRATEGY format (strategy-critic flagged DRIFTED — removed
   the B0–B6 build-log ledger + iter-stamped prose, replaced with a route description; ~15.4KB→~13KB).
6. Dispatched ONE prover lane (the two READY equalizer sub-lemmas, mathlib-build) — see Decision D2.

## Decision made

### D1 — Adopt the sheaf-axiom equalizer route for the keystone (NOT span-cover descent; NOT the
###      strategy-critic's `isIso_fromTildeΓ_iff`-as-an-alternative).
The keystone `IsLocalizedModule(powers f) ρ_f` cannot be proved by `isLocalizedModule_of_span_cover` on
global sections: its per-`gⱼ` hypothesis is the abstract `LocalizedModule(powers gⱼ)Γ(X,F)`, and feeding it
needs `Γ(D(gⱼ),F)≅Γ(X,F)_{gⱼ}` = keystone-at-`gⱼ` = the same statement (circular; confirmed by all three
critics + the analogist, `analogies/keystone-descent.md`). The correct non-circular route is the Stacks
01HV(4) sheaf-axiom equalizer: localize F's degree-0/1 sheaf equalizer at `f` (exact localization
`IsLocalizedModule.map_exact`), match term-by-term against the `D(f)`-cover equalizer via the per-tile
localizations (DONE tile lemma on the tilde tiles, NEVER on global `Γ(X,F)`), kernel comparison ⟹ keystone.

**Why NOT the strategy-critic's `isIso_fromTildeΓ_iff` "alternative":** it is not a competing route — it is
the assembly WRAPPER (already planned: Next-iter item 3). `tilde(M)(D(f))=M_f` in Mathlib, so the per-`D(f)`
component of `fromTildeΓ` IS the map `Γ(X,F)_f→Γ(D(f),F)`; checking it iso IS the keystone, which still needs
the same equalizer argument underneath. The analogist (opus, deep Mathlib citation) showed the strategy-
critic's "free H⁰ sheaf condition" understates this, and that the naive "iso-on-cover" form additionally
resurrects the dormant Route-P tilde-base-change wall. So the equalizer route is both correct and the cleanest.
**Reversal signal:** if the prover finds `qcoh_section_equalizer` (the degree-0/1 sheaf-condition unfold)
genuinely intractable in Mathlib's `SheafOfModules` API, reconsider — but the project's P3 `CechAcyclic`
machinery already does the harder positive-degree version, so degree 0/1 should be strictly easier.

### D2 — ONE prover lane this iter: the two READY equalizer leaves (mathlib-build), NOT the full keystone.
After the re-route, the keystone decomposes into 4 sub-lemmas. Two are frontier-ready THIS iter:
`qcoh_section_equalizer` (no deps — pure sheaf axiom) and `tile_section_localization` (all 3 deps DONE).
The kernel comparison `\uses` both → not ready; the keystone `\uses` all four → not ready. So the honest
ready work is exactly the two leaves (one lane, QcohTildeSections.lean, mathlib-build). This is genuine
forward progress on the now-CORRECT route — not a probe of a possibly-circular target. The consolidated
chapter gates all its files; I cleared the HARD GATE via the fast path THIS iter so the lane dispatches now
rather than waiting an iter.

### D3 — Defer, do not chase, the `lem:qcoh_localized_sections` circularity.
The writer flagged it as circular by the same old mechanism. blueprint-reviewer confirmed via DAG BFS that
it has NO path to `lem:cech_computes_cohomology` (DORMANT). It is unbuilt (no Lean decl), blocks nothing.
Scheduled as a future blueprint cleanup (re-route or delete), not this iter's concern.

## Soundness probe outcome (the mandated cheap pass before deep budget)
This iter WAS the soundness pass. Spending it on the analogist + critics (instead of a blind deep keystone
prover) is exactly what the "Soundness check before spending budget" gate prescribes — and it paid off: the
keystone route was genuinely broken, and a blind deep lane would have hit the wall after burning effort 3117.
The cost (4 read-only consults + 1 writer + 2 clean + 1 scoped review) bought a corrected route AND a real
prover lane on the ready leaves. No idle iter.

## Subagent skips
- (none — all three highly-recommended plan-phase critics dispatched: progress-critic `routeb`,
  strategy-critic `keystone`, blueprint-reviewer `iter041` + scoped `keystone-rereview`. blueprint-writer +
  blueprint-clean dispatched for the re-route. mathlib-analogist dispatched for the soundness consult.)
