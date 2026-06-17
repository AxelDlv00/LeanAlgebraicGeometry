# Strategy Critic Report

## Slug
iter037

## Iteration
037

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Verdict**: SOUND

### Route: The acyclicity bridge (Čech↔derived, 01XJ/01EO)

- **Verdict**: SOUND — the non-circular regression-break (P3 standard-cover vanishing → 01EO dimension-shift → affine sheaf vanishing, never consuming affine vanishing) is correctly structured; the three bricks are reported done and 01EO closed.

### Route: 01I8 affine `F≅~(ΓF)` — section-localization (the live "Route B")

This is the directive's focus. I verified the full B-chain infrastructure against Mathlib source.

- **Goal-alignment**: PASS — produces unconditional `[IsQuasicoherent F] → IsIso F.fromTildeΓ`, which is the exact instance 02KG's gated tops consume.
- **Mathematical soundness**: PASS — see prerequisite verification. Crucially, Mathlib's own `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) proves the single-presentation case via `PreservesCokernel.iso (tilde.functor R)` — i.e. tilde *right*-exactness on the presentation cokernel. That is precisely the mechanism the strategy's non-circularity pitfall mandates ("identification via left adjoint preserving the cokernel, NOT left-exact Γ of an abstract cokernel"). The route therefore inherits a working, non-circular template rather than inventing one.
- **(a) Is B1–B6 a genuine route or does it hide a wall?** Genuine. Each step maps to existing Mathlib:
  - B1 `QuasicoherentData` (Quasicoherent.lean:201) with field `presentation (i) : (M.over (X i)).Presentation` — the cover + per-`Uᵢ` presentation is literally the structure.
  - B2 `Presentation.map` (Quasicoherent.lean:179) — restriction is a colimit-preserving left adjoint, so it maps presentations. Verified present.
  - B3 engine `pushforwardPushforwardEquivalence` (PushforwardContinuous.lean:305) + `Over.forgetAdjStar` (line 276) — verified present. This is the one real *build* (site/IsContinuous plumbing) but it is bounded categorical glue over an existing equivalence engine, not missing mathematics.
  - B4 `Presentation.ofIsIso` (Quasicoherent.lean:132) — verified present.
  - B5/B6 reported done (`section_isLocalizedModule_of_presentation`, `isLocalizedModule_of_span_cover`).
  No hidden wall. B3 is the load-bearing lane and is honestly labelled as such.
- **(b) Does dropping the `IsLocalizing` shortcut leave assembly viable?** Yes. `IsLocalizing` / `isIso_fromTildeΓ_iff_isLocalizing` confirmed ABSENT (only hit is `Probability/Process/LocalProperty.lean`, an unrelated measure-theory predicate). Assembly via per-`D(f)` `IsLocalizedModule.lift` + `isIso_fromTildeΓ_iff` (Tilde.lean:340, essImage form — verified present) is mathematically self-contained: source `(ΓM)_f` and target `Γ(D(f),M)` are both localizations of `ΓM` at `powers f`, the component map is the lift, hence iso on every basic open. `IsLocalizing` was packaging, not load-bearing.
- **(c) Non-circularity with 02KG**: PASS. 01I8 Route B never invokes affine `Hⁱ`-vanishing; the per-`D(gⱼ)` identification routes through tilde right-exactness (confirmed to be how Mathlib does it). 02KG's two FALSE-ready tops are gated on unconditional `qcoh_iso_tilde_sections` and the strategy explicitly forbids dispatching them until 01I8 closes. Dependency is strictly one-directional.
- **Phantom prerequisites**: none — every named Mathlib symbol verified to exist (see Prerequisite verification).
- **Effort honesty**: reasonable, mildly optimistic on B3. ~200–400 LOC / ~2–4 iters with B0/B5/B6 done and B1/B2/B4 thin wrappers is credible; B3's "fiddly site/IsContinuous plumbing" is the realistic overrun risk, but comparable completed categorical-plumbing rows (P3b: ~1500 LOC / ~9 iters) show the team absorbs this class of work.
- **Verdict**: SOUND

### Route: Absolute cohomology — Ext of the corepresenting object (Form B)

- **Verdict**: SOUND

## Format compliance

