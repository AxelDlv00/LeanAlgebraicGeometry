# Strategy Critic Report

## Slug
iter128

## Iteration
128

## Routes audited

### Route: M1 — EXCISED (Differentials.lean cleanup, iter-126)

- **Goal-alignment**: PASS — excision removes only declarations with zero in-tree consumers and does not touch any of the nine protected declarations.
- **Mathematical soundness**: PASS — nothing was claimed mathematically; this is bookkeeping. The preserved M1.d (`kaehler_quotient_localization_iso`) is a meaningful Mathlib-PR candidate, not load-bearing here.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable (already executed).
- **Verdict**: SOUND.

### Route: M2.a — `rigidity_over_kbar` (over an arbitrary base field $k$, iter-127 over-k pivot)

- **Goal-alignment**: PARTIAL — the named declaration's body, once closed, feeds `genusZeroWitness`, which feeds `nonempty_jacobianWitness`. That chain reaches a protected declaration. However, the strategy quietly conflates "rigidity stated over $k$" with "rigidity proved over $k$ without ever touching $\bar k$." A morphism `f : C → A` with `df = 0` is forced to be constant *on geometric points*, and the standard reduced-source / separated-target promotion to scheme-morphism equality (step C.2.e) then yields equality over $k$ — but the *geometric-points* argument typically needs to be set up over $\bar k$ before descending, since "set-theoretic image" arguments (C.2.c) and "image is one-dimensional" arguments are most naturally phrased on the algebraic closure. The blueprint asserts that the over-k variant works for pieces (i)+(ii)+(iii), but does not address how C.2.c's image-dimension argument runs when the residue field at a closed point of `C` is a non-trivial finite extension of `k`. This is a soundness loose end, not (necessarily) a fatal one, but the strategy has not done the over-k mathematics carefully for sub-step C.2.c.
- **Mathematical soundness**: PARTIAL — see above. Also: the body sketch in `RigidityKbar.tex` C.2.b says "we will take $U := \mathbb P^1_{\bar k}$", but the actual Lean source `C` is *not* literally $\mathbb P^1_k$ — it is "an abstract smooth proper geometrically irreducible curve over $k$ of genus 0". Under the over-k commitment with no $C(k) \ne \emptyset$ hypothesis, $C$ need not be $\mathbb P^1_k$ at all (Brauer–Severi conics). The C.2.b reduction therefore cannot literally take "$U := \mathbb P^1_{\bar k}$"; it must work with the abstract curve directly. The blueprint prose has not been updated for this.
- **Sunk-cost reasoning detected**: yes — see § Sunk-cost flags below.
- **Phantom prerequisites**: `AlgebraicGeometry.GrpObj.lieAlgebra`, `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`, `AlgebraicGeometry.GrpObj.omega_free`, `AlgebraicGeometry.GrpObj.omega_rank_eq_dim`, `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`, and especially **any scheme-level absolute Frobenius `F_X` for a smooth scheme over `k`** — none of these exist in Mathlib `b80f227`. Most are explicitly admitted as planned new declarations; that is fine. **What is not OK is that there is no scheme-level Frobenius infrastructure in Mathlib *at all*** — `lean_leansearch` "absolute Frobenius scheme" returns only ring-side `frobenius` / `iterateFrobenius` from `Mathlib.Algebra.CharP.Frobenius`. Project-local search confirms zero scheme-side Frobenius declarations (only `FrobeniusNumber` from `NumberTheory/FrobeniusNumber.lean`, unrelated). Pulling the absolute Frobenius `F_X` from ring level to scheme level is a real, multi-iter task on its own (cf. Stacks Tag 0CC4); the strategy's 300–600 LOC / 2 iter for piece (iii) is significantly under-counted.
- **Effort honesty**: under-counted on piece (iii); see § Must-fix-this-iter.
- **Verdict**: CHALLENGE.

### Route: M2.b — `genusZeroWitness` (terminal-object construction, iter-127 scaffold)

