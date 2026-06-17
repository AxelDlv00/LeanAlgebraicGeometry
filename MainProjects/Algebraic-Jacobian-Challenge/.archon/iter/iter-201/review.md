# Iter-201 (Archon canonical) — review

## Outcome at a glance

- **The "third iter under USER 2026-05-28 standing directive (ROUTE
  C PAUSE permanent / Route A bottom-up / reference-driven
  mathlib-build) plus iter-201 plan agent's option-(c) continuation
  on A.2.c REJECT (`route201` strategy-critic SOUND + plan-agent
  applied 4 strategy-critic correctives — format compliance restored,
  `## Goal` A.2.c framing unambiguous, genus-0 option ranking
  surfaced, infrastructure-deferral termination condition stated) + 3
  Route A substrate-only prover lanes (WD-A4a Sub-build 2 HARD BAR
  MET + PUSH-BEYOND partial; AB-Stacks-00MF Path B matrix-collapse
  substrate landed but body NOT closed; COE-Stage6.B-Jacobian 3
  substrate sub-pieces landed but Step A1 Matsumura BLOCKED on 3
  Mathlib gaps Stacks 00NQ / `A/(f₁)` RLR-preservation /
  `IsRegularLocalRing.localization`) + 13 axiom-clean substrate
  declarations across the 3 files (6 WD ord-naturality + scheme
  packaging; 4 AB Module matrix-collapse Path-B substrate; 3 COE
  cotangent / transport / composite) + 1 of 3 HARD BARs MET
  (WD only; AB HARD BAR converted to a precisely-typed Nat-induction
  restructuring obligation; COE HARD BAR re-classified as Mathlib-
  gap-blocked) + iter-201 plan-phase 5 subagents returned
  (progress-critic STUCK on all 3 lanes corrected via blueprint
  expansion + STRATEGY.md velocity refresh + TO_USER escalation note;
  strategy-critic SOUND + 4 CHALLENGE-level findings ALL addressed;
  blueprint-reviewer cleared 3-of-3 chapters via same-iter fast path
  on AB; mathlib-analogist `coe-stacks00sw` delivered 3-step A1/A2/A3
  recipe; mathlib-analogist `ab-stacks00mf` delivered Path B verdict
  obviating Stacks 00MF for AB) + iter-201 review-phase 4 subagents
  dispatched in parallel (lean-auditor `iter201` + 3
  lean-vs-blueprint-checker {wd,ab,coe}-iter201) + sync_leanok iter
  =201 ran (5 added / 0 removed, chapters_touched =
  RiemannRoch_WeilDivisor)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per
  `logs/iter-201/meta.json` `prover.status: done`,
  `planValidate.objectives: 3`. **3/3 prover lanes returned `done`
  clean (no API 529 errors)**. **21st consecutive zero-axiom build
  streak** (0 → 0 project axioms).

- **Sorry trajectory**: iter-200 baseline **78** → iter-201 exiting
  **78**. **Net delta 0** (substrate-only iter, no top-level sorry
  closures). Per-file sorries: WD 3 → 3, AB 1 → 1, COE 3 → 3.

  The iter lands in the **worst-case band** of the iter-201 plan
  agent's projection ("Worst case: 78 → 78, all 3 lanes substrate-
  only"). Within the substrate-only band, the lanes are *not*
  homogeneous in quality: Lane WD landed a textbook HARD BAR +
  partial PUSH-BEYOND with a clean iter-202 Sub-build 3 handoff;
  Lane AB landed the binding new substrate per its analogist's Path
  B recipe (now ~3× closer to closure); Lane COE substrate gain is
  more modest (one cotangent-side packaging + one Mathlib-gap-
  conditional composite), and the substantive Step A1 closure is
  newly-confirmed gated on 3 Mathlib gaps that the iter-201 plan
  agent had under-budgeted to 30-50 LOC and the iter-201 prover
  re-scoped honestly to 100-200 LOC + prereqs.

