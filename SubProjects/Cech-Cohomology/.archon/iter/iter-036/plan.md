# Iter-036 plan — 01I8 PIVOT to Route B (section-localization); Route P demoted to dormant; keystone dispatched

## Note on this phase
This plan phase was **resumed**: a prior run this iter dispatched mathlib-analogist + progress-critic +
blueprint-reviewer (all completed), pivoted STRATEGY.md to Route B, and dispatched a blueprint-writer
(`route-b`) that rewrote the chapter — then died before dispatching the prepared strategy-critic, doing a
fast-path re-review, processing prover results, or writing PROGRESS/sidecar. This run finished all of that.

## Entering state (verified)
iter-035's two prover lanes (both mathlib-build, +9 axiom-clean, both files 0-sorry):
- `QcohRestrictBasicOpen.lean` (NEW) — P1a L1 COMPLETE (+5): `modulesRestrictBasicOpen(+Iso)`,
  `specBasicOpen`/`specAwayToSpec`/`specAwayToSpec_eq`. L2/L3 blocked on absent-Mathlib tilde base-change.
- `TildeExactness.lean` — PARTIAL (+4): `tilde_germ_algebraMap_smul`, `stalkMapₗ`, `stalkMapₗ_eq`,
  `stalkMapₗ_injective`. Named target `tildePreservesFiniteLimits` still ABSENT.
Project sorry = 2 (both frozen/superseded: `CechHigherDirectImage:~679` frozen P5b, `CechAcyclic.affine`
dead). Build green. `gaps = 0`. `unmatched` 5 → 1 after this phase's wiring.

## What I did this phase
1. Processed both prover lanes → task_done (+9 axiom-clean, marked dormant); refreshed task_pending header;
   rewrote PROGRESS.md for Route B; cleared the two prover task_results.
2. Wired the 4 dormant TildeExactness helpers into `lem:tilde_preserves_kernels` `\lean{}` (coverage debt
   5 → 1; residual = dead `CechAcyclic.affine`, deferred — protected file references it).
3. **Dispatched the prepared strategy-critic `iter036`** (STRATEGY pivoted → not skippable). Verdict
   **SOUND**: Route B is a genuine pivot (hardest prerequisite changes from absent-Mathlib packaging walls
   to the irreducible 01HV core), non-circular with 02KG, all Mathlib names verified present. One must-fix
   (STRATEGY format DRIFTED) + a soundness clarification + an `IsLocalizing` leverage suggestion.
4. **Dispatched a fast-path scoped blueprint-reviewer `routeb`** (chapter was rewritten after the stale
   `iter036` review). Verdict: chapter `complete:true, correct:true`, **GATE PASS** for both Route B
   targets, 0 must-fix (1 soon: spurious `\uses`; 2 informational). All 4 `\mathlibok` anchors verified
   live against the toolchain.
5. Applied the reviewer's "soon" fix (removed spurious `lem:fromTildeGamma_mathlib` from the keystone
   statement `\uses`) and the strategy-critic's soundness clarification (added the **tilde RIGHT-exactness
   non-circularity** paragraph to the keystone proof body).
6. Fixed STRATEGY format DRIFT (must-fix): collapsed the 4 Phases-table cells to one line each, stripped
   per-iter tags (`iter-035`/`iter-036`/"PIVOT iter-036"/"reframed iter-036"), added a dedicated
   `### 01I8 affine F≅~(ΓF)` route subsection (detail moved out of the table cell + the pitfall +
   the `IsLocalizing` leverage), and compressed the Open-questions 01I8 bullet.
7. Dispatched ONE prover lane: `QcohTildeSections.lean` → keystone `qcoh_section_isLocalizedModule`
   (mathlib-build, scaffold keyword on the path line). Wrote sidecar + objectives; updated ARCHON_MEMORY +
   TO_USER.

## Decisions made

