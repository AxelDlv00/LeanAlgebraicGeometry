# Refactor Directive

## Slug
cotangent-grpobj-body-shape-iter131

## Problem

The iter-130 body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (in `AlgebraicJacobian/Cotangent/GrpObj.lean:131-170`) is **structurally opaque** for the downstream rank lemma `cotangentSpaceAtIdentity_finrank_eq` (deferred to iter-132+).

Concretely, the iter-130 body uses:

```lean
  refine Classical.choice (α := ModuleCat k) ?_
  obtain ⟨U, V, e, hxV, _hU, _hV, _hfree, _hrank⟩ := Scheme.smooth_locally_free_omega …
  …
  exact ⟨(ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])⟩
```

After elaboration, the outermost head symbol is `Classical.choice` applied to a `Nonempty (ModuleCat k)` witness. By kernel-level rules (verified by the iter-131 mathlib-analogist at `Init/Classical.lean:19-32`), `Classical.choice` has no reduction rule beyond eta; the result is **not definitionally equal** to the explicit witness term `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`. Downstream rank-lemma prover lanes cannot `unfold cotangentSpaceAtIdentity` to expose the `extendScalars`/`Ω` structure.

This was flagged as **must-fix** by both `lean-auditor-review130` and `mathlib-analogist-cotangent-body-shape-iter131`. The strategy-critic-iter131 + progress-critic-iter131 both flagged the route as CHURNING (4th body-shape touch in 4 consecutive iters on the same declaration). The corrective is a body-shape refactor that exposes the chart-base-changed Kähler module as the outermost head symbol of the elaborated body, even though the chart `V` itself remains `Classical.choose`-extracted (opaque-but-named) from `smooth_locally_free_omega`'s `Prop`-level existential.

## Mathematical Justification

The replacement body shape is detailed in `analogies/cotangent-body-shape.md` § Recommendation. It restructures the body from a `by`-tactic block (which forces `Classical.choice` to bridge `Prop` and `Type`) to a **pure-term `noncomputable def`** using `let`-bindings whose RHSs invoke `Classical.choose` / `Classical.choose_spec` on the same `smooth_locally_free_omega …` existential. The outer body expression is then the explicit `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])` form, **not** wrapped in `Classical.choice` or any sigma-type.

Mathlib precedent: `Polynomial.SplittingField` / `SplittingFieldAux` (`Mathlib.FieldTheory.SplittingField.Construction:126-138`) is exactly this pattern — named extractor with `Classical.choose` / `.choose_spec` accessors plus an explicit outer expression that downstream consumers can rewrite against by delta-reducing the `let`-bindings.

The semantics is unchanged (kernel-clean; only `propext, Classical.choice, Quot.sound` axioms; rigidity consumer sees the same rank-`n` `k`-module). The change is purely structural: `cotangentSpaceAtIdentity G` now reduces to `(extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])` (with named-but-opaque `V`, `ψV`, etc.) instead of `Classical.choice ⟨…⟩`. The downstream rank lemma can then `unfold` + `obtain ⟨_, _, _, _, hfree, hrank⟩ := h.choose_spec.choose_spec.choose_spec` on the **same** existential to access `Module.Free` and `Module.rank … = n`.

## Changes Requested

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

**Body replacement** of the `cotangentSpaceAtIdentity` declaration at lines ~131-170. Replace the `by`-tactic-block body with a pure-term `noncomputable def`. The signature is preserved exactly (no change to the binder list `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k`).

