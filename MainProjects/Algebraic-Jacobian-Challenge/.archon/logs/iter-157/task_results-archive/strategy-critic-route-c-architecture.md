# Strategy Critic Report

## Slug
route-c-architecture

## Iteration
157

## Routes audited

### Route: A — Picard/Quot/Hilbert FGA engine (positive-genus object)

- **Goal-alignment**: PASS — the protected goal forbids `C(k)≠∅`, so the positive-genus
  witness must be a real dim-`g` AV even when `C(k)=∅`; `Pic⁰_{C/k}` is the canonical
  such object and the FGA engine is genuinely unavoidable. No subtler object dodges it.
- **Mathematical soundness**: PASS — FGA Picard representability + identity component is
  established mathematics; the decomposition (Quot/Hilbert → repr `Pic` → `Pic⁰` →
  Albanese UP) is the standard construction.
- **Effort honesty**: under-counted (disclosed) — `~5100+ · 0/it` with `~40–70` iters
  left and **0 realized LOC after 157 iterations** is the headline risk. The line "NOT
  yet itemised in ~5100 — true budget higher" (the Albanese UP) is honest, but it means
  the *named* critical-path number is acknowledged as an under-count. Verdict honest, not
  dishonest, but the reader should register: the critical path has not been started.
- **Verdict**: SOUND — proceed, with eyes open that this is the project-fatal piece and
  it remains at zero realized progress.

### Route: genus-0 rigidity (c) — char-free AV-rigidity stack

- **Goal-alignment**: PARTIAL — the stack delivers "ℙ¹ → A is constant" (Prop 3.10), but
  `rigidity_over_kbar` is stated for a *general genus-0 curve* `C_k̄`. The bridge
  `genus-0 + k̄-point ⟹ C_k̄ ≅ ℙ¹` (or at least `⟹ unirational`) is a real, separate
  theorem (Riemann–Roch / anticanonical, Hartshorne IV) that is **not itemised** in the
  `1500–3500` budget. For a smooth proper curve, unirational ⇔ rational ⇔ `≅ ℙ¹`, so this
  cannot be dodged. Flag it as a missing line-item, not a soundness hole.
- **Mathematical soundness**: PASS — the Milne chain (cube → Rigidity 1.1 → Thm 3.2 →
  Prop 3.10) is correct and, crucially, **char-free**. Thm 3.2 (rational map extends) is
  in fact trivial for the curve case (a rational map from a smooth curve to a proper
  variety is automatically a morphism), so the real weight is theorem-of-the-cube +
  Prop 3.10.
- **Effort honesty**: under-counted — see CHALLENGE below. The theorem of the cube drags
  in **seesaw + flat/proper cohomology base change + semicontinuity + line bundles on
  products**, none of which exist in Mathlib (verified: no `AbelianVariety`, no Picard
  infrastructure, only bare `Proj` structure sheaf). These prerequisites are plausibly
  comparable in cost to a chunk of the representability monster, yet the row is labelled
  "the LOW-risk half" and "likely the cheapest unbuilt critical-path deliverable."
- **Verdict**: CHALLENGE — the *commitment* to route (c) is defensible (the char-free
  property is a genuine, non-sunk-cost reason; see below), but the **cost framing is not
  honest** and the **cheapest-route comparison is asserted, not shown**. Both must be
  fixed in STRATEGY.md this iter.

### Route: genus-0 rigidity (a) — differential / Serre-duality fallback

- **Goal-alignment**: PARTIAL — would close genus-0 only in `CharZero`; the protected
  goal is arbitrary `[Field k]`. Correctly demoted to off-path fallback.
- **Mathematical soundness**: PASS — sound where it applies (char 0).
- **Verdict**: SOUND — correctly held as a gated fallback, not deleted.

### Route: genus-0 rigidity (b) — byproduct of the engine

- **Verdict**: SOUND — `Alb(genus-0)=Pic⁰(ℙ¹)=0` is correct; correctly ranked behind (c)
  because it couples genus-0 to the A.2 representability risk.

## Format compliance

- **Size**: 134 lines / ~9 KB — within budget.
- **Headings**: PASS — section list is exactly `## Goal`, `## Phases & estimations`,
  `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: no (borderline) — no literal `iter-NNN` strings. Mild
  history-flavoured phrases ("skeleton already 6/7 closed", "the `df=0` framing was a red
  herring of the chart route", "Kept in tree … not deleted") are present but do not name
  iterations. Trim on next edit; not a violation.
- **Accumulation detected**: no — the "New project material introduced (in tree)"
  bullet list edges toward inventory-tracking, but is framed as gaps/assets and is short.
- **Table discipline**: PASS — columns match the canonical set; LOC cells carry both
  figures (e.g. `~5100+ · 0/it`).
- **Appendix sections**: the trailing `**Soundness rules (operational):**` is a bolded
  paragraph inside the last section, not a `##` heading — not the renamed-section
  violation the skeleton warns about. Acceptable; could fold into a one-liner.
- **Format verdict**: COMPLIANT.

## Alternative routes (suggested)

### Alternative: concrete-ℙ¹ differential route (the directive's question 1)

