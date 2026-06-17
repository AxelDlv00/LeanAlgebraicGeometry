# Strategy Critic Report

## Slug
iter125

## Iteration
125

## Routes audited

### Route: End-state "zero inline sorry" vs. M1 parked

- **Goal-alignment**: FAIL — Two STRATEGY clauses contradict. Top of file:
  "The end-state is **zero inline `sorry` in the project**. There are no
  deferred tasks; every gap is on the active roadmap." Roadmap M1:
  "**Status: parked from iter-125.** ... M1 may un-park in one of
  three ways: A user directive... a future iter where M2+M3 are
  sufficiently de-risked... an off-loop / hand-formalization session."
  The sorry inventory still lists `Differentials.lean:282` (the
  `appLE_isLocalization` Function.Bijective sorry) as an open in-tree
  sorry. If M1 stays parked AND the un-park triggers are all soft
  (user choice / future de-risking / off-loop work), then this sorry
  is **deferred**, full stop — the "parked, may un-park" phrasing is
  a polite rename of "deferred."
- **Mathematical soundness**: PASS — the in-tree work being parked is
  itself sound; M1.b's `Function.Bijective ⇑forwardAlg` has a
  documented 130-210 LOC closure recipe (filtered-colim bridge +
  basic-open cofinality + `lift_injective_iff` / `lift_surjective_iff`).
- **Sunk-cost reasoning detected**: yes — the M1 "park, may un-park"
  framing is explicitly justified by the recipe being "concrete and
  feasible" and the work already invested ("M1.b helper appLE_isLocalization
  body retains the residual sorry at L398 (Steps 0+1+4+commutes' closed
  iter-122/iter-123/iter-124)"). The very reasoning that the recipe is
  feasible is what triggers the "may un-park" hope. By symmetric
  reasoning, the project should either close M1 in-loop OR delete the
  bridge wholesale; "park indefinitely until an un-park trigger fires"
  is the sunk-cost compromise.
- **Phantom prerequisites**: none (Mathlib pieces named in M1 were
  verified iter-122 / iter-123).
- **Effort honesty**: reasonable for the recipe itself; **dishonest
  about the implied terminal state** — the strategy does not own up
  to the fact that parking without a hard un-park gate makes the
  M1.b sorry permanent in expectation.
- **Verdict**: CHALLENGE

### Route: M2.a iter-125 refactor → iter-126 prover lane sequencing

