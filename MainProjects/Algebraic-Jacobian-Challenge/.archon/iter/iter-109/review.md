# Iter-109 (Archon canonical) / iter-111 (project narrative) — review

## Outcome at a glance

- **Single small prover lane on `Picard/LineBundle.lean`** closing the 3 transient `Pic.pullback*` sorries that the iter-109 (Archon) C1-promotion refactor had introduced. Path (i) inline construction per PROGRESS.md spec; one new sister-gap helper (`SheafOfModules.pullback_oneIso`) introduced as a `noncomputable def` companion to the existing named-deferred `SheafOfModules.pullback_tensorObj`.
- **Result**: **COMPLETE** — all 3 transient closures landed cleanly. Pre-commit escalation policy (progress-critic-iter109: re-dispatch mathlib-analogist if <2 of 3 close) is satisfied without escalation.
- **Sorry trajectory**: project total **18 → 16** (−2). Per-file: BasicOpenCech 6 → 6, Differentials 5 → 5, Modules-Monoidal 1 → 1, Jacobian 1 → 1, Picard.Functor 1 → 1, **Picard/LineBundle 4 → 2** (closed L93/L99/L105, retained L82 `pullback_tensorObj`, added L96 `pullback_oneIso`).
- **Compile-verified**: yes (`lean_diagnostic_messages` severity=error returns `[]` end-to-end; `lake build` succeeds, 8333 jobs). **Seventeenth consecutive compile-verified prover iteration** (iter-092 through iter-109 Archon).
- **No new axioms**; no protected signatures touched; `archon-protected.yaml` unchanged. `lean_verify` on the three closed bodies shows `["propext","sorryAx","Classical.choice","Quot.sound"]` — standard axioms; `sorryAx` enters transitively from `pullback_tensorObj`, `pullback_oneIso`, and (post-C1, load-bearing) `instIsMonoidal_W`.
- **Named-gap roster**: 4 → 5 named Mathlib-gap sorries + 1 budget-deferral (the new `pullback_oneIso` is bookkeeping; both pullback isos collapse together upon a Mathlib refresh landing `(SheafOfModules.pullback _).Monoidal`).

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **16**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at L1120 (`cechCofaceMap_pi_smul`, **PAUSED**, partial scaffold preserved), L1212 (substep (a) augmented Čech, deferred), L1536 (`K → K₀` transport, deferred), L1564 (substep (a) for `s₀`, deferred), L1754 (`g_R.map_smul'`, gated on L1120), L1846 (`h_loc_exact`, budget-deferred per iter-108 Archon).
  - `AlgebraicJacobian/Differentials.lean`: **5** at L122, L636, L718, L735, L877 (unchanged; OFF-LIMITS iter-109 — Phase B not dispatched).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (`instIsMonoidal_W`; Mathlib gap; load-bearing post-C1).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; Phase C3 deferred via JacobianWitness exit policy).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L181 (`PicardFunctor.representable`; gated on Phase C3 / now downstream of LineBundle C1).
  - `AlgebraicJacobian/Picard/LineBundle.lean`: **2** at L86 (`SheafOfModules.pullback_tensorObj`; named-deferred Mathlib gap) and **L98 (`SheafOfModules.pullback_oneIso`; new named-deferred sister gap, iter-109 added)**.
- **Solved this iter**: **3** sorries — `Pic.pullback` (L93→L108), `Pic.pullback_id` (L99→L131), `Pic.pullback_comp` (L105→L147). All three closed via Path (i) inline construction using `pullback_oneIso` + `pullback_tensorObj` as oracles plus `Scheme.Modules.pullbackId` and `Scheme.Modules.pullbackComp` (existing Mathlib infrastructure).
- **Partial this iter**: **1** — `SheafOfModules.pullback_oneIso` introduced as new helper with `sorry` body (named-deferred Mathlib-gap sister to `pullback_tensorObj`).
- **Blocked this iter**: none.
- **Untouched (deferred)**: 6 BasicOpenCech + 5 Differentials + 1 Monoidal + 1 Jacobian + 1 Picard.Functor + 1 LineBundle (`pullback_tensorObj`) = 15 untouched (the iter-109 added `pullback_oneIso` raises the count by 1).

## What the iter-109 plan got right