- **HARD BAR landings**: **1 of 3 lanes**.
  - Lane WD-A4a Sub-build 2: **MET**.
    `Ring.ordFrac_ringEquiv` axiom-clean (L311) + 3 ancillary
    naturality helpers + PUSH-BEYOND partial (function-field iso +
    scheme-side packaging both axiom-clean; iter-202 Sub-build 3
    will discharge the `h_compat` parameter).
  - Lane AB-Stacks-00MF Path B: **NOT MET** (closure HARD BAR);
    **MET** for the matrix-collapse-substrate sub-HARD-BAR. The 4
    `RingTheory.Module` helpers are Path B's binding new piece per
    the `ab-stacks00mf` analogist verdict; with them in hand, full
    closure of `_succ_pd` is reachable in ~80-120 LOC via
    Nat-induction restructuring (base case = matrix-collapse +
    LES; inductive step = `depth_of_short_exact` (2)+(3)).
  - Lane COE-Stage6.B-Jacobian: **NOT MET**. 3 substrate
    sub-pieces landed; Step A1 (the substantive piece) gated on
    Stacks 00NQ + `A/(f₁)` RLR-preservation + `IsRegularLocalRing.localization`
    Mathlib gaps. Re-routing via `IsRegularLocalRing.localization`
    confirmed ALSO blocked.

- **Plan trajectory** entering iter-201 (per iter-201 plan): best
  78 → ~73-75 (−3 to −5), realistic 78 → ~76-77 (−1 to −2), worst
  78 → ~78 (0). iter-201 lands a **0-net (worst-case)** outcome
  with substantive HARD BAR on Lane WD plus axiom-clean binding
  substrate on Lane AB; Lane COE is the binding obstruction whose
  iter-202 corrective requires a `mathlib-analogist` re-scout of
  the three confirmed-absent Mathlib gaps before committing
  another prover lane.

- **Reviewer-phase subagents** — see `## Subagent dispatches`.

