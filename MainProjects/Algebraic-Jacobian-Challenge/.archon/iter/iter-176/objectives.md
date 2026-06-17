# Iter-176 — prover lane directives

Iter-175 was DAMAGED by an Anthropic session-limit reset window at
06:14 UTC: 5 of 10 file-skeleton lanes hit `summary: "You've hit your
session limit · resets 7:30am (UTC)"` at session_end with 1 turn /
0 ms / $0 spent — the assigned files were NEVER created. Lane B
(RelativeSpec.lean) and Lane D (WeilDivisor.lean) also died with the
same 1-turn limit summary. Only Lane A1, Lane F (AuslanderBuchsbaum.lean),
and Lane J (Thm32RationalMapExtension.lean) ran to substantive completion
before the cutoff. (Lane FGAPicRepresentability ran 32 turns and $3.17
but never used `Write` — explored, then hit the limit, never wrote the
file.)

Iter-176 RE-DISPATCHES the 7 affected lanes verbatim. Lane A1 gets a
STRICT one-shot directive (single-attempt option (a) from
`analogies/chart-bridge-structural-pivot.md`); the 5 file-skeleton
re-dispatches keep their iter-175 chapter pins; Lane B + Lane D get
the same scope they had iter-175.

## Lane A1 — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (STRICT one-shot)

**Status**: Lane A1 is on its 5th consecutive iter without top-level
closure. The progress-critic `route175` armed the STUCK trigger for
iter-176. **However**, the iter-175 prover never actually applied the
analogist-prescribed recipe — they restructured `gmScalingP1_cover_X_iso`'s
`congrHom` argument (DIFFERENT approach) and hit the session-limit
cutoff before applying option (a). Iter-176 dispatches with a STRICT
no-exploration directive: apply option (a) AS WRITTEN; if it doesn't
close Step C in a single attempt, abort with INCOMPLETE and we
escalate to user via TO_USER.md.

**Required reading**: `analogies/chart-bridge-structural-pivot.md`,
specifically the "Top suggestion" + "Step C revised" sections (~lines
160–250).

**Sub-task A — option (a) on Step C of `gmScalingP1_chart_PLB_eq`**:

Open the file at L310 (case 0) and L322 (case 1). Insert ONE LINE in
EACH branch, immediately AFTER the `unfold gmScalingP1_cover_X_iso
gmScalingP1_cover` (which the file already has) and BEFORE the
existing `simp only [Iso.trans_hom, …]` chain:

- Case 0 (around current L310): insert `simp only [Fin.isValue, Fin.zero_eta]`
- Case 1 (around current L322): insert `simp only [Fin.isValue, Fin.mk_one]`

After each insertion, the existing `simp only [Iso.trans_hom, …,
pullbackSpecIso_hom_base, pullback.lift_fst, …, Category.id_comp]`
chain should fire (it was failing previously because `pullbackSpecIso_hom_base`
etc. didn't match on `MvPolynomial.X ⟨0, _⟩`; after Fin normalization
they should unify).

If the simp chain still leaves a residual after the Fin normalization,
the analogist recipe says try appending `<;> rfl` or
`<;> exact pullback.condition_assoc …`-style alignment per
`Mathlib.RingTheory.WittVector.IsPoly:354` analogue.

**Sub-task B — cross cases of `gmScalingP1_chart_agreement`**:

ONLY attempt sub-task B if sub-task A closes both Step C cases. The
cross cases (0,1)/(1,0) at L366/L368 need the substantive ring identity
sketched at `analogies/chart-bridge-structural-pivot.md` lines 250–340
(tmul_mul_tmul + mul_invSelf + mk_eq_mk_iff). Budget ~30-40 LOC per
case; if it doesn't land in single-attempt mode, abort.

**Helper budget**: 0 new private lemmas. The analogist's option (a)
needs zero new helpers — its whole point is the trivial 1-line
syntactic bridge.

**Termination**: if option (a) fails to close BOTH Step C cases,
write a SHORT task_result naming exactly which residual goal blocks
(LSP goal-state at the failure point) and STOP. Do NOT escalate to
option (b) Fin.cases refactor THIS iter — that's an iter-177 decision
for the plan agent.

