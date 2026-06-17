# Strategy Critic Report

## Slug
iter112

## Iteration
112

## Routes audited

### Route: Phase A — Čech acyclicity (DEFERRED-gated)

- **Goal-alignment**: PASS — Phase A residual sorries do not enter the protected-declaration chain; their treatment as off-path (L1846 budget-deferred, L1120 PAUSED, L1212/L1536/L1564/L1754 substep-gated) is consistent with the stated end-state surface.
- **Mathematical soundness**: PASS — the budget-deferral on L1846 is correctly distinguished from a Mathlib gap (Mathlib has `IsLocalizedModule.{Away,pi,prodMap}`, verified via leansearch this iter). L1120 PAUSED on documented dual-path documentation (`finite-product-localisation-and-cech-r-linearity.md`).
- **Sunk-cost reasoning detected**: no — strategy treats inline scaffolding at L1786–L1834 explicitly as "inert infrastructure for future re-attempt," not as a justification to keep pushing L1846 by the same method.
- **Phantom prerequisites**: none new this iter; verified Mathlib names hold.
- **Effort honesty**: reasonable — per-substep close-out figure "~30–80 LOC conditional on predecessor landing" is now correctly bracketed and **not** scheduled in "Path from today."
- **Verdict**: SOUND.

### Route: Phase B — Cotangent sheaves (3 prover-buildable + 1 deferred-parallel + 1 named-gap)

- **Goal-alignment**: PARTIAL — none of L122/L735/L718/L636/L877 are in the chain of the 9 protected declarations. L877 (`serre_duality_genus`) is explicitly tagged "forward-compatibility named-deferral; no current protected signature consumes this." L122/L735/L718 are similarly orphans relative to the protected chain. The strategy does not explicitly justify *why* the autonomous loop schedules ~4–8 iters / ~200 LOC of prover work on Differentials.lean given this. The only implicit rationale is "deliver the project's content beyond the strict protected set." That rationale is defensible but needs to be **named** so a fresh reader doesn't mistake it for sunk-cost continuation of pre-JacobianWitness-exit-policy scope.
- **Mathematical soundness**: PASS — dispatch order L122 → L735 → L718 follows the dependency graph (L735 is a corollary of L718 via pullback preservation; L122 is foundational because downstream depends on `relativeDifferentials`; L718 is the Hartshorne II.8.15 heavy core). The basis-to-opens descent for L122 is correctly flagged as non-trivial sub-lemma work, not a Mathlib gap.
- **Sunk-cost reasoning detected**: borderline. Phase B work is scheduled without explicit goal-tie to the protected deliverables; the implicit driver is "we already committed to these sorry sites being prover-closable." That's a sunk-cost smell, but it's mild — the work is genuinely mathematical content, not infrastructure-for-its-own-sake.
- **Phantom prerequisites**: `TopCat.Presheaf.IsSheaf.isSheafOpensLeCover` verified in Mathlib; the strategy's reference to "Route (a) refinement-cofinality against `isSheaf_iff_isSheafOpensLeCover` [verified]" is honest. `AlgebraicGeometry.Modules.tilde` previously verified per blueprint-writer-iter111; not re-verified this iter (loogle timed out) but no reason to suspect drift.
- **Effort honesty**: reasonable — L122 estimate upward-revised iter-111 (~2–3 iters / ~100–200 LOC) is honest about the basis-to-opens descent friction; L718 calibrated as heaviest (~2–4 iters); L735 as cheapest corollary (~1–2 iters).
- **Verdict**: CHALLENGE — see Must-fix below. The math and order are sound; the *scope rationale* is missing.

### Route: Phase C0 — Monoidal `X.Modules` (dormant pre-C1, load-bearing post-C1)

