# Strategy Critic Report

## Slug
iter123

## Iteration
123

## Mode

Re-verification of iter-122 strategy revisions. Prior critique
challenged M1 framing, M2 effort estimate, M2.d single-route framing,
M3 effort estimate, and the named-axiom alternative. Iter-122
revisions addressed each. This report re-audits with a fresh
mathematician's perspective and surfaces residual concerns.

## Routes audited

### Route: M1 — Bridge presheaf ↔ algebra-Kähler on affine charts

- **Goal-alignment**: PARTIAL — M1 is explicitly OFF the critical
  path for closing `nonempty_jacobianWitness`. It does not advance the
  protected-chain sorry count (it introduces a sorry'd declaration
  and closes it; net zero). The strategy frames it as "Mathlib
  contribution work invited by the iter-121 user pivot directive."
  Aligned to *that* directive, but not aligned to the project's
  stated end-state of "zero inline `sorry` rooted at `Jacobian.lean:179`."
- **Mathematical soundness**: PASS — the decomposition into M1.a
  (submonoid), M1.b (`IsLocalization` via two-sided localizing
  isomorphism), M1.c (inlined `Subsingleton Ω` via formal
  unramifiedness of localizations), M1.d (`equivOfFormallyUnramified`
  tower-cancellation), M1.e (assembly) is correct mathematically.
  The shift in M1.b to building both `A_M → A_colim` and
  `A_colim → A_M` and concluding via `IsLocalization.of_le` (instead
  of a `Functor.Final` argument) is a sound simplification — the
  intended target is the universal property of `A_colim`, not its
  presentation as a colim.
- **Sunk-cost reasoning detected**: yes (residual) — the iter-122
  rewrite added an "Honest opportunity-cost statement" but the
  argument for choosing M1 over M2.a in iter-122 (and presumably
  iter-123) reads as: "M1's blueprint is detailed and aligned;
  M2.a's prerequisite `Rigidity.lean` refactor has not been scoped."
  The fix for "M2.a's prerequisite is not scoped" is to scope it,
  not to keep working on M1. The strategy schedules M2.a for
  iter-124+, but does not name an iter for the Rigidity.lean
  refactor-scoping step. That gap perpetuates the M1-over-M2.a
  preference until M1 stalls.
- **Phantom prerequisites**: none — all 8 named Mathlib leverages
  verified (`KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`,
  `Algebra.FormallyUnramified.of_isLocalization`,
  `KaehlerDifferential.exact_mapBaseChange_map`,
  `KaehlerDifferential.map_surjective`,
  `IsAffineOpen.isLocalization_basicOpen`, `IsLocalization.of_le`,
  `IsAffineOpen.appLE_eq_away_map`,
  `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`).
- **Effort honesty**: reasonable — the iter-122 revision (4–7 iter /
  200–400 LOC, with 3–5 iter / 200–400 LOC for M1.b alone) is honest
  about the `IsLocalization.of_le` two-direction construction cost.
- **Verdict**: CHALLENGE — not the math, the *scheduling* and the
  *off-critical-path framing*. See "Must-fix" below.

### Route: M2 — Genus-0 witness `genusZeroWitness`

- **Goal-alignment**: PASS — M2 produces exactly half of the
  genus-stratified body of `nonempty_jacobianWitness`. The Brauer–
  Severi case (no `k`-rational point) is handled by vacuity of
  `isAlbaneseFor` (the field universally quantifies over `P : 𝟙_ ⟶ C`,
  which has no inhabitants if `C(k) = ∅`). Verified against
  `Jacobian.lean:143–160` — the `JacobianWitness` structure has
  exactly this universal-quantification shape, so vacuity does
  apply.
- **Mathematical soundness**: PARTIAL — see M2.d below. The base-
  change-and-descent skeleton is sound, but the M2.d cotangent-
  vanishing alternative has an unacknowledged characteristic-`p`
  hazard.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: M2.c's "Galois descent of morphism
  equality of schemes" is named but not Mathlib-spot-checked by the
  strategy. Without a verified Mathlib name, this step's cost is
  speculative.