- **Path (i) preference**: PROGRESS.md preferred inline construction over Path (ii) (separate `(Scheme.Modules.pullback f).Monoidal` instance). The prover took Path (i) and the LOC count is ~30 for `Pic.pullback` + 12 for `pullback_id` + 16 for `pullback_comp` — well below Path (ii)'s ~3-4× estimate.
- **Helper budget**: the plan's "≤2 file-local helpers" cap accommodates 1 helper introduced (`pullback_oneIso`). The plan-step recipe explicitly anticipated this: "preserves the monoid unit ... sorry -- delegate to a 1-line lemma or fold into pullback_tensorObj". The prover chose the 1-line-lemma route since `pullback_tensorObj`'s signature is protected. The reviewer concurs: this is the correct shape.
- **Pre-commit escalation discipline**: the plan committed to `mathlib-analogist` re-dispatch if <2 of 3 closed. Closing 3 of 3 satisfies the policy cleanly without escalation; no helper-rounds, no additional infrastructure.
- **Bracket on `pullback_tensorObj`**: the plan explicitly disallowed attempts at L82 (the named Mathlib gap). The prover respected this; the file's named-gap stays as the 4th named gap (now 5th with the new sister `pullback_oneIso`).
- **Mathlib lemma tagging**: the plan tagged `Scheme.Modules.pullbackId` and `Scheme.Modules.pullbackComp` as `[expected]` and asked the prover to verify. Both exist; the prover used them directly for `pullback_id` and `pullback_comp` bodies.

## What the iter-109 plan could have anticipated

- **The plan's example sketched `refine Units.map ⟨⟨?_, ?_⟩, ?_⟩` with `Quotient.lift`. The prover used the anonymous-constructor on `MonoidHom`'s fields directly without `Quotient.lift`**, because `mul_eq`/`one_eq` and `mapSkeleton.obj` unfold definitionally. This is a cleaner shape; the plan's `Quotient.lift` machinery would have worked too but is overkill. Reviewer flags this for future Skeleton-API plan-step recipes — the definitional unfoldings are stronger than the plan assumed.
- **The plan tagged `Scheme.Modules.pullback_id` and `Scheme.Modules.pullback_comp` (lowercase `_id`, `_comp`); the actual Mathlib names are `pullbackId` and `pullbackComp` (camelCase, returning `NatIso`s)**. The prover correctly routed through these. This is a minor planning artifact.

## What the iter-109 plan got wrong / what to fix next iter

- **Blueprint chapter drift**: `blueprint/src/chapters/Picard_LineBundle.tex:62,81,119` still states the Lean bodies of `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` "remain `sorry`". This is now stale — the bodies are closed, gated only on the two named-deferred isos (`pullback_tensorObj`, `pullback_oneIso`). Plan-agent action item for iter-110 (Archon): dispatch `blueprint-writer linebundle-postClose` to (i) correct the stale prose, (ii) add a new `\thm:SheafOfModules_pullback_oneIso` block mirroring the existing `\thm:SheafOfModules_pullback_tensorObj`, and (iii) refresh the "Pull-back gap" paragraph at L28 to mention the now-bundled sister-iso pair.
- **`pullback_oneIso` named-gap disclosure**: STRATEGY.md's "5 named Mathlib gaps + 1 budget-deferral" framing needs updating. Either rename to "6 named Mathlib-gap sorries + 1 budget-deferral" (counting syntactically), or keep "5 + 1" with a note that 2 of the 5 are the μIso/εIso halves of one bundled Mathlib gap (counting conceptually). The end-state disclosure framing in STRATEGY.md should be updated by the iter-110 (Archon) plan agent.

## Streak status entering iter-110 (Archon canonical)

- **Picard/LineBundle.lean C1 route**: 1-iter prover round (iter-109 Archon = iter-111 narrative) with **COMPLETE** outcome — closes the post-C1 transient downstream cleanly. Streak: fresh, 1 iter, **CONVERGING** verdict expected from progress-critic next iter.
- **BasicOpenCech.lean**:
  - **L1120 (`cechCofaceMap_pi_smul`)**: 7-iter PARTIAL streak FROZEN at PAUSE for **4 clean iters** (iter-108 through iter-111 narrative). Iter-109 (Archon) correctly did NOT extend.
  - **L1846 (`h_loc_exact`)**: 2-iter PARTIAL streak FROZEN at exit-criterion (budget-deferral applied iter-108 Archon = iter-110 narrative); iter-109 (Archon) did NOT extend. Route closed-out.
- **All other routes**: untouched / off-limits this iter.

## Subagent dispatches this review phase

- **lean-auditor** (slug `iter109`, MANDATORY): **COMPLETE**. `task_results/lean-auditor-iter109.md`. Verdict: **HEALTHY**. 0 must-fix-this-iter, 3 major (1 NEW, 2 carry-over), 3 minor. Findings:
  - C1 promotion `LineBundle := (Skeleton X.Modules)ˣ` verified **mathematically correct**; `pullback_oneIso` signature + docstring sound.
  - **NEW major iter-109**: `BasicOpenCech.lean:1742` `g_R.map_smul'` in-flight comment ("Deferred to the next iteration") starting to harden into excuse-comment material after multiple iters. Plan-agent action: 1-line comment rewrite to honest "deferred behind `cechCofaceMap_pi_smul` closure" framing.
  - **CARRY-OVER major**: `BasicOpenCech.lean:17` + `Differentials.lean:27` header rot persists.
