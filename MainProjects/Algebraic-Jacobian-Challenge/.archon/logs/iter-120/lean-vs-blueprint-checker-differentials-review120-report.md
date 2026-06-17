# Lean ↔ Blueprint Check Report

## Slug
differentials-review120

## Iteration
120

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean`
- Blueprint: `blueprint/src/chapters/Differentials.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (chapter: `def:relative_kaehler_presheaf`)
- **Lean target exists**: yes (Differentials.lean:49)
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules`, constructed via `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` applied to the adjunction transpose of `f.c` (the comorphism), exactly mirroring the chapter's prose ("paired with $\struct{X}$ by the canonical adjunction-transpose").
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**: the chapter and the Lean both use `TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat`. Definition is `noncomputable`, consistent with the colimit/Kan-extension nature flagged in the chapter prose.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (chapter: `lem:relative_kaehler_presheaf_obj`)
- **Lean target exists**: yes (Differentials.lean:58)
- **Signature matches**: yes — type equality `((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) = CommRingCat.KaehlerDifferential (φ'.app V)` matches the chapter's $\Omega_{X/S}(V) = \Omega_{\struct{X}(V) / (f^{-1}_{\mathrm{psh}}\struct{S})(V)}$.
- **Proof follows sketch**: yes — body is `rfl`, exactly the "identification is by `rfl` after unfolding" the chapter promises.
- **notes**: clean — the chapter's claim that the K\"ahler module is defined object-wise is precisely vindicated by the `rfl` proof.

### `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}` (chapter: `thm:smooth_locally_free_omega`)
- **Lean target exists**: yes (Differentials.lean:91)
- **Signature matches**: yes — `[SmoothOfRelativeDimension n f]` (un-aliased, not the deprecated `IsSmoothOfRelativeDimension`), conclusion `∃ U V (e : V ≤ f ⁻¹ᵁ U), x ∈ V ∧ IsAffineOpen U ∧ IsAffineOpen V ∧ (Module.Free … ∧ Module.rank … = n)` over the appLE algebra structure. This is the exact algebra-K\"ahler form the chapter states.
- **Proof follows sketch**: yes (with one minor packaging difference, noted below).
- **notes**:
  - Step 1 packaging differs from chapter prose. Chapter Step 1 names `AlgebraicGeometry.smoothOfRelativeDimension_iff` (the `@[mk_iff]`-generated bridge). The Lean proof instead uses the direct accessor `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`, which is the same `∃ U, IsAffineOpen U, ∃ V, IsAffineOpen V, x ∈ V, e : V ≤ f ⁻¹ᵁ U, RingHom.IsStandardSmoothOfRelativeDimension n …` content packaged as a direct existential rather than an `iff`. Mathematically identical, syntactically lighter. Minor proof-vs-chapter drift in the *named tool*, not in the *mathematical step*.
  - Steps 2, 3, 4 use the exact names the chapter lists: `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential n`. Clean match.
  - Step 4.5 packaging also differs. Chapter says the `Nontrivial Γ(X, V)` side condition is discharged via `AlgebraicGeometry.Scheme.component_nontrivial`. The Lean proof instead builds `haveI : Nonempty V := ⟨⟨x, hxV⟩⟩` and lets typeclass inference chain `Nonempty V → Nontrivial Γ(X, V)`. Mathematical content (V is non-empty because `x ∈ V`, hence the section ring is nontrivial) is identical; the chapter just names a downstream lemma that the Lean prover doesn't invoke by name.

## Red flags

None. No `:= sorry`, no `:= True`/`:= rfl` on substantive claims (the one `rfl` is on a definitionally-true type equality the chapter authorises), no excuse-comments, no custom axioms (`lean_verify` reports only `propext`, `Classical.choice`, `Quot.sound`).

## Unreferenced declarations (informational)

None — every `def`/`theorem` in `Differentials.lean` (3 total) has a matching `\lean{...}` block in the chapter.

## Blueprint adequacy for this file

- **Coverage**: 3/3 — all Lean declarations have a corresponding `\lean{...}` block in the chapter. Zero unreferenced declarations. Out-of-scope remarks (`rem:bridge_relative_kaehler_iso_appLE`, `rem:converse_counterexample`, `rem:converse_lemma_hypotheses`, `rem:stacks_02G1`) are intentionally Lean-side-less per the directive's known-issues list.
- **Proof-sketch depth**: adequate. The chapter's `\begin{proof}` for `thm:smooth_locally_free_omega` enumerates Steps 1–4.5 with the exact Mathlib lemma names, matching the verified 6-step Mathlib chain that the prover closed. The `lem:relative_kaehler_presheaf_obj` proof block also previews the `rfl` resolution.
- **Hint precision**: precise. The chapter's Remark `rem:smooth_class_naming` explicitly pins `AlgebraicGeometry.SmoothOfRelativeDimension` over the deprecated alias, and the Lean uses the un-aliased class. The `\lean{...}` hints resolve to the exact declarations (verified via `lean_hover_info`).
- **Generality**: matches need. The algebra-K\"ahler form is chosen deliberately to sidestep the unproved presheaf bridge; the chapter is explicit about this trade-off (`sec:bridge-out-of-scope`).
- **Recommended chapter-side actions**: minor only.
  - Consider noting in Step 1 of the proof body that the Lean formalisation may use either the `mk_iff` form `smoothOfRelativeDimension_iff` or the equivalent direct accessor `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`. This is purely editorial — both produce the same chart.
  - Consider noting in Step 4.5 that the `Nontrivial Γ(X, V)` discharge can equivalently be obtained by building `Nonempty V` from `x ∈ V` and letting typeclass inference chain through `Nonempty → Nontrivial` on the section ring, in addition to the named `component_nontrivial` route.
  - Both are optional polishing; neither changes the mathematical content.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: two prose-vs-Lean naming drifts in the `thm:smooth_locally_free_omega` proof block (Step 1's `smoothOfRelativeDimension_iff` vs. the direct existential accessor used in Lean; Step 4.5's `component_nontrivial` vs. the inline `Nonempty V` construction). Both are descriptive nits, not correctness issues. The mathematical content matches step-for-step.

Overall verdict: the chapter and the Lean are in faithful bidirectional alignment for this iteration; the freshly-closed `smooth_locally_free_omega` proof correctly formalises the chapter's 6-step Mathlib chain, and the chapter is ready for `\leanok` on both the statement and proof blocks (the `\lean{...}` hints pin the right declarations for `sync_leanok`).
