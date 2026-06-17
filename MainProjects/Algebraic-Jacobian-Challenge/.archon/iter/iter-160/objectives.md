# Iter-160 objectives detail

## Lane 1 (DEEP, sole lane): AbelianVarietyRigidity.lean — `rigidity_eqOn_saturated_open_to_affine`

- **Target:** `rigidity_eqOn_saturated_open_to_affine` (L124; body `sorry` at L141) — the lone
  residual `sorry` of the Rigidity-Lemma chain (bridge 2 = slice-constancy / agreement equation).
- **Blueprint:** `chapters/AbelianVarietyRigidity.tex`, `lem:rigidity_eqOn_saturated_open_to_affine`
  (iter-160 block; HARD GATE cleared by `avr-recheck2`). Recipe: `analogies/rigidity-affineconst.md`.
- **Statement (sound, signature-faithful):** for a `p₂`-saturated open `U = (snd X Y)⁻¹(Vset)`,
  affine `U₀ ⊆ Z`, with `f(U) ⊆ U₀` and `[IsAlgClosed kbar]`, `X` proper, `(X⊗Y)` geom-irreducible
  + reduced, `Z` separated: `f` and the collapse map `retract ≫ f` (`(x,y)↦(x₀,y)`) agree on `U`.
- **Route B (cohomology-free), two steps:**
  1. Per-closed-slice constancy: `κ(y)=k̄`; slice `X_y ≅ X` proper integral → `Γ(X_y)=k̄`
     (`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closed) →
     single `k̄`-point of `U₀` (`ext_of_isAffine`) = `f(x₀,y)`.
  2. Globalise: closed points dense in finite-type `U` (`closure_closedPoints`/Jacobson); dense-range
     probe → `ext_of_isDominant_of_isSeparated'` → equality on all of `U`.
- **Off-limits:** relative Stein / `f_*O=O` (confirmed Mathlib gap); the 3 deferred scaffolds
  (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`);
  the already-closed chain lemmas.
- **Acceptable outcomes:** full close, OR PARTIAL with a new TRUE-as-stated named sub-lemma (Step 1
  or Step 2) landed as a clean top-level `sorry`-bearing decl with a precise docstring (NOT buried).

## Deferred (not lanes this iter)

- `Cotangent/GrpObj.lean` — 2 stale docstrings (iter-159 lean-auditor), cosmetic, 0 live sorries.
- Theorem of the cube + genus-0⟹ℙ¹ (Riemann–Roch) — multi-iter sub-builds, blueprinted as deferred.
- `Jacobian.lean` / `RigidityKbar.lean` — downstream/off-path, gated.

## Dispatch summary (this plan phase)

- progress-critic `avr-trajectory` → CONVERGING (proceed).
- blueprint-writer `avr-helper` → COMPLETE (helper block + uses + remark).
- blueprint-reviewer `avr-recheck` → PARTIAL (backward 2-cycle must-fix).
- blueprint-writer `avr-uses-fix` → COMPLETE (forward acyclic edges).
- blueprint-reviewer `avr-recheck2` → HARD GATE CLEARS.
- strategy-critic → skipped (STRATEGY.md unchanged; no live challenge).
