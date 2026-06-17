# Strategy Critic Report

## Slug

route176

## Iteration

176

## Routes audited

### Route: A — Picard scheme / Albanese via FGA

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` is the canonical construction; once A.4 lands an Albanese UP via Sym^g (Milne III §6), it satisfies the protected `IsAlbaneseFor` over `Over (Spec k)`.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III §6 is the textbook path; the per-sub-phase decomposition (A.2.a.i/ii/iii, A.2.b.i/ii/iii, A.4.a/b/c/d.i/d.ii) matches the references.
- **Sunk-cost reasoning detected**: no — the strategy explicitly considers and records-as-rejected the `Sym^g`/theta-divisor and `Pic⁰`-functor-of-points alternatives on merits (rejection reasons given).
- **Infrastructure-deferral detected**: yes — see "Infrastructure-deferral findings" below. The route depends on Stacks 052H flattening stratification, the Grassmannian/Quot stack, `GroupScheme.IdentityComponent`, an Auslander–Buchsbaum import at the form A.4.b needs, a Weil-divisor-on-surface API (A.4.a), and a `Sym^g`-of-schemes (A.4.d.i) — every one of these is goal-required (the final theorem statement is unprovable without them) and every one is currently `gated`/`file-skeleton open`/`pending` rather than under active body fill. The "Axiomatise-then-replace staging" open question is the explicit acknowledgement that the strategy may collapse to axioms; it is "TRACKED, NOT COMMITTED" with the trigger pushed to iter-180 — i.e. an additional ~4 iters of waiting before the strategy even decides whether to start building these in-tree.
- **Phantom prerequisites**:
  - `GroupScheme.IdentityComponent` — NOT in Mathlib (LSP search returned only `Subgroup.connectedComponentOfOne` for topological groups). Strategy names it under A.3 "Key Mathlib needs" without a project-side construction plan.
  - `LocallyConstantPushforward` — NOT verified in the form named. A.3 needs the scheme-level statement that the degree of a line bundle is locally constant in the base, which I could not locate.
  - `Sym^g`-of-schemes (S_g-quotient): NOT in Mathlib, strategy honestly lists it as new project material (~400–700 LOC), but no quotient-by-finite-group-scheme API is named as the substrate.
- **Effort honesty**: under-counted. The only validated velocity in the table is A.1.a at `~50/it`. Then:
  - A.2.a.ii claims 800–1300 LOC in ~3–5 iters → implied 160–433 LOC/it (3–9× realized).
  - A.2.a.iii claims 700–1400 LOC in ~3–5 iters → implied 140–467 LOC/it.
  - A.2.b.ii claims 800–1500 LOC in ~3–5 iters → implied 160–500 LOC/it.
  - A.2.b.iii claims 1200–2400 LOC in ~4–7 iters → implied 171–600 LOC/it (3–12× realized).
  - A.4.a claims 1500–2500 LOC in ~13–20 iters → implied 75–192 LOC/it on the dominant-risk phase.
  Aggregate "Total positive-genus arm: ~50–95 iters / ~9000–16000 LOC" implies ~95–320 LOC/it across the whole arm; at the realized ~50 LOC/it, the same LOC band lands at **~180–320 iters**. Either the iter band or the LOC band is fantasy. The strategy must pick a side.
- **Parallelism under-exploited**: no — 8 parallel-startable lanes named for the iter, consistent with the dependency graph.
- **Verdict**: CHALLENGE

### Route: C — genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k` trivially satisfies `IsAlbaneseFor` once `rigidity_over_kbar` is established for the curve, and the Spec-k-direct descent decision in Open Qs makes this concrete.
- **Mathematical soundness**: PASS — the `𝔾_m`-scaling shortcut is sound (consumes proven Cor 1.5 + density + `ext_of_isDominant`), and the RR-bridge to `ℙ¹` is the standard Hartshorne IV.1.3.5 path.
- **Sunk-cost reasoning detected**: yes — verbatim: *"STUCK 5 consec iters; iter-175 PARTIAL was session-limit damaged; option (a) STRICT one-shot iter-176"*. The "one more try, same recipe" framing after five iters at ~0/it is textbook sunk-cost — the strategy explains why iter-175 didn't complete (session-limit) but does not argue why iter-176 will, except that the recipe will now be applied "AS WRITTEN". The reversal trigger ("if iter-176 closes 0 Step C sorries, iter-177 escalates to user via TO_USER.md") is too weak: it permits the same recipe to consume another iter of planner attention even on total failure. Recommendation: harden to a HARD STOP — on iter-176 not closing ≥1 Step C sorry, automatically commit to the differential `H⁰(ℙ¹, O(-2))=0` char-0 sub-case AND surface an `axiom`-shortcut option in `TO_USER.md` the same iter.
- **Infrastructure-deferral detected**: yes — the hardest prerequisite of Route C across the last 5 iters has been `gmScalingP1` body fill (chart-bridge structural pivot). Successive route-narrows have changed the surface recipe (`option (a)`, `option (b)`, `option (c)`, chart-algebra envelope, then split-into-4-files, then `congrHom`-arg restructure) but not the underlying construction being requested. This is the second-failure-mode of "pivots that move the same hard problem one layer deeper" rather than introducing a different mathematical reduction. A genuine pivot would be either (i) admit a temporary `axiom gmScalingP1_constant : ∀ (f : ℙ¹_{k̄} → A), Function.const _ (f 0) = f` and use it to close the genus-0 witness now (with `-- TODO: replace`), or (ii) drop `gmScalingP1` entirely and finish `ℙ¹→A const` via `H⁰(ℙ¹, O(-2))=0` (char-0 sub-case). Both are mathematically sound exits the strategy treats as merely "reversal triggers" pushed to a later iter.
- **Phantom prerequisites**: none additional — `Scheme.Cover.glueMorphisms` VERIFIED; `Proj.fromOfGlobalSections` VERIFIED.
- **Effort honesty**: under-counted (the `gmScalingP1` row is internally inconsistent). The row reads `Iters left: ~2–4 | LOC: ~80–150 | velocity: ~0/it (5 iters realized)`. At literally zero realized progress across five iters, "~2–4 iters left" is not a forecast, it is a hope. Either the velocity claim is wrong (i.e. there has been silent partial progress not surfaced in `realized/it`) or the iter band is wrong. The other genus-0 rows (RR.2 `~0/it` realized, RR.3 / RR.4 `gated`) inherit the same opacity. Re-estimate: the genus-0 arm total ("~14–25 iters") cannot be trusted while a single row sits at ~0/it × 5.
- **Parallelism under-exploited**: no — `gmScalingP1` and RR.1 are listed as concurrent prover lanes; RR.2/3/4 are correctly sequential after RR.1.
- **Verdict**: CHALLENGE

