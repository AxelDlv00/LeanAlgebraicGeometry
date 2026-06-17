# Iter 038 — Plan (Quot-Foundations)

## TL;DR

iter-037 fired the FBC tripwire (assembly pass closed nothing). This iter resolved the FBC route at the
strategic level (KEEP, via a sharpened cross-domain analogist), cleared the blueprint gate for two prover
lanes, cleared the public coverage debt (4 plan-written blocks), and dispatched **2 parallel import-independent
prover lanes** — FBC gets NO prover this iter (the analogist consult was the tripwire-correct action; the
`_legs_conj` prover round is scheduled for iter-039):

1. **QUOT-semilin** [mathlib-build] — build `gammaImageRingEquiv` (σ_V) + `gammaPullbackImageIso_hom_semilinear`,
   then chain through P1's pullbacks + bridges (I)/(II) to assemble `Hfr` → close gap1.
2. **GR-E4** [mathlib-build, scaffold] — build the valuative-criterion filler `existence_lift` (frontier-ready).

## Decision made — FBC: KEEP the conjugate route; the residual is a PROOF, not a refactor

- **Option chosen:** dispatch the tripwire-mandated mathlib-analogist (cross-domain), but SHARPENED — not
  "find the reframing" (already in `analogies/fbc-mate-reencode.md`, iter-034) but "is the conjugate
  re-encoding the lowest-cost path, or does a Mathlib-precedented route bypass `gstar_transpose` entirely?"
  Then schedule a focused `_legs_conj` prover round for iter-039.
- **Why (over re-running the literal tripwire OR a blind refactor):** the analogist returned IN-ITER with two
  decisive findings: (a) **KEEP** — the mate coherence is irreducible (`pushforwardBaseChangeMap` is *defined*
  as the transpose; the geometric counit is not iso; both PIVOTs — module-level `regroupEquiv`, geometric
  base-change package — evaluated and rejected, no Lean 02KH to port); (b) **the feared refactor cascade is
  already neutralized** — the proof-free conjugate read is built (`codomain_read_legs_param` /
  `conjPullbackFactor`=`leftAdjointCompIso` / `_legs_conj` / `_conj_eq`), `codomain_read_legs` unchanged,
  `gstar_transpose` insulated. So the sole residual is the conjugate-side PROOF of `_legs_conj` (conj-2b +
  conj-2d + the single-`conjugateEquiv`-component reframing) — a prover round, exactly what the progress-critic
  named as the iter-039 must-fix.
- **LOC/risk:** iter-039 FBC round ~80–150 LOC, fine-grained; conj-2b/conj-2d are leandag frontier-ready with
  blueprint blocks; the reframing is the one genuinely-hard node. Risk: the reframing may still resist —
  but there is no cheaper route (PIVOTs rejected on first principles, not effort).
- **Cheapest reversal signal:** if the iter-039 `_legs_conj` round lands conj-2b/2d but cannot do the
  reframing, the conjugate component idiom is genuinely exhausted → escalate to a refactor that rebuilds the
  whole `_legs` comparison from `leftAdjointCompIso` primitives (the analogist's contained-cascade shape),
  not another prover round.

## Disposition of critic verdicts (no silent overrides)

- **progress-critic `iter038` — FBC STUCK (must-fix: iter-039 prover on conj-2b/2d, NOT another consult).**
  ACCEPTED. PROGRESS iter-039 ramp + task_pending schedule exactly that. The critic confirmed this iter's
  NO-PROVER+analogist was the correct response to the fired tripwire. QUOT/GR CONVERGING — proceed.
- **strategy-critic `iter038` — FBC CHALLENGE ("execute the re-cut, don't re-consult — sunk cost").**
  OVERTAKEN, not rebutted. The critic's premise was that the iter-034 re-cut sits unexecuted and the planner
  was commissioning another consult instead of acting. The in-iter analogist established that NO re-cut is
  owed (the proof-free conjugate read is ALREADY built; `codomain_read_legs` is insulated). So the critic's
  recommended action (run the re-cut as a spike) is moot; the genuine actionable residual is the `_legs_conj`
  PROOF, which is scheduled as iter-039's FBC prover round (an action, not a consult). The "module-level via
  `regroupEquiv`" alternative the critic also flagged as a non-escape is confirmed rejected by the analogist.
- **strategy-critic SNAP CHALLENGE (tensor-powers under-decomposed; Mathlib `PresheafOfModules.monoidalCategory`
  exists).** ADDRESSED by noting the Mathlib mitigant in STRATEGY `## Mathlib gaps`; SNAP stays gated on gap1 +
  Open Q1, so the concrete sub-phase decomposition is owed when SNAP opens, not this iter.
- **strategy-critic format DRIFT (must-fix).** FIXED: STRATEGY cells de-narrativised (removed `@0NN`/`iter-0NN`/
  `LIVE @` leakage; FBC-A1 Status reduced to bare `STUCK`); FBC route paragraph + Q2 rewritten to the KEEP
  state. Byte size (16.5KB) still over the ~12KB target — a focused cell-trim is owed (non-blocking, logged).
- **blueprint-reviewer `iter038` — QuotScheme CONDITIONAL HOLD.** RESOLVED same-iter: added the `% LEAN TYPE`
  pin for `j ''ᵁ V` in `def:gamma_image_ring_equiv` + a sentence naming the `map_smul` naturality API in the
  semilinearity proof. Reviewer pre-cleared dispatch contingent on the pin ⇒ QUOT lane dispatches this iter.
  GrassmannianCells CLEARS; FlatBaseChange honest (no prover).

## Blueprint work this iter (plan-authored, math-only)

- **Picard_QuotScheme.tex:** coverage blocks `lem:isLocalizedModule_ringEquiv_semilinear` (I),
  `lem:isLocalizedModule_restrictScalars_powers_algebraMap` (II); NEW prover targets
  `def:gamma_image_ring_equiv` (σ_V, with `% LEAN TYPE` pin) + `lem:gamma_pullback_image_iso_hom_semilinear`;
  wired all into `lem:section_localization_descent`'s `\uses{}`.
- **Picard_GrassmannianCells.tex:** coverage block `lem:gr_free_entry_eq_signed_minor` (pins
  `exists_minorDet_eq_free_entry`); wired into `lem:gr_existence_factor_through_valuation_ring`'s `\uses{}`.
- **Cohomology_FlatBaseChange.tex:** coverage block `lem:base_change_mate_extendScalars_inner_value_counit`
  (redundant variant of `gstar_generator_close`).

## Subagent skips

- **blueprint-clean:** skipped — this iter's blueprint edits are plan-authored coverage blocks + two
  prover-target blocks following the chapter's existing `\mathrm{}`/`% LEAN TYPE` conventions; the
  blueprint-reviewer (dispatched, whole-blueprint) carried the purity check and flagged only minor `%`-comment
  verbosity (non-blocking) — no separate purity pass warranted.

## Soundness check (cheap disprove pass)

- **QUOT semilinearity** — not a false-statement risk: for an open immersion `j`, `j ''ᵁ V` and `V` have
  canonically isomorphic structure sheaves (`IsOpenImmersion` ⟹ iso onto image), and the pullback module's
  sections transform semilinearly over that ring iso; standard, true. Variance confirmed sensible by the
  blueprint-reviewer (covariant on module sections, contragredient on the ring action).
- **GR E4** — `existence_lift` has a full top/bottom-triangle proof sketch + concrete LEAN SIGNATURE; all 5
  deps `\leanok`; frontier-ready. No disprove concern.
