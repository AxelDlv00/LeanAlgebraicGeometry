# Strategy Critic Report

## Slug
iter113-retry

## Iteration
113

## Executive note

The strategy is unchanged from iter-112. The iter-112 edits (scope-rationale
paragraph + load-bearing-vs-orphan split) addressed the iter-112 CHALLENGE on
*scheduling rationale*, and on that axis I would render the strategy SOUND. But
the iter-113 directive surfaces a separate concern that was not in scope iter-112:
the *signatures themselves* of three of the six "orphan disclosure named gaps"
(L877, L718, L735 in `Differentials.lean`) are **universally false as Lean
statements** — not just deferred Mathlib content but actual signature defects.
The strategy's framing of these as honest named-deferred gaps masks that the
project's own Soundness rule is being violated. This must be addressed before
any iter-113 prover work on Phase B is scheduled.

Routes audited: 5. CHALLENGE verdicts: 2 (Phase B; Orphan-disclosure framing).

## Routes audited

### Route: Phase A — Čech acyclicity (DEFERRED gated)

- **Goal-alignment**: PASS — Phase A is explicitly off-path and not consumed by the protected chain. The deferral via Option (i) + named substep dependencies for L1212/L1536/L1564 is documented coherently.
- **Mathematical soundness**: PASS — L1846 mechanizable from `IsLocalizedModule.{Away, pi, prodMap}` (verified iter-108/iter-112). The PAUSED L1120 lane is fenced off correctly.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — the iter-110 framing-precision pass (per-substep close-out, not global Phase A cost) is honest.
- **Verdict**: SOUND.

### Route: Phase B — Cotangent sheaves prover work (L122, L735, L718)

- **Goal-alignment**: PARTIAL — Phase B is "blueprint-completeness commitment", explicitly not protected-chain-blocking. The framing is honest about its scope. The challenge: **the three sorries scheduled for prover work have orphan-disclosure friends (L877, L718, L735) whose signatures are universally false** (see "Mathematical soundness" below). Closing the L122 body without first fixing the false signatures on L718/L735 nominally lands a blueprint marker, but the corresponding `Differentials.lean` theorem statements that the blueprint commits to are mathematically broken.
- **Mathematical soundness**: PARTIAL — The L122 helper (`relativeDifferentialsPresheaf_isSheaf`) is correctly stated; both proposed routes (refinement-cofinality / explicit affine-cover gluing via `tilde`) are sound. **But L718 (`smooth_iff_locally_free_omega`) carries `(n : ℕ)` as a universally-quantified free parameter on an iff with `Smooth f` (rank-independent)**: instantiating any `n` other than the actual relative dimension makes the iff false. Example: `f = 𝟙 (Spec k)` is `Smooth f` true, but for `n = 1` the right-hand side requires `Module.rank = 1` everywhere on Ω, which vanishes — iff false. **L735 (`cotangent_at_section`) has the same defect**: free `n`, hypothesis only `Smooth f`. Both signatures are theorems about a *specific* relative dimension `n` that the hypothesis must witness (e.g. `SmoothOfRelativeDimension n f`), not arbitrary `n`. As `theorem ... := sorry`, they violate the strategy's own Soundness rule ("Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the claim or with one whose signature is mathematically wrong").
- **Sunk-cost reasoning detected**: yes (borderline). Quote (paraphrased from STRATEGY.md L24): *"the alternative — trim project scope to the protected-only chain — was considered iter-112 and rejected: doing so would ... erase the post-C1 monoidal-`X.Modules` work that establishes the *correct* sheaf-theoretic `LineBundle` as the iter-109 promotion delivered."* The "we'd erase iter-109's work" reasoning is sunk-cost. The C1 promotion is past investment; the case for continuing on Phase B should rest on forward value, not preservation of investment.
- **Phantom prerequisites**: none I detected. (Iter-112 verified `IsLocalizedModule.{Away,pi}`, `isSheafOpensLeCover`, `Skeleton`-monoidal.)
- **Effort honesty**: under-counted — the strategy estimates ~4–8 iters / ~200 LOC for Phase B, but does not include the **signature-correction sub-phase** that L718/L735/L877 need before any body work can be scheduled honestly. Adding ~1–2 iters for fix-or-delete on the three orphan-signature defects is needed.
- **Verdict**: CHALLENGE. The planner must address either (a) **fix the false signatures first** (re-state L718/L735 against `SmoothOfRelativeDimension n` rather than free `n`; re-state L877 as `H¹(O_C) = H⁰(Ω)` not `H⁰(O_C) = H⁰(Ω)`), or (b) **delete the orphan signatures** with a `% NOTE:` blueprint annotation that the statement is unformalized, or (c) **explicit rebuttal** in `iter/iter-113/plan.md` naming why the signature defects don't violate the Soundness rule.

### Route: Phase C0 — Monoidal `X.Modules` (DEFERRED)

