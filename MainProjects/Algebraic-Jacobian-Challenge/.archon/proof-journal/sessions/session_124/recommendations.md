# Recommendations for the next plan-agent iteration (iter-125)

## CRITICAL — must be acted on this iter

### CRITICAL #1 — Iter-125 fires the M2.a pivot unconditionally per the iter-124 sharpened commitment

**Action**: drop M1.b from iter-125 prover objectives. Execute the
staged Rigidity refactor as the iter-125 prover lane.

The iter-124 strategy-critic's sharpened commitment + the iter-124
progress-critic watch flag #1 (project sorry count flat at 2 across
iter-122 / iter-123 / iter-124 — the strict 3-iter-flat-count
threshold) both fire. iter-124 returned PARTIAL with real structural
narrowing (`commutes'` closed in body; residual narrowed to named
`Function.Bijective ⇑forwardAlg`) but no full closure. Per the
sharpened commitment, this triggers the unconditional pivot — no
"we are close" continuation.

**Iter-125 prover-lane scope** (staged in `iter/iter-124/plan.md`
§ "Iter-125 Rigidity refactor directive"):

- Refactor target: `AlgebraicJacobian/Rigidity.lean:79`
  `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`.
- Drop 8 unused hypotheses: `{n m : ℕ}`,
  `[SmoothOfRelativeDimension n X.hom]`, `[IsProper X.hom]`,
  `[GrpObj X]`, `[SmoothOfRelativeDimension m Y.hom]`,
  `[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]`.
- Weaken `[IsProper Y.hom]` to `[IsSeparated Y.hom]` (only
  load-bearing target-side hypothesis per the proof body's
  `ext_of_isDominant_of_isSeparated'` call).
- Keep `[GeometricallyIrreducible X.hom]`, `[IsReduced X.left]`.
- Update 2 blueprint cross-refs (`Rigidity.tex`, `Jacobian.tex`
  C.2.g) with `\lean{...}` hints.
- No protected signatures touched (the declaration is not
  protected). No new sorries.
- Estimated cost: 1 iter / ~25 LOC. Persistent rationale:
  `analogies/rigidity-refactor.md`.

The iter-126 prover lane runs M2.a rigidity-over-`k̄` against the
refactored `Scheme.Over.ext_of_eqOnOpen`.

### CRITICAL #2 — TO_USER.md surfaces the M3 named-axiom alternative this iter

**Action**: TO_USER.md has been re-authored this review-phase with
the M3 named-axiom alternative alongside the existing PR-and-wait
option. **This is done — no further iter-125 plan-agent action
required** unless the user responds in `USER_HINTS.md` between iters.

