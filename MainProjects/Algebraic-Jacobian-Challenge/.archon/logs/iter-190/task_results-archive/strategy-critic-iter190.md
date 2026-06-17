# Strategy Critic Report

## Slug

iter190

## Iteration

190

## Routes audited

### Route: A — Picard scheme via FGA

- **Goal-alignment**: PARTIAL — route ends at `Pic⁰_{C/k}` as Albanese, which matches the goal; but Lane M↓ commits a permanent `sorryAx`-producing named gap that the goal's "kernel-only axioms" clause forbids.
- **Mathematical soundness**: PASS — Kleiman §4–5 + Nitsure §5 + Milne III §6 is the textbook construction; the dependency graph is mathematically faithful.
- **Sunk-cost reasoning detected**: yes — "STOP dispatching provers on `CodimOneExtension.lean`" frames a give-up as a strategic commitment; the justification ("Option c COMMITTED") never argues that the route does not in fact need Stacks 00TT, it argues that the project is going to stop trying.
- **Infrastructure-deferral detected**: yes — `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT) is required by the goal (consumed by `CodimOneExtension` → A.4.a → A.4 → Route A), and the strategy plans to ship the final theorem with a permanent named typed sorry pending an unscheduled Mathlib PR. See the dedicated finding below.
- **Phantom prerequisites**: none confirmed phantom; spot-checks below.
  - `LocallyConnectedSpace` — VERIFIED in `Topology/Connected/LocallyConnected.lean`. The strategy's row "`LocallyConnectedSpace` from `IsLocallyNoetherian` (NEW)" is the *bridge lemma* (EGA I 6.1.9), which is the genuine gap; not phantom.
  - `IsLocallyNoetherian` — VERIFIED (`AlgebraicGeometry/Noetherian.lean`).
  - `CategoryTheory.GrpObj` — VERIFIED (`CategoryTheory/Monoidal/Grp_.lean`).
  - `GeometricallyIrreducible` — VERIFIED (`AlgebraicGeometry/Geometrically/Irreducible.lean`).
  - `Scheme.restrictFunctorIsoPullback` — VERIFIED (`AlgebraicGeometry/Modules/Sheaf.lean`).
  - `IsOpenSubgroupScheme` — MISSING locally; new project material, not phantom in the strategy's sense (correctly enumerated as a gap).
  - `Algebra.Extension.cotangentComplex` — VERIFIED at algebra level; the A.3.iii substrate "deformation theory; cotangent complex at identity" needs the *scheme-level* tangent-space-via-deformations theorem, which is NOT enumerated as a separate substrate line in the gaps section.
- **Effort honesty**: under-counted on the A.3.iii–iv pair and on A.4.d.
  - A.3.iii (tangent iso) and A.3.iv (smoothness) both reduce to the same deformation-theory / cotangent-complex-at-identity substrate. Splitting them into 6–10 + 8–12 iters (totalling 14–22 iters, 500–900 LOC) underestimates the cost of the shared substrate, which is *one* deep formalization (scheme-level tangent space ↔ first-order deformations) likely heavier than the sum of the two thin assembly steps.
  - A.4.d (10–18 iters, 400–800 LOC, gated) is gated on "universal effective divisor → Pic^d morphism", but neither the universal-effective-divisor functor nor the `Pic^d` component (degree-d fiber of the degree map) is enumerated as its own phase. The degree map `Pic → ℤ` is A.3.vii but the *connected component* `Pic^d` is implicit reuse of A.3.ii + A.3.vii that the table never names. Under-counted by at least one sub-phase.
  - Other active rows (A.1.b, A.3.i, RR.1, RR.2.H⁰, RR.3) arithmetically consistent at ~30/it.
- **Parallelism under-exploited**: yes — A.3.iii–vi are listed sequentially in the dependency graph (`A.3.iii ⊳ A.3.ii; A.3.iv ⊳ A.3.iii; A.3.v ⊳ A.3.ii; A.3.vi ⊳ A.3.ii`), but in fact only A.3.iv strictly depends on A.3.iii. A.3.v (properness) and A.3.vi (geom-irreducibility) only need A.3.ii and can run in parallel with A.3.iii–iv. The graph is *correct* but the iters-left line of 6+8+6+4 = 24 iters serializes work that could compress to ~max(6+8, 6, 4) = 14 iters under parallel dispatch.
- **Verdict**: CHALLENGE — the route is mathematically sound and the iter-188 decomposition is broadly right granularity, but (1) the `isRegularLocalRing_stalk_of_smooth` "permanent named sorry" commitment makes the stated goal unprovable as written, (2) the scheme-level tangent-space substrate behind A.3.iii–iv is under-named, and (3) A.4.d depends on an unenumerated `Pic^d` / universal-effective-divisor substrate.

### Route: C — Genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k` directly satisfies the witness signature; the descent lock to `Over (Spec k)` aligns with the goal's `[Field k]`-only typing.
- **Mathematical soundness**: PASS — Milne §I.3 (Thm 3.2, Prop 3.10) plus genus-0 ⟹ ℙ¹ via Riemann-Roch is canonical and does not require Serre duality.
- **Infrastructure-deferral detected**: no — RR.2 H¹ skyscraper-flasque vanishing was the only previously-deferred construction on this arm, and it is now committed as a project-side phase with a concrete LOC estimate (~200–400). The promotion addresses the prior critique.
- **Effort honesty**: reasonable — 40–60 iters / 2080–3700 LOC for the full Route C is internally consistent with ~30 LOC/it realized velocity on the four active RR rows.
- **Verdict**: SOUND — the iter-188 promotion of RR.2.H¹ and the chart-bridge III.c separated-locus pivot together close the previous live challenges on this arm.

