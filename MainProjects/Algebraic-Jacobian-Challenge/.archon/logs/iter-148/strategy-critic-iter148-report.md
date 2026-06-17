# Strategy Critic Report

## Slug
iter148

## Iteration
148

## Routes audited

### Route: Route C (M2 critical path) — chart-algebra envelope

- **Goal-alignment**: PASS — the chart-algebra envelope closes the genus-0
  rigidity-to-group-scheme argument over the project's chosen `k`, exactly
  the M2.a obligation under the protected signature (no `C(k) ≠ ∅` hypothesis,
  vacuity branch handled).
- **Mathematical soundness**: PASS — chart-Kähler kernel + 2-chart Čech MV
  on `Ω^{⊕n}` + char-p Frobenius patch is a coherent decomposition; the
  iter-147 absorption now correctly flags the MV-on-`Ω^{⊕n}` step as
  **genuinely new instantiation** of the abstract MV theorem (not a
  mechanical reuse of the `O_C` application), so the framing is honest.
- **Sunk-cost reasoning detected**: no — the merit argument now stands on
  its own (three named layers with their respective Mathlib hooks);
  iter-147 critique's "framed as new instantiation" requirement was
  absorbed.
- **Phantom prerequisites**: none. Verified via loogle:
  `Algebra.IsStandardSmooth.free_kaehlerDifferential` (RingTheory.Smooth.StandardSmoothCotangent),
  `RingHom.iterateFrobenius_comm` (Algebra.CharP.Frobenius),
  `Subsingleton (Algebra.H1Cotangent _ _)` (RingTheory.Smooth.Basic).
- **Effort honesty**: under-counted (internally inconsistent).
  Iter-145→iter-147 trajectory: 89 → 342 LOC (~127 LOC/iter average,
  2 sub-pieces closed in 2 iters of prover work). Remaining 2 sub-pieces
  budgeted at **400–800 LOC** in `## Phases & estimations` ⇒ total
  upper trajectory **742–1142 LOC**. The carry-over alternative's rolling
  trigger (a) reads "exceeds the upper LOC budget (~1050 LOC)". **The
  upper trajectory CROSSES this trigger** (1142 > 1050). Either the table
  upper bound should be tightened to ~700 LOC remaining, or the trigger
  threshold should be raised to ~1200 LOC, but the strategy cannot
  internally claim *both* numbers as written.
- **Verdict**: **CHALLENGE** — reconcile the table upper bound vs the
  rolling-trigger threshold so they agree on the same upper-LOC bound.

### Route: Route A (M3 off-critical-path) — Picard via FGA

- **Goal-alignment**: PASS — Picard scheme + identity-component subgroup
  + smoothness/properness/dimension gives the Albanese object the
  protected signature demands.
- **Mathematical soundness**: PASS — standard FGA-style construction;
  Hilbert/Quot representability + flattening stratification + identity
  component is the canonical route over a field.
- **Sunk-cost reasoning detected**: **mild** — the merit-vs-Route-B
  paragraph closes with "the iter-123 audit weighted this heavily",
  which appeals to a prior audit decision rather than re-arguing the
  merit each iter. The substantive merit argument that *precedes* this
  phrase is good (Route B needs `S_n`-quotient infrastructure that is
  "no closer to existence" + still needs identity-component
  construction), so the citation is not load-bearing — but the phrasing
  is sunk-cost-adjacent. **Recommendation**: drop the "iter-123 audit
  weighted this heavily" clause; let the preceding merit argument stand
  on its own.
- **Phantom prerequisites**: none assumed-already-present; the strategy
  correctly identifies Hilbert/Quot representability, identity-component
  subgroup scheme, fppf/étale sheafification, Grothendieck flattening,
  and coherent-of-finite-type as in-tree material to build.
- **Effort honesty**: reasonable. ~6070 LOC midpoint over 50–80 iters
  ≈ ~75–120 LOC/iter, comparable to the chart-algebra pace.
- **Verdict**: **SOUND** with the small "iter-123 audit" sunk-cost-
  adjacent phrasing flagged separately under "Sunk-cost flags".

