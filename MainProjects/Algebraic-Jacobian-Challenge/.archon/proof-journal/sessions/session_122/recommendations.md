# Recommendations for the next plan-agent iteration (iter-123)

## CRITICAL — must be acted on this iter

### CRITICAL #1 — Continue M1.b: iter-123 prover lane on `appLE_isLocalization` (Steps 1–4)

**Target**: `AlgebraicJacobian/Differentials.lean:282` `appLE_isLocalization`
body (residual `sorry` at L304).

**Status**: Step 0 of the 4-step `IsLocalization.of_le` chain is
closed this iter (`isUnit_appLE_unitSubmonoid_in_colim`, L164, ~70 LOC).
Steps 1–4 remain. The plan-agent's iter-122 PROGRESS.md framed
PARTIAL as expected; the structural-advance criterion fires (Step 0
closed + 3 of 4 sorry sites eliminated + bridge body L145 closed
modulo M1.b), so this is the canonical CONVERGING route.

**Recommended action**: dispatch a prover on `Differentials.lean` with
PROGRESS.md objectives targeting Steps 1–4 in order. The remaining
~100–250 LOC decomposes:

- **Step 1 (~30–60 LOC)**: build the universal map
  `Localization (appLE_unitSubmonoid f hU hV e) → A_colim` via
  `IsLocalization.lift (appLE_colimRingHom f e).hom` using
  `isUnit_appLE_unitSubmonoid_in_colim` as the
  unit-of-image hypothesis (the `IsLocalization.lift` signature is
  `(g : M → S₁) (hg : ∀ y, IsUnit (g y)) : S → S₁`; the Step 0
  helper feeds the `hg` slot directly).

- **Step 2 (~50–120 LOC, hardest)**: build the reverse map
  `A_colim → A_M` via the cocone universal property of the
  pullback presheaf's `Lan` construction. Strategy: each
  `Γ(S, W) → A_M` for `f V ⊆ W ⊆ U` factors through some
  `Γ(S, D(g)) = (Γ(S, U))_g` via quasi-compactness of `f V` + a
  basic-open cover; the universal arrow then assembles via
  `IsColimit.desc`. This is the only step that needs scheme-theoretic
  cofinality reasoning; the rest is pure ring-theory.

- **Step 3 (~10–30 LOC)**: composite-identity verification via
  `IsLocalization.ringHom_ext` (`Mathlib.RingTheory.Localization.Defs`)
  + `IsColimit.hom_ext` on the colimit cocone. The
  `appLE_colimRingHom_comp_φV` factorisation theorem (L116, fully
  proved) is the right input here — both composites land as
  `Scheme.Hom.appLE` after applying the factorisation, so the
  `ringHom_ext` reduces to a single arrow check.