## Format compliance

- **Size**: 159 lines / 11.6 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order.
- **Per-iter narrative detected**: yes — verbatim examples: *"A.2.c — FGA `Pic_{C/k}` assembly chapter LANDED iter-174"* (status cell); *"Axiomatise-then-replace staging (NEW — strategy-critic CHALLENGE)"* (Open Qs); *"STUCK 5 consec iters; iter-175 PARTIAL was session-limit damaged; option (a) STRICT one-shot iter-176"* (status cell); *"Decision trigger: if iter-180 Route A velocity remains ~0/it"* (Open Qs); *"Planned: 7 more file-skeletons under Picard/, Albanese/, RiemannRoch/ (opening this iter and iter-176)"* (gaps section, on-disk variant); *"if iter-176 closes 0 Step C sorries with option (a) on file, iter-177 escalates to user via TO_USER.md"* (Open Qs). At least six specific iter numbers appear inline.
- **Accumulation detected**: no — completed phases remain as status rows (correct), and rejected alternatives are kept as compact one-liners (acceptable for skeleton).
- **Table discipline**: PASS — table form, LOC cells carry both `remaining · realized/it`. Internal arithmetic inconsistencies are flagged as effort-honesty issues, not table-form violations.
- **Appendix sections**: none detected.
- **Format verdict**: DRIFTED

The doc is the right shape, but per-iter narrative has colonized status cells and the Open Qs section. Strip iter numbers from status cells (replace "iter-174" with "landed"); strip the "(NEW — strategy-critic CHALLENGE)" attribution from the axiomatise-staging item; strip the "iter-180" / "iter-176" / "iter-177" deadlines from Open Qs (use abstract triggers like "next stuck iter" or "after one more stuck iter"). Move the chart-bridge narrative wholesale to the iter sidecar.

