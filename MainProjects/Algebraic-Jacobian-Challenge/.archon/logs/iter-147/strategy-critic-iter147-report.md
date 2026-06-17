# Strategy Critic Report

## Slug
iter147

## Iteration
147

## Routes audited

### Route: Route C (M2 critical path) — chart-algebra piece (ii)

- **Goal-alignment**: PASS — the chart-algebra envelope feeds `rigidity_over_kbar` → `genusZeroWitness` → genus-stratified body of `nonempty_jacobianWitness`. The route ends at the protected declaration's genus-0 arm without smuggling in a $C(k) \neq \emptyset$ hypothesis (the vacuity branch via `Classical.byCases` over `P : 𝟙_ _ ⟶ C` is correctly cited under `## Soundness rules`).
- **Mathematical soundness**: PARTIAL — the three-layer "df=0 derivation chain" (chart-Kähler kernel + chart-Čech MV on $\Omega^{\oplus n}$ + char-p Frobenius patch) is plausible *as an avoidance of Serre duality*, but the strategy elides a real subtlety. The MV sequence on $\Omega^{\oplus n}$ gives
  `0 → H^0(C, F) → H^0(U_1, F) ⊕ H^0(U_2, F) → H^0(U_1∩U_2, F) → H^1(C, F) → 0`
  and *deducing $H^0 = 0$ on a genus-0 curve* via this sequence requires that the middle map be injective — which is exactly the chart-algebra content the route hopes to extract. The phrasing "reusing the existing `H^1(C, O_C) = 0` MV infrastructure" is slightly misleading: the $\mathcal{O}_C$ vanishing is a $H^1$ statement, while what is needed for $\Omega$ is an $H^0$ statement on a different sheaf — the infrastructure may need genuine adaptation, not just instantiation. STRATEGY.md should either (a) state explicitly that the chart-Čech MV machinery for $\Omega^{\oplus n}$ is new, or (b) name the reusable lemma it is instantiating.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags below for the "Pivot drivers (historical, iter-144)" block in this route.
- **Phantom prerequisites**:
  - `Algebra.IsStandardSmooth.free_kaehlerDifferential` — could not verify (rate limit); the parent class `Algebra.IsStandardSmooth` exists in `Mathlib.RingTheory.Smooth.StandardSmooth` but the named lemma may not. Planner should cite a `lean_local_search` / `lean_loogle` confirmation in plan.md or rename to whatever the actual Mathlib lemma is.
- **Effort honesty**: reasonable — ~400–800 LOC over 4–6 iters for the remaining β-core + KDM + final-substep of constants is in line with the existing 5-block scaffold size.
- **Verdict**: CHALLENGE — the MV-on-$\Omega^{\oplus n}$ ↔ existing-MV-infra equivalence needs a one-line citation; the (β-core) Čech MV step is the load-bearing piece of the entire M2 critical path, and "reusing existing infrastructure" cannot stand as the only justification.

### Route: Route A (M3 off-critical-path) — Picard scheme via FGA

- **Goal-alignment**: PASS — Picard scheme + identity-component subgroup scheme is the canonical algebraic construction of the Jacobian; feeds `positiveGenusWitness` and thus the genus≥1 arm of `nonempty_jacobianWitness`.
- **Mathematical soundness**: PASS — FGA Hilbert/Quot representability is well-trodden algebraic geometry. The decomposition A.1–A.4 is named but not visible from STRATEGY.md itself.
- **Sunk-cost reasoning detected**: yes — the dismissal of Route B ("symmetric powers + Stein — dropped as historical alternative per iter-144 user-hint") is given purely on iter-history grounds. The iter-126 user hint ("do the work; no axioms") plausibly does not force Route A over Route B; it just forbids upstream-PR gating. A fresh mathematician asks: "why Hilbert/Quot, given that for curves $\mathrm{Sym}^g \to \mathrm{Pic}^g$ is a classical and more concrete route?" — and STRATEGY.md owes that question a merit-based answer.
- **Phantom prerequisites**: the route names "Hilbert/Quot representability; identity-component subgroup scheme; fppf/étale topologies; Picard pre-functor; flattening stratification; coherent-of-finite-type" without citation. Each is a multi-thousand-LOC Mathlib gap. The strategy promises to write them in-tree, which is fine *if the in-tree LOC midpoint reflects that scope* — see effort below.
- **Effort honesty**: under-counted — 6070 LOC for the union of {Hilbert scheme of points, Quot scheme of coherent sheaves, fppf/étale topologies + sheafification, flattening stratification, identity-component subgroup scheme, Picard pre-functor, coherent-of-finite-type infrastructure} is aggressive. Hilbert and Quot representability alone in any classical write-up is 100s of pages of dense algebraic geometry. The 6070 midpoint reads more like the cost of *one* of those pieces, not the bundle. If the bundle estimate is anchored to `analogies/m3-route-a-refresh-iter145.md` (which the critic does not read), STRATEGY.md should re-state the basis of the estimate in one line so a fresh reader can sanity-check it.
- **Verdict**: CHALLENGE — re-justify Route A on merits over Route B in one paragraph (one-line is acceptable if the case is clear); reconcile the 6070-LOC midpoint with the named sub-pieces. Route A is *probably* correct but the strategy currently presents it as inherited rather than chosen.

