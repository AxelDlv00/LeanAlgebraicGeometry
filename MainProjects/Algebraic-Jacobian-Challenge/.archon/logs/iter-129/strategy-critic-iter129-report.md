# Strategy Critic Report

## Slug
iter129

## Iteration
129

## Routes audited

### Route: M1 (presheaf-bridge, EXCISED iter-126)

- **Goal-alignment**: PASS — excise removed a sorry with zero in-tree consumers; preserved `kaehler_quotient_localization_iso` as standalone Mathlib-PR candidate.
- **Mathematical soundness**: PASS — the standalone `kaehler_quotient_localization_iso` (alg-tower `A → L → B` with `A → L` a localization ⇒ `Ω[B⁄A] ≃ Ω[B⁄L]` as `B`-module) is the natural generalisation of `tensorKaehlerEquivOfFormallyEtale` to the "only base unramified" case.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: M2 (genus-0 witness via over-k cotangent-vanishing pile)

- **Goal-alignment**: PARTIAL — see CHALLENGE on `lieAlgebra` dimension parameter below: the iter-128 Lean definition hardcodes `[SmoothOfRelativeDimension 1 G.hom]`, which makes the resulting object unusable for the M2.a rigidity target `A` (codomain of `f : C → A`), whose relative dimension can be arbitrary.
- **Mathematical soundness**: PARTIAL — see CHALLENGE on the hidden presheaf-vs-sheaf bridge re-entering via the deferred rank lemma.
- **Sunk-cost reasoning detected**: **yes** — "the over-k commitment remains net-positive but the case is narrower than iter-127's framing" frames the over-k commitment as a fait accompli rather than re-deciding on current merits. The lower bound of revised savings is 0 iter / 0 LOC; that is a defensible re-decision boundary, not a "stay the course" boundary.
- **Phantom prerequisites**: `IsRegularLocalRing.cotangentSpace` (named in spot-check concern 2 as the blueprint route for the rank lemma) does NOT exist in Mathlib `b80f227`. `lean_local_search "cotangentSpace"` returns only `Algebra.Generators.cotangentSpaceBasis`, `Algebra.Extension.CotangentSpace`, and `Ideal.IsLocalRing.CotangentSpace`. The strategy's "blueprint-RHS-pinning" line points at a Mathlib name that doesn't exist as named.
- **Effort honesty**: under-counted — pieces (i.b)+(i.c) carry a bridge between the iter-128-chosen presheaf-globalsections-extendScalars definition and *either* (a) the geometric pullback `η^* Ω` or (b) the local-ring cotangent space `m/m²`; that bridge is not separately costed.
- **Verdict**: **CHALLENGE**.

### Route: M3 (positive-genus witness, user-hint absorbed; off-loop until M2 closes)

- **Goal-alignment**: PASS — Route A / Route B both produce the target witness; user-escalation TO_USER absorbed iter-126 in favor of "do the work, no axioms".
- **Mathematical soundness**: PASS — both routes are standard FGA / Brill–Noether decompositions; iter-123 route-pick audit established honest LOC totals against snapshot `b80f227`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: the M3 top-3 gating pieces (Hilbert/Quot representability, identity-component subgroup, Sym^n of schemes, Stein factorisation, Brill–Noether–Riemann–Roch) are all confirmed Mathlib gaps in the audit; not phantom — explicitly named as gaps to build.
- **Effort honesty**: honest (route-pick audit returned ~6500 LOC Route A / ~9000 LOC Route B, both above the 5000-LOC hard-fallback threshold).
- **Verdict**: SOUND — but stays off critical path until M2 closes per strategy's own sequencing.

### Route: Soundness rules + user-hint citation discipline

- **Goal-alignment**: PASS — the explicit ban on new axioms + the iter-128 citation-discipline addendum (user-hint applies to M3 disposition specifically, not as blanket warrant for *any* expensive in-tree path) is a healthy guardrail.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: n/a.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Direct ℙ¹ rigidity for the `C(k) ≠ ∅` branch of M2.b

