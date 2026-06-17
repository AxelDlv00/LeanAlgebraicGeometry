# Strategy Critic Report

## Slug
iter032

## Iteration
032

## Routes audited

### Route: FBC (affine lemma direct-on-sections + globalization)

- **Goal-alignment**: PASS — proving the i=0 base-change map is an iso on sections, then globalizing via a Čech-free finite equalizer, does deliver `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PARTIAL — the *math* of the section-identity triangle (domain read + codomain read + g*-transpose) is fine. What is *not* sound is the diagnostic reframe in the FBC-A risk cell: "iter-031 ROOT-CAUSE: the prescribed splice route was NEVER EXECUTABLE … a declaration-ordering bug, NOT a math wall." A pure declaration-ordering bug is a minutes-long fix (move three `have`s / lemmas above `_legs`), not a route that needs a fresh corrective round *and* a tripwire. The persistent obstruction that has actually consumed ~14 iters is the term-mode splice **across the `X.Modules` instance diamond** (keyed `rw`/`simp`/`erw` "CONCLUSIVELY dead", per the cell itself). Calling that "ordering, not a wall" understates the real difficulty and is the kind of comforting re-diagnosis that keeps an over-budget route alive.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The route is re-justified each iter by a freshly-located local cause (iter-029 "keyed rewriting dead" → iter-031 "declaration ordering") rather than by re-evaluating whether direct-on-sections term-mode splicing is the right global vehicle at all.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none fatal. `conjugateEquiv_counit_symm` is stated as already proven (project-side); the named `Adjunction.comp_counit_app`, `pullbackComp`, etc. are standard. Not independently re-verified here (project-internal term mechanism, no new external lemma claimed).
- **Effort honesty**: under-counted — `Iters left: 1–2` on a phase that entered iter-018 and is now ~14 iters over a 2–3 estimate. The `1–2` is the same optimistic figure that has been wrong every prior round; treat it as "1 corrective round THEN a forced fork," not a credible completion estimate.
- **Parallelism under-exploited**: yes — FBC-B (`H⁰`-as-equalizer packaging + flat `−⊗B` preserves a finite equalizer) is marked NEXT / "Sequenced after gstar," but its core content (sheaf-condition equalizer for `SheafOfModules`, `Mathlib.RingTheory.Flat.Equalizer`) does not depend on the FBC-A section identity and could be scaffolded now. Serializing it behind a 14-iter-stuck phase compounds the FBC leg's schedule risk.
- **Verdict**: CHALLENGE

### Route: GF (algebraic core → geometric wrapper)

- **Goal-alignment**: PASS — wrapping `genericFlatnessAlgebraic` over a finite affine cover with the localisation `V = D(∏ fⱼ)` yields `thm:generic_flatness`; the `[IsIntegral S]`+`[QuasiCompact p]` base hypotheses are correctly flagged as required-or-false.
- **Mathematical soundness**: PASS — standard Nitsure §4 patch-and-localise; G1/G3 correctly identified as the project-built residue, with G1 bottoming at gap1.
- **Verdict**: SOUND

### Route: QUOT (Hilbert poly + Quot/Grassmannian defs + gap1)

- **Goal-alignment**: PASS — Hilbert-poly-as-graded-Hilbert-function (`existsUnique_hilbertPoly` + done Hilbert–Serre rationality) and `Grassmannian := QuotFunctor (𝟙 S) V Φ_d` align with `def:hilbert_polynomial`/`def:quot_functor`/`def:grassmannian_scheme`.
- **Mathematical soundness**: PASS — the gap1 4-step spine (C done → P1 → D → assembly) is the standard Hartshorne II.5.3/II.5.5 mechanism. D (section-localization descent) is correctly the keystone: it is the *engine* (Γ(D(f),F)=M_f via quasicoherence), not a consequence of the iso it serves, so there is **no circularity** — the common worry "isn't section-localization just gap1 restated?" does not bite here.
- **Infrastructure-deferral detected**: no — gap1's hardest piece (D) is on a concrete in-project critical path with a named consumer, not deferred upstream.
- **Phantom prerequisites**: minor mis-attribution, not phantom. The cell claims "Mathlib has `isIso_fromTildeΓ_iff` + the global-Presentation case only." loogle finds **no `isIso_fromTildeΓ` in Mathlib**; Mathlib provides `ModuleCat.tilde` / `ModuleCat.Tilde.*` and `isIso_fromTildeΓ_iff` / `isIso_fromTildeΓ_of_presentation` are **project-side** (the "in-file iff engine," listed DONE). So the P1 "NOW UNBLOCKED" claim rests on *project* infra, which is fine, but the strategy should stop attributing it to Mathlib. Separately, the keystone D cites **Stacks 01HA**, a tag NOT in `references/summary.md`; the math (Hartshorne II.5.3) is sound but the tag is unverified — confirm before quoting it in the blueprint.
- **Effort honesty**: reasonable — `QUOT-repr` at `6–12 iters / ~400–1000+ LOC` is honestly the deepest target; not under-counted.
- **Verdict**: SOUND

### Route: GR-sep/proper (diagonal closed immersion + valuative criterion)

- **Goal-alignment**: PASS — separated-then-proper on the now-glued `Grassmannian.scheme` feeds `thm:grassmannian_representable`.
- **Mathematical soundness**: PASS — separatedness as a closed-immersion diagonal checked on the `U^I×U^J` chart cover (surjective comorphism `δ_{I,J}`) is the standard glued-from-affines argument; proper via valuative criterion correctly sequenced after.
- **Parallelism under-exploited**: no — running it now as a parallel lane is structurally correct (depends only on the DONE glued scheme + charts/cocycle, lives in `GrassmannianCells.lean`, no gap1/FBC dependency). The only contention to watch is same-file edits if any GR-glue follow-up reopens, but glue is closed.
- **Verdict**: SOUND

## Format compliance

- **Size**: 133 lines / ~10 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive in prose cells, e.g. `"keyed-rewriting CONCLUSIVELY DEAD vs X.Modules diamond (iter-029)"`, `"iter-031 ROOT-CAUSE: the prescribed splice route was NEVER EXECUTABLE"`, `"OVER_BUDGET (entered iter-018); REVISED tripwire … → iter-033 decides"`, `"gap1 route (analogist iter-030)"`, `"Decision (iter-024): build it ONCE QUOT-side"`. These iter-by-iter diagnostics belong in `iter/iter-NNN/plan.md`, not in STRATEGY.md prose.
- **Accumulation detected**: no — completed phases (GR-glue, gap1 bridge C) correctly moved to `## Completed`; the active table holds only live phases. The bloat is inside cells, not stale rows.
- **Table discipline**: FAIL — `## Phases & estimations` Risk cells violate "one short line per cell." The FBC-A Risk cell is an ~8-line multi-sentence paragraph (root-cause narrative + route-b recipe + tripwire); the QUOT-defs and GF-geo Risk cells are similarly multi-sentence.
- **Format verdict**: NON-COMPLIANT