## Format compliance

- **Size**: 167 lines / ~7.6 KB — within budget (~250 lines / ~12 KB).
- **Headings**: FAIL — extra top-level `## Soundness rules` section (explicitly named in the canonical-skeleton violation list as a renamed/extra heading). The canonical set is `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in that order. `## Soundness rules` is a sixth section that must be dissolved — its mathematically-binding content (no-axioms, no-rational-point, df=0 layer chain) should fold into `## Routes` (the layer chain is part of Route C's argument) and `## Mathlib gaps & new material` (the "converse of `smooth_locally_free_omega` is false" caveat). The "User-hint citation discipline" subsection is pure iter-126/iter-144 history and belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Per-iter narrative detected**: yes — pervasive. Representative samples (verbatim):
  - `iter-146 closed (α)+(lift); (constants) PARTIAL; (β-core)+(KDM) deferred`
  - `Pivot drivers (historical, iter-144): bundled-route piece (i.b)+(i.c)+(iii) DESCOPED + EXCISED iter-145`
  - `iter-150+ RelativeSpec trigger preserved per iter-142`
  - `iter-147+ refines signature to also carry df = dg via β-core`
  - `(DONE iter-128 → iter-132)`
  - `iter-126 user hint reaffirmation`
  - `The iter-143 fix extracted basechange_along_proj_two_inv_app_isIso from such an inline letI`
  - At least ~25 distinct iter-NNN tokens (iter-125, 126, 128, 132, 142, 143, 144, 145, 146, 147+, 150+, 170+) throughout the file.
- **Accumulation detected**: yes — examples:
  - In Route C: the (α) and (lift) bullets stay listed as "CLOSED iter-146" with no functional purpose for the planner. Closed pieces should disappear from `## Routes`; the route should describe only what remains.
  - In `## Open strategic questions`: "Iter-147+ cleanup of 5 orphan helpers in Cotangent/GrpObj.lean (shearMulRight + companions, schemeHomRingCompatibility, isIso_of_app_iso_module, relativeDifferentialsPresheaf_restrict_along_identity_section)" — this is an operational task list, not a strategic question.
  - "Route B — symmetric powers + Stein — dropped as historical alternative per iter-144 user-hint" — historical-rejected-alternative anchor.
  - "Rigidity.lean ext_of_eqOnOpen (iter-125; consumed by both Route C and ext_of_diff_zero thin-renaming)" — completed scaffolding citation.
- **Table discipline**: PASS-with-DRIFT — columns are correct (Phase | Status | Iters left | LOC | Key Mathlib needs | Risks), but the Status cell of the M2.body-pile row is a 3-clause iter-narrative phrase (`iter-146 closed (α)+(lift); (constants) PARTIAL; (β-core)+(KDM) deferred`) rather than a one-line status; the Key-Mathlib-needs cells in rows 3 and 5 are also over-long.
- **Appendix sections**: `## Soundness rules` functions as an appendix of historical rules and constraints (six bullets, one of them — "User-hint citation discipline" — purely an iter-126/iter-144 historical reading). Treat as an appendix-section violation.
- **Format verdict**: NON-COMPLIANT — the document violates the canonical skeleton in three independent ways (extra section, pervasive iter-narrative, accumulation), and the extra section + appendix character means a non-trivial restructure is needed, not a cleanup pass. (Iter-146 critic flagged "Format NON-COMPLIANT" at 701 LOC; the file has shrunk to 167 LOC but the structural violations — extra section, iter narrative — remain.)

## Alternative routes (suggested)

### Alternative: M3 via $\mathrm{Sym}^g(C) \to \mathrm{Pic}^g(C)$ (Route B, revived)