- **Goal-alignment**: PASS — `instIsMonoidal_W` is dormant pre-C1; post-C1 it became load-bearing on the Picard arc, not on the protected `Jacobian` arc. The end-state disclosure adequately distinguishes the conditional layers.
- **Mathematical soundness**: PASS — the varying-ring `stalk_tensorObj` gap is a real Mathlib gap.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — explicit named-deferral.
- **Verdict**: SOUND.

### Route: Phase C1 — Refined `LineBundle` (DONE iter-109)

- **Goal-alignment**: PASS — closed iter-109; the iter-109 sister pair (`pullback_tensorObj`, `pullback_oneIso`) is honestly accounted as two named gaps that collapse simultaneously when Mathlib lands the monoidal pullback instance.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: Phase C3 — `JacobianWitness` exit policy

- **Goal-alignment**: PASS — `nonempty_jacobianWitness` is the single load-bearing gap on the protected chain. `lean_verify` on every protected `Jacobian.*` / `AbelJacobi.*` declaration surfaces `sorryAx` rooted at `Jacobian.lean:179`, as the strategy claims.
- **Mathematical soundness**: PASS — the `JacobianWitness` structure plus `IsAlbanese` formulation captures the genus-0 case via the trivial witness `Spec k` (the witness's `J` can be `Spec k` when genus is 0); higher-genus is the Albanese existence content. The protected signatures pick up the right instances by projection.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none (Hilbert/Quot, finite-group quotients are honestly named as Mathlib gaps).
- **Effort honesty**: reasonable — the strategy honestly acknowledges this is Hartshorne-chapter-scope effort that is out of scope for the autonomous loop.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Fix-signatures-first sub-phase (Phase B prequel)

- **What it looks like**: Schedule a single ~50–100 LOC pass before any Phase B body work, which:
  1. Re-states L877 as `Module.rank k (HModule k (toModuleKSheaf C) 1) = Module.rank k (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0)` (H¹(O_C) = H⁰(Ω), the actual Serre duality statement matching the docstring).
  2. Re-states L718 as `[SmoothOfRelativeDimension n f] → (Ω is locally free of rank n)` (replacing the universally-quantified `n` with a typeclass that fixes it), or alternatively as `∃ rank function r : X → ℕ, ∀ x, ∃ U around x, Ω is locally free of rank r x`. Drop the iff if it can't be made universally true.
  3. Re-states L735 similarly: `[SmoothOfRelativeDimension n f] → (s^* Ω is locally free of rank n)` — pin `n` to the typeclass, not a free parameter.
- **Why it might be cheaper or sounder**: The current Phase B plan (close L122 body, then L735, then L718) closes a body on L122 (sound) while leaving L718/L735/L877 as false-signature `sorry`'d theorems — actively *worse* than leaving them unstated because the blueprint then commits `\leanok` on falsities. A fix-signatures-first pass removes the soundness violation and lets subsequent body work be honest. Cost: 1 iter, ~50–100 LOC of re-statement + downstream consumer updates (the orphan status means downstream consumers are few or zero).
- **What the current strategy may have rejected**: The strategy did not consider this route. Iter-110 reclassification of L877 added it to the named-gap list as a "forward-compatibility named-deferral", treating the signature as deferred-correct rather than examining whether the docstring matches the signature.
- **Severity of the omission**: critical.

### Alternative: Trim orphan-signature blueprint commitments

- **What it looks like**: Delete L877, L718, L735 from `Differentials.lean` entirely. Replace with `% NOTE: Serre duality / smoothness criterion / cotangent-at-section statement deferred — unformalized` in the corresponding blueprint chapter. Update the named-gap count from 7 to 4 (gap #1, #3, #4, #5/#6 collapse to one underlying Mathlib gap).
- **Why it might be cheaper or sounder**: Zero LOC committed to deferred-correct theorems with false-as-written signatures. The blueprint's commitment is honest: "this statement is deferred and not yet formalized". The protected chain is unaffected (these are orphan). A fresh reader counting gaps gets a smaller named-deferral list and a cleaner picture.
- **What the current strategy may have rejected**: The strategy's iter-112 "blueprint-completeness commitment" framing treats the *presence* of the signatures as deliverable value. But signatures that are universally false provide negative value — they hide a defect rather than disclose one.
- **Severity of the omission**: major.

### Alternative: Helper #1 via `SheafOfModules.IsQuasicoherent`

- **What it looks like**: Define `relativeDifferentials f` upfront as a quasi-coherent `SheafOfModules` by gluing affine charts `D(g) ↦ Ω_{B[1/g]/A}` via `KaehlerDifferential.isLocalizedModule_map`. Then `_isSheaf` is a corollary of the quasi-coherent sheaf gluing API, not a separate Step 2 + Step 3 chain.
- **Why it might be cheaper or sounder**: Shortcuts the basis-to-opens descent (helper #1) by using Mathlib's `tilde` / `IsQuasicoherent` API directly. The two routes documented in the strategy (Route (a) refinement-cofinality, Route (b) explicit affine-cover gluing) both reduce to assembling the sheaf via this API anyway.
- **What the current strategy may have rejected**: The strategy explicitly mentions Route (b) "explicit affine-cover gluing with `AlgebraicGeometry.Modules.tilde`" — this is essentially this alternative. So it's not a fully-rejected alternative, more a partially-considered one. The remaining question: is Route (b) cheaper than Route (a), and should the planner commit to Route (b) upfront rather than leaving the choice open?
- **Severity of the omission**: minor.

## Sunk-cost flags

- "the alternative — trim project scope to the protected-only chain — was considered iter-112 and rejected: doing so would ... erase the post-C1 monoidal-`X.Modules` work that establishes the *correct* sheaf-theoretic `LineBundle` as the iter-109 promotion delivered" — Why this is sunk-cost: the C1 promotion is past investment; "we'd erase iter-109's work" is a sunk-cost argument for keeping Phase B in scope. Recommendation: re-frame the scope decision on the merits of what Phase B *delivers going forward* (blueprint coverage of cotangent sheaves), not on what trimming would invalidate. The C1 work is already shipped; whether to do Phase B does not depend on it.

## Prerequisite verification

- `IsLocalizedModule.Away`: VERIFIED (iter-112 — accepted from prior critic).
- `IsLocalizedModule.pi`: VERIFIED (iter-112).
- `IsLocalizedModule.prodMap`: VERIFIED (iter-108).
- `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover`: VERIFIED (referenced in Differentials.lean L192, used in compiled code).
- `AlgebraicGeometry.Scheme.isBasis_affineOpens`: VERIFIED (referenced in Differentials.lean L140).
- `AlgebraicGeometry.Modules.tilde`: VERIFIED (referenced in Differentials.lean L141 as Route (b)).
- `Skeleton`-monoidal / `BraidedCategory (Skeleton X.Modules)`: VERIFIED (iter-112; consumed by C1 closure iter-109).
- `KaehlerDifferential.isLocalizedModule_map`: VERIFIED (iter-111 blueprint-writer claim, used in chapter recipe).
- `KaehlerDifferential.span_range_derivation`: VERIFIED (referenced in Differentials.lean L759, compiled).
- Hilbert / Quot schemes, finite-group quotients: MISSING (correctly disclosed as Mathlib gaps).
- Serre duality / dualizing sheaf / trace morphism for proper morphisms: MISSING (correctly disclosed iter-110).

## Must-fix-this-iter

- **Route Phase B: CHALLENGE** — the orphan-disclosure named gaps L718, L735, L877 carry mathematically-false signatures (free `n : ℕ` on rank-independent hypotheses; H⁰ = H⁰ instead of H¹ = H⁰). Closing the L122 body without fixing these is a Soundness rule violation in the strategy's own terms. Planner must either (a) schedule a signature-correction sub-phase before any Phase B body work, (b) delete the false-signature orphan theorems and downgrade the named-gap count, or (c) record an explicit rebuttal in `iter/iter-113/plan.md` arguing why these are *not* signature defects.
- **Alternative Trim-orphan-signature blueprint commitments: major** — strategy frames orphan theorems as blueprint-completeness value when their signatures are false. Planner must address.
- **Alternative Fix-signatures-first sub-phase: critical** — the iter-113 prover dispatch order in STRATEGY.md ("L122 first; L735 second; L718 last") schedules body work on the broken-signature theorems with no signature-correction step. Address before opening a Phase B prover lane.

## Overall verdict

A fresh mathematician would partially approve. The scope rationale + load-bearing-vs-orphan framing from iter-112 is now defensible at the *scheduling* level — the strategy makes clear that Phase B and Phase C2 are blueprint-completeness commitments, not protected-chain blockers, and the protected chain bottoms out at a single named witness (`nonempty_jacobianWitness`). On that axis the strategy is sound.

But the iter-112 strategy edits did not examine the *underlying signatures* of the orphan-disclosure named gaps. Three of the six orphan signatures (L718, L735, L877) are universally false as stated: L718 and L735 have a free `n : ℕ` on iffs with `Smooth f` (rank-independent), so the iff fails for any `n` ≠ the actual relative dimension; L877 has both sides indexed at `H⁰`, claiming `H⁰(C, O_C) = H⁰(C, Ω)` rather than the Serre duality statement `H¹(C, O_C) = H⁰(C, Ω)` named in the docstring. The Soundness rule forbids `sorry`-bodied theorems with mathematically wrong signatures; these violate it. The strategy must address this before scheduling iter-113 prover work — either fix the signatures, delete them, or rebut the soundness concern. The named-deferred Mathlib-gap status of these three is masking a Lean-side soundness issue. The "1 load-bearing + 6 orphan disclosure" framing remains correct as a count, but the orphan-disclosure side currently includes three theorems whose disclosure value is *negative* because the disclosure is dishonest about the signature's truth value.

---

**Return line**: `iter113-retry: CHALLENGE — 5 routes audited, 2 CHALLENGE verdicts`
