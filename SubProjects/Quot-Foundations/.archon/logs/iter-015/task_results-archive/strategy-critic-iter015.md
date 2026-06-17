# Strategy Critic Report

## Slug
iter015

## Iteration
015

## Routes audited

### Route: FBC (flat base change of the i=0 pushforward)

- **Goal-alignment**: PASS — closing `affineBaseChange_pushforward_iso` + `flatBaseChange_pushforward_isIso` is exactly two of the seed nodes.
- **Mathematical soundness**: PASS — the seam decomposition (conjugate-unit calculus, Seam 1 closed) is a sound route to "the canonical map is iso"; `unit_conjugateEquiv_symm` verified present and is the correct idiom.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the merge-back-necessity / ∃-iso check is deferred behind a "revisit only if Seam 2/3 stall ≥2 iters" gate. See below.
- **Phantom prerequisites**: none — `unit_conjugateEquiv_symm`, `Module.Flat.ker_lTensor_eq` both VERIFIED.
- **Effort honesty**: reasonable — FBC-A 1–2 iters is mildly optimistic given Seam 2 is a pseudofunctor reindex, but "all proved mod Seam 3" makes it plausible.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

The strategy still carries, under `## Open strategic questions`, the FBC "merge-back necessity"
contingency: *does the parent consume `lem:affine_base_change_pushforward` as "the canonical map is
iso" (⟹ Seams 2–3 unavoidable) or as "∃ natural iso" (⟹ seams vanish, use `regroupEquiv`)?* — with
the instruction "Only revisit if Seam 2/3 stall ≥2 iters."

This framing is **internally inconsistent with the project's own seed statement.** The actual stub is

```
theorem affineBaseChange_pushforward_iso (h : IsPullback g' f' f g) [IsAffineHom f] … :
    IsIso (pushforwardBaseChangeMap f g f' g' h.w F)
```

i.e. it already fixes **the canonical map** `pushforwardBaseChangeMap` and asserts it `IsIso` — not
`∃ iso`. Given that, and given the goal's own constraint that signatures match the parent so the work
merges back, the open question is effectively already answered in one of two ways, neither of which is
"defer behind a stall gate":

1. If this seed signature matches the parent (the strategy asserts it does), the answer is
   canonical-map-iso ⟹ **Seams 2–3 are unavoidable**. Then the "open question" is moot and should be
   *closed/removed* from STRATEGY.md, not left dangling.
2. If the planner believes ∃-iso truly suffices for the parent, that is a **re-signing of the seed
   theorem** (`IsIso (canonical map)` → `∃ iso …`), which materially changes merge-back. That
   decision must be verified against the parent's frozen statement **now** — it is a ~0-iter read of a
   single signature — because it gates the entire Seam 2 (generic-pullback-square pseudofunctor
   reindex) + Seam 3 effort. Sequencing a zero-cost check *after* sinking ≥2 iters into the expensive
   route it might obviate is backwards.

Either way the "revisit if stall ≥2 iters" gate is the wrong instrument. The planner must (a) resolve
the question now by reading the parent's statement of `lem:affine_base_change_pushforward`, then (b)
either delete the open question (route confirmed, seams proceed) or record the re-sign decision — not
keep it as a live contingency.

### Route: GF (generic flatness)

- **Verdict**: SOUND

The algebraic-core decomposition (`gf_generic_rank_ses` + `gf_torsion_reindex` over the shared
single-variable Nagata-elimination engine, `Nat.strong_induction_on d` generalizing the **base
domain** so the IH typechecks at base `A_g`) is the standard Nitsure §4 induction, correctly
identifying the base-ring-changes-under-reindex subtlety. Estimates and parallel-with-QUOT framing are
honest.

### Route: QUOT (Hilbert polynomial, Quot functor, Grassmannian, representability)

- **Goal-alignment**: PARTIAL — the encoding chosen in STRATEGY.md (graded Hilbert function)
  contradicts the documented semantics of the seed stub it must fill (cohomological χ). See below.