## Format compliance

- **Size**: 150 lines / 11 659 bytes — within budget but at ~97 % of the 12 KB cap; one more iter of growth pushes over.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in order.
- **Per-iter narrative detected**: yes — multiple verbatim "iter-188 / iter-189" references:
  - "pivot from Sym^g route per iter-188 decision" (phases table)
  - "A.3 decomposed into 7 sub-phases per strategy-critic iter-188 finding"
  - "RR.2 H¹ promoted ... per strategy-critic iter-188 finding"
  - "per iter-188 strategy-critic finding" (Routes section)
  - "chart-bridge III.c separated-locus iter-188"
  - "Chapter rewrite iter-189 plan-phase"
  Iter sidecars are the home for audit-trail to prior iters; STRATEGY.md should state the *current* decomposition without crediting its provenance.
- **Accumulation detected**: minor — `## Open strategic questions` carries three lines of `REJECTED — ...` flags (Sym^g, Pic⁰-functor-of-points). These act as "Considered alternatives" by another name. Reasonable to keep load-bearing warnings, but each rejection should give one-line *current-mathematical* reason rather than a historical decision tag.
- **Table discipline**: PASS with minor gaps — most LOC cells carry both figures or "gated" velocity; A.1.a (~0/it) is honest for a complete row but the 5–10 iters-left claim is then arithmetically incoherent (5 × 0 = 0). The chart-bridge collapse-at-zero row reads "NOT-YET-MEASURED" instead of a velocity, which is a minor discipline gap.
- **Format verdict**: DRIFTED — the per-iter narrative is the main issue; everything else is minor.

## Infrastructure-deferral findings

### Deferred: `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT)

- **Required by goal**: yes — codim-1 extension consumes it (Lane M↓ feeds `CodimOneExtension.lean`), `CodimOneExtension` feeds A.4.a, A.4.a is dominant Route-A risk feeding A.4.c → A.4.d → Albanese existence. Without it, the protected `nonempty_jacobianWitness` cannot close kernel-axiom-clean.
- **Current plan for building it**: none — the strategy reads "accept narrow named typed sorry as permanent until Mathlib upstream" and "STOP dispatching provers on `CodimOneExtension.lean`". No project-side build, no Mathlib PR estimated.
- **Timeline**: absent — "off Mathlib upstream timeline" is explicit.
- **Verdict**: REJECT — the goal's end-state is "zero inline sorry, kernel-only axioms `{propext, Classical.choice, Quot.sound}`". A named typed sorry introduces `sorryAx`, which is not in that allow-list. The deferral is therefore a *goal weakening dressed as a strategic decision*. Either (a) Lane M↓ Option (a) / (b) — build it project-side, ~50–150 LOC of basic commutative algebra (smooth → flat → presentation by polynomial relations → regular sequence → regular local ring) — must be re-committed, or (b) the goal must be relaxed to allow that specific named sorry, in which case STRATEGY.md and the protected-declaration contract should say so explicitly.

### Deferred: scheme-level tangent space via first-order deformations