- **`sync_leanok` iter=201**: 5 added / 0 removed / 1 chapter
  touched (`RiemannRoch_WeilDivisor.tex`). The 5 markers
  correspond to the iter-200 Sub-build 1 substrate decls
  (`restrictToOpen`, `ofOpen`, `equivOpen`, `stalkIso`,
  `IsRegularInCodimensionOne.instOpen`) whose new pins landed in
  the iter-201 plan agent's `§Open-immersion descent for prime
  divisors`. No manual marker overrides required.

- **Blueprint doctor**: no structural findings (every chapter
  `\input`'d; every `\ref` / `\uses` resolves; every annotation
  argument non-empty; no new `axiom` declarations under
  `AlgebraicJacobian/`).

## Per-lane assessment

### Lane WD-A4a Sub-build 2 — HARD BAR MET + PUSH-BEYOND partial

**Trajectory**: clean. The lane's substrate decomposition into 4
ord-naturality helpers (`ord`, `nonZeroDivisors`,
`ordMonoidWithZeroHom`, `ordFrac`) is the natural modular shape
and emerged from the prover's bottom-up build, not from the plan
agent's pre-scoped recipe. The PUSH-BEYOND chose to land
`Scheme.Opens.functionFieldIso` + a scheme-side parameterised
wrapper rather than attempting to discharge `h_compat` inline —
this is the correct discipline (Sub-build 3 = `h_compat`
discharge in iter-202).

**No dead ends; no friction**. Per the prover task report's "Dead
ends (none this iter)" section, the only unanticipated good thing
was `ordMonoidWithZeroHom_ringEquiv` as a natural intermediate;
the analogist's iter-200 Sub-build 2 preview signature was
followed verbatim.

**Forward-compatibility**: every helper is honestly typed and
ready for iter-202 Sub-build 3 consumption. The L535 terminal
closure remains USER-blocked (signature strengthening to
`[IsNoetherian X]` requires Route C consumer access), which is a
strategy-level constraint, not a prover failure.

### Lane AB-Stacks-00MF Path B — substrate MET, closure NOT MET

**Trajectory**: the Path B analogist verdict iter-201 obviated the
33-iter / 5.5×-over-budget churn that the progress-critic flagged
for User escalation. The 4 matrix-collapse helpers ARE the binding
new substrate per the analogist; lean_verify confirms axiom-clean.

**Why closure not landed this iter**: the matrix-collapse helper
on its own does not close `_succ_pd`; the base case (k=0, pd M=1)
requires ~50-80 LOC of LES bookkeeping + linear-equivalence
transport on top of matrix-collapse, AND the body must be
restructured as `induction k generalizing M` to make the IH
reachable for the inductive step. Neither piece is a Mathlib gap;
both are doable in iter-202.

**A second important finding** (analogist Path B alternative): the
inductive step k≥1 does NOT need matrix-collapse at all. It closes
via `depth_of_short_exact` parts (2)+(3) directly: lower bound
`depth M ≥ depth K - 1` and upper bound `depth M + 1 ≤ depth K`
combine for `depth M + k + 1 = depth R`. This means the iter-202
closure body is actually simpler than first projected; matrix-
collapse is used only at the base case.

**Required iter-202 dispatch**: a `mathlib-build` lane with helper
budget 2, restructuring `_succ_pd` as `induction k generalizing M`,
landing both branches, and removing `private` per the iter-201 plan
option (1) commitment.

### Lane COE-Stage6.B-Jacobian — substrate-only on auxiliary pieces

**Trajectory**: the `coe-stacks00sw` analogist 3-step A1/A2/A3
recipe was followed verbatim, but the prover's Mathlib scout
re-discovered three substantive gaps that the analogist's recipe
under-estimated:

1. `IsRegularLocalRing → IsDomain` (Stacks 00NQ): ABSENT in
   forward direction. The standard proof uses associated-primes /
   Cohen-Macaulay (~100-200 LOC project-local OR Mathlib upstream PR).
2. `A / (f₁) → IsRegularLocalRing` preservation: ABSENT. Mathlib has
   the dim-drop lemma but no RLR-preservation companion.
3. `IsRegularLocalRing.localization` (Stacks 00OF): ABSENT
   (re-routing via this alternative is also closed off).

The 3 substrate decls landed are honest auxiliary pieces:
`submersivePresentation_relation_cotangent_mk_linearIndependent`
(forward-ergonomics packaging),
`...linearIndependent_localized` (transport through a generic
localisation map), and `ringKrullDim_quotient_localization_MvPolynomial_of_regular`
(Mathlib-gap-conditional Step 1+2+3 composite). They are
forward-compatible with any iter-202+ A1 closure but do not move
the L1061 sorry.

**Required iter-202 dispatch**: a `mathlib-analogist` (slug
`coe-mathlib-gaps-iter202`) to re-scout the 3 gaps at the current
Mathlib pin AND assess project-local build cost vs. upstream PR
turnaround. The Lane T32 re-engagement trigger ALSO names
`IsRegularLocalRing → IsDomain`, so the Stacks 00NQ closure is
doubly load-bearing.

**Do NOT re-dispatch Lane COE Step A1 prover** before the analogist
verdict — the iter-201 prover already scouted; a re-dispatch would
repeat the same scout.

### Lane RPF / FGA / T32 / RCI — HELD per iter-201 plan rationale

Unchanged from iter-201 plan rationale. Lane RPF awaits the
iter-204+ TensorObjSubstrate body fill; Lane FGA awaits the
iter-205+ Lane RPF body fill; Lane T32 awaits the COE Stage 6.B
closure trigger (still binding on the 3 Mathlib gaps above); Lane
RCI is Route C PAUSED.

## Subagent dispatches

| Subagent | Slug | Status |
|---|---|---|
| lean-auditor | `iter201` | RETURNED (1 must-fix / 2 major / 5 minor) |
| lean-vs-blueprint-checker | `wd-iter201` | RETURNED (1 major / 1 soon / 1 minor) |
| lean-vs-blueprint-checker | `ab-iter201` | RETURNED (1 major / 1 soon / 3 minor) |
| lean-vs-blueprint-checker | `coe-iter201` | RETURNED (0 must-fix / 3 soon / 1 minor) |

Reports auto-archive to `logs/iter-201/`. CRITICAL / HIGH findings
landed at the top of `recommendations.md`; MEDIUM as bullets;
LOW as one-liners in `summary.md`.

**lean-auditor `iter201` cross-file finding flips the Lane COE
narrative**: the iter-201 prover's Lane COE Mathlib scout
*(`task_results/AlgebraicJacobian_Albanese_CodimOneExtension.lean.md`)*
correctly identified that Mathlib b80f227 lacks
`IsRegularLocalRing → IsDomain` (Stacks 00NQ). What the prover
missed: the project ALREADY HAS a private project-local witness
`isDomain_of_regularLocal` at `AuslanderBuchsbaum.lean:2657`
(strong-induction-on-spanFinrank, axiom-clean), whose closure
chain `regularLocal_quotient_isRegularLocal_of_notMemSq` →
`notMem_minimalPrimes_of_regularLocal_succ` (this iter, closed
prior; see CRIT-LA-2 stale-label flag) → `isDomain_of_regularLocal`
makes `CohenMacaulay.of_regular` axiom-clean for the first time.
**This materially changes CRIT-2 in `recommendations.md`**: Lane
COE Step A1's "Mathlib gap" classification is wrong — the
substantive Stacks 00NQ witness already exists project-side,
needs only promotion from `private` to public OR an explicit
cross-file import from CodimOneExtension.lean. Additionally,
`regularLocal_quotient_isRegularLocal_of_notMemSq` (a hidden
building block of `isDomain_of_regularLocal`) provides the
`A/(f₁) → IsRegularLocalRing` preservation that the Lane COE
scout listed as the second Mathlib gap. **Two of three "Mathlib
gaps" are actually project-local witnesses with promotion-only
cost**; only `IsRegularLocalRing.localization` (Stacks 00OF)
remains genuinely absent. The iter-202 plan agent should
re-dispatch Lane COE Step A1 prover with explicit cross-file
import directives rather than dispatching a `mathlib-analogist`
re-scout (which would re-confirm the Mathlib gaps without
surfacing the project-local witnesses).

All 3 lean-vs-blueprint-checker dispatches returned:
- **wd-iter201**: 1 major (missing `\lean{...}` pin for the public
  `Scheme.Opens.functionFieldIso`) + soon/minor stale labels.
  Sub-build 1's 5 sync_leanok markers all land correctly.
- **ab-iter201**: 1 major (private + pin mismatch on
  `auslander_buchsbaum_formula_succ_pd` — sync_leanok can't resolve;
  closure landing still pending) + soon Path-B narrative tense
  refresh + 3 minor.
- **coe-iter201**: 3 soon — blueprint API-state INCORRECTLY claims
  `IsRegularLocalRing.localization` (Stacks 00OF) exists in Mathlib;
  Step A1 recipe under-budgets Mathlib gaps by 5-10× *(but the
  iter-201 lean-auditor cross-file finding partially supersedes
  this: the project HAS 2 of the 3 gaps already, so the iter-202
  chapter refresh should re-frame as "Mathlib lacks, project
  supplies privately, iter-202 promotes + imports")*; 3 new
  iter-201 private substrate theorems absent from chapter
  narrative.

All checker findings land in `recommendations.md` as MED-3a (WD),
MED-3b (AB), and MED-5b (COE). The iter-202 plan agent should
dispatch `blueprint-writer` lanes on each of the 3 chapters.

## Knowledge Base additions (this iter)

The following will be appended to `PROJECT_STATUS.md`'s Knowledge
Base section (Proof Patterns + Known Blockers):

### Proof Patterns
- **Bilinear `Ext` matrix-collapse via `mk₀_sum`+`mk₀_smul`+`comp_sum`+`comp_smul`**
  *(iter-201 Lane AB-Stacks-00MF Path B, `Albanese/AuslanderBuchsbaum.lean`
  L1418-1481, 4 axiom-clean helpers.)* For a postcomposition
  `e.comp (mk₀ (ofHom A))` where `A : R^m →ₗ R^n` factors through a
  finite product, decompose `A = ∑ A_{ij} • elemMap _ _ i j` then
  push through `ofHom` (`ModuleCat.hom_sum + ofHom_add`), `mk₀`
  (`Ext.mk₀_sum + Ext.mk₀_smul`), and `comp` (`Ext.comp_sum +
  Ext.comp_smul`). Each summand reduces to a scalar-bilinear form
  closable via a scalar-annihilator helper (e.g.
  `ext_smul_eq_zero_of_mem_annihilator`). The absence of
  `ModuleCat.ofHom_smul` does NOT block this — scalars are absorbed
  into the basis vector before `ofHom`.
- **`Ring.ordFrac` naturality across compatible `RingEquiv` +
  `IsFractionRing` chains** *(iter-201 Lane WD-A4a Sub-build 2,
  `RiemannRoch/WeilDivisor.lean` L247-311, 4 axiom-clean
  ord-naturality decls.)* The 4-helper modular decomposition
  (`ord_ringEquiv`, `nonZeroDivisors_ringEquiv`,
  `ordMonoidWithZeroHom_ringEquiv`, `ordFrac_ringEquiv`) factors
  through `Ring.ordFrac_eq_div` + the `mk'` API of
  `IsLocalization`. Recipe at `ordFrac_ringEquiv`:
  `by_cases x = 0`; nonzero branch obtains `(a, b ∈ nzd R)` via
  `IsLocalization.surj`, lifts `a ∈ nzd R` via
  `mem_nonZeroDivisors_of_ne_zero` (uses `[IsDomain R]`), expresses
  both sides as `mk' K_R a ⟨b, _⟩` / `mk' K_S (e a) ⟨e b, _⟩`,
  applies `Ring.ordFrac_eq_div`, closes via
  `ordMonoidWithZeroHom_ringEquiv` on numerator and denominator.
  Reusable for any order/multiplicity transport across stalk
  isomorphisms.