### D1 — 01I8: adopt Route B (section-localization); demote Route P to dormant fallback.
**Chosen** (ratified; the pivot itself was made by the prior partial run on the mathlib-analogist evidence).
Why: Route P only reached the goal through TWO absent-Mathlib multi-hundred-LOC walls (tilde base-change
`tilde_restrict_basicOpen`; and `tildePreservesFiniteLimits`, plus the Mathlib-unsupported
qcoh-closed-under-kernels for P3). Route B needs none — its `D(f)`-component of `fromTildeΓ` is *literally*
`IsLocalizedModule.lift` of the section-restriction map (Mathlib `Tilde.lean:200`), so the only hard input
is the keystone `IsLocalizedModule (.powers f) (Γ(X,F)→Γ(D(f),F))`, discharged by the DONE P1b
`isLocalizedModule_of_span_cover`. Trade-off: discard ~9 axiom-clean Route-P decls from the critical path
(kept as compiling dormant fallback assets — zero deletion risk). Reversal signal: if the keystone's
per-`D(gᵢ)` identification cannot be done via tilde right-exactness and genuinely needs affine `H¹`, Route
B is circular and Route P (or a new route) returns — but strategy-critic + blueprint-reviewer both confirm
the right-exactness route is sound.

### D2 — CHURNING on TildeExactness → corrective = route pivot (drop the lane), NOT blueprint-expand.
progress-critic `iter036` returned **CHURNING** (PARTIAL×3, `tildePreservesFiniteLimits` absent) and named
"blueprint expansion + frame iter-036 objective as closing the named target." **I do not take that
corrective**, and this is an explicit, sanctioned override (not a silent one): the SAME-iter mathlib-analogist
finding establishes `tildePreservesFiniteLimits` is OFF the Route B critical path. "Pivot routes" is one of
the catalog's named CHURNING correctives and is strictly stronger than expand-and-redispatch — it removes the
churning lane entirely rather than feeding it another helper round. The critic's report itself flags the churn
as "structural, not mathematical," consistent with the lane being unnecessary. Corrective executed: STRATEGY
route pivot + lane dropped + file marked dormant. No re-dispatch of TildeExactness. This fully satisfies the
"CHURNING obliges a concrete corrective THIS iter — a route pivot, not another round of the same lane" rule.

### D3 — ONE prover lane this iter (not the cap-10 max).
The Route B keystone is the sole live critical-path frontier node. Every other frontier node is FALSE-ready
(02KG `affine_cech_vanishing_qcoh`, P5a `cech_augmented_resolution` — gated on unconditional
`qcoh_iso_tilde_sections`), dormant (Route P), or a pin-less transport-exposition step
(`cech_free_eval_prepend_homotopy`). Dispatching a gated lane would burn a prover (blocked-deps / unprovable
sorry). The keystone is one mathematical statement, not yet splittable into independent files; the
mathlib-build prover will hand off a decomposition if blocked, from which I can split parallel lanes next
iter. progress-critic confirmed file-count 1 is within cap and Route 2's pause was justified.

## Gate compliance (HARD GATE)
`QcohTildeSections.lean` → chapter `Cohomology_CechHigherDirectImage.tex` (consolidated, `covers` it). The
stale `blueprint-reviewer-iter036` (partial/partial) predated the Route B rewrite; per the same-iter fast
path I re-dispatched the reviewer scoped to the rewritten chapter (`routeb`), got a fresh
`complete:true + correct:true + 0 must-fix` with explicit GATE PASS on both Route B targets, AND the build is
green → keystone enters objectives this iter. Gate satisfied via the fast path.

## Subagent skips
- (none for plan-mandatory subagents — blueprint-reviewer, progress-critic, strategy-critic all dispatched.)

## Risks / watch for iter-037
- Keystone is a fresh lane (UNCLEAR ≤2 iters). Watch the per-`D(gᵢ)` `QuasicoherentData`→finite-presentation
  extraction (universe/defeq tax) and that tilde RIGHT-exactness is the identification route (not left-exact
  sections — would reopen circularity). If it partials, split per the prover's decomposition.
- Assembly step next: decide `forget`-reflects-isos basis-check vs Mathlib `isIso_fromTildeΓ_iff_isLocalizing`
  (verified leverage per strategy-critic).
