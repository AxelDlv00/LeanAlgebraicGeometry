# Session 146 (iter-146 review)

## Metadata

- Session number: 146 (= iter-146).
- Stage: prover.
- Iteration meta (`logs/iter-146/meta.json`): `planValidate.status: ok`,
  `objectives: 1`, `prover.status: done`, `prover.durationSecs: 1631`
  (~27 min).
- Files edited by prover (per `attempts_raw.jsonl` summary line):
  exactly one — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.
- Attempts log: 120 total events; 5 edits, 0 goal checks, 6 diagnostic
  checks, 0 builds (the prover invoked `lake env lean` directly via
  Bash 3 times for whole-file verification — see "Build calls" below),
  24 lemma searches, 1 total error (an early `lean_diagnostic_messages`
  invocation with a relative path that the LSP rejected; immediately
  retried with an absolute path).
- Sorry count (declarations using `sorry` / inline `sorry`) per file
  at iter-146 close:
  - `Cotangent/GrpObj.lean` — 0 / 0 (unchanged).
  - `Cotangent/ChartAlgebra.lean` — **3 / 3** (was 5 / 5 at iter-145
    close; iter-146 NET delta **−2 inline sorries**).
  - `Jacobian.lean` — 2 / 2 (unchanged).
  - `RigidityKbar.lean` — 1 / 1 (unchanged).
  - **Total: 6 declarations / 6 inline** (was 8 / 8 at iter-145
    close; iter-146 NET delta **−2**, the first strict-count
    reduction since the iter-145 chart-algebra decomposition cost
    of +2).

## Targets and per-target outcomes

The iter-146 planner scoped the prover lane to **3 of 5** chart-algebra
sub-pieces in `Cotangent/ChartAlgebra.lean` (the 2 remaining
sub-pieces — β-core and KDM ring-side — were declared off-limits this
iter pending iter-147 blueprint-reviewer green-light).

### Target 1 — `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product` (was L50; now L84)

- **Status**: SOLVED (sorry-free; `\leanok` on statement + body).
- **Signature refined** from `: True := sorry` to the real
  `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)` shape per
  the blueprint sketch
  (`lem:chart_algebra_isPushout_of_affine_product` at
  `RigidityKbar.tex:1835`).
- **Body**: a single `inferInstance`.
- **Key insight**: Mathlib's `TensorProduct.isPushout` instance
  (`Mathlib/RingTheory/IsTensorProduct.lean:630`) discharges the
  algebra-level pushout square directly. The three-step Mathlib
  recipe cited by the iter-146 planner (`pullbackSpecIso` →
  `isPullback_SpecMap_of_isPushout` → `CommRingCat.isPushout_iff_isPushout`)
  is the SCHEME-level identification; the algebra-level CORE is a
  one-shot Mathlib instance.
- **Wrinkle**: `Algebra.TensorProduct.rightAlgebra` is a `local`
  instance inside `Mathlib.RingTheory.IsTensorProduct`. The prover
  re-enabled it at file scope via `attribute [local instance]
  Algebra.TensorProduct.rightAlgebra` at L74 of `ChartAlgebra.lean`.
  Without this attribute the canonical `Algebra.IsPushout` instance
  cannot resolve in this file.
- **Diagnostic trail** (from `attempts_raw.jsonl`):
  - Attempt 1 (`lean_run_code` at 05:18:44Z): a 6-line snippet
    declaring the `Algebra.IsPushout` goal failed with `failed to
    synthesize instance of type class Algebra B₂ (TensorProduct k B₁ B₂)`
    — the right-algebra instance was not in scope.
  - Attempts 2–3 (05:18:55Z, 05:19:09Z): same error, recurring.
  - 05:19:27Z `grep` discovered the local-instance declaration in
    `Mathlib.RingTheory.IsTensorProduct` at L630.
  - 05:19:51Z final `lean_run_code` with `attribute [local instance]
    Algebra.TensorProduct.rightAlgebra` succeeded with no diagnostics.

### Target 2 — `AlgebraicGeometry.constants_integral_over_base_field` (was L77; now L144)

- **Status**: PARTIAL (signature refined to the real shape;
  substeps 1–2 of the body closed; substep 3 deferred to a
  structured `sorry` at L177).
- **Signature refined** from `: True := sorry` to
  `RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤`
  for `{k : Type u} [Field k] {X : Scheme.{u}}` with hypotheses
  `[X.Over (Spec (.of k))]`, `[IsProper (X ↘ Spec (.of k))]`,
  `[Smooth (X ↘ Spec (.of k))]`, **`[IsReduced X]`**, and
  `[GeometricallyIrreducible (X ↘ Spec (.of k))]`.