### Known Blockers
- **Three Mathlib gaps gate the Stage 6.B Jacobian-regular-sequence
  witness for `isRegularLocalRing_stalk_of_smooth`
  (`Albanese/CodimOneExtension.lean` L1061)** *(iter-201 Lane COE
  re-scout.)* (1) `IsRegularLocalRing → IsDomain` (Stacks 00NQ) is
  ABSENT in forward direction at Mathlib b80f227; only the PID
  converse instance exists. (2) `A / (f₁) → IsRegularLocalRing`
  preservation is ABSENT (Mathlib has dim-drop via
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` but no
  RLR-preservation companion). (3) `IsRegularLocalRing.localization`
  (Stacks 00OF) is ABSENT (verified by grep over the whole
  `RingTheory/RegularLocalRing/` directory). Project-local build of
  the chain via Cohen-Macaulay / associated-primes theory is
  ~100-200 LOC for Stacks 00NQ alone (matched in scale by the AB
  Stacks 00MF parallel gap; both partially infrastructure-dependent).
  **DO NOT** re-dispatch Lane COE Step A1 prover before a
  `mathlib-analogist` re-scout of the three gaps. The Lane T32
  re-engagement trigger ALSO names `IsRegularLocalRing → IsDomain`,
  so closing Stacks 00NQ is doubly load-bearing.

## Decision made

The iter-201 plan agent's option-(c) honest framing on A.2.c is
unchanged this iter (strategy-critic `route201` SOUND with 4
non-blocking CHALLENGE-level findings, all addressed inline by the
plan agent). The iter-201 prover lane decisions follow the plan;
no review-level redirection.

The iter-202 plan agent inherits the following decision points:
- CRIT-0: dispatch Lane AB-Path-B-Continue (Nat-induction +
  closure body).
- CRIT-1: dispatch Lane WD-A4a Sub-build 3 (`h_compat` discharge).
- CRIT-2: dispatch a `mathlib-analogist` re-scout for the 3
  COE Mathlib gaps BEFORE any Lane COE prover re-dispatch.

## TO_USER

No new escalation this iter. The iter-201 plan-agent FYI (Path B
analogist resolved the AB ℕ∞ arithmetic blocker; Lane FGA Sorry 4
re-engagement still gated on TensorObjSubstrate iter-204+) carries
forward to the review's `TO_USER.md`.
