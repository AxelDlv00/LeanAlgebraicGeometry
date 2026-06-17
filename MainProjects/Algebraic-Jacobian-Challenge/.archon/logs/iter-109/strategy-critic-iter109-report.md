# Strategy Critic Report

## Slug
iter109

## Iteration
109

## Routes audited

### Route: Phase A — Čech acyclicity (closed-out)

- **Goal-alignment**: PASS — Phase A residuals (L1212, L1536, L1564) feed downstream cohomology that the genus/Jacobian arc requires; closure-out via budget-deferral on L1846 + PAUSE on L1120 is goal-aligned because neither blocks the genus definition.
- **Mathematical soundness**: PASS — the four `IsLocalizedModule.*` building blocks for L1846 are verified to exist in Mathlib (`IsLocalizedModule.pi`, `IsLocalizedModule.prodMap` confirmed via leansearch; `IsLocalizedModule.Away` and the algebra adapter were verified by strategy-critic-iter108 per the strategy's text). The "budget deferral, not gap" labelling is correct.
- **Sunk-cost reasoning detected**: no — the PAUSE rationale on L1120 is "7 PARTIAL iters + 2 PAUSED iters + new wrapper/inlining both committed to not-repeat", which is explicit anti-sunk-cost discipline.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — ~30–80 LOC residuals look honest given the named sub-step sorries.
- **Verdict**: SOUND.

### Route: Phase B — Cotangent sheaves (deferred to iter-111+)

- **Goal-alignment**: PASS — cotangent sheaves + Serre duality are the legitimate path to the genus *theorem* content (not just the definition).
- **Mathematical soundness**: PASS — `h_exact` deferred parallel to `instIsMonoidal_W` is the right structural choice (Mathlib gap on stalkwise exactness for `SheafOfModules`, verified absent at iter-086 audit). The variance flag on `serre_duality_genus` at L877 is appropriately surfaced.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable for the non-`h_exact` sorries; `serre_duality_genus` is the high-variance one and the strategy correctly demands a mathlib-analogist consult before scheduling.
- **Verdict**: SOUND.

### Route: Phase C0 — Monoidal `X.Modules` / `instIsMonoidal_W` (deferred, becomes load-bearing post-C1)

- **Goal-alignment**: PASS — the "deferred indefinitely with honest disclosure" framing matches the project's overall posture.
- **Mathematical soundness**: PASS — the underlying claim `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀) is mathematically true; the gap is purely Mathlib-infrastructural. `PresheafOfModules.monoidalCategory` is confirmed present in Mathlib but not yet lifted to schemes with varying rings.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 LOC remaining is consistent with the "leave the inline sorry, surface honestly" posture.
- **Verdict**: SOUND. Note: the "becomes load-bearing post-C1" framing is the right disclosure; see Overall verdict for one nuance about the disclosure paragraph.

### Route: Phase C1 — Refined `LineBundle` (firing this iter)

- **Goal-alignment**: PASS — refining `LineBundle X` from the global-sections approximation `CommRing.Pic Γ(X, ⊤)` to `Shrink (Skeleton X.Modules)ˣ` is the correct sheaf-theoretic content that the protected `Jacobian` arc requires.
- **Mathematical soundness**: PASS — verified pieces:
  - `CategoryTheory.Skeleton.instCommMonoid [BraidedCategory C]` exists at `Mathlib.CategoryTheory.Monoidal.Skeleton`.
  - `CommRing.Pic` exists at `Mathlib.RingTheory.PicardGroup`; the pattern `Shrink (Skeleton _)ˣ` is the Mathlib canonical idiom (confirmed by `CommRing.Pic.mk`'s `[Module.Invertible R M]` signature, consistent with the analogist's literal-form claim).
  - `SheafOfModules.pullback` exists at `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous` but **no `Functor.Monoidal` instance is provided** (verified by absence in loogle + leansearch — analogist finding confirmed).
- **Sunk-cost reasoning detected**: no — the iter-108 plan-agent rebuttal to firing C1 *concurrently* with the L1846 escape-valve correctly cited the analogist's not-yet-returned must-fix findings as the reason to wait, not "we've invested in the global-sections approximation".
- **Phantom prerequisites**: none — the analogist's recipe is grounded in pieces I verified.
- **Effort honesty**: reasonable — the revision from 5–8 iters / 200–300 LOC up to 6–10 iters / 250–400 LOC reflecting the pullback gap is an honest revision in response to the analogist findings, not a soft-pad.
- **Verdict**: CHALLENGE (Q1 + Q2 nuances — see Must-fix-this-iter).

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS — re-derivation onto the new `LineBundle` is necessary for the downstream `PicardFunctor`/`PicardFunctorAb` consumers to type-check.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 4–6 iters / ~150 LOC for re-derivation including étale sheafification looks tight but not implausible; if C1 lands cleanly the structural skeleton survives.
- **Verdict**: SOUND.

### Route: Phase C3 — `JacobianWitness` exit policy

- **Goal-alignment**: PARTIAL — the witness pattern produces a *framework* for the Jacobian, not a Jacobian. The strategy is explicit about this and the protected signatures still hold (verified: `archon-protected.yaml` lists exactly the 9 declarations of the directive). A fresh mathematician will accept "framework conditional on witness" as a defensible end-state given the Mathlib-foundations reality, but the gap between "framework" and "challenge goal" is a real one. The Plain-language disclosure paragraph at L54–60 is the right honest accounting.
- **Mathematical soundness**: PASS — `Nonempty (JacobianWitness C)` is a mathematically true statement; deferring it as a single inline sorry follows the soundness rule.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: PASS — the strategy correctly accepts that the original 10–15 iters / 1500 LOC estimate was wildly under-counted and now estimates 50–150 iters / 5,000–15,000 LOC for any honest C3 attempt; this justifies the deferral.
- **Verdict**: SOUND (with PARTIAL on Q3 — see Must-fix-this-iter).

### Route: Phases D, E — file-level closure

- **Goal-alignment**: PASS — protected signatures present, downstream consumers route through the witness/typeclass framework.
- **Mathematical soundness**: PASS.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Split C1 into C1a (type + group structure) and C1b (pullback iso)

- **What it looks like**: Iter-109 narrative dispatches the refactor only for the new `LineBundle X := Shrink (Skeleton X.Modules)ˣ` type + `instCommGroup` derivation via `Skeleton.instCommMonoid [BraidedCategory X.Modules]`. Defer `Pic.pullback` refactor (and the option (a)/(b)/(c) decision for the monoidal-pullback gap) to iter-110+ narrative, *after* the new type compiles and the `BraidedCategory (X.Modules)` typeclass-resolution path is validated.
- **Why it might be cheaper or sounder**: The pullback-gap commitment (option (c) ⇒ 5th named sorry) is irreversible at the disclosure level. Validating the type-level refactor *first* gives a clean recovery point if the analogist's `Shrink (Skeleton X.Modules)ˣ` idiom turns out to have a universe-size issue at the scheme level (which the strategy at L97 already flags as "the prover round verifies"). Splitting lets you back out cleanly. Under the current bundled plan, a universe-size failure forces re-planning *together* with the pullback-gap commitment.
- **What the current strategy may have rejected**: unclear — the strategy talks about a "refactor + initial prover work" envelope of 80–130 LOC for iter-109 but doesn't disclose whether C1a alone fits in a smaller envelope. The planner should clarify.
- **Severity of the omission**: minor — the bundled C1 is workable, but the unsplit firing increases blast radius on a not-fully-validated target type.

### Alternative: Curve-specific Pic⁰ as a fourth deferred-C3 path

- **What it looks like**: The "Phase C3 exit policy" section names three deferred paths (Hilbert/Quot, Sym^g/S_g, divisor-class-image). A fourth path — Pic⁰ defined as the kernel of the degree map on `LineBundle` for a smooth proper curve — is structurally simpler at the curve level than the general case because Riemann-Roch + the autoduality of the Jacobian-of-a-curve give automatic representability classically. This route would still bottom out at a `JacobianWitness` sorry, but its sketch is curve-specific and may surface less Mathlib-gap-blocked.
- **Why it might be cheaper or sounder**: It's not actionable this iter (Phase C3 is deferred); the value is purely framing-completeness. A future picker-upper of the project should see all four paths enumerated.
- **What the current strategy may have rejected**: the curve-specific path is implicit in the "divisor-class-image" formulation but the strategy doesn't separate the curve-specific degree-map idea from the general scheme-theoretic-image idea. They have different Mathlib-prereq profiles.
- **Severity of the omission**: minor — framing nit, not a strategic redirect.

## Sunk-cost flags

None detected. The strategy's text on the global-sections approximation `CommRing.Pic Γ(X, ⊤)` is presented as "the C1 promotion replaces this" rather than "we've invested too much to abandon this", which is correct framing. The iter-108 rebuttal to firing C1 concurrently with the L1846 escape-valve correctly cited *new information from the analogist* as the reason to wait, not sunk cost.

## Prerequisite verification

- `CommRing.Pic` (`Mathlib.RingTheory.PicardGroup`): VERIFIED (exists; the `Shrink (Skeleton _)ˣ` idiom is the canonical Mathlib pattern, confirmed via `CommRing.Pic.mk`'s typeclass requirement `[Module.Invertible R M]`).
- `CategoryTheory.Skeleton.instCommMonoid [BraidedCategory C]` (`Mathlib.CategoryTheory.Monoidal.Skeleton`): VERIFIED.
- `SheafOfModules.pullback` (`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`): VERIFIED.
- `AlgebraicGeometry.Scheme.Modules.pullback` (`Mathlib.AlgebraicGeometry.Modules.Sheaf`): VERIFIED.
- `PresheafOfModules.monoidalCategory` (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`): VERIFIED.
- `Functor.Monoidal (Scheme.Hom.pullback f)` or `(SheafOfModules.pullback _).Monoidal`: MISSING (confirmed absent — analogist finding validated).
- `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap` (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`): VERIFIED.
- `IsLocalizedModule.Away` + algebra adapter: previously verified by strategy-critic-iter108 (trusting that verification; my own leansearch returned the family but not the specific `Away` lemma surface-up in the top results — not concerning given the iter-108 verification was direct).

## Must-fix-this-iter

- **Route Phase C1 (Q1 — firing decision)**: CHALLENGE — the planner should record an explicit rebuttal to the *split-C1* alternative above. Specifically, justify either (i) why bundling C1a + C1b in one iter is preferable, or (ii) accept the split and revise the refactor directive accordingly. Right now the strategy is silent on the split option.

- **Route Phase C1 (Q2 — option (c) vs (b) for the pullback gap)**: CHALLENGE — the strategy at L29 says option (c) "smallest scope, named deferral, mirrors `instIsMonoidal_W` posture" but does not surface that **the *content* of option (b) (hand-rolled iso, inline sorry) and option (c) (standalone named sorry) is essentially identical** — only the labelling differs (top-level named lemma vs in-body sorry). The "smallest scope" claim for (c) is misleading without acknowledging this equivalence. The planner should add a one-paragraph clarification to STRATEGY.md (in the C1 row or in a footnote) that the choice between (b) and (c) is a *labelling/disclosure-surface* choice, not a mathematical or effort choice. Both are equally "smallest scope". The default of (c) is then defensible purely on "consistency with the `instIsMonoidal_W` named-deferral pattern", which is fine — but the rationale needs to be honest.

- **Route Phase C3 (Q3 — conditional-on-conditional framing)**: CHALLENGE — the Plain-language disclosure at L54–60 honestly describes the *two* conditional layers (Jacobian-on-witness; Picard-on-`instIsMonoidal_W`) but does NOT enumerate *which parts of the project are unconditional*. A fresh reader sees two stacked conditionals and may read "framework conditional on framework conditional on gap" as "everything is conditional". In fact: `genus` (Phase D), the cotangent sheaves API (Phase B modulo `h_exact`), the Čech cohomology API (Phase A modulo budget-deferrals), and the `Pic` *type* (post-C1, modulo monoidal-pullback) are all *unconditional* down to inline-`sorry`-named gaps but their public APIs type-check unconditionally. The planner must extend the Plain-language disclosure with a one-paragraph "what's unconditional vs what's framework-conditional" enumeration so the reader can tell which parts of the project work without the two named witnesses.

## Re-verification of previously CHALLENGED items

- **iter-108 strategy-critic CHALLENGE on L1846 labelling (Mathlib gap vs budget-deferral)**: ADDRESSED. The strategy now treats these as distinct categories. The "Aggregate" paragraph at L22–32 explicitly says "5 named Mathlib-gap sorries + 1 budget-deferral" with a separate row for the budget item. The "Mathlib gaps in scope" table at L75 explicitly says `IsLocalizedModule.Away f.1 on finite products of restricted basic-opens` is "NO LONGER A GAP" and reclassified as budget-deferral. The "Soundness rule" section at L146–150 formalizes the three categories (named Mathlib gaps; JacobianWitness exit; budget-deferral). Clean response. PASS.

- **Phase B variance flag on `serre_duality_genus` L877 (carried from iter-107/108)**: STILL LIVE, correctly handled. Phase B is not dispatched this iter (C1 is firing), so the flag is dormant but not stale. The strategy at L107 correctly demands a mathlib-analogist consult on Mathlib's Serre-duality coverage *before* Phase B is scheduled. Right call. I considered pushing back on "could the analogist be dispatched pre-emptively as a hedge?" but the project's analogist consult budget (rate-limit + attention) makes just-in-time dispatch correct.

## Overall verdict

A fresh mathematician would approve this strategy with two clarifications and one minor framing extension. The C1 promotion firing this iter is the right move given the analogist's must-fix findings are now in hand; the post-C1 named-sorry count increase from 4 to 5 is a defensible disclosure cost for the project's chosen pattern of named-and-disclosed Mathlib gaps. The conditional-on-conditional end-state framing is mathematically honest but should be supplemented with a "what's unconditional" paragraph so readers can locate the load-bearing pieces. The L1846 budget-deferral vs Mathlib-gap distinction is cleanly resolved from iter-108's challenge. The bundled-vs-split C1 decision is the one place where the strategy is silent on a reasonable alternative; the planner should rebut explicitly.

Three CHALLENGE verdicts, no REJECT, 8 routes audited. Strategy is broadly sound and goal-aligned; the CHALLENGEs are framing/disclosure refinements, not structural redirects.
