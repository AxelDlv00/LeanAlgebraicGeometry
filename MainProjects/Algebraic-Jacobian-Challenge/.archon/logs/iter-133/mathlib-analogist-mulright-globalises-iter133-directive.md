# Mathlib Analogist Directive

## Slug
mulright-globalises-iter133

## Design question

What is the canonical Mathlib pattern for proving that the relative cotangent sheaf `Ω_{G/k}` of a smooth group scheme `G` over a base field `k` is **trivialised by translation** — i.e., is globally isomorphic to the pullback along the structure map `G → Spec k` of the cotangent space at the identity? Two sub-questions matter to the project:

(A) Does Mathlib have a precedent for this shear-iso globalisation construction (the shear `σ = ⟨pr₁, μ⟩` on `G ×_k G` as a categorical map in `Over (Spec k)` using `GrpObj` data only), and what's the Mathlib idiom for the natural iso `Ω_{G/k} ≅ pr₁^*(η_G^* Ω_{G/k})`?

(B) Does the iter-131 `Classical.choose`-chain body of `cotangentSpaceAtIdentity` (a chart-dependent body, non-canonical as a value but with the explicit `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])` outer head symbol) compose with the shear-iso globalisation step? Specifically: when the shear-iso construction needs to identify the cotangent at identity as the fibre object, does it require the chart-base-changed body of `cotangentSpaceAtIdentity` (which would only give a chart-dependent fibre) to be bridged to a canonical (chart-independent) presentation — e.g. the stalk-side `Ideal.IsLocalRing.CotangentSpace 𝔪_{η_G}`? If yes, the bridge cost (~300–600 LOC per `analogies/cotangent-body-shape.md`) is what trigger (a') in STRATEGY.md monitors.

The iter-131 strategy-critic's Q3 must-fix scheduled this consult BEFORE any iter-133+ piece (i.b) prover lane fires. Iter-132 closed piece (i.a); iter-133 is the appropriate iter to dispatch this consult.

## Project artifact(s) under question

- `AlgebraicJacobian/Cotangent/GrpObj.lean:149-188` — `cotangentSpaceAtIdentity` definition (iter-131 `Classical.choose`-chain body shape: pure-term `noncomputable def` with `let`-bindings on `Classical.choose` of `Scheme.smooth_locally_free_omega`'s existential; outer head symbol `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:198-219` — `cotangentSpaceAtIdentity_eq_extendScalars` companion structural-shape lemma (iter-131 strong acceptance lemma; closes by `refine ... rfl⟩`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:244-282` — `cotangentSpaceAtIdentity_finrank_eq` rank lemma (iter-132 close; uses `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`).
- `blueprint/src/chapters/RigidityKbar.tex:243-268` — § `lem:GrpObj_mulRight_globalises` blueprint statement + proof sketch for the target Lean name `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`. The proof sketch builds `σ` and its candidate inverse `τ = ⟨pr₁, μ ∘ (ι × id_G)⟩` using `GrpObj` axioms (associativity + left-inverse); restricts along the section `⟨id_G, η_G⟩ : G → G ×_k G`. The iter-127 over-k risk register at line 258 emphasises functorial-shear-only (no pointwise translation via closed/`k̄`-rational points).
- `analogies/cotangent-body-shape.md` — iter-131 analogist's prior work on the body shape: includes a § "Bridge lemma list (closure chain under `Classical.choose`-chain (B))" with the rank-lemma chain (which iter-132 consumed). The shear-iso composition with (B) was flagged as deferred-bridge-concern in iter-130 strategy-critic Q2.

## Why now

The iter-131 strategy-critic Q3 must-fix said: "Iter-133+ prover lane on piece (i.b) MUST be preceded by a mathlib-analogist consult on whether the shear iso composes with the iter-131 `Classical.choose`-chain body". Iter-132 closed piece (i.a) — now is the time. Without your verdict the iter-134+ prover lane would risk the same iter-128/iter-130 pattern (prover lane lands wrong/opaque body, requiring corrective iters).

## Hints

- `Mathlib.AlgebraicGeometry.Group.Smooth` (`b80f227`) — the project consumes `mulRight` from here (per blueprint § (i.b) proof line 267). Does this file already have a shear-iso construction, or only the `mulRight` morphism?
- `Mathlib.CategoryTheory.Monoidal.Grp_` — the `GrpObj` API. Does Mathlib have an idiom for shear isos in monoidal categories?
- `Mathlib.AlgebraicGeometry.Pullback` / `Mathlib.AlgebraicGeometry.Limits` — pullback identifications for cotangent presheaves under base change.
- `Mathlib.Algebra.Lie.OfAssociative` / `Mathlib.Algebra.Lie.Submodule` — Lie group / Lie algebra precedents (analogous category-theoretic shear constructions).
- The iter-131 `Classical.choose`-chain body's outer `extendScalars` head symbol is *exposed* via `cotangentSpaceAtIdentity_eq_extendScalars`; the chart `V` is chosen but the *form* of the body is canonical (the choice is hidden behind `Classical.choose`).
- The bridge to the canonical (chart-independent) `Ideal.IsLocalRing.CotangentSpace 𝔪_{η_G}` is what iter-130 strategy-critic Q2 worried about; iter-131 mathlib-analogist scoped it at 300–600 LOC.

## Severity expectation

**high-stakes**: piece (i.b) is on the critical path for M2.a body closure (iter-151+); the LOC envelope of 200–500 LOC for piece (i.b) was set under the assumption that the shear iso composes cleanly with (B). If it doesn't, piece (i.b) blows to 500–1100 LOC or forces a route pivot. Trigger (a') in STRATEGY.md monitors this in production. Please be strict about idiom adherence.

## Format expected

Per `.archon/subagents/mathlib-analogist.md`: verdict (PROCEED / ALIGN_WITH_MATHLIB / DIVERGE_INTENTIONALLY) + persistent file at `analogies/mulright-globalises-cotangent.md` + report at `task_results/mathlib-analogist-mulright-globalises-iter133.md`. Be explicit about (a) whether Mathlib has a shear-iso precedent in `GrpObj` or `Mathlib.AlgebraicGeometry.Group.*`, (b) whether the chart-base-changed body of `cotangentSpaceAtIdentity` requires an inline (B)→(A) stalk-cotangent bridge for the shear iso to land cleanly, (c) LOC estimate for piece (i.b) under each closure path (clean composition with (B) vs. inline bridge vs. route pivot), (d) any newly-flagged trigger (a') condition refinements.