- **Mathematical soundness**: PARTIAL — the rationality decomposition is sound, but the S1 "pinning"
  prose contains an internal contradiction about H¹.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the QCoh→localization bridge is genuinely off the closure
  path — the only consumer is QUOT-repr's universal-property support check, and that is correctly
  identified; the deferral is defensible).
- **Phantom prerequisites**: none — `Polynomial.existsUnique_hilbertPoly` (with `[CharZero]`),
  `Submodule.FG.restrictScalars_of_surjective`, `Functor.representableByEquiv`, the
  `HomogeneousSubmodule`/`QuotSMulTop` scaffold all VERIFIED.
- **Effort honesty**: reasonable — SNAP-S2 (G1–G5) 2–4 iters is slightly optimistic for from-scratch
  graded-quotient-ring grading (G3 is real new theory) but the analogy supplies verified anchors and a
  build order; QUOT-repr's wide 6–12 / ~400–1000+ range honestly reflects uncertainty, and the repr
  theorem only requires `∃ Y, Nonempty (RepresentableBy Y)` (not projective/proper/Plücker, which are
  punted to refinement), so the obligation is lighter than the docstring's prose suggests.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

The prior QUOT challenge's three substantive parts are **addressed**: (a) the rationality
decomposition (power-series `IsRatHilb` engine DONE + G1–G5 graded API + D5 degreewise rank-nullity)
is the right shape — the `quot-graded-module-api` analysis correctly shows D5 avoids graded objects but
G1–G4 remain required to feed the IH, with a sound build order; (b) `def:sectionGradedRing` (the S1
bridge) is now a budgeted phase row (`SNAP-S1/S3`, NEXT, 3–6 iters) rather than an unscheduled
blocker; (c) the `[Module.Finite κ (𝒜 1)]` question is minor and correctly flagged (it does follow
from "f.g. κ-algebra + degree-1-generated": homogeneous degree-1 algebra generators κ-span 𝒜₁).

But two **new** concerns surface on a fresh read:

1. **Encoding mismatch between STRATEGY.md and the seed stub.** STRATEGY.md commits to the *graded
   Hilbert function* encoding (no cohomological χ, routed through graded Hilbert–Serre +
   `existsUnique_hilbertPoly`). The actual `hilbertPolynomial` stub's docstring documents the
   *cohomological* encoding verbatim: `Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗m}) = Σ_i (-1)^i dim H^i`
   and "the body unfolds to the graded-Euler-characteristic construction once χ … + Snapper". The
   signature (`Polynomial ℚ` keyed by `s`) is encoding-agnostic so the graded route is *implementable*,
   but the documented intent of the artifact the project must fill directly contradicts the plan. The
   planner must reconcile: update the stub docstring + blueprint to the graded encoding, and confirm
   the parent cone's downstream consumers (flattening stratification / Quot) accept a
   graded-Hilbert-function-defined `hilbertPolynomial` rather than a χ-defined one — otherwise the
   "merges back" goal is at risk at exactly this node.

2. **Internal H¹ inconsistency in the S1 pinning prose.** STRATEGY.md justifies pinning to
   `M := im(Sᴺ → ⊕ₘΓ(F_s⊗L_s^m))` with: "*dim_κ M_m = dim_κ Γ(F_s⊗L_s^m) for m≫0, pinning to M is
   legitimate and keeps the leg Čech-independent (no H¹ re-enters)*", while in the same paragraph
   conceding the polynomial agrees with χ "*for m≫0 by Serre vanishing*". These cannot both stand:
   `M_m ⊆ Γ(F⊗L^m)` always, and equality in high degree is *exactly* surjectivity
   `H⁰(Sᴺ)_m ↠ Γ(F⊗L^m)`, whose cokernel is the H¹ of the presentation kernel — i.e. Serre vanishing.
   The same fact is also what makes Φ_s presentation-independent (well-defined). So the equality is a
   genuine cohomological input, not a free fact, and "no H¹ re-enters" is false *as stated*.

   Mitigation (why this is CHALLENGE, not REJECT): no **theorem** in the 29-node closure actually
   requires `M_m = Γ`. The only representability theorem is `Grassmannian.representable`, which is the
   `X = S` (relative-dimension-0) case where no higher cohomology arises and the graded Hilbert
   function is trivially the constant `d`. So the closure *can* be completed Čech-free with
   `hilbertPolynomial` defined as the eventual polynomial of a chosen presentation's `M`. But then the
   strategy must (i) **drop** "dim M_m = dim Γ for m≫0" as a load-bearing soundness claim (it is not
   needed for any closure sorry and is not H¹-free), and (ii) acknowledge that the resulting def is
   "the Hilbert polynomial of the chosen presentation," whose presentation-independence / agreement
   with χ is an unformalized side-remark — which loops straight back to concern (1) about whether the
   parent accepts that weaker def.