## Infrastructure-deferral findings

### Deferred: Stacks 052H flattening stratification

- **Required by goal**: yes — A.2.b.ii (flat-locus open subscheme) is a precondition of Quot representability, which is in the FGA Pic critical path for the positive-genus arm.
- **Current plan for building it**: in-tree, ~2000–3500 LOC across A.2.a.i/ii/iii.
- **Timeline**: vague — A.2.a.i is "chapter LANDED; sub-phase pending" with no file-skeleton; the per-sub-phase iter band (3–5 each) is **gated**, no realized velocity.
- **Verdict**: CHALLENGE — concrete file-skeleton plus a first-LOC commitment is needed THIS iter to confirm the route is actually being pursued, not just budgeted. Without one, the "Axiomatise-then-replace" trigger at iter-180 is the de-facto plan, which should be explicit.

### Deferred: Quot scheme + Grassmannian (Nitsure §5)

- **Required by goal**: yes — Quot is the engine for `Pic_{C/k}` representability.
- **Current plan for building it**: in-tree, ~2600–5000 LOC across A.2.b.i/ii/iii.
- **Timeline**: vague — all three sub-phases gated, no skeleton, no realized velocity.
- **Verdict**: CHALLENGE — same as 052H. Either a concrete file-skeleton lands or the axiomatise-staging is committed.

### Deferred: `GroupScheme.IdentityComponent`

- **Required by goal**: yes — A.3 produces `Pic⁰` as the identity component of `Pic`.
- **Current plan for building it**: none — the strategy lists it under A.3 "Key Mathlib needs" with no project-side construction plan and no Mathlib PR pointer.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — either name a project file/module that will define `GroupScheme.IdentityComponent` (with a LOC estimate), or commit to upstreaming with an external Mathlib-PR tracker. As a pure "Mathlib need" with no owner, this is exactly the goal-required-but-unowned construction the deferral check is designed to surface.

### Deferred: `Sym^g`-of-schemes (S_g quotient)

- **Required by goal**: yes if A.4.d.ii is wired via Milne Prop 6.1 (which the strategy commits to). The protected `IsAlbaneseFor` UP needs the Sym^g–Pic⁰ correspondence for the unpointed-positive-genus arm.
- **Current plan for building it**: in-tree, ~400–700 LOC at A.4.d.i.
- **Timeline**: gated; no skeleton.
- **Verdict**: CHALLENGE — finite-group-scheme quotient is the substrate; the strategy does not name how it will obtain it.

### Deferred: gmScalingP1 body (genus-0)

- **Required by goal**: yes (under current Route C — `ℙ¹→A` constant via 𝔾_m-scaling). NOTE: an alternative `H⁰(ℙ¹,O(-2))=0` route would NOT need it, so this is conditionally goal-required.
- **Current plan for building it**: chart-bridge structural pivot per `analogies/chart-bridge-structural-pivot.md`, applied as a STRICT one-shot this iter.
- **Timeline**: ~2–4 iters (table) but contradicted by ~0/it × 5 prior iters (status cell).
- **Verdict**: CHALLENGE — either (a) demote `gmScalingP1` to an admitted `axiom` with `-- TODO: replace`, completing the genus-0 arm immediately, or (b) commit NOW to the differential char-0 sub-case so iter-177 is not yet another "option (a) one more try" cycle. The current strategy budgets a sixth `gmScalingP1` attempt.

## Alternative routes (suggested)

### Alternative: Genus-0 via temporary `axiom gmScalingP1_constant`

- **What it looks like**: introduce `axiom gmScalingP1_constant : ∀ (f : (P1 k̄) ⟶ A), ...` in a `-- TODO: replace by chart-bridge body` block, finish the genus-0 witness arm in 1–2 iters, then return to the chart-bridge as a deferred refactor target after the global witness is `nonempty_jacobianWitness`-closed.
- **Why it might be cheaper or sounder**: the end-state demands kernel-only axioms, but achieving an end-to-end build that is one axiom away from completion is more diagnostic than a partial build where neither arm closes. It exposes whether the positive-genus arm closes cleanly above the genus-0 witness body and isolates the chart-bridge as a contained piece of debt. Most importantly, it provides a HARD STOP to the 5-iter stuck pattern by making "finish anyway" the path of least resistance.
- **What the current strategy may have rejected**: the strategy considers axiomatise-then-replace ONLY for Route A items (Stacks 052H, Grassmannian, Quot, FGA Pic representability) — not for Route C residuals. There is no recorded rejection reason, which is itself a smell: the same workflow option should be available to both arms.
- **Severity of the omission**: major

