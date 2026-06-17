# Strategy Critic Report

## Slug
iter023

## Iteration
023

> **Directive/disk mismatch (read first).** The STRATEGY.md pasted into my directive is *stale* — it
> shows GF-alg with "L4 finiteness leaf @754 remains" and no `## Completed` section. The on-disk
> `STRATEGY.md` is newer (GF-alg's L4 closed, a populated `## Completed` table, FBC route-swap text).
> I audited the **on-disk** version, since that is the authoritative current strategy. One consequence:
> the directive's framing — "GF-alg has just completed (genericFlatnessAlgebraic axiom-clean), so I am
> moving it to ## Completed" — is **not yet reflected on disk**, where GF-alg is still `ACTIVE` with a
> live residual `@2021`. The planner must reconcile (see GF route).

## Routes audited

### Route: FBC

- **Goal-alignment**: PASS — affine lemma on global sections + Čech-free globalization yields
  `IsIso (pushforwardBaseChangeMap)`, the FBC goal.
- **Mathematical soundness**: PASS — tilde-dictionary rewrite → `regroupEquiv` (closed) plus the
  H⁰-equalizer/flat-preservation globalization is a standard, correct decomposition; the residual
  `gstar_transpose` counit coherence is genuine remaining content, not a gap dressed as done.
- **Sunk-cost reasoning detected**: no (borderline) — the FBC-A phase has *elapsed 8+ iters against a
  2–3 scoped* (a real overrun, and the strategy states it honestly), but the iter-020 route-swap
  closed 2 of 3 seams (`domain_read`, `codomain_read` axiom-clean), leaving exactly 1 live sorry
  (`gstar`). That is a measurable reduction in open obligations, not pure momentum. Continuing is
  defensible.
- **Infrastructure-deferral detected**: yes — two items. (1) The strategy's own tripwire ("FBC
  merge-back necessity ... Only revisit if Seam 2/3 stall ≥2 iters") appears to have **fired**: the
  `gstar` crux has been the live frontier since the iter-020 swap (≈3 iters to iter-023), yet the
  canonical-θ-vs-∃-iso check is still parked as "a residual contingency only." (2) The FBC-A risk cell
  carries "**+2 long-term-deferred (@1724/@1746)**" sorries with no statement of whether they lie in
  the 29-node closure. The goal is "zero project sorry in the 29-node closure"; a sorry that is
  in-closure cannot be "long-term-deferred," and one that is out-of-closure should be named as such.
- **Phantom prerequisites**: none — `conjugateEquiv_counit_symm`, `Module.Flat.ker_lTensor_eq` both
  VERIFIED present.
- **Effort honesty**: reasonable — 1–2 iters for a single sorry with a verbatim-confirmed closing
  lemma is credible.
- **Verdict**: CHALLENGE — close out the self-set tripwire (cheap: read the parent consumer + the
  frozen seed signature, confirm in one line whether `gstar` is unavoidable) and classify @1724/@1746
  against the closure. The core route is sound; these are must-resolve hygiene items, not a rewrite.

### Route: GF

- **Goal-alignment**: PASS — `genericFlatnessAlgebraic` + geometric wrap (`[IsQuasicoherent]`+
  `[IsFiniteType]`, affine-open + finite-cover) = `thm:generic_flatness`.
- **Mathematical soundness**: PASS — Nitsure §4 variable-count induction with base-domain
  generalization, decomposed into `gf_generic_rank_ses` + `gf_torsion_reindex` + the tower descent;
  internally consistent.
- **Infrastructure-deferral detected**: no — the geometric wrapper genuinely depends on the algebraic
  core, which is at/near closure; opening GF-geo next is correct sequencing, not deferral.
- **Phantom prerequisites**: none — `LinearEquiv.extendScalarsOfIsLocalization` VERIFIED present
  (with `_apply`/`_symm_apply`).
- **Effort honesty**: reasonable, with one caveat — GF-geo's "Γ(F,W)-as-finite-module plumbing" can
  expand beyond 40–120 LOC if relating sections over an affine cover to a finite module over the
  finite-type algebra needs more than a thin reduction. Acceptable as a starting estimate.
- **Verdict**: SOUND — but the **doc must be reconciled**: on disk GF-alg is `ACTIVE` with residual
  `@2021`, while the directive declares it complete. If genuinely closed, move it to `## Completed`
  this iter (accumulation discipline) *before* GF-geo is the prerequisite-met frontier; if not,
  GF-geo's precondition is not yet satisfied and it cannot open.

### Route: QUOT

- **Goal-alignment**: PARTIAL — produces all four QUOT objects, but the Hilbert-polynomial encoding
  rests on a finiteness input whose cohomology-free status is asserted, not established (below).
- **Mathematical soundness**: PARTIAL — see the deferral finding. The Route-2 ambient-subquotient
  rationality engine (`gradedModule_hilbertSeries_rational`, S2) is done and sound. The risk is
  entirely in S1's input lemma.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — `lem:sectionGradedModule_fg` (see dedicated finding).
- **Phantom prerequisites**: none — `Polynomial.existsUnique_hilbertPoly`,
  `CategoryTheory.Functor.representableByEquiv` both VERIFIED present.
- **Effort honesty**: reasonable for QUOT-defs/QUOT-repr (repr honestly flagged 6–12 iters /
  400–1000+ LOC), but **SNAP-S1 (3–6 iters) is contingent**: if `lem:sectionGradedModule_fg` cannot
  be proved H¹-free, the lane silently absorbs coherent-cohomology-from-scratch and is grossly
  under-counted.
- **Parallelism under-exploited**: no — the strategy correctly routes P2, SNAP-S1, and
  `def:sectionGradedRing` as independent, Mathlib-only-importing lanes alongside FBC/GF. Good.
- **Verdict**: CHALLENGE — the encoding pivot's entire justification ("keeps QUOT Čech-independent")
  hinges on S1's input being cohomology-free; that claim must be verified before the S1 lane is built.

## Format compliance

- **Size**: 168 lines / 16618 bytes — **over budget** on bytes (16.6 KB vs ~12 KB ceiling); lines OK.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive in prose (not just the Completed ledger cell).
  Representative: `"ROUTE SWAPPED iter-020"`, `"L5 CLOSED iter-017; L4 injectivity CLOSED iter-019;
  L4 finiteness leaf CLOSED iter-021"`, `"Phase elapsed 8+ iters (entered <iter-014)"`,
  `"removal in a dedicated FBC-no-prover refactor, iter-023)"`, `"[verified iter-022]"`,
  `"DONE iter-020, axiom-clean"`. This is iter-by-iter history that belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: yes — the `Risks` and `Key Mathlib needs` cells in `## Phases &
  estimations` have ballooned into multi-sentence, bold-markup paragraphs (the FBC-A and GF-alg risk
  cells each run ~10+ lines of prose). The `## Completed` table is within its row bound (6 rows) and
  is fine.
- **Table discipline**: FAIL — `Status` is a clean tag, but `LOC`/`Key Mathlib needs`/`Risks` cells
  violate "one short line per cell" (prose paragraphs with embedded iter history and `[verified
  iter-022]` annotations).
- **Format verdict**: NON-COMPLIANT — over byte budget + pervasive per-iter narrative + prose-paragraph
  table cells. Restructure in-place this iter: lift the iter-stamped history into the iter sidecar,
  compress each table cell to one line, and the byte count falls back under budget as a side effect.

## Infrastructure-deferral findings

### Deferred: `lem:sectionGradedModule_fg` (finite generation of the graded section module Γ_*(F))

- **Required by goal**: yes — it is the existence input to `existsUnique_hilbertPoly`, hence to
  `def:hilbert_polynomial`, one of the four QUOT goal objects. Without a f.g. graded module the
  Hilbert polynomial does not exist.
- **Current plan for building it**: the strategy asserts it is "**Serre/Hartshorne II.5.17, chapter
  II, before any cohomology**" and that this "never lets H¹ re-enter," keeping QUOT Čech-independent.
  No project-side proof yet; the lane is scoped at SNAP-S1 (3–6 iters).
- **Timeline**: vague — folded into SNAP-S1 with no separate budget for the finiteness step itself.
- **Verdict**: CHALLENGE — the claimed citation is doubtful and the claim is the load-bearing
  justification for the *entire* encoding pivot. The classical proof that the **full** section module
  Γ_*(F) = ⊕_m Γ(X, F(m)) is finitely generated over the homogeneous coordinate ring routes through
  Serre vanishing: from `0 → K → ⊕ O(-d_i) → F → 0`, twisting and taking H⁰ gives surjectivity onto
  Γ(F(m)) only once `H¹(K(m)) = 0` for m≫0 — an H¹ statement. The strategy's escape ("pin
  `M := Γ_*(F)`, so `dim M_m = dim Γ(F(m))` in ALL degrees, no Serre-vanishing comparison") is correct
  *only if* Γ_*(F) is itself f.g., which is exactly the cohomological fact. This is the textbook
  infrastructure-deferral signature: **the pivot from the cohomological-χ encoding to the
  graded-Hilbert-function encoding may have relocated the same coherent-cohomology content
  (Serre finiteness) into `lem:sectionGradedModule_fg`, not eliminated it.** Before the S1 lane is
  built, the planner must either (a) exhibit a genuinely H¹-free proof of Γ_*(F) f.g. and cite the
  *exact* result (verify it is chapter-II, not a III/cohomology result — "II.5.17" looks like a
  misattribution), or (b) adopt the alternative below and reframe "Čech-independent" honestly.

## Alternative routes (suggested)

### Alternative: define Φ_s from a chosen f.g. presentation module, not from Γ_*(F)

- **What it looks like**: every coherent F on Proj S is `M̃` for *some* f.g. graded S-module M (the
  surjectivity half of the M ↦ M̃ correspondence — a chapter-II construction, f.g. *by construction*).
  Apply `gradedModule_hilbertSeries_rational` + `existsUnique_hilbertPoly` to that M to extract Φ_s.
  The agreement `dim M_m = dim Γ(F(m))` for m≫0 stays the already-acknowledged non-load-bearing
  remark.
- **Why it might be cheaper or sounder**: it gets finite generation *for free* (M is f.g. by how it
  is built), sidestepping the doubtful Γ_*(F)-f.g. lemma entirely.
- **What the current strategy may have rejected**: the strategy chose `M = Γ_*(F)` precisely to make
  `dim M_m = dim Γ(F(m))` hold in *all* degrees (definitionally), which a chosen presentation gives
  only for m≫0. **Caveat — this alternative does not fully escape cohomology either**: making Φ_s a
  *well-defined invariant of the sheaf F* (independent of the choice of M) again needs the m≫0
  agreement across presentations, i.e. Serre. So whichever route is taken, the planner should confirm
  whether the parent cone needs Φ as a canonical function of F (Quot stratifies by Hilbert
  polynomial, which suggests yes) — if so, **some** Serre-type input appears genuinely required, and
  the "Čech-independent" label for the QUOT Hilbert-polynomial sublane should be stated with that
  caveat rather than as an unqualified property.
- **Severity of the omission**: major — it does not by itself dissolve the cohomology question, but it
  isolates exactly where the irreducible cohomological content lives, which the current single-route
  framing obscures.

## Sunk-cost flags

- `"Phase elapsed 8+ iters (entered <iter-014); originally scoped 2–3."` (FBC-A) — Not sunk-cost in
  the disqualifying sense (the strategy is honest and the route-swap closed 2/3 seams), but it is the
  reason the merge-back-necessity tripwire must now actually fire rather than stay parked. Recommendation:
  resolve the canonical-θ-vs-∃-iso check this iter on its merits (it is a cheap read of the frozen
  seed + parent consumer), so `gstar` is confirmed necessary rather than assumed.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`).
- `LinearEquiv.extendScalarsOfIsLocalization`: VERIFIED (`Mathlib.RingTheory.Localization.Module`).
- `CategoryTheory.conjugateEquiv_counit_symm`: VERIFIED (`Mathlib.CategoryTheory.Adjunction.Mates`).
- `CategoryTheory.Functor.representableByEquiv`: VERIFIED (`Mathlib.CategoryTheory.Yoneda`).
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib.RingTheory.Flat.Equalizer`).