- **What it looks like**: over `k̄`, `C_k̄ ≅ ℙ¹`; compute `H⁰(ℙ¹,Ω) = H⁰(ℙ¹,O(−2)) = 0`
  *directly* (Euler sequence / explicit transition functions — NOT general Serre
  duality); pull back invariant differentials `f^*: H⁰(A,Ω_A) → H⁰(ℙ¹,Ω) = 0`; since
  invariant forms generate `Ω_A` (the `GrpObj` cotangent material), conclude `df = 0`;
  then `df=0 ⟹ constant` via the **already-closed, axiom-clean KDM/chart envelope**.
- **Why it might be cheaper or sounder**: it reuses an asset the project already owns and
  sidesteps the theorem of the cube entirely. The directive's sharp sub-question is
  correct: the iter-155 refutation was about a *general* genus-0 curve where every chart
  `Ω_C(V)` is free rank-1 so KDM can't *detect* `df=0` globally — that refutation does
  **not** apply to the *concrete* `ℙ¹`, whose `H⁰(Ω)=0` is genuinely elementary. So the
  "cheap ℙ¹" route is **not** killed by iter-155.
- **Why it nonetheless does not displace route (c)**: it dies on the **char-`p` wall**.
  `df=0 ⟹ constant` is FALSE in char `p` without Frobenius descent (a map can factor
  through the Frobenius `ℙ¹→ℙ¹`). Closing it needs: (1) `df=0 ⟹ factors through Frobenius`
  (a real theorem to formalize), and (2) the infinite-factorisation argument
  `f^*k(A) ⊆ ⋂_n k(ℙ¹)^{p^n} = k̄ ⟹ constant`. That is a whole Frobenius-descent
  subproject the protected no-`CharZero` goal forces. Route (c) is char-free precisely to
  avoid this. **This is the real reason route (c) wins, and STRATEGY.md never states it**
  — it lumps the cheap-ℙ¹ idea under "fallback (a) carries a char-`p` gap" without noting
  that ℙ¹'s `H⁰(Ω)=0` is cheap (unlike general Serre duality). The cheapest-route question
  has been *answered correctly but not shown to be tested*.
- **What the current strategy may have rejected**: it conflates "concrete ℙ¹ `H⁰=0`" with
  "general Serre duality `H⁰(C,Ω_C)=0`" and discards both together under (a).
- **Severity of the omission**: major — the conclusion (commit c) is right, but the
  decision record must show the comparison, or a fresh reader cannot tell route (c) was
  chosen on merit rather than on the cube being already half-blueprinted.

## Prerequisite verification

- `AbelianVariety` (Mathlib AV theory): MISSING (loogle: no results) — consistent with
  the strategy's "absent from Mathlib" claim. Safe direction (asserts absence).
- `PicardScheme` / `Pic⁰` representability: MISSING — consistent with strategy.
- `RelativeSpec` (named A.2 entry point, ~700–1100 LOC): MISSING under that name (loogle:
  no results). Mathlib has `Spec`/`StructureSheaf`/`Proj` but no relative-Spec packaging
  surfaced. Not phantom-assumed-present (strategy treats it as a build target), but the
  exact entry-point name should be confirmed before a prover is gated on it.
- ℙ¹ differential cohomology (`H⁰(ℙ¹,Ω)=0`, `Ω_{ℙ¹}≅O(−2)`): MISSING — only bare `Proj`
  structure-sheaf machinery exists. Relevant if the concrete-ℙ¹ alternative is ever
  costed: that route is NOT free either.

## Must-fix-this-iter

- **Route (c): CHALLENGE** — (1) cost the **theorem-of-the-cube prerequisites** (seesaw,
  flat/proper cohomology base change, semicontinuity, line bundles on products) as
  explicit sub-line-items, and confirm the total is genuinely cheaper than the
  df=0+Frobenius-descent alternative; (2) add the missing line-item
  `genus-0 curve over k̄ ⟹ ≅ ℙ¹ / unirational` (Riemann–Roch, Hartshorne) to the genus-0
  budget; (3) either soften "the LOW-risk half / cheapest unbuilt deliverable" or justify
  it against the now-explicit cube cost.
- **Alternative (concrete-ℙ¹): major** — record in STRATEGY.md the one-line reason route
  (c) beats the cheap-ℙ¹ route: *ℙ¹'s `H⁰(Ω)=0` is elementary and iter-155 does not refute
  it, but the df=0 step needs Frobenius descent in char `p`, which the char-free cube
  avoids.* This converts an asserted decision into a tested one.

## Overall verdict

A fresh mathematician would **endorse the destination but not the map**. The commitment
to route (c) for genus-0 is the correct call, and for the right underlying reason — the
protected goal's arbitrary `[Field k]` makes char-freeness decisive, since every
differential/`H⁰` route (including the genuinely-cheap concrete-ℙ¹ computation that
iter-155 does *not* refute) hits a char-`p` Frobenius-descent wall that the
theorem-of-the-cube stack sidesteps. But STRATEGY.md presents this as settled without
showing the comparison, and it under-costs route (c) by hiding the theorem-of-the-cube
prerequisites (seesaw + cohomology base change, all absent from Mathlib) and the
`genus-0 ⟹ ℙ¹` bridge inside a flat `1500–3500` estimate while branding it "the low-risk
half." With BOTH arms now confirmed as multi-thousand-LOC, absent-from-Mathlib geometry
builds at 0 realized LOC/iter, "genus-0 is low-risk" is true only *relative to*
representability, not in absolute terms — the overall feasibility framing should say so.
Format is clean and compliant. Fix the two recorded items in-place this iter; the routes
themselves do not need rewriting.
