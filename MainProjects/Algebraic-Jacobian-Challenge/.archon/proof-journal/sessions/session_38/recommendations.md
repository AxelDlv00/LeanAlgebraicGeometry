# Recommendations for the next plan-agent iteration (iter-039)

## Tracks

### Track 1 (recommended primary — iter-039 prover lane): affine-vanishing input

**Target**: `Scheme.HModule'_zero_of_isAffineOpen` — the Step 4 input asserting `H^{>0}(Spec A, F) = 0` for any quasi-coherent (or `ModuleCat k`-valued) sheaf `F` evaluated on an affine open.

**With iter-037's corner-bridge `Module.Finite` transport AND iter-038's H⁰ `Module.Finite` transport now both in scope, affine-vanishing is the *only* remaining algebraic obstruction** to the `Module.Finite k (HModule k (toModuleKSheaf C) n)` instance for proper geometrically integral $k$-curves.

**Action items for the iter-039 plan-agent**:

1. **Re-probe Mathlib** for the current state of affine-vanishing API. This recommendation has been carried forward unchanged across iter-036 → iter-037 → iter-038 — *re-probe was last done at iter-028 (~ a year of accumulated Mathlib drift)*. Probe candidates (in order of search priority):
   - `Mathlib/AlgebraicGeometry/Cohomology/Affine.lean` (existence and content).
   - `IsAffineOpen.cohomology_zero_of_pos`, `Scheme.cohomology_isAffineOpen`, `IsAffineOpen.HModule_eq_zero`, or similar names.
   - The `QuasiCoherent` ↔ `ModuleCat`-flavored affine vanishing comparison.
   - Cech-vs-derived-functor comparison route (alternate path if `IsAffineOpen.HModule_eq_zero` style is not bundled).
2. **If Mathlib bundles it directly**: a single-iteration prover lane (~30–60 LOC term-mode wrapper plus a curve specialisation `HModule'_zero_of_isAffineOpen_curve` mirroring iter-030 / iter-035 / iter-036 / iter-037 / iter-038 dot-notation patterns).
3. **If Mathlib has it as a TODO or only at the `QuasiCoherent` flavor**: plan a 2–4 iteration assembly — first an iter-039 carrier predicate / `Scheme.IsAffineCohomologyVanishing` (or similar), then iter-040 the `IsAffineOpen → IsAffineCohomologyVanishing` instance, then iter-041 the `HModule'`-side specialisation, then iter-042 the curve form.

**Probe-confirmation gate** (continued cohort discipline): as established across iter-031 → iter-038, do **not** assign the prover lane until the plan-agent's `lean_run_code` probe returns `{success: true, diagnostics: []}` end-to-end on the proposed body. Probe-confirmation has been the dominant predictor of zero-corrective-Edit landings.

