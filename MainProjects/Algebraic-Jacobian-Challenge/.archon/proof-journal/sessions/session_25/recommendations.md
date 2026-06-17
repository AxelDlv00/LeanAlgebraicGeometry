# Recommendations for the next plan-agent iteration (iter-031)

## Headline

Iter-030 (this session) closed the **toModuleKSheaf specialisation on a curve** of the Serre-finiteness chain (Path 2, Step 2.5) in a single Edit with no corrective Edit. Two new declarations: `AffineCoverMVSquare.HModule'_sequence_curve` (`noncomputable def`) and `AffineCoverMVSquare.HModule'_sequence_curve_exact` (`lemma`). Both kernel-only axioms, sorry trajectory `9 → 9 → 9` (no transient).

Recommended iter-031 prover lane:

- **Track 1 (primary):** the **cover-totality identification on cohomology**, materialising Step 3 of the Serre-finiteness sketch — a linear isomorphism `HModule' k F n ⊤ ≃ₗ[k] HModule k F n`. This is the bridge from the iter-014 / iter-015 carrier H^n on a sheaf to the iter-022 / iter-026 abstract LES H' on a MV-square; the X₄ corner of an `AffineCoverMVSquare` is `⊤` (iter-029 lemma), so the LES on a 2-affine cover terminates at the global cohomology of the whole curve. Concrete shape: `noncomputable def Scheme.HModule'_top_iso (k : Type u) [Field k] {X : Scheme.{u}} (F : Sheaf …) (n : ℕ) : HModule' k F n ⊤ ≃ₗ[k] HModule k F n` (or however the iter-014 carrier is named — re-probe Mathlib at plan time). Heavily mirrors the iter-014 / iter-015 idiom of bridging a generic-`Opens`-indexed cohomology to its global-section incarnation. Single declaration, narrow scope, suitable for single-Edit closure if the body reduces to `Abelian.Ext.linearEquiv₀` or similar.
- **Track 2 (parallel low-coupling):** **none recommended**. Polish backlog remains empty.

## Heavier alternative for iter-031 if Track 1 is gated

- **Affine vanishing input** `Scheme.HModule'_zero_of_isAffineOpen` (or similar): `H^{>0}(Spec A, F) = 0` for any `IsAffineOpen U` and `n ≥ 1`. This is Step 4 of the Serre-finiteness sketch and is the heaviest step of the chain — possibly multi-iteration depending on Mathlib state for affine vanishing. Recommended only if Track 1 turns out to be Mathlib-gated.

## Concrete plan-agent actions

1. **Migrate the iter-030 cohort entries to `task_done.md`** (two new entries):
   - `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve` — RESOLVED iter-030 / session 39, single Edit, kernel-only axioms, dot-notation method-call form.
   - `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve_exact` — RESOLVED iter-030 / session 39, same Edit.
2. **Clear the iter-030 candidate from `task_pending.md`** and queue iter-031+ candidates: cover-totality identification (primary), affine vanishing (heavier alternative), then the finite-dimensional `H^0` chain.
3. **Append the two new declaration names to `blueprint/lean_decls`**.
4. **Re-probe Mathlib state** before drafting the iter-031 directive:
   - Cover-totality bridge: search for `Sheaf.cohomology … ⊤` / `HasGlobalSections` / `Abelian.Ext … ⊤` / similar Mathlib idioms that already build the bridge `cohomology on the top open ≃ global cohomology`. If Mathlib already has this, the iter-031 prover task is a thin re-export. If not, the bridge needs a from-scratch construction in `Cohomology/StructureSheafModuleK.lean` (or `Cohomology/MayerVietoris.lean`).
   - Affine vanishing API: search for `AlgebraicGeometry.Scheme.IsAffineOpen.cohomology_zero` / `Serre.affine_vanishing` / similar. Status of `H^{>0}(Spec A, F) = 0` infrastructure in Mathlib determines the multi-iteration cost of Step 4.
   - Čech-vs-derived-functor comparison API: re-probe at iter-031 plan time to determine whether Step 5 (finite-dimensional `H^0`) can use Čech-form computation or must go via derived functor.