- **Required by goal**: yes — A.3.iii (tangent iso `H¹(O_C) ≅ T_0 Pic⁰`) and A.3.iv (smoothness of relative dim g) both consume this substrate; both feed A.3 → Pic⁰ as abelian variety → witness object.
- **Current plan for building it**: implicit — neither A.3.iii nor A.3.iv enumerates the scheme-level tangent-space construction as a separate substrate row in `## Mathlib gaps & new material`. The gaps section lists "A.3.iii–vi Pic⁰ AV wrap (tangent iso, smoothness, properness, geom-irreducibility). ~800–1600 LOC." as one bundle.
- **Timeline**: vague — folded into the 6–10 / 8–12 iters of A.3.iii / A.3.iv with no separate iter budget.
- **Verdict**: CHALLENGE — the strategy under-decomposes a load-bearing substrate. Add a sub-row "A.3.iii.0 — scheme-level tangent space ↔ first-order deformations" with its own iter / LOC budget so the planner can dispatch a prover on it without that work being silently absorbed into A.3.iii.

### Deferred: `Pic^d` component / universal effective divisor functor (A.4.d substrate)

- **Required by goal**: partially — A.4.d Albanese UP is required; the substrate is what A.4.d concretely needs.
- **Current plan for building it**: implicit reuse of A.2.b (Quot ⇒ Hilb of points ⇒ universal effective divisor for a smooth curve) and of A.3.ii + A.3.vii (Pic⁰ + degree map ⇒ Pic^d as fiber). The strategy never names this reuse path.
- **Timeline**: bundled inside A.4.d's 10–18 iters / 400–800 LOC.
- **Verdict**: CHALLENGE — if the reuse is genuine, write one sentence under A.4.d explaining it (e.g. "`Pic^d` := fiber of A.3.vii degree map at `d`; universal effective divisor := Hilb^d_C reused from A.2.b"). If not, the LOC estimate is materially short.

## Alternative routes (suggested)

### Alternative: Yoneda functor-of-points Albanese UP

- **What it looks like**: prove `Pic⁰_{C/k}` represents the relative-degree-0 Pic functor (already the plan in A.2.c + A.3.ii). Then for any abelian variety `A`, deduce `Mor_k(C, A) ≅ Hom_{Sch/k}(Pic⁰_C, A)` by Yoneda on the representable, using that `A` itself represents its functor of points and that the Abel-Jacobi morphism is the universal element. No codim-1 indeterminacy step: the morphism `C → Pic⁰_C` is constructed *as the universal element of the representable functor*, not extended from a rational map.
- **Why it might be cheaper or sounder**: avoids A.4.a (the dominant Route-A risk, 40–80 iters / 1500–2500 LOC) and avoids the `isRegularLocalRing_stalk_of_smooth` deferral entirely. The cost it pushes back is heavier categorical machinery (a more functorial treatment of Pic representability), but A.2.c is already paying that cost.
- **What the current strategy may have rejected**: line 113 reads "REJECTED — `Pic⁰`-functor-of-points UP (shifts codim-1 content rather than eliminates it)". This rationale is one phrase long. A fresh reader cannot tell *where* the shifted codim-1 content lands. If the claim is that constructing the Abel-Jacobi morphism `C → Pic⁰_C` from the representing object requires a codim-1 lift on the curve side, the strategy should name that lemma. As written the rejection is unjustified at the precision required to commit to a 280–500 iter alternative.
- **Severity of the omission**: major — should be re-examined before Lane M↓ is locked in as a permanent named sorry. If the Yoneda route really does compile down to an equivalent codim-1 obligation, document that equivalence; if it does not, the chosen route is over-paying by an enormous margin.

## Sunk-cost flags

- `"STOP dispatching provers on \`CodimOneExtension.lean\`"` — Why this is sunk-cost: it's framed as a directive rather than a mathematical claim. The mathematical claim ("this lemma is unprovable in-project at acceptable cost") is the one that needs to be on record; the dispatch-stop is an operational consequence. Recommendation: replace with "Lane M↓ is gated on Stacks 00TT and currently has no project-side build plan; reassess if [N] iters elapse without an upstream PR."
- `"Option c COMMITTED"` — Why this is sunk-cost: "committed" smuggles a reversibility claim into a decision that the open-strategic-questions list itself describes as conditional ("until Mathlib upstream"). Recommendation: name the conditions under which Option (c) un-commits — e.g. "Option (c) committed conditional on a Mathlib `isRegularLocalRing_stalk_of_smooth` PR landing by iter-NNN; otherwise reopen Option (a)/(b)."

## Prerequisite verification

