# Progress Critic Directive

## Slug
kdm-route

## Iter
154

## Active routes / files under review

### Route: Cotangent/ChartAlgebra.lean — chart-algebra envelope (KDM + constants), Route C critical path

- **Started at iter**: chart-algebra split ~iter-144; KDM sub-piece live since iter-149
- **Iters audited**: iter-150 to iter-153

#### Sorry counts per iter (this file)
- iter-150: 2  (KDM + constants)
- iter-151: 2  (KDM + constants)
- iter-152: 2  (KDM + constants)
- iter-153: 1  (KDM only — constants CLOSED, axiom-clean)

(Whole-project sorry counts over the same window: 9 → 9 → 9 → 8.)

#### Helpers added per iter (this file)
- iter-150: ~190 LOC of `_mvPoly_*` private FREE-CASE helpers + `_hFunct` functoriality reduction
- iter-151: none (comment-only — prover proved the bare KDM lemma mathematically FALSE; documented 2 counterexamples)
- iter-152: none (architectural refactor: signature corrected to add `[IsAlgClosed k]`/`[CharZero k]`/`[IsDomain B]`; no new helpers)
- iter-153: none (closed `constants_integral_over_base_field` in ~25 LOC via existing alg-closed collapse; no new helpers)

#### Prover statuses per iter
- iter-150: PARTIAL — re-decomposed; net sorry inflated 5→9 (KDM transfer step unresolved)
- iter-151: PARTIAL — proved bare KDM lemma FALSE (counterexamples); no code, comment-only diagnosis
- iter-152: (no prover dispatch — architectural-pivot iter; signature refactor only)
- iter-153: COMPLETE on primary (constants closed, axiom-clean, project 9→8) + BRIGHT-LINE STOP on KDM secondary

#### Recurring blocker phrases
- "KDM transfer step / `ker d = field of constants` / FT.3" appears in iter-149, 150, 151, 152, 153 reports — the same residual content (kernel of the universal Kähler derivation = relative algebraic closure for a separable char-0 field extension) has blocked the KDM lemma across the whole window.
- "Mathlib gap — lemma confirmed ABSENT (snapshot b80f227)" appears in iter-153 prover report; the prior iters attacked the same step under different framings (bare B-only transfer, then post-pivot field-of-fractions FT.3).

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from the "Chart-algebra envelope (over `[IsAlgClosed]`)" row): "3–5"
- **Elapsed iters in current phase**: ~8 (phase active since the chart-algebra split; the `[IsAlgClosed]` pivot at iter-152 reset scope but the KDM step is the same residual)
- **Phase started at iter**: chart-algebra split ~iter-144; STRATEGY.md row notes "OVERRAN prior estimate"

#### Planner's current proposal for this iter
The planner is NOT assigning another KDM prover round. Instead it is
executing the STRATEGY.md bright-line corrective: a `mathlib-analogist`
(cross-domain) consult on the FT.3 "kernel of universal Kähler derivation =
field of constants for separable char-0 field extension" shape, followed by
a blueprint-writer round that decomposes FT.3 into named sub-lemmas with the
analogist's verified Mathlib citations. The KDM prover round is deferred to
iter-155 (after FT.3 is decomposed and the decomposed chapter is reviewed).
No prover lane fires this iter on this route; all other open sorries
(`Jacobian.lean`, `RigidityKbar.lean`) are gated on KDM closure, and
`ChartAlgebraS3.lean` is descoped off-path.

## PROGRESS.md proposal (this iter)

- **File count**: 0 (no prover dispatch — mechanical hard gate: the only
  critical-path sorry is blocked on a Mathlib gap whose corrective is a
  read-only analogist consult + blueprint decomposition)
- **Files**: (none)
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope

- `Jacobian.lean` (genusZeroWitness, positiveGenusWitness) — gated on chart-algebra closure.
- `RigidityKbar.lean` (rigidity_over_kbar) — gated on chart-algebra closure.
- `Cotangent/ChartAlgebraS3.lean` — descoped off-critical-path.
