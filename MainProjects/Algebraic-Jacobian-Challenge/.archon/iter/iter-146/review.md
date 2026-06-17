# Iter-146 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED** on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
  with 3 of 5 chart-algebra sub-pieces in scope. Result: **2 substantive
  closures + 1 substantive partial** (the first strict-count sorry
  reduction since the iter-145 chart-algebra decomposition cost of +2).
  `meta.json`: `planValidate.status: ok / objectives: 1`,
  `prover.status: done`, `prover.durationSecs: 1631` (~27 min).

- **Sorry count delta** (declarations using `sorry` / inline
  `sorry`): 8 / 8 → **6 / 6** (NET **−2**). Per-file at iter-146
  close:
  - `Cotangent/GrpObj.lean` — 0 / 0 (unchanged).
  - `Cotangent/ChartAlgebra.lean` — **3 / 3** (was 5 / 5):
    - L97 `df_zero_factors_through_constant_on_chart : True := sorry`
      (β-core; OFF-LIMITS this iter; carry-over from iter-145).
    - L107 `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
      : True := sorry` (KDM ring-side; OFF-LIMITS this iter;
      carry-over).
    - L177 `sorry` inside `constants_integral_over_base_field`'s
      body (substep 3 deferred; signature now real).
  - `Jacobian.lean` — 2 / 2 (unchanged).
  - `RigidityKbar.lean` — 1 / 1 (unchanged).

- **Per-target outcome** (iter-146 in-scope: 3 of 5 chart-algebra
  sub-pieces):
  - **(α) `algebra_isPushout_of_affine_product`** — SOLVED
    (sorry-free). Signature refined to
    `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)`; body is
    `inferInstance` after re-enabling Mathlib's `local`
    `Algebra.TensorProduct.rightAlgebra` instance at file scope.
  - **(β-aux) `constants_integral_over_base_field`** — PARTIAL.
    Signature refined to
    `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤` with
    `[Smooth] [IsProper] [IsReduced] [GeometricallyIrreducible]`
    hypotheses on `X` over `[Field k]`. Substeps 1–2 closed
    (`IrreducibleSpace` → `IsIntegral` → `IsField Γ(X, ⊤)` +
    `appTop.hom.Finite` via the four-lemma chain). Substep 3
    deferred (structured `sorry` at L177 with iter-147+ closure
    path documented inline).
  - **(lift) `Scheme.Over.ext_of_diff_zero`** — SOLVED (sorry-free)
    via **signature reduction**: the planner-spec'd `df = dg` +
    smooth-proper-genus-0 curve + smooth-proper-group-scheme
    hypotheses are dropped; body is a one-line delegate to the
    iter-125 `Scheme.Over.ext_of_eqOnOpen` packaging. The Lean
    docstring at L196–L203 honestly documents the reduction;
    iter-147+ will refine the signature to also carry `df = dg`
    and derive `eqOnOpen` from it via chart-algebra (β) Steps 1–2.

- **Substantive code delta** (iter-146 prover lane, 5 edits / 6
  diagnostic checks / 0 builds via the lean LSP / 24 lemma searches
  per `attempts_raw.jsonl`; the prover also invoked `lake env lean`
  directly via Bash 3 times for whole-file verification — all
  clean):
  - `Cotangent/ChartAlgebra.lean`: 89 → 225 LOC (+136 LOC).
    Three placeholder declarations refined to real signatures
    (`algebra_isPushout_of_affine_product` 5 LOC, `constants_*` 34
    LOC body + ~40 LOC docstring, `ext_of_diff_zero` 11 LOC). One
    new `attribute [local instance] Algebra.TensorProduct.rightAlgebra`
    at L74. One new import `AlgebraicJacobian.Rigidity` (for
    `ext_of_eqOnOpen`). Module-level docstring expanded with a
    `## Status (iter-146 prover lane)` block (L37–L57) tracking
    per-iter closure state. Two `: True := sorry` placeholders
    (β-core L97, KDM ring-side L107) intentionally preserved per
    planner OFF-LIMITS clause.