- **Body progress**:
  - Substep (1): `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
    + `isIntegral_of_irreducibleSpace_of_isReduced` → `IsIntegral X`.
  - Substep (2.a): `isField_of_universallyClosed` → `IsField Γ(X, ⊤)`.
  - Substep (2.b): `finite_appTop_of_universallyClosed` → `appTop.hom`
    is finite.
  - Substep (3) DEFERRED: the geometric-irreducibility base-change
    step that pins `dim_k Γ(X, ⊤) = 1` via the chain
    `Γ(X, ⊤) ⊗_k k̄ ≃ Γ(X_{k̄}, ⊤) = k̄` + `Module.finrank_baseChange`.
    Inline block-comment at L167–L176 of `ChartAlgebra.lean`
    documents the iter-147+ closure path.
- **Note on `[IsReduced X]` discipline**: Mathlib snapshot
  `b80f227` lacks a general `Smooth ⇒ IsReduced` over a field
  (closest is `Scheme.Hom.dense_smoothLocus_of_perfectField`,
  perfect-base only). The project explicitly carries the typeclass.
  Same discipline already documented in `Rigidity.lean`'s
  "Hypothesis history" block.
- **Diagnostic trail**:
  - Multiple `lean_leansearch` / `lean_local_search` queries on
    "geom-irr base-change", "constants-equal-base-field", "smooth
    implies reduced over field", "global-sections-finite-dimensional".
    Hits: `finite_appTop_of_universallyClosed`,
    `isField_of_universallyClosed`,
    `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`,
    `isIntegral_of_irreducibleSpace_of_isReduced`,
    `Module.finrank_baseChange`,
    `IntermediateField.bot_eq_top_iff_finrank_eq_one`.
  - Negative searches: no direct Mathlib lemma for "finite
    `k`-algebra `A` with `A ⊗_k k̄ ≃ k̄` forces `A = k`" — must be
    assembled from the dimension-count chain (iter-147+).
  - 05:30:33Z final edit landed the substep-1+2 body with the
    structured `sorry` at substep 3.
  - 05:31:01Z verification via `lake env lean
    AlgebraicJacobian/Cotangent/ChartAlgebra.lean`: 3 sorry
    warnings, no errors.

### Target 3 — `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (was L89; now L208)

- **Status**: SOLVED (sorry-free) **with a signature reduction**.
- **Signature refined** from `: True := sorry` to
  `{k : Type u} [Field k] {C A : Over (Spec (.of k))}
   [IsSeparated A.hom] [IsReduced C.left] [GeometricallyIrreducible C.hom]
   (f g : C ⟶ A) (U : C.left.Opens) (hU : (U : Set C.left).Nonempty)
   (hUf : U.ι ≫ f.left = U.ι ≫ g.left) : f = g`.
- **Body**: `:= AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf`
  — a thin renaming of the iter-125 packaging in
  `AlgebraicJacobian/Rigidity.lean:91`.
- **Signature reduction call-out**: the planner-spec'd `df = dg`
  hypothesis was DROPPED from the iter-146 signature on the grounds
  that, if `eqOnOpen` is given outright, Step 3 of the blueprint
  recipe alone suffices (the chart-algebra Steps 1–2 derivation
  `df = dg ⇒ … ⇒ eqOnOpen` becomes redundant). The Lean docstring
  at L196–L203 documents this reduction. The blueprint statement
  (which DOES carry `df = dg`) now disagrees with the Lean
  signature; both reviewers flagged this as a load-bearing
  mismatch needing a `% NOTE:` annotation (applied this review).
- **Iter-147+ plan**: refine the signature to also take a
  chart-algebra `df = dg` hypothesis and derive `eqOnOpen` from it
  via Steps 1–2 of the recipe (depends on the β-core sub-piece
  `df_zero_factors_through_constant_on_chart` landing first).
- **Diagnostic trail**: minimal — the prover identified the
  iter-125 packaging via a single `grep` on the project's
  AlgebraicJacobian sources, imported `AlgebraicJacobian.Rigidity`
  in `ChartAlgebra.lean`, and landed the delegation immediately.

## Build calls

The prover invoked `lake env lean
AlgebraicJacobian/Cotangent/ChartAlgebra.lean` three times:

- 05:27:22Z: clean (3 sorry warnings at L97, L107, L132 — the file
  layout before the constants substep was added).
