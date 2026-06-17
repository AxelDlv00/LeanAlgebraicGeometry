# Strategy Critic Report

## Slug
iter036

## Iteration
036

## Routes audited

### Route: FBC (affine + flat base change of H⁰)

- **Goal-alignment**: PASS — the route targets exactly `lem:affine_base_change_pushforward` /
  `thm:flat_base_change_pushforward` over the parent-frozen `pushforwardBaseChangeMap`.
- **Mathematical soundness**: PASS — the math (regroup iso = `cancelBaseChange`, no flatness for the
  affine case) is correct. The *proof-engineering route choice this iter* is what fails.
- **Sunk-cost reasoning detected**: yes (inverted) — see Sunk-cost flags. The strategy ABANDONS the route
  the source code itself labels "the only tractable route" and PIVOTS to the route the same code labels
  "a dead end."
- **Infrastructure-deferral detected**: yes — the pivot is rotation churn. The hardest prerequisite is
  identical before and after: `base_change_mate_gstar_transpose` (FlatBaseChange.lean:1999, residual
  `sorry`@2122) resting on `base_change_mate_fstar_reindex_legs` (:1713, residual `sorry`@1700). Neither
  the conjugate route nor the element-`ext` route removes this lemma; both must discharge it.
- **Phantom prerequisites**: none in the strategy; `conjugateEquiv_counit_symm` is real (used in compiling
  code @2079).
- **Effort honesty**: under-counted — FBC-A is listed `2–4 iters / ~150–320 LOC` but it carries FOUR open
  `sorry`s (1700, 2122, 2303, 2325): the `_legs` coherence, the `gstar_transpose` coherence, obligation-1
  affine reduction (the code itself calls this "the remaining multi-hundred-LOC build", @2301), and the
  flat-case wrapper. 2–4 iters for all four is optimistic given obligation 2 already stalled 5 iters.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

#### Why the pivot is rotation churn (the core finding)

`pushforwardBaseChangeMap` is DEFINED (FlatBaseChange.lean:79-86) as an adjunction transpose:
`((pullbackPushforwardAdjunction g).homEquiv _ _).symm (inner)`. There is no element-level handle on this
map except by unfolding the transpose, which by `Adjunction.homEquiv_counit` produces the `(g^*⊣g_*)`-counit
composite — i.e. *the mate form*. The existing proof of `base_change_mate_section_identity` (:2151) does
exactly this and bottoms out at `base_change_mate_gstar_transpose`:

```
unfold pushforwardBaseChangeMap
rw [Adjunction.homEquiv_counit]
exact base_change_mate_gstar_transpose ψ φ M
```

So the STRATEGY claim that the element-`ext` route "never normaliz[es] the map to its mate form … the
`X.Modules` diamond is never hit and the `_legs`/`gstar_transpose` coherence is bypassed entirely"
(STRATEGY.md:60, :64-66 region; Routes "ACTIVE iter-036" bullet) is **contradicted by the map's own
definition**: to evaluate `pushforwardBaseChangeMap.app U` on any element you must unfold the transpose,
which IS the mate form, which lands on `base_change_mate_gstar_transpose`. The element chase does not bypass
the gap — it is a *different tactic for the same residual lemma*.

Worse, the residual lemma's own in-code note (FlatBaseChange.lean:2054-2057) has already evaluated the
element-`ext` route and rejected it:

> "The per-generator route is a dead end: `ext x` reduces the goal to the full opaque geometric composite
> applied to `1 ⊗ₜ x`, which neither `rfl` nor `simp` can evaluate (the geometric counit/pullback/Γ have
> no element-level normal form) — the abstract conjugate calculus above is the only tractable route."

The STRATEGY's Q2 open sub-question ("the explicit-`ext` chase must unfold `pushforwardBaseChangeMap.app U`
to a concrete `ModuleCat` map without re-crossing the diamond — if it does not, reconsider") is therefore
**already answered NO by the source before the iter begins**. The trip-wire condition is met at iter start,
not at iter end.

#### What the strategy got backwards

The code shows the conjugate-counit route is NOT a barren dead end: it has a LANDED, compiling master
identity `huce` (the counit-transport identity, FlatBaseChange.lean:2099-2107) and a precisely-scoped
remainder (steps 2–3, ~150 LOC, enumerated @2109-2121: inner reindex via the *proved standalone*
`base_change_mate_fstar_reindex_legs_unitExpand`/`…_gammaDistribute` + Seam-1 `base_change_mate_unit_value`,
a one-generator close, and dictionary cancellation). The strategy abandons this — the route the code calls
"the only tractable route" — to chase the route the code calls "a dead end." That is the inversion the
planner must resolve before spending prover budget.

### Route: GF (generic flatness, geometric wrapper)

