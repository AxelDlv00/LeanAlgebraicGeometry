# Lean Audit Report

## Slug
iter022

## Iteration
022

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 235–247 (stale).** The section comment `/-! ## Project-local Mathlib supplement — affine tilde dictionary -/` contains a block titled "What remains for the full object iso `pushforward_spec_tilde_iso`" describing a quasi-coherence obligation (`fromTildeΓ (pushforward (tilde M))` is an iso iff QC) as the "sole remaining obligation". The proof of `pushforward_spec_tilde_iso` (line 538) bypasses that route entirely via `pushforward_spec_tilde_iso_of_isLocalizedModule` + `tildeRestriction_isLocalizedModule`. The described obligation is now discharged (differently), making the "what remains" block stale.
  - **Line 1421 — sorry in `base_change_mate_fstar_reindex_legs`.** Genuine work-in-progress. The scaffold above (subst, simp-collapses via `gammaMap_pushforwardComp_*`, the literal-form `key` from `pullbackPushforward_unit_comp`) is real and compiles. The sorry represents the "mate-unwinding crux" (step iii of Seam 2) whose remaining blocker (literal-form lock preventing `rw [unitExpand]` / `rw [gammaDistribute]`) is accurately described at lines 1412–1420.
  - **Line 1613 — sorry in `base_change_mate_gstar_transpose`.** This is the focus of iter-022. The scaffold at lines 1552–1612 is **genuine**: `adjL`/`adjR`/`β` are set, `hpullinv`, `hcounitL`, `hcounitR` compile and derive correct intermediate steps, and `huce` after `rw [hcounitL, hcounitR]` is accurately described as the master counit-transport identity. The comment at 1591–1598 ("recipe step 1 COMPLETE — verified compiling") is accurate. The note at 1537–1540 correctly identifies that `base_change_mate_fstar_reindex` cannot be cited (sorry-backed) and that the inner-reindex content must be reproved inline — this is correct engineering caution, not an excuse.
  - **Line 1786 — sorry in `affineBaseChange_pushforward_iso`.** Genuine. The comment correctly identifies the "affine reduction" (restriction-compatibility of `pushforwardBaseChangeMap`) as a separate Mathlib-absent multi-hundred-LOC obligation.
  - **Line 1808 — sorry in `flatBaseChange_pushforward_isIso`.** Genuine. Comment describes the Čech-cohomology infrastructure dependency; explicitly deferred to a later iteration.
  - **Transitive sorry chain:** `base_change_mate_section_identity` (line 1647) calls `base_change_mate_gstar_transpose` (sorry-backed), and `base_change_mate_generator_trace` (line 1667) calls `base_change_mate_section_identity`. Both carry transitive sorry. `pushforward_base_change_mate_cancelBaseChange` (line 1704) similarly depends on the chain. This is acknowledged in the comments and not hidden.
  - **Heartbeat option at line 979** (`maxHeartbeats 4000000` for `base_change_mate_unit_value`): the proof uses `erw`/`simp` chains over stacked `restrictScalars`/tilde–Γ round-trips; justified by the observable tactic complexity.
  - **Heartbeat options at lines 1323 and 1425** (`maxHeartbeats 1600000` for sorry-backed lemmas): these options apply to declarations that terminate in `sorry`, so they do no real work and are harmless but slightly confusing.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`genericFlatnessAlgebraic` is PROVED** (no sorry in either branch). The `by_cases` at line 1988 produces two branches: the finite-`A`-module case delegates to `GenericFreeness.exists_free_localizationAway_of_finite`; the non-module-finite case assembles via `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` with all three obligations (subsingleton/torsion base, `B/𝔭` domain, short-exact splice) fully closed at lines 2010–2132 using L1/L4/L5 and the bridge `free_localizationAway_of_away_tower`. No `sorry` appears anywhere in the proof body.
  - **Stale section comment at ~line 1963.** The `/-! ## Generic flatness, algebraic form ... -/` section comment (preceding `genericFlatnessAlgebraic`) says "**Surviving residue** (`sorry` this iter): when `M` is finite over the *finite-type* algebra `B` but not module-finite over `A`, the genuine §4 dévissage is required…". The code no longer has a sorry in that branch. This description of a surviving sorry is stale and inaccurate — the actual status is better than claimed.
  - **File header lines 21–25 slightly overstated.** "Each blueprint-pinned declaration carries…a `sorry` body where the proof is not yet supplied." The file header then names only `genericFlatness` as the blueprint-pinned declaration; `genericFlatnessAlgebraic` is not in the blueprint-pinned list and its proof body is now complete. Minor, but the header's generic statement misleads.
  - **`set_option maxHeartbeats 1600000` + `synthInstance.maxHeartbeats 400000` on `genericFlatnessAlgebraic` (lines 1965–1970) — JUSTIFIED.** Assessment: (a) The assembly invokes `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` over a complex dévissage motive, synthesises `IsDomain`/`IsNoetherianRing`/`IsScalarTower` instances for `Localization.Away g` at multiple nesting levels, and bridges `LocalizedModule (powers g) C ≃ₗ Cg` through `IsLocalizedModule.iso` + `LinearEquiv.extendScalarsOfIsLocalization`. These are legitimately expensive. (b) The raised limits are *lower* than those of the sub-lemmas they call (L4 uses 4 M/1 M heartbeats; L5b uses 4 M/1 M), consistent with the assembly needing less per-elaboration-step budget than re-elaborating those sub-lemmas would. (c) The comment at lines 1966–1969 correctly identifies the `B/𝔭` branch as the driver; that branch is the most instance-heavy part of the proof. No structural defect masked.
  - **Line 2208 — sorry in `genericFlatness`.** Genuine. The proof reaches `obtain ⟨U₀, hU₀aff, hx₀, -⟩` (finding the first affine open), then stops. The comment (lines 2192–2207) accurately describes all remaining steps: quasi-compact cover of `p⁻¹(U₀)`, finitely many patches, applying `genericFlatnessAlgebraic` on each, taking `V = D(∏ fⱼ)`, and the flat-from-free conclusion. Now that `genericFlatnessAlgebraic` is proved, this sorry is closer to resolution than the comment implies.
  - **All GenericFreeness sub-lemmas are proved**: L1 (`exists_free_localizationAway_of_torsion`, line 168), L3a/L3b/L3c, L3, L4a (`gf_clear_one_denominator`), L4 (`exists_localizationAway_finite_mvPolynomial`), L5a (`gf_generic_rank_ses`), L5b.1/L5b.2/L5b.3, L5b (`gf_torsion_reindex`), L5 (`exists_free_localizationAway_polynomial`), `free_localizationAway_of_away_tower`. No sorry in any of them.
  - **Heartbeat options at lines 482–487** (`synthInstance 1M`, `maxHeartbeats 4M`) on `exists_localizationAway_finite_mvPolynomial`: the comparison-map (`ν`, `ψ`) + `aeval` assembly over stacked `Away` localisations is demonstrably heavy; justified.
  - **Heartbeat options at lines 1461–1466** (`synthInstance 1M`, `maxHeartbeats 4M`) on `gf_torsion_reindex`: the doubly-indexed `MvPolynomial (Fin (m+1)) (Localization.Away g)` instance chain is expensive; justified.
  - **Heartbeat option at line 1699** (`synthInstance 1M`) on `free_localizationAway_of_away_tower`: the doubly-localised carrier `LocalizedModule (powers h) (LocalizedModule (powers g) T)` drives expensive `OreLocalization`/`LocalizedModule` synthesis; justified.
  - **Heartbeat option at line 1820** (`synthInstance 1M`) on `exists_free_localizationAway_polynomial`: for the inductive-step wiring of the reindexed quotient module; justified.

