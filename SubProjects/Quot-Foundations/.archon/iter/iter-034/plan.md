# Iter 034 — Plan (Quot-Foundations)

## TL;DR

Resumed an interrupted iter-034 plan phase (the prior run had dispatched the 2 mandatory critics +
`mathlib-analogist fbc-mate` and re-encoded the FBC blueprint to the conjugate route, then stopped before
finalizing PROGRESS/sidecar). Consumed that work, cleared the remaining coverage debt, ran the gate, and
dispatched **four parallel import-independent prover lanes**:

1. **FBC-A** [fine-grained] — the **conjugate-side re-encoding** of `_legs` (the iter-033 pivot's first
   prover round). Direct-on-sections is ABANDONED. Recipe from `mathlib-analogist fbc-mate`
   (`analogies/fbc-mate-reencode.md`): re-cut `codomain_read_legs` proof-free from `leftAdjointCompIso`,
   restate `_legs`, discharge via `conjugateEquiv.injective` + the reassoc conjugate set.
2. **FBC-B** [mathlib-build] — the **independent** ModuleCat-over-A eqLocus sub-lane feeding
   `LinearMap.tensorEqLocusEquiv` (not blocked on FBC-A; the downstream chain is).
3. **QUOT-P1** [mathlib-build] — build the keystone `isIso_fromTildeΓ_restrict_basicOpen` via the
   5-step affine descent (unblocked by this-iter's `overRestrictPresentation`).
4. **GR-sep** [mathlib-build] — build the keystone `Grassmannian.isSeparated` via route (b)
   (structure morphism `π : scheme → Spec ℤ` + the Proj template; the ring heart is done).

Coverage debt cleared (9 helper blocks, writers `quot-cov`/`gr-cov`). STRATEGY format-scrubbed
(strategy-critic DRIFTED). Gate re-cleared (blueprint-clean + blueprint-reviewer `iter034b`: all 4 lanes CLEAR).

## State at entry (verified from iter-033 task_results + leandag + the iter-034 critics)

- **FBC-A** 4 sorries, route ruled out at iter-033 (term-mode collapse landed; residual = cross-layer
  naturality the explicit-factor route can't express). Blueprint ALREADY re-encoded to the conjugate route
  by the interrupted phase (`lem:base_change_mate_codomain_read_legs` NOTE @~1185).
- **FBC-B** new file, +3 axiom-clean; 4 chain links blocked on FBC-A's affine sorry; eqLocus sub-lane
  independent + decomposed.
- **QUOT** 4 protected stubs; +4 axiom-clean slice-transport infra; P1 keystone has a concrete 5-step recipe.
- **GR** 0 sorries; +6 axiom-clean ring heart (`diagonalRingMap_surjective`); `isSeparated` has route (b).
- **GF** 1 sorry (gated on gap1 + a newly-flagged `gf_torsion_reindex` OreLocalization fix).

## Decision made — dispatch the FBC-A conjugate prover THIS iter (not a 2nd plan-only iter)

The progress-critic `iter034` returned **STUCK** for FBC-A and sanctioned iter-034 as a (first) plan-only
pivot iter, expecting the analogist consult this iter and the prover next. I go one better and **dispatch
the conjugate prover this iter**, because the two prerequisites it named are already satisfied:
- **(shape confirmed)** `mathlib-analogist fbc-mate` returned a concrete conjugate-side recipe, and
- **(diamond avoided — the must-fix)** BOTH the analogist and strategy-critic `iter034` confirm the
  coherence is discharged by proven Mathlib mate lemmas *at the functor layer where the `X.Modules`
  diamond never forms* (analogist: "so the `X.Modules` diamond never forms"; strategy-critic: "moving a
  coherence from prove-under-a-diamond to cite-from-the-library passes the pivot test").

This is strictly better than a 2nd plan-only iter: it removes the progress-critic's consecutive-plan-only
avoidance risk and starts paying down the pivot now. The blueprint conjugate route is gate-cleared
(blueprint-reviewer `iter034b`). LOC/risk: comparable to `RegroupHelper` (011·4, ~120 LOC); the residual
risk is the `pushforwardBaseChangeMap ≅ mateEquiv` identification, but iso-ness is ALREADY free
(`pullback_spec_tilde_iso = conjugateIsoEquiv`), so the open work is only the `_legs` coherence, for which
the analogist gave the explicit `.injective`/reassoc route. Reverse signal: if this round closes nothing,
fall back to the tripwire below.

**Tripwire (do not re-date):** if the iter-035 FBC-A round (this one is iter-034's) closes ≥1 of
`_legs`/`gstar_transpose` → continue. If iter-034 closes nothing, iter-035 runs ONE fine-grained re-break
of the conjugate route; if iter-035 also closes nothing, **iter-036 escalates the single FBC-A crux to the
user via TO_USER** (already pre-stated in TO_USER as "then this single crux escalates to you"). 15+ iters /
>7× budget — no further silent extension.

## Rebuttals to critic must-fix items

- **strategy-critic `iter034` — "`tensorEqLocusEquiv` is a phantom; replace with `LinearMap.tensorKerEquiv`":
  REBUTTED.** `LinearMap.tensorEqLocusEquiv` EXISTS in `Mathlib.RingTheory.Flat.Equalizer` — confirmed this
  iter via `lean_loogle` (full signature: `[Module.Flat R M] : M ⊗[R] (f.eqLocus g) ≃ₗ[S] ((lTensor S M f).eqLocus (lTensor S M g))`),
  and independently by the iter-033 FBC-B prover (which gave the file path + type). The strategy-critic
  searched by name-substring and missed it; the blueprint pin `lem:flat_preserves_equalizer_mathlib` is
  correct. No change. (`LinearMap.tensorKerEquiv` is NOT the right anchor here; the equalizer form is.)
- **progress-critic `iter034` — "confirm the mate encoding avoids the diamond before the prover fires":
  SATISFIED** by the analogist + strategy-critic this iter (functor-layer coherence; see Decision above).
- **strategy-critic `iter034` — Stacks tag for D (`section_localization_descent`) "01HA" uncorroborated:
  DEFERRED, not dispatched.** QUOT-D is sequenced AFTER P1 (next iter), so no blueprint quote is consumed
  this iter. Recorded in PROGRESS Next-iter ramp: read the source (the lemma is
  `lemma-invert-f-sections` / Hartshorne II.5.3; verify the tag) before the D blueprint quote.
- **strategy-critic `iter034` — format DRIFTED:** STRATEGY scrubbed this iter (FBC-A Risks cell compressed
  to one line; iter attributions removed from Routes / Open-Q prose — "(analogist iter-030)",
  "(strategy-critic iter-031)", "Decision (iter-024)").

## Subagents this iter (5 dispatched; 2 critics + analogist consumed from the interrupted run)

- **progress-critic `iter034`** (consumed) — FBC-A STUCK; FBC-B/QUOT-P1/GR-sep UNCLEAR (positive).
- **strategy-critic `iter034`** (consumed) — SOUND; format DRIFTED; `tensorEqLocusEquiv` must-fix rebutted.
- **mathlib-analogist `fbc-mate`** (consumed) — concrete conjugate-side recipe for `_legs`;
  `analogies/fbc-mate-reencode.md`.
- **blueprint-writer `quot-cov`** — 3 gap1-C/P1 coverage blocks, wired into the P1 keystone.
- **blueprint-writer `gr-cov`** — 6 `sec:gr_separated` ring-heart coverage blocks, wired into `lem:gr_separated`.
- **blueprint-clean `iter034`** — purity over the 5 edited chapters.
- **blueprint-reviewer `iter034b`** (whole, HARD GATE) — all 4 lanes CLEAR; one cosmetic `\uses` omission
  in the P1 proof block fixed (plan agent); one deferred GF item (`gf_torsion_reindex` OreLocalization).

## Disproof / soundness checks

- FBC-A is not a false-statement risk: the target is `IsIso(pushforwardBaseChangeMap)`, whose iso-ness is
  already proven (`pullback_spec_tilde_iso`); only the coherence `_legs` is open — a true identity, not a
  satisfiability question. No counterexample search warranted.
- `tensorEqLocusEquiv` existence verified directly (above) — the disproof of the phantom claim.

## Tool substitutions

None. (No LLM API key in env, so `archon-informal-agent.py` was not used; the analogist subagent and
`lean_loogle` covered the consult + existence checks — these are first-class catalog/MCP tools, not substitutions.)

## Subagent skips

- None. The 3 highly-recommended plan subagents all ran this iter: strategy-critic `iter034` and
  progress-critic `iter034` (consumed from the interrupted run; STRATEGY + prover trajectory both changed,
  so re-running was warranted and was already done), blueprint-reviewer `iter034b` (mandatory — chapters
  were edited this iter).
