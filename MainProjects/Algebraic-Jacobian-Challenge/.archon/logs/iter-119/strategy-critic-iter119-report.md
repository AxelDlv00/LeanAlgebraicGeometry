# Strategy Critic Report

## Slug
iter119

## Iteration
119

## Routes audited

### Route: Phase C — close `smooth_locally_free_omega` (forward implication only)

- **Goal-alignment**: PASS — closing the only inline sorry in `Differentials.lean` realises the "Differentials.lean ships unconditionally" claim and brings the project to its declared end-state (exactly one inline sorry: `nonempty_jacobianWitness`).
- **Mathematical soundness**: PASS — the chain `smoothOfRelativeDimension_iff` → `algebraize` (via `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`) → `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` → instance `Algebra.IsStandardSmooth.free_kaehlerDifferential` + theorem `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` is the canonical Mathlib path and is mathematically correct.
- **Sunk-cost reasoning detected**: no — Phase C is a concrete one-iter close, not a justification of an inherited approach.
- **Phantom prerequisites**: none. Every named lemma verified to exist in the current `.lake/packages/mathlib` snapshot — see "Prerequisite verification" below.
- **Effort honesty**: reasonable — "1–3 prover iters / ~100–300 LOC" is plausible for an `obtain`/`algebraize`/`rw`/`exact` chase, modulo the two minor slate gaps named in Must-fix-this-iter (Nontriviality and `f.c`-vs-`f.appLE` reconciliation).
- **Verdict**: SOUND — proceed, with two minor slate advisories the prover will need to handle (see Must-fix-this-iter).

### Route: iff → forward demotion of `smooth_locally_free_omega`

- **Goal-alignment**: PASS — demoting an unsound iff to a sound forward implication keeps the project's stated correctness invariant; the iff was never going to close honestly.
- **Mathematical soundness**: PASS — the strategy's counterexample is valid. The closed immersion `Spec k → Spec k[t]` induced by `k[t] → k, t ↦ 0` is surjective on rings, hence `Ω_{k/k[t]} = 0` (locally free of rank 0); it is locally of finite presentation (`k = k[t]/(t)` is finitely presented as a `k[t]`-algebra); but `k` is not flat over `k[t]` (tensoring `k[t] →·t k[t]` with `k` yields the zero map `k → k`, not injective), so the morphism is not smooth. The converse direction genuinely requires deformation-theoretic input (`Subsingleton (Algebra.H1Cotangent A B)`), which local freeness of Ω + finite presentation does not give you. This is a correctness fix, not a weakening.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: n/a.
- **Effort honesty**: n/a (already implemented in iter-118).
- **Verdict**: SOUND.

### Route: ship `nonempty_jacobianWitness` as the single inline `sorry`

- **Goal-alignment**: PARTIAL — the project goal is "formalise the nine protected declarations." Six of them (`Jacobian.lean` + `AbelJacobi.lean`) will `lean_verify` to `sorryAx` rooted at `Jacobian.lean:179`. Strictly speaking the nine declarations *type-check* but six are not *proved*; the strategy is explicit that this is the intended end-state, framed as "conditional on a single named foundational hypothesis." A fresh mathematician would accept this framing only if the named hypothesis is itself genuinely a theorem (it is) and the dependency is auditable (it is: `lean_verify` localises the gap precisely).
- **Mathematical soundness**: PASS — existence of an Albanese variety of a smooth proper geometrically irreducible curve is a true theorem; the three routes (Hilbert/Quot via FGA; symmetric powers + Stein; rigidity + genus-0 sub-case) are all classical. Route C is correctly described as complementary (handles only genus-0 with `C(k) ≠ ∅`).
- **Sunk-cost reasoning detected**: no — the decision to leave the witness as a sorry is justified by an external Mathlib gap, not by past project investment.
- **Phantom prerequisites**: none. The strategy is honest that the three Mathlib build-outs (Hilbert/Quot; symmetric powers + finite-group-scheme quotients + Stein; or the converse direction of `smooth_locally_free_omega`) are project-external.
- **Effort honesty**: reasonable — "project-external, out of autonomous-loop scope" is the correct estimate.
- **Verdict**: SOUND — the iter-118 challenge (convert to `axiom`) was rebutted on procedural grounds (`prompts/plan.md` L43 hard rule). From a fresh mathematician's view a `sorry`-rooted `sorryAx` and a named `axiom` are semantically equivalent for downstream auditability; the choice is a project-hygiene preference and I do not re-raise.

### Route: Genus / Rigidity / Cohomology infrastructure ships unconditionally

- **Goal-alignment**: PASS — `genus` and the Rigidity lemma are protected declarations; closing them unconditionally is required by the project goal.
- **Mathematical soundness**: PASS — the Čech / Mayer–Vietoris stack used to define `genus` as `Module.finrank k (Scheme.HModule k (toModuleKSheaf C) 1)` is a standard route. (Not re-derived here — the blueprint chapter summary suffices.)
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none flagged in this directive; nothing in the slate references infra I cannot locate.
- **Effort honesty**: n/a — described as already-shipped.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Picard-scheme-via-Artin-representability for `nonempty_jacobianWitness`

