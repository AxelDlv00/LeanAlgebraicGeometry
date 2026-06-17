# Recommendations for the next plan-agent iteration (iter-047)

## Major milestone closed iter-046

**The producer chain for `IsHModuleHomFinite k C (toModuleKSheaf C)` is now complete end-to-end.** Iter-046 landed eight new declarations (5 Mathlib gap-fills in a new `namespace CategoryTheory` block + 3 project-local applied bridges + the producer instance in `namespace AlgebraicGeometry.Scheme`) closing steps (1)+(3)+(4) of the iter-044 four-step producer-instance plan. Combined with iter-045's step (2) (`SheafGammaObj_linearEquiv_top` + `module_finite_gammaObj_of_isProper`) and iter-044's step (1) algebraic input (`module_finite_globalSections_of_isProper`), this completes the full producer chain.

**Immediate downstream consequence**: iter-043's curve consumer `module_finite_HModule_zero_of_isHModuleHomFinite_curve` fires automatically on `Module.Finite k (HModule k (toModuleKSheaf C) 0)` queries — closing the **H⁰ side** of the genus-finrank `Module.Finite` ladder for proper integral `Spec k`-schemes (and in particular for the smooth proper geometrically irreducible curves consumed by `smoothOfRelativeDimension_genus`).

## Highest-priority track for iter-047

### Track 2A (recommended primary, iter-047 prover lane): `IsAffineHModuleVanishing k C (toModuleKSheaf C)` producer

**Step 4.6 of the genus-Module.Finite ladder.** The parallel producer instance for the H${}^{>0}$ affine-vanishing carrier predicate (iter-040). Required for the genus carrier (`HModule k (toModuleKSheaf C) 1` finiteness, queued iter-048+). **Genuinely substantive remaining step in Phase A** — Mathlib still does not contain scheme-level Serre affine vanishing per the iter-039/040/041/042/043/044/045/046 re-probe history.

**Plausible iter-047 outcomes**:
- **Single-iteration close (~50–80 LOC)** if a Mathlib piece directly produces the affine vanishing for `ModuleCat k`-valued sheaves (probably via affine cohomology = Čech cohomology = sheafified Čech complex on a covering by `1` → vanish in positive degrees).
- **2-iteration close (~80–150 LOC)** if project-local Čech-vs-derived comparison plus affine Čech vanishing pieces are needed.
- **3+-iteration close (~150+ LOC)** if direct construction with manual derived-functor unfolding is required.

**Mathlib probe mandate for iter-047 plan-agent**:
1. `Sheaf.cohomology_affine` / `IsAffine` + `Sheaf.HasZero.cohomology_pos_iff` / similar named theorems for affine vanishing.
2. `CechCohomology` / `Cech.complex` API for the Čech side of the comparison.
3. `affine_isAffine_iff_Sheaf_acyclic` or any "affine ⇔ all higher sheaf cohomology vanishes" Mathlib statement.
4. Scheme-level `IsAffine` + `Module` enrichment vanishing — check both `AlgebraicGeometry.IsAffine` and the Stein-flavoured `affineCover` developments.

### Track 2B (recommended alternative, iter-047 prover lane): finrank corollary of iter-046 producer