- **What it looks like**: Split `genusZeroWitness` into two arms by Boolean classifier `Nonempty (𝟙_ _ ⟶ C)`. On the empty arm, `isAlbaneseFor` is vacuous — done. On the nonempty arm, use a *direct* rigidity for `f : ℙ¹_k → A` that bypasses the general "smooth proper geometrically irreducible curve of genus 0 → group scheme" formulation. The ℙ¹-specific rigidity uses the explicit affine chart cover of ℙ¹: a morphism `Spec k[t] → A` factors through `Spec k` because the local cotangent at the closed point of A is trivialised by the smoothness of A, and the global `Spec k[t] → A` can be analyzed by looking at where `t` goes (a section of `O_A` near the image, which must be constant if `A` is proper). This avoids ever needing `lieAlgebra` of a general group scheme.
- **Why it might be cheaper or sounder**: ℙ¹ has an explicit Mathlib API (well, `AlgebraicGeometry.Proj` of `MvPolynomial.gradedAlgebra`); the affine chart cover gives a constructive entry point. The strategy's pile (i)+(ii)+(iii) totals 1850–3600 LOC for general curves; the ℙ¹-specific path would be in the 500–1000 LOC range because pieces (ii) and (iii) collapse to their ring-side `k[t]` / `k[1/t]` instances.
- **What the current strategy may have rejected**: the strategy ties M2 closure to the general over-k rigidity (`rigidity_over_k`); it pre-commits to building general pile pieces (i)+(ii)+(iii) even though only the C(k) ≠ ∅ branch needs ANY rigidity at all (the C(k) = ∅ branch is vacuous). The strategy's framing — "the genus-0 universal property of J = Spec k routes through `rigidity_over_k`" — is over-general for what the universal property actually requires.
- **Severity of the omission**: **major** — could halve the M2 timeline if the planner is willing to split `genusZeroWitness` into two branches and pay the C(k) ≠ ∅ identification `C ≅ ℙ¹_k` cost (still substantial, but much smaller than the pile). The strategy currently treats `C ≅ ℙ¹_k` as gated on full Serre duality (3000–8000 LOC), but the **weak form** "C smooth proper geom-irr of genus 0 with a rational point ⇒ C ≅ ℙ¹_k" is provable from *elementary* projective embedding + low-order pole existence, not full Serre duality. The strategy under-estimates the elementary path here.

### Alternative: Standalone scheme-level cotangent SHEAF before piece (i)

- **What it looks like**: Build `AlgebraicGeometry.Scheme.Omega` (the sheaf, not the presheaf) as a standalone Mathlib-quality contribution, depending on Mathlib's `PresheafOfModules.sheafify`, then redefine `lieAlgebra` in terms of the sheaf's stalk at the identity. The sheaf-level construction sidesteps the "global sections of the presheaf ≠ global sections of the sheaf for proper non-affine schemes" issue.
- **Why it might be cheaper or sounder**: the rank lemma `lieAlgebra_finrank_eq_dim G = n` becomes a stalk-level computation that follows directly from local smoothness of G at the identity. With the presheaf-only approach, the rank lemma must additionally bridge "global sections of presheaf at top open, extendScalars along identity ring-map" to "stalk at residue field of identity section's closed point" — a non-trivial bridge for proper G.
- **What the current strategy may have rejected**: iter-127 strategy explicitly defers this with "Revisit at iter-129 if piece (i) build reveals the bridge cost is substantially worse than estimated." **Iter-129 is now.** Iter-128 closure of (i.a) was the *definition* only; the bridge cost is in (i.b)+(i.c) which haven't run. The iter-129 plan should explicitly evaluate the trigger.
- **Severity of the omission**: **major** — the trigger was set for iter-129; not firing it without explicit re-evaluation is a process gap. Strategy should either re-evaluate the trigger or document why iter-128 evidence doesn't warrant re-evaluation.

### Alternative: Let M3 subsume M2 at g=0 as a sanity-check

- **What it looks like**: M3's Albanese construction `Alb(C) := Sym^g(C) / ~` returns `Spec k` at g=0 (Sym^0 of any scheme = Spec of the base; quotient by trivial action is trivial). If M3 is being built anyway, M2 might fall out as `Alb(C)` evaluated at g=0, avoiding the cotangent-vanishing pile entirely.
- **Why it might be cheaper or sounder**: avoids paying for M2's pile if M3's pile already exists. Single uniform construction.
- **What the current strategy may have rejected**: the strategy explicitly separates M2 and M3 because M3 is multi-month and gated on Hilbert/Quot/Sym^n infrastructure. The argument for separation: M2 can ship the genus-stratified `nonempty_jacobianWitness` body restructure SOONER if M2 closes independently.
- **Severity of the omission**: **minor** — strategy makes a defensible separation choice, but doesn't acknowledge the overlap. If pieces (i)+(ii)+(iii) blow up, falling back to "wait for M3, then both close uniformly" is a hedge worth naming.

## Sunk-cost flags

