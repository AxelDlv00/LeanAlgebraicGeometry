# Progress-critic directive — iter-222

Assess convergence of the single active prover route. Verdict per route.

## Active route: TS.dual (A.1.c.SubT.dual — sheaf internal-hom / dual of 𝒪_X-modules)

File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (sole productive lane).
Mode: `mathlib-build` (funded multi-iter infrastructure block; tracked by **sub-step
retirement**, NOT project-sorry count — the gated project sorry `exists_tensorObj_inverse`
closes only at sub-step 5).

Strategy estimate for this phase (lifted verbatim from STRATEGY.md `## Phases & estimations`):
- **Iters left: ~6–12.**
- **Phase entered: iter-219** (so elapsed = 3 iters as of end of iter-221).

### Signals, last 5 iters (K=5)

| iter | prover status | project sorry | decls added | what landed |
|---|---|---|---|---|
| 217 | COMPLETE | 81→80 | 5 | closed linchpin `tensorObj_restrict_iso` (H1 adjunction + H2 monoidal) |
| 218 | INCOMPLETE (pre-committed gate) | 80→80 | 0 | probed ⊗-inverse; correctly hit gate naming Mathlib-absent dual; ran analogist |
| 219 | sub-step 1 COMPLETE | 80→80 | 11 | per-object VALUE module `homModule`/`internalHomObjModule` + 9 helpers |
| 220 | sub-step 2 COMPLETE | 80→80 | 12 | `restrictionMap` family + ASSEMBLED presheaf `internalHom` via `ofPresheaf` |
| 221 | sub-step 3 PARTIAL | 80→80 | 6 | `dual` DONE (leanok'd) + `internalHomEvalApp` + 5 eval helpers; FULL `internalHomEval` morphism slipped |

Recurring blocker phrase: **"`Over.map` pseudofunctor coherence"** (map_id/map_comp not
defeq). iter-220 CRACKED it for `restrictionMap` with a private helper `hom_app_heq`
(`subst h; rfl` + `eq_of_heq`). iter-221's slipped `internalHomEval` naturality reduces
(confirmed by the prover via `tensor_ext`) to exactly that same coherence obstacle — the
prover left a precise, worked-out reduction naming each step and the iter-220 template to
port.

### This iter's proposed objective (1 file)

`TensorObjSubstrate.lean` [prover-mode: mathlib-build] — **complete sub-step 3**: build the
full natural morphism `PresheafOfModules.internalHomEval` by assembling the already-built
per-object `internalHomEvalApp` into a `Hom.mk` and discharging the naturality field via the
ported iter-220 `hom_app_heq`/`subst` coherence trick. First sub-step: the `internalHomEvalApp_tmul`
simp lemma. Success bar = `internalHomEval` built axiom-clean.

## Questions for you

1. Is this route CONVERGING, CHURNING, STUCK, or UNCLEAR — given sub-step retirement (3 of
   ~6–12) is the tracking metric, not project-sorry count?
2. iter-221 was the first within-sub-phase slip (sub-step 3 spanning 2 iters). Is re-dispatching
   the SAME lane to finish `internalHomEval` — with a precise, precedented, recorded fix
   (port the iter-220 `hom_app_heq` trick) — the right move, or a churn signal?
3. The review flagged the genuine churn trigger to watch: iter-222 returning PARTIAL with only
   more eval *helpers* and no assembled `internalHomEval` morphism. Do you concur that is the
   correct stop-signal, and is there an earlier one?
