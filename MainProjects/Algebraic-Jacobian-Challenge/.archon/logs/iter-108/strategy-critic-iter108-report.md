# Strategy Critic Report

## Slug
iter108

## Iteration
108

## Routes audited

### Route: Phase A — Čech acyclicity (BasicOpenCech.lean) / iter-110 escape-valve

- **Goal-alignment**: PASS — Phase A closure is a genuine prerequisite for downstream `HModule` cohomology and ultimately for the `genus` definition (which is `Module.finrank` of an `HModule`).
- **Mathematical soundness**: PASS — the Čech-acyclicity-of-basic-open-covers route is the standard treatment (Hartshorne III.4 / Stacks 01EX); no obvious mathematical gap in the chosen decomposition.
- **Sunk-cost reasoning detected**: no — the strategy has internalized the iter-107 critic's exit criterion and L1120 was explicitly paused after 7 PARTIALs; the L1846 single-iter budget is enforced and the escape-valve menu MUST fire.
- **Phantom prerequisites**: none for the routing per se. BUT: see the **Must-fix-this-iter** section below on the *labelling* of Option (i)'s deferred sorry — Mathlib actually has `IsLocalizedModule.Away` (in `Mathlib.Algebra.Module.LocalizedModule.Away`) and `IsLocalizedModule.pi` (in `Mathlib.RingTheory.TensorProduct.IsBaseChangePi`). L1846's claim that the slice-cover product is a localized module is *constructible from existing Mathlib*, not a Mathlib gap.
- **Effort honesty**: reasonable — ~5–9 iters / ~130–280 LOC remaining is plausible *given* the escape-valve actually fires this iter. If it slips again, the estimate is under-counted.
- **Verdict**: CHALLENGE
  - The route itself is sound; the CHALLENGE is on the *labelling* of Option (i)'s residual sorry as a Mathlib gap. See must-fix #1 below.

### Route: Phase B — Cotangent sheaves (Differentials.lean)

- **Goal-alignment**: PASS — `Ω^1_{X/k}` and Serre duality are the standard route to a Mathlib-style genus and the variance-flagged `serre_duality_genus` is the right gateway to coupling genus to dimension-of-tangent-space at Jacobian.
- **Mathematical soundness**: PASS — `h_exact` deferred parallel to `instIsMonoidal_W` is consistent with the named-gap policy.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: variance flag on `serre_duality_genus` is acknowledged; planner correctly defers the dispatch pending mathlib-analogist consult on Mathlib's Serre-duality coverage for `Module.finrank` consumers.
- **Effort honesty**: reasonable for *non-Serre-duality* sorries (L122, L718, L735). The `serre_duality_genus` slot is variance-flagged precisely because Mathlib's coverage may force a separate route or a fifth named gap — that's the kind of uncertainty a fresh reader would also see.
- **Verdict**: SOUND — but execute the analogist consult on `serre_duality_genus` *before* scheduling Phase B prover dispatch (the strategy already says this).

### Route: Phase C0 — Monoidal X.Modules (instIsMonoidal_W deferred)

- **Goal-alignment**: PASS — downstream uses don't require monoidality of `X.Modules`; `instIsMonoidal_W` is correctly classified as not gating.
- **Mathematical soundness**: PASS — `stalk_tensorObj` for varying-ring R₀ is a known Mathlib gap (tensor-of-presheaves with varying ring is an open infrastructure question).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 LOC remaining is right — this is a named gap, not a deliverable.
- **Verdict**: SOUND.

### Route: Phase C1 — Refined LineBundle (promotion to MonoidalCategory.Invertible)