- **Verdict**: SOUND — algebraic core done; the geometric wrapper bottoms at gap1 (G1), which IS being
  built QUOT-side with a concrete decomposition, so this is a genuine dependency, not a deferral. Note for
  honesty: "GF-geo 2–4 iters left" is really "2–4 iters AFTER gap1 lands"; the row's `Iters left` should
  read as gated, which the Risks cell does say ("dispatch deferred until gap1 lands").

### Route: QUOT gap1 (QCoh≃Mod affine descent: C→P1→D→assembly)

- **Verdict**: SOUND — the descent is the standard Hartshorne II.5.3 / Stacks `lemma-invert-f-sections`
  argument; C and P1 are done, D (keystone) is correctly identified and referenced. No phantom infra
  (`Scheme.Modules.restrictFunctor`/`pullback` confirmed to exist per the strategy's own correction).

### Route: GR-proper (valuative criterion, E1–E4)

- **Phantom prerequisites**: `UniversallyClosed.of_valuativeCriterion` — could not verify this iter (loogle
  timed out, local search needs an open file). It is a plausible Mathlib name but the planner should
  confirm the exact spelling before dispatch; Mathlib's valuative-criterion API has churned.
- **Verdict**: SOUND (mathematically — Nitsure §1 DVR-filler is the right argument; separatedness done),
  pending the one prerequisite spot-check above.

### Route: QUOT-repr (`thm:grassmannian_representable`)

- **Effort honesty**: the `~400–1000+ LOC / 6–12 iters` row is honest about being the deepest target;
  no objection. Properly BLOCKED behind QUOT-defs/SNAP/RelativeSpec.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 149 lines / ~13 KB — lines within budget; bytes at/near the ~12 KB ceiling, watch growth.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open
  strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — prose (not the `## Completed` `Iters` ledger cell) references
  specific iters: "Conjugate route EXHAUSTED iter-035 (trip-wire FIRED)" (Phases Risks cell),
  "*(ABANDONED iter-035)* … EXHAUSTED at the section-composite→`conjugateEquiv`-component reframing (5-iter
  stall …)" (Routes), "Q2 — FBC encoding — RESOLVED, trip-wire FIRED iter-035", "P1 … DONE iter-034".
  Move iter-stamped narrative to the iter-036 sidecar; keep STRATEGY iter-agnostic.
- **Accumulation detected**: no — completed phases are in `## Completed` (7 rows, within bound); no excised
  route lingers in `## Routes`.
- **Table discipline**: FAIL (minor) — several `## Phases & estimations` Risks cells are multi-sentence
  paragraphs (FBC-A and GR-proper rows especially), not "one short line per cell."
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: `base_change_mate_gstar_transpose` / `base_change_mate_fstar_reindex_legs` (the `_legs`/mate coherence)

- **Required by goal**: yes — it is the residual `sorry` under every section-level FBC lemma; the affine
  base-change theorem is transitively `sorry`-backed through it.
- **Current plan for building it**: STRATEGY proposes the element-`ext` route, which the source code
  (FlatBaseChange.lean:2054-2057) documents as "a dead end" and which does not remove this lemma in any
  case. The route that the code documents as tractable (conjugate-counit calculus, landed `huce` master
  identity @2099, ~150-LOC enumerated remainder) is marked ABANDONED.
- **Timeline**: present (2–4 iters) but pointed at the dead-end route, so effectively absent for a route
  that can close.
- **Verdict**: CHALLENGE — the pivot renames the gap without solving it (hardest prerequisite identical
  before/after); the planner must either justify why element-`ext` is now tractable against the in-code
  "no element-level normal form" finding, or revert to the conjugate-counit route and finish its
  enumerated ~150-LOC remainder.

## Alternative routes (suggested)

### Alternative: Resume the conjugate-counit calculus from the landed `huce` (RECOMMENDED)

- **What it looks like**: This is not a new route — it is the route the strategy abandoned. The master
  counit-transport identity `huce` is already proved and compiling (FlatBaseChange.lean:2099). The
  remaining work is the three enumerated pieces at :2109-2121: (a) inner reindex `Γ_R(θ_in) = ρ` reproven
  inline from the PROVED standalone `base_change_mate_fstar_reindex_legs_unitExpand` (:1317) +
  `…_gammaDistribute` (:1348) + Seam-1 `base_change_mate_unit_value`; (b) the one-generator close
  `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv` on `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`; (c) dictionary
  cancellation against `Θ_src`/`Θ_tgt`.
- **Why it might be cheaper or sounder**: the code says it is "the only tractable route," the hard counit
  coherence is already landed, and the remainder is a bounded ~150 LOC with named inputs — far more
  concrete than restarting from scratch on a documented dead end.