**Highest priority — gates Step 4** (the last unproved input to the Serre-finiteness `Module.Finite k (HModule k F n)` instance for `F = toModuleKSheaf C` on a proper $k$-curve, given iter-037 and iter-038's transports).

### Track 1 alternative (lighter, exploratory): sharper Mayer–Vietoris LES consumer

**Target**: a single-step LES consumer combining

- iter-029's `HModule'_sequence_curve_exact` (exactness in the LES on `HModule'`),
- iter-035's `HModule'_X₄_linearEquiv_curve` (corner-bridge for `X₄`),
- iter-036's `finrank_HModule_eq_HModule'_X₄_curve` (finrank corollary of the corner-bridge),
- iter-037's `module_finite_HModule_of_HModule'_X₄_curve` (corner-bridge `Module.Finite` transport),

into a four-term LES directly on `HModule k F (n+1)` for the curve case:

```
HModule' k F n X₁ ⊕ HModule' k F n X₂ → HModule' k F n X₃ → HModule k F (n+1)
```

Plausibly a single-iteration ~20–40 LOC declaration (`Scheme.AffineCoverMVSquare.HModule_LES_curve` or similar). This is now an even more attractive forward investment: with iter-038's H⁰ transport added, the LES consumer chains directly into degree-0 `Module.Finite` results without going through the corner-bridge, which simplifies the downstream Serre-finiteness assembly.

**Lower priority than Track 1**: this is forward investment, not a path-clear.

### Track 2 (parallel low-coupling): none recommended

Polish backlog remains empty. The protected sorries in `Jacobian.lean` and `AbelJacobi.lean` are all blocked on Phase C step 4 / Phase A step 6 chain completion plus a `noncomputable` user-decision; do not attempt them prematurely.

### Hard avoid

- `representable` — closing on the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor.
- The 5 `Jacobian.lean` protected sorries — Phase C step 4 (FGA representability) plus `noncomputable` user-decision.
- The 3 `AbelJacobi.lean` protected sorries — structurally downstream of `Jacobian C` plus `noncomputable` user-decision on `ofCurve`.
- Closed scaffold sites in `Cohomology/MayerVietoris.lean` (iter-016 → iter-026, iter-028 → iter-037) and in `Cohomology/StructureSheafModuleK.lean` (iter-006, iter-009, iter-010, iter-011, iter-012, iter-014, iter-015, iter-038) — do not retry; they are already closed.

## `blueprint/lean_decls` maintenance (recurring drift, fifth consecutive flag)

The iter-037 declarations (`AffineCoverMVSquare.module_finite_HModule_of_HModule'_X₄` + `..._curve`) were cleared by the iter-038 plan-agent (now at L62–63). **However, the iter-038 declarations themselves were not appended this pass**:

- `AlgebraicGeometry.Scheme.module_finite_HModule_zero`
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero`

The iter-039 plan-agent should clear these alongside introducing the new objectives. **Same drift pattern across iter-035 → iter-036 → iter-037 → iter-038 → now iter-039 (five consecutive iterations of clear-on-arrival rather than clear-as-you-go).** Recommendation: **strongly suggest** updating the plan-agent prompt template to make appending the previous iteration's declarations to `blueprint/lean_decls` an explicit pre-prover-task step, not an afterthought. **This recommendation has now been issued 4 times consecutively without uptake — escalate to a hook or template change rather than yet another recommendation note.** Non-blocking — chapter file complete with all `\leanok` markers verified accurate.

## Reusable proof patterns discovered or re-confirmed this iteration

- **`Module.Finite.equiv` for `Module.Finite` transport along an existing `LinearEquiv` with mismatched orientation, requires `.symm`** *(iter-038, re-confirms iter-037 with the orientation flip)*: when the existing `LinearEquiv` has `Cohomology ≃ₗ[k] Hom` (LHS = conclusion-side, RHS = hypothesis-side), the canonical Mathlib idiom is `Module.Finite.equiv e.symm` — three characters of additional fixed cost over iter-037's matched-orientation case. Reusable for any future `Module.Finite` transport.
- **Pattern: pair finrank + `Module.Finite` corollaries on every `LinearEquiv` bridge** *(iter-035 → iter-038)*: every project `LinearEquiv` bridge that grounds a downstream finiteness argument should be paired with both `e.symm.finrank_eq` (finrank corollary) and `Module.Finite.equiv e.symm` (or `e` if matched) (`Module.Finite` corollary) in the *same iteration that introduces the bridge*. iter-038 retroactively closed the H⁰-bridge cohort (iter-010 + iter-015) at degree 0; iter-035→037 closed the corner-bridge cohort at degree $n$. **Forward recommendation**: any future `LinearEquiv` bridge added (e.g. for affine-vanishing) should land its two corollaries in the introducing iteration, not in a follow-up cohort.
- **PROGRESS.md known-dead-end #185 (dup-namespace short-name prefix)**: the `Scheme.` short-name prefix inside an enclosing `namespace AlgebraicGeometry.Scheme` block trips `linter.dupNamespace`. Iter-038 prover handled this with one corrective Edit per declaration (two total). **Plan-agent action**: when emitting verbatim bodies for declarations inside `namespace AlgebraicGeometry.Scheme`, write the short name **without** the `Scheme.` prefix to maintain the zero-corrective-Edit cadence.

## Mathlib gating watch

- **Affine-vanishing API**: re-probe required (carried forward from iter-036 → iter-037 → iter-038 → iter-039; now the *primary remaining gate* on Phase A step 6).
- **Čech-vs-derived-functor comparison**: re-probe required if the affine-vanishing route doesn't land directly. Mathlib has both flavors of cohomology and the comparison theorem may be the easier consumer.
- **Off-Archon Mathlib upstream PR for `Abelian.Ext.chgUnivLinearEquiv` (iter-034 deliverable)**: remains a clean candidate. The body uses only Mathlib API and the gap is well-defined.

## Approach-selection guidance for the iter-039 plan-agent

1. **First action**: re-probe Mathlib for affine-vanishing API. This is the binary decision that determines whether iter-039 is a single-iteration close or a 2–4 iteration assembly.
2. **If single-iteration close is feasible**: assign to a probe-confirmed prover lane immediately. Pre-stage `\leanok` markers in the chapter as has been the standing practice across iter-032 → iter-038 (and was followed correctly this iteration).
3. **If multi-iteration assembly is needed**: pick a single carrier-side step for iter-039 (e.g. predicate or instance only); defer the consumer step to iter-040+. Maintain the single-Edit-per-iteration cadence that has held across the iter-031 → iter-038 cohort.
4. **PROGRESS.md hygiene**: when emitting verbatim bodies for declarations inside an existing `namespace`, write the short name without the redundant top-namespace prefix (e.g. inside `namespace AlgebraicGeometry.Scheme`, write `theorem foo` not `theorem Scheme.foo`). This recommendation is the iter-038 specific corrective.