If the user has not responded by the iter-125 plan-phase, continue
on critical-path work (the M2.a pivot per CRITICAL #1). The
named-axiom option REMAINS open at any later iter (the loop does
not auto-add named axioms per the plan-agent standing rule; the
user retains authority over the project direction).

## HIGH — review-subagent findings to act on

### HIGH #3 — Comment-block trim on `Differentials.lean:332-397`

Per `lean-auditor-review124.md` § Major:

The L332-L397 comment block has bloated to ~66 LOC for a single
residual sorry and leaks iter-loop narrative into production Lean
source: "Strategy this iter (iter-124)" (L334), "Mathlib b80f227"
commit-hash citation (L335), "the iter-125+ prover lane would need
to assemble" (L395), "the iter-125 pivot to M2.a fires per the
strategy-critic-iter124 sharpened commitment" (L396-L397). The
content is substantive (the INJECTIVITY/SURJECTIVITY analysis is
genuine; the Mathlib-gap identification is accurate) but the
ephemeral planning-state references do not belong in production
Lean.

**Recommended action**: discretionary. Three options:

1. **Defer to whatever iter eventually closes the bijectivity sorry**.
   At that point the entire L332-L397 block is replaced with the
   actual proof and the iter-loop narrative auto-disappears. Lowest
   cost; recommended unless the M1.b lane resumes in the near term.
2. **Trim the iter-loop narrative inline this iter** (iter-125) as
   a discretionary tail-end refactor after the Rigidity refactor
   lands. ~5-10 LOC of narrative removal; preserves the substantive
   blocker analysis; ~0.1 prover-equivalent iter cost.
3. **Defer indefinitely until a follow-up cleanup pass surfaces
   it via lean-auditor a third time**.

Recommendation: option 1 (defer to bijectivity closure). The
comment is iter-124-specific by virtue of the strategy-critic
references; once iter-125's M2.a pivot fires, the comment's
references to iter-125 become historical, and a future iter that
reopens M1.b will likely rewrite the entire block anyway.

### HIGH #4 — Blueprint chapter M1.b proof-prose realignment for `lem:appLE_isLocalization`

Per `lean-vs-blueprint-checker-differentials-review124.md` § Severity
summary → minor:

The chapter's M1.b proof sketch at L162-188 of `Differentials.tex`
still describes the route as "build backward map abstractly via
cocone universal property + basic-open cover; verify composites are
identities via `IsLocalization.ringHom_ext`". The iter-124 Lean body
now uses a different route: "promote `forward` to `forwardAlg : ...
→ₐ[A] ...` and reduce to `Function.Bijective ⇑forwardAlg` via
`AlgEquiv.ofBijective`". Both routes are mathematically valid; the
chapter prose has drifted from the Lean.

**Recommended action**: discretionary inline blueprint edit for
the iter-125 plan agent. Add 1 paragraph to the M1.b proof prose
(`Differentials.tex` L165-L195) noting:

- The Lean now packages Steps 2 + 3 jointly as bijectivity of
  `forwardAlg` (the AlgHom promotion of `forward = IsLocalization.lift _`).
- The bijectivity decomposes via `IsLocalization.lift_injective_iff`
  (for `→` direction of Step 3) + `IsLocalization.lift_surjective_iff`
  (for Step 2 element representation).
- The two underlying Mathlib gap pieces are (a) filtered-colim
  element representation for `IsPointwiseLeftKanExtensionAt`-defined
  colims of `CommRingCat`, and (b) basic-open cofinality from
  `appLE_unitSubmonoid` to `Opens S`.

Cost: ~15 LOC of blueprint prose. Best landed by the iter-125 plan
agent inline (no blueprint-writer subagent needed; the
mathematical content is fully in
`task_results/AlgebraicJacobian_Differentials.lean.md` and the
review summary, ready to be transcribed).

## MEDIUM — track but do not act on this iter

### MEDIUM #5 — Blueprint dedicated `\begin{lemma}` blocks for inline helpers

Per `lean-vs-blueprint-checker-differentials-review124.md` and the
iter-124 plan.md "Soon item #3" carry-forward:

The five inline-only references (`appLE_unitSubmonoid`,
`isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`,
`appLE_colimRingHom`, `appLE_colimAlgebra`) all have `\lean{...}`
references but no dedicated `\begin{lemma}` / `\begin{definition}`
blocks. The chapter currently treats them as "inline helpers"
inside the parent lemma's proof body.

**Recommended action**: blueprint-writer dispatch for a future iter
(NOT iter-125 — iter-125 is the Rigidity refactor lane). The
iter-126 or iter-127 plan agent should consider dispatching a
blueprint-writer with directive "promote these 5 inline references
to dedicated `\begin{lemma}` / `\begin{definition}` blocks in
`Differentials.tex` so the chapter acts as a proper roadmap".

### MEDIUM #6 — M2-prep phantom-prereq builds scheduled for iter-127+

Per `iter/iter-124/plan.md` § "Watch criteria committed for iter-125"
#7:

The iter-124 plan-phase verified that:
- **M2.c** ("Galois descent of morphism equality of schemes") is
  partially-supported by Mathlib's descent framework
  (`IsLocalAtTarget.descendsAlong`,
  `RingHom.FaithfullyFlat.codescendsAlong_surjective`,
  `Spec.map_injective`). Assembly cost: 4–8 iter / 300–500 LOC.
- **M2.d-alt** ("abelian-variety cotangent triviality") is a
  genuine Mathlib phantom. Build cost: 10–20 iter / 800–1500 LOC.
- **`geomIrred.exists_kalg_pt`** ("base-change-to-`k̄`
  rational-point existence") is a genuine Mathlib phantom. Build
  cost: 3–5 iter / 200–400 LOC.

**Recommended action**: the iter-126 / iter-127 plan agent
(post-M2.a) should schedule these into the iter-127+ horizon as
parallel prover lanes alongside M2.b genus-0 assembly.

## LOW — informational only

### LOW #7 — Iter-122/123 carry-over minor flags unchanged

Per `lean-auditor-review124.md` § Minor:

- `Differentials.lean:239` `erw [hmc]` inside
  `appLE_colimRingHom_comp_φV` is a known brittle spot (iter-123
  carry-over, unchanged this iter). Should be rewritten as a
  deterministic `rw`/`simp only` once the project finds the right
  normal form.
- `Rigidity.lean:62-67` — six unused typeclass hypotheses on
  `GrpObj.eq_of_eqOnOpen`. **This is resolved by the iter-125
  Rigidity refactor** (CRITICAL #1 drops 8 unused hyps including
  these 6; the lean-auditor's minor flag closes after iter-125).
- `MayerVietorisCover.lean:55-60` — three `IsAffineOpen` fields of
  `AffineCoverMVSquare` are unused. Document-only flag; situation
  unchanged from iter-123.
- `MayerVietorisCore.lean:354, 523, 539, 565` — four `set_option
  backward.isDefEq.respectTransparency false in` uses. Workaround
  for Mathlib's iter-2024 isDefEq-fastpath changes; appears
  unavoidable.

### LOW #8 — Iter-124 prover compact attempt count

The iter-124 prover executed 1 substantive Edit + 28 lemma searches
in ~20 minutes, producing a structural narrowing of the residual
without inflating the project sorry count. This is the right shape
for a structural-narrowing iter that exits with a documented
blocker. Carry forward as a positive workflow datum.

## Plan-agent ordering for iter-125

1. **Sequence the Rigidity refactor first** (CRITICAL #1) — this is
   the staged execution lane for iter-125.
2. **Optionally fold in HIGH #4** (blueprint prose realignment for
   M1.b) as an inline plan-phase edit, ~15 LOC of blueprint prose.
   Discretionary; can defer.
3. **Skip CRITICAL #2** (the TO_USER.md surface is done).
4. **Defer HIGH #3 (comment trim)** unless the iter-125 prover lane
   touches `Differentials.lean` again (it should not — iter-125 is
   the Rigidity refactor lane).
5. **Defer MEDIUM #5** to iter-126+.
6. **Carry MEDIUM #6 forward** into the iter-127+ horizon.
7. The 3 mandatory critics + 1 mandatory lean-auditor + however many
   lean-vs-blueprint-checkers needed (per the Rigidity refactor's
   target files) all dispatch normally.

## Watch criteria for iter-126 (from iter-125)

1. **Iter-125 Rigidity refactor returns COMPLETE** (zero sorries
   introduced; refactored signature compiles; blueprint cross-refs
   updated): iter-126 dispatches the M2.a prover lane against the
   refactored declaration.
2. **Iter-125 Rigidity refactor returns BLOCKED** (e.g., a downstream
   `Jacobian.lean` consumer the iter-124 mathlib-analogist missed
   relies on a dropped hypothesis): iter-126 plan-phase dispatches a
   second mathlib-analogist consult and either re-scopes the
   refactor or rolls back to the iter-124 signature.
3. **iter-125 USER_HINTS.md response received** on TO_USER.md M3
   options: the plan-agent translates the user direction into
   STRATEGY.md updates + the appropriate downstream actions.

## Reusable proof patterns surfaced this iter (for PROJECT_STATUS.md Knowledge Base)

1. **`AlgEquiv.ofBijective` + `IsLocalization.lift_{inj,surj}_iff`
   is the canonical narrowing step when forward is an
   `IsLocalization.lift` to a target with the right algebra
   structure**. Pairs naturally with the iter-122 helper-extraction
   pattern (`appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra`)
   to make `commutes'` close in 1 LOC via `RingHom.congr_fun`.

2. **`RingHom.congr_fun` for `commutes'` field of an AlgHom**. When
   target algebra structure is `someRingHom.toAlgebra` and you have
   a fact `f.comp (algebraMap _ _) = someRingHom`, then
   `RingHom.congr_fun (h := the_fact) r` closes the `commutes'` goal
   `f (algebraMap r) = algebraMap r` via the definitional unfolding
   of `RingHom.toAlgebra`'s `algebraMap`. The `algebraMap = ringHom`
   defeq is the load-bearing trick.

Both will be added to PROJECT_STATUS.md § Proof Patterns this review.
