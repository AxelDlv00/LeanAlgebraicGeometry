# Iter-098 (Archon canonical) plan agent narrative

> **Note on iteration numbering.** The Archon-loop counter (`ARCHON_ITER_NUM=098`)
> diverges from the project's internal narrative counter, which uses iter-099
> for the prover round whose output this plan-agent run consumes, and iter-100
> for the prover lane this run schedules. Sidecar dirs follow Archon's counter;
> in-file commentary follows the project narrative. Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-099 prover report
  (verified independently below; archived to `logs/iter-098/prover-iter099-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-099 plan with two-step recipe (Step 1: fill L532 lemma
  body; Step 2: apply lemma at L695).
- `STRATEGY.md` — Phase A arc up to iter-098 refactor's split-slot lemma
  insertion.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.

## Independent verification

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → `6 total` (was 7).
- `lean_diagnostic_messages` severity=error → `[]`.
- Sorry locations (verified): L728 (NEW residual), L820, L1144, L1172, L1362, L1391.
- No new axioms (`grep -n "^axiom " BasicOpenCech.lean` empty).
- Iter-098 refactor's `alternating_sum_pi_smul_aux_sum_comp` body (L532–L537):
  3-line proof committed verbatim per directive recipe.
- Inside `cechCofaceMap_pi_smul`: at L710–L712 the new lemma is APPLIED via
  `rw [← Pi.smul_apply (i := j)]; refine congrFun (alternating_sum_pi_smul_aux_sum_comp
  Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j` — Miller-pattern unifier successfully
  fills `?Z_int`, `?G`, `?E := eqToHom`, `?s := Finset.univ`. Only the
  per-summand `?hG` discharge remains as residual `sorry` at L728.

## Iter-099 outcome assessment

**Substantively positive.** The iter-098 split-slot structural lemma's design
is FULLY VALIDATED at the call site:
- `alternating_sum_pi_smul_aux_sum_comp`'s body closes in 3 lines as predicted
  (Miller-pattern unification fires HOU-free because `G` and `E` are binders).
- The lemma's application at the call site succeeds via `rw [← Pi.smul_apply
  (i := j)]; refine congrFun (... ?_ r y) j` — the `congrFun` neatly
  bridges family-level conclusion to the post-iter-097-B1 j-eval form,
  AND the `?E := eqToHom` slot accepts the call site's `eqToHom` independently
  of `?G`'s elaboration. This cleanly avoids the iter-097 Attempt-5 dead-end.

**Residual subgoal narrowed.** Only `?hG` (per-summand R-linearity of
`((-1)^↑i • Pi.lift_thing) ≫ eqToHom`) remains. Its goal shape is now small
and concrete (verified at L728 via `lean_goal`), and decomposes cleanly:
1. categorical scalar `(-1)^↑i • _` extraction (k-linear),
2. propagation through `eqToHom`, `e₂` (k-linear),
3. coordinate-wise R-linearity via `presheafMap_restrict_collapse`.

The iter-099 prover exhausted six routes for step (1) — root cause is well
understood: polymorphic `(-1)^↑i` doesn't elaborate to k automatically, so
`Linear.smul_comp` / `Preadditive.zsmul_comp` / `ModuleCat.hom_smul` all
pattern-match-fail, even though each lemma is mathematically applicable.

## Decisions for iter-100

1. **No subagent call.** The residual is tactic-level (3-step decomposition)
   and the structural lemma is fully validated. Calling refactor again would
   be unjustified — there's nothing structurally wrong, just a typeclass
   synthesis gap on a polymorphic scalar.
2. **No analogy call.** The pattern (k-linear smul extraction past hom +
   presheaf-restriction R-linearity) is well-trodden in Phase A iter-090/091.
3. **No challenger call.** No new definition introduced.
4. **Single substantive prover lane (Lane 1)**: close L728 `?hG` discharge.
   Recommended chain pins `(-1)^↑i` to k via `set h_sgn : k := (-1)^(↑i : ℕ)`
   BEFORE distribution attempts, then `Linear.smul_comp` + `map_smul` +
   `smul_left_comm` + `congr 1` + `ext j'` + `presheafMap_restrict_collapse`.
5. **Lane 2 (Differentials) OFF-LIMITS** as before — `h_exact` Mathlib gap
   parallel to `instIsMonoidal_W`.

## Blueprint

No changes — `alternating_sum_pi_smul_aux`, `alternating_sum_pi_smul_aux_sum_comp`,
`cechCofaceMap_pi_smul`, `presheafMap_restrict_collapse` are project-local
helpers without their own `\lean{...}` blueprint entries. Their parent
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` blueprint discussion in
`Cohomology_MayerVietoris.tex` § Čech acyclicity remains accurate.

## Sorry trajectory

| Iter | BasicOpenCech sorries | Net change |
|---|---:|---:|
| iter-095 entry | 6 | — |
| iter-096 (refactor: alternating_sum_pi_smul_aux added) | 7 | +1 (structural) |
| iter-097 (prover: aux body closed) | 6 | −1 |
| iter-098 (refactor: alt_sum_comp added) | 7 | +1 (structural) |
| iter-099 (prover: alt_sum_comp body + L695 application) | 6 | −1 |
| **iter-100 target** | **5** | **−1 (close L728)** |
| iter-101 target | 4 | −1 (close L1362 g_R.map_smul') |

## What changes propagate

- `task_done.md` — appended one entry: "iter-099 structural advance".
- `task_pending.md` — refreshed BasicOpenCech section (sorry count 7 → 6, line
  numbers shifted to L728, L820, L1144, L1172, L1362, L1391; iter-100 plan
  summary added; iter-099 plan migrated to historical reference).
- `STRATEGY.md` — Phase A row revised; iter-099 entry added to Revision log;
  iteration estimate ~5–8 → ~4–7; iter-100/101 plans updated.
- `PROGRESS.md` — fully rewritten for iter-100 prover dispatch.
- `iter/iter-098/plan.md` (this file) — narrative for the planning round.
- `iter/iter-098/objectives.md` (companion) — the dispatched objectives.