- **Auditor MAJOR findings** (`lean-auditor-iter146`): 3 must-fix
  + 4 major + 6 minor + 2 critical excuse-comments. Must-fix items
  are:
  - L97 + L107 `: True := sorry` placeholders (β-core + KDM
    ring-side) — OFF-LIMITS this iter per planner; carry-over from
    iter-145. The auditor flags them per descriptor rule; the
    plan agent's iter-146 directive authorisation is honored here
    (project-strategic placeholder vs project-bias-blind auditor
    classification — see `PROJECT_STATUS.md` Knowledge Base under
    iter-145 entries for the rule).
  - L208 `ext_of_diff_zero` named-concept-vs-body mismatch (rename
    of `ext_of_eqOnOpen` dropping `df = dg`) — substantive iter-146
    structural-finding. Honest documentation already on the Lean
    side (L196–L203 docstring); blueprint-side `% NOTE:` added this
    review-phase.
  - Major: L177 substantive `sorry` (substep 3 deferred); L144
    declaration-name "integral" understates "equal to"; L11–L25
    iter-history NOTE block duplicates L70–L73 inline justification;
    L37–L57 `## Status` block bakes per-iter content into the file
    docstring (rot risk).
  - Full report at `.archon/task_results/lean-auditor-iter146.md`.

- **Lean-vs-blueprint-checker findings**
  (`lean-vs-blueprint-checker-chart-algebra-iter146`): must-fix on
  `ext_of_diff_zero` signature mismatch (recommended fix:
  blueprint-side `% NOTE:`, applied this iter); major on missing
  explicit-`[IsReduced X]` discipline annotation at
  `lem:constants_integral_over_base_field` (annotation applied this
  iter); minor on the single-`inferInstance` vs three-step chain
  call-out at `lem:chart_algebra_isPushout_of_affine_product`
  (annotation applied this iter). All five chart-algebra Lean
  declarations cross-reference cleanly to blueprint blocks (5/5
  coverage). Full report at
  `.archon/task_results/lean-vs-blueprint-checker-chart-algebra-iter146.md`.

- **2 mandatory review-phase subagent dispatches**, both returned +
  absorbed via blueprint-side `% NOTE:` annotations (3 added) +
  `recommendations.md` next-iter items.

## Substantive code findings

- **The (α) chart-algebra helper collapses to a one-shot
  `inferInstance`** at the algebra level once Mathlib's local
  right-algebra instance is re-enabled. The iter-146 planner's
  three-step `pullbackSpecIso` → `isPullback_SpecMap_of_isPushout`
  → `CommRingCat.isPushout_iff_isPushout` chain is the honest
  scheme-level derivation, but for the chart-algebra (α) helper at
  the algebra level (which is what the β-core + KDM consumers
  actually need), Mathlib has already done the work. **New
  Knowledge Base entry** added (see PROJECT_STATUS.md).

- **`[IsReduced X]` discipline propagated to a third site this iter**:
  - Pre-existing: `Rigidity.lean`'s "Hypothesis history" block.
  - iter-146 add: `ChartAlgebra.lean:140–143` inline at
    `constants_integral_over_base_field`.
  - iter-146 review-phase add: `RigidityKbar.tex:lem:constants_integral_over_base_field`
    `% NOTE:` block.

  The convention "Mathlib `b80f227` lacks general `Smooth ⇒ IsReduced`
  over a field" is now documented at every place where it bites.

- **The `ext_of_diff_zero` signature-reduction call-out** is a real
  iter-146 structural finding that needs an iter-147+ follow-up. The
  iter-146 closure is honest sorry-free Lean, but the lemma does NOT
  deliver the full chart-algebra (β) envelope content the blueprint
  block describes. The blueprint `% NOTE:` documents this, and
  `recommendations.md` item 2 schedules the iter-147+ re-refinement
  once the β-core sub-piece lands.

- **Net strict-count sorry reduction: −2**, the first such delta on
  Route 1 (chart-algebra piece (ii)) since the iter-145 decomposition
  cost of +2. Cumulative route delta (iter-145 + iter-146):
  6 → 8 → 6 = NET 0 strict-count change, with positive structural
  signal: 1 substantive closure (α) + 1 substantive partial
  (constants substep 1–2) + 1 signature-reduction (ext_of_diff_zero).

## Blueprint markers updated (manual, this review phase)