- 05:31:01Z: clean (3 sorry warnings at L97, L107, L144).
- 05:33:34Z: clean (3 sorry warnings at L97, L107, L144).
- 05:34:46Z (after final `Write` of task_result): clean (3 sorry
  warnings; final line numbers L97, L107, L144 in early checks but
  the L144 sorry actually lives inside the body at L177 in the
  final file — the L144 in the lake output is the declaration-uses-
  `sorry` warning attached to the declaration line).

## Mandatory review subagents (iter-146 review phase)

- `lean-auditor-iter146` returned **3 must-fix** + 4 major + 6 minor
  + 2 critical excuse-comments on `Cotangent/ChartAlgebra.lean`:
  - L97 `df_zero_factors_through_constant_on_chart : True := sorry`
    (β-core stub; OFF-LIMITS iter-146 per planner; carry-over from
    iter-145).
  - L107 `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
    : True := sorry` (KDM stub; OFF-LIMITS iter-146 per planner;
    carry-over from iter-145; also flagged for parallel-namespace
    placement under `AlgebraicGeometry` rather than at root).
  - L208 `ext_of_diff_zero` named-concept-vs-body mismatch (the
    `df = dg` hypothesis is dropped, body is a plain rename of
    `ext_of_eqOnOpen`).
  - 4 major: L177 substantive `sorry` inside `constants_*` (substep
    3 deferral); L144 declaration name "integral" understates
    "equal to"; L11–L25 iter-history duplicate scaffolding; L37–L57
    `## Status` block bakes per-iter content into the file
    docstring.
  - Full report at
    `.archon/task_results/lean-auditor-iter146.md`.
- `lean-vs-blueprint-checker-chart-algebra-iter146` returned
  **must-fix** on the `ext_of_diff_zero` signature mismatch with
  recommended fix = blueprint-side `% NOTE:` (preferred over
  re-adding `df = dg` as an unused parameter on the Lean side).
  Also flagged a major on the missing `[IsReduced X]` discipline at
  `lem:constants_integral_over_base_field` in the blueprint, and
  an optional minor on the single-`inferInstance` vs three-step
  chain at `lem:chart_algebra_isPushout_of_affine_product`. All
  five Lean declarations in `ChartAlgebra.lean` cross-reference
  cleanly to their blueprint blocks (5/5 coverage). Full report at
  `.archon/task_results/lean-vs-blueprint-checker-chart-algebra-iter146.md`.

## Blueprint markers updated (manual)

- `RigidityKbar.tex`, `lem:chart_algebra_isPushout_of_affine_product`:
  added `% NOTE: (iter-146 review)` recording that the iter-146
  Lean closure collapses the three-step Mathlib chain into a single
  `inferInstance` under the locally re-enabled
  `Algebra.TensorProduct.rightAlgebra` instance — keeps the chapter
  prose accurate without rewriting the three-step derivation, which
  remains the honest scheme-level path.
- `RigidityKbar.tex`, `lem:constants_integral_over_base_field`: added
  two `% NOTE: (iter-146 review)` blocks recording (a) the explicit
  `[IsReduced X]` Lean discipline (Mathlib `b80f227` lacks general
  `Smooth ⇒ IsReduced`), matching the convention already in
  `Rigidity.lean`'s "Hypothesis history"; (b) the iter-146 substep
  1–2 body closure with substep 3 deferred to iter-147+ via the
  `IsBaseChange` + Stacks Tag 02KH + `Module.finrank_baseChange` chain.
- `RigidityKbar.tex`, `lem:Scheme_Over_ext_of_diff_zero`: added
  `% NOTE: (iter-146 review)` documenting the iter-146 Lean signature
  reduction (the `df = dg` + smooth-proper-genus-0 curve + smooth-
  proper-group-scheme hypotheses are dropped; the Lean lemma is a
  thin renaming of `ext_of_eqOnOpen` consuming `eqOnOpen` directly,
  with iter-147+ scheduled to re-add `df = dg` and derive
  `eqOnOpen` from it via the chart-algebra (β) Steps 1–2).
- No `\mathlibok` added (no Lean side directly re-exports a Mathlib
  declaration; all three iter-146 closed lemmas are project
  declarations that *use* Mathlib lemmas, not aliases of them).
- No `\notready` stripped (no chart-algebra block had a stale
  `\notready` from before the iter-146 lane).
- No `\lean{...}` corrections (the prover did not rename any
  declaration; all three signatures retain the iter-145 planner-
  chosen Lean names).

## Blueprint doctor findings (iter-146)

The deterministic `blueprint-doctor` flagged **5 empty
`\uses{}`** annotations in
`blueprint/src/chapters/Cohomology_MayerVietoris.tex`. These
would crash the next `leanblueprint web` build with
`Label '' could not be resolved` → `RecursionError`. The plan
agent for iter-147 must address them — see `recommendations.md` for
the actionable next-iter item.