### Route: Alternative (still on the table) — over-`k̄` + Galois descent for M2.a

- **Goal-alignment**: PASS — base-change to `k̄` for genus-0 → `ℙ¹_{k̄}`,
  apply small `ℙ¹` rigidity, descend via fpqc descent, recovers the
  M2.a obligation.
- **Mathematical soundness**: PASS — standard descent strategy.
- **Sunk-cost reasoning detected**: no — the alternative is presented
  as currently-not-chosen with explicit rolling-trigger re-evaluation
  criteria, not as "we already invested elsewhere so we keep going".
- **Phantom prerequisites**: the strategy correctly identifies fpqc
  descent of morphisms / sheaf-of-morphisms infrastructure as the
  blocker that motivated the iter-127 commitment to over-`k`.
- **Effort honesty**: not LOC-budgeted; this is appropriate for a
  carry-over alternative pending trigger conditions.
- **Verdict**: **SOUND** — but the trigger condition (a) inherits the
  Route-C upper-LOC inconsistency above (see CHALLENGE on Route C).
  Once Route C's upper bound is reconciled, this alternative's trigger
  is automatically well-defined.

## Format compliance

- **Size**: 178 lines / 10089 bytes — within budget (250 lines / 12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in
  the canonical order. Iter-147's restructure stuck.
- **Per-iter narrative detected**: **yes**. Representative quotes from
  the current STRATEGY.md prose (not from headings or filenames):
  - "the iter-123 audit weighted this heavily" (Route A merit paragraph)
  - "This was the project's pre-iter-127 path; iter-127 committed to
    over-`k` via the chart-algebra envelope" (over-`k̄` alternative
    paragraph)
  - "Iter-150 carries a scheduled symmetric audit" (over-`k̄`
    alternative paragraph)
  - "closed sub-pieces omitted; see iter-147 sidecar" (Route C
    intro)

  Stable filename references such as `analogies/m3-route-a-refresh-iter145.md`
  are NOT counted — they are immutable artifact paths, not per-iter
  prose. The four quoted phrases above are exactly the kind of
  iter-by-iter prose that belongs in `iter/iter-NNN/plan.md`, not in
  STRATEGY.md.
- **Accumulation detected**: minor. The Route B paragraph occupies ~10
  lines documenting a rejected alternative inline; this is defensible
  as live decision context (Route A is justified by comparison to B),
  but could be tightened. The "Soundness rules" content survives as a
  bold subsection inside `## Mathlib gaps & new material` (iter-147
  dissolved the prior top-level `## Soundness rules` heading). The
  soundness-rules content is operational discipline, not a Mathlib gap,
  so its placement is slightly off-genre — but it is no longer a
  separate top-level section, so the structural complaint from iter-147
  is resolved.
- **Table discipline**: PASS — `## Phases & estimations` is a Markdown
  table with the named columns; one short line per cell.
- **Appendix sections**: none detected.
- **Format verdict**: **DRIFTED** — skeleton intact, table compliant,
  size within budget, no appendix sections, but four per-iter-narrative
  phrases bleed prior planner state into STRATEGY.md prose. Planner
  should excise these phrases this iter without a full restructure.

## Alternative routes (suggested)

No fresh alternative this iter — the strategy already enumerates the
three coherent routes (Route C / Route A / over-`k̄` alternative), and
the iter-147 critique's alternatives were absorbed. A fresh-context
mathematician scanning the routes does not see a missing fourth path
(e.g., a Hodge-theoretic or analytic construction) that would apply
over a general field `k` of arbitrary characteristic — those routes
are intrinsically `ℂ`-specific or require infrastructure even further
from Mathlib.

## Sunk-cost flags

- `"the iter-123 audit weighted this heavily"` (Route A merit
  paragraph) — Why this is sunk-cost: appeals to a prior audit decision
  rather than re-arguing on merits. The preceding merit argument
  (Route B needs `S_n`-quotient infrastructure + still needs identity-
  component) is sound and self-supporting. **Recommendation**: drop the
  citation; the substantive merit argument stands without it.