- `LocallyConnectedSpace`: VERIFIED (Mathlib `Topology/Connected/LocallyConnected.lean`).
- `IsLocallyNoetherian`: VERIFIED (Mathlib `AlgebraicGeometry/Noetherian.lean`).
- `CategoryTheory.GrpObj`: VERIFIED (Mathlib `CategoryTheory/Monoidal/Grp_.lean`).
- `GeometricallyIrreducible`: VERIFIED (Mathlib `AlgebraicGeometry/Geometrically/Irreducible.lean`).
- `Scheme.restrictFunctorIsoPullback`: VERIFIED (Mathlib `AlgebraicGeometry/Modules/Sheaf.lean`).
- `Algebra.Extension.cotangentComplex`: VERIFIED at algebra level; *scheme-level* tangent-space-via-deformations not localised here — see deferral finding above.
- `IsOpenSubgroupScheme`: MISSING (correctly enumerated as new project material in A.3.i).
- `isRegularLocalRing_stalk_of_smooth`: MISSING — strategy plans a permanent named sorry; see infrastructure-deferral finding.

## Prior critique status (iter-188 findings re-checked)

- iter-188: A.3 decomposed into 7 sub-phases — **addressed** (A.3.i through A.3.vii present; granularity broadly right, though A.3.iii–iv share a substrate that should be split out — see CHALLENGE).
- iter-188: A.4.d pivoted Sym^g → divisor-map UP — **addressed** (line 44 + line 104). Substrate reuse path is implicit rather than explicit — minor follow-up.
- iter-188: RR.2.H¹ promoted from "off path" to committed sub-phase — **addressed** (line 49 + Routes section).
- iter-188: Lane M↓ Option (c) committed — **addressed in letter, live in spirit** — the commitment is recorded, but the commitment itself is what this iter-190 audit re-opens as an infrastructure-deferral CHALLENGE.
- iter-188: Axiomatise-then-replace removed — **addressed** (line 93–94).

## Must-fix-this-iter

- Route A: infrastructure-deferral REJECT — `isRegularLocalRing_stalk_of_smooth` is required by the goal (kernel-only-axioms clause); the strategy must either (a) re-commit to a project-side build with a concrete iter estimate, or (b) explicitly amend the goal contract to allow that specific named sorry. As written, "permanent named typed sorry" is incompatible with `## Goal`.
- Route A: infrastructure-deferral CHALLENGE — scheme-level tangent space ↔ first-order deformations substrate is unnamed; add it as a separate sub-row in `## Phases & estimations` so A.3.iii–iv don't silently absorb it.
- Route A: infrastructure-deferral CHALLENGE — `Pic^d` component and universal-effective-divisor functor for A.4.d are not explicitly enumerated; either name the reuse path (A.2.b Hilb + A.3.ii + A.3.vii) inline under A.4.d or budget them as their own sub-rows.
- Route A: CHALLENGE — A.3.iii–iv share one substrate; either combine them or split that substrate out so the 14–22 iter sum is honest. A.3.v / A.3.vi can run parallel to A.3.iii–iv; dependency graph language should reflect that.
- Alternative `Yoneda functor-of-points UP`: major omission — re-examine the line-113 rejection rationale ("shifts codim-1 content rather than eliminates it"); name the specific codim-1 obligation it shifts, or reconsider the alternative before locking Lane M↓ permanently.
- Format: DRIFTED — strip the "per iter-188 / iter-189" provenance tags from STRATEGY.md (six identified occurrences); push them into iter sidecars. Also fix A.1.a's `~0/it` × 5–10-iters arithmetic and the chart-bridge "NOT-YET-MEASURED" velocity cell.

## Overall verdict

The iter-188 revisions are *mostly* sound: the A.3 7-sub-phase decomposition is the right granularity (modulo splitting out the tangent-space-via-deformations substrate shared by iii and iv), the A.4.d Sym^g → divisor-map pivot is a legitimate reuse of A.2.b machinery rather than a problem-renaming, and the RR.2 H¹ promotion correctly puts H¹ on the critical path where the genus definition demands it. Route C is SOUND. **However, the strategy defers `isRegularLocalRing_stalk_of_smooth`, which is required for the stated goal of zero inline sorry with kernel-only axioms.** Committing Lane M↓ Option (c) to a "permanent named typed sorry until Mathlib upstream" with no project-side build and no upstream timeline is an infrastructure-deferral that, as the goal is currently written, makes the project incompletable. This is the single most consequential CHALLENGE on the strategy; it must be resolved this iter either by re-opening Lane M↓ Option (a)/(b), by negotiating an explicit goal-contract amendment, or by re-examining the rejected Yoneda functor-of-points alternative which routes around the dependency. Format is DRIFTED but not yet NON-COMPLIANT — purge the iter-NNN provenance tags in the same revision.
