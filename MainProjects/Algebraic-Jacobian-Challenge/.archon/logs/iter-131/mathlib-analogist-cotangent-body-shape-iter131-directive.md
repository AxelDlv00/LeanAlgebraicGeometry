# Mathlib Analogist Directive

## Slug
cotangent-body-shape-iter131

## Design question

For the iter-130 body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (file `AlgebraicJacobian/Cotangent/GrpObj.lean:131-170`), the iter-130 review found a structural-opacity defect: the body wraps the explicit chart-base-changed Kähler module in `Classical.choice (α := ModuleCat k) ⟨X⟩`, so the result is opaque past `Nonempty (ModuleCat k)` and the downstream rank lemma `cotangentSpaceAtIdentity_finrank_eq` cannot close against it.

Two intertwined questions:

**Q1 (proposed fix's soundness).** The iter-131 plan proposes a refactor lane that swaps the outer `Classical.choice` for a `Classical.choose`-chain (or `Classical.indefiniteDescription`) that exposes the chart `V`, the algebra structure on `Γ(G, V)`, and the algebraic Kähler module `Ω[Γ(G, V) / Γ(Spec k, U)]` as named local data so the rank lemma can `unfold cotangentSpaceAtIdentity` and reach the explicit module. Does this proposed body shape actually fix the accessibility defect? Specifically:

- Is `Classical.choose`-extracted data **definitionally accessible** in a `def` body (i.e. `cotangentSpaceAtIdentity G` reduces to an `extendScalars _ Ω[…]`-shaped term where `V`, `ψV`, and the algebra structure are extractable from the elaborated term)?
- Or does `Classical.choose` produce the same opacity as `Classical.choice` in this `def`-body context (e.g. because the surrounding `def` is `noncomputable` and `Classical.choose` invokes the same kernel-level choice operator)?
- If it does fix accessibility, what is the **rank lemma's closure path** against the refactored body? Verify the closure chain `[verified]`-or-`[expected]`-tagged in `analogies/lieAlgebra-rank-bridge.md` lines 102–118 (steps 1–6 + bridge-list) actually compose end-to-end against the proposed body. Name any `[expected]` step that should be upgraded to `[verified]` via `lean_leansearch` / `lean_loogle`.

**Q2 (alternative (B′) chart-level `m_V / m_V²`).** Strategy-critic-iter131 surfaced a chart-level variant: instead of `extendScalars ψV` applied to `Ω[Γ(V) / Γ(U)]`, define `cotangentSpaceAtIdentity G := m_V / m_V²` where `m_V ⊂ Γ(V)` is the maximal ideal corresponding to the prime `ψV^{-1}(0)` (the image of `η_G` restricted to V). Specifically:

- Does Mathlib `b80f227` ship the chart-level cotangent `m_V / m_V²` for a regular-local point of a smooth chart at lower bridge-cost than (B)?
- Is the rank lemma's closure path cleaner under (B′) — e.g. `IsRegularLocalRing.iff_finrank_cotangentSpace` + `Algebra.IsStandardSmoothOfRelativeDimension` + the chart-localisation step?
- Does (B′) give the cotangent at identity as a **named fibre object** that the iter-133+ piece (i.b) `mulRight_globalises_cotangent` shear-iso lemma can globalise more directly than (B)'s `extendScalars` form?
- What is the LOC budget for (B′)'s definition + rank lemma vs (B)'s? The iter-129 analogist (`analogies/lieAlgebra-rank-bridge.md` Decision 2) estimated (A) global stalk at 500–1000 LOC; (B′) chart-level should be intermediate.

The output should let the iter-131 plan agent decide:
- (a) proceed with the proposed `Classical.choose`-chain refactor on (B) (if Q1 says yes AND (B′) doesn't dominate); OR
- (b) pivot to (B′) chart-level `m_V / m_V²` this iter (re-doing the refactor lane as a body **replacement**, not a body shape fix); OR
- (c) pivot back to STRATEGY.md route decision via a mid-iter strategy-critic re-dispatch (if both Q1 and Q2 come back negative on (B) and (B′)).

## Project artifact(s) under question

- `AlgebraicJacobian/Cotangent/GrpObj.lean:131-170` — current iter-130 body of `cotangentSpaceAtIdentity` using `refine Classical.choice (α := ModuleCat k) ?_; obtain ⟨…⟩; exact ⟨X⟩`.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:7-62` — imports + status block describing iter-130 Replacement (B).
- `AlgebraicJacobian/Differentials.lean:124-143` — `smooth_locally_free_omega` (the project's `Algebra.IsStandardSmoothOfRelativeDimension` chart extraction).
- `analogies/lieAlgebra-rank-bridge.md:30-200` — iter-129 mathlib-analogist's Decision 1 (iter-128 zero-collapse), Decision 2 (A/B/C choice landing on (B)), Decision 3 (closure chain). **This is your source-of-truth for (B); your job is to verify its (B) recommendation survives the iter-130 opacity defect and to scope (B′) which the iter-129 analogist did NOT consider as a separate option.**

## Why now

The iter-131 plan agent is about to dispatch a refactor lane on `Cotangent/GrpObj.lean` that swaps `Classical.choice` for `Classical.choose`. Progress-critic-iter131 returned **CHURNING** on this route and mandated that an analogist consult precede the refactor (its primary corrective). Strategy-critic-iter131 returned **CHALLENGE** and also recommended a (B′) feasibility analogist. Both critics agree this consult is the right cheap pre-refactor check.

The cost of NOT consulting you: the iter-128 body was kernel-clean-but-degenerate; the iter-130 body was kernel-clean-but-opaque. A third body-shape attempt without analogist validation risks a third kernel-clean-but-defective close.

## Hints (optional)

- Mathlib namespaces relevant: `Mathlib.Logic.Classical` (`Classical.choose`, `Classical.indefiniteDescription`, `Classical.choice`); `Mathlib.RingTheory.Ideal.Cotangent` (`IsLocalRing.CotangentSpace`); `Mathlib.RingTheory.RegularLocalRing.Defs` (`IsRegularLocalRing.iff_finrank_cotangentSpace`); `Mathlib.RingTheory.Smooth.StandardSmoothCotangent` (`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`); `Mathlib.LinearAlgebra.Dimension.Constructions` (`Module.finrank_baseChange`); `Mathlib.RingTheory.TensorProduct.Free` (`Algebra.TensorProduct.instFree`).
- The opacity mechanism on the iter-130 body: `Classical.choice : Nonempty α → α` is opaque (no reduction rule beyond eta+definitional-unfolding-of-`α`); when applied to a `Nonempty (ModuleCat k)` witness whose underlying carrier is `⟨X⟩`, the result is `Classical.choice ⟨X⟩` which does NOT reduce to `X` via `simp` / `rfl`. By contrast `Classical.choose : (∃ x, p x) → α` followed by `Classical.choose_spec` exposes a *named* witness with a proof of its property, so a downstream lemma can `obtain ⟨V, hV⟩ := …` on `Classical.choose_spec` of the same existential and apply lemmas to the explicitly-named `V`.
- The iter-129 analogist's Decision 2 verdict on (B) noted "the body depends on a chosen chart" and "Mitigation: bundle the chart choice into a `Nonempty` existential ... and define the cotangent via `Classical.choice`. Downstream consumers (rigidity argument) only need the existence of a rank-`n` `k`-module, not canonicity." The iter-130 prover followed this advice literally; what the iter-129 analogist did NOT consider is that **the rank lemma** itself (deferred to iter-130+) is a downstream consumer of the body, and "existence of rank-`n`" is not enough — the rank lemma needs to **prove** the rank is `n`, which requires accessing the chart's structure. So the iter-129 verdict's "canonicity is not load-bearing" framing was correct for the rigidity consumer but missed the rank-lemma consumer.

## Severity expectation

high-stakes — this design decision is the third body-shape attempt on a load-bearing declaration that has now consumed 3+ iters. Be strict about idiom adherence; verify proposed Mathlib name shapes by `lean_leansearch` / `lean_loogle` rather than trusting `[expected]` tags. The plan agent will treat your **ALIGN_WITH_MATHLIB** verdict as a refactor obligation and your **PROCEED** verdict as the green light for the `Classical.choose`-chain plan.
