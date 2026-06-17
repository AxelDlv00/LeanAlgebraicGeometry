# Recommendations for the next plan iteration (iter-151)

## CRITICAL — `TO_USER.md` gates the iter-151 dispatch shape

The iter-150 plan agent escalated to the user the question:

> Should `rigidity_over_kbar`'s signature in
> `AlgebraicJacobian/RigidityKbar.lean` be amended to add
> `[IsAlgClosed kbar]`?

The full context + trade-off analysis is in
`iter/iter-150/plan.md` § "TO_USER surface" and is now surfaced in
`TO_USER.md`. **The iter-151 prover dispatch shape depends on the
user's answer**:

- **YES (`[IsAlgClosed kbar]` added)**: descope (S3.pi.1) and
  (S3.pi.2) entirely from M2.a critical path; hPI branch closes in
  ~15 LOC via `IsAlgClosed.algebraMap_bijective_of_isIntegral`;
  reintroduce fpqc-descent-of-morphisms scaffolding (~300–500 LOC) on
  a downstream consumer (`genusZeroWitness` candidate).
- **NO (iter-127 over-`k` commitment retained)**: continue (S3.pi.1)
  in path (b) (~150–250 LOC Stacks 02KH ad-hoc); (S3.pi.2) remains on
  the M2.a critical path (~50–100 LOC Stacks 09HD+030K). Iter-150
  progress-critic CHURNING signal escalates to STUCK if iter-151
  lands 0 of 2 (S3.pi.\*) closures (per the iter-150 plan's fallback
  policy).
- **No response (default to NO)**: same as NO.

## HIGH PRIORITY — iter-151 closure targets

### Tractable iter-151 prover candidates

1. **KDM (BR.5) transfer step** — `ChartAlgebra.lean` KDM body
   (sorry at L388). Iter-150 deposited the FREE-CASE MvPolynomial
   helpers + SubmersivePresentation extraction + lift `bTilde` +
   functoriality `_hFunct` (D_A bTilde ∈ ker(map)). The residual is
   the "transfer step": construct `α ∈ P.Ring` with
   `algebraMap P.Ring B α = b` AND `D_A α = 0`. Two paths
   inventoried (~30 LOC each):
   - **(S5.a)** Explicit `KaehlerDifferential.ker_map_of_surjective`
     unfolding + Leibniz-rule iteration to chase the I·Ω modifier
     away. Uses `KaehlerDifferential.mvPolynomialBasis` for the free
     structure of `Ω[P.Ring⁄k]`.
   - **(S5.b)** `Algebra.FormallySmooth.subsingleton_h1Cotangent`
     for abstract H1-vanishing bypass.

   Recommend (S5.a) as primary path — concrete and matches the
   iter-150 deposited helpers; (S5.b) as fallback if the explicit
   chase blows up beyond 30 LOC.

2. **(S3.sep.\*) HYBRID part (B) wire-in via `[CharZero k]`
   propagation through `constants_integral_over_base_field`** — if
   the user replies YES on TO_USER, skip this (the hPI branch
   descopes the (S3.sep.\*) consumers entirely via algebraic-closure
   bypass). If the user replies NO or no response: propagate
   `[CharZero k]` through `constants_integral_over_base_field`
   (signature change in `ChartAlgebra.lean`), then (b.1) branch
   closes in ~5 LOC by replacing the
   `IsSeparable.of_isGeometricallyReduced_of_finite k _` call at
   L457 with the new helper
   `Algebra.IsSeparable.of_finite_of_perfectField` landed iter-150 in
   `ChartAlgebraS3.lean`. NOTE: this is a consumer-side refactor,
   not a (S3.sep.\*) body closure — (S3.sep.1) and (S3.sep.2) remain
   structured sorry on their iter-149 signatures for the
   over-general-base-field formulation.

## MEDIUM PRIORITY — multi-iter trajectory

### (S3.pi.\*) closure plan if user replies NO

Under the NO disposition the M2.a critical path retains:

- **(S3.pi.1)** `Gamma_baseChange_iso_tensor_of_proper`
  (`ChartAlgebraS3.lean:L243`, sorry L276). Stacks 02KH H^0 row.
  ~150–250 LOC Čech-equaliser + flat-tensor exchange chase. The
  deepest sub-claim on path (b); the iter-150 progress-critic CHURNING
  signal will escalate to STUCK if not advanced iter-151.
- **(S3.pi.2)** `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
  (`ChartAlgebraS3.lean:L389`, sorry L403). Stacks 09HD+030K
  embedding-count chain. ~50–100 LOC.
- **hPI branch** of `constants_integral_over_base_field`
  (`ChartAlgebra.lean:L617`). Consumes (S3.pi.1) + (S3.pi.2) + the
  `Smooth ⇒ IsReduced X_{\bar k}` base-change-stability bridge. The
  iter-149 hSep precedent's 4-step `FiniteDimensional k Γ` bridge is
  directly reusable.

### Helper-lemma promotion

The new helper `Algebra.IsSeparable.of_finite_of_perfectField` at
`ChartAlgebraS3.lean:L435` is a candidate Mathlib PR. It is 3 LOC of
body, hypotheses `[FiniteDimensional k F] [PerfectField k]`,
conclusion `Algebra.IsSeparable k F`. The Mathlib chain
`FiniteDimensional ⇒ Algebra.IsAlgebraic` +
`Algebra.IsAlgebraic.isSeparable_of_perfectField` is two existing
Mathlib instances that compose; the project's helper just wraps the
composition under a more discoverable name. **Recommend**: defer the
Mathlib-PR pass until the project has a stable plan (post-iter-151
trajectory).

## LOW PRIORITY / informational

### Iter-150 prover-lane deposit (forward-progress infrastructure to keep in mind)

Even though the iter-150 NET sorry count is unchanged (9 → 9), the
iter-150 prover lanes deposited substantial reusable infrastructure:

- **`_finsupp_sub_single_eq_of_one_le`** — finsupp-subtraction
  uniqueness helper. Reusable in `pderiv`/monomial coefficient chases.
- **`_mvPoly_coeff_pderiv_at_shifted`** — pderiv coefficient formula
  at shifted monomial. Candidate for Mathlib once polished (~40 LOC).
- **`_mvPoly_mem_range_C_of_pderiv_eq_zero`** + **
  `_mvPoly_mem_range_C_of_D_eq_zero`** — FREE-CASE joint-kernel
  collapse for `MvPolynomial σ k` in CharZero. The (BR.5) closure's
  "FREE-CASE" half; reusable any time a `D f = 0 ⇒ f ∈ C.range` claim
  appears in `MvPolynomial`-flavoured context.
- **`Algebra.IsSeparable.of_finite_of_perfectField`** — see above.

All four `_mvPoly_*` helpers are `private`. Consider whether to
expose them once the (BR.5) transfer step lands and the (BR.5)
declaration is sorry-free; if KDM consumes the FREE-CASE as its only
external user, leaving the helpers private is fine.

## Blocked / do-not-retry

### `Algebra.IsSeparable k F ⇒ Algebra.IsGeometricallyReduced k F` direction in Mathlib b80f227

NOT a Mathlib instance. Confirmed iter-150 full grep across
`Mathlib/RingTheory/Nilpotent/`, `Mathlib/RingTheory/Smooth/`,
`Mathlib/AlgebraicGeometry/Geometrically/`. The forward direction
exists (`Algebra.instIsReducedTensorProductOfIsAlgebraicOfIsGeometricallyReduced`);
the reverse direction does not. **Do NOT** redispatch
`mathlib-analogist` on this question — the gap is well-characterised
and is a Mathlib-PR-grade lemma.

### Inflating (S3.sep.\*) signatures with `[PerfectField k]` or `[CharZero k]` WITHOUT propagating to the consumer first

Iter-150 prover-lane attempted this twice (S3.sep.1 + S3.sep.2);
both broke `constants_integral_over_base_field` at the consumer
call site with `synthInstanceFailed`. **Do NOT retry** this pattern;
the consumer-side `[CharZero k]` propagation must land FIRST (an
upstream signature change to `constants_integral_over_base_field`,
which then cascades to `rigidity_over_kbar` and other downstream
consumers).

### HYBRID-DEFERRED (S3.pi.\*) bodies

Per iter-150 planner directive: do NOT attempt (S3.pi.1) or (S3.pi.2)
body closure until the user's HYBRID part (A) decision lands. The
prior iter-149 prover scaffolded both with 5-step closure chains
already; redoing the scaffolding gains nothing.

## Reusable proof patterns added to PROJECT_STATUS.md Knowledge Base

(See PROJECT_STATUS.md Knowledge Base updates this review.)

- **MvPolynomial pderiv coefficient formula at shifted monomial** —
  `coeff (u - single i 1) (pderiv i f) = coeff u f * (u i : k)` for
  `u i ≥ 1` (proof via `as_sum` + `pderiv_monomial` + `sum_eq_single`
  + finsupp-subtraction uniqueness helper).
- **MvPolynomial joint-kernel collapse in CharZero** —
  `(∀ i, pderiv i f = 0) ⇒ f ∈ MvPolynomial.C.range` via support
  analysis; bridged to `D f = 0` via
  `KaehlerDifferential.mvPolynomialBasis_repr_apply`.
- **HYBRID-part-(B) consumer-compatibility blocker** —
  CharZero-collapse signature inflation requires consumer-side
  `[CharZero k]` propagation FIRST; iter-150 documented as iter-151+
  cascade refactor pattern.
- **`Algebra.IsSeparable k F ⇒ Algebra.IsGeometricallyReduced k F`
  Mathlib b80f227 gap** (anti-pattern / known blocker — do not
  re-search Mathlib for this direction).

## Subagent findings absorption

Three review subagents returned. Reports archived at
`logs/iter-150/{lean-auditor-iter150,lean-vs-blueprint-checker-chartalgebra-iter150,lean-vs-blueprint-checker-chartalgebras3-iter150}-report.md`.

### MUST-FIX-THIS-ITER (carry to iter-151 plan-phase)

From `lean-vs-blueprint-checker-chartalgebra-iter150`:

- **Blueprint adequacy failure on KDM**: the chapter's only structured
  (p2) closure is the (BR.1)–(BR.5) chain via
  `Differential.ContainConstants`; the Lean has pivoted to a HYBRID
  (C) MvPolynomial-side joint-kernel-collapse + SubmersivePresentation
  lift + functoriality reduction (iter-150 deposit). The chapter has
  NOT been updated to document the HYBRID (C) route. **Action**: the
  iter-151 plan agent should dispatch a `blueprint-writer` for
  `RigidityKbar.tex` to add a `(BR.5')` (or pivot (BR.4)–(BR.5)) sub-
  block documenting the MvPolynomial joint-kernel-collapse +
  `KaehlerDifferential.map_D` + `KaehlerDifferential.ker_map_of_surjective`
  transfer route. The Lean comments at `ChartAlgebra.lean:L297–337` are
  a good seed for the prose. The four `_mvPoly_*` private helpers are
  blueprint-unanchored until this writer round lands.
- **KDM body sorry on substantive claim** (`ChartAlgebra.lean:L388`,
  the (BR.5) transfer step). Already on the iter-151+ closure target
  list above; reiterating for severity bookkeeping.

### MAJOR (next iter or two)

From `lean-auditor-iter150`:

- **3 stale line-number cross-refs in `ChartAlgebraS3.lean`** (L60,
  L156, L313 — references to `ChartAlgebra.lean:L367`, `L431`,
  `L457`). Iter-150 helper insertion shifted the consumer line numbers
  ~120 LOC; the docstring cross-refs lag. **Action**: iter-151+ writer-
  style cleanup pass on `ChartAlgebraS3.lean` to refresh the
  cross-refs to their current line numbers OR to make them
  location-agnostic (cite the lemma name, not the line number).

From `lean-vs-blueprint-checker-chartalgebra-iter150`:

- **`df_zero_factors_through_constant_on_chart` signature mismatch
  with blueprint prose persists from iter-148**: Lean drops `A`, `f`,
  `df = 0`, `W`, `V`, `f^♯`, `R` from the chapter's statement; body
  is a one-line KDM delegate. Blueprint NOTE acknowledges and pins as
  iter-149+ refinement, still outstanding at iter-150. Four C-side
  typeclasses (`IsProper`, `Smooth`, `IsReduced`,
  `GeometricallyIrreducible`) remain decorative. **Action**:
  iter-151+ plan to choose between (a) inflate the Lean signature per
  the blueprint NOTE, or (b) update the blueprint to formalise the
  thin-wrapper disposition as the load-bearing form.
- **`ext_of_diff_zero` signature mismatch persists from iter-146**:
  same kind of issue (Lean drops `df = dg`, genus 0 + smooth proper
  curve/group hypotheses; body is a one-line `ext_of_eqOnOpen`
  delegate). Iter-148+ refinement still outstanding.
- **`constants_integral_over_base_field` hPI branch sorry** at
  `ChartAlgebra.lean:L617` — sorry on a load-bearing branch with
  project-internal closure depending on (S3.pi.\*). Already noted in
  CRITICAL section; bookkeeping only.

From `lean-vs-blueprint-checker-chartalgebras3-iter150`:

- **MAJOR-1: pointer-chapter stale Stacks Tags** in
  `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` at L42 (cites
  `0334+04QM`, should be `035U+04QM`), L46 (cites `0BJF`, should be
  `0BUG`), L51 (cites `05DH`, should be `030K`). The iter-150
  render-fix writer corrected the canonical chapter but did NOT
  propagate to the pointer chapter (out of that writer's
  write-domain). **Action**: iter-151+ writer round on the pointer
  chapter to apply the three Stacks Tag substitutions.
- **MAJOR-2: iter-150 HYBRID-DEFERRED disposition not reflected in
  either chapter**. Both `RigidityKbar.tex` (S3.pi.\*) blocks and the
  pointer chapter "Body status" paragraph still read as if (S3.pi.\*)
  is on the M2.a critical path. **Action**: iter-151+ writer round to
  add a `% NOTE iter-150 HYBRID-pivot: ...` block to (S3.pi.1) and
  (S3.pi.2) in `RigidityKbar.tex`, mirrored in the pointer chapter.

### MINOR (defer-friendly)

- **In-Lean docstring stale Stacks Tags** in `ChartAlgebraS3.lean`
  (L32, L39, L56, L121–122) — same three tags as MAJOR-1; in-Lean
  documentation only. Defer to next writer/auditor pass on this file.
- **New helper `Algebra.IsSeparable.of_finite_of_perfectField`
  unblueprinted** (dead code in iter-150; planner-honest
  forward-progress infrastructure). Recommend a one-bullet
  acknowledgement in the pointer chapter when the MAJOR-2 fix lands.
- **(S3.pi.1) packaging via `Nonempty (... ≃ₐ[K] ...)`** vs blueprint
  prose's "canonical comparison map is iso": acknowledged in source
  by a "Signature note" docstring block; mathematical content matches.
- **Pre-existing `import Mathlib`** in `Genus.lean:6` and
  `Cohomology/SheafCompose.lean:6` — not iter-150 work; defer.
- **Line-length linter warning** at `Jacobian.lean:L275`
  (the `Jacobian` def signature). Not iter-150 work; defer.
- **Header block accumulation** at `ChartAlgebra.lean:L1–66` — iter-141
  through iter-150 commentary stacked; readability cost. Iter-151+
  may consider a header rewrite.
- **Auditor noted `push_neg` is deprecated in Lean** but no `push_neg`
  uses remain in source (prover replaced them this iter); no action.

### Kernel-axiom check (clean)

`lean-auditor-iter150` ran `lean_verify` on all 5 iter-150 deposits:
the four `_mvPoly_*` / `_finsupp_*` private helpers + the new
`Algebra.IsSeparable.of_finite_of_perfectField`. All five return
**kernel-only axioms** (`propext, Classical.choice, Quot.sound`);
**no new axioms introduced**. Iter-150 work passes the axiom-hygiene
gate cleanly.

### Excuse-comment scan (clean)

`lean-auditor-iter150` performed a global scan for canonical
excuse-comment patterns and reported **zero hits** across all 15
`.lean` files audited. The project's "structured sorry" discipline
remains in good hygiene this iter.