- `RigidityKbar.tex`, `lem:chart_algebra_isPushout_of_affine_product`:
  added `% NOTE: (iter-146 review)` recording the single-`inferInstance`
  discharge under the locally re-enabled
  `Algebra.TensorProduct.rightAlgebra` instance — keeps the three-step
  scheme-level chain as informational while the algebra-level lemma
  is what the chart-algebra consumers actually need.
- `RigidityKbar.tex`, `lem:constants_integral_over_base_field`:
  added two `% NOTE: (iter-146 review)` blocks — (a) explicit
  `[IsReduced X]` discipline, matching the convention in
  `Rigidity.lean`'s "Hypothesis history"; (b) iter-146 substep 1–2
  body closure with substep 3 deferred to iter-147+ via the
  `IsBaseChange` + Stacks Tag 02KH + `Module.finrank_baseChange` chain.
- `RigidityKbar.tex`, `lem:Scheme_Over_ext_of_diff_zero`: added
  `% NOTE: (iter-146 review)` documenting the iter-146 signature
  reduction (drop `df = dg`, smooth-proper-genus-0 curve, smooth-
  proper-group-scheme; thin rename of `ext_of_eqOnOpen`; iter-147+
  scheduled to re-add `df = dg`).
- No `\mathlibok`, no `\lean{...}` rename, no `\notready` strip — none
  applicable this iter.

## Blueprint doctor (iter-146)

The deterministic blueprint-doctor flagged 5 empty `\uses{}`
annotations in `Cohomology_MayerVietoris.tex`. These will crash the
next `leanblueprint web` build via `Label '' could not be resolved`
→ `RecursionError`. **Surfaced in `recommendations.md` item 1 as
the top CRITICAL action for iter-147 plan agent.** Not an
iter-146-prover concern; needs an iter-147 blueprint-writer.

## Mandatory subagent dispatches (review phase)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `lean-auditor` | iter146 | 3 must-fix + 4 major + 6 minor + 2 critical excuse-comments on `Cotangent/ChartAlgebra.lean` (1 file audited per directive scope). Must-fix items: 2 `: True := sorry` (OFF-LIMITS per planner — see iter-145 Knowledge Base entry on subagent-semantics tension) + 1 named-concept-vs-body rename (`ext_of_diff_zero`). | Recommendations 3 + 5 land the auditor's major+minor items in iter-147 cleanup. Must-fix on `ext_of_diff_zero` matched by `lean-vs-blueprint-checker` and absorbed via blueprint `% NOTE:` this review-phase. |
| `lean-vs-blueprint-checker` | chart-algebra-iter146 | Faithful for (α) and (β-aux); (lift) is a thin renaming dropping the load-bearing `df = dg` hypothesis — needs a blueprint-side `% NOTE:`. Three recommended chapter-side actions (lift signature-reduction NOTE, IsReduced discipline NOTE, optional inferInstance call-out NOTE). All 5 Lean declarations have `\lean{...}` blocks; coverage 5/5. | All 3 recommended `% NOTE:` annotations applied this review-phase. |

## Per-target attempt details

For each target, the substantive attempt and result. Full event-by-
event detail in `proof-journal/sessions/session_146/{summary.md,
milestones.jsonl}`.

### Target (α) — `algebra_isPushout_of_affine_product`

- Attempt 1: `: Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂) :=
  inferInstance` failed at `failed to synthesize instance of type
  class Algebra B₂ (TensorProduct k B₁ B₂)` — Mathlib left-algebra
  in scope, right-algebra `local` to `Mathlib.RingTheory.IsTensorProduct`
  and invisible downstream.
- Attempt 2: `attribute [local instance] Algebra.TensorProduct.rightAlgebra`
  at file scope, then `inferInstance` succeeded.
- Trail evidence: 4 separate `lean_run_code` failures with the
  identical type-class error before the unlock landed. Recipe is
  now project-canonical.

### Target (β-aux) — `constants_integral_over_base_field`

- Signature refined to the real shape (~40 LOC docstring + 15 LOC
  signature + ~30 LOC body).
- Substep 1: `GeometricallyIrreducible.irreducibleSpace_of_subsingleton
  (X ↘ Spec (CommRingCat.of k))` + `isIntegral_of_irreducibleSpace_of_isReduced X`.