## Key findings / patterns discovered

- **`Mathlib.RingTheory.IsTensorProduct` ships `TensorProduct.isPushout`
  as an instance, but the right-algebra structure it depends on
  (`Algebra.TensorProduct.rightAlgebra`) is `local` to that file.**
  Files downstream of `Mathlib.RingTheory.IsTensorProduct` that want
  the canonical `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` instance
  must re-enable the local instance via
  `attribute [local instance] Algebra.TensorProduct.rightAlgebra`.
  Documented inline at `ChartAlgebra.lean:70–74`.
- **Algebra-level `Algebra.IsPushout` is a single `inferInstance`**
  on `TensorProduct k B₁ B₂` once the right-algebra is in scope —
  no scheme-level `pullbackSpecIso` chain needed for the chart-algebra
  use case. The scheme-level chain is still the honest derivation,
  but for the chart-algebra (α) helper at the algebra level, the
  Mathlib instance is the closure.
- **`Smooth (X → Spec k) ⇒ IsReduced X` is a Mathlib gap in
  `b80f227`** for general base. The closest lemma is
  `Scheme.Hom.dense_smoothLocus_of_perfectField` (perfect-base
  only). The project's discipline is to explicitly carry
  `[IsReduced X]` at every call site that needs it; the discipline
  is now documented at three sites: `Rigidity.lean`'s "Hypothesis
  history" (pre-existing), `ChartAlgebra.lean:140–143` (iter-146
  add), and `RigidityKbar.tex:lem:constants_integral_over_base_field`'s
  new `% NOTE:` block (iter-146 review-phase add).
- **Mathlib `b80f227` lacks "finite `k`-algebra `A` with
  `A ⊗_k k̄ ≃ k̄` forces `A = k`"** — must be assembled from the
  dimension-count chain (`Module.finrank_baseChange` +
  `Subalgebra.finrank_bot` /
  `IntermediateField.bot_eq_top_iff_finrank_eq_one`). This is the
  iter-147+ substep 3 closure path for
  `constants_integral_over_base_field`.
- **`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
  + `IsProper` extends `UniversallyClosed` and `LocallyOfFiniteType`** —
  the cleanest Mathlib chain for "Γ(X, ⊤) is a finite-dim field
  extension of k under `IsProper (X ↘ Spec k)` + `IsIntegral X`".
  Reusable for any chart-algebra-style structure that needs to
  reduce a `Γ`-type claim to its dimension over the base field.
- **Named-concept-vs-body mismatch as iter-146 review-phase**
  pattern: when a prover refines a `: True := sorry` placeholder by
  delegating to a renamed-but-existing lemma (here:
  `ext_of_diff_zero` → `ext_of_eqOnOpen`), the blueprint MUST get
  a `% NOTE:` flag that the Lean lemma is a deliberate signature
  reduction, not the load-bearing form the chapter sketches.
  Otherwise the chapter and the Lean are out of sync, and the
  next prover attempt at the load-bearing form will be confused
  about whether the lemma is already closed.

## Recommendations for next session

See `recommendations.md`. Top items:
1. **Iter-147 mandatory blueprint-reviewer** re-confirms
   `RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_GrpObj.tex`
   are both `complete: true / correct: true` post the iter-146
   Wave 2 writers + iter-146 review-phase `% NOTE:` adds.
2. **Iter-147 blueprint-writer dispatch on
   `Cohomology_MayerVietoris.tex`** to fix the 5 empty `\uses{}`
   annotations flagged by the blueprint doctor (this is a HARD
   build-crash blocker, not just a hygiene issue).
3. **Iter-147 prover lane on `constants_integral_over_base_field`
   substep 3** to close the geom-irr base-change `dim_k Γ = 1`
   chain via `Module.finrank_baseChange` + flat base change of
   `Γ` for a proper scheme.
4. **Iter-147+ ext_of_diff_zero re-refinement**: re-add `df = dg`
   hypothesis to the Lean signature and derive `eqOnOpen` from it
   via the chart-algebra (β) Steps 1–2. Depends on the β-core
   sub-piece landing first.
5. **`ChartAlgebra.lean` cleanup pass** addressing the 4 major +
   6 minor findings from `lean-auditor-iter146`: trim the L11–L25
   iter-history duplicate scaffolding, demote the L37–L57
   `## Status` block to a `STRATEGY.md`-only reference, drop the
   unused `open Limits`, and re-evaluate the file-scope
   `attribute [local instance]` widening.
