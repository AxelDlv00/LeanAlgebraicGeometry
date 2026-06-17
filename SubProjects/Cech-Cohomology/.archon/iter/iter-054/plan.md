# Iter-054 plan — both P5a lanes collapsed to crisp residuals; execute the CHURNING corrective (blueprint expansion naming the exact Lean mechanism) + re-dispatch

## Entering state (verified)
iter-053 ran BOTH new lanes (first real prover attempt on each). Both PARTIAL-with-strong-progress:
- **Lane 1 `CechAugmentedResolution.lean`:** whole `cechAugmented_exact` WIRED axiom-clean end-to-end
  (toSheaf reflect → `homologyIsoSheafify` → sheafification square → locally-zero site lemma → covering
  sieve → eval-preserves-homology) down to ONE residual `hSec` (line 180): `IsZero` of the F-valued
  augmented Čech **section** complex homology for `V ≤ coverOpen 𝒰 i`. +2 axiom-clean reusable helpers.
- **Lane 2 `OpenImmersionPushforward.lean`:** +1 axiom-clean private `isAffineHom_of_affine_separated`;
  both tops reduced to the SHARED bridge (1) = cohomology-presheaf identification (the deferred hand-off
  in HigherDirectImagePresheaf.lean).
Project inline sorry = 5 (2 frozen: CechHigherDirectImage:780 protected P5b, CechAcyclic:110 dead; 3
residual: CechAugmentedResolution:180, OpenImmersionPushforward:87/128). Build GREEN.