- **What it looks like**: For a smooth proper geometrically irreducible curve $C/k$ of genus $g \ge 1$, construct the Jacobian as the Stein factorization (or schematic image) of the Abel–Jacobi map $\mathrm{Sym}^g(C) \to \mathrm{Pic}^g(C)$. The symmetric product $\mathrm{Sym}^g(C)$ is a smooth projective $k$-scheme constructed via GIT-quotient of $C^g$ by $S_g$. For $g \ge 1$, the Abel–Jacobi map is birational onto its image, and Stein factorization gives the Jacobian directly. Group structure comes from the universal property of $\mathrm{Pic}^0$.
- **Why it might be cheaper or sounder**: it avoids Hilbert/Quot representability (the most expensive single piece of Route A), avoids flattening stratification, and avoids the identity-component-of-a-group-scheme construction (because $\mathrm{Pic}^g$ is already connected and the translation by a divisor gives the identity component). The infrastructure it needs — symmetric product of a scheme by a finite group action, Stein factorization, schematic image — is closer to existing Mathlib (symmetric products of varieties / GIT quotients by finite groups exist in `Mathlib.Algebra.GroupAction.Quotient` family, Stein factorization is a standard piece of EGA). It also handles the no-rational-point case more transparently: the construction is purely over `Spec k`.
- **What the current strategy may have rejected**: the iter-144 user hint pivot. STRATEGY.md cites only "dropped as historical alternative per iter-144 user-hint" — which is not a merit-based reason. Plausible *merit-based* objections (Sym^g not having a global $k$-rational point either, the need for genus-specific case analysis, Stein factorization for non-proper morphisms being tricky) are not stated. Plausible counter: $\mathrm{Sym}^g(C)$ over a curve without a $k$-point may still lack a $k$-rational base point, but so does $\mathrm{Pic}^0$ via FGA — both routes face the same vacuity-branch obligation.
- **Severity of the omission**: major — given Route A's 6070-LOC midpoint and the named-but-unbudgeted dependencies (Hilbert/Quot, flattening, identity-component construction), an alternative that might come in at 30–50% of the LOC budget is not optional to weigh.

### Alternative: M2 chart-algebra via Stein factorization over $\bar k$ + descent

- **What it looks like**: prove rigidity-over-$k$ by base-changing to $\bar k$ where genus-0 forces $C_{\bar k} \cong \mathbb{P}^1_{\bar k}$, applying rigidity for $\mathbb{P}^1$ to morphisms to a group scheme directly (a much smaller fact), then descending to $k$ via Galois descent for morphisms of schemes.
- **Why it might be cheaper or sounder**: rigidity for $\mathbb{P}^1_{\bar k}$ → group scheme is short and clean (any morphism factors through a point because $\mathbb{P}^1$ has no non-constant morphisms to a group). The Galois descent step is a single application of fpqc descent for morphisms. This avoids the chart-Čech MV on $\Omega^{\oplus n}$ + KDM char-p + (β-core) chain entirely.
- **What the current strategy may have rejected**: `## Open strategic questions` does mention an "iter-150 over-k vs over-`k̄` symmetric audit" — so the option is on the planner's radar but is deferred behind a rolling trigger. The strategy does not state *why* the chart-algebra envelope was chosen over base-change-and-descend in the first place. Plausible counter: the descent step is itself non-trivial and may require its own MV / sheaf-of-morphisms infrastructure that Mathlib lacks.
- **Severity of the omission**: major — the over-`k̄` route should be on the explicit Routes list with a merit-based comparison, not parked behind a trigger condition.

## Sunk-cost flags

- `Pivot drivers (historical, iter-144): bundled-route piece (i.b)+(i.c)+(iii) DESCOPED + EXCISED iter-145 (only piece (i.a) cotangentSpaceAtIdentity trio retained from Cotangent/GrpObj.lean); pivot saves ~740–1840 LOC.` — Why this is sunk-cost: the entire block justifies the current chart-algebra route in terms of what was previously descoped, not in terms of why chart-algebra is the right approach for piece (ii). Recommendation: replace the "pivot drivers" paragraph with a single line stating the *current* reason for the chart-algebra route on its merits — i.e. why a chart-Kähler kernel + Čech MV + Frobenius chain is the right way to derive `df = 0`. The historical pivot belongs in `iter/iter-144/plan.md`, not in STRATEGY.md's Route description.

- `Route B — symmetric powers + Stein — dropped as historical alternative per iter-144 user-hint` — Why this is sunk-cost: the user-hint reading is itself an iter-126/iter-144 historical artifact. Recommendation: state the present-day merit-based reason Route A beats Route B (e.g. "Route B's GIT-quotient construction needs Mathlib infrastructure for $S_n$-quotients of schemes that is no closer to existence than Hilbert/Quot, *and* Sym^g + Stein still requires an identity-component construction"). If no such reason holds, the planner should re-evaluate Route A vs Route B on merits.

- `the iter-126 user hint ("do the work; no axioms; ~6500–9000 LOC may not be that much for an AI") was clarified iter-144` — Why this is sunk-cost: the entire "User-hint citation discipline" bullet under `## Soundness rules` is an iter-126 + iter-144 historical reading. Recommendation: STRATEGY.md should encode rules that *currently* apply (no new axioms — kept; no upstream-PR gating — kept) without anchoring them in past user hints. The hints have done their work; the rule is the residue.

