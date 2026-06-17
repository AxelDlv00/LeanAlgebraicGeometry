# Recommendations for the next plan iteration (after iter-005)

## TOP PRIORITY — scaffold the one leaf that gates the entire P4 tail

**Build `quasiIso_τ₂` / `isIso_homologyMap_τ₂` as a NEW provable declaration FIRST.** This is the
sole blocker for `ofShortExact_resolvesMiddle` → `ofShortExact` → `rightDerivedShiftIsoOfAcyclic`
→ `rightDerivedIsoOfAcyclicResolution` (the whole remaining P4 chain). It does NOT exist in
Mathlib (only the last-term `quasiIso_τ₃`, `HomologySequenceLemmas.lean:168`, is provided).

- **Statement**: for a short exact sequence of (co)chain complexes `0 → X₁ → X₂ → X₃ → 0` with the
  two outer verticals quasi-isos, the middle vertical is a quasi-iso; equivalently the homology-map
  form `isIso_homologyMap_τ₂`.
- **Proof recipe (from the prover's task result + the checker)**: homology five-lemma on the
  7-term LES window `H^{i'}(X₃) → H^i(X₁) → H^i(X₂) → H^i(X₃) → H^{i+1}(X₁)` centred at `H^i(X₂)`.
  This spans **two** `composableArrows₅` windows `(i', i)` and `(i, i+1)`; assemble a 7-term exact
  `ComposableArrows` or apply the four-lemmas `mono_of_epi_of_mono_of_mono` /
  `epi_of_epi_of_epi_of_mono` to extracted sub-windows. Handle the ℕ-boundary at `i = 0` (no
  predecessor) exactly as the `τ₃` proof handles its boundary: `by_cases hi : ∃ j, c.Rel i j`.
  Model directly on `mono_homologyMap_τ₃` / `epi_homologyMap_τ₃` / `isIso_homologyMap_τ₃`
  (`Mathlib/Algebra/Homology/HomologySequenceLemmas.lean:113–166`).
- **Then** (straight-line, all inputs already proven this iter): package `horseshoeMid` + `β` as
  `InjectiveResolution ses.X₂` (`quasiIso` field = the new result; `injective` field from
  `Injective.instBiprod`; `ι` from `β` via `CochainComplex.fromSingle₀Equiv` + `horseshoeβ_comp_d`)
  → `ofShortExact` (exposes `horseshoeSES` + `horseshoeSES_shortExact`) → feed
  `rightDerivedShiftIsoOfSplitResolutionSES` → `rightDerivedShiftIsoOfAcyclic` → staircase
  induction → `rightDerivedIsoOfAcyclicResolution`.
- **Blueprint action**: this leaf needs its own block. Add a `\mathlibok`-adjacent NEW lemma
  (project-proved, not Mathlib) under `lem:horseshoe_resolvesMiddle`'s `\uses`, e.g.
  `lem:quasiIso_middle_of_ses`, with the five-lemma proof sketch above. Consider an
  effort-breaker only if the five-lemma assembly stalls — it is a single self-contained lemma, so
  a first `mathlib-build` attempt is warranted.

## Blueprint hygiene the planner should land (from lean-vs-blueprint-checker, major/minor)

The review agent already corrected the three stale `\lean{...}` names + added the `resolvesMiddle`
`% NOTE:` (these were in-domain). The following remain for the **planner** (informal prose / block
structure — review agent does not author prose):

1. **[major, content-side]** Consider **splitting `lem:horseshoe_twist`** into per-declaration
   sub-blocks matching the realized cluster (`horseshoeτ`, `horseshoeτ_cocycle`, `twistPair`,
   `horseshoeβ`) for clean 1-to-1 coverage. The multi-target `\lean{}` I applied works for
   `sync_leanok`, but one block → 15+ decls is coarse.
2. **[minor]** Add a **`TwistedBiprod` blueprint block/subsection** describing the injective-free
   abstraction (cochain complexes `K,L` + cocycle family `τ` ⇒ biproduct complex with matrix
   differential `[[d_K,τ],[0,d_L]]`), referencing `\lean{CategoryTheory.twistedBiprod}`,
   `twistedBiprodInl`, `twistedBiprodSnd`, `twistedBiprodSplitting`. The Lean is *more general*
   than the current blueprint (which describes it only in the injective-resolution context).
3. **[minor]** Add a block for `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (the fully-
   formalized "inner engine" of the dimension shift) with `\lean{...rightDerivedShiftIsoOfSplitResolutionSES}`.

## 1-to-1 coverage debt (`archon dag-query unmatched` = 50 lean_aux nodes)

Many are old (CechHigherDirectImage helpers: `coverCechNerveOver(Aug)`, `pushPullMap_eq_raw`,
`rawPushPullMap(_comp/_self)`, `pushPull_pentagon`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`).
**New this iter** (AcyclicResolution), all to be wired into the blueprint once the block-split
above is done — they fold under `lem:horseshoe_twist`/`_dComp`/`_chainMap` (now correctly named):
`twistedBiprodD(_fst/_snd/_comp)`, `twistedBiprod(_X/_d)`, `twistedBiprodInl(_f)`,
`twistedBiprodSnd(_f)`, `twistedBiprodInl_comp_Snd`, `twistedBiprodSplitting`; `horseshoeβ₁`,
`horseshoeH(_comp_d)`, `f_comp_horseshoeβ₁`, `g_comp_horseshoeH`, `horseshoeτZero(_hf)`,
`ιC_comp_horseshoeτZero`, `twistPair`, `horseshoeτ(_cocycle/_zero)`, `horseshoeMid`,
`horseshoeSES(_splitting/_shortExact)`, `horseshoeβ(_fst/_snd/_comp_d)`, `ιC0(_comp_d/_comp_τZero)`.
Carried over still-unblueprinted from iter-004: `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`,
`shortExact_of_degreewise_splitting`, `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
`rightDerivedShiftIsoOfSplitResolutionSES`.

## Lean-source cleanup (lean-auditor, 1 major / 6 minor — for a refactor or the next prover touch)

- **[major]** Trim the 177-line `/-! ### Status (iter-005) … -/` block (L457–633) — strategy/planner
  content embedded in the `.lean` source, and the source of all long-line warnings. Move to
  `.archon/` state. (Not review-agent domain; flag for the planner to schedule a refactor or fold
  into the next prover dispatch's housekeeping.)
- **[minor]** 4 unused-section-variable warnings: `omit [HasInjectiveResolutions 𝒜] in` on the
  affected decls. Module docstring lists undeclared future targets; status block label will go stale.

## Reusable proof patterns discovered this iter (also in Knowledge Base)
- **Namespace-shadowed instance synthesis**: inside `namespace InjectiveResolution`, `Mono` of a
  hypothesis or of `I.ι.f n` won't synthesize; pass `@Injective.factorThru _ … hMono` positionally
  and `mono_of_isLimit_fork I.isLimitKernelFork` for the resolution mono.
- **`rw`-poisoned `neg_comp`**: prove the equality on a fresh `have e : … := by …` goal, then
  `exact e` (defeq-tolerant); extract as a standalone lemma to dodge universe-metavar flakiness.
- **Single-complex domain mismatch**: wrap `I.ι.f 0` in a clean-domain `def` (`ιC0 := I.ι.f 0`)
  when composing under another map, so `rw`/`simp` subterm matching survives.

## Do NOT re-assign
- The horseshoe **monolith** `ofShortExact` as a single `mathlib-build` dispatch — it is now
  decomposed; build `quasiIso_τ₂` then assemble. Do not re-dispatch `resolvesMiddle` before
  `quasiIso_τ₂` exists (it will just re-hit the same Mathlib gap).
- P3 (`CechAcyclic.affine`) and P5 (`cech_computes_higherDirectImage`) remain genuinely blocked
  (P3 statement gap; P5 needs P3+P4) — unchanged from prior iters.
