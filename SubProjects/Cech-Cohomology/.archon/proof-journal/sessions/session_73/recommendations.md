# Recommendations — after iter-073

## CRITICAL — tooling, fix BEFORE any prover re-dispatch on CSI
- **CSI (2475 LOC) is no longer reliably inline-verifiable.** iter-073's prover landed **0 edits** purely because every `lake build`/`lake env lean` verification got OOM/timeout-killed (exit 137/144; background `lean` >6 min). The route's 2 atomic leaves are NOT the obstacle — the build environment is. Pick ONE corrective:
  1. **Split `CechSectionIdentification.lean`** so each leaf (`coreIso_comm_leg`, `sectionCechAugV_π`) sits in its own smaller downstream module that builds in available memory. Cheapest durable fix; dispatch the `refactor` subagent with a precise split plan (the two leaves + their private dependency clusters). Preserve frozen `\lean{}` names.
  2. OR **sanction LSP-only proving for this file** this round: prover lands edits checked by `lean_diagnostic_messages` + the loop's deterministic `sync_leanok`/CI `lake build` (which DID complete, 337s) as the real verification gate. Risk: kernel-soundness trap (LSP accepts unsound rfl `lake env lean` rejects) — mitigate by requiring the next review to confirm `#print axioms` clean once the post-prover sync build runs.
- Do **NOT** bare-re-dispatch a prover on CSI as-is — it will re-hit the same wall and waste another iter (this is the 2nd flat iter; 072 made real foundation progress but 073 made none).

## Closest-to-completion targets (route SOUND, blueprint complete, gate passed)
1. **`sectionCechAugV_π`** (CSI:2081) — planner-ordered FIRST. Degree-0 augmentation seam, the cheaper structural leaf. Tool: `leftAdjointUniq` (`Adjunction/Unique.lean:36`); unwinds via proved `pushPull_sigma_iso_π` + `pushPull_leg_sections`. Closing it makes the whole Stub-6 homotopy sorry-free.
2. **`coreIso_comm_leg`** (CSI:1536) — per-coface combinatorial leaf (the iter-072 (a)–(d) seam split). Tools: `Pi.mapIso` (`Limits/Shapes/Products.lean:393`) + `piComparison_comp_π` for the ∏-leg vs pushPull σ-iso match; `pushforward` def @ `Sheaf.lean:151`.

## Do-not-retry / churn guard
- Both leaves are blocked behind the **build wall**, not a math/strategy wall. The progress-critic's iter-073 watch-flag ("close ≥1 this iter") was **NOT** satisfied — but the cause is tooling, not route-churn. Next plan phase should treat this as a **STUCK-on-tooling** signal: address the build environment (split or LSP-mode) rather than effort-breaking the leaves further (they are already atomic) or pivoting the route (it is sound).

## Housekeeping (low priority, carry forward from iter-066)
- Stale OpenImm `.lean` comments (877–896, 956–966) misdescribe closed cases / `hacyc`; un-`private` `isAffineHom_of_affine_separated`/`sectionsCorep`/`sectionsCorepPushforward` so `sync_leanok` can mark `_acyclic`/`jshriek_transport_along_iso`. Fold into the CSI split refactor if it touches those files; otherwise next cleanup pass.

## Clean signals
- Coverage debt `unmatched` = 0; blueprint-doctor clean; gaps = 6 (unchanged strategic ∞-holes).