- **"the over-k commitment remains net-positive but the case is narrower than iter-127's framing"** (M2.body-pile row) — Why this is sunk-cost: it frames the over-k decision as already-made and now defended, rather than re-deciding on current merits. The savings collapsed from 7–13 iter / 500–900 LOC to 2–6 iter / 0–500 LOC; the lower bound is zero. Recommendation: the iter-129 plan should re-examine the over-k vs over-`k̄` decision on the *revised* numbers (without invoking the iter-127 commitment as load-bearing). If the revised lower bound is 0/0, the commitment is no longer defended by quantitative savings — it must be defended on other grounds (cleaner blueprint? fewer concept-overhead lines?) or reverted to the over-`k̄` baseline that comes with the security of a verified analogist verdict from iter-126.

- **"the iter-128 hard trigger no longer fires (the decision has been made iter-126)"** (M1 EXCISED row) — Why this is NOT sunk-cost (clarifying a borderline case): the iter-128 hard trigger was conditional on "no new evidence collection between now and then"; the iter-126 excise WAS new evidence (the refactor lane returned, the sorry departed). So this prose is correct, not sunk-cost. No recommendation.

## Prerequisite verification

- `Differential.ContainConstants` (Mathlib): **VERIFIED** — exists at `Mathlib/RingTheory/Derivation/DifferentialRing.lean` as a class.
- `Algebra.FormallyUnramified.of_isLocalization` (Mathlib, named in M1 standalone PR docstring): **NOT DIRECTLY VERIFIED**. `lean_local_search "Algebra.FormallyUnramified"` returns only the instance `Algebra.FormallyUnramified.isOpenImmersion_SpecMap_lmul`; the `of_isLocalization` constructor may exist but wasn't surfaced. Planner should verify before depending on the exact name in the standalone PR.
- `AlgebraicGeometry.Scheme.absoluteFrobenius` (named in M2.body-pile piece (iii) row): **MISSING** — `lean_local_search "absoluteFrobenius"` returns empty; `lean_local_search "Scheme.frobenius"` returns empty. The strategy's revised iter-128 LOC accounting (800–1500 LOC) explicitly identifies this as a gap to build; this is correctly labeled as PHANTOM.
- `Mathlib.Algebra.CharP.Frobenius` (named as ring-side prerequisite for piece (iii)): **VERIFIED** — `lean_local_search "frobenius"` shows `frobenius`, `frobenius_add`, `frobenius_mul`, `frobenius_def`, `LinearMap.frobenius_def`, all under `Mathlib/Algebra/CharP/Frobenius.lean`.
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` (named as M2.body-pile piece (i) PHANTOM): **MISSING** (correctly labeled PHANTOM in strategy).
- `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (named as M2.body-pile piece (ii) PHANTOM): **MISSING** (correctly labeled PHANTOM in strategy).
- `IsRegularLocalRing.cotangentSpace` (named as blueprint RHS route for the rank lemma, per concern 2): **MISSING — and not labeled PHANTOM**. `lean_local_search "cotangentSpace"` returns `Algebra.Generators.cotangentSpaceBasis`, `Algebra.Extension.CotangentSpace`, `Ideal.IsLocalRing.CotangentSpace`. The intended object is likely `Ideal.IsLocalRing.CotangentSpace` (m/m² for a local ring), but the strategy's name is wrong; this is a strategy-prose phantom that the iter-129 planner should fix before pinning the rank lemma blueprint.
- `SmoothOfRelativeDimension` (Mathlib, used in `lieAlgebra` signature): **VERIFIED** — `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean`.

## Must-fix-this-iter

- **Route M2: CHALLENGE — `lieAlgebra` dimension parameter is hardcoded to `1`**. The iter-128-landed declaration `AlgebraicGeometry.GrpObj.lieAlgebra` at `AlgebraicJacobian/Cotangent/GrpObj.lean:87–101` carries `[SmoothOfRelativeDimension 1 G.hom]`. The M2.a rigidity target `A` (codomain of `f : C → A`) is a *general* smooth proper group scheme of arbitrary relative dimension `n`. The definition as written cannot be applied to `A` unless `A` happens to be 1-dimensional. The planner must either (a) generalise the definition to `[SmoothOfRelativeDimension n G.hom]` with `n : ℕ` as a universe/free parameter, or (b) explicitly document this iter that piece (i.a) is a *scaffolding* artifact intended for the curve-side argument only, with the general version a follow-up. This is a goal-alignment issue — the chosen Lean type is too narrow for the rigidity argument's actual needs.