- **What it looks like**: define `Pic^0_{C/k}` as the Yoneda fppf-sheaf and invoke Artin's representability theorem to produce the scheme structure, then identify with the Jacobian.
- **Why it might be cheaper or sounder**: avoids the heavy Hilbert/Quot machinery; Artin's criterion is more local-deformation-theoretic.
- **What the current strategy may have rejected**: Artin's representability is *also* not in Mathlib `b80f227`, and arguably is at least as heavy as the FGA route to set up. So this isn't really cheaper — same gap, different door.
- **Severity of the omission**: minor — the strategy's "Mathlib gaps left for whoever picks up the project" section is exhaustive enough; this alternative would not change the autonomous-loop verdict.

### Alternative: stronger characterisation `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`

- **What it looks like**: `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:319` ships `IsStandardSmoothOfRelativeDimension n R S ↔ Module.rank S Ω[S⁄R] = n` *given* `[Nontrivial S]` and `[IsStandardSmooth R S]`. This iff is the right tool when you already have `IsStandardSmooth` in hand and want to read off the dimension.
- **Why it might be cheaper or sounder**: for Phase C's forward direction it's not needed — the strategy's slate already gets free + rank directly — but a prover wanting the rank statement *as an iff* in a future cleanup may prefer this form.
- **What the current strategy may have rejected**: unclear; probably just unaware that this iff is on hand. Not load-bearing.
- **Severity of the omission**: minor.

## Sunk-cost flags

None detected. The strategy is forward-looking; the `nonempty_jacobianWitness` retention is justified on external-Mathlib-gap grounds, not "we've already done X."

## Prerequisite verification

All six lemmas / definitions named in the Phase C closing slate were located in the current `.lake/packages/mathlib` snapshot:

- `AlgebraicGeometry.smoothOfRelativeDimension_iff`: VERIFIED — generated by `@[mk_iff]` on `class SmoothOfRelativeDimension` at `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134-138`; usage at line 160 confirms the generated name.
- `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`: VERIFIED — `Mathlib/RingTheory/RingHom/StandardSmooth.lean:70-72`; the `@[algebraize ...]` attribute on the `RingHom.IsStandardSmoothOfRelativeDimension` def (line 60) means the `algebraize` tactic will invoke it automatically.
- `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`: VERIFIED — `Mathlib/RingTheory/Smooth/StandardSmooth.lean:102-105`, inside `namespace Algebra`.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential` (instance): VERIFIED — `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:301-304`.
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED — `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:313-317`. **Note** the `[Nontrivial S]` hypothesis at line 313.
- `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`: VERIFIED — project-local at `AlgebraicJacobian/Differentials.lean:58-64`, body `rfl`.

Independent observation about how the algebra structures line up: `CommRingCat.KaehlerDifferential f` is defined with `letI := f.hom.toAlgebra` (`Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:96-98`). That is the same local algebra the `algebraize` tactic produces from `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`. So the two algebra structures align by definition on the Kähler side. What the slate does **not** explicitly call out is the reconciliation between the ring map underlying the bridge (`((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c |>.app V`) and the ring map produced by `smoothOfRelativeDimension_iff` (`(f.appLE U V e).hom`). These are the same map in spirit but the prover will need a `naturality`/`rfl` step to identify them at the chosen `U`,`V`. See Must-fix-this-iter (M1).

## Must-fix-this-iter

- **Route Phase C — advisory M1 (slate completeness, `f.c` vs `f.appLE`)**: SOUND with caveat. The slate does not include the unfold/naturality lemma needed to identify `((pullbackPushforwardAdjunction …).homEquiv _ _).symm f.c |>.app (.op U)` with `(f.appLE U V e).hom` at the chosen chart. The prover will need this bridge (likely a `simp [Scheme.Hom.appLE, ...]` after `rw [relativeDifferentialsPresheaf_obj_kaehler]`, or a small project-local helper). Recommend the planner either (a) name the expected `simp` set in the slate, or (b) add a one-line helper `appLE_eq_pullbackHomEquiv_app` to the project bridge layer. Not a blocker for Phase C, but the cost estimate "100–300 LOC" should explicitly cover this reconciliation.

- **Route Phase C — advisory M2 (`Nontrivial Γ(X, U)`)**: the slate omits the prerequisite `[Nontrivial Γ(X, U)]` required by `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`. It follows from `x ∈ U` (U nonempty ⇒ section ring nontrivial via the standard "nonempty affine ⇒ nontrivial coordinate ring" lemma; Mathlib has `AlgebraicGeometry.IsAffineOpen.nontrivial`-style lemmas — the prover should grep). Recommend the planner add `Nontrivial` synthesis to the slate as an explicit micro-step.

Both M1 and M2 are slate-completeness notes, not strategic challenges. No REJECT verdicts.

## Overall verdict

The strategy is **SOUND**. A fresh mathematician would approve this strategy as-is. The Phase C closing slate is verifiably aligned with `b80f227` Mathlib; the iff → forward demotion is a correctness fix, not a weakening; the single `sorry` end-state is honestly disclosed and audit-localisable; the three routes for `nonempty_jacobianWitness` (with Route C correctly framed as complementary) are an exhaustive account of the Mathlib gap; and no sunk-cost reasoning surfaces. The two advisory items (slate completeness on `f.c` vs `f.appLE` reconciliation, and the `Nontrivial Γ(X, U)` micro-step) are minor — the planner should fold them into the prover directive but neither is a strategic challenge. Proceed with Phase C this iter.