## Must-fix-this-iter

- Route QUOT: infrastructure-deferral CHALLENGE — `lem:sectionGradedModule_fg` (Γ_*(F) f.g.) is
  required by the goal (existence of `def:hilbert_polynomial`) and its asserted cohomology-free
  proof is doubtful (classical proof uses Serre H¹ vanishing). Either produce/cite an exact H¹-free
  proof (and verify the "Hartshorne II.5.17, chapter II" attribution) or adopt the chosen-presentation
  alternative and state the "Čech-independent" claim for this sublane with the Serre caveat.
- Route FBC: CHALLENGE — the self-set merge-back-necessity tripwire ("revisit if Seam 2/3 stall ≥2
  iters") has fired (`gstar` live ≈3 iters); resolve the canonical-θ-vs-∃-iso check now, and classify
  the two "long-term-deferred" sorries @1724/@1746 against the 29-node closure (in-closure ⟹ they are
  goal-required and cannot be deferred).
- Route GF: reconcile doc with reality — if `genericFlatnessAlgebraic` is closed, MOVE GF-alg to
  `## Completed` (accumulation), which is also the precondition that lets GF-geo legitimately open.
- Format: NON-COMPLIANT — (1) per-iter narrative pervades the table `Risks`/`Key Mathlib needs` cells
  and Routes prose; (2) those cells are prose paragraphs, not one-liners; (3) file is over the ~12 KB
  byte budget. Restructure in-place: push iter-stamped history to `iter/iter-023/plan.md`, compress
  cells to one line each.

## Overall verdict

The strategy is fundamentally well-structured — a clean fan of independent leaves (FBC / GF / QUOT)
with parallelism correctly exploited, honest deep-target estimates, and every load-bearing Mathlib
name I checked verified present. The sequencing the directive proposes is largely sound: continuing
FBC's 3-seam route is justified (the iter-020 swap closed 2 of 3 seams and the closing lemma exists),
and opening GF-geo after the algebraic core is correct dependency order. But two things must be fixed
before the iter commits. First and most important: **the strategy defers `lem:sectionGradedModule_fg`
(finite generation of the section module Γ_*(F)), which is required for the stated goal
(`def:hilbert_polynomial`), and its claimed cohomology-free proof is the load-bearing justification
for the whole encoding pivot — yet the classical proof of that finiteness uses Serre H¹ vanishing.**
If that input is not genuinely H¹-free, the pivot from the cohomological-χ encoding did not escape the
cohomology; it relocated it, and the "Čech-independent" identity for the QUOT Hilbert-polynomial
sublane is overstated. Second, the document is NON-COMPLIANT (per-iter narrative and prose-paragraph
cells push it over the byte budget) and should be restructured in-place this iter. The FBC tripwire
and the GF-alg accumulation/reconciliation are smaller must-do hygiene items.