- `Iter-147+ cleanup of 5 orphan helpers in Cotangent/GrpObj.lean (shearMulRight + companions, ...)` — Why this is sunk-cost: orphans of previous routes are listed as a strategic question rather than being either (a) deleted now, or (b) demoted to a `task_pending.md` chore. Recommendation: this is operational debt, not a strategic question; move it to `task_pending.md`.

## Prerequisite verification

- `RingHom.iterateFrobenius_comm`: VERIFIED — `Mathlib.Algebra.CharP.Frobenius`, signature `(g : R →+* S) (p : ℕ) [ExpChar R p] [ExpChar S p] (n : ℕ) : g.comp (iterateFrobenius R p n) = (iterateFrobenius S p n).comp g`.
- `Algebra.IsStandardSmooth`: VERIFIED — `Mathlib.RingTheory.Smooth.StandardSmooth`.
- `Algebra.H1Cotangent`: VERIFIED — `Mathlib.RingTheory.Extension.Cotangent.Basic`. The `Subsingleton (Algebra.H1Cotangent A B)` soundness-rule citation is anchored on a real object.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: UNVERIFIED — rate limit prevented confirmation. Planner should cite the actual Mathlib name in plan.md (or `lean_local_search` it before scheduling β-core).
- `Scheme.Over.ext_of_eqOnOpen`: UNVERIFIED — referenced as iter-125-landed project material, not Mathlib; not a phantom-Mathlib concern.
- `KaehlerDifferential.D`: UNVERIFIED — rate limit prevented confirmation. This is *core* Mathlib and almost certainly exists, but the planner should still cite a one-line `lean_hover_info` confirmation in plan.md before scheduling β-core (cheap to do; eliminates the only residual phantom concern).

## Must-fix-this-iter

- **Route C: CHALLENGE** — STRATEGY.md must either (a) cite the specific reusable lemma underwriting the "chart-Čech MV on $\Omega^{\oplus n}$" step (claimed as "reusing the existing `H^1(C, O_C) = 0` MV infrastructure"), or (b) state that the chart-Čech MV on $\Omega^{\oplus n}$ is genuinely new infrastructure and budget it in `## Mathlib gaps & new material`. One sentence either way.
- **Route A: CHALLENGE** — re-justify Route A on merits relative to Route B (Sym^g + Stein) in one paragraph; reconcile the 6070-LOC midpoint against the named sub-pieces (Hilbert + Quot + flattening + identity-component + fppf sheafification + Picard pre-functor + coherent-of-finite-type) so a fresh reader can sanity-check.
- **Alternative "over-$\bar k$ + descent" (M2): major** — explicitly compare against Route C on merits, or commit to the chart-algebra envelope by name (not by elimination). Currently parked behind an iter-150 rolling trigger; a fresh mathematician would expect this to be a present-tense alternative on the `## Routes` list.
- **Format: NON-COMPLIANT** — STRATEGY.md must be restructured this iter. Three impactful deviations: (i) dissolve the extra `## Soundness rules` section into `## Routes` / `## Mathlib gaps & new material` and move the "User-hint citation discipline" bullet out entirely; (ii) excise per-iter narrative throughout (~25 iter-NNN tokens), in particular the "Pivot drivers (historical, iter-144)" block in Route C and the iter-NNN status-line phrasing in the `## Phases & estimations` table; (iii) remove accumulation (closed sub-pieces (α)+(lift) in Route C, the iter-125 ext_of_eqOnOpen reference in `New project material introduced`, the iter-128→132 cotangentSpaceAtIdentity historical citation, and the "Iter-147+ cleanup of 5 orphan helpers" operational-debt bullet from `## Open strategic questions`). Move any historical detail that needs preserving to `iter/iter-147/plan.md`.

## Overall verdict

A fresh mathematician reading this STRATEGY.md would say: the destination (nine protected declarations, vacuity-branch-honest, no axioms) is clear and correctly framed, and the two named routes (Route C for M2, Route A for M3) are plausible algebraic-geometry choices — but the document presents both routes as inherited from prior iterations rather than chosen on present-day merits. The chart-algebra envelope's load-bearing step (Čech MV on $\Omega^{\oplus n}$ yielding $H^0 = 0$ on a genus-0 curve) is asserted without naming the lemma it reuses; the FGA Picard route is preferred over symmetric-powers-plus-Stein with no merit-based justification; the over-$\bar k$ descent alternative is parked rather than weighed. Together with a NON-COMPLIANT format (extra `## Soundness rules` section, ~25 iter-NNN tokens of per-iter narrative, three categories of accumulation), the strategy is structurally not the canonical-skeleton document the project's protocol asks for. Material concerns; restructure plus two route-level CHALLENGE responses required this iter.