- **Effort honesty**: under-counted on M2.d (alt) — see below.
- **Verdict**: CHALLENGE — M2.d's cotangent-vanishing alternative
  has a characteristic-p hazard and its effort estimate (5–10 iter /
  300–800 LOC) is optimistic.

### Route: M2.d — Genus-0 identification (RR path vs cotangent-vanishing)

- **Goal-alignment**: PASS for the RR path; PARTIAL for the
  cotangent-vanishing alternative — see soundness.
- **Mathematical soundness**: PARTIAL.
  - **RR path** is mathematically sound: build Mathlib's RR for
    curves over `k̄`, then identify `C_{k̄} ≅ ℙ¹_{k̄}` via the
    standard genus-0-with-rational-point argument.
  - **Cotangent-vanishing alternative** has a characteristic-`p`
    hazard the strategy does not acknowledge. The argument as stated
    is: `H⁰(C, Ω¹_{C/k̄}) = 0` (genus 0 via Serre duality), so
    pullbacks of invariant differentials on `A` vanish, so
    `df = 0`, so `f` factors through `Spec k̄`. The last step is
    invalid in characteristic `p > 0`: `df = 0` only forces `f` to
    factor through the relative Frobenius `F_C : C → C^{(p)}`. To
    conclude `f` is constant in char `p`, one must either
    (i) iterate the Frobenius factorization and argue convergence,
    (ii) invoke that abelian varieties have no rational curves, or
    (iii) reduce to char 0 via lifting / spreading-out. Each adds
    work the 5–10 iter / 300–800 LOC estimate does not account for.
  - The Serre-duality-for-curves prerequisite is itself substantial:
    it requires the dualizing sheaf, coherent-cohomology duality,
    and finiteness of coherent cohomology on projective schemes —
    none of which Mathlib has in usable form (verified: zero
    matches for `Serre duality` in Mathlib sources). The claim
    "Serre duality is a smaller gap than full Riemann–Roch" is
    plausible (Serre duality doesn't need the explicit
    `dim H⁰(D) − dim H⁰(K-D) = deg D + 1 − g` count), but only
    modestly so — the dualizing-sheaf infrastructure overlaps
    heavily with what RR needs.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: "abelian-variety cotangent triviality"
  is named "(probably available)" — the parenthetical is honest but
  the strategy should verify before committing.
- **Effort honesty**: under-counted for the alt path. A realistic
  estimate including the characteristic-p fix and the dualizing-
  sheaf infrastructure is closer to 10–20 iter / 800–1500 LOC, not
  5–10 / 300–800.
- **Verdict**: CHALLENGE — characteristic-p hazard must be
  acknowledged in STRATEGY.md, and the M2.d (alt) estimate revisited
  upward.

### Route: M3 — Positive-genus witness `positiveGenusWitness`

- **Goal-alignment**: PASS — closes the second half of the genus-
  stratified body. The Albanese-variety construction via either
  Picard scheme (Route A) or symmetric powers + Stein (Route B) is
  the standard mathematical content.
- **Mathematical soundness**: PASS — both routes are textbook.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none claimed as present. All Route A
  and Route B top-3 pieces explicitly marked as missing — and indeed
  verified missing in Mathlib (no Hilbert-functor representability,
  no symmetric powers of schemes, no Stein factorisation, no
  Riemann–Roch for curves).
- **Effort honesty**: reasonable for the bottom-line "100+ iter /
  10000+ LOC per route" estimate. The "hard fallback ⇒ user
  escalation when both routes exceed 5000 LOC" rule is sound. The
  fact that the iter-123 audit is scheduled independently of M1
  (a parallel deliverable, not a sequential gate) is good — that
  fixes the iter-122 critique.
- **Verdict**: SOUND — modulo the audit actually being dispatched
  this iter, which the strategy commits to.