## Format compliance

- **Size**: 182 lines / ~14 KB — lines within budget; bytes marginally over the ~12 KB guide.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — specific-iteration references in prose and table cells:
  e.g. "Seam 1 (`unit_value`) CLOSED iter-014", "gf_torsion_reindex CLOSED iter-014 (+5 transport
  helpers)", "Decision (iter-014): take the STRENGTHEN route", "reaffirmed iter-014", "Seam 1 closed
  iter-014 via the canonical route". These belong in `iter/iter-NNN/plan.md`; in STRATEGY.md they
  should read as state ("Seam 1 CLOSED") without the iter tag.
- **Accumulation detected**: no — completed work is in the `## Completed` table (4 rows, within
  bound); no excised routes linger.
- **Table discipline**: FAIL (minor) — several `Risks` cells in `## Phases & estimations` are
  multi-sentence paragraphs (FBC-A and GF-alg especially), not "one short line per cell".
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Route FBC: CHALLENGE — resolve the ∃-iso-vs-canonical-map question **now** by reading the parent's
  frozen statement of `lem:affine_base_change_pushforward` (the project's own seed is already
  `IsIso (pushforwardBaseChangeMap …)`). Then either delete the open question (seams confirmed
  unavoidable, proceed) or record an explicit re-sign decision. Do not leave it gated on "stall ≥2
  iters".
- Route QUOT: CHALLENGE — reconcile the STRATEGY.md graded-Hilbert-function encoding with the
  `hilbertPolynomial` stub's documented χ encoding (update docstring + blueprint, confirm parent
  accepts the graded def); and fix the S1 prose so it does not simultaneously claim "dim M_m = dim Γ
  for m≫0" and "no H¹ re-enters" — drop the equality as a load-bearing claim or schedule the
  cohomological input it actually requires.
- Format: DRIFTED — scrub per-iter `iter-014` tags from prose/table cells and shorten the overlong
  `Risks` cells (move detail to `iter/iter-NNN/plan.md`). Not blocking on its own, but address in the
  in-place edit.

## Overall verdict

GF is SOUND and well-decomposed. FBC and QUOT are mathematically viable routes built on verified
Mathlib infrastructure (all five load-bearing names checked present), but each carries a live
CHALLENGE the planner must address this iter. For FBC: the "merge-back necessity / ∃-iso escape" is
*not* a contingency to defer — the project's own seed theorem already states `IsIso` of the canonical
map, so the question is either moot (close it) or a re-sign that must be verified against the parent
now, since the cheap check gates the expensive Seam 2/3 work. For QUOT: the strategy's graded-Hilbert-
function encoding contradicts the seed stub's documented cohomological-χ semantics, and the S1 pinning
prose is internally inconsistent — it claims "no H¹ re-enters" while relying on `dim M_m = dim Γ` for
m≫0, which *is* the Serre-vanishing/H¹ input (also needed for well-definedness). No closure theorem
forces that equality (the only representability target is the X=S Grassmannian case), so QUOT remains
closable Čech-free, but the planner must drop the equality as a load-bearing claim and reconcile the
encoding with the parent so the work actually merges back. Format is DRIFTED (per-iter narrative in
prose/cells, overlong Risks cells) — fix in-place alongside the two CHALLENGE edits.