**Acceptance**: best-case = 4 sorries closed (Step C ×2 + cross ×2);
break-even = 2 sorries closed (Step C ×2); INCOMPLETE = 0 sorries
closed ⟹ TO_USER.md escalation iter-177.

## Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean` (re-dispatch verbatim)

Same scope as iter-175 (which died 1-turn to session limit):

- PRIMARY: `RelativeSpec` (L160 in iter-175 numbering) body.
- SECONDARY: `structureMorphism` (L171).
- TERTIARY: `affine_base_iff` (L230).

Hard scope = 3 sorries max. Required reading
`analogies/qcohalgebra-structure.md`. The blueprint chapter
`Picard_RelativeSpec.tex` HARD GATE clears (iter-172 verdict;
iter-175 marker-only changes do not affect).

Helper budget = 2 new private lemmas max.

## Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (re-dispatch verbatim)

Same scope as iter-175 (which died 1-turn to session limit):

- PRIMARY: `RationalMap.order` body (around L140) via
  `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` per
  `analogies/dvr-rationalmap-order.md` recipe.
- May thread `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` as an
  explicit typeclass argument.

NOT ATTEMPTED: `principal`, `principal_hom`, `principal_degree_zero`
(downstream of `order` body landing).

Helper budget = 2 new private lemmas max.

## Lane E — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (file-skeleton; re-dispatch)

The file does NOT exist (Lane E iter-175 died in 1 turn). Re-dispatch
the verbatim iter-175 file-skeleton directive: scaffold from the pins
in `blueprint/src/chapters/Picard_FlatteningStratification.tex`;
substantive types (NO `True := trivial` / `Iso.refl _` placeholders);
all bodies `sorry`; add the module import to `AlgebraicJacobian.lean`.

## Lane G — `AlgebraicJacobian/Picard/RelPicFunctor.lean` (file-skeleton; re-dispatch)

Same shape. Pin source: `blueprint/src/chapters/Picard_RelPicFunctor.tex`.
Substantive types; sorry bodies; import added.

## Lane H — `AlgebraicJacobian/Picard/QuotScheme.lean` (file-skeleton; re-dispatch)

Same shape. Pin source: `blueprint/src/chapters/Picard_QuotScheme.tex`.

## Lane I — `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (file-skeleton; re-dispatch)

Same shape. Pin source: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
(empty `\uses{}` fixed iter-175 by writer `fgapic-empty-uses-fix`).

## Lane K — `AlgebraicJacobian/RiemannRoch/OCofP.lean` (file-skeleton; re-dispatch)

Same shape. Pin source: `blueprint/src/chapters/RiemannRoch_OCofP.tex`.

## Termination expectations

| Lane | Expected sorries Δ | Path-on-failure |
|---|---|---|
| A1 | -4 best / -2 break-even / 0 worst ⟹ TO_USER iter-177 | escalate |
| B | -2 to -3 | retry iter-177 |
| D | -1 | retry iter-177 |
| E | +~3-6 stubs | retry iter-177 |
| G | +~3-6 stubs | retry iter-177 |
| H | +~3-6 stubs | retry iter-177 |
| I | +~3-6 stubs | retry iter-177 |
| K | +~3-6 stubs | retry iter-177 |

Best-case end-of-iter sorries: 37 → 36 (Lane A1 −4 + Lane B −3 + Lane D −1
+ 5 file-skeletons net +~25) ≈ 50–60.
Break-even: 37 → 50ish.
Worst-case: Lane A1 0 closure ⟹ STUCK confirmed and escalates iter-177.

The +20-something file-skeleton stubs are EXPECTED INFLATION, not regression
— they shift Routes A.2.a/A.2.b/A.2.c/A.4.b/A.4.c/RR.3 from chapter-only
to file-skeleton state.

## Reversal triggers

- **Lane A1 closes 0 sorries with option (a) applied**: iter-177 fires
  TO_USER.md escalation proposing route pivot to differential
  `H⁰(ℙ¹, O(-2)) = 0` char-0 sub-case OR `Fin.cases` structural pivot
  per analogist option (b).
- **Five file-skeleton re-dispatches die again to session limit**:
  evidence of harness budget shape — escalate to user with explicit
  request to either raise the session budget or reduce iter-fan-out.