### Alternative: Differential `H⁰(ℙ¹, O(-2)) = 0` for the genus-0 base (char-0 sub-case)

- **What it looks like**: in char 0, every `f : ℙ¹ → A` pulls back invariant 1-forms ω ∈ H⁰(A, Ω¹_A); the pullback `f^* ω ∈ H⁰(ℙ¹, Ω¹_{ℙ¹})` lives in `H⁰(ℙ¹, O(-2)) = 0` (Hartshorne III.5.1.a + ω_{ℙ¹} ≅ O(−2) Ex.II.8.20.1), so `df = 0`, so `f` is constant. References already in `references/hartshorne-algebraic-geometry.md`.
- **Why it might be cheaper or sounder**: skips the chart-algebra entirely; uses results the strategy already has reference cards for. Genuine "different prerequisite" — neither `gmScalingP1` nor any `ChartIso`-side construction appears.
- **What the current strategy may have rejected**: named as the iter-177 reversal trigger, not committed. Char-0-only is the listed weakness, but char-general support can be salvaged later via Frobenius descent — and the goal of `nonempty_jacobianWitness` is char-general only IF the project really targets `Field k` without `CharZero`. Spot-check the protected signatures to confirm.
- **Severity of the omission**: major — this is the strategy's own stated reversal trigger, and ought to be committed at first failure rather than after another full iter of `option (a)` retry.

### Alternative: A.4 / A.3 via Pic⁰ representability as a `Set.Functor` (no full Pic scheme)

- **What it looks like**: at the protected-signature level, `Jacobian` only needs to be a scheme with an `IsAlbaneseFor` certificate. One could construct `J` as a corepresenting object of the Pic⁰ functor restricted to a small skeleton of test schemes, bypassing both full Pic_{C/k} representability and `Sym^g`. Concretely, one builds the universal pair (J, L_univ) via the abstract sheafification of Pic⁰ on the étale site, without proving the full Quot-based representability.
- **Why it might be cheaper or sounder**: skips A.2.a, A.2.b, and A.4.d.i — which together carry ~6000–10000 LOC of pure Mathlib infrastructure. Would still need A.4.a (codim-1) for Albanese UP, but reduces the strategic surface area substantially.
- **What the current strategy may have rejected**: the strategy mentions `Pic⁰`-functor-of-points Albanese-UP as REJECTED on "strict bypass — shifts the codim-1 content from A.4.a into A.2.c rather than eliminates it". That is an honest answer for codim-1 specifically, but does not address the larger A.2.a/A.2.b elimination this variant offers.
- **Severity of the omission**: minor — needs a literature check (does abstract sheafification of Pic⁰ produce a scheme without Quot? not obviously yes).

## Sunk-cost flags

- `"STUCK 5 consec iters; iter-175 PARTIAL was session-limit damaged; option (a) STRICT one-shot iter-176"` — Why this is sunk-cost: a sixth attempt at the same recipe is being framed as a fresh strict-once attempt because iter-175 was operationally truncated, not because new insight makes the recipe likelier to succeed. Recommendation: reframe on merits — if the recipe failed five times for *mathematical* or *Lean-API* reasons, it will fail a sixth; if the only failure mode was session-limit, dispatch under a stricter time budget AND attach a HARD STOP that commits to the differential alternative on any non-closing outcome.
- `"if iter-180 Route A velocity remains ~0/it on the file-skeleton lanes opening this iter, escalate to user-level option-choice"` — Why this is sunk-cost: ~0/it across multiple lanes simultaneously is information *now*, not at iter-180. Recommendation: define a concrete LOC-per-iter floor (e.g. "if A.2.a / A.2.b / A.4.b together fail to land ≥150 LOC over two iters") that triggers the option-choice surfacing IN-LINE, not at a calendar date 4 iters out.

## Prerequisite verification