## Sunk-cost flags

- `"iter-031 ROOT-CAUSE: the prescribed splice route was NEVER EXECUTABLE … a declaration-ordering bug, NOT a math wall"` — Why this is sunk-cost: it reframes a 14-iter, 5–7× over-budget stall as a trivial mechanical slip, which lets the same route survive one more round instead of forcing the fork; "the previous prescription was never executable" is itself an admission that prior estimates were fiction. Recommendation: judge the corrective on its own merits with a *hard* cutover (not "decide at iter-033"), and scope the ModuleCat re-encoding fork as a real, parallel alternative now (see below).
- `"REVISED tripwire"` (FBC-A) — Why this is sunk-cost: a tripwire that has been "REVISED" rather than fired after entering at iter-018 is a moving goalpost. Recommendation: make iter-033 a commitment, not a re-revisable checkpoint.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`, requires `[Field F] [CharZero F]` — matches the strategy's `[CharZero]` note).
- `Module.flat_of_isLocalized_maximal`: VERIFIED (`Mathlib.RingTheory.Flat.Localization`).
- `ModuleCat.tilde` / `ModuleCat.Tilde.*`: VERIFIED (`Mathlib.AlgebraicGeometry.Modules.Tilde`) — the base tilde API exists.
- `isIso_fromTildeΓ_iff`, `isIso_fromTildeΓ_of_presentation`: MISSING from Mathlib (loogle: no `isIso_fromTildeΓ` hits) — these are PROJECT declarations; the strategy mis-labels them "Mathlib has."
- Stacks tag `01HA` (keystone D citation): UNVERIFIED — not in `references/summary.md`; confirm the tag before blueprint-quoting (the Hartshorne II.5.3 content is sound regardless).

## Must-fix-this-iter

- Route FBC: CHALLENGE — (a) the **ModuleCat-level re-encoding fork is not documented in `## Open strategic questions`** (the directive itself calls it "Open Q2," but STRATEGY.md has only Q1 + two bullets); a fork the planner intends to decide at iter-033 must be a written open question with both arms and a decision trigger, or it cannot be honestly weighed. (b) Stop characterising the obstruction as "ordering, not a math wall"; it is the `X.Modules` diamond splice. (c) Run the FBC-A corrective and the ModuleCat re-encoding as **parallel** preparation rather than serial "corrective → then maybe pivot," and unblock FBC-B's independent equalizer scaffolding now instead of sequencing it behind a 14-iter-stuck phase.
- Format: NON-COMPLIANT — collapse the per-iter narrative out of the Phases Risk cells into `iter/iter-032/plan.md`, and shrink each Risk cell (esp. FBC-A, QUOT-defs, GF-geo) to one short line. Restructure in place this iter.

## Overall verdict

Three of the four lanes are sound. GF and QUOT/gap1 are well-decomposed: the gap1 4-step spine (C→P1→D→assembly) is the right shape, **D (section-localization descent) is correctly the keystone with no circularity**, and running GR-separated as a parallel lane off the now-glued scheme is structurally clean. The QUOT prerequisites verify (`existsUnique_hilbertPoly`, `flat_of_isLocalized_maximal`, the `ModuleCat.tilde` API), with two cleanups owed: `isIso_fromTildeΓ_*` are project-side, not Mathlib, and the keystone's Stacks 01HA tag is unverified against the reference index. The strategy does **not** exhibit an infrastructure-deferral pattern — no goal-required construction is pushed to "upstream" or "future work." The live problem is **FBC**: a 5–7× over-budget phase kept alive by a sunk-cost reframe ("declaration-ordering bug, NOT a math wall") and a repeatedly-"REVISED" tripwire, with its genuine strategic alternative (the ModuleCat re-encoding) absent from `## Open strategic questions` and its independent successor (FBC-B) needlessly serialized. "One more corrective round, then escalate at iter-033" is acceptable only if iter-033 is made a hard commitment, the ModuleCat fork is written up as a real open question and prepared in parallel now, and FBC-B's equalizer scaffolding starts in parallel — otherwise it is one more single-threaded extension of the same stall. Format is NON-COMPLIANT (pervasive per-iter narrative + paragraph-length table cells) and must be restructured in place this iter.