---

## Must-fix-this-iter

None.

No excuse-comments were found. The sorries are substantiated work-in-progress backed by accurate plans and genuine scaffolds. No definition was found with a wrong body or a weakened statement. No parallel re-implementation of a Mathlib API was identified.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:235–247` — Stale section comment describing "what remains" for `pushforward_spec_tilde_iso`. The QC-route description (and its "sole remaining obligation") is now resolved via a different route (the localization route). The description should be removed or updated to record that the iso is proved and how.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:~1963` — Stale section comment claiming "Surviving residue (`sorry` this iter)" in the finite-type dévissage branch of `genericFlatnessAlgebraic`. The code has no sorry in that branch; the comment misleads about the proof status. Should be updated to reflect that `genericFlatnessAlgebraic` is proved.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1323,1425` — `set_option maxHeartbeats 1600000` applied to sorry-backed lemmas (`base_change_mate_fstar_reindex_legs`, `base_change_mate_fstar_reindex`). The option is harmless but does no work and may confuse the reader about whether the sorry-bearing code is "expensive to elaborate."
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:21–25` — File header says "each blueprint-pinned declaration carries…a `sorry` body"; by the file's own definition only `genericFlatness` is blueprint-pinned, which is accurate, but the generic sentence still slightly overstates.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2208` — Comment in `genericFlatness` correctly lists the remaining steps but doesn't note that `genericFlatnessAlgebraic` (which it depends on) is now proved, making the remaining work purely the geometric assembly.

---

## Excuse-comments (always called out separately)

None found. All sorry-bearing declarations carry honest descriptions of the genuine mathematical crux remaining. The note at `FlatBaseChange.lean:1537–1540` (warning not to cite the sorry-backed `base_change_mate_fstar_reindex`) is an example of correct caution, not an excuse.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (stale "what remains" comments — one in each file)
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are in honest, substantiated in-progress state; no wrong definitions, no fake scaffolds, no masked structural defects. The `base_change_mate_gstar_transpose` iter-022 scaffold is genuine. The raised heartbeat options on `genericFlatnessAlgebraic` are justified. Two major stale comments (one per file) overstate remaining obligations that have since been discharged.