- `AlgebraicGeometry.Scheme.Cover.glueMorphisms`: VERIFIED (Mathlib.AlgebraicGeometry.Gluing).
- `AlgebraicGeometry.Proj.fromOfGlobalSections`: VERIFIED (Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic).
- `GroupScheme.IdentityComponent`: MISSING (only topological-group `Subgroup.connectedComponentOfOne` exists; no scheme-level identity component).
- `LocallyConstantPushforward` (in the form for A.3's degree map): MISSING — no direct hit.
- `Sym^g`-of-schemes / S_g-quotient: MISSING (only `MulAction.QuotientAction` for sets/modules).
- Stacks 052H flattening stratification: MISSING (only `Module.freeLocus` API exists, not a full stratification by Hilbert polynomial).
- Auslander–Buchsbaum at the form A.4.b needs: PARTIAL — `CategoryTheory.projectiveDimension` exists; no `Module.depth` of the required scheme-theoretic form located.

## Must-fix-this-iter

- Route A: CHALLENGE — effort estimates not internally consistent with realized ~50 LOC/it on A.1.a. Either narrow the LOC bands on A.2.a/A.2.b/A.4.a (cut by 2–3×) or widen the iter bands to ~180–320-iter total scale. Pick one; the current table cannot be both.
- Route A: CHALLENGE — `GroupScheme.IdentityComponent`, `Sym^g`-of-schemes, and `Stacks 052H` are listed as Mathlib needs without project-side owners or skeleton commitments. Either name the project file that will build each (with LOC estimate) or commit to the axiomatise-staging trigger immediately rather than at iter-180.
- Route C: CHALLENGE — `gmScalingP1` row internally inconsistent (~0/it × 5 vs ~2–4 iters left). Re-estimate the row OR introduce the temporary `axiom gmScalingP1_constant` alternative as a strategy-blessed exit. The "STRICT one-shot iter-176" is acceptable only if backed by a HARD STOP (no iter-177 option-(a) retry) committing to the differential char-0 sub-case on any non-closing outcome.
- Alternative `temporary axiom gmScalingP1_constant`: major omission — Route C lacks the axiomatise-staging workflow option that Route A has; add it under Open Qs.
- Alternative `differential H⁰(ℙ¹, O(-2)) = 0` char-0: major omission — currently demoted to a reversal trigger after one more iter; should be promoted to a concurrent lane this iter to break the stuck pattern.
- Phantom prerequisite `GroupScheme.IdentityComponent`: not in Mathlib. Either a project-side build plan or an explicit upstream-PR tracker must appear under "Mathlib gaps & new material".
- Format: DRIFTED — strip iter numbers from status cells (e.g. `"chapter LANDED iter-174"` → `"chapter LANDED"`), strip "(NEW — strategy-critic CHALLENGE)" attribution, strip the iter-176/177/180 deadlines from Open Qs (use abstract triggers like "after one more stuck iter"). Move the `gmScalingP1` narrative to the iter sidecar.

## Overall verdict

Both routes are mathematically sound and goal-aligned, but each has a serious planner-side problem the strategy must address before iter-176 prover dispatch. **The strategy defers `GroupScheme.IdentityComponent`, `Sym^g`-of-schemes, and Stacks 052H flattening stratification, which are required for the stated goal** under the chosen Route A, and assigns no project-side owner or concrete timeline to the first of those — only a "Mathlib need" label. Route A's effort table is arithmetically inconsistent with the only validated velocity (~50 LOC/it on A.1.a vs implied 140–600 LOC/it on A.2.a/A.2.b/A.4.a sub-phases); at realized rate, the positive-genus arm is a ~180–320-iter task, not the ~50–95 iters claimed. Route C's `gmScalingP1` row is a sunk-cost trap: five iters at zero realized velocity dressed as "~2–4 iters left" with a sixth attempt at the same recipe authorized by the "iter-175 session-limit" caveat. The right corrective is to commit a HARD STOP — on iter-176 not closing ≥1 Step C sorry, automatically commit the differential char-0 alternative AND surface a `temporary axiom gmScalingP1_constant` option in `TO_USER.md` the same iter — rather than budgeting another `option (a)` retry at iter-177. Format-wise the doc is DRIFTED: iter numbers have colonized status cells and Open Qs; an in-place restructure this iter to abstract those out is owed.

route176: CHALLENGE — 2 routes audited, 2 CHALLENGE verdicts, 5 infrastructure-deferral findings, format=DRIFTED
