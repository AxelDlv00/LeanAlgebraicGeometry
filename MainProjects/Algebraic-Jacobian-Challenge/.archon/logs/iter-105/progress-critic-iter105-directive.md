# Progress Critic Directive

## Slug
iter105

## Iter
105

## Active routes / files under review

### Route: `cechCofaceMap_pi_smul` trailing sorry in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **Started at iter**: 099 (first lane on this slot; iter-104 closed a related L536 target)
- **Iters audited**: 100, 101, 103, 104 (project), 105 (project) — Archon-canonical iter-099 through iter-104

#### Sorry counts per iter (BasicOpenCech.lean only)
- entering iter-099: 7
- end of iter-099: 6 (closed `alternating_sum_pi_smul_aux_sum_comp` body; opened nothing new)
- end of iter-100: 6 (no closure; structural advance — `funext j'` pivot landed)
- end of iter-101: 6 (no closure; S1–S3 chain landed but stalled at S4)
- end of iter-102 (refactor): 7 (added inert helper `alternating_zsmul_pi_smul_aux_sum_comp` skeleton)
- end of iter-103: 6 (closed iter-102 helper body; failed Path A on L827)
- end of iter-104 (project): 6 (closed `cechCofaceMap_summand_family_R_linear` body at L536 — DIFFERENT target, not the L988 trailing slot)
- end of iter-105 (project): 6 (added two wrapper helpers fully proved, committed structured partial proof at L1147; no L1147 closure)
- end of iter-106 (project) [this report]: 7 (added Route 1 lemma signature with sorry body; L1147→L1179 sorry preserved)

#### Helpers added per iter (this route)
- iter-099: 0 (closed pre-existing helper; closed L657 call site)
- iter-100: 0
- iter-101: 0
- iter-102 (refactor): +1 inert helper `alternating_zsmul_pi_smul_aux_sum_comp` (skeleton only; body sorry)
- iter-103: 0 (closed iter-102 helper body)
- iter-104/Archon (refactor): +2 helpers `cechCofaceMap_summand_family` (full body), `cechCofaceMap_summand_family_R_linear` (skeleton, body sorry)
- iter-104 (project) [prover]: 0 (closed iter-104/Archon helper body)
- iter-105 (project) [prover]: +2 helpers `cechCofaceMap_summand_family'` (full body), `cechCofaceMap_summand_family'_R_linear` (full body) — BOTH fully proved zero-sorry
- iter-106 (project) [prover]: +1 helper `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (SKELETON only, body sorry, "dead-end" `have hPrev` scaffold unused before `sorry`)

#### Prover statuses per iter (this route)
- iter-099: PARTIAL — closed 1 sorry (`_sum_comp` body + applied at call site); `?hG` per-summand discharge remains
- iter-100: PARTIAL — `funext j'` pivot landed but 6 scalar-extraction routes failed at discrim-tree
- iter-101: PARTIAL — S1–S3 of post-funext recipe landed; 6 attempts at S4 failed at same discrim-tree class
- iter-103: PARTIAL — S4–S5 landed as forward progress; 5 routes failed on post-S5 frame (discrim-tree blocker + whnf timeout at 1600000 + eqToHom metavar ambiguity)
- iter-105: PARTIAL — 2 wrapper helpers fully proved; L1147 structured partial proof committed; residual identified as morphism-level eqToHom-vs-Pi.π transport at coord `j'`
- iter-106: PARTIAL — Route 1 lemma signature elaborates clean, body proof 7 attempts all failed (Pi.hom_ext → Pi.lift_π → can't apply past eqToHom; eqToHom_refl needs literal rfl; subst hPrev infinite recursion; simp only [hPrev] no progress; aesop_cat fails; ext + simp reduces to same gap). L1179 sorry: 4 attempts failed (simp piIsoPi_hom_ker_subtype_apply no progress; `Preadditive.zsmul_comp` whnf timeout at 1600000; ModuleCat.hom_zsmul/hom_smul/hom_nsmul find no match; `set F_at_i` discrim-tree blocked).

#### Recurring blocker phrases
- "discrimination-tree pattern-unification" / "discrim-tree blocker" appears in iter-100, iter-101, iter-103, iter-105, iter-106 reports — 5 of 5 audited iters mention it as the persistent blocker.
- "whnf timeout" / "deterministic timeout at 1600000 heartbeats" appears in iter-101, iter-103, iter-106 reports — 3 of 5 iters.
- "anonymous-closure Pi.lift codomain" / "anonymous-closure form" appears in iter-100, iter-101, iter-103, iter-104, iter-105, iter-106 reports — 6 of 6 iters mention this as the structural root cause.
- "Fin index mismatch" / "`Fin ((prev n) + 2)` vs `Fin (n+1)`" appears in iter-097, iter-102/Archon, iter-105, iter-106 reports — multi-iter index-type unification problem.
- "eqToHom-vs-Pi.π transport" / "eqToHom transport identification" appears in iter-103, iter-105, iter-106 — 3 of 6 iters explicitly name this as residual.

#### Planner's current proposal for this iter (iter-107 / Archon iter-105)

The iter-106 prover's recommendation is one of three:
1. Lift `set_option maxHeartbeats` for `cechCofaceMap_pi_smul` head from 1600000 to 3200000 or 6400000 and retry the `← ConcreteCategory.comp_apply (×4) + Preadditive.zsmul_comp` chain. The hypothesis: the whnf timeout is solvable with more budget.
2. Rework the Route 1 lemma to NOT use eqToHom at all — parameterize by `i : Fin ((prev n) + 2)` directly (eliminate the `Fin.cast hRel.symm i` roundtrip), or use HEq + heq_of_eq.
3. Discard the wrapper approach entirely and re-attempt R-linearity of unwrapped per-summand directly via `Pi.hom_ext` + per-coord scalar pullback — would discard iter-105/iter-106 helpers.

The planner's tentative proposal is to dispatch another prover round attempting BOTH option 1 (heartbeat lift) AND option 2 (lemma rework without eqToHom), with refactor cleanup of the lean-auditor-flagged stale docstrings and dead-end `have hPrev` scaffold as preamble.

## Out of scope

The other 12 sorries in the project (Differentials × 5, Modules/Monoidal × 1, Jacobian × 1, Picard/Functor × 1, BasicOpenCech L1239/L1271 (substep a)/L1563/L1591/L1595/L1623/L1810 — deferred per strategy) are NOT under review this iter. Only the `cechCofaceMap_pi_smul` route (active L1179) and its newly-added Route 1 lemma transient sorry at L751 are in scope.