5. **Pre-specify naming and qualification** in the iter-031 directive:
   - If the new declaration is sub-namespaced (`AffineCoverMVSquare.X`), state in the directive whether the body should use `_root_.AlgebraicGeometry.Scheme.X` (parent-namespace declaration with name collision) or `S.X` dot-notation (sub-namespace method on a receiver of the sub-namespace's expected type). The iter-029 / iter-030 dichotomy is now well-documented and either choice is correct given the right context.
6. **Append the iter-031 § to `blueprint/src/chapters/Cohomology_MayerVietoris.tex`** with the new label, `\lean{...}` macro, `\uses{...}` cross-references, and informal prose. Leave `\leanok` markers off — those are the review agent's surface.

## Hard avoid (do not retry)

- `representable` (deferred per directive — `PicardFunctor.representable` requires FGA-level machinery and the LineBundle refinement, both Mathlib-gated).
- The 8 remaining protected sorries (`Jacobian` × 5 + `AbelJacobi` × 3) — gated on Phase A step 6 *Path 2* (the very chain iter-030 is on; need Steps 3–5 first), Phase C step 4 (FGA representability), the deferred `representable`, the `LineBundle` refinement Mathlib gap, and `noncomputable` user-decisions on two of the def-flavoured ones.
- Direct `LineBundle` refinement (Mathlib-gated until either the refinement lands or the user decides to formalise it from scratch).
- Renaming any of the 33 declarations now in `Cohomology/MayerVietoris.lean` (23 from iter-016 → iter-026 + 2 from iter-028 + 6 from iter-029 + 2 from iter-030).
- Bare in-namespace short-name references inside the body of a sub-namespaced declaration whose body needs to invoke a parent-namespace declaration — use `_root_.AlgebraicGeometry.Scheme.X` (iter-029 lesson, still in force).
- Forgetting `[HasWeakSheafify J (Type u)]` alongside `[HasSheafify J (ModuleCat.{u} k)]`.
- `def` instead of `noncomputable def` for any declaration whose body unfolds to a sheafification or other noncomputable construction.

## Reusable patterns from this session

- **Dot-notation method-call form (`S.foo`) sidesteps the iter-029 sub-namespace shadowing trap when the receiver type carries the expected method.** Two cases now documented:
  1. Body invokes a *parent-namespace* declaration whose short name collides with the current sub-namespace → use `_root_.X.Y.Z` (iter-029 pattern).
  2. Body invokes a *sub-namespace method* on a receiver of the sub-namespace's expected type → use `S.foo` dot-notation (iter-030 pattern).
- **Two-declaration prover rounds in a single Edit when the cohort is a tightly-coupled `def + lemma` mirror pair on top of an existing abstract specialisation cohort.** Pattern: an iter-N-1 abstract cohort exposes `Foo` and `Foo_exact`; iter-N binds them by composition with a fixed sheaf flavour as `Foo_curve` and `Foo_curve_exact`. Bodies are term-mode one-liners with dot-notation method calls.
- **Probe-confirmed term-mode bodies adopted verbatim land at ~100% reliability** at the semantic content level, and at ~100% syntactic level too when the body uses dot-notation method-call form rather than bare short names. The iter-029 syntactic exception is now a special case of the broader pattern.
- **`noncomputable` propagates through structure-sheaf-binding delegations** — the iter-030 `HModule'_sequence_curve` is `noncomputable def` because its body references `Scheme.toModuleKSheaf C`. The exactness companion is a `lemma` (proposition-valued, no `noncomputable` needed).

## Status of the Serre-finiteness chain

- **Step 1 (abstract LES on a MV-square)**: COMPLETE — iter-022 / iter-023 / iter-026 abstract LES + exactness; iter-029 sheaf-parameterised specialisation on `AffineCoverMVSquare`.
- **Step 2 (corner-identification simp lemmas on `AffineCoverMVSquare`)**: COMPLETE — iter-029.
- **Step 2.5 (toModuleKSheaf specialisation on a curve)**: COMPLETE — iter-030 (this session).
- **Step 3 (cover-totality identification on cohomology, `HModule' k F n ⊤ ≃ₗ[k] HModule k F n`)**: PENDING — iter-031 primary candidate.
- **Step 4 (affine vanishing `H^{>0}(Spec A, F) = 0`)**: PENDING — iter-032+ (heavier, possibly multi-iteration).
- **Step 5 (finite-dimensional `H^0` ⇒ `Module.Finite k (HModule k F i)`)**: PENDING — iter-033+ (depends on Step 4).
- **Step 6 (consume into `smoothOfRelativeDimension_genus`)**: PENDING — once Steps 3–5 land, the protected `Jacobian.lean` sorry on `smoothOfRelativeDimension_genus` becomes addressable.

## Probe discipline reminder for iter-031

The probe runs in a fresh module without the new sub-namespace, so:
- It cannot exercise the iter-029 sub-namespace shadowing trap (parent-namespace bare-name resolution inside a sub-namespaced declaration's body).
- It *can* exercise iter-030-style dot-notation method-call resolution when the receiver type is correctly annotated.
- For any iter-031 directive that defines a new sub-namespaced declaration, pre-specify in the directive's "body shape" hint whether bodies should use `_root_.` qualification (case 1) or dot-notation (case 2). This sidesteps the only documented probe-vs-prover gap.

## Eventual blueprint markers to add (next review pass)

The iter-031 plan agent will write the new chapter blocks (definition + theorem + proof prose); the iter-031 review agent (this agent's iter-031 successor) should add `\leanok` markers once the prover lands. Marker conventions stable.
