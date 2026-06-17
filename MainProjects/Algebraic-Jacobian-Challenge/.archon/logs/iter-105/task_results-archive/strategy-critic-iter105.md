# Strategy Critic Report

## Slug
iter105

## Iteration
105

## Routes audited

### Route: Phase A — Čech acyclicity (`BasicOpenCech.lean`)

- **Goal-alignment**: PARTIAL — Čech acyclicity for `toModuleKSheaf` over basic-open covers feeds project-local sheaf cohomology, which underlies `representable` in C3, which underlies the protected `Jacobian`. The chain is long; the connection is correct in principle but each intermediate link is itself partial.
- **Mathematical soundness**: PASS — proving `cechCofaceMap` R-linearity per summand is a routine bookkeeping step in a Čech complex construction. The math is standard.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags section. Six consecutive iters of wrapper-engineering on `cechCofaceMap_pi_smul` without commitment to option (3) "bypass wrapper entirely" is the canonical 5×-cost-of-restart antipattern. The strategy lists (3) as an option but the active target language ("Iter-107 plan picks among: (1)…(2)…(3)") keeps (3) co-equal with two more incremental moves, which biases the planner to (1)/(2) again.
- **Phantom prerequisites**: `IsLocalizedModule.Away` exists (verified); `IsLocalizedModule.Away` on **finite products** as a Pi-type instance is the project's claimed gap, and it is plausibly absent. The strategy correctly flags this.
- **Effort honesty**: under-counted — estimate "3–6 iters / ~80 LOC" but six iters have already been spent on a single `sorry` slot at L1179. Either the slot is structurally harder than the original estimate or option (3) is genuinely the right move and hasn't been tried. Either way the residual estimate should not be revised downward.
- **Verdict**: CHALLENGE — STRATEGY must explicitly state the iter-107 abort policy: if option (1)/(2) doesn't close L1179 this iter, the next iter is committed to option (3) (rip the wrapper). The current "pick among" framing is open-ended and produces another iter of wrapper engineering by default.

### Route: Phase B — Cotangent sheaves (`Differentials.lean`)

- **Goal-alignment**: PASS — cotangent sequences feed `SmoothOfRelativeDimension (genus C)` which is a protected instance. Direct line of sight.
- **Mathematical soundness**: PASS — cotangent exact sequence is classical (Hartshorne II.8). Strategy correctly identifies that proving sheaf exactness from stalk/section data is the hard part.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: "Stalkwise criterion for `SheafOfModules` exactness" — strategy claims both routes (stalkwise and section-wise) absent from Mathlib. I did not verify this comprehensively; it is plausible since modern Mathlib's `SheafOfModules` infrastructure is partial. The strategy honestly defers `h_exact` via inline sorry, which is sound per the project's own soundness rule.
- **Effort honesty**: reasonable — "8–12 iters / ~250 LOC" for 5 sorries (one deferred) is in the right range, given that `h_exact` is bracketed out.
- **Verdict**: SOUND.

### Route: Phase C0 — Monoidal `X.Modules` (`instIsMonoidal_W`)