- **Goal-alignment**: PASS — the current `CommRing.Pic Γ(X, ⊤)` approximation is explicitly admitted-wrong for non-affine schemes by its own docstring (per the blueprint summary). Smooth proper curves are non-affine, so the project's *intended* mathematical content under the current approximation is broken downstream of `LineBundle`. Promotion to `MonoidalCategory.Invertible (X.Modules)` is the right correction.
- **Mathematical soundness**: PASS — invertible objects in a monoidal category is the standard categorical formulation of line bundles (= rank-1 locally-free quasicoherent sheaves up to iso, with the monoidal structure giving the Picard group). `CategoryTheory.MonoidalCategory` instances on relevant categories exist in Mathlib (confirmed via leansearch hits in `Mathlib.CategoryTheory.Monoidal.*`).
- **Sunk-cost reasoning detected**: no — the strategy explicitly says C1 promotion is "materially the right move regardless of Phase A outcome" and is firing on the merits, not because past iters spent time on a wrong LineBundle.
- **Phantom prerequisites**: none from a strategic standpoint. The refactor will need `MonoidalCategory.Invertible` (verified to exist as concept via leansearch hits on `Mathlib.CategoryTheory.Monoidal.*`) and the monoidal structure on `X.Modules` modulo `instIsMonoidal_W`. The dependency on the deferred `instIsMonoidal_W` should be planned: does the C1 refactor *need* the monoidal instance to typecheck, or can it state `Invertible` in a way that's parametric in the monoidal structure?
- **Effort honesty**: reasonable — ~5–8 iters / ~200–300 LOC for body refactor with frozen signature.
- **Verdict**: SOUND — with a planner advisory: clarify whether the C1 body refactor compiles against the currently-deferred `instIsMonoidal_W` or relies on it being filled.

### Route: Phase C2 — PicardFunctor re-derivation

- **Goal-alignment**: PASS — Picard scheme (or, here, the étale-sheafified Picard functor) is the right intermediate object between LineBundle and Jacobian.
- **Mathematical soundness**: PASS — étale-sheafification of `X ↦ Pic(X)` is the standard construction; representability is the deferred gap.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: étale-sheafification machinery is present in Mathlib (Mathlib has `CategoryTheory.Sheaf.Sheafify` and étale Grothendieck topology infrastructure). Verify before dispatch.
- **Effort honesty**: ~4–6 iters / ~150 LOC. Reasonable for re-derivation against a refactored `LineBundle`.
- **Verdict**: SOUND.

### Route: Phase C3 — DEFERRED via JacobianWitness exit policy

- **Goal-alignment**: PARTIAL — the protected signatures compile, but the project explicitly disclaims autonomous construction of the Jacobian (the original challenge goal). The strategy is transparent about this in the "End-state" plain-language disclosure paragraph. Acceptable as a scoping decision *because* the prerequisites (Hilbert/Quot schemes; finite-group quotients of schemes; Riemann–Roch effective theory + scheme-theoretic image) are confirmed absent from Mathlib b80f227.
- **Mathematical soundness**: PASS — `JacobianWitness C` carrying scheme + group structure + smoothness + properness + geom-irred + Abel-Jacobi data is a true *existence* hypothesis (the Jacobian of a smooth proper curve over a field does exist as a theorem of algebraic geometry), so the iff-form / TRUE-statement soundness rule is satisfied. `Nonempty (JacobianWitness C)` is a true hypothesis being deferred, not a false claim being smuggled.
- **Sunk-cost reasoning detected**: no — adopted in response to the iter-105 REJECT, not in spite of it.
- **Phantom prerequisites**: none — all three alternative routes (FGA-via-Hilbert; Sym^g C / S_g; divisor-class-image Pic⁰) are explicitly confirmed Mathlib-gap-blocked.
- **Effort honesty**: 0 iters / 0 LOC under the exit policy. Honest.
- **Verdict**: SOUND.

### Route: Phase D, E — Genus, Jacobian instances, Abel–Jacobi

- **Goal-alignment**: PASS at the file/signature level; content-level closure is downstream of C3.
- **Mathematical soundness**: PASS for the file-level closure; the content reduces to the `JacobianWitness` data extraction, which is mechanical given the witness.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 / 0 — file-level closure already achieved, content-level BLOCKED-ON-C3-WITNESS by design.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Pull-down — make Option (i) cheaper by labelling honestly rather than as "Mathlib gap"

- **What it looks like**: under the iter-110 escape-valve, if Option (i) wins, the L1846 annotation should NOT be `-- MATHLIB GAP: IsLocalizedModule.Away f.1 on slice-cover product ...`. It should be something like `-- DEFERRED (budget): provable from Mathlib's IsLocalizedModule.{Away,pi,prodMap}; mechanization deferred at iter-110 due to letI-binder propagation friction. Re-attempt blocked behind no-blocking-downstream-work.`
- **Why it might be cheaper or sounder**: same operational cost (one inline sorry + annotation), but the *labelling* honesty matters. The project's "3 named Mathlib gaps" end-state is the central scoping concession — diluting it with a 4th gap that's actually a difficulty deferral undermines the reader's ability to assess "what was structurally impossible vs. what was just expensive." A reader looking at four `-- MATHLIB GAP:` markers cannot tell which three required Hartshorne-chapter-sized infrastructure and which one needed a tedious-but-mechanizable proof.
- **What the current strategy may have rejected**: the strategy treats "name as Mathlib gap" and "leave inline sorry honestly" as equivalent operationally. They are equivalent operationally, but the *taxonomy* matters for the value proposition: a Jacobian framework conditional on three Mathlib gaps (Hilbert schemes; stalkwise sheaf exactness; varying-ring stalk-tensor) is a different artifact from one conditional on four gaps including a budget-deferred lemma.
- **Severity of the omission**: major — addressable via a single line of guidance, not a strategy rewrite, but if missed it weakens the project's transparency.

