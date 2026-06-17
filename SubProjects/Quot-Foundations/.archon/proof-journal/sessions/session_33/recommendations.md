# Session 33 (iter-033) — Recommendations for the next plan iteration

## TOP PRIORITY — FBC: PIVOT, do not re-assign direct-on-sections
The sanctioned "one final round" override against the FBC **STUCK** verdict FAILED — `_legs` @1495 is
still sorry. The plan's unconditional commitment (b) fires: **iter-034 must abandon the direct-on-sections
vehicle and execute STRATEGY Open Q2 arm (a): re-encode the base-change map at the
`ModuleCat`/`SheafOfModules` level so the `X.Modules` instance diamond never forms.**
- This is a **refactor**, not a prove round. Recommend a refactor and/or effort-breaker pass FIRST to set
  up the new encoding, then provers on the resulting pieces.
- **Do NOT** dispatch any prover (whole-goal, fine-grained, wrapper, or term-mode-splice) at `_legs` or
  `gstar_transpose` on the current encoding. The residual is cross-layer naturality (F2/F3 cancellers in
  `(Spec φ)_* ⋙ Γ_R` vs partners in `Γ_R' → gammaPushforwardIso ψ → restrictScalars ψ`), which the
  explicit-factor route provably cannot express. Handoff: `informal/base_change_mate_fstar_reindex_legs.md`.
- `gstar_transpose` @1744 is transitively gated on `_legs` — do not assign in isolation.

## HIGH — closest-to-completion targets to prioritize next iter
1. **GR `Grassmannian.isSeparated`** — strongest close candidate. The hard ingredient
   (`diagonalRingMap_surjective`, the surjective restricted-diagonal comorphism) AND the e₂ source iso
   (`pullbackιIso`) are axiom-clean. Remaining = the geometric glue assembly (per-patch closed immersion
   from the surjective comorphism via "Spec of a surjective ring map is a closed immersion" + target iso +
   terminal-vs-`Spec ℤ` reconciliation + two-leg `hom_ext`). 1–2 iter formalization, fully scouted (route
   (b) in `task_results/.../GrassmannianCells.lean.md`). **Name the keystone `…Grassmannian.isSeparated`**
   to match the `lem:gr_separated` pin.
2. **QUOT `isIso_fromTildeΓ_restrict_basicOpen` (gap1 P1)** — the slice→geometric Presentation-transport
   machinery is now in place axiom-clean (`presentationPullbackιOfQuasicoherentData`). Remaining =
   basic-open restriction + `isIso_fromTildeΓ_of_presentation` (affine descent / keystone D, Stacks 01HA).
   **Confirm the Stacks tag 01HA against a reference before blueprint-quoting D** (flagged in the iter-034
   ramp). Reuse the heartbeat triple + `set_option`-above-docstring ordering for the slice-site synthesis.

## HIGH — FBC-B lane is live and fully independent of FBC-A
`FlatBaseChangeGlobal.lean` landed the finite-affine-cover + sheaf-condition-equalizer infrastructure
(3 axiom-clean decls). Continue this lane next iter regardless of the FBC-A pivot: assemble the affine
base-change comparison (`affine_base_change_pushforward` @2017 in `FlatBaseChange.lean`) and the global
gluing using `Modules.exists_finite_affineCover_isLimit_sheafConditionFork`. This is the de-risked,
parallel path the strategy-critic prescribed.

## MEDIUM — coverage debt: 14 unmatched `lean_aux` need blueprint blocks (planner authors prose)
`archon dag-query unmatched` → 14 nodes. Per the "Lean ⟹ tex" doctrine the planner must add blueprint
blocks (the review agent does not author prose). Suggested labels are in the task results.
- **GR (GrassmannianCells.lean)** — `diagonalRingMap` (`def:gr_diagonalRingMap`),
  `diagonalRingMap_left`/`_right` (`lem:gr_diagonalRingMap_apply`), `transitionPreMap_minorDet_swap_mul`
  (`lem:gr_transitionPreMap_minorDet_swap_mul`), `diagonalRingMap_surjective`
  (`lem:gr_diagonalRingMap_surjective`), `pullbackιIso` (`def:gr_pullbackιIso`), and the pre-existing
  `rotMid`/`transitionInvImageMatrix`/`transitionInvPair` (private helpers of `cocyclePhiId`). Wire
  `lem:gr_separated`'s `\uses` to `lem:gr_diagonalRingMap_surjective`.
- **QUOT (QuotScheme.lean)** — `isIso_unitToPushforwardObjUnit_of_isIso'` (private; pin with
  `% NOTE: private`), `overRestrictUnitIso`, `overRestrictPresentation`,
  `presentationPullbackιOfQuasicoherentData`. The P1 proof sketch needs these as intermediate pinned
  blocks for traceability (lvb-quotscheme major).
- **FBC-B (FlatBaseChangeGlobal.lean)** — `exists_finite_affineCover_isLimit_sheafConditionFork`
  (the consolidation lemma; label e.g. `lem:gamma_finite_equalizer_consolidated`) — lvb-fbcglobal major.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- FBC `_legs`: term-mode `congrArg` collapses the trailing transparent `pushforwardComp` factor; cross-layer
  naturality is the unbreakable residual for the explicit-factor route.