- **lean-vs-blueprint-checker** (slug `linebundle-iter109`, MANDATORY): **COMPLETE**. `task_results/lean-vs-blueprint-checker-linebundle-iter109.md`. Verdict: **HEALTHY**. 0 must-fix-this-iter, 3 chapter-side major (documentation drift), 1 chapter-side minor + 1 Lean-side minor. Key findings:
  - C1 promotion verified faithful (`LineBundle := (Skeleton X.Modules)ˣ` matches chapter prose).
  - `Pic.pullback` proof "mathematical content matches" — hand-construction equivalent to blueprint's `Skeleton.monoidHom` route.
  - **3 chapter-side major**: (i) missing `\thm:SheafOfModules_pullback_oneIso` sibling block; (ii) missing `\lean{...}` hints for `Pic.pullback_id` and `Pic.pullback_comp` (functoriality lemmas only prose-mentioned); (iii) stale "remain `sorry`" prose at L62 and L81 — all addressable via the recommendation-1 blueprint-writer dispatch.
  - **NEW Lean-side minor**: stale module docstring at `LineBundle.lean:32-37` (twice stale: body closed; gap now two oracles). Flag for next prover/refactor touch.
  - **Checker's "opine"**: mild preference for sibling `\thm:SheafOfModules_pullback_oneIso` block (justified by symmetry of `lean_verify`'s axiom chain on `Pic.pullback`).

Findings folded into recommendations.md. The pre-known issues the directives
flagged (LineBundle weakened-wrong def now **RESOLVED** via iter-109 C1;
blueprint chapter prose at L62/L81 now stale; `pullback_oneIso` not yet in
chapter) are all re-confirmed and are plan-agent action items for iter-110
(Archon) per recommendations 1+2.

## Knowledge Base additions

(Folded into PROJECT_STATUS.md Knowledge Base in the same review pass):

1. **Skeleton-quotient goals via double-`change` + `congr_toSkeleton_of_iso`** — reusable pattern for any `mapSkeleton` proof routed through `(Scheme.Modules.pullback f).mapSkeleton.obj u.val`.
2. **`apply Units.ext` over `show ... .val = ...`** when working with `Units.map ⟨⟨_,_⟩,_⟩`-shaped MonoidHoms — the latter's `.val` projection is brittle.
3. **Pullback-functoriality on `Skeleton` decomposes through `Functor.mapIso (fromSkeletonToSkeletonIso _).symm`** — the bridge between `pullback (f ≫ g)` and `(pullback f) ∘ (pullback g) ∘ (·.out)`.
4. **Sister-gap pattern for protected named-deferred sorries**: when a downstream consumer needs *two* outputs of an unstated Mathlib instance (here, μIso + εIso of `Functor.Monoidal`), introduce sister sorries with parallel docstrings; both collapse together upon a Mathlib refresh.

## Iteration log (one-paragraph)

**Iter-109 (Archon canonical) / iter-111 (project narrative)** — single small prover lane on `Picard/LineBundle.lean` post-C1 transient closure. Path (i) inline construction landed all 3 transient `Pic.pullback*` bodies (LOC: ~30 + 12 + 16 = ~58 LOC total proof content). One sister-gap helper `SheafOfModules.pullback_oneIso` introduced as `noncomputable def` (4 LOC, body `sorry`) — the εIso companion to the existing named-deferred μIso `pullback_tensorObj`. Project sorry count 18 → 16; LineBundle file count 4 → 2; named Mathlib-gap roster 4 → 5 + 1 budget-deferral (conceptually still 4 + 1 since the new `pullback_oneIso` and existing `pullback_tensorObj` are bundled as one Mathlib instance). Compile-verified end-to-end; `lake build` 8333 jobs green; no new axioms; protected signatures unchanged. Pre-commit escalation policy satisfied (3/3 closed cleanly, ≤2 helpers); no mathlib-analogist re-dispatch needed. Blueprint chapter `Picard_LineBundle.tex` requires a small-scope update next iter to (i) correct stale "remain sorry" prose at L62/L81/L119 and (ii) add a `\thm:SheafOfModules_pullback_oneIso` block mirroring the existing μIso block. Streak: LineBundle C1 route 1-iter, CONVERGING; BasicOpenCech routes (L1120 PAUSED 4 clean iters; L1846 budget-deferred 2 clean iters) untouched as planned.