- **Goal-alignment**: PASS — the construction returns `JacobianWitness C` with $J = \Spec k$, which is exactly what the genus-zero branch of `nonempty_jacobianWitness` needs. The vacuity argument for the $C(k) = \emptyset$ branch (Brauer–Severi conics) is correctly handled at the Lean type level by `∀` over an empty type.
- **Mathematical soundness**: PASS, provided M2.a's body closes. The proof sketch in `Jacobian.tex` § `sec:genusZeroWitness` is clean: the only non-trivial step is invoking `rigidity_over_kbar` in the existence branch of `isAlbaneseFor`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none beyond M2.a.
- **Effort honesty**: reasonable (100–200 LOC body closure, 1–2 iter, conditional on M2.a).
- **Verdict**: SOUND (conditional on M2.a closing).

### Route: M2.body-pile pieces (i)+(ii)+(iii), the shared cotangent-vanishing pile

- **Goal-alignment**: PASS — pieces (i), (ii), (iii) collectively close the keystone of C.2.d (`df = 0 ⇒ f` constant) which closes M2.a.
- **Mathematical soundness**: PARTIAL for (i); PASS for (ii); PARTIAL for (iii):
  - **(i)**: The sub-decomposition (i.a)→(i.b)→(i.c) is mathematically correct as a strategy. But the (i.a) signature in the blueprint asserts `finrank_k 𝔤 = dim G` without naming what `dim G` is at the Lean level. In Mathlib, "dim G" is not a packaged function on `Over (Spec k)` — the project's encoding routes dimension through `SmoothOfRelativeDimension n`, which means the (i.a) rank lemma should read `Module.finrank k (lieAlgebra G) = n` for some `[SmoothOfRelativeDimension n G.hom]` instance, **not** `= dim G`. This is a real signature-design ambiguity that has to be resolved before (i.a) can be filled.
  - **(i.b)** functorial shear iso: mathematically correct, OK.
  - **(i.c)** the "pullback of free $k$-module along $G \to \Spec k$ is a free $\mathcal O_G$-module" step is fine.
  - **(ii)**: PASS. The two halves (ring-side `Differential.ContainConstants`, scheme-side `ext_of_diff_zero`) are accurately scoped. `Differential.ContainConstants` is verified to exist in `Mathlib.RingTheory.Derivation.DifferentialRing`.
  - **(iii)**: char-$p$ handling via "absolute Frobenius $F_X$ intrinsic to $X$" is *mathematically* correct, but **no scheme-level Frobenius exists in current Mathlib**, and constructing one is a substantial undertaking (functorial $p$-th-power map on rings, sheafified to a `Scheme ⟶ Scheme` morphism, compatibility with smoothness, the Stacks 0CC4 lemma that $F_X$ on a smooth $k$-scheme in char $p$ factors as $G \xrightarrow{F_{X/k}} X^{(p)} \xrightarrow{W} X$ etc.). The 300–600 LOC estimate is low by at least a factor of two; a realistic figure is 800–1500 LOC, comparable to piece (i).
- **Sunk-cost reasoning detected**: yes — see § Sunk-cost flags.
- **Phantom prerequisites**: none beyond what is named.
- **Effort honesty**: piece (iii) under-counted; piece (i) honest given the sub-decomposition; piece (ii) reasonable.
- **Verdict**: CHALLENGE (piece (iii) honest-LOC accounting, (i.a) signature ambiguity).

### Route: M3 — `positiveGenusWitness`

- **Goal-alignment**: PASS — both Route A (Picard via FGA) and Route B (Sym^n + Stein) close the positive-genus branch of `nonempty_jacobianWitness`.
- **Mathematical soundness**: PASS — classical.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: substantial (FGA representability, Hilbert / Quot schemes for Route A; symmetric powers, finite-group quotients of schemes, Stein factorisation for Route B). All correctly admitted as missing.
- **Effort honesty**: reasonable for the framing as "100+ iter / 10000+ LOC per route". This is parked off the iter-by-iter path until M2 closes; no immediate action.
- **Verdict**: SOUND.