### Route: Genus-stratified body decomposition

- **Goal-alignment**: PASS — the `by_cases h : genus C = 0`
  decomposition is well-formed (`genus C : ℕ` has decidable
  equality). The two arms `genusZeroWitness` and
  `positiveGenusWitness` cover all cases.
- **Mathematical soundness**: PASS — verified that the
  `JacobianWitness` structure's `smoothGenus` field has type
  `SmoothOfRelativeDimension (genus C) J.hom`, so genus-0 ⇒ J is
  relative-dim 0; genus ≥ 1 ⇒ J is relative-dim ≥ 1. The two arms
  produce well-typed witnesses against this constraint.
- **Phantom hypotheses**: PASS — the strategy explicitly handles
  the no-`k`-rational-point case via vacuity of `isAlbaneseFor`,
  avoiding the Brauer–Severi blind spot the iter-121 first draft
  fell into.
- **Sunk-cost reasoning detected**: no.
- **Effort honesty**: N/A (this is a 1-line case-split when both
  arms are defined; cost is in the arms, not the split).
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: M1 deferral entirely until M2/M3 land

- **What it looks like**: drop M1 from the iter-by-iter roadmap.
  The bridge `relativeDifferentialsPresheaf_iso_kaehler_appLE` is
  not consumed downstream by M2.a, M2.b, M2.c, M2.d, M3.A, or M3.B
  (the strategy explicitly says so). Spend every iter on M2.a (or
  the scoping work for the Rigidity.lean refactor that M2.a needs)
  and the M3 audit. Leave M1 to a future Mathlib-contribution sprint
  once the protected chain is closed by named-axiom or upstream-PR
  routing.
- **Why it might be cheaper or sounder**: 4–7 iter spent on M1 is
  4–7 iter not spent on the critical path. Even if M3 will
  ultimately escalate to the user, M2.a is a sub-3-iter step that
  closes a verifiable piece of the critical path *now*. Soundness
  argument: a fresh mathematician would not justify off-critical-
  path work by "the user said we can act as Mathlib contributors,
  so let's do that" when an on-critical-path step is sitting on
  deck. The user pivot directive *permits* Mathlib contribution
  work, it does not *require* prioritising it over critical-path
  steps.
- **What the current strategy may have rejected**: the strategy's
  rebuttal is "M2.a needs a Rigidity.lean refactor that has not been
  scoped." That is an argument for scoping the refactor, not for
  picking M1.
- **Severity of the omission**: major — the iter-122 strategy-
  critic challenge on M1's off-critical-path status was answered by
  "we still execute M1 per user pivot," but the answer does not
  address the opportunity-cost critique squarely. A fresh
  mathematician would re-raise it.

### Alternative: Skip the genus-stratified case split; build the Albanese functor representability directly

- **What it looks like**: instead of `by_cases h : genus C = 0`,
  build a uniform construction of `JacobianWitness C` via the
  Albanese-functor representability theorem. The Albanese
  functor is `Hom(C, -)` restricted to abelian varieties and
  pointed morphisms; it is represented by `Alb(C)`. The
  representability is what `JacobianWitness` *is*, modulo
  packaging.
- **Why it might be cheaper or sounder**: avoids two parallel
  arms (M2 + M3); one uniform construction. Avoids the genus-0
  edge-case subtleties (Brauer–Severi vacuity, base change to k̄
  for rigidity).
- **What the current strategy may have rejected**: the Albanese-
  functor representability is exactly M3 (it *is* the Albanese
  variety construction). So this alternative collapses into M3 and
  doesn't save the genus-0 work — it just removes the cheap genus-0
  win that M2 offers. **Rejected for sound reasons**: the genus-
  stratified split lets the genus-0 arm close at 15–30 iter rather
  than waiting for M3's 100+ iter.
- **Severity of the omission**: minor — strategy's choice is
  defensible; this alternative would *increase* total iter cost.