- **Route M2: CHALLENGE — hidden presheaf-vs-sheaf bridge re-enters via the deferred rank lemma**. The iter-128 `lieAlgebra` definition uses `(ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))` where `M = relativeDifferentialsPresheaf G.hom`. For a proper non-affine `G`, the global sections of the presheaf at top differ from the sheaf-level global sections (sheafification matters). The rank lemma `finrank lieAlgebra = n` must implicitly assert that the chosen presheaf-globalsections-extendScalars construction is isomorphic to the geometric pullback `η^* Ω` along the identity section — and this isomorphism requires either (i) the shear-iso translation-invariance (which couples to piece (i.b), iter-130+, properly costed); or (ii) a separate "presheaf-vs-sheaf bridge at top" theorem the strategy has not costed. The iter-126 M1 excise was supposed to remove the presheaf-vs-sheaf bridge cost from this project; here it returns through the back door. Strategy must either (a) extend piece (i.b) scope to include the presheaf-vs-sheaf reconciliation and add the cost to the 1850–3600 LOC pile estimate, or (b) document an explicit argument that for `GrpObj` the presheaf-top-sections coincide with sheaf-top-sections without sheafification.

- **Route M2: CHALLENGE — revert trigger (a) is mis-targeted**. The trigger reads "iter-128 prover lane on `lieAlgebra` returns INCOMPLETE on a *functorial* shear-iso-style argument and only closes if pointwise translation is allowed". But the shear iso enters at piece (i.b) (iter-130+), not at piece (i.a) (iter-128 definition). Piece (i.a) is purely a `ModuleCat k` constructor; it doesn't *need* the shear iso at all. The trigger should be rewritten to target the iter-130+ prover lane on piece (i.b), with concrete failure criterion ("piece (i.b) globalisation prover returns INCOMPLETE on the functorial shear-iso route and closes only with `[IsAlgClosed]` on the base field"). As written, the trigger is unfireable: iter-128 closed without using the shear iso at all.

- **Alternative "Direct ℙ¹ rigidity for the C(k) ≠ ∅ branch": major — strategy ignored a potentially cheaper sub-route for genus-0 universal property**. Strategy must either (a) acknowledge the ℙ¹-specific path as a hedge to be evaluated if the over-k pile blows past 2000 LOC, or (b) explicitly document why the general over-k route is preferred even on the C(k) ≠ ∅ branch.

- **Alternative "Standalone scheme-level cotangent sheaf": major — iter-129 was the strategy-named re-evaluation trigger for this hedge, and the trigger has not been actively evaluated**. Strategy must add (this iter) an explicit assessment: does the iter-128 closure of piece (i.a) via the presheaf-extendScalars route signal that the bridge cost is (i) within the bundled estimate, (ii) materially worse, or (iii) not yet revealed because (i.a) was definition-only? If (iii), defer the trigger explicitly to a named future iter (e.g. "re-evaluate at iter-133 when piece (i.b) shear-iso lane completes or fails").

- **Phantom prerequisite `IsRegularLocalRing.cotangentSpace`**: strategy's spot-check-concern-2 narrative references a Mathlib name that doesn't exist. The intended object is probably `Ideal.IsLocalRing.CotangentSpace`; fix in any iter-129 plan-sidecar or STRATEGY.md prose that cites the rank lemma route.

- **Sunk-cost flag on the over-k commitment**: strategy must re-defend the over-k commitment on the revised numbers (lower-bound savings = 0/0) without appealing to the iter-127 commitment as load-bearing. Acceptable defenses: cleaner blueprint, fewer concept-overhead lines, or empirical evidence from iter-128 that the over-k path's risks (functorial shear iso, absolute Frobenius) are tractable. If no positive defense materializes, revert to over-`k̄` baseline + reintroduce M2.c.

## Overall verdict

A fresh mathematician would approve **M1's excise** (sound, well-reasoned) and **M3's user-hint absorption + off-loop posture** (sound, deferring to long-build work). However **M2 carries multiple material concerns**: the iter-128-landed `lieAlgebra` Lean definition is dimensionally too narrow (hardcoded `n = 1`) for the rigidity argument's actual codomain `A`; the chosen construction re-imports a presheaf-vs-sheaf bridge that iter-126's M1 excise was supposed to remove; the over-k commitment's net savings collapsed to a lower bound of zero without re-defense; the standalone-cotangent-sheaf alternative's iter-129 re-evaluation trigger fires this iter but is not actively engaged; and the revert trigger (a) is mis-targeted to iter-128 piece (i.a) when it should target the iter-130+ piece (i.b) shear-iso lane. Five must-fix issues land on the planner this iter. The strategy is not REJECT-grade (the math is plausible and the routes are defensible if the issues are addressed), but it's solidly CHALLENGE — the planner must either update STRATEGY.md or record an explicit rebuttal in `iter/iter-129/plan.md` for each of the five.