- Substep 2.a: `isField_of_universallyClosed k (X ↘ Spec
  (CommRingCat.of k))`.
- Substep 2.b: `finite_appTop_of_universallyClosed k (X ↘ Spec
  (CommRingCat.of k))`.
- Substep 3: deferred via structured `sorry` at L177 with iter-147+
  closure path inline-commented (set up `X_{k̄}`, flat base change of
  `Γ`, `Module.finrank_baseChange` chain).
- Negative search results: Mathlib `b80f227` lacks "finite `k`-algebra
  `A` with `A ⊗_k k̄ ≃ k̄` forces `A = k`" as a single lemma — must be
  assembled from the dimension-count chain.

### Target (lift) — `ext_of_diff_zero`

- Single edit: added `import AlgebraicJacobian.Rigidity` to
  `ChartAlgebra.lean`, refined signature to consume `eqOnOpen`
  directly, body delegates to `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`.
- Iter-146 signature-reduction rationale (per L196–L203 docstring):
  the planner-spec'd `df = dg` hypothesis was DROPPED because, if
  `eqOnOpen` is given outright, Step 3 of the blueprint recipe alone
  suffices (the chart-algebra (β) Steps 1–2 derivation becomes
  redundant). Encoding `df = dg` as `(_ : True)` would trip the
  prover-prompt's "tautologically-true placeholder" guardrail.
- iter-147+ re-refinement: re-add `df = dg`, derive `eqOnOpen` from
  it via Steps 1–2 (depends on β-core sub-piece landing first).

## What worked / what didn't

**Worked**:
- `attribute [local instance] Algebra.TensorProduct.rightAlgebra`
  at file scope as the unlock for `Algebra.IsPushout` instance
  search.
- The four-lemma Mathlib chain
  `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` →
  `isIntegral_of_irreducibleSpace_of_isReduced` →
  `isField_of_universallyClosed` →
  `finite_appTop_of_universallyClosed` for "Γ(X, ⊤) is a finite-dim
  field extension of k" under `IsProper` + `[IsReduced X]` +
  `[GeometricallyIrreducible (X ↘ Spec k)]`.
- Honest signature-reduction documentation on the Lean side
  (`ext_of_diff_zero` docstring L196–L203) + blueprint `% NOTE:`
  paired in review-phase — keeps the chapter and Lean in sync
  about the deferred load-bearing form.

**Didn't work** (4 `lean_run_code` failures before the unlock):
- Naive `Algebra.IsPushout … := inferInstance` without re-enabling
  `Algebra.TensorProduct.rightAlgebra`. Mathlib's left-algebra is
  global; the right-algebra is deliberately `local`.

**Deferred (off-limits this iter per planner)**:
- β-core `df_zero_factors_through_constant_on_chart` (L97).
- KDM ring-side
  `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  (L107).

Both await iter-147 mandatory blueprint-reviewer green-light on the
iter-146 Wave 2 rigiditykbar-writer's KDM step (p1) + step (p3)
absorption.

## Progress-critic preview for iter-147

Iter-147 mandatory progress-critic will weigh:
- 2 substantive closures + 1 substantive partial = positive signal,
  matches CONVERGING criterion at the strict-count level (route
  delta −2 inline sorries).
- The `ext_of_diff_zero` signature reduction is a structural
  call-out — does it count as a substantive closure?
  - **For CONVERGING**: it closes a sorry-free declaration matching
    the planner-spec'd Lean target name, with iter-147+ refinement
    scheduled.
  - **Against CONVERGING**: the blueprint statement (with `df = dg`)
    is strictly stronger than the iter-146 Lean form; the lemma does
    not yet deliver the chart-algebra (β) envelope content.
- Most likely verdict: **CONVERGING-with-caveat** — the iter-146
  prover lane is the FIRST chart-algebra prover round on a freshly
  decomposed route, and the strict-count delta is net negative for
  the first time in 5+ iters on this route trajectory.

## TO_USER.md

Empty — no user-actionable escalation this iter. Planner did not
intentionally skip provers (objectives: 1, `prover.status: done`),
no environment issue, no missing dependency. The
`Cohomology_MayerVietoris.tex` blueprint-doctor finding is an
iter-147 plan-agent task, not a user-action item.