### Alternative: M2.d via direct char-independent Mumford rigidity over k̄, no cotangent argument, no RR

- **What it looks like**: Mumford's rigidity lemma — any morphism
  from a proper variety to an abelian variety that contracts a
  divisor is constant. Specialised to `C → A` with `f(P) = e_A`:
  if `C` is genus 0 (so `C ≅ ℙ¹` over `k̄`), use that any
  morphism from `ℙ¹_{k̄}` to an abelian variety is constant (this
  is a *direct* application of `GrpObj.eq_of_eqOnOpen` plus the
  fact that `ℙ¹` is rational). But — this still needs `C ≅ ℙ¹`
  over `k̄`, which loops back to the RR-path.
- **Alternative formulation**: any morphism from a proper geom-
  irred curve `C` of genus 0 to an abelian variety is constant,
  *without* identifying `C ≅ ℙ¹`. Argument: such a map factors
  through the Albanese of `C`, which is trivial (since for genus 0,
  `Alb(C) = 0` over `k̄`). But this is circular — we are *defining*
  the Albanese, so we can't use its triviality as input.
- **Why it might be cheaper or sounder**: it might not be — both
  variations reduce to either the RR path or a genus-0 cotangent
  argument with the characteristic-p hazard.
- **Severity of the omission**: minor — the strategy's two-variant
  M2.d framing (RR-path vs cotangent-vanishing) already covers the
  reasonable choices.

## Sunk-cost flags

