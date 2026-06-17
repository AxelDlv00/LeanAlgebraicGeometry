# Progress Critic Report

## Slug
iter037

## Iteration
037

## Routes audited

### Route: 01I8 `F ≅ ~(Γ F)` — Route B (section-localization), `QcohTildeSections.lean`

- **Sorry trajectory**: Flat at 2 across the entire K=5 window (iter-032 to iter-036) — by design in `mathlib-build` mode; those 2 sorry are frozen/superseded. The project-mandated convergence metric is the named unconditional 01I8 target `qcoh_section_isLocalizedModule`. It is **ABSENT across all 5 iters**.

- **Helper accumulation**: 24 helpers added across 5 iters (+7, +3, +2, +9, +3). Named target: never closed. Helper-to-payoff ratio is entirely front-loaded; the named target has not advanced.

- **Prover dispatch pattern**: 1 file dispatched per iter throughout the window. All other files in scope are gated on 01I8, dormant, or done; no under-dispatch finding (M = 1, N = 1 consistently).

- **Recurring blockers**:
  - iter-033: "Ab-stalk mono transport"
  - iter-034: "σ_x R-linear packaging + jointly-reflecting assembly"
  - iter-035: "absent-Mathlib **tilde base-change** (`tilde_restrict_basicOpen`, Stacks `lemma-widetilde-pullback`)"
  - iter-036: "**`.over`→affine base-change bridge** — explicitly the SAME geometric base-change that blocked Route P at iter-035"

  The same-blocker threshold for STUCK (≥3 consecutive iters) is NOT met — the phrase "affine base-change / tilde restrict to D(f)" appears in only 2 consecutive iters (035, 036). However, this is the single persisting geometric obstruction across the full Route P window: the blocker phrase evolved (each sub-obstacle cleared), but the underlying infrastructure gap — restrict a qcoh module + its presentation to D(f) and compare sections with localizations — was always the residual core.

- **Avoidance / rotation churn**: The Route P → Route B pivot occurred at iter-036. The directive states Route B's primary keystone blocker is "explicitly the SAME geometric base-change that blocked Route P at iter-035." This is the **possible rotation churn** pattern (rules §6): route pivoted, new route's primary blocker is inferably the same infrastructure gap as the old route's. Flag for strategy-critic to confirm or refute. Counter-signal (from the planner, assessed as credible): the MODULE-transport half (`modulesRestrictBasicOpen`, iter-035) is already built — the residual is the sections-comparison `Γ(D(g),F) ≅ Γ(Spec R_g, F|_{D(g)})`, which is more elementary than the original Route P wall (`tilde_restrict_basicOpen`, a tilde-specific base-change absent from Mathlib). The distinction is real: Route P required an absent-Mathlib functor-level identity for tilde specifically; Route B needs a sections-level comparison derivable from basicOpenIsoSpecAway functoriality. This weakens — but does not dissolve — the rotation-churn signal.

- **Prover status pattern**: PARTIAL (iter-033), PARTIAL (iter-034), PARTIAL (iter-035), SETUP/PARTIAL (iter-036, Route B local-model bricks built, keystone not yet attempted). Named target ABSENT ×5.

- **Throughput**: Route B phase entered at iter-036, 1 iter elapsed; STRATEGY.md estimate "~3–5 iters." **ON SCHEDULE** for the Route B sub-phase. The broader 01I8 effort has run since ~iter-029 (~8 iters total) against a series of rolling estimates — not independently scored here since Route B represents a genuine strategic reset.

- **Verdict: CHURNING**

  Rule matched: **PARTIAL prover status ≥3 of last K iters** (3 explicit PARTIAL iters on Route P, plus a non-closing iter-036 on Route B). Named target ABSENT all 5 iters with 24 helpers accumulated. CHURNING rule 1 ("helpers added ≥2 iters AND named target unchanged AND no structural change") has a partial exception for the iter-036 pivot (genuine strategic reset), but PARTIAL×3+ rule matches independently. Possible rotation churn is a secondary signal, not the primary verdict basis.

- **Primary corrective**: **Attempt the keystone directly this iter.** The iter-037 proposal already enacts this: build the base-change-bridge glue (section-comparison) and close `qcoh_section_isLocalizedModule` in the same dispatch. This IS the correct CHURNING response — stop accumulating helpers and drive toward the named target. The report's must-fix entry is therefore simultaneously a verdict and a confirmation that the planner's proposal is on-track. **Critical constraint**: if the keystone does NOT close this iter, the iter-038 response MUST be user escalation — NOT another route pivot or another helper round.

- **Secondary corrective**: Dispatch strategy-critic before iter-038 prover assignment to confirm or refute the rotation-churn hypothesis. If confirmed (same geometric bridge, cosmetic relabeling), user escalation is preemptively the right call.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: none identified — all other files are either 0-sorry done, gated on 01I8 close, or dormant with no blueprint chapter pending.
- **Over the cap**: no
- **Under-dispatch finding**: no — M = 1 (the keystone lane), N = 1 dispatched.
- **Iter-over-iter trend**: 1 → 1 → 1 → 1 → 1; stable, not under-dispatching against available ready lanes.
- **Verdict: OK** — file count 1 within cap 10; no under-dispatch; not growing while routes churn.

---

## Must-fix-this-iter

- **Route 01I8 (Route B): CHURNING** — primary corrective: **Attempt `qcoh_section_isLocalizedModule` as the DIRECT target this iter; no further helper-only rounds.** The iter-037 proposal already satisfies this corrective. If the keystone does not close, escalate to the user at iter-038 rather than pivoting routes again.
- **Route 01I8 (Route B): possible rotation churn** — the geometric base-change infrastructure gap (section-comparison for restricted module) has persisted under both Route P and Route B labels. Dispatch strategy-critic before iter-038 to adjudicate; if confirmed, the next step is user escalation, not a third route.

---

## Informational

The CHURNING verdict is simultaneously a warning about the 5-iter pattern AND a confirmation that the iter-037 proposal (base-change glue + keystone attempt in one dispatch) is the correct CHURNING corrective — the planner has preemptively identified the right response. The verdict does not recommend blocking or redirecting this iter's prover dispatch; it recommends the planner explicitly note in iter-037 plan.md that another non-closing iter triggers user escalation, not a further route relabel.

The sections-comparison `Γ(D(g),F) ≅ Γ(Spec R_g, modulesRestrictBasicOpen g F)` is structurally simpler than the Route P wall — it follows from basicOpenIsoSpecAway functoriality and does not require absent-Mathlib tilde-specific base-change. The rotation-churn flag is a signal to monitor, not a verdict that the route is provably circular.

---

## Overall verdict

One route is under review: 01I8 Route B (section-localization, `qcoh_section_isLocalizedModule`). It is **CHURNING**: 24 helpers accumulated across 5 iters, named target ABSENT throughout, PARTIAL prover status ≥3 of last K iters, with a possible rotation-churn signal (Route B's primary blocker shares the same geometric base-change infrastructure as Route P's iter-035 blocker). The iter-037 proposal is the correct CHURNING corrective — it attempts the keystone directly rather than adding more helpers — and should proceed. The must-fix obligation is a forward constraint: if the keystone does not close at iter-037, iter-038 must escalate to the user rather than attempting a third route pivot or further helper accumulation. Dispatch sanity is OK (1 file, 1 ready lane, no under-dispatch).