A `Module.finrank`-flavoured restatement of the producer-instance conclusion: a `theorem` form giving `Module.finrank k (HModule k (toModuleKSheaf C) 0) = ...` (exact RHS depends on iter-045's `module_finite_gammaObj_of_isProper` finrank chasing). Useful as a one-iteration verification that the H⁰ producer chain composes correctly at the finrank level. Plausibly single-iteration ~30–50 LOC.

**Equal priority with Track 2A** — pick based on which has the tighter probe-confirmation circle. **Track 2B is a low-risk warm-up**; Track 2A is the next genuinely substantive step.

### Track 2C (alternative, iter-047 prover lane): sharper Mayer–Vietoris LES consumer

Combine iter-029 LES + iter-035 → iter-039 transports + iter-040 + iter-041 + iter-042 + iter-043 consumers + iter-044 Stein input + iter-045 LinearEquiv + iter-046 producer instance into a four-term LES on `HModule k F (n+1)` for the curve case. Plausibly single-iteration ~30–50 LOC.

### Track 2D (low-priority): Mathlib upstream PRs

The five new `CategoryTheory.*` declarations from iter-046 (`Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv`) are pure Mathlib gap-fills with kernel-only axioms and no project-specific dependencies. **Recommendation for off-Archon side track**: open Mathlib upstream PRs to merge these into `Mathlib/CategoryTheory/Adjunction/Additive.lean` (or a sibling `Linear.lean`). Once merged, the project-local block can be deleted.

## Probe `include`-syntax parity check (iter-046 retro recommendation for iter-047 plan-agent)

The iter-046 plan-agent's `lean_run_code` probe scaffold appears to have used the `include adj in <decl>` per-declaration syntax (which compiled in the probe environment) but the local Lean toolchain rejected it at the prover's first Edit (parser error `unexpected token 'include'; expected 'lemma'`). The iter-046 prover fixed this with one cosmetic corrective Edit by switching to the section-style `include adj` standalone line, mirroring Mathlib's `CategoryTheory/Adjunction/Additive.lean` L36.

**Recommendation for iter-047 plan-agent**: future probes that feature the `include` keyword should test the exact section-style or per-declaration form to be used in the prover body, or default to the section-style form (standalone line before the declaration block) to avoid this class of cosmetic corrective. The bug class is similar to iter-044's `op` vs `Opposite.op` qualification mismatch: probe environment slightly diverges from the target file's parsing context.

## Continuing-discipline reinforcements (iter-040 → iter-046)

- **`blueprint/lean_decls` clear-as-you-go discipline holds for the seventh iteration in a row** (iter-040 + iter-041 + iter-042 + iter-043 + iter-044 + iter-045 + iter-046). The iter-046 plan-agent appended 8 new entries (L40–L47), bringing the total to 106 entries. Continue this discipline — `blueprint/lean_decls` is now fully current through iter-046.
- **Pre-marking blueprint `\leanok` markers from the plan-agent side, with review-side validation** holds for the second iteration in a row (iter-045 pre-marked 4 markers, iter-046 pre-marked 12 markers). Reduces review-agent surface area to validation only. Continue.
- **Verbatim probe-confirmed body landing** holds: 9 of 12 iterations (iter-035 → iter-046) zero-corrective-Edit, 1 with cosmetic corrective (iter-044), 1 with cosmetic corrective (iter-046). The pattern continues to deliver clean, atomic Edits.
- **`archon-protected.yaml` untouched** for the seventh iteration in a row. Continue.

## Targets blocked — do NOT assign in iter-047

- All 8 protected sorries (5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`) — gated on Phase C step 4 (FGA representability), `LineBundle` Mathlib refinement, and `noncomputable` user-decisions. **Plan-agent should NOT assign these.**
- `PicardFunctor.representable` — intentionally deferred. **Plan-agent should NOT assign.**
- All closed scaffold sites in `Cohomology/MayerVietoris.lean` and `Cohomology/StructureSheafModuleK.lean` (iter-006 through iter-046).

## Reusable proof patterns from iter-046 (for iter-047+ planning)

1. **Section-style `include adj`** for `Adjunction`-parameterised lemma cohorts in a `namespace` block. Mirrors Mathlib pattern.
2. **Five-`haveI` typeclass scaffolding** for composed-functor `Linear`/`Additive` propagation when the composed functor is definitionally a composition (use `unfold; infer_instance` for the intermediate step).
3. **Anonymous-constructor `LinearEquiv` from `AddEquiv`** with `change` + `simp [adj.homEquiv_unit]`, with a load-bearing `haveI : F.Linear R := adj.left_adjoint_linear R`.
4. **Producer-instance assembly via `Module.Finite.equiv (LE1.trans LE2).symm` chain** — `let`-bound `LinearEquiv`s with `haveI` for the upstream finiteness source.
5. **Multi-block packaged Edit** (8 declarations across 2 blocks in 3 Edits) handled cleanly with one cosmetic corrective — confirms the multi-declaration packaging pattern scales beyond the iter-038 → iter-045 two-declaration version.

## Summary

Iter-046 closed the **producer chain** for `IsHModuleHomFinite k C (toModuleKSheaf C)` end-to-end. Combined with iter-043's curve consumer, the **H⁰ Module.Finite ladder** is now closed for proper integral `Spec k`-schemes. **Iter-047 should attack Step 4.6 (Track 2A — `IsAffineHModuleVanishing` producer)** as the next genuinely substantive step in Phase A, with Track 2B (finrank corollary) as the low-risk warm-up alternative.
