# Strategy Critic Report

## Slug
iter121

## Iteration
121

## Routes audited

### Route: M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart

- **Goal-alignment**: PARTIAL — The bridge does not close any
  currently-open project sorry. It is added as a *new* sorry-bearing
  declaration in `Differentials.lean` whose closure is purely upstream
  infrastructure. The strategy is candid about this ("the new sorry-
  bearing entry in this file"), but the framing should be clearer:
  M1 is investment, not project-sorry reduction. Its only project-
  level downstream is the eventual presheaf-form scheme-level
  smoothness criterion needed in `Jacobian.smoothOfRelativeDimension_genus`,
  but that protected declaration is presently closed-modulo-witness,
  not blocked on M1.
- **Mathematical soundness**: PASS — The factorisation through
  `colim_{f V ⊆ W} O_S(W) = Localization_M A` for
  `M := {g ∈ A : appLE(g) ∈ B^×}` is correct, and the use of
  `KaehlerDifferential.isLocalizedModule_map` to push the Kähler
  module across the localisation is the right tool. The argument's
  pivot — cofinality of `{D(g) : g ∈ M}` in
  `{W : f V ⊆ W ⊆ S}` — is the classical computation of the
  inverse-image presheaf section ring on an affine chart.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: minor spelling fix — strategy writes
  `IsAffineOpen.basicOpen_isLocalization`; Mathlib's name is
  `IsAffineOpen.isLocalization_basicOpen`
  (`Mathlib.AlgebraicGeometry.AffineScheme`). `KaehlerDifferential.isLocalizedModule_map`
  (`Mathlib.RingTheory.Etale.Kaehler`) is verified.
- **Effort honesty**: reasonable — 4–7 iter / 250–450 LOC is plausible
  for a contribution of this granularity, especially given the
  cofinality lemma is genuinely new Mathlib material. M1.b's 120 LOC
  budget is the tight one; cofinality + IsLocalization wiring for a
  presheaf-of-rings colimit may push closer to 180.
- **Verdict**: SOUND, with two clarifications required for the planner:
  (a) explicitly state that M1 is upstream infrastructure that does
  **not** reduce the project's `nonempty_jacobianWitness`-rooted
  sorryAx count; (b) fix the `isLocalization_basicOpen` spelling.

### Route: M2 — Genus-0 witness via rigidity (Route C, partial)

- **Goal-alignment**: **FAIL** — M2 does not, as planned, reduce
  the project's only open project-level sorry. The protected
  `nonempty_jacobianWitness` at `Jacobian.lean:176` is
  ```
  theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
      [GeometricallyIrreducible C.hom] :
      Nonempty (JacobianWitness C)
  ```
  with no genus parameter. To turn an M2 deliverable into closure of
  this sorry, you must either (i) restructure the proof body of
  `nonempty_jacobianWitness` to case-split on `genus C = 0` vs.
  `genus C ≥ 1` — but `genus C = 0` is decidable only in the
  metatheory, so the case-split is `byCases`-on-classical and depends
  on a *decidable equality* of the natural-number genus, which is
  fine — and then provide M3 (or a different M2-style argument) for
  the `genus C ≥ 1` branch; OR (ii) accept that M2 produces *only*
  reusable building blocks (rigidity-for-`ℙ¹`, trivial-witness factory)
  that M3 consumes later. The strategy does not pick. As written, M2
  is presented as an independent milestone, but on the protected
  signature it closes nothing on its own.
- **Mathematical soundness**: PARTIAL — Two real soundness issues.
  (1) M2.a presumes morphisms `ℙ¹_k → A` hit the identity at a
  $k$-rational point. For the application to `C → A` (the genus-0
  witness's universal property), one must transport via M2.c
  `C ≅ ℙ¹_k`. But `nonempty_jacobianWitness` does not assume `C` has
  a $k$-rational point. Over a non-algebraically-closed `k`, a
  smooth proper geometrically-irreducible curve of genus 0 with no
  $k$-rational point (a Brauer–Severi conic over `k`) is *not*
  isomorphic to `ℙ¹_k`. The Jacobian is still `Spec k`, but the
  identification `C ≅ ℙ¹_k` of M2.c is genuinely false in that case.
  M2 as written is therefore valid only under the additional
  hypothesis "`C` has a `k`-rational point," which the protected
  signature does not give. (2) The proper genus-0 argument that
  *does* apply protected-signature-wide goes via base change:
  `C_{k̄} ≅ ℙ¹_{k̄}` (using `C_{k̄}` automatically has a `k̄`-point
  since it's nonempty geometrically-integral); rigidity over `k̄`;
  descent of constancy. The strategy does not mention this route,
  and base change of a `GrpObj` to the algebraic closure (with its
  group-scheme structure) is non-trivial Mathlib work the strategy
  hasn't budgeted.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: M2.c's Riemann–Roch dependency is
  flagged honestly. The base-change route (mathematically required
  for the non–`k`-rational-point case) is unbudgeted, so its
  prerequisites — base change of group-scheme structures, Galois
  descent of morphisms to schemes proper over `k` — are unenumerated.
- **Effort honesty**: M2.a/b at 200–500 LOC is plausible *if* the
  k-rational-point hypothesis is accepted (which it isn't, per the
  protected signature). The realistic estimate, including
  `geom-genus 0 ⇒ C_{k̄} ≅ ℙ¹_{k̄}` and the base-change
  group-scheme transport, is probably 50–100% higher.
- **Verdict**: CHALLENGE — the planner must address: (a) how M2
  composes with the genus-stratified case split of
  `nonempty_jacobianWitness`'s body, or otherwise produces a project
  sorry reduction on its own; (b) the missing `k`-rational-point
  hypothesis, which means M2.c (as written) is mathematically false
  for the protected signature; (c) the unbudgeted base-change-and-
  descent infrastructure required to handle the
  non-k-rational-point case.

### Route: M3 — General witness via Picard scheme or symmetric powers

- **Goal-alignment**: PASS — Either route, if completed, closes
  `nonempty_jacobianWitness` for arbitrary genus. The strategy is
  candid about the multi-month scope.
- **Mathematical soundness**: PASS — Both routes are textbook;
  Picard via FGA (Hilbert/Quot → representability of
  `Pic_{C/k}^0`) and Sym^g via Stein factorisation are standard
  alternatives. The choice between them is the actual strategic
  decision.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: the strategy does not enumerate the
  Picard route's dependencies (Hilbert scheme representability,
  Quot scheme representability, the various flatness/coherence
  lemmas for FGA) nor the symmetric-powers route's (scheme-level
  symmetric quotients by finite group actions, RR-with-coefficients
  for `Sym^g(C)`, Stein factorisation for proper morphisms). Neither
  inventory is in Mathlib at any meaningful coverage; both are
  genuine multi-month upstream contributions in their own right.
  The strategy mentions this in aggregate ("Many tens of iters /
  thousands of LOC") but does not name the gating Mathlib pieces
  per route.
- **Effort honesty**: candidly admitted as multi-month. But this is
  precisely the place where a *route-choice rubric* is missing.
  Picking the wrong route costs the project months; deferring the
  pick to "a future iter's plan-phase" without explicit decision
  criteria is a strategic punt that may not survive the next pivot.
  The strategy should commit, this iter, to a concrete trigger and
  criterion for the route pick (e.g. "after M1 closes, audit
  Mathlib snapshot for: (i) `RepresentableBy` infrastructure for
  the Picard functor; (ii) `Sym^n` schemes and the quotient-by-Sₙ
  construction; pick the route whose top-3 missing dependencies
  total < 2000 LOC of upstream work").
- **Verdict**: CHALLENGE — the planner must: (a) commit to explicit
  route-pick decision criteria *in this iter's plan*, even if the
  pick itself is deferred; (b) name the gating Mathlib pieces per
  route (top-3 dependencies each), so future iters can track
  cumulative progress against either route's bill of materials;
  (c) define the per-iter progress signal during M3's multi-month
  run (what makes iter 30/50 of M3 "on track"?).

## Alternative routes (suggested)

### Alternative: Genus-stratified body of `nonempty_jacobianWitness`

- **What it looks like**: Restructure the proof body of
  `nonempty_jacobianWitness` (the protected signature itself is
  unchanged) as
  ```
  theorem nonempty_jacobianWitness ... := by
    by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
    · exact ⟨genusZeroWitness C h⟩      -- delivered by M2
    · exact ⟨positiveGenusWitness C h⟩  -- delivered by M3
  ```
  This converts the strategy's M2 deliverable from "infrastructure"
  to "half of a sorry-closure," giving the autonomous loop visible
  intermediate progress.
- **Why it might be cheaper or sounder**: It surfaces the
  genus-stratification — which is implicit in the strategy already
  ("the genus-`0` rigidity content is absorbed into
  `nonempty_jacobianWitness`," per the protected file's comment at
  Jacobian.lean:25) — as a *Lean-level* decomposition. The genus-0
  case becomes a closed sub-theorem the iter-by-iter loop can land,
  and M3 is reframed as "close the `positiveGenusWitness` arm,"
  which is morally what it is anyway. The cost is non-zero (you
  must phrase the `byCases` correctly and supply the trivial group
  scheme structure on `Spec k`), but it converts M2 from
  preparatory infrastructure into a *demonstrable project
  milestone*.
- **What the current strategy may have rejected**: unclear. The
  strategy doesn't mention this option. The protected-signature
  body is freely editable (signatures are frozen, bodies are not),
  so there's no protectedness barrier. The likely implicit reason
  is that M2.c's `C ≅ ℙ¹_k` step is gated on Mathlib RR, so the
  genus-0 arm isn't really cheaper to close than the genus≥1 arm.
  But the strategy should at least name this reasoning.
- **Severity of the omission**: major. Without this, M2 yields no
  project-side progress signal; the iter-by-iter loop spends 4–8
  iters on M2 and the sorry inventory is unchanged.

### Alternative: Genus-0 via base change to `k̄` and Galois descent

- **What it looks like**: For the genus-0 arm, *bypass* the
  `C ≅ ℙ¹_k` identification entirely. Pull back to `k̄`, use
  classical genus-0-over-algebraically-closed (where every
  geom-irreducible nonempty curve has a `k̄`-point, hence
  `C_{k̄} ≅ ℙ¹_{k̄}`), apply rigidity for `ℙ¹_{k̄} → A_{k̄}`, and
  descend constancy back to `k`. This handles the
  Brauer–Severi-conic case the strategy's M2.c silently breaks on.
- **Why it might be cheaper or sounder**: It does not need
  Mathlib's general RR-for-curves-over-an-arbitrary-field; only
  the algebraically-closed special case, which (a) is more
  tractable and (b) is the actually-needed mathematical step. It
  also handles all genus-0 curves uniformly, including those
  without a `k`-rational point — which the protected signature
  permits.
- **What the current strategy may have rejected**: not mentioned;
  may have been overlooked. The strategy's M2.c as written is
  mathematically false on the protected signature (counterexample:
  any Brauer–Severi conic over `ℚ`).
- **Severity of the omission**: major. Without this (or some
  equivalent), M2 is mathematically incomplete for the protected
  signature, and the M2 LOC/iter estimate is undercounted.

### Alternative: Picard route via a small, mathematician-blessed sub-Picard

- **What it looks like**: Instead of constructing the full
  `Pic_{C/k}^0` via FGA (Hilbert/Quot representability), construct
  *the divisor-class group of `C`* as a discrete group scheme and
  bootstrap a coarser representability claim on the protected
  signature's universal property. This trades full
  representability for a fixed-codomain construction.
- **Why it might be cheaper or sounder**: It sidesteps Hilbert and
  Quot schemes entirely; the divisor-class group can be built from
  line-bundle data and a finiteness theorem for `Pic^0(C)(k)`.
  However, the *scheme structure* on this is exactly what FGA
  delivers, and you can't get away with a discrete underlying
  scheme for an Albanese variety (the protected
  `SmoothOfRelativeDimension g.toNat (Jacobian C).hom` would
  collapse).
- **What the current strategy may have rejected**: probably this
  exact concern — Albanese has to be a smooth proper geom-irred
  variety of dimension `g`, not a discrete group scheme. So this
  alternative is foreclosed by the protected signature on
  `smoothOfRelativeDimension_genus`. Worth naming explicitly so
  future iters don't re-propose it.
- **Severity of the omission**: minor.

### Alternative: Use Mathlib's analytic Jacobian (over `ℂ`) and *restrict the protected signature to `k = ℂ`*

- **What it looks like**: The protected signature quantifies over
  any field `k`. If the user-directive's "zero inline sorry"
  end-state proves unreachable for general `k` within the
  autonomous loop's horizon, an alternative is to negotiate a
  protected-signature *narrowing* (with the mathematician's
  approval) to `k = ℂ`, then port Mathlib's complex-analytic
  Jacobian (period lattice, polarisation theorem).
- **Why it might be cheaper or sounder**: Mathlib has substantially
  more complex-analytic geometry than algebraic-stack
  representability. The Albanese variety of a Riemann surface is
  classical and may be formalisable in 5–10× less LOC than the
  general-`k` Picard scheme.
- **What the current strategy may have rejected**: the user
  directive's "zero inline sorry" end-state is presumably tied to
  Merten's challenge specification, which quantifies over all
  fields. Narrowing the protected signature requires user
  approval and is presumably out of scope. But the strategy should
  name this option as the only available *real fallback* if M3
  proves to be a multi-year, not multi-month, build-out.
- **Severity of the omission**: minor — the strategy is following a
  user directive that probably forecloses this option, but the
  strategy should explicitly say "user directive forecloses
  alternative signature narrowing; this is the all-or-nothing
  end-state."

## Sunk-cost flags

None detected. The iter-121 pivot is explicitly driven by a fresh
user directive ("the loop now operates as a Mathlib contributor"),
not by past investment. The strategy does *not* contain claims of
the form "we've built X, so we must continue with Y." If anything,
the strategy *over-corrects* away from prior investment by treating
the previously-accepted `sorry` end-state as wholly invalidated; the
prior end-state's framing wasn't sunk-cost reasoning either.

## Prerequisite verification

- `KaehlerDifferential.isLocalizedModule_map` — VERIFIED
  (`Mathlib.RingTheory.Etale.Kaehler`).
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` — VERIFIED
  (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`); the strategy's
  M4 footnote correctly identifies the strictly-stronger converse
  hypothesis `Subsingleton (Algebra.H1Cotangent R S)`.
- `IsAffineOpen.basicOpen_isLocalization` — RENAMED. Mathlib's name
  is `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`
  (`Mathlib.AlgebraicGeometry.AffineScheme`). Strategy should fix
  the spelling so the M1.b sub-step reference is correct.
- `GrpObj.eq_of_eqOnOpen` — VERIFIED in project's
  `AlgebraicJacobian/Rigidity.lean:79`. The strategy correctly
  identifies it as the M2.a leverage.
- `Algebra.H1Cotangent` (used in the soundness-rules section) —
  not spot-checked but is the standard Mathlib name; the converse-
  counterexample discussion is mathematically correct as stated.

## Must-fix-this-iter

- **Route M1: SOUND with clarifications** — planner must (a)
  acknowledge in STRATEGY.md that M1 is upstream-infrastructure
  investment, not project-sorry reduction; (b) fix the Mathlib
  name spelling: `IsAffineOpen.isLocalization_basicOpen`
  (not `basicOpen_isLocalization`).

- **Route M2: CHALLENGE** — planner must address: (a) the
  protected `nonempty_jacobianWitness` has no genus parameter, so
  M2 alone does *not* reduce the project-sorry count; either pick
  the genus-stratified-body alternative (recording the
  `byCases h : genus C = 0` decomposition in STRATEGY.md) or
  reclassify M2 as "preparatory infrastructure for M3"; (b) M2.c's
  `C ≅ ℙ¹_k` step is mathematically false for the protected
  signature, which permits curves without `k`-rational points
  (Brauer–Severi conics); strategy must either restrict M2's
  applicability (and then explicitly handle the
  non-k-rational-point case under M3) or replace M2.c with the
  base-change-to-`k̄` + Galois-descent argument and update the LOC
  estimate.

- **Route M3: CHALLENGE** — planner must: (a) commit, *in
  STRATEGY.md*, to explicit route-pick decision criteria for the
  Picard-vs-symmetric-powers choice (e.g. "evaluate top-3 missing
  Mathlib pieces per route after M1 close; pick the route with
  smaller cumulative LOC estimate"); deferring the pick is fine,
  deferring without criteria is not; (b) name the gating Mathlib
  pieces per route (top-3 dependencies each) so iter-by-iter
  progress is trackable against either bill of materials; (c)
  define a per-iter progress signal during M3 (what does iter 30
  of M3 look like, and how does the loop verify it's on track?).

- **Alternative (genus-stratified body): major** — planner must
  evaluate this option explicitly and either adopt it (with the
  resulting `genusZeroWitness` / `positiveGenusWitness` sub-theorems
  in STRATEGY.md) or rebut it in `iter/iter-121/plan.md`.

- **Alternative (genus-0 via base change to `k̄`): major** — planner
  must adopt this (or an equivalent) for the M2 arm to be valid on
  the protected signature, or restrict M2.

## Overall verdict

A fresh mathematician would **not** approve this strategy as-is. M1
is mathematically sound and a reasonable upstream contribution, but
it does not reduce the project's current sorry count, and the
strategy presents it as a project milestone without making the
"infrastructure-only" framing explicit. M2 has two real defects:
its only product is preparatory (it cannot close the
all-genera-quantified `nonempty_jacobianWitness` on its own) and
its M2.c step is mathematically false for the protected signature
(genus-0 curves without `k`-rational points exist and break
`C ≅ ℙ¹_k`). M3 is honestly multi-month but its route-choice deferral
without explicit decision criteria — given that picking wrong costs
months — is the strategy's most serious planning gap. The strategy
faithfully implements the user's "zero inline sorry" directive, and
that directive itself is fine, but the *route to* zero sorry needs
the corrections enumerated in Must-fix-this-iter before this iter's
plan should commit. CHALLENGE.