- **Goal-alignment**: PASS — strategy correctly notes C0 does not gate C1/C2/C3 (because Phase C1's invertible-object route can be done in the bundled-monoidal-category formulation that already works for known-Mathlib cases). Deferring is correct.
- **Mathematical soundness**: PASS — the deferral is justified by a genuine Mathlib gap (varying-ring `R₀` stalk).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` for varying-ring R₀ is absent (plausible, did not verify exhaustively).
- **Effort honesty**: 0 LOC remaining is honest given the deferral.
- **Verdict**: SOUND.

### Route: Phase C1 — Refined `LineBundle`

- **Goal-alignment**: FAIL → PASS-after-refactor. The current `def LineBundle X := CommRing.Pic Γ(X, ⊤)` is admitted-wrong on non-affine schemes (verified: `CommRing.Pic` is the Mathlib commutative-ring Pic in `Mathlib.RingTheory.PicardGroup`, which gives the wrong group for X non-affine — e.g. `Pic(ℙⁿ_k)` should be ℤ but `CommRing.Pic Γ(ℙⁿ_k, ⊤) = CommRing.Pic k = trivial`). The strategy correctly flags this but defers the refactor.
- **Mathematical soundness**: FAIL until refactored. A definition that's mathematically wrong even with no theorems proved against it is a load-bearing rotten foundation. The strategy's own soundness rule ("Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the claim or with one whose signature is mathematically wrong") arguably already prohibits this: the LineBundle def is mathematically wrong and downstream code uses it.
- **Sunk-cost reasoning detected**: implicit — the deferral "Phase C1 sits AFTER Phase A" carries an unstated "we've invested in current LineBundle, A first" energy.
- **Phantom prerequisites**: `Invertible` of `X.Modules` — depends on monoidal structure that is partially deferred (C0). However, for Phase C1 the bundled `ModuleCat.SheafOfModules` flavor with `Invertible` should be reachable without the full `instIsMonoidal_W`.
- **Effort honesty**: under-counted — "3 iters / ~100 LOC" for redefining `LineBundle` as `Invertible (X.Modules)` plus re-deriving the comm-group structure and all downstream usage sites is optimistic. Realistic: 5–8 iters / 200–300 LOC. Especially because the comm-group structure on `Invertible (X.Modules)` may itself need new lemmas about tensor inverses being unique up to iso.
- **Verdict**: CHALLENGE — STRATEGY must specify (a) what triggers C1 promotion ahead of A if A stalls a second time, and (b) how the wrong-def is contained from contaminating Phase B's `Picard_FunctorAb` derivation. Without these guards, any downstream `LineBundle`-typed lemma proved during Phase B with the wrong def is technical debt against the eventual refactor.

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS — re-derive `PicardFunctor C` against the correct `LineBundle` def.
- **Mathematical soundness**: PASS conditional on C1 succeeding.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: depends on étale sheafification — Mathlib's étale topology is partial; verify before commit.
- **Effort honesty**: under-counted — "2 iters / ~50 LOC". A full re-derivation including étale sheafification and the abelian-group structure is closer to 4–6 iters / ~150 LOC, especially if the C1 refactor reshapes downstream API surfaces.
- **Verdict**: CHALLENGE on estimate; SOUND on plan.

### Route: Phase C3 — Representability of PicardFunctor (`JacobianWitness`)

- **Goal-alignment**: PASS in principle — closing C3 is what makes the protected `Jacobian` instance witness a real scheme.
- **Mathematical soundness**: PARTIAL — both proposed routes (FGA-via-Hilbert and `Sym^g C / S_g`) are correct mathematics. But the strategy admits both require infrastructure absent from Mathlib (Hilbert/Quot schemes; finite-group quotients of schemes). The plan to build either *from inside this project* is a moonshot.
- **Sunk-cost reasoning detected**: no, but optimism bias is present.
- **Phantom prerequisites**:
  - `Hilb_{C/k}` scheme construction — confirmed absent (no Mathlib hits for Hilbert/Quot schemes of curves).
  - Finite-group quotients of schemes — confirmed absent (search returned only `Action.FintypeCat.term_⧸ₐ_` for FintypeCat, not for `Scheme`).
  - Étale descent for line bundles (implicit) — partial in Mathlib.
- **Effort honesty**: WILDLY under-counted — "10–15 iters / ~1500 LOC". A realistic estimate for constructing either route from current Mathlib:
  - **FGA-via-Hilbert route**: building the Hilbert scheme of curves from scratch is a Hartshorne-chapter-sized undertaking, ~5,000–10,000 LOC of foundational AG. The full FGA representability theorem on top is another several thousand LOC.
  - **`Sym^g C / S_g` route**: constructing finite-group quotients of schemes requires either GIT (geometric invariant theory, missing from Mathlib) or a base-case treatment for finite étale group actions (also missing). The birational Abel–Jacobi argument then requires birational equivalence theory and Riemann–Roch (the latter is implicit in `genus`, but the equivalence theory is not).
  - Realistic range: 50–150 iters / 5,000–15,000 LOC for either route.
- **Verdict**: REJECT (as currently scoped). The strategy must either:
  - (a) explicitly accept a project scope of 50+ iters and rewrite the estimate, or
  - (b) defer C3 indefinitely and accept that the protected `Jacobian`/`ofCurve` bodies remain `sorry`-routed to a `JacobianWitness` placeholder (similar to `h_exact` and `instIsMonoidal_W` deferrals), or
  - (c) pick a third route the strategy hasn't named (see Alternatives section).
  - Continuing C3 work without one of (a)/(b)/(c) is sunk-cost reasoning in expectation: each future iter on C3 with current estimates will under-deliver and the gap will compound.

### Route: Phase D — `genus`/`Jacobian`/instances ("closed iter-073")

- **Goal-alignment**: PASS in formal sense; FAIL in content sense — the file compiles with stubs that defer to `JacobianWitness` (C3). Since C3 is incomplete, the protected declarations are formally non-`sorry` but mathematically vacuous. The accounting "0 iters / 0 LOC remaining" hides this.
- **Mathematical soundness**: PASS conditional on C3.
- **Sunk-cost reasoning detected**: no, but accounting is misleading.
- **Phantom prerequisites**: depends entirely on C3.
- **Effort honesty**: misleading — "closed" is true at the file level (no inline `sorry` in D's file) but false at the math level (everything is routed to C3's `sorry`).
- **Verdict**: CHALLENGE — STRATEGY's status table should show D/E as "blocked-on-C3", not "closed iter-073". The current framing produces a false sense of progress and obscures that the project is ~95% prerequisite-work for one final theorem.

### Route: Phase E — Abel–Jacobi ("closed iter-073")

- Identical analysis to Phase D. **Verdict**: CHALLENGE — re-status as "blocked-on-C3" in the strategy table.

## Alternative routes (suggested)

### Alternative: Direct construction of Pic⁰ via divisor classes (bypass Hilbert and Sym^g)

- **What it looks like**: For a smooth proper curve C/k, the group `Pic⁰(C)` of degree-zero divisor classes can be constructed as a group object in Sch/k without invoking either Hilbert or quotient schemes. The idea: pick a base divisor D₀ of degree g (e.g. g times the base point P); use Riemann–Roch to show `h⁰(D₀ + (some degree-0 divisor)) = 1` generically; this gives a birational map from the symmetric product to Pic⁰. But instead of constructing Sym^g(C) as a scheme, define `Pic⁰(C)` directly as the *scheme-theoretic image* of the morphism `C^g → Pic^g` (sending (P₁, …, P_g) to the class of P₁ + … + P_g − gP) and verify this is a group scheme via the Riemann–Roch argument. This avoids constructing Sym^g(C) as a separate scheme.
- **Why it might be cheaper or sounder**: skips two major infrastructure tracks (Hilbert/Quot and finite-group quotients) at the cost of needing scheme-theoretic image (which Mathlib has partially) and Riemann–Roch (which is implicit in `genus` and may be partially available).
- **What the current strategy may have rejected**: unclear — the strategy presents two binary options without listing this third path. Likely because the "scheme-theoretic image is a group scheme" step is itself hard. But it is no harder than the missing pieces in routes (a) and (b).
- **Severity of the omission**: major — third route deserves explicit consideration before committing C3's binary choice.

### Alternative: Defer C3 indefinitely; ship the project with C3 as an open `sorry`-routed witness

- **What it looks like**: Phase C3 declares a structure `JacobianWitness C : Type` with `sorry`-bodied fields for representability data, plus an `instance : Inhabited (JacobianWitness C)` body that is `sorry`. Phases D and E reach the protected `Jacobian`/`ofCurve` via this witness. The project ships at the end of Phase C2 with the protected declarations compiling but with a single named, file-level `sorry` in `JacobianWitness`, mirroring the treatment of `h_exact` and `instIsMonoidal_W`.
- **Why it might be cheaper or sounder**: it is the only way to terminate the project in finite time with current Mathlib. The strategy already accepts deferred `sorry`s for `h_exact` and `instIsMonoidal_W` — extending the same treatment to C3 is consistent. The project would then be a *framework* for the Jacobian (genus, Picard functor, all instances) that bottoms out in a single named Mathlib gap (`JacobianWitness`), which is honest.
- **What the current strategy may have rejected**: the protected declarations are described as "deliverables" so the planner may resist deferring them. But the protected declarations are *signatures*, not *implementations*: a sorry-routed body still satisfies the signature requirement.
- **Severity of the omission**: critical — without an "exit strategy" for C3, the project has no defined endpoint.

### Alternative: Re-prove `cechCofaceMap_pi_smul` without the named-family wrapper (committed option 3)

- **What it looks like**: discard `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`, and the Route-1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`. Rewrite `cechCofaceMap_pi_smul`'s body to prove the alternating-sum R-linearity in-line, accepting ~50–80 LOC of bookkeeping per summand index but no `eqToHom` transport gymnastics.
- **Why it might be cheaper or sounder**: the strategy itself reports 6 iters of wrapper engineering without closure, and the residual issue is exactly an `eqToHom` transport that wouldn't exist without the wrapper. In-line bookkeeping is uglier but eliminates the discrimination-tree pattern-unification failure mode.
- **What the current strategy may have rejected**: the planner has invested in the wrapper. The "pick among (1)…(2)…(3)" framing of iter-107 keeps (3) co-equal with two more incremental moves.
- **Severity of the omission**: major — the strategy lists this as an option but does not commit to it as the fallback if (1)/(2) stall again.

## Sunk-cost flags

- **"Iter-107 plan picks among: (1) heartbeat lift + retry, (2) lemma rework without eqToHom, (3) bypass wrapper entirely."** — Why this is sunk-cost: After 6 iters of wrapper engineering, listing "bypass wrapper" as a co-equal option (rather than the default for the next iter if (1)/(2) fail) presumes wrapper engineering is still the right structural choice. The first six iters are evidence against. Recommendation: rewrite the active-target paragraph to commit iter-108 to option (3) if iter-107 does not close L1179.

- **"Phase C1 ... should be the priority refactor after A"** — Why this is sunk-cost: the "after A" ordering carries an unstated "A is closer to closure so finish it first" energy, but A has been at 80% closure for 6+ iters. Recommendation: define a trigger ("if A stalls a 3rd time, promote C1") explicitly in STRATEGY.md.

- **Implicit: status of Phases D and E as "closed iter-073"** — Why this is sunk-cost: it preserves the *narrative* that two phases are done, even though their content depends on C3. Recommendation: re-status D and E as "blocked-on-C3" in the phase table; the protected declarations compile with sorry-routed witnesses, which is honest framing.

## Prerequisite verification

- `IsLocalizedModule.Away`: VERIFIED (exists in `Mathlib.Algebra.Module.LocalizedModule.Basic`).
- `IsLocalizedModule.Away` on finite products: not directly verified, but search hits in `Mathlib.RingTheory.LocalProperties.Submodule` are all for Pi over a *spanning set*, not a *finite product*. The project's specific need (finite product) plausibly is absent.
- `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀): not verified (rate-limited); strategy claims absent — plausible.
- `CommRing.Pic`: VERIFIED (exists in `Mathlib.RingTheory.PicardGroup`); confirms the strategy's flagged-wrong-def claim is honest (`CommRing.Pic k` is trivial for a field, so `LineBundle ℙⁿ_k` would be trivial via the current def, which is wrong).
- `SheafOfModules.IsQuasicoherent`: VERIFIED (exists in `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`).
- Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves in Mathlib: MISSING (the strategy correctly notes the project builds this locally via `Abelian.Ext`).
- Hilbert scheme `Hilb_{C/k}`: MISSING.
- Finite-group quotients of schemes (`Scheme / G` for finite G): MISSING (search returned only `FintypeCat`-flavored quotients).
- Stalkwise criterion for `SheafOfModules` exactness: not verified; strategy claims absent — plausible.
- `Smooth`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension`, `GrpObj`: not directly verified, but these underpin the protected signatures and are presumed present (they appear verbatim in `references/challenge.lean` which compiles).

## Must-fix-this-iter

- **Route A: CHALLENGE** — STRATEGY must specify the iter-108 abort policy: if iter-107 option (1) or (2) does not close L1179, the next iter is committed to option (3) (rip the wrapper). Eliminate the "pick among" framing.
- **Route C1: CHALLENGE** — STRATEGY must (a) define a trigger for promoting C1 ahead of A if A stalls again, and (b) state how the wrong-def is contained from contaminating Phase B's `Picard_FunctorAb` re-derivation in the interim. Re-state estimate to 5–8 iters / 200–300 LOC.
- **Route C2: CHALLENGE** — estimate "2 iters / ~50 LOC" is under-counted; revise to 4–6 iters / ~150 LOC.
- **Route C3: REJECT** — pick one of (a) explicit-50+-iter scope, (b) defer-via-witness, (c) the divisor-class-image alternative. Continuing without an exit strategy is sunk-cost reasoning.
- **Routes D and E: CHALLENGE** — re-status as "blocked-on-C3" in the phase table.
- **Alternative "Defer C3 indefinitely via `JacobianWitness`": critical** — the strategy must explicitly accept or reject this. Without an exit strategy the project has no termination condition.
- **Alternative "Divisor-class-image Pic⁰": major** — the strategy must name this option in the C3 binary choice or explicitly reject it.
- **Alternative "In-line `cechCofaceMap_pi_smul`": major** — the strategy must commit to this as the iter-108 fallback if iter-107 stalls.
- **Sunk-cost: wrapper engineering on `cechCofaceMap_pi_smul`** — rewrite Phase A active-target paragraph to make option (3) the default fallback.
- **Phantom prerequisite `IsLocalizedModule.Away` on finite products**: strategy assumes this is achievable in ~80 LOC; not independently verified. Planner should spot-check before iter-108.

## Overall verdict

A fresh mathematician would NOT approve this strategy as-is. The Phase A tactical work is salvageable with a clearer commit-to-option-(3) rule. Phase B is sound. Phase C1's wrong-def is acknowledged but the deferral lacks containment guards. Phase C2's estimate is optimistic. **Phase C3 is the structural problem**: ~1,500 LOC for representability of `PicardFunctor` over arbitrary fields is an order of magnitude under-counted, and both proposed routes depend on infrastructure (Hilbert/Quot schemes, finite-group quotients of schemes) that is confirmed absent from Mathlib. The project has no defined endpoint without either accepting a 50+-iter scope, accepting a `JacobianWitness`-deferred terminus, or naming a third route. The narrative that Phases D and E are "closed" further obscures that 100% of the remaining mathematical content lives in C3.

The most urgent strategic decision is not which tactic to pick on L1179 — it is whether the project terminates by *constructing* the Jacobian (50+ iters, two phantom infrastructure tracks to build) or by *witnessing* it (consistent with the project's existing deferral pattern for `h_exact` and `instIsMonoidal_W`). STRATEGY.md must answer this before the next prover dispatch on C3-aimed work.