- `"M1's blueprint is now (iter-122) fully detailed with analogist-
  verified Mathlib alignment; M2.a's project-side prerequisite
  GrpObj.eq_of_eqOnOpen requires a Rigidity.lean source-side
  refactor (per blueprint-writer-jacobian-iter121 finding) that has
  not been scoped"` — Why this is sunk-cost: the *fact* that M1's
  blueprint is detailed (because we've worked on it) is being used
  as a reason to keep working on M1 rather than scoping the M2.a
  refactor. Recommendation: schedule the M2.a Rigidity.lean refactor
  scoping as an iter-123 deliverable (parallel to the M3 audit, both
  off the prover lane). Decide M1 vs M2.a on the merits — M2.a's
  expected total cost vs M1's expected total cost — not on which
  blueprint is currently more detailed.

- `"If the M1 work stalls (progress-critic CHURNING for 2+ iters),
  the critical-path-preference rule fires: pivot to M2.a"` —
  Why this is sunk-cost-adjacent: it commits to staying on M1
  until it visibly stalls, instead of evaluating on the merits each
  iter. Recommendation: invert the default. Make "on critical
  path" the default tiebreaker; M1 must affirmatively justify
  itself each iter against an on-critical-path alternative, not the
  other way around.

## Prerequisite verification

All claimed Mathlib leverage verified present:

- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`: VERIFIED
  (`Mathlib/RingTheory/Etale/Kaehler.lean:38`)
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED
  (`Mathlib/RingTheory/Unramified/Basic.lean:303`)
- `KaehlerDifferential.exact_mapBaseChange_map`: VERIFIED
  (`Mathlib/RingTheory/Kaehler/Basic.lean:753`)
- `KaehlerDifferential.map_surjective`: VERIFIED
  (`Mathlib/RingTheory/Kaehler/Basic.lean:710`)
- `IsAffineOpen.isLocalization_basicOpen`: VERIFIED
  (`Mathlib/AlgebraicGeometry/AffineScheme.lean:650`)
- `IsLocalization.of_le`: VERIFIED
  (`Mathlib/RingTheory/Localization/Defs.lean:173`)
- `IsAffineOpen.appLE_eq_away_map`: VERIFIED
  (`Mathlib/AlgebraicGeometry/AffineScheme.lean:669`)
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: VERIFIED
  (`Mathlib/RingTheory/Smooth/StandardSmoothOfFree.lean:49`)

Claimed Mathlib gaps confirmed absent:

- Hilbert scheme / Hilbert functor representability: MISSING
- Symmetric powers of schemes `Sym^n X`: MISSING
- Stein factorisation theorem: MISSING (zero matches in Mathlib)
- Riemann–Roch for curves: MISSING (only listed in Mathlib's
  `docs/1000.yaml` wishlist)
- Serre duality for curves: MISSING (zero matches in Mathlib)

Unverified (strategy names but does not spot-check):

- "Galois descent of morphism equality of schemes" (M2.c) —
  strategy says "Project must verify whether Mathlib has scheme-
  level Galois-descent of morphism equality." That verification
  has not been done and should be added to the iter-123 docket.
- "abelian-variety cotangent triviality" (M2.d alt) — strategy
  says "(probably available)." Should be verified before
  committing to the cotangent-vanishing alternative.

## Must-fix-this-iter

- **Route M1: CHALLENGE** — STRATEGY.md should either (a) schedule
  the M2.a Rigidity.lean refactor *scoping step* as an iter-123
  parallel deliverable (giving M2.a a concrete iter-124 start), or
  (b) explicitly defend the "M1 over M2.a in iter-123" choice on
  grounds other than "M2.a's prerequisite refactor has not been
  scoped" (which is a fixable obstacle, not a reason to avoid
  M2.a). Without (a) or (b), the M1-prioritisation reads as
  sunk-cost.

- **Route M2.d: CHALLENGE** — STRATEGY.md should:
  1. Acknowledge the characteristic-`p` hazard in the cotangent-
     vanishing alternative: `df = 0` only forces factoring through
     the relative Frobenius in char `p > 0`, not constancy.
  2. Either name how the char-`p` case is handled (Frobenius
     iteration argument, lifting to char 0, or restriction to
     char-0 fields with a separate plan for char `p`), or revise
     the alt-path estimate upward to account for handling it.
  3. Revise the M2.d-alt estimate to 10–20 iter / 800–1500 LOC,
     accounting for the dualizing-sheaf infrastructure required by
     Serre duality plus the char-`p` work.

- **Phantom prerequisite (M2.c)**: schedule a Mathlib-coverage
  spot-check on "Galois descent of morphism equality of schemes"
  alongside the M3 audit in iter-123. Without it, M2.c's 3–6 iter /
  150–300 LOC estimate is speculative.

- **Phantom prerequisite (M2.d alt)**: schedule a spot-check on
  "abelian-variety cotangent triviality" (likely names:
  `AbelianVariety.cotangent_trivial`,
  `Algebra.GroupSchemeOmegaTrivial`, or similar). If missing in
  Mathlib, the M2.d alt estimate revises further upward.

## Overall verdict

The iter-122 STRATEGY.md revisions adequately address most of the
prior strategy-critic challenges: M1 is correctly framed as
off-critical-path with an explicit opportunity-cost statement; M2.d
splits into RR-path and a cotangent-vanishing alternative; M3 cost
is honest at 100+ iter / 10000+ LOC per route; the named-axiom
alternative is correctly ruled out. All claimed Mathlib leverage
verifies; all claimed Mathlib gaps confirm.

However, two material concerns remain. First, the M1-over-M2.a
prioritisation in iter-123 is justified by "M2.a's prerequisite
refactor has not been scoped," which is sunk-cost-adjacent — the
fix is to scope the refactor, not to keep working on M1. STRATEGY.md
should schedule the Rigidity.lean refactor-scoping step as an
iter-123 parallel deliverable, putting M2.a on a concrete iter-124
start. Second, the M2.d cotangent-vanishing alternative has an
unacknowledged characteristic-`p` hazard: `df = 0` does not imply
constancy in char `p > 0`. STRATEGY.md should acknowledge this and
either name the handling or revise the alt-path estimate upward.

A fresh mathematician would approve the strategy *after* these two
fixes; without them, the strategy is plausibly executing off-
critical-path work for sunk-cost reasons, and is over-optimistic
about the genus-0 closure cost in positive characteristic.