- **Size**: 141 lines / 13699 bytes — lines within budget; bytes ~14% over the ~12 KB guidance (DRIFT, minor).
- **Headings**: PASS — actual file carries exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in order. (The `## References index` / `## Blueprint chapters` / `## Project goal` blocks appended in my directive are dispatcher scaffolding, NOT in the file — confirmed by reading STRATEGY.md directly.)
- **Per-iter narrative detected**: yes — line 56–57: *"(analogist `bridge`, iter-037 corrected the earlier \"needs none\" overclaim)"*. The substantive claim ("NOT base-change-free, per analogist `bridge`") is fine; the `iter-037 corrected the earlier overclaim` clause is per-iter narrative that belongs in the iter sidecar, not STRATEGY.md.
- **Accumulation detected**: yes (minor) — `### Route B — two spectral sequences (REJECTED)` is an excised route still occupying a `## Routes` subsection (2-line decision note; borderline-acceptable but technically belongs in a sidecar). Compounded by a **name collision**: "Route B" denotes BOTH the rejected spectral-sequence route AND the live 01I8 section-localization route, which is a genuine readability hazard the planner should disambiguate (e.g. rename the live one "01I8 section-localization route").
- **Table discipline**: PASS — both tables are well-formed, one-line cells; `## Completed` is 6 rows (within bound).
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Format: DRIFTED — (1) delete the `iter-037 corrected the earlier overclaim` clause at line 56–57 (per-iter narrative); (2) disambiguate the "Route B" name collision (rejected spectral-sequence route vs. live 01I8 section-localization route); (3) optionally trim toward the 12 KB budget. In-place edits, no restructure needed.

## Prerequisite verification

- `Scheme.Modules.fromTildeΓ`: VERIFIED (Tilde.lean:195)
- `isIso_fromTildeΓ_iff` (essImage form): VERIFIED (Tilde.lean:340)
- `isIso_fromTildeΓ_of_presentation`: VERIFIED (Tilde.lean:398) — and its proof uses tilde right-exactness, matching the route's non-circular mechanism
- unconditional `[IsQuasicoherent M] → IsIso M.fromTildeΓ`: MISSING (Mathlib's `IsQuasicoherent` section ends at line 410 with only the per-`Presentation` lemma + the reverse `(tilde M).IsQuasicoherent` instance) — confirms the project genuinely must build this; strategy's claim correct
- `IsLocalizing` / `isIso_fromTildeΓ_iff_isLocalizing`: MISSING (no qcoh-sense occurrence; only an unrelated `Probability/Process/LocalProperty.lean` predicate) — confirms the shortcut is correctly off the table
- `pushforwardPushforwardEquivalence`: VERIFIED (PushforwardContinuous.lean:305), with `pushforwardPushforwardAdj` (226) and `Over.forgetAdjStar` (276)
- `QuasicoherentData` (+ `.over (X i)` presentation field): VERIFIED (Quasicoherent.lean:201/208)
- `Presentation.map`: VERIFIED (Quasicoherent.lean:179)
- `Presentation.ofIsIso`: VERIFIED (Quasicoherent.lean:132)
- `IsQuasicoherent`: VERIFIED (Quasicoherent.lean:249)

## Overall verdict

The corrected 01I8 strategy is sound. The earlier "Route B needs no base-change" claim was rightly retracted; the B1–B6 decomposition is a genuine route to the keystone, not a wall in disguise — every named Mathlib dependency (`QuasicoherentData`, `Presentation.map`, `Presentation.ofIsIso`, `pushforwardPushforwardEquivalence`, `fromTildeΓ`, `isIso_fromTildeΓ_iff`) is verified present, and the one real build (B3) is bounded categorical plumbing over an existing equivalence engine. Dropping the `IsLocalizing` shortcut is harmless: it does not exist in Mathlib, and the per-`D(f)` `IsLocalizedModule.lift` + `isIso_fromTildeΓ_iff` assembly is self-contained. Non-circularity with 02KG holds and is reinforced by the fact that Mathlib's own `isIso_fromTildeΓ_of_presentation` discharges the per-piece identification through tilde right-exactness — exactly the mechanism the strategy's pitfall-warning prescribes. No infrastructure-deferral findings; no phantom prerequisites; no sunk-cost reasoning. The only must-fix items are format DRIFT: one per-iter-narrative clause ("iter-037 corrected the earlier overclaim") and a "Route B" name collision, both fixable in place this iter.