### Alternative: Phase C1 + Phase A defer-as-deferred-sorry executed *concurrently* this iter

- **What it looks like**: the iter-110 escape-valve menu presents (i), (ii), (iii) as exclusive. The strategy elsewhere notes that C1 is right "regardless of Phase A outcome" and Option (i) is "operationally cheap." So the natural pick is BOTH: (a) annotate L1846 as a deferred sorry (Option-i action, ~5 minutes of work), and (b) fire the C1 promotion refactor.
- **Why it might be cheaper or sounder**: Option (i) is genuinely a one-liner (replace `sorry` with `sorry -- DEFERRED: ...` plus a one-sentence comment); pretending it consumes an entire iter is itself a sunk-cost-style framing. C1 promotion is the substantive work for iter-110.
- **What the current strategy may have rejected**: the strategy says "After the escape-valve, the iter is light on substantive prover dispatch — likely a single prover round on the chosen escape-valve action." That phrasing presupposes the escape-valve consumes the iter. Under (i), it doesn't. Under (ii), it does. So picking (i) leaves the iter under-utilized unless C1 is also fired.
- **Severity of the omission**: major — the planner is asking whether 4 named gaps is acceptable. The cheaper answer is: do (i) honestly-labelled AND start C1 in the same iter, so the gap-count question becomes secondary to "yes we corrected the mathematically-wrong LineBundle this iter."

### Alternative: For LineBundle, sanity-check the C1 promotion lands a *typeable* invertible-object definition

- **What it looks like**: before committing to `LineBundle X := MonoidalCategory.Invertible (X.Modules)`, verify that `Mathlib.CategoryTheory.Monoidal.Invertible` (or its equivalent) defines invertibility on objects (not just morphisms) and that this is the right level of abstraction. The leansearch hits suggest Mathlib has invertibility-of-morphisms machinery but I could not in one search pass confirm an explicit "invertible object of a monoidal category" type.
- **Why it might be cheaper or sounder**: if the right type doesn't exist as a one-line definition, the C1 refactor could implicitly grow to "build invertible-object infrastructure in Mathlib first" — which would push the LOC estimate up materially.
- **What the current strategy may have rejected**: unclear — the strategy may have already verified this; the rebuttal can be a one-line "yes, `MonoidalCategory.Invertible` is at Mathlib path X" reference.
- **Severity of the omission**: minor — but worth a one-line confirmation in the iter-110 plan.

## Sunk-cost flags

No sunk-cost claims of the form "we've already done X, so we should continue with Y" were detected in the strategy. The iter-105 REJECT on Phase C3 was honored with an exit policy. The iter-107 critic's exit criterion on L1846 is enforced. L1120's pause after 7 PARTIALs is a legitimate pivot.