- `TensorProduct ℤ` of `MvPolynomial` rings: `inferInstance`/explicit `Semiring` annotation fails — drop the
  return-type annotation (GR `diagonalRingMap`).
- Slice→geometric `SheafOfModules.Presentation` transport: `overRestrictEquiv.functor` is a `pushforward`;
  unit iso via the `IsIso ψ` route (ψ=𝟙), NOT `PullbackFree` finality; `.{u}` on `Presentation.map`/`ofIsIso`;
  heartbeat triple + `set_option`-above-docstring.
- Sheaf-condition fork as a limit: `gammaIsLimitSheafConditionFork := ((isSheaf_iff_isSheafEqualizerProducts
  M.presheaf).mp M.isSheaf U).some`; finite affine cover via `isCompact_iff_finite_and_eq_biUnion_affineOpens`.

## Blocked / do-not-retry
- **FBC `_legs` / `gstar_transpose` direct-on-sections** — exhausted (see TOP PRIORITY). No more keyed
  rewriting, no more term-mode-splice rounds on the current encoding.
- **GR/QUOT keystones via a single sorry'd stub** — the no-sorry invariant means a half-done keystone is
  deleted, not committed; assign these as complete assemblies (with all sub-ingredients already landed),
  not as "fill the one remaining sorry."

## Pre-existing issues surfaced (not iter-033 regressions)
- GR blueprint: 8 `private` declarations pinned with public `\lean{}` names that don't resolve under
  `lake env lean` (sync_leanok works around it). Low priority; either promote to non-private or annotate.
- GR module docstring (L8–21) is stale ("single declaration … affineChart"); ~1300 lines now.
- QUOT `Grassmannian.representable` skeleton is weaker than the blueprint prose (no smoothness/properness/
  Plücker); already documented by a `% NOTE` at blueprint L3832.

## Subagent reports (this review)
- `task_results/lean-vs-blueprint-checker-fbcglobal-iter033.md` — 0 must-fix; 1 major (consolidation-lemma
  coverage debt), 1 minor (generality note — APPLIED by review: `% NOTE` on `lem:gamma_finite_equalizer`).
- `task_results/lean-vs-blueprint-checker-grcells-iter033.md` — 0 must-fix; 2 major (dangling `isSeparated`
  pin — APPLIED `% NOTE` by review; 6-decl coverage debt), 2 minor (private pins, stale docstring).
- `task_results/lean-vs-blueprint-checker-quotscheme-iter033.md` — 0 must-fix; 1 major (4-decl coverage
  debt + P1 traceability), 1 minor (Grassmannian.representable weakening, pre-existing).
- `task_results/lean-auditor-iter033.md` — see "lean-auditor findings" below.

## lean-auditor findings (`task_results/lean-auditor-iter033.md`)
Overall: all 4 files structurally sound; FBC's 4 sorries genuine + properly disclosed (including the
transitive sorry-backing chain `section_identity → generator_trace → cancelBaseChange`); GR entirely
sorry-free; the QUOT slice-transport infra + FBCGlobal decls non-vacuous.

- **4 "must-fix" — NOT actionable this iter (protected stubs, by design).** The flagged
  `hilbertPolynomial` / `QuotFunctor` / `Grassmannian` / `Grassmannian.representable` (QuotScheme.lean
  @123/161/198/225) are the blueprint-authorized PROJECT-GOAL stubs listed in `archon-protected.yaml`;
  their "for the iter-NNN file-skeleton the body is a typed sorry" comments trip the auditor's
  excuse-comment rule, but the auditor itself records them as "known project goals, not hidden defects —
  remediation is iterative proof work, not removal." Types correct; no in-file dependents. **Disposition:
  record as known planned-work sorries; do not act.** (These are gated on gap1 / downstream lanes.)
- **3 "major" — RESOLVED (build-verification false alarms).** The auditor (read-only, no build) could not
  confirm `isCompact_iff_finite_and_eq_biUnion_affineOpens`, `quasiSeparatedSpace_iff_forall_affineOpens`,
  and `M.presheaf`/`M.isSheaf` on `SheafOfModules`. All three resolve: `FlatBaseChangeGlobal.lean`
  `lake build` is GREEN and `lean_verify` returns `{propext, Classical.choice, Quot.sound}`. No action.
- **3 "minor" — cosmetic, optional cleanup.** Stale iteration-narrative comments in `FlatBaseChange.lean`
  (L845 "STATUS (iter-011) … fully proved" on `base_change_mate_regroupEquiv` — accurate but dead prose;
  L224 "UPDATE (resolved)" narrative; L1844 "recipe step 1 COMPLETE" scaffold note). Harmless; a future
  comment-cleanup refactor could prune them. Note: `base_change_mate_regroupEquiv` IS fully proved
  (grep-confirmed), so the L845 comment is not laundering.