- **What the current strategy may have rejected**: the strategy frames it as "EXHAUSTED (5-iter stall)."
  But a route with a landed master identity and an enumerated 150-LOC remainder is *in progress*, not
  exhausted; the "exhausted" label looks like inverted sunk-cost (abandoning the sunk work precisely where
  it was about to pay off).
- **Severity of the omission**: critical.

### Alternative: Affine tilde-equivalence transport

- **What it looks like**: on `Spec R` the qcoh↔`ModuleCat` tilde functor is an equivalence compatible with
  the pullback/pushforward adjunctions (`gammaPushforwardNatIso` already encodes one leg). Transport
  `pushforwardBaseChangeMap` over the affine square to the algebraic `cancelBaseChange` as the
  equivalence-image, so iso-ness is a pure `LinearEquiv` fact across an equivalence.
- **Why it might be cheaper or sounder**: equivalences send isos to isos by general nonsense, sidestepping
  any element chase.
- **What the current strategy may have rejected**: proving "the equivalence sends `pushforwardBaseChangeMap`
  to `cancelBaseChange`" is itself close to the same coherence, so this may not be genuinely independent —
  offered only as a fallback if Alternative 1 stalls again.
- **Severity of the omission**: minor.

## Sunk-cost flags

- `*(ABANDONED iter-035)* the conjugate-side … route: EXHAUSTED at the section-composite→conjugateEquiv-component reframing (5-iter stall, trip-wire fired)` — Why this is (inverted) sunk-cost: the route is
  abandoned at the moment its hard counit coherence (`huce`) is landed and only a bounded, enumerated
  ~150-LOC remainder is left; the in-code note calls it "the only tractable route." Recommendation: judge
  the conjugate route on its remaining cost (≈150 LOC with named inputs) versus the element route's
  documented-impossible cost, not on the count of prior iters spent.

## Prerequisite verification

- `conjugateEquiv_counit_symm`: VERIFIED (used in compiling code, FlatBaseChange.lean:2079).
- `Adjunction.homEquiv_counit`: VERIFIED (used @2167).
- `UniversallyClosed.of_valuativeCriterion`: UNVERIFIED this iter (loogle timeout) — planner must confirm
  before GR-proper dispatch.

## Must-fix-this-iter

- Route FBC: CHALLENGE — the iter-036 pivot to "affine-local explicit-inverse + element-`ext`" is rotation
  churn: the hardest prerequisite (`base_change_mate_gstar_transpose`/`_legs`) is unchanged, and the route
  it pivots TO is explicitly documented as "a dead end" in FlatBaseChange.lean:2054-2057, while the route
  it ABANDONS is documented as "the only tractable route" with a landed master identity and a bounded
  ~150-LOC remainder. The planner must either (a) revert FBC-A to the conjugate-counit calculus and finish
  the enumerated steps 2–3, or (b) record an explicit rebuttal in plan.md naming why element-`ext` is now
  tractable despite the in-code "the geometric counit/pullback/Γ have no element-level normal form" finding.
  Do NOT spend prover budget on the element-`ext` round until this is resolved.
- Route FBC: infrastructure-deferral CHALLENGE — `base_change_mate_gstar_transpose` required by goal; the
  current plan points at a route that does not build it. Build it via the conjugate route this iter or
  produce a concrete plan with an iter estimate that survives the in-code dead-end note.
- Alternative "resume conjugate calculus": critical omission — the strategy treats a 150-LOC-from-done
  route as exhausted.
- Format: DRIFTED — move iter-stamped narrative ("EXHAUSTED iter-035", "ABANDONED iter-035", "DONE
  iter-034", "trip-wire FIRED iter-035") to the iter-036 sidecar and shorten the multi-sentence Risks
  cells to one line each.

## Overall verdict

The non-FBC routes (GF, QUOT gap1, GR-proper, QUOT-repr) are SOUND, correctly sequenced, and honestly
scoped; the only open prerequisite to confirm is `UniversallyClosed.of_valuativeCriterion` for GR-proper.
The FBC route, however, fails this audit: the strategy defers `base_change_mate_gstar_transpose`/`_legs`,
which is required for the stated goal, by pivoting to an element-`ext` route that (1) cannot bypass that
lemma — `pushforwardBaseChangeMap` is *defined* as the adjunction transpose, so any element-level evaluation
unfolds to the mate form and lands back on `base_change_mate_gstar_transpose` — and (2) is explicitly
recorded as "a dead end" in the source at FlatBaseChange.lean:2054-2057, while the route the source calls
"the only tractable route" (conjugate-counit calculus, with a landed master identity `huce` and a bounded
~150-LOC remainder) is marked ABANDONED. This is a pivot that moves the same hard problem one layer deeper
in the wrong direction; it must be reverted or rebutted in plan.md before any prover budget is spent on FBC
this iter. Format is DRIFTED on per-iter narrative and overlong table cells — fix in place.