## What I did this phase
1. Processed both iter-053 prover results → task_done (both lanes' progress) + refreshed task_pending
   header + the two P5a entries; cleared both prover result files.
2. **Wave 1 (parallel read-only consults):**
   - **progress-critic `iter054` → Route 1 CHURNING, Route 2 UNCLEAR.** Route 1 CHURNING because
     `cechAugmented_exact` has been PARTIAL for 3 consecutive iters (051 object layer, 052 import-cycle
     discovery, 053 collapse-to-residual), accumulating helpers, target never closed. **Corrective
     (must-fix this iter): blueprint expansion of Step 3/4 naming the EXACT Lean mechanism BEFORE any
     prover re-dispatch — NOT another reworded re-dispatch.** Route 2 UNCLEAR: proceed, attempt bridge (1)
     DIRECTLY (it "may be near-rfl" — all upstream is 0-sorry), do not hand it off again.
   - **strategy-critic `iter054` → SOUND** (0 challenges). Both residuals correctly scoped, no hidden
     circularity (cechAugmented discharges on `{V⊆Uᵢ}` avoiding the `Ȟᵖ(V,·)` trap; bridge (1) reduces to
     02KG which is proven independently of f_*-acyclicity via 01EO/P3 — acyclic dep graph). One non-blocking
     flag: confirm at P5b that `isAffineHom_of_affine_separated`'s `[X.IsSeparated]` is suppliable from the
     frozen `f separated + quasi-compact` (absolute-vs-relative separatedness) — see Open flag below.
   - **mathlib-analogist `deepbridge` → PROCEED on both** with off-the-shelf Mathlib idioms (`analogies/
     deepbridge.md`, exact decl names + imports + the `Homotopy⟹IsZero` 3-lemma combo + the
     `extAddEquivCohomologyClass∘homologyAddEquiv` Ext-bridge; ExtraDegeneracy REFUTED by variance).
3. **Executed the CHURNING corrective:** blueprint-writer `iter054` expanded the consolidated chapter
   `Cohomology_CechHigherDirectImage.tex` — Step 3 (a)–(e) now names the homotopy⟹IsZero mechanism + the
   concrete-section-complex identification + the ExtraDegeneracy dead-end; 2 new helper `\lean{}` blocks;
   `lem:open_immersion_pushforward_comp` proof now names Bridges (1)–(3) with Mathlib decls; private
   `isAffineHom_of_affine_separated` bundled into the `\lean{}` list (coverage debt cleared); optional
   `\mathlibok` Ext-bridge anchor. blueprint-clean `iter054` purified (1 phrase). **blueprint-reviewer
   `iter054` → HARD GATE CLEARS** the consolidated chapter (0 must-fix; both target files clear). Fixed the
   one "soon" item myself (added `\uses{lem:pushforwardPushforwardEquivalence_mathlib}`).
4. Refreshed STRATEGY (the two ACTIVE P5a rows — estimates + the now-named residual mechanisms; removed the
   format-drift `(iter-053)` tags). Updated PROGRESS `## Current Objectives` (2 lanes, mathlib-build).

## Decision made

### D1 — Execute the CHURNING corrective via blueprint expansion, then RE-DISPATCH both lanes (do NOT pivot the route, do NOT extract a shared upstream bridge this iter).
- **Chosen:** the progress-critic's named corrective is blueprint expansion naming the exact Lean mechanism
  — which the analogist supplied precisely. The chapter now carries the full formalization route for both
  residuals (gate-cleared). Re-dispatch BOTH files (mathlib-build) with the NOW-CONCRETE blueprint; this is
  NOT "the same lane with a reworded recipe" (the forbidden non-response) — the blueprint now names the
  actual `mapHomologicalComplex↔depDiff` identification, the `Homotopy⟹IsZero` combo, and the Ext-bridge
  decls that were previously absent.
- **Why not pivot/refactor:** strategy-critic SOUND, no circularity; the residuals are PROCEED (off-the-shelf
  idioms), not new-infrastructure walls. The CHURNING was a *blueprint-precision* defect (under-specified
  mechanism), not a route defect — exactly the corrective the critic named. Pivoting would discard a correct,
  end-to-end-wired theorem one residual from done.
- **Why not extract a shared `affine`+`cechAugmented` bridge into FreePresheafComplex.lean this iter:** the
  progress-critic floated it as a secondary note, but (a) FreePresheafComplex is upstream + 0-sorry + frozen-ish;
  (b) the cechAugmented residual is at the EASIER section/AddCommGrp level (no outer pushforward) and is
  self-contained in CechAugmentedResolution.lean; (c) over-abstracting before the concrete build exists risks
  churn. Keep co-located; extract later IF the build proves genuinely reusable for `affine`.
- **Reversal signal:** if the iter-054 Lane-1 prover reports the named identification (`mapHomologicalComplex`
  → concrete `∏_σ Γ(coverInter σ⊓V,F)`) is itself a multi-iter wall (not the "easier section-level" the
  analogist predicts), THEN extract it as its own foundational sub-lane (and reconsider whether `affine`
  should be revived to share it). Watch for a 2nd consecutive Lane-1 PARTIAL with the residual unchanged.

### D2 — Re-sign `higherDirectImage_openImmersion_comp` from `Nonempty (A ≅ B)` to canonical `A ≅ B`.
- **Chosen:** instruct the Lane-2 prover to re-sign the (non-protected, non-frozen) scaffold return type to
  the canonical iso the blueprint specifies.
- **Why:** the construction (`rightDerivedIsoOfAcyclicResolution` + `pushforwardComp`) IS canonical; `A ≅ B`
  is strictly stronger/more reusable downstream than `Nonempty (A ≅ B)` and keeps Lean↔blueprint consistent
  (blueprint already says `≅`). lvb-openimm flagged the `Nonempty` weakening as must-fix. Folded into the
  prover objective (no separate refactor dispatch — it owns the file).

## Open flag (non-blocking, for P5b assembly)
strategy-critic: `isAffineHom_of_affine_separated` carries `[X.IsSeparated]` (absolute, over the terminal).
The frozen `cech_computes_higherDirectImage` gives `f : X ⟶ S` separated + quasi-compact (RELATIVE). At the
P5b consumer, confirm `[X.IsSeparated]` is suppliable (or that the open-immersion lemma should instead take
relative separatedness of `f`). Not this iter's concern (the two lanes are self-contained with their own
`[X.IsSeparated]` hyp); flagged so the P5b planner checks it before assembly.

## Subagents dispatched
- progress-critic `iter054` (CHURNING Route 1 / UNCLEAR Route 2 — corrective executed)
- strategy-critic `iter054` (SOUND)
- mathlib-analogist `deepbridge` (PROCEED both; `analogies/deepbridge.md`)
- blueprint-writer `iter054` + blueprint-clean `iter054` + blueprint-reviewer `iter054` (HARD GATE CLEARS)

## Next iter (ordered)
1. Process Lane 1 + Lane 2 results. If Lane 1 closes → `cechAugmented_exact` available = P5a resolution input
   for P5b. If a lane hands off, set the next sub-leaf (watch the D1 reversal signal for Lane 1).
2. EnoughInjectives connector (`HasInjectiveResolutions → EnoughInjectives`, ~6 LOC) + the P5a last-mile
   Ext-bridge — prerequisites for P5b. Confirm the Open flag above.
3. P5b comparison assembly (Route A, line-780 protected goal) — gated on P5a inputs.
4. Non-blocking cleanup: delete dead `CechAcyclic.affine` stub (sorry 5→4; repoint `lem:cech_acyclic_affine`).