The closest near-miss is the framing of the iter-110 escape-valve menu as a *choice* between (i) and (ii). Treating these as exclusive when they are operationally orthogonal is mildly sunk-cost-adjacent (it suggests the project has internalized a "one big decision per iter" budget that doesn't reflect the actual cost of Option (i)).

- `"After the escape-valve, the iter is light on substantive prover dispatch — likely a single prover round on the chosen escape-valve action."` — Why this is sunk-cost-adjacent: it presumes the escape-valve consumes the iter's substantive work even when the chosen option is one-line annotation work. Recommendation: reframe so Option (i) doesn't displace C1 firing; the planner can do both.

## Prerequisite verification

- `IsLocalizedModule.Away`: **VERIFIED** — exists in `Mathlib.Algebra.Module.LocalizedModule.Away` as an abbreviation.
- `IsLocalizedModule.pi`: **VERIFIED** — exists as an instance in `Mathlib.RingTheory.TensorProduct.IsBaseChangePi` (Finite ι; product of localized linear maps is localized).
- `IsLocalizedModule.prodMap`: **VERIFIED** — same module as above; binary product variant.
- `MonoidalCategory.Invertible` (as a type/structure for invertible objects in a monoidal category): **NOT FULLY VERIFIED** in one search pass. Leansearch returned monoidal-morphism invertibility lemmas but the exact "invertible object" type was not surfaced. Planner should one-line-verify before C1 dispatch.
- `Module.finrank` (used in `genus`): assumed exists (it's a long-standing Mathlib construct); not searched.
- `Abelian.Ext` (used in HModule): assumed exists; not searched.
- Hilbert / Quot schemes: **MISSING** per strategy's own statement (b80f227). Honoured.
- Finite-group quotients of schemes: **MISSING** per strategy's own statement. Honoured.

## Must-fix-this-iter

- **Route Phase A: CHALLENGE — Labelling of Option (i)'s residual sorry as a "Mathlib gap" is incorrect.** Mathlib b80f227 *has* `IsLocalizedModule.Away` and `IsLocalizedModule.pi` (verified via leansearch). The L1846 obligation is a *combination* of these existing pieces and is mechanizable from current Mathlib. Calling it a "Mathlib gap" inflates the named-gap surface with a difficulty-deferral. **Required action**: if Option (i) is chosen, the inline annotation should be `-- DEFERRED (budget): provable from Mathlib's IsLocalizedModule.{Away,pi,prodMap}; mechanization deferred due to letI-binder propagation friction at iter-N` — NOT a `-- MATHLIB GAP:` marker. The end-state should then disclose 3 Mathlib gaps + 1 budget-deferred sorry, not 4 Mathlib gaps. The planner must either adopt this labelling in the iter-110 plan or rebut in plan.md by naming the specific Mathlib lemma that is missing and that would close L1846 (and verifying its absence in b80f227).

- **Alternative "Phase C1 + Option (i) concurrently this iter": major.** The iter-110 escape-valve menu treats Options (i) and (ii) as exclusive. They are operationally orthogonal: Option (i) is one-line annotation work; Option (ii) is hundreds of LOC of refactor. **Required action**: the iter-110 plan should either (a) execute Option (i)'s annotation AND fire C1 promotion in the same iter, or (b) explicitly rebut why these are exclusive (e.g., "C1 promotion needs blueprint and structural prep this iter that displaces it to iter-111").

- **Phantom prerequisite `MonoidalCategory.Invertible` (for C1 promotion): minor.** Verify the exact Mathlib name and signature for "invertible object of a monoidal category" before dispatching the C1 refactor. One-line rebuttal in plan.md citing the Mathlib path is sufficient.

- **Carried from iter-107**: variance flag on `serre_duality_genus`. Re-confirmed live. Dispatch `mathlib-analogist` on Mathlib's Serre-duality coverage *before* scheduling Phase B prover work, not concurrently with it.

## Overall verdict

A fresh mathematician would approve the **strategic shape** of this project as-is: the JacobianWitness exit policy is the right response to the iter-105 REJECT given the confirmed absence of Hilbert/Quot/finite-quotient infrastructure in Mathlib; the C1 promotion is the right correction to a mathematically-wrong LineBundle approximation; the iter-107 exit criterion on L1846 is properly enforced. The strategy is honest, has internalized prior critic feedback, and discloses its end-state limitations clearly in plain language.

There is **one material concern**: the proposed "defer L1846 as the 4th named Mathlib gap" under Option (i) is mis-labelled. Mathlib has the building blocks (`IsLocalizedModule.Away`, `IsLocalizedModule.pi`); L1846 is a budget deferral, not a Mathlib gap. Surfacing it as a Mathlib gap dilutes the project's central scoping concession and undermines the reader's ability to distinguish "structurally impossible" gaps from "expensive-but-mechanizable" deferrals. Fix the label (use `-- DEFERRED (budget)`), and the strategy is fully sound.

Answering the planner's direct question — "is 4 named gaps acceptable instead of 3?" — the answer is: **the count is not the issue; the labelling honesty is.** Three genuine Mathlib gaps + one honestly-labelled budget deferral is materially different (and more transparent) from four uniformly-labelled "Mathlib gaps." Pick the honest taxonomy and the value proposition is preserved.

Routes audited: 7. CHALLENGE/REJECT verdicts: 1 CHALLENGE (Phase A, on labelling of Option (i)). All other routes SOUND.