### iter-128 TRIPWIRE: prover target `AlgebraicGeometry.GrpObj.lieAlgebra` (piece (i.a))

- **Is it the simplest realistically-prover-fillable target in piece (i)?** **No.** Two strictly smaller targets exist within the same sub-decomposition (see Alternatives §). The plan-agent's framing — "(i.a) has the smallest signature surface" — is misleading because the (i.a) *as currently spec'd in the blueprint* bundles **(definition of `lieAlgebra G`) + (rank-equals-dim claim)** into one prover-iter task. The rank claim alone requires the bridge `f^* Ω_{Y/k}` at a section ↔ cotangent space `m/m²` of the local ring at the corresponding closed point. This bridge is not in Mathlib (only ring-side `IsLocalRing.CotangentSpace` is) and constructing it is well over a single iter's worth of work. iter-128 will almost certainly fail to land the full (i.a) signature.
- **Is the TRIPWIRE itself sound as a tactical move?** PARTIAL — it correctly identifies that 3 consecutive plan-phase-only iters is a churning signal that needs breaking. But forcing a prover lane on a target that is mis-scoped invites a failed prover dispatch that then justifies *another* plan-phase-only iter to re-scope, exactly the churning pattern it tried to break.
- **Verdict**: CHALLENGE — re-scope iter-128's prover target before dispatching.

## Alternative routes (suggested)

### Alternative: iter-128 prover target = **just the definition** `AlgebraicGeometry.GrpObj.lieAlgebra G := η_G^* Ω_{G/k}` (no rank lemma)

- **What it looks like**: A single Lean `def`. The signature is `noncomputable def AlgebraicGeometry.GrpObj.lieAlgebra (G : Over (Spec (.of k))) [GrpObj G] : ...` returning a `k`-module obtained by pulling back the project's existing `relativeDifferentialsPresheaf` along the identity section of `G`. No rank claim, no `finrank = dim G`. Body is constructive plumbing only.
- **Why it might be cheaper or sounder**: It actually fits in one iter. The rank-equals-relative-dimension claim is then `lieAlgebra_finrank` as a *separate* iter-129+ task, scoped on its own. This matches the blueprint's already-staged `lem:GrpObj_lieAlgebra` (definition) vs. `lem:GrpObj_lieAlgebra_finrank` (rank) split — the strategy text just collapsed them in the iter-128 directive.
- **What the current strategy may have rejected**: unclear; the strategy's "lieAlgebra together with lieAlgebra_finrank_eq_dim" coupling appears to be an inadvertent over-scoping rather than a deliberate choice.
- **Severity of the omission**: major.

### Alternative: iter-128 prover target = **the shear iso `σ : G ×_k G → G ×_k G`** as a categorical construction in `Over (Spec k)`

- **What it looks like**: A pure `CartesianMonoidalCategory` + `GrpObj` construction. Build `σ := lift (fst) (mul)` and its inverse `τ := lift (fst) (mul ∘ (inv ⊗ id))`, prove `σ ≫ τ = 𝟙` and `τ ≫ σ = 𝟙` using the GrpObj axioms (associativity + left-inverse). No cotangent presheaf needed at all. This is a clean stepping-stone for piece (i.b) without engaging any of piece (i.a)'s open questions.
- **Why it might be cheaper or sounder**: It exercises pure category theory only; the prover has access to mature `MonObj` / `GrpObj` API already in Mathlib `b80f227`. ~100–300 LOC. It also independently de-risks the *most-cited* over-k risk (the "functorial shear iso, NOT pointwise translation" risk register in `RigidityKbar.tex`) by landing the iso itself before the cotangent argument depends on it.
- **What the current strategy may have rejected**: appears not considered.
- **Severity of the omission**: major.

### Alternative: revert the iter-127 over-k commitment; use over-$\bar k$ + Galois descent