- **Goal-alignment**: PARTIAL — `instIsMonoidal_W` is not in the protected chain. Its "load-bearing post-C1" disclosure is for the **Picard arc** (`Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`), not for any protected `Jacobian`/`AbelJacobi` declaration. This is correctly disclosed in the End-state section ("did you build the Picard framework... yes, but the framework type-checks transitively against the named Mathlib gap..."). The disclosure is honest; the goal-tie is project-content (blueprint commitment to Picard) rather than protected-declaration delivery.
- **Mathematical soundness**: PASS — the `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀) gap is real in Mathlib b80f227.
- **Sunk-cost reasoning detected**: no — the strategy doesn't argue "keep working on Monoidal because we started." It defers indefinitely.
- **Phantom prerequisites**: none in scope.
- **Effort honesty**: 0 — correctly accounted as a parked gap with no scheduled close-out.
- **Verdict**: SOUND.

### Route: Phase C1 — Refined `LineBundle` (DONE iter-109)

- **Goal-alignment**: PARTIAL — same observation as C0: `LineBundle X := (Skeleton X.Modules)ˣ` is project-content, not protected. The C1 promotion succeeded but is orthogonal to delivering the 9 protected declarations (which are routed via JacobianWitness, not via Picard).
- **Mathematical soundness**: PASS — `Skeleton` for monoidal categories exists in Mathlib (`CategoryTheory.Skeleton.one_eq` verified via leansearch this iter); `(Skeleton X.Modules)ˣ` is well-typed if `BraidedCategory (X.Modules)` is inhabited (transitive on `instIsMonoidal_W`).
- **Sunk-cost reasoning detected**: no — the C1 promotion delivered a *correct* (`(Skeleton X.Modules)ˣ`) definition replacing a previous approximation (`CommRing.Pic Γ(X, ⊤)`). The rationale is mathematical (the previous definition was wrong); not sunk-cost.
- **Phantom prerequisites**: none new — `MonoidalCategory.Invertible` flagged iter-108 was resolved iter-109 via the analogist consult; the body uses `Units` of the skeleton-monoid which is the safer Mathlib chain.
- **Effort honesty**: 0 (DONE).
- **Verdict**: SOUND.

### Route: Phase C2 — `PicardFunctor` re-derivation (verification round)

- **Goal-alignment**: PARTIAL — same as C0/C1: Picard arc is not in the protected chain. The "verification round" (cheap intel: read `Picard/Functor.lean` post-C1 + spot-check `fiberMap`/`quotMap`) is reasonable as **read-only audit** to confirm the C1 universe bumps cleanly absorbed.
- **Mathematical soundness**: PASS — the audit task is well-defined.
- **Sunk-cost reasoning detected**: no — the bracketing "~0–4 iters / ~0–80 LOC" captures the uncertainty honestly. Most likely outcome (per strategy) is 0 further work.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — small uncertainty window appropriate for a verification pass.
- **Verdict**: SOUND.

### Route: Phase C3 — Representability / `JacobianWitness` exit policy

- **Goal-alignment**: PASS — the protected `Jacobian`/`ofCurve`/instances route through `Nonempty (JacobianWitness C)` (sorry at `Jacobian.lean:179`). The signatures match the protected list verbatim; the bodies bottom out in a single named gap. End-state framing is plain-language disclosure ("we ship a framework, conditional on the witness — we do NOT autonomously construct the Jacobian"). This is the strategy-critic-iter105 REJECT honestly absorbed.
- **Mathematical soundness**: PASS — the witness pattern is logically clean (one existence sorry; downstream bodies are `(some_witness).field` extractions).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: Hilbert/Quot, finite-group scheme quotients — both correctly flagged absent and deferred indefinitely.
- **Effort honesty**: 0 — deferred indefinitely with explicit policy.
- **Verdict**: SOUND.

### Route: Phase D, E — `genus`/`Jacobian`/instances + Abel–Jacobi (file-level closure)

- **Goal-alignment**: PASS — these are the protected files; they compile against the JacobianWitness sorry at `Jacobian.lean:179` plus their own routings.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 (already closed at file level).
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Trim project scope to the 9 protected declarations + their direct dependency cone

- **What it looks like**: Audit which `.lean` files contribute to the axiom chain of the 9 protected declarations. Any sorry-bearing file (`Differentials.lean`, `Picard/*.lean`, `Modules/Monoidal.lean`) that does **not** transitively feed a protected declaration is candidate for: (a) trimming to declared-only-no-proof status, or (b) deletion entirely. Specifically: after Phase C3 exit via JacobianWitness, the Picard arc (LineBundle, PicardFunctor, PicardFunctorAb) is decoupled from the protected chain — so `instIsMonoidal_W` + the iter-109 sister pair `(pullback_tensorObj, pullback_oneIso)` could be left as `sorry` indefinitely with no further work scheduled. Same for L122/L735/L718 in Differentials.lean. The autonomous loop would terminate immediately after Phase C2 verification audit.
- **Why it might be cheaper or sounder**: Cuts ~6–12 prover iters and ~150–300 LOC from the schedule. Reduces the risk that prover-budget burns on content orthogonal to the deliverables. Sharpens the project's identity: "we deliver 9 framework declarations + 1 named gap (`nonempty_jacobianWitness`)" is a tighter story than "we deliver 9 framework declarations + ship a Picard formalism + ship cotangent-sheaf content."
- **What the current strategy may have rejected**: The strategy's implicit answer is probably "the blueprint commits to Picard and Differentials chapters; trimming to protected-only would invalidate blueprint chapters." That's defensible. But it's not stated in STRATEGY.md — the strategy lists Phase B / Phase C2 as forward work without explaining why they're on the schedule given the C3 exit policy shorted out the Picard-routed Jacobian construction.
- **Severity of the omission**: major — not because the project should necessarily trim, but because a fresh reader genuinely cannot tell from STRATEGY.md alone whether the remaining Phase B and Phase C2 work is (i) load-bearing for a stated deliverable, (ii) blueprint-completeness commitment, or (iii) sunk-cost momentum from pre-iter-107 scope. Naming the rationale would clarify.

### Alternative: Tighten the "7 named gaps" disclosure to "load-bearing for protected vs. orphan disclosure"

- **What it looks like**: Split the 7-named-gaps roster into two sub-counts:
  - **Load-bearing on protected**: 1 (`nonempty_jacobianWitness` only — this is the gap a `lean_verify` on any protected declaration surfaces).
  - **Orphan disclosure** (in project `.lean` files but no protected chain depends on them): `cotangentExactSeq_structure.h_exact`, `instIsMonoidal_W`, `PicardFunctor.representable`, `SheafOfModules.pullback_tensorObj`, `SheafOfModules.pullback_oneIso`, `serre_duality_genus` — these are honest project-content sorries but do not block the 9 protected deliverables.
- **Why it might be cheaper or sounder**: Reader transparency. The current "7 named gaps + 1 budget-deferral" headline blends two different categories of sorries. A fresh reader counting gaps would assume all 7 stand between the project and shipping; in fact only 1 does (`nonempty_jacobianWitness`).
- **What the current strategy may have rejected**: Probably nothing — this is purely presentational. The "What's unconditional vs framework-conditional" section already gives the split implicitly; promoting it to the headline would be a small refinement.
- **Severity of the omission**: minor.

## Sunk-cost flags

- `"Phase B autonomous-loop scope is now 3 sorries"` — Why this is sunk-cost-adjacent: the strategy frames Phase B as ongoing prover work without re-justifying why L122/L735/L718 are in scope after the C3 exit policy decoupled the protected `Jacobian` from any Differentials-chain dependency. Recommendation: name the goal-tie explicitly ("Phase B prover work delivers blueprint-chapter content commitments beyond the protected set; the autonomous loop schedules it because [...]").
- `"Largely absorbed by iter-109 universe bumps. ... Likely outcome: no further work needed"` — Why this is mildly sunk-cost-adjacent: the C2 verification round is justified post-hoc by C1's iter-109 outcomes rather than by what C2 contributes to the protected deliverables. Recommendation: explicitly state that C2 is a *read-only audit* this iter, not a prover lane. The current text already implies this; making it explicit removes any inferring on the planner's part.

## Prerequisite verification

This iter's spot-checks (loogle timed out; leansearch used as backup):

- `IsLocalizedModule.Away`: VERIFIED (`Mathlib.Algebra.Module.LocalizedModule.Away`, both `abbrev` forms).
- `IsLocalizedModule.pi`: VERIFIED (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`, instance form).
- `IsLocalizedModule.prodMap`: NOT RE-VERIFIED this iter (loogle unavailable; named verified in strategy text per strategy-critic-iter108). Trust strategy claim.
- `TopCat.Presheaf.IsSheaf.isSheafOpensLeCover` / `IsSheafOpensLeCover`: VERIFIED (`Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover`).
- `CategoryTheory.Skeleton` for monoidal categories: VERIFIED (`CategoryTheory.Skeleton.one_eq` in `Mathlib.CategoryTheory.Monoidal.Skeleton` confirms Skeleton has Monoidal interplay).
- `AlgebraicGeometry.Modules.tilde`: NOT RE-VERIFIED this iter (named verified by blueprint-writer-differentials-iter111 per strategy text).
- `(SheafOfModules.pullback _).Monoidal`: claim is ABSENT — not re-verified this iter, but the strategy's claim of absence (analogist-c1-route iter-108) is internally consistent with the existence of the iter-109 sister-pair workaround.

No phantom prerequisites detected. Strategy's Mathlib infrastructure claims are honest under the verifications I could complete this iter.

## Must-fix-this-iter

- **Route Phase B: CHALLENGE** — The strategy schedules ~4–8 iters / ~200 LOC of Phase B prover work (L122, L735, L718) without explicit goal-alignment to the 9 protected declarations or to a named blueprint deliverable. A fresh reader cannot tell whether this work is required for shipping, blueprint-completeness, or vestigial pre-C3-exit-policy scope. **Planner must address** in STRATEGY.md (or rebut in `iter/iter-112/plan.md`) by naming the rationale: e.g. "Phase B closes Differentials.tex blueprint commitments beyond the protected set; this is independent project scope, not load-bearing for the JacobianWitness arc."

- **Alternative: Trim project scope to protected-only — major** — Related to the above. The strategy should explicitly acknowledge that the autonomous loop's remaining scheduled work (Phase B non-h_exact non-L877 sorries, Phase C2 verification, post-C1 disclosure tracking) is *not* required to deliver the 9 protected declarations. Currently the End-state framing emphasizes 7 named gaps + 1 budget-deferral as if all stand between the project and shipping; in fact only `nonempty_jacobianWitness` does. Naming this in the End-state section would clarify the actual delivery surface vs. the disclosure surface.

- **Alternative: Tighten "7 named gaps" headline — minor** — Optional presentational refinement: split the 7-named-gaps headline into "1 load-bearing on protected + 6 orphan disclosures." Not blocking; aids reader clarity.

## Overall verdict

A fresh mathematician would approve the strategy **with one substantive challenge**: the schedule continues to allocate prover budget to Phase B (Differentials sorries L122/L735/L718) and Phase C2 (verification round) without explicitly tying those tasks to either (a) the 9 protected declarations or (b) a named blueprint-completeness commitment. After the iter-107 C3 exit policy decoupled the protected `Jacobian` from the Picard arc and after iter-110 reclassified L877 as a named-gap, the autonomous loop's remaining work is mostly **orphan content** relative to the protected deliverables. This may be intentional (blueprint scope ≠ protected scope), but the strategy must state the rationale rather than letting the reader infer it. Beyond this, prerequisite Mathlib infrastructure is correctly verified, the C3 / JacobianWitness exit pattern is soundness-rule-compliant, the post-C1 load-bearing disclosure on `instIsMonoidal_W` is honest, and the prior-iter framing asks (Phase A `DEFERRED (gated)`, L718 heaviest, L122 upward-revised) are addressed in the current text. SOUND-with-CHALLENGE overall: 7 routes audited, 1 CHALLENGE verdict (Phase B scope rationale), 0 REJECT verdicts.
