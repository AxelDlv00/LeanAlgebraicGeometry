# Iter-053 plan — relocate `cechAugmented_exact` (import-cycle fix) + correct its discharger + open the open-immersion lane

## Entering state (verified)
iter-052 ran both lanes. **02KG CLOSED:** `affine_serre_vanishing` + `affine_cech_vanishing_qcoh` are
now unconditional axiom-clean (Lane A SOLVED). **Lane B PARTIAL:** the prover proved
`cechAugmented_exact` **cannot be proved in `CechHigherDirectImage.lean`** — every sections/sheafification
ingredient (`homologyIsoSheafify`, `sectionCech_*`, `qcoh_iso_tilde_sections`, `affineCoverSystem`)
lives in a file that transitively IMPORTS it (import cycle). It instead landed +3 upstream abelian-sheaf
site lemmas (`isZero_presheafToSheaf_obj_of_W` / `_of_W_isZero` / `_of_isLocallyBijective`) and
recommended relocating the theorem downstream. Project sorry = 2 pre-existing (both frozen/dead). Build GREEN.

## What I did this phase
1. Processed the two iter-052 prover results (Lane A SOLVED → task_done; Lane B PARTIAL site lemmas →
   task_done; both result files cleared). Refreshed task_pending header.
2. **Wave 1 (parallel):** progress-critic `iter053` (CONVERGING, dispatch=OK), strategy-critic `iter053`
   (SOUND, 1 CHALLENGE + format drift), mathlib-analogist `tosheaf-reflect` (PROCEED — bridge is a
   3-line helper + native square), blueprint-writer `iter053-cechaug` (covers lines + site-lemma block +
   prose refresh + folds + label fix), lean-scaffolder `iter053` (created both new stub files + build wiring).
3. **Acted on the strategy-critic CHALLENGE (D2 below)** — rewrote `lem:cech_augmented_resolution`
   Steps 3–4 + `\uses` to the prepend-homotopy discharger.
4. blueprint-clean `iter053` (purity); blueprint-reviewer `iter053` → **Lane 1 GATE CLEARS**, Lane 2
   blocked by 1 must-fix (part-1 helper missing from `\lean{}`); fixed it (one-line `\lean{}` add) →
   blueprint-reviewer `iter053-recheck` → **Lane 2 GATE CLEARS**.
5. Verified `lake build` GREEN (8331 jobs; only the 3 expected stub-sorry warnings).
6. Updated STRATEGY (02KG → Completed; P5a split into two ACTIVE rows; `cechAugmented_exact` route
   rewritten to prepend-homotopy; trimmed DONE bullets; size 13.2→12.4 KB) and PROGRESS (two lanes).

## Decision made

### D1 — RELOCATE `cechAugmented_exact` to a NEW downstream file `CechAugmentedResolution.lean`.
- **Chosen:** new file importing CechAcyclic + HigherDirectImagePresheaf + AffineSerreVanishing +
  QcohTildeSections; the object layer (`cechAugmentedComplex`) stays upstream in CechHigherDirectImage.
- **Why:** the import cycle is real (iter-052 prover proved it). A new file (vs. reusing
  `AffineSerreVanishing.lean`) honours the standing file-splitting directive + the prover's explicit
  recommendation + keeps the deep resolution argument isolated for parallel work.
- **Risk/LOC:** ~200–350 LOC. Reversal signal: none expected (build green with stub).

### D2 — CORRECT the local discharger to the cover-agnostic prepend-`i_fix` homotopy (NOT tilde).
- **Chosen:** Step 3/4 of `lem:cech_augmented_resolution` now use the prepend-`i_fix` contracting
  homotopy over the basis `{V ⊆ some Uᵢ}` (the restricted cover `{Uₛ∩V}` has a member `=V` ⇒
  contractible). F-agnostic + cover-agnostic; NO qcoh/tilde/affineness.
- **Why:** strategy-critic `iter053` CHALLENGE — the blueprint named `affine_cech_vanishing_tilde_subcover`
  (the *standard cover {D(fᵢ)} of an affine* vanishing, the 02KG tool) to discharge a local check over
  the *restricted arbitrary cover {Uₛ∩V}*, where it does not apply. The correct, classical discharger is
  the insert-index homotopy (any sheaf, any cover, local contractibility where a member ⊇ V). The project
  already has the template (`CombinatorialCech.combHomotopy`/`combHomotopy_spec`,
  `FreeCechEngine.combHomotopy`; the objectwise recipe in FreePresheafComplex.lean L83–92). Verified the
  basis `{V ⊆ some Uᵢ}` is cofinal. blueprint-reviewer re-CLEARED the rewrite as correct.
- **Consequence:** `cechAugmented_exact` needs neither qcoh nor affineness for exactness; the scaffolded
  `hF`/`h𝒰` hyps are kept (downstream consumers have them) but unused by the proof.
- **Reversal signal:** if the F-valued objectwise prepend homotopy hits a real obstruction the prover
  can't build, fall back to splitting it as a dedicated sub-leaf next iter (effort-breaker).

### D3 — Open the P5a-consumer lane `higherDirectImage_openImmersion_comp` in parallel.
- **Chosen:** NEW file `OpenImmersionPushforward.lean`, two-decl scaffold (part-1 `_acyclic` + part-2
  `_comp`), mathlib-build.
- **Why:** it consumes only DONE upstream (`affine_serre_vanishing` just unblocked, +
  `higher_direct_image_presheaf` + P4); its blueprint is detailed + reviewer-cleared; it is independent
  of Lane 1 so the two run as genuine parallel prover lanes (standing parallelism directive). progress-critic
  confirmed opening it is not an over-load risk.
- **Risk:** deep, multi-step (part 2 in particular); may need >1 iter — mathlib-build hands off cleanly.

## Prior critique status
- strategy-critic `iter053` CHALLENGE (cechAugmented local discharger) — **ADDRESSED** (D2, blueprint
  rewritten + reviewer-recleared). Format drift — **ADDRESSED** (02KG row moved to Completed; 01I8 route
  subsection collapsed; size trimmed). No live REJECT.
- blueprint-reviewer `iter053` must-fix (open_immersion `\lean{}` missing part-1) — **ADDRESSED** (fixed +
  recheck cleared).
- progress-critic `iter053` CONVERGING, 0 must-fix.

## Subagent skips
- (none — all plan-phase highly-recommended subagents dispatched: progress-critic `iter053`,
  strategy-critic `iter053`, blueprint-reviewer `iter053` + `iter053-recheck`.)