- **Step 4 (~5–10 LOC)**: package the resulting
  `Localization M ≃ₐ[Γ(S, U)] A_colim` via
  `IsLocalization.isLocalization_of_algEquiv` (or `IsLocalization.of_le`
  per the analogist's recommendation).

**Reusable inputs from iter-122**:
- `isUnit_appLE_unitSubmonoid_in_colim` (L164, fully proved) — Step 1 input.
- `appLE_colimRingHom_comp_φV` (L116, fully proved) — Step 3 input.
- `appLE_colimRingHom` (L97), `appLE_colimAlgebra` (L106) — Step 1/2 algebra.

**Effort estimate**: 1 prover iter, 100–250 LOC.

**Risk profile**: Step 2 is the only step with genuine novelty. If
Step 2 alone takes >2 prover iters, dispatch `mathlib-analogist`
on the cocone-universal-property usage before continuing — the
project hasn't previously had to do scheme-theoretic `IsColimit.desc`
work, so this is in fresh territory where the analogist's
"BEFORE the design ships" guidance applies.

### CRITICAL #2 — Stale Lean docstring on `smooth_locally_free_omega` (Differentials.lean:436–447)

**Issue**: The docstring of `smooth_locally_free_omega` (lines
436–447) claims the presheaf-form bridge is "**a Mathlib gap** ...
requires presheaf-level cofinality machinery (~200–400 LOC) that
is **out of autonomous-loop scope**." This was true entering iter-121
but is now stale — the bridge is being actively formalized this iter
(`relativeDifferentialsPresheaf_equiv_kaehler_appLE` is in the file,
closed modulo M1.b; the M1 roadmap explicitly puts the bridge **in**
autonomous-loop scope per the iter-121 user pivot directive).

**Why it matters**: future readers of the file (including the next
iter's prover) will be misled by the stale "out of scope" claim. The
review agent cannot edit `.lean` files; the plan agent must dispatch
a refactor.

**Recommended action**: in the iter-123 plan-phase, dispatch a
`refactor` subagent with directive "rewrite the docstring of
`Differentials.lean:431-447` `smooth_locally_free_omega` to reflect
that the bridge is now formalized as
`relativeDifferentialsPresheaf_equiv_kaehler_appLE` (modulo M1.b).
Update the cross-reference: point at
`relativeDifferentialsPresheaf_equiv_kaehler_appLE` directly, and
note that M1.b is the open work item. Do NOT touch the theorem
signature; this is purely a docstring fix." Tiny refactor; should
complete in 1 attempt.

**Effort estimate**: 0.1 prover-equivalent iter (single Edit; should
complete in 1 attempt).

## HIGH — should be acted on this iter or next

### HIGH #3 — Consider extracting the M1 contribution candidate to Mathlib

**Target**: `AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso`
(L330, fully proved this iter; ~25 LOC).

**Why**: this is the Mathlib contribution candidate identified by
the iter-121 mathlib-analogist as "the most extractable from M1"
(candidate name `KaehlerDifferential.equivOfFormallyUnramified`,
candidate home `Mathlib.RingTheory.Kaehler.Basic`). The lemma is
ring-theoretic (no scheme-theoretic dependencies); it's a clean
generalisation of `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`
to the "only the lower step is formally unramified" case.

The proof is short, the Mathlib closure pieces are already used
(`KaehlerDifferential.exact_mapBaseChange_map`, `map_surjective`,
`LinearEquiv.ofBijective`); the only project-side input is
`kaehler_localization_subsingleton`, itself a 2-line composition.

**Recommended action**: NOT this iter (M1.b is on the critical path
and should land first). After iter-123 closes M1.b, the iter-124
plan phase can dispatch a follow-up to draft a Mathlib PR. Catalog
this in `analogies/relative-differentials-presheaf-bridge.md` for
future reference.

### HIGH #4 — Re-dispatch `lean-vs-blueprint-checker` on Differentials this iter (review-phase scope, this iter's responsibility — done implicitly via this recommendation; flag for iter-123 plan)

The blueprint's M1.b proof prose (`Differentials.tex § sec:bridge`,
Lemma `lem:appLE_isLocalization`) describes a 4-step
`IsLocalization.of_le` proof that has been faithfully implemented in
Lean modulo Step 0 (which is broken out as a separate helper lemma
`isUnit_appLE_unitSubmonoid_in_colim` instead of inlined as in the
blueprint's "first observe that each `g ∈ M`..." sub-paragraph).
This is a documentation drift opportunity — the blueprint could be
updated to mention the helper lemma explicitly, since the helper is
reusable and named.

**Recommended action**: dispatch `blueprint-writer-differentials-iter123`
in plan phase with directive "add a `\lean{...AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim}`
sub-block before `lem:appLE_isLocalization` documenting the Step 0
helper that's now factored out (single statement, no proof body
needed beyond a paragraph reference to the bullet (a)+(d) of the
existing M1.b proof prose)." Tiny edit; ~10 LOC of LaTeX.

## MEDIUM — should be acted on within 2-3 iters

### MEDIUM #5 — Document the "rw [Functor.map_comp] needs erw on Lan-defined functors" workaround

The Knowledge Base in `PROJECT_STATUS.md` has entries about cofinality
framing and `FormallyUnramified.of_isLocalization`; it does NOT yet
have entries about the four technical lessons surfaced this iter
(see `summary.md § Key findings`):

1. `rw [Functor.map_comp]` fails on `((TopCat.Presheaf.pullback _ _).obj _).map (f ≫ g)`; workaround pre-prove + `erw`.
2. `rw [Category.assoc]` similarly fails; workaround `exact Category.assoc _ _ _`.
3. `change`/`show` on `algebraMap` doesn't unify; route via `IsUnit` + `exact`.
4. `adj.unit.naturality` emits `((𝟭 _).obj _)` terms; use `simpa`.

These will be added to the Knowledge Base by the review agent (this
review). The plan agent should be aware that these patterns will
recur in iter-123 Step 2 (cocone universal property work) and may
need to be invoked again.

### MEDIUM #6 — Step 2 of `appLE_isLocalization` may benefit from a tactical helper

The iter-122 PROGRESS.md noted Step 2 is the hardest of the four
remaining steps because it requires scheme-theoretic cofinality
reasoning. If the iter-123 prover hits the same kind of
`((pullback _ _).obj S.presheaf).map` rewrite blockers as iter-122,
consider asking the refactor subagent to extract a Step-2 helper
lemma `colim_descend_via_basic_open_refinement` (or similar) BEFORE
the prover lane, mirroring the iter-122 approach of breaking out
`appLE_colimRingHom` and `isUnit_appLE_unitSubmonoid_in_colim` as
top-level lemmas. The principle: helper lemmas with explicit
`Functor.map_comp`-friendly signatures avoid the rewriter pitfalls
that bloated the iter-122 Step 0 work to ~15 attempts on substep (c).

**Recommended action**: discretionary — let the iter-123 prover try
Step 2 directly first; only dispatch the helper-extraction refactor
if Step 2 stalls.

## LOW — informational / notes

### LOW #7 — Iter-122 was the most productive single iter on M1 so far

In one iter, the project went from "M1 scaffolding exists but is
all sorry-stubs (4 sorry sites + 1 black-box hypothesis)" to "M1
infrastructure 90% complete (Step 0 closed + bridge body closed +
all algebra/module/tower instances closed + factorisation theorem
proved); only Steps 1–4 of `IsLocalization.of_le` remain". Both
the deep-prover subagent and the main prover stream contributed
substantively. Net LOC added: ~200 of fully-proved declarations
(top-level: `appLE_colimRingHom`, `appLE_colimAlgebra`,
`appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`,
`kaehler_localization_subsingleton`,
`kaehler_quotient_localization_iso`,
`relativeDifferentialsPresheaf_equiv_kaehler_appLE`).

### LOW #8 — No CHURNING or STUCK signals; CONVERGING is the right verdict

5 prover-iter window on Differentials.lean:
- iter-118: PARTIAL (algebra-Kähler refactor + Steps 1–4 of bridge);
- iter-119: PARTIAL (Steps 1–5 of bridge);
- iter-120: COMPLETE (smooth_locally_free_omega closure);
- iter-121: no prover dispatch (strategic pivot);
- iter-122: PARTIAL (M1 scaffolding 75% closed; net sorry 1 → 2).

Per the iter-122 progress-critic UNCLEAR verdict from the plan phase,
this iter resolves UNCLEAR → CONVERGING: structural advance is large
(~200 LOC of fully-proved declarations, all 3 non-M1.b sorry sites
closed, M1.b Step 0 closed). The plan agent should NOT pivot routes
or dispatch progress-critic preemptively — iter-123 should continue
the M1.b lane.

### LOW #9 — Helper lemmas pattern is paying off

The iter-122 approach of breaking out `appLE_colimRingHom`,
`appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`,
`isUnit_appLE_unitSubmonoid_in_colim` as top-level named lemmas
(rather than inlining them) made the M1.e bridge body close in one
Edit (rather than needing inline proofs of ~15 LOC inside the
bridge body itself). This mirrors the iter-098 split-slot pattern
(`alternating_sum_pi_smul_aux_sum_comp`) that was successful for
the BasicOpenCech work. Reusable pattern for iter-123 Step 2.

### LOW #10 — Workaround pattern for `algebraMap` non-unification

When `letI : Algebra A B := φ.hom.toAlgebra` is in scope and the
goal uses `algebraMap A B`, neither `change` nor `show` will unify
the goal with a form involving `φ.hom` directly even though they
ARE definitionally equal. Workaround: introduce a `have h_alg :
algebraMap A B g = φ.hom g := rfl` (or via `RingHom.algebraMap_toAlgebra`
when applicable) and `rw [h_alg]`. The `rfl` form works at the
have-level even though `change` fails at the goal-level. Reusable
across the project.

## Off-limits for iter-123 (already-recorded; reaffirmed)

- `AlgebraicJacobian/Jacobian.lean:179` `nonempty_jacobianWitness`
  — the single foundational sorry; queued behind M2 + M3 per the
  genus-stratified body restructure plan. M2.a Rigidity refactor
  scheduled iter-124+ per STRATEGY.md.
- All `Cohomology/*` files (M5-M8 scaffolding) — not active prover
  lanes; iter-121 lean-auditor flagged dead-chain issues exist but
  are not on the M1/M2/M3 active roadmap.
- `Rigidity.lean` — closed; queued for source-side refactor before
  M2.a enters the prover queue iter-124+.

## Suggested iter-123 plan-phase ordering

1. **Plan-phase critic round**: dispatch `strategy-critic-iter123`
   (re-verification — strategy unchanged since iter-121 rewrite;
   pass directive saying so), `blueprint-reviewer-iter123` (whole-blueprint
   audit; HARD GATE confirmation), `progress-critic-iter123` (M1
   route signals: 5 iters of data with this iter's structural
   advance — verdict expected CONVERGING).
2. **Optional refactor**: docstring fix (CRITICAL #2 above) and
   blueprint-writer expansion (HIGH #4 above) — both very small,
   can land in parallel with the prover lane in the same iter.
3. **Prover lane**: PROGRESS.md targets Steps 1–4 of `appLE_isLocalization`
   per CRITICAL #1; expected PARTIAL or COMPLETE depending on Step 2's
   difficulty.