**Reference implementation** (from `analogies/cotangent-body-shape.md` § Recommendation, with the projection variant the refactor agent should adapt as the prover's local discoveries dictate):

```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  let h := Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  let U : (Spec (.of k)).Opens := h.choose
  let h₁ := h.choose_spec
  let V : G.left.Opens := h₁.choose
  let h₂ := h₁.choose_spec
  let e : V ≤ G.hom ⁻¹ᵁ U := h₂.choose
  let hxV : x₀ ∈ V := h₂.choose_spec.1
  have htop : (⊤ : (Spec (.of k)).Opens) ≤ ηleft ⁻¹ᵁ V := by
    intro s _
    rw [Scheme.Hom.mem_preimage]
    rw [show s = default from Subsingleton.elim _ _]
    exact hxV
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k :=
    ηleft.appLE V ⊤ htop ≫ (Scheme.ΓSpecIso (.of k)).hom
  letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  (ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])
```

The refactor agent should adjust precise field-projection access (`h.choose_spec.choose`, `.choose_spec.choose_spec.choose`, etc.) per the actual signature of `Scheme.smooth_locally_free_omega` in `AlgebraicJacobian/Differentials.lean`. The exact structure of the existential's tuple — `⟨U, V, e, hxV, hU, hV, hfree, hrank⟩` per the iter-130 body's `obtain` — should match: 8 component fields, where `hxV` is the 4th (index `.choose_spec.choose_spec.choose_spec.1` if anonymous, or `.choose_spec.choose_spec.choose_spec.choose` etc. depending on Lean's nested `∃`/`∧` desugaring). Verify by running `lean_diagnostic_messages` after the edit.

**Defensive verification** (after the body refactor, in the same file, after the def): add a `rfl`-closable bridge lemma to confirm the body is structurally accessible:

```lean
/-- Defensive lemma: `cotangentSpaceAtIdentity G` is definitionally equal to its
explicit chart-base-changed Kähler module form. The chart `V`, the algebra
structure, and the Kähler module are opaque (`Classical.choose`-extracted) but
the outer `extendScalars`/`ModuleCat.of`-of-`Ω` form is exposed. This proves
that the iter-131 body refactor closed the iter-130 opacity defect: a
downstream rank lemma can `simp only [cotangentSpaceAtIdentity_eq]` to rewrite
the body to the explicit form. -/
theorem cotangentSpaceAtIdentity_eq_extendScalars (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ∃ (U : (Spec (.of k)).Opens) (V : G.left.Opens) (e : V ≤ G.hom ⁻¹ᵁ U)
        (htop : (⊤ : (Spec (.of k)).Opens) ≤
          (CategoryTheory.CommaMorphism.left η[G]) ⁻¹ᵁ V),
      letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
        (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
      cotangentSpaceAtIdentity G =
        (ModuleCat.extendScalars
          ((CategoryTheory.CommaMorphism.left η[G]).appLE V ⊤ htop ≫
            (Scheme.ΓSpecIso (.of k)).hom).hom).obj
          (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)]) := by
  unfold cotangentSpaceAtIdentity
  refine ⟨_, _, _, _, ?_⟩
  rfl
```

The lemma is the **acceptance test** for the iter-131 refactor: it MUST close by `rfl` (or `unfold cotangentSpaceAtIdentity; rfl`) under the refactored body. If it does not close, the refactor's structural exposure is incomplete and must be re-attempted. **This is the strategy-critic-iter131 must-fix-this-iter "ensure the iter-131 refactor lane's deliverable is testable" requirement.**

If the exact statement of `cotangentSpaceAtIdentity_eq_extendScalars` is hard to formulate with the nested existentials (because of `letI` instance unification), a weaker variant that just witnesses the form (without re-deriving the `htop` proof) is acceptable:

```lean
-- Weaker fallback: just witness that the body's outermost head symbol is `extendScalars`.
theorem cotangentSpaceAtIdentity_eq_extendScalars_weak (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ∃ (M : Type _) (_ : AddCommGroup M) (R : Type _) (_ : CommRing R)
        (_ : Algebra R k) (_ : Module R M),
      cotangentSpaceAtIdentity G = (ModuleCat.extendScalars (Algebra.toRingHom : R →+* k)).obj
        (ModuleCat.of R M) := by
  -- … by destructuring the `Classical.choose`-chain and producing the
  -- explicit witness existential.
  sorry  -- if this proves to be hard, mark it INCOMPLETE in the report
```

**Strong preference**: close the `_extendScalars` lemma (strong form preferred, weak fallback acceptable). If neither closes by `rfl` after the body refactor, write a PARTIAL report naming what blocked.

**Docstring refresh**: 
- Update lines 64–66 ("Status (iter-130 fix-up: body replaced with chart-base-change Replacement (B))") to "Status (iter-131 fix-up: `Classical.choice` wrapper removed; body refactored to pure-term form exposing chart-base-changed Kähler module to downstream consumers)".
- Update the lines ~118-126 "Caveat on canonicity" paragraph in the declaration docstring: drop the misleading framing that the body's loss is "not canonical in the strictest sense". The accurate framing is: the body's chart `V` is `Classical.choose`-extracted (so the resulting `k`-module is non-canonical), but its `ModuleCat k`-shape is the explicit `(ModuleCat.extendScalars _).obj _`-of-`Kähler-module`-form (so downstream rank-lemma proofs can reach it via `unfold` + `let`-binding delta-reduction). Reference the new `cotangentSpaceAtIdentity_eq_extendScalars` lemma as the formal proof that the structural shape is exposed.
- Update lines ~128-130 to point at the new structural-accessibility theorem instead of vaguely promising "the structural properties are content for the iter-129+ rank lemma".

### Piggyback: `AlgebraicJacobian/Jacobian.lean` docstrings

Per `lean-auditor-review130` major findings #2 + #3 (and recorded in iter-131 task_pending.md):

- **L195** (`nonempty_jacobianWitness` docstring): "This is the single remaining mathematical sorry of the Phase-C Jacobian scaffolding" — STALE. The file now carries TWO sorries (`genusZeroWitness` at L188 + `nonempty_jacobianWitness` at L211). Rewrite to "This is one of the two open mathematical sorries of the Phase-C Jacobian scaffolding (the other being `genusZeroWitness` of `def:genusZeroWitness`); both are scheduled for body closure post M2 + M3 per STRATEGY.md."
- **L226** (`Jacobian` def docstring): same staleness ("the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding"). Bring into alignment with the new L195 phrasing and with the file-level docstring at L19–30 which correctly enumerates two sorries.

These are pure docstring edits; no Lean body change. They piggyback on this refactor lane because `Jacobian.lean` was off-limits to the iter-130 prover lane.

## Affected Files

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — body shape refactor + new `_extendScalars` defensive lemma + docstring refresh.
- `AlgebraicJacobian/Jacobian.lean` — two-docstring touch-up (lines ~195 + ~226).

**No other files**. Specifically NOT TOUCHED:
- `AlgebraicJacobian/RigidityKbar.lean` — body of `rigidity_over_kbar` still has its sorry; off-limits per the iter-131 plan (post-iter-131 deferral pending pile closure).
- `AlgebraicJacobian/Differentials.lean` — `smooth_locally_free_omega` shape unchanged (the analogist's future-cleanup item to convert it to a `Σ'`-bundle is out-of-scope for iter-131).
- `archon-protected.yaml` — no signatures changed.
- Blueprint chapters — handled separately by `blueprint-writer-abeljacobi-galois-iter131` (already returned COMPLETE) + deferred `RigidityKbar.tex` writer to iter-132 (per `blueprint-reviewer-iter131` directive-override authorisation).

## Expected Outcome

After the refactor lands:

1. **`Cotangent/GrpObj.lean`** compiles clean (`lean_diagnostic_messages` returns 0 items; `lake env lean Cotangent/GrpObj.lean` exits silently).
2. **`lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`** returns `{propext, Classical.choice, Quot.sound}` — kernel-only; no `sorryAx`, no named axioms.
3. The body of `cotangentSpaceAtIdentity` is a pure-term `noncomputable def` (no `by`-tactic block at the top level). After `unfold cotangentSpaceAtIdentity`, the body reduces (modulo `let`-binding delta) to `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])`.
4. **Acceptance test lemma `cotangentSpaceAtIdentity_eq_extendScalars`** (or its weak fallback) closes by `rfl` (or `unfold cotangentSpaceAtIdentity; rfl`). This is the testable iter-131 deliverable per strategy-critic-iter131.
5. **Sorry count unchanged**: 3 (Jacobian.lean:188 `genusZeroWitness`, Jacobian.lean:211 `nonempty_jacobianWitness`, RigidityKbar.lean:87 `rigidity_over_kbar`). The new acceptance-test lemma is a `theorem`, not a `def` with `sorry`.
6. **`Jacobian.lean`** docstrings at L195 + L226 are updated; sorry count unchanged.
7. **`lake build`** passes end-to-end.

## Constraints

- **NO new axioms.** `lean_verify` of `cotangentSpaceAtIdentity` must remain kernel-only.
- **NO signature changes** on `cotangentSpaceAtIdentity` (binder list preserved verbatim).
- **NO touching the off-limits files** named above (`RigidityKbar.lean`, `Differentials.lean`, `archon-protected.yaml`, blueprint chapters).
- **NO new `sorry` bodies.** The refactor is closure-of-existing-shape, not new scaffolding. The new acceptance-test lemma must close by `rfl` (or `simp` / `rfl`-related); if it doesn't, report PARTIAL and name the specific blocker.
- **`Classical.choose`-chain pattern** — do not use `Σ'`-bundles or `Classical.indefiniteDescription` as the primary destructuring mechanism (the iter-131 analogist's recommendation is the `let`-binding-of-`Classical.choose` pattern, matching the `Polynomial.SplittingFieldAux` Mathlib precedent).
- **If the strong `_extendScalars` lemma proves intractable**, the weak fallback variant is acceptable. The strong lemma is preferred because it gives the iter-132+ rank-lemma prover lane a direct `simp` rewrite handle.

## Acceptance test (per strategy-critic-iter131)

The deliverable's testability is the iter-131 refactor's pre-commit signal: 

- The acceptance-test lemma `cotangentSpaceAtIdentity_eq_extendScalars` (or its weak fallback) must close cleanly.
- If it fails to close, this is empirical evidence that the proposed `Classical.choose`-chain body shape does NOT solve the opacity defect, and the iter-131 refactor result must be classified as PARTIAL with the iter-132 plan re-opening Replacement (A) / (B′) / fibre-free reformulation as a route pivot.

A PARTIAL report from this refactor lane is acceptable and actually preferred over a misleading COMPLETE: if `Classical.choose`-chain doesn't work, we need to know NOW, not after another prover dispatch on the deferred rank lemma.
