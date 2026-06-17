# Iter-044 plan — Sub-lemma B reduced to ONE ring identity (iter-043); blueprint refreshed + re-cleared; closer re-dispatched

## Entering state (verified)
iter-043's one lane landed **two `rfl` scalar-action bridges** (`modulesSpecToSheaf_smul_eq`,
`modulesRestrictBasicOpen_smul_eq`, both axiom-clean, kernel-verified via `lake env lean`) and **reduced the
entire Sub-lemma B obstruction to ONE structure-sheaf ring identity** (~30–50 LOC). The iter-042 "~150 LOC
non-definitional wall" was sharpened: scalar actions AND carriers are definitional (carriers via `restrict_obj`
on the iterated-image open `W`); only the bundled `ModuleCat R_g` vs `ModuleCat R` differs at the category
level. Project inline-sorry = 2 (both frozen/superseded). Build green. QcohTildeSections.lean is 0-sorry.

Tile-lemma ingredient status: Sub-lemma A ✔ (iter-042), base-ring descent ✔ (iter-041), two rfl bridges ✔
(iter-043). **Sub-lemma B `tile_section_comparison` — ONE ring identity remains.**

## What I did this phase
1. Processed iter-043 lane → task_done (+2 axiom-clean rfl bridges, the major reduction); refreshed
   task_pending header to iter-044.
2. **Fixed the iter-043 review must-fix-equivalent + coverage debt** (lean-vs-blueprint `qts`: the
   `lem:tile_section_comparison` sketch went STALE — overstated the residual 3–5× and claimed "genuinely
   non-definitional"; + 2 new bridge lemmas had no blueprint blocks). blueprint-writer `tile-residual`:
   rewrote the sketch to the accurate two-rfl-bridges + one-ring-identity decomposition (displayed residual
   identity + routes A/B), added blocks for `lem:modulesSpecToSheaf_smul_eq` + `lem:modulesRestrictBasicOpen_smul_eq`,
   wired the new `\uses{}`. blueprint-clean `tile-residual` stripped 2 residual Lean-leakage comments.
3. **Same-iter fast path:** blueprint-reviewer `iter044` (whole-blueprint; gate-scoped on the active lane) →
   **HARD GATE CLEARS** — chapter complete+correct, sketch does not misdirect into a large construction, 0
   must-fix. One soon item (dormant `lem:qcoh_localized_sections`, no DAG path to goal) — does not block.
4. **progress-critic `routeb` → CHURNING (dispatch=OK)** — handled per Decision D1.
5. Refreshed the STRATEGY 01I8 risk cell (Sub-lemma B now DEFINITIONAL scalar/carrier; residual = one ring
   identity ~30–50 LOC; LOC range ~120–250 → ~80–200). No route/phase/decomposition change.
6. Dispatched ONE prover lane: QcohTildeSections.lean → close the residual ring identity → Sub-lemma B →
   assemble `tile_section_localization` (mathlib-build).

## Decision made

### D1 — Respond to progress-critic CHURNING with the critic's OWN named corrective (blueprint expansion),
###      NOT a route pivot; re-dispatch the same file a 5th time, with two enforcement guards.
The CHURNING verdict fires verbatim on the "PARTIAL prover status × 3 (iters 041–043)" rule. But the critic's
analysis is explicit that this is "CHURNING-but-close, not CHURNING-by-rotation": the obstruction shrank
monotonically (section-comparison-not-rfl → ~150 LOC wall → ONE ring identity with two named closure routes),
every round landed genuinely load-bearing axiom-clean infra, and the route is "converging rapidly, slowed by
blueprint-sketch lag." The critic's **primary corrective is blueprint expansion** — sequence the prover AFTER
the writer delivers the updated `lem:tile_section_comparison` sketch. That is exactly what I did this iter
(writer → clean → reviewer HARD-GATE-CLEARS, all before the prover lane). The critic returned **dispatch=OK**.
So the response to CHURNING is a concrete corrective THIS iter (blueprint rewrite + re-clear), not "another
helper round on the same recipe." The two enforcement points the critic named are baked into the objective:
(1) the prover reads the REFRESHED sketch, not the stale one (the rewrite makes the stale version inaccessible —
the sketch now matches the real residual); (2) the prover must VALIDATE the in-file "PROVEN tactic prefix"
comment with `lean_goal`/`lean_multi_attempt` before relying on it (lean-auditor `iter043`: `tile_scalar_compat`
was never compiled). **Reversal signal:** if the ring identity stalls on a concrete term-mode wall, iter-045
dispatches a mathlib-analogist (api-alignment) on the `ΓSpecIso`/`globalSectionsIso` section-comparison with
the prover's ACTUAL error state, AND I revise the 01I8 `Iters left` estimate (the critic's SLIPPING flag:
estimated ~2, elapsed 3; threshold for OVER_BUDGET is 4). A route pivot is NOT warranted — there is no rival
non-circular route, and the residual is one named ring identity with two concrete Mathlib closure paths.

### D2 — No second (parallel) prover lane; the keystone is the single critical path.
`cechAugmented_exact` (`lem:cech_augmented_resolution`) is GATED on 01I8 via `\uses{lem:qcoh_iso_tilde_sections}`
(frontier-honesty fix iter-043, still live). The leandag "Ready to prove" frontier lists it +
`lem:cech_free_eval_prepend_homotopy` + `lem:tilde_restrict_basicOpen` + `lem:tile_section_comparison`, but the
first two are 01I8-gated in substance and `lem:tilde_restrict_basicOpen` is a DORMANT Route-P asset (do not
resurrect). The only honest, gate-cleared frontier piece is the tile lemma. The standing parallelism directive
does not manufacture honest parallel work; one lane is correct.

## Subagent skips
- strategy-critic: STRATEGY.md changed only by a single risk-cell estimate refresh (Sub-lemma B residual:
  ~100–150 LOC → one ring identity ~30–50 LOC; LOC range tightened) within the UNCHANGED sheaf-axiom-equalizer
  Route-B keystone — no route swap, phase split/merge, or decomposition change. The last strategy-critic
  (iter-041 `keystone`) raised one CHALLENGE (span-cover descent circular), which was ADDRESSED that iter
  (re-routed to the equalizer) and recorded; no live challenge remains. A full strategy re-audit on a factual
  estimate refresh would be a hollow dispatch (the exact failure mode the skip affordance exists to avoid).

## Coverage debt cleared this iter
- `lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq` — blueprint blocks added by
  blueprint-writer `tile-residual` (were the 2 new lean_aux nodes in the iter-043 leandag coverage-debt list).
  `\lean{}` pins confirmed present in the Lean codebase by blueprint-reviewer `iter044`.
- `lean:AlgebraicGeometry.CechAcyclic.affine` — pre-existing dead/superseded node; deletion still deferred
  (protected `CechHigherDirectImage.lean` references it; remove at P5b assembly rework).