- **Goal-alignment**: PARTIAL — iter-125 refactor (rename
  `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`, drop GrpObj
  hypothesis on X, weaken `IsProper Y → IsSeparated Y`) is sound and
  necessary: P^1 is not a GrpObj, so the original lemma cannot be
  applied at X = P^1_kbar. **However**, iter-126's claimed deliverable
  ("`Rigidity_over_kbar` named lemma scaffolded; C.2.b + C.2.c in
  body; C.2.d residual sorry") is over-sold: see "Mathematical soundness"
  below.
- **Mathematical soundness**: FAIL — the Sequencing table's iter-126
  row reads as if M2.a's body is essentially closed modulo one
  residual sorry. But per `Jacobian.tex` C.2, C.2.c's image-dimension
  argument only dichotomises (image is a point — done — or image is
  dim 1 — needs C.2.d). For positive-dim A, C.2.c does NOT close
  anything without C.2.d. So iter-126's actual deliverable is **a
  named scaffolding declaration whose body is "either trivial-A case
  by terminal-morphism uniqueness, or sorry-on-C.2.d"** — i.e., the
  whole rigidity content of M2.a is in the C.2.d residual. The
  strategy's iter-126 row presents this as "C.2.b + C.2.c in body"
  but the truth is closer to "scaffold the named declaration; the
  body reduces to one named sorry that itself requires M2.d-alt's
  10-20 iter / 800-1500 LOC build."
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**:
  - `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` (C.2.d):
    confirmed PHANTOM by my own `lean_leansearch` spot-check (zero
    hits for "morphism from projective line to abelian variety is
    constant"). The strategy correctly marks it phantom in the
    `Jacobian.tex` C.2.g paragraph but the iter-125→126 Sequencing
    table doesn't reflect this gate cost.
  - `AbelianVariety.cotangent_trivial` (the input to C.2.d's
    cotangent-vanishing proof): confirmed PHANTOM by my own
    `lean_leansearch` spot-check (results returned `Ideal.cotangent_*`
    and `Algebra.FormallySmooth.subsingleton_h1Cotangent` but
    nothing on the scheme/abelian-variety side).
- **Effort honesty**: under-counted — the iter-126 row reads as a
  ~1-iter deliverable but actually it's a ~1-iter scaffolding +
  10-20 iter C.2.d build-out before M2.a is genuinely closed.
- **Verdict**: CHALLENGE — the Sequencing table must either fold
  the C.2.d gating cost into M2.a's row, or rewrite iter-126's
  deliverable as "scaffold M2.a as named sorry on C.2.d phantom"
  rather than the misleading "C.2.b + C.2.c in body."

### Route: C.2.d and M2.d-alt as separate vs. shared Mathlib pile

- **Goal-alignment**: PARTIAL — STRATEGY treats C.2.d (rigidity for
  ℙ¹ → A in the M2.a body) and M2.d-alt (cotangent-vanishing rigidity
  for the genus-0 sub-case as an alternative to RR-based C ≅ ℙ¹
  identification) as separate sub-strategies under separate
  milestones. But both rely on the **same Mathlib pile**:
  (i) cotangent-triviality of an abelian variety / smooth group scheme
  over a field, (ii) Serre-duality / cohomology-of-Ω on ℙ¹ (resp. on
  a smooth proper curve), (iii) scheme-level "df ≡ 0 ⇒ f factors
  through Spec k" with characteristic-p Frobenius handling. Once that
  pile lands, **both** C.2.d and M2.d-alt close. STRATEGY's separate
  cost estimates (10-20 iter for M2.d-alt; C.2.d cost folded into
  M2.a) double-count the shared build.
- **Mathematical soundness**: PASS — the underlying mathematics is
  correct in both places.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: same as above (M2.a row): the
  cotangent-triviality + scheme-level df=0-constancy pile is the
  shared phantom.
- **Effort honesty**: over-counted on the aggregate (because the
  shared pile is listed twice); the underlying single-pile estimate
  (10-20 iter / 800-1500 LOC) is honest.
- **Verdict**: CHALLENGE — collapse the C.2.d / M2.d-alt build into
  one "shared cotangent-vanishing Mathlib pile" item, and depend
  both M2.a and M2.d-alt on it. This is a clarity/honesty fix, not
  a route-change.

### Route: Multi-month wait window iter-by-iter table

- **Goal-alignment**: PARTIAL — the table is well-intentioned (it
  surfaces what each iter actually does) but mis-leading by layout.
  Rows for iter-128 (M2.c assembly), iter-130+ (M2.c.aux), iter-130+
  (M2.d-alt) each list a single iter as the "lane" but the per-row
  cost estimates are 4-8, 3-5, 10-20 iter respectively. Reading the
  table linearly, a reader sees ~5 single-iter rows and infers M2 is
  ~5 iters away from closure. Honest read: M2.c (4-8) + M2.c.aux
  (3-5) + M2.d-alt (10-20) = 17-33 iter just for M2's prerequisites,
  plus M2.a's body (already needing M2.d-alt) plus M2.b's witness
  assembly. M2 closure is in iter-145 to iter-160, not iter-130+.
- **Mathematical soundness**: PASS — each row is mathematically
  sound in isolation.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: M2.c.aux (`geomIrred.exists_kalg_pt`)
  and M2.d-alt cotangent-triviality, both already flagged.
- **Effort honesty**: under-counted at the table layout level
  (single-iter rows for multi-iter items).
- **Verdict**: CHALLENGE — re-format the Sequencing table so each
  row's iter-range matches its own LOC/iter estimate, e.g.
  "iter-128..133 (4-8 iter): M2.c assembly" rather than the
  single-line "128: M2.c". Without this, every downstream consumer
  of STRATEGY reads an over-optimistic timeline.

### Route: Soundness rule "no new axioms" vs. TO_USER.md named-axiom option

- **Goal-alignment**: PASS — STRATEGY correctly observes the plan
  agent cannot propose named axioms (standing rule), while the user
  retains authority via TO_USER.md. This is internally consistent.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND

### Route: M3 user-escalation outstanding

- **Goal-alignment**: PASS — strategy correctly recognises both
  routes exceed 5000-LOC hard fallback threshold, escalation is
  triggered, three smallest extractable PR pieces identified.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: Route A — Hilbert representability,
  Quot representability, identity-component subgroup scheme (all
  flagged as multi-thousand-LOC contribution candidates). Route B —
  symmetric powers of schemes, Stein factorisation, Brill-Noether-RR.
- **Effort honesty**: reasonable (per iter-123 audit, ~6500 / ~9000
  LOC midpoints).
- **Verdict**: SOUND (pending user decision on TO_USER.md)

## Alternative routes (suggested)

### Alternative: Prove M2.a rigidity directly over k, drop M2.c

- **What it looks like**: STRATEGY chases the blueprint's choice
  (`Jacobian.tex` C.2.f) of proving rigidity over kbar and descending
  via Galois descent of morphism equality (M2.c). But the cotangent-
  triviality argument for an abelian variety is local: at the
  identity, Ω_{A/k} has a global frame from left-invariant forms
  (the cotangent module of the Lie algebra). This holds over any
  field, not just algebraically closed. Therefore the same C.2.d
  argument runs verbatim over k (where C ≅ ℙ¹_k already, by
  Brauer-Severi + k-rational point), and M2.c (Galois descent of
  morphism equality of schemes — currently 4-8 iter / 300-500 LOC)
  becomes unnecessary for the C(k) ≠ ∅ branch.
- **Why it might be cheaper or sounder**: Saves the entire M2.c
  build (4-8 iter / 300-500 LOC). Trades a Mathlib-gap-fill (Galois
  descent of scheme morphism equality) for nothing — the underlying
  M2.a body cost is unchanged because the cotangent-vanishing pile
  is needed either way. Also cleaner: avoids the "prove a kbar
  statement then descend" step that adds a faithfully-flat-descent
  layer the project doesn't otherwise touch.
- **What the current strategy may have rejected**: STRATEGY does not
  discuss this. The blueprint C.2.f frames descent as the natural
  route, possibly because it wanted to factor the kbar-side
  conclusion through the geom-irreducible base change C_kbar → ℙ¹_kbar
  (which is only available over kbar, since over k the genus-0
  identification fails for C(k) = ∅). But the C(k) = ∅ branch is
  handled by vacuity in M2.b (no marked points, IsAlbanese vacuously
  true) and never needs rigidity at all — so the descent step is
  serving no necessary purpose in the project's overall structure.
- **Severity of the omission**: major — the strategy commits to 4-8
  iter / 300-500 LOC of work it may not need. A plan-phase
  conversation with the blueprint author (mathematician) should
  resolve this; if the over-k argument works, the savings are real.

### Alternative: Excise the M1 bridge declaration entirely (rather than park)

- **What it looks like**: The M1 bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  was introduced iter-121 as glue between presheaf-side and
  algebra-Kähler-side. The downstream consumer of the FORWARD direction
  is `smooth_locally_free_omega` — which STRATEGY says was closed
  iter-120 in algebra-Kähler form **without** the bridge. If no
  downstream project consumer uses the bridge declaration, delete
  the bridge declaration outright. The Differentials.lean:282 sorry
  vanishes. The Mathlib-contribution candidate
  `KaehlerDifferential.equivOfFormallyUnramified` (M1.d) can still
  be PR'd from off-loop work even without the bridge in-tree.
- **Why it might be cheaper or sounder**: Trades 130-210 LOC of
  M1.b closure work for 0 LOC of bridge-deletion work. Reduces the
  project's terminal sorry count by 1. Cleaner: the bridge was
  introduced speculatively under the iter-121 "Mathlib-contributor"
  pivot but, per STRATEGY's own "M1 is not iff-form elegance"
  paragraph, M1's value is PR-extractability rather than
  project-internal load-bearing. If it's not load-bearing, deletion
  beats parking.
- **What the current strategy may have rejected**: STRATEGY says
  "M1.e (the bridge body assembly) are all closed in body via the
  existing project helpers" but does not address whether any project
  declaration consumes the bridge as an instance/lemma argument. If
  not, parking is silently choosing to ship the dead-weight sorry.
- **Severity of the omission**: major — the strategy spends an
  entire roadmap milestone (M1) on a declaration that may have zero
  in-tree consumers.

### Alternative: Convert M1.b's bijectivity sorry to a project-level named axiom (under explicit user permission)

- **What it looks like**: If excision (above) is rejected because
  some downstream consumer DOES use the bridge, the honest fallback
  is to convert `Function.Bijective ⇑forwardAlg` to a project-level
  `axiom` (named, blueprint-cited, fenced) with a tracking issue.
  Project then reports as "complete relative to one explicit Mathlib-
  gap axiom" rather than "complete with one indefinitely-deferred
  sorry."
- **Why it might be cheaper or sounder**: Sound: zero work. Cheaper:
  saves the 130-210 LOC closure. Honest end-state: the project's
  Mathlib-gap surface area is named, not hidden in a "parked"
  status.
- **What the current strategy may have rejected**: STRATEGY's
  Soundness rule "No new axioms" forbids the plan agent from
  proposing this, and explicitly subordinates the iter-121 user
  pivot directive to the plan-agent standing rule. But this is the
  user's call, not the plan agent's; STRATEGY should surface this
  to TO_USER.md as a third option (alongside PR-and-wait and the
  named-axiom for M3) for the M1 sorry specifically.
- **Severity of the omission**: minor — this is a fallback if
  Alternative B is rejected; it doesn't itself argue against the
  current plan, only argues for surfacing the option to the user.

## Sunk-cost flags

- "`M1.b helper appLE_isLocalization body retains the residual ... sorry
  at L398 (Steps 0+1+4+commutes' closed iter-122/iter-123/iter-124).
  Parked from iter-125 per the M2.a pivot; ... [M1] is parked because
  the M2.a critical-path work has been deferred ≥3 iters by M1.b
  churn`" — Why this is sunk-cost: the framing is "we put in 3 iters
  on M1.b, the remaining work has a concrete recipe, so we'll park
  it (rather than finish or abandon) and hope it un-parks later."
  Recommendation: decide on M1's merits today — either close in
  iter-126 (1-2 iter remaining per the prover's own estimate), or
  excise the bridge declaration (Alternative B), or escalate to user
  as a named-axiom candidate (Alternative C). "Parked indefinitely"
  is the worst of all worlds.

- "`The estimated cost to finish (if un-parked): 1-2 iter / 130-210
  LOC`" — Why this is sunk-cost-adjacent: a 1-2 iter remaining cost
  is well within iter-loop reach. The strategy doesn't argue that
  M1 is too expensive to close; it argues M2.a is more urgent. But
  M2.a has 10-20 iter of phantom-Mathlib gate (C.2.d) ahead of it
  before it closes, so the "urgency" framing doesn't survive a
  closer look — M1 will finish faster than M2.a will. Recommendation:
  reconsider M1's iter-126 priority given that the project's actual
  unblocking is on the C.2.d Mathlib pile, not on M2.a-the-named-
  declaration.

## Prerequisite verification

- `AlgebraicGeometry.ext_of_isDominant`: VERIFIED (exists,
  `Mathlib.AlgebraicGeometry.Morphisms.Separated`). STRATEGY does
  not cite this by name as the M2.a refactor target's downstream
  primitive; if `Scheme.Over.ext_of_eqOnOpen` is the right wrapper
  shape, the refactor is sound and the ~25 LOC estimate plausible.
  (Honesty improvement: cite `ext_of_isDominant` in STRATEGY § M2.a
  to anchor the refactor on existing Mathlib.)
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`: VERIFIED
  (cited by STRATEGY § M1.b, marked `[verified]`).
- `IsLocalization.of_le`: VERIFIED (marked `[verified]`).
- `KaehlerDifferential.exact_mapBaseChange_map`: VERIFIED.
- `KaehlerDifferential.map_surjective`: VERIFIED.
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED.
- `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` (C.2.g):
  MISSING — confirmed PHANTOM by my own spot-check (no result for
  "morphism from projective line to abelian variety is constant"
  in Mathlib b80f227).
- `AbelianVariety.cotangent_trivial` / `GroupScheme.Omega_trivial`
  (M2.d-alt input): MISSING — confirmed PHANTOM by my own spot-check
  ("cotangent sheaf of abelian variety is trivial" returned
  unrelated Ideal/H1Cotangent results).
- `geomIrred.exists_kalg_pt` (M2.c.aux): per STRATEGY's record of
  iter-124 spot-check, PHANTOM. Not re-verified this iter.
- `AlgebraicGeometry.IsLocalAtTarget.descendsAlong`,
  `RingHom.FaithfullyFlat.codescendsAlong_surjective`,
  `AlgebraicGeometry.Spec.map_inj`: per STRATEGY's record of
  iter-124 spot-check, VERIFIED.

## Must-fix-this-iter

- Route end-state-vs-M1-park: CHALLENGE — STRATEGY's "zero inline
  sorry" end-state contradicts "M1 parked, may un-park via soft
  triggers." Either (a) un-park M1 with a hard iter-126 trigger,
  (b) excise the M1 bridge declaration (Alternative B), or
  (c) escalate to TO_USER.md as a named-axiom candidate
  (Alternative C). Status quo is sunk-cost soft-deferral dressed as
  parking.

- Route M2.a iter-125→126 sequencing: CHALLENGE — Sequencing table
  must accurately reflect that iter-126's M2.a deliverable is "a
  scaffolded named declaration whose body reduces to one named
  sorry on the C.2.d phantom" rather than "C.2.b + C.2.c in body
  with C.2.d residual." The current phrasing makes M2.a sound
  close to closure when it actually has the full M2.d-alt pile
  (10-20 iter / 800-1500 LOC of Mathlib build) ahead of it.

- Route C.2.d / M2.d-alt double-counting: CHALLENGE — collapse
  C.2.d (the input to M2.a body closure) and M2.d-alt (the
  alternative to RR for the genus-0 identification) into a single
  shared "cotangent-vanishing Mathlib pile" item. Both depend on
  the same prerequisites; cost should be counted once, with both
  M2.a and M2.d-alt depending on it.

- Route multi-month-wait-window table: CHALLENGE — re-format so
  each row's iter-range matches its own LOC/iter estimate. M2.c
  shown as iter-128 but its own estimate is 4-8 iter. M2.c.aux and
  M2.d-alt are stuffed under "130+" but their estimates are 3-5
  and 10-20 iter respectively. Honest re-format puts M2 closure
  in iter-145 to iter-160, not iter-130+.

- Alternative "Prove M2.a rigidity directly over k, drop M2.c":
  major — STRATEGY commits to 4-8 iter / 300-500 LOC of M2.c
  Galois-descent work that may be unnecessary if rigidity proves
  directly over k. Planner should resolve with the mathematician
  whether the cotangent-vanishing argument requires algebraically
  closed base or just a field. If a field suffices, drop M2.c.

- Alternative "Excise the M1 bridge declaration entirely": major —
  STRATEGY parks M1 without addressing whether the bridge has any
  in-tree consumer. If not, deletion beats parking and the project's
  sorry count drops by 1 free. Planner must audit consumers of
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE` before
  defending the park.

- Phantom prerequisite `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`:
  confirmed PHANTOM by independent spot-check this iter. Gating cost
  must be folded into M2.a's row in Sequencing.

- Phantom prerequisite `AbelianVariety.cotangent_trivial`: confirmed
  PHANTOM by independent spot-check this iter. Gating cost must be
  folded into the shared "cotangent-vanishing pile" item proposed
  above.

## Overall verdict

The strategy under review is **substantively right on the math** —
the M2.a refactor + M2.b vacuous-or-rigidity-via-base-change, the
M3 route-pick audit conclusion, and the prior critique resolutions
(M2 phantom spot-checks, M3 escalation, sequencing wait-window
introduction) are all on the right track. **But the strategy
remains dishonest on three load-bearing points**: the M1 "parked,
may un-park" framing silently defers a sorry the end-state forbids;
the iter-126 M2.a deliverable is over-sold as near-closure when it
actually scaffolds-with-one-named-sorry on a 10-20 iter Mathlib
pile; and the per-iter Sequencing table understates the iter-range
of multi-iter rows so that the timeline reads ~iter-130 when honest
reading puts M2 closure in iter-145+. Two material alternatives —
proving M2.a rigidity directly over k (saving M2.c entirely) and
excising the M1 bridge declaration outright (saving 130-210 LOC of
parked-work) — are not considered and could each free meaningful
iters. A fresh mathematician would not approve the strategy as-is;
4 CHALLENGE verdicts (5 if you separate the per-Route challenges
from the per-Alternative ones) are must-fix before this iter's plan
commits.

iter125: CHALLENGE — 6 routes audited, 4 CHALLENGE + 2 SOUND verdicts (plus 2 major alternatives the strategy omits)
