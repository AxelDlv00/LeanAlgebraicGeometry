# Refactor Report

## Slug
cotangent-grpobj-body-shape-iter131

## Status
COMPLETE — body shape refactored to pure-term `noncomputable def` exposing the chart-base-changed Kähler module as the outermost head symbol; the **strong** acceptance-test lemma `cotangentSpaceAtIdentity_eq_extendScalars` closes by `rfl` (no fallback needed); `Jacobian.lean` docstrings updated; `lake build` passes; axiom hygiene preserved (kernel-only `{propext, Classical.choice, Quot.sound}`); sorry count unchanged at 3.

## Directive

### Problem
Iter-130 body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` was wrapped in `Classical.choice (α := ModuleCat k) ⟨…⟩`, making the outermost head symbol `Classical.choice`. Downstream rank lemmas could not `unfold` past the `Nonempty (ModuleCat k)` wrapper to expose `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])`. Flagged must-fix by lean-auditor-review130 + mathlib-analogist-cotangent-body-shape-iter131. Body-shape refactor required to switch to a pure-term `Classical.choose`-chain pattern (Mathlib idiom; `SplittingFieldAux` precedent).

### Changes requested
1. Replace `cotangentSpaceAtIdentity`'s `by`-tactic body with a pure-term `noncomputable def` using `let`-bindings on `Classical.choose`/`.choose_spec` of `smooth_locally_free_omega`.
2. Add acceptance-test lemma `cotangentSpaceAtIdentity_eq_extendScalars` (strong form preferred; weak fallback acceptable).
3. Refresh `cotangentSpaceAtIdentity` docstrings: Status block + "Caveat on canonicity" + closing paragraph.
4. Piggyback: rewrite stale docstrings on `Jacobian.lean:195` + `Jacobian.lean:226` ("single remaining mathematical sorry" → "one of the two open mathematical sorries").

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **What:** Replaced the `by`-tactic body of `cotangentSpaceAtIdentity` (was `by classical; refine Classical.choice ?_; obtain ⟨…⟩ := smooth_locally_free_omega …; exact ⟨…⟩`) with a pure-term `noncomputable def`. The new body chains `let h := …`, `let U := h.choose`, `let h₁ := h.choose_spec`, `let V := h₁.choose`, `let h₂ := h₁.choose_spec`, `let e := h₂.choose`, `let hxV := h₂.choose_spec.1`, then `let htop`, `let ψV`, `letI : Algebra …`, and finally the outer expression `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of Γ(G.left, V) Ω[…])`. The `htop` proof is a `fun s _ => by rw [Scheme.Hom.mem_preimage, …]; exact hxV` inline lambda.
- **Why:** Per directive — kernel rules give `Classical.choice` no reduction beyond eta, so the iter-130 body was structurally opaque. The `Classical.choose`-chain pattern (Mathlib's `SplittingFieldAux` idiom) lets the outer expression remain explicit while named-but-opaque chart accessors carry the existential's data.
- **Cascading:** None within the file — the signature is preserved verbatim.

- **What:** Added new theorem `cotangentSpaceAtIdentity_eq_extendScalars` (the **strong** form, witnessing the existential of `U`, `V`, `e`, `htop` such that `cotangentSpaceAtIdentity G = (extendScalars …).obj (ModuleCat.of … Ω[…])`).
- **Why:** Per directive — this is the iter-131 testable deliverable (strategy-critic-iter131 must-fix). The lemma closes by `refine ⟨h.choose, h.choose_spec.choose, h.choose_spec.choose_spec.choose, fun s _ => ?_, rfl⟩` followed by the `htop` proof. The final `rfl` exercises the structural exposure: it proves `cotangentSpaceAtIdentity (n := n) G` definitionally equals the explicit chart-base-changed form, with the chart `V` and inclusion `e` instantiated to the same `Classical.choose` projections that the body's `let`-bindings use.
- **Cascading:** None.

- **What:** Refreshed three docstring blocks:
  - Lines 32–48: "Status" — replaced "iter-130 fix-up: body replaced with chart-base-change Replacement (B)" with "iter-131 fix-up: pure-term body refactor" and expanded the body of the Status block to explain the `Classical.choice` wrapper removal.
  - Lines 118–148: "Caveat on canonicity" — dropped the misleading "not canonical in the strictest sense" framing; new wording distinguishes "non-canonical *as a value*" (chart `V` is `Classical.choose`-extracted) from "structural shape *is exposed*" (the outer head symbol after `unfold` + delta-reduction). References `cotangentSpaceAtIdentity_eq_extendScalars` as the formal proof of structural exposure.
  - Closing paragraph (~lines 144–148) updated to point at iter-132+ rank lemma and at the new acceptance-test theorem.
- **Why:** Per directive — docstring staleness across iter boundaries.
- **Cascading:** None.

### File: `AlgebraicJacobian/Jacobian.lean`

- **What:** Updated docstring at the original L194–200 (now L194–202) for `nonempty_jacobianWitness`: changed "the single remaining mathematical sorry of the Phase-C Jacobian scaffolding" → "one of the two open mathematical sorries of the Phase-C Jacobian scaffolding (the other being `genusZeroWitness`); both are scheduled for body closure post M2 + M3 per STRATEGY.md."
- **What:** Updated docstring at the original L222–230 for `Jacobian` def: changed "the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding" → "one of the two open mathematical sorries of the Phase-C scaffolding (the other being `genusZeroWitness`), both scheduled for body closure post M2 + M3 per STRATEGY.md."
- **Why:** Per directive (lean-auditor-review130 major findings #2 + #3) — file actually carries TWO sorries (`genusZeroWitness` and `nonempty_jacobianWitness`), the docstrings were stale.
- **Cascading:** None; pure docstring touch-up.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: compiles clean (no errors, no warnings).
- `AlgebraicJacobian/Jacobian.lean`: compiles with pre-existing warnings only (the two `declaration uses sorry` for `genusZeroWitness` + `nonempty_jacobianWitness`, plus a pre-existing long-line warning on the protected `Jacobian` def signature at L234 — not introduced by this refactor).
- `lake build` end-to-end: **passes** (8330 jobs).
- Sorry count across the project: **3 unchanged** — `Jacobian.lean:192` (`genusZeroWitness` body), `Jacobian.lean:213` (`nonempty_jacobianWitness` body), `RigidityKbar.lean:87` (`rigidity_over_kbar` body).

## Axiom Verification
- `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` → `{propext, Classical.choice, Quot.sound}` (kernel-only; no `sorryAx`, no project axioms).
- `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars` → `{propext, Classical.choice, Quot.sound}` (kernel-only).
- The "opaque" pattern warnings (lines 47, 50, 192) are from the docstrings (`*opaque*` appearing as a word in prose), not actual `opaque` declarations.

## Acceptance Test Result
The **strong** form of `cotangentSpaceAtIdentity_eq_extendScalars` closes — the `refine … rfl⟩` invocation succeeds, confirming that `cotangentSpaceAtIdentity (n := n) G` is definitionally equal to the explicit `(ModuleCat.extendScalars (ηleft.appLE V ⊤ htop ≫ ΓSpecIso _).hom).obj (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])` form, modulo `let`-binding delta-reduction. The `htop` component proof had one wrinkle: `rw [Scheme.Hom.mem_preimage]` did not fire on the goal `s ∈ ηleft ⁻¹ᵁ V` in the acceptance-lemma's tactic context (the lemma's pattern expects `Scheme.Opens` but the goal had `Opens ↥(Spec …)`, despite their definitional equality through the `abbrev`). Worked around with a single `change (ConcreteCategory.hom ηleft.base) s ∈ h.choose_spec.choose`, then `rw [show s = default ...]; exact hxV`. The downstream `rfl` is unaffected.

## Notes for Plan Agent

1. **Strong acceptance lemma succeeded.** No fallback needed; the iter-131 `Classical.choose`-chain body shape **does** solve the opacity defect, as predicted by `analogies/cotangent-body-shape.md`. The iter-132+ rank-lemma prover lane can `obtain ⟨_, _, _, _, hfree, hrank⟩ := h.choose_spec.choose_spec.choose_spec.2.2.2` (or similar — see signature of `smooth_locally_free_omega` in `Differentials.lean:124`) on the *same* `h := smooth_locally_free_omega …` and then use `cotangentSpaceAtIdentity_eq_extendScalars` to rewrite the goal to `Module.finrank k ((extendScalars _).obj (ModuleCat.of _ Ω[…]))`, then apply `Module.finrank_baseChange`.

2. **`Scheme.Hom.mem_preimage` rewrite quirk.** Inside the acceptance lemma's tactic context, `rw [Scheme.Hom.mem_preimage]` failed to fire on a goal that should have matched it (the goal had `Opens ↥(Spec ...)` while the lemma pattern wanted `Scheme.Opens ?m`; both unfold to the same type via the `Scheme.Opens X := TopologicalSpace.Opens X` abbrev, but `rw` is syntactic at the relevant level). The `change` workaround is fine and inexpensive. Worth noting for future similar refactors; could potentially be a Mathlib issue (the lemma's implicit `f` argument may be the culprit) but out of scope here.

3. **The "opaque" pattern false positives** in the `lean_verify` output (lines 47, 50, 192) are from the word "opaque" appearing in docstrings, not from actual `opaque` declarations. Already cross-checked.

4. **Long-line warning at `Jacobian.lean:234`** is on the protected `Jacobian` def signature (`noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]`). Pre-existing; the refactor agent's write-domain disallows touching the protected signature. Plan agent may want to flag this to the mathematician (one option: rebreak the line at the second `[…]` instance binder).

5. **`Cotangent/GrpObj.lean` line 47 stale reference.** The closing paragraph of the iter-130 docstring refresh I did not update mentions "iter-129+ companion rank lemma" at line 87. Now my edit at line 144–148 says "iter-132+ rank lemma `cotangentSpaceAtIdentity_finrank_eq`". The mid-docstring at line 87 still says "iter-129+ companion rank lemma" — that's a pre-existing minor staleness in a section I was not asked to update; flagging here rather than expanding the directive's scope. Plan agent may want to bring it forward to "iter-132+" for consistency in a future iter.

6. **Future cleanup opportunity (out-of-scope this iter, per directive):** `smooth_locally_free_omega` in `Differentials.lean` could be refactored to return a `Σ'`-bundle (`noncomputable def smooth_locally_free_omega' : Σ' (U : S.Opens) …` via `Classical.choice` of nonemptiness of the `Σ'`). This would let `cotangentSpaceAtIdentity` destructure with `let ⟨U, V, e, …⟩ := smooth_locally_free_omega' …` instead of the 4-step `Classical.choose` chain, and would also be reusable by future chart-extracting consumers (e.g., piece (i.b) in iter-133+). Directive explicitly out-of-scopes this for iter-131.