- **What it looks like**: M2.c (Galois descent of morphism equality, 4–8 iter / 300–500 LOC per the strategy's earlier accounting) is re-instated. Pieces (i)+(ii)+(iii) of the shared pile are then stated and proved over $\bar k$, which sidesteps the over-k risks the strategy itself acknowledges (functorial shear iso instead of pointwise translation; absolute $F_X$ instead of relative $F_{Y/k}$). The downside is the M2.c step itself.
- **Why it might be cheaper or sounder**: The strategy claims pieces (i)+(ii)+(iii) over-k save 500–900 LOC / 7–13 iter vs. dropping the over-$\bar k$+descent path. But it has not done a side-by-side honest LOC comparison of the over-k *implementation* cost vs. the over-$\bar k$+descent cost. Specifically, **scheme-level absolute Frobenius `F_X` does not exist in Mathlib at all**, while Mathlib does have substantial faithfully flat descent infrastructure. If piece (iii) over-k costs the corrected 800–1500 LOC (my estimate above) instead of 300–600 LOC, the over-k path may net *more* expensive than over-$\bar k$+descent.
- **What the current strategy may have rejected**: the iter-127 over-k analogist verdict OK_OVER_K is taken as binding without a comparable honest-cost accounting of the over-$\bar k$+descent alternative *after* the iter-127 over-k pieces are honestly sized.
- **Severity of the omission**: major.

### Alternative: char-$p$ piece (iii) as a *named scoped sorry*, parallel to piece (iv) Serre duality

- **What it looks like**: Land pieces (i) and (ii) for char-0 only. Mark piece (iii) char-$p$ handling as a *named gap* (`hCharZero : CharZero k`-hypothesised, with the char-$p$ case left as a clearly-labelled `sorry`-with-precise-statement), in the same spirit as the iter-127 deferral of piece (iv) Serre duality. The Lean keystone `rigidity_over_kbar` then gains a `[CharZero k]` instance hypothesis (or `[ExpChar k 0]`), which propagates upward as a hypothesis on `genusZeroWitness` and ultimately on `nonempty_jacobianWitness`.
- **Why it might be cheaper or sounder**: The end-state target is "zero inline `sorry` in the project, no named axioms." A scoped char-0 hypothesis is *not* a `sorry` and not a named axiom — it is a typeclass binder that propagates the partial scope honestly. **However**: the protected `nonempty_jacobianWitness` signature is frozen and does **not** carry `[CharZero k]`. So this alternative is **not viable as written** — adopting it would violate the protected signature. The only way to do char-0-only is to leave a `sorry` in the char-$p$ branch of an internal helper, which violates the end-state target. So the strategy is correct to reject this; I mention it only to confirm the rejection is principled, not sunk-cost.
- **What the current strategy may have rejected**: implicitly rejected by the no-axiom / no-sorry end-state.
- **Severity of the omission**: minor (already correctly rejected; the strategy could state the rejection rationale explicitly for completeness).

## Sunk-cost flags

- *"iter-126 user hint absorbed: 'do the work, no axioms; ~6500–9000 LOC may not be that much for an AI'"* — Used to justify NOT considering a Riemann–Roch / Brauer–Severi route that the strategy itself characterised as cheaper (the C.1 path in `Jacobian.tex`), and to justify a scheme-level absolute-Frobenius build-out the project has not previously attempted. **Why this is sunk-cost**: the user-hint quotation is being applied as a generic blanket warrant for *all* expensive in-tree paths, rather than as a specific endorsement of one route after honest comparison. Recommendation: re-cite the user hint with the specific decision it was attached to (M3 Route A vs. axiomatising `nonempty_jacobianWitness`), and rebuild the in-tree-vs-PR-target case for the M2.body-pile *de novo* on the merits of pieces (i)+(ii)+(iii) vs. alternative formulations.

- *"Revert option: 1 iter strategic backtrack + restoration of M2.c rows"* — The strategy preserves the over-$\bar k$ revert option but does not name a *trigger condition* for exercising it. **Why this is sunk-cost**: a "revert option" with no trigger is a way to say "we've decided over-k and we're not changing our minds" while feeling like a hedge. Recommendation: name a concrete trigger ("revert if piece (iii) over-k exceeds 800 LOC at iter 142", or "revert if the iter-128 prover lane on `lieAlgebra` fails three consecutive iterations").

## Prerequisite verification

- `CategoryTheory.GrpObj`: VERIFIED (exists in `Mathlib.CategoryTheory.Monoidal.Grp_`).
- `Differential.ContainConstants`: VERIFIED (exists in `Mathlib.RingTheory.Derivation.DifferentialRing`).
- `iterateFrobenius` / `frobenius` (ring-side): VERIFIED (exists in `Mathlib.Algebra.CharP.Frobenius`).
- `IsLocalRing.CotangentSpace`: VERIFIED (exists in `Mathlib.RingTheory.Ideal.Cotangent`; **but only ring-side**, not as a pullback of a sheaf along a section).
- `AlgebraicGeometry.IsSmoothOfRelativeDimension`: VERIFIED.
- `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`: MISSING (correctly admitted as NEEDS_MATHLIB_GAP_FILL).
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` / `lieAlgebra`: MISSING (correctly admitted as new in-tree declarations).
- **Scheme-level absolute Frobenius `F_X`**: MISSING. `lean_local_search` for "Frobenius" returns only `Mathlib/NumberTheory/FrobeniusNumber.lean` (unrelated). `lean_leansearch` for "absolute Frobenius scheme" returns only ring-side `frobenius` / `iterateFrobenius`. There is no `AlgebraicGeometry.Scheme.frobenius`, no `AlgebraicGeometry.absoluteFrobenius`, no equivalent. **This is a substantial undeclared Mathlib infrastructure gap that piece (iii) silently absorbs.**
- `AlgebraicGeometry.Group.Smooth.pointEquivClosedPoint`: not verified; the strategy mentions it only to motivate avoiding it under the over-k commitment, so its existence is not a prerequisite here.
- `relativeDifferentialsPresheaf` (project-internal): not verified by my tools, but the strategy and prior reference to `analogies/cotangent-presheaf-design.md` indicate it exists in-tree. Assumed VERIFIED.

## Must-fix-this-iter

- **Route M2.a — CHALLENGE**: Two issues. (1) The blueprint's C.2.b reduction prose still says "we will take $U := \mathbb P^1_{\bar k}$" even though the Lean source `C` is an abstract genus-0 curve over $k$ (no $\mathbb P^1_k$ structure required under the over-k commitment, *especially* in the $C(k) = \emptyset$ branch). Update C.2.b prose to operate with the abstract `C` directly, or pin down at what stage the $\mathbb P^1$ identification is invoked. (2) The image-dimension argument (C.2.c) over `k` (when the residue field at a closed point of `C` is a finite extension of `k`) is not addressed; add a paragraph to `RigidityKbar.tex` § "Proof decomposition" explicitly handling residue-field extensions, or state explicitly that pieces (i)+(ii)+(iii) collectively bypass C.2.c via the differential-vanishing route.

- **Route M2.body-pile piece (iii) — CHALLENGE**: Honest-LOC accounting. There is no scheme-level Frobenius in Mathlib `b80f227`. The "300–600 LOC / 2 iter" estimate is unrealistic when the project must first build `AlgebraicGeometry.Scheme.absoluteFrobenius` (or its equivalent) from the ring-side `frobenius`. Revise to **800–1500 LOC / 4–8 iter** and re-sequence M2 accordingly. The honest M2 closure estimate would then push from "iter-143 to iter-157+" to "iter-148 to iter-165+".

- **Route M2.body-pile piece (i.a) — CHALLENGE**: Signature ambiguity. `finrank_k 𝔤 = dim G` does not type-check directly because Mathlib has no `dim G` function on `Over (Spec k)`. Either (a) the rank lemma's signature reads `Module.finrank k (lieAlgebra G) = n` parameterised by an explicit `[SmoothOfRelativeDimension n G.hom]` instance, or (b) the strategy specifies what Lean-side `dim` it intends (Krull dimension of `G.left` via `topologicalKrullDim`? `Module.finrank k (G.left.presheaf.obj ...)`?). Pick one and record it in the blueprint and the iter-128 prover directive.

- **Alternative "scope iter-128 to just the `lieAlgebra` definition, deferring rank to iter-129" — major**: The iter-128 META-PATTERN TRIPWIRE prover target as currently spec'd bundles (definition) + (rank-equals-dim claim) into one iter. Re-scope iter-128 to land just `def AlgebraicGeometry.GrpObj.lieAlgebra G`; defer `lieAlgebra_finrank_eq_dim` to a separate iter-129 prover lane. This matches the blueprint's already-staged (i.a)-definition vs. (i.a)-rank split.

- **Alternative "shear iso `σ` as a pure-categorical iter-128 warm-up target" — major**: Consider replacing the iter-128 TRIPWIRE target entirely with `AlgebraicGeometry.GrpObj.shearIso : G ×_k G ≅ G ×_k G` and its inverse-pair lemma. This is pure `CartesianMonoidalCategory` + `GrpObj` API and has the smallest signature surface in *all* of pieces (i.a)+(i.b)+(i.c). It also directly de-risks the over-k risk that the blueprint flags most loudly.

- **Alternative "revert over-k commitment after an honest cost re-estimation" — major**: Before iter-128 commits, redo the cost comparison side-by-side: over-k (piece (i) 800–1500 + piece (ii) 250–500 + piece (iii) **revised 800–1500**) vs. over-$\bar k$+M2.c-descent (piece (i)' over-$\bar k$ possibly cheaper because pointwise translation is admissible + piece (iii)' may be skippable on $\bar k$ if descent absorbs char-$p$ + M2.c 300–500). The strategy currently *asserts* over-k saves 500–900 LOC / 7–13 iter, but that accounting predates the scheme-Frobenius-is-missing-from-Mathlib discovery. Either re-affirm the over-k commitment with the new numbers, or trip the revert option.

- **Sunk-cost flag on user-hint citation — major**: Re-cite the iter-126 user hint "do the work, no axioms; ~6500–9000 LOC may not be that much for an AI" with the specific decision it was attached to (M3 Route A vs. axiomatising existence). Stop using it as a generic blanket warrant for unaccounted-for in-tree scope.

- **Phantom prerequisite scheme-level absolute Frobenius**: strategy depends on a Mathlib piece I couldn't locate at all in the snapshot. Build-it-as-we-go is a legitimate plan if (and only if) the LOC budget honestly reflects "we are also constructing the underlying Mathlib API."

## Overall verdict

A fresh mathematician reading this strategy would *not* approve it as-is. The mathematics is fundamentally on the right track — the genus-stratified decomposition is clean, the genus-0 over-k commitment is defensible, the piece-(i.a)/(i.b)/(i.c) sub-decomposition is a sane lattice for staged Lean work — but three honest concerns block immediate green-light: (1) piece (iii)'s scheme-level absolute Frobenius is *materially* missing from Mathlib and the budget hides this, (2) the iter-128 TRIPWIRE prover target couples a definition with a rank-equals-dim claim whose missing-bridge dependencies make one-iter closure unrealistic, and (3) the over-k vs. over-$\bar k$+descent cost comparison was made before piece (iii)'s real cost surfaced and should be redone. The plan should land iter-128 with a tighter, properly-scoped prover target (the definition-only `lieAlgebra` or the shear iso `σ`) while STRATEGY.md absorbs the corrected piece-(iii) accounting and either re-affirms or reverts the over-k commitment.

---

*Return value:* `iter128: CHALLENGE — 5 routes audited + iter-128 TRIPWIRE, 4 CHALLENGE verdicts (M2.a, piece (iii), piece (i.a) signature, iter-128 target re-scope) and 4 major alternatives the planner must address.*