- `"This was the project's pre-iter-127 path; iter-127 committed to
  over-`k` via the chart-algebra envelope on grounds that the descent
  step needs its own sheaf-of-morphisms / fpqc-descent infrastructure
  that Mathlib lacks"` (over-`k̄` alternative paragraph) — Why this is
  sunk-cost-adjacent: the *reason* (descent infrastructure missing) is
  load-bearing and merit-based, but the iter-numbered framing
  ("pre-iter-127", "iter-127 committed") encodes commitment history
  rather than the live trade-off. **Recommendation**: replace with
  "Mathlib currently lacks fpqc-descent-of-morphisms infrastructure,
  which would have to be built up alongside this route; the chart-
  algebra envelope's β-core MV is structurally a one-time investment
  that pays for itself across M2.a + M2.b." Same content, no iter
  numbers.

## Prerequisite verification

- `KaehlerDifferential.D`: VERIFIED (Mathlib has the `D` derivation on
  `Ω[S⁄R]` — standard).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED
  (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent` — exact type
  `Module.Free S Ω[S⁄R]` given `IsStandardSmooth R S`).
- `RingHom.iterateFrobenius_comm`: VERIFIED
  (`Mathlib.Algebra.CharP.Frobenius`).
- `Subsingleton (Algebra.H1Cotangent A B)`: VERIFIED
  (`Mathlib.RingTheory.Smooth.Basic` —
  `Algebra.FormallySmooth.subsingleton_h1Cotangent`).
- `Scheme.Over.ext_of_eqOnOpen`: project-internal (not a Mathlib
  prerequisite); ack.

## Iter-148-specific finding: proper-flat-base-change-of-Γ gap depth

The directive asks whether the iter-148 prover lane's "~50–150 LOC thin
wrapper" estimate for the substep-3 gap is realistic, or whether the
gap conceals a longer chain (proper-flat base change of `H^i` for all
`i`, requiring coherent-of-finite-type infrastructure).

**Finding.** The depth of the gap depends on the *exact* statement of
`constants_integral_over_base_field` substep 3:

- **If the substep needs "`Γ(C, O_C)` is integral over `k`"**
  (matching the lemma's name): the gap is genuinely thin. Mathlib
  already has `AlgebraicGeometry.finite_appTop_of_universallyClosed`
  (`Mathlib.AlgebraicGeometry.Morphisms.Proper`), which states: for
  `X` integral, `f : X ⟶ Spec K` universally closed and locally of
  finite type, the appTop ring map `K → Γ(X, O_X)` is **finite**.
  Finite ⇒ integral via standard `Module.Finite`-to-`IsIntegral`
  bridging. The thin wrapper is then ~50–150 LOC of plumbing:
  derive `IsIntegral C` from `GeometricallyIrreducible + Smooth`
  (likely already available), apply
  `finite_appTop_of_universallyClosed`, conclude integrality. **No
  proper-flat-base-change machinery needed.**

- **If the substep needs "`Γ(C, O_C) = k`"** (the stronger statement
  that justifies invoking geometric irreducibility specifically): the
  gap conceals proper-flat base change of `Γ` along `k → k̄`, which in
  full generality is part of cohomology-and-base-change. For `Γ = H^0`
  specifically with `X/k` proper, this is provable directly without
  invoking the full `H^i` machinery, but it still needs a non-trivial
  bridge (Γ-of-base-change ≅ base-change-of-Γ for proper schemes,
  using qcqs + flatness). I would budget this at ~250–500 LOC, not
  ~50–150.

  The strategy's framing — "geom-irr base-change chain for `Γ` of
  proper schemes" (Mathlib gaps line 132) and the directive's
  Stacks-02KH/0BUG citation — points to the equality version.

**Verdict.** The current strategy is **ambiguous** between the two
interpretations: the lemma's *name* (`constants_integral`) points at
integrality, but the *gap prose* ("geom-irr base-change chain", Stacks
02KH/0BUG) points at equality. The iter-148 prover lane could:
- close in 50–150 LOC if integrality is enough downstream, OR
- over-run badly (and still leave a phantom dependency) if equality
  is needed and the wrapper is built on top of nonexistent flat-base-
  change-of-Γ infrastructure.

**Recommendation (CHALLENGE).** Before the iter-148 prover lane lands,
the strategy must clarify *which* statement is actually needed
downstream (in `rigidity_over_kbar` and consumers). If integrality:
amend the gap entry in `## Mathlib gaps & new material` to drop the
Stacks-02KH/0BUG citation (it overstates the depth and misleads future
provers); reference `finite_appTop_of_universallyClosed` instead. If
equality: keep the citation but raise the LOC budget on substep 3 (to
~250–500 remaining LOC) and add an explicit fallback decision: **build
the flat-base-change machinery**, or **route around it via the over-`k̄`
alternative for M2.a** (deferring substep 3 indefinitely). This is
exactly the kind of fork the rolling trigger structure (b) — "fresh
prover lane returns INCOMPLETE on a base-dependent sub-goal" — was
designed to handle.

## Must-fix-this-iter

- **Route C: CHALLENGE** — reconcile the table's `400–800 LOC remaining`
  budget against the rolling-trigger threshold `~1050 LOC cumulative`.
  Current trajectory 342 + 800 = 1142 crosses the trigger; the two
  numbers must agree on the same upper bound.
- **Substep 3 statement: CHALLENGE** — disambiguate between
  "`Γ` integral over `k`" (thin, ~50–150 LOC via
  `finite_appTop_of_universallyClosed`) and "`Γ = k`" (needs proper-
  flat-base-change-of-`Γ`, ~250–500 LOC). The current Mathlib-gaps
  entry's prose and Stacks citation point at the deeper version while
  the lemma name and 50–100-LOC budget point at the shallow version.
  Pick one and align both the lemma name and the LOC budget. If the
  deeper version is needed, name explicitly whether the strategy
  commits to building the flat-base-change machinery in-tree or
  defers M2.a substep 3 to the over-`k̄` alternative.
- **Format: DRIFTED** — STRATEGY.md should excise four per-iter-narrative
  phrases this iter (no full restructure needed):
  - "the iter-123 audit weighted this heavily" → drop
  - "This was the project's pre-iter-127 path; iter-127 committed to
    over-`k` via the chart-algebra envelope" → rewrite without iter
    numbers (substantive reason can stay)
  - "Iter-150 carries a scheduled symmetric audit" → reword as
    "A symmetric audit of the alternatives is scheduled at the next
    strategic checkpoint" or move the iter-150 commitment to the
    relevant iter sidecar
  - "closed sub-pieces omitted; see iter-147 sidecar" → replace with
    "closed sub-pieces summarised in the iter sidecar where each
    closed; current STRATEGY.md tracks only remaining work"
- **Route A sunk-cost-adjacent phrasing**: drop the "iter-123 audit
  weighted this heavily" citation (subsumed by the format must-fix
  above; the preceding merit argument is sufficient on its own).

## Overall verdict

The iter-147 restructure largely stuck: canonical skeleton intact,
table compliant, size and appendix discipline good, prior critiques on
MV-as-genuinely-new-instantiation and merit-vs-sunk-cost framing
absorbed. The strategy is fundamentally sound and a fresh mathematician
would approve the high-level architecture (Route C for M2 critical
path, Route A for M3 off-critical-path, over-`k̄` carry-over with
rolling trigger). But three concrete issues need addressing this iter
before the iter-148 prover dispatch:

1. **The Route-C LOC budget and rolling-trigger threshold are
   internally inconsistent** — table says 400–800 remaining, trigger
   says 1050 cumulative; current trajectory 342 + 800 = 1142 crosses
   the trigger. Pick one bound.
2. **The substep-3 gap is ambiguous in depth** — the lemma name says
   "integral", the prose and citation point at "equal to `k`" via
   flat base change. If the latter is needed, the 50–150-LOC wrapper
   estimate is wrong and the strategy should commit to either building
   the flat-base-change machinery or routing around via over-`k̄`.
3. **Four per-iter-narrative phrases** bleed prior planner state into
   STRATEGY.md prose; excise them this iter (DRIFTED, not NON-COMPLIANT
   — no restructure needed, just targeted excisions).
