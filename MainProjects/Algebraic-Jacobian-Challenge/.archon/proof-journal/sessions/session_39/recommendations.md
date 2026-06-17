# Recommendations for the next plan-agent iteration (iter-040)

## Tracks

### Track 1A (recommended primary — iter-040 prover lane): affine-vanishing carrier predicate (multi-iteration assembly)

**Target**: a carrier predicate `Scheme.IsAffineCohomologyVanishing` (or an equivalent name) capturing `H^{>0}(Spec A, F) = 0` for any sheaf-of-modules `F` evaluated on an affine open.

**With iter-037's corner-bridge `Module.Finite` transport, iter-038's abstract H⁰ `Module.Finite` transport, AND iter-039's H⁰ curve `Module.Finite` transports now all in scope, affine-vanishing remains the *only* remaining algebraic obstruction** to the `Module.Finite k (HModule k (toModuleKSheaf C) n)` instance for proper geometrically integral $k$-curves.

**Mathlib re-probe done this iter-039 plan-agent pass — confirmed still absent**:

- `Mathlib/AlgebraicGeometry/Cohomology/` directory does not exist;
- only `subsingleton_H_of_isZero` (`Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` L74) is available — trivial;
- `IsAffineOpen.cohomology_zero_of_pos`, `Scheme.cohomology_isAffineOpen`, `IsAffineOpen.HModule_eq_zero` all absent.

**Multi-iteration assembly is therefore required** (recommendation re-issued from iter-036 / iter-037 / iter-038, now with confirmed Mathlib state):

1. **iter-040**: introduce a carrier predicate `Scheme.IsAffineCohomologyVanishing` (or similar). Probably ~10–20 LOC, single-iteration close, no proofs.
2. **iter-041**: prove the `IsAffineOpen → IsAffineCohomologyVanishing` instance. Likely the heaviest of the three iterations — needs Čech-vs-derived comparison or a direct Serre-vanishing argument. Plausibly multi-iteration on its own if Mathlib pieces don't compose.
3. **iter-042**: consume via the LES — produce `HModule'_eq_zero_of_isAffineOpen` (the actual finiteness input) by pairing iter-041 with iter-038/039's transport ladder.

**Probe-confirmation gate** (continued cohort discipline): as established across iter-031 → iter-039, do **not** assign the prover lane until the plan-agent's `lean_run_code` probe returns `{success: true, diagnostics: []}` end-to-end on the proposed body. Probe-confirmation has been the dominant predictor of zero-corrective-Edit landings (4 of 5 iterations zero-corrective-Edit across iter-035 → iter-039).

**Highest priority — gates Step 4** (the last unproved input to the Serre-finiteness `Module.Finite k (HModule k F n)` instance for `F = toModuleKSheaf C` on a proper $k$-curve).

### Track 1B (recommended alternative — iter-040 prover lane): sharper Mayer–Vietoris LES consumer (single-iteration close)

**Target**: a single-step LES consumer combining

- iter-029's `HModule'_sequence_curve_exact` (exactness in the LES on `HModule'`),
- iter-035's `HModule'_X₄_linearEquiv_curve` (corner-bridge for `X₄`),
- iter-036's `finrank_HModule_eq_HModule'_X₄_curve` (finrank corollary of the corner-bridge),
- iter-037's `module_finite_HModule_of_HModule'_X₄_curve` (corner-bridge `Module.Finite` transport),
- iter-038's `module_finite_HModule_zero` (abstract H⁰ `Module.Finite` transport),
- **iter-039's `module_finite_HModule_zero_curve` and `module_finite_HModule'_zero_curve`** (curve-form H⁰ transports),

into a four-term LES directly on `HModule k F (n+1)` for the curve case:

```
HModule' k F n X₁ ⊕ HModule' k F n X₂ → HModule' k F n X₃ → HModule k F (n+1)
```

Plausibly a single-iteration ~20–40 LOC declaration (`Scheme.AffineCoverMVSquare.HModule_LES_curve` or similar). With iter-039's H⁰ curve transports now available, this consumer chains directly into degree-0 `Module.Finite` results without needing affine-vanishing as a prerequisite — simplifying the downstream Serre-finiteness assembly.

**Equal priority with Track 1A**: this is forward investment that does NOT require affine-vanishing to land. **The iter-040 plan-agent should pick Track 1A or Track 1B based on which has a tighter probe-confirmation circle**. Track 1B is plausibly the cleaner single-iteration close; Track 1A is more strategically valuable but requires multi-iteration assembly.

### Track 2 (parallel low-coupling): none recommended

Polish backlog remains empty. The protected sorries in `Jacobian.lean` and `AbelJacobi.lean` are all blocked on Phase C step 4 / Phase A step 6 chain completion plus a `noncomputable` user-decision; do not attempt them prematurely.

### Hard avoid

- `representable` — closing on the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor.
- The 5 `Jacobian.lean` protected sorries — Phase C step 4 (FGA representability) plus `noncomputable` user-decision.
- The 3 `AbelJacobi.lean` protected sorries — structurally downstream of `Jacobian C` plus `noncomputable` user-decision on `ofCurve`.
- Closed scaffold sites in `Cohomology/MayerVietoris.lean` (iter-016 → iter-026, iter-028 → iter-037) and in `Cohomology/StructureSheafModuleK.lean` (iter-006, iter-009, iter-010, iter-011, iter-012, iter-014, iter-015, iter-026, iter-038, iter-039) — do not retry; they are already closed.
- Re-introducing the `Scheme.` short-name prefix inside `namespace AlgebraicGeometry.Scheme` — known-dead-end #185, surfaced by iter-038, internalised by iter-039.

## `blueprint/lean_decls` maintenance (recurring drift, sixth consecutive flag)

The iter-038 declarations (`module_finite_HModule_zero` + `module_finite_HModule'_zero`) were cleared by the iter-039 plan-agent (now at L23–24). **However, the iter-039 declarations themselves were not appended this pass**:

- `AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve`
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero_curve`

The iter-040 plan-agent should clear these alongside introducing the new objectives. **Same drift pattern across iter-035 → iter-036 → iter-037 → iter-038 → iter-039 → now iter-040 (six consecutive iterations of clear-on-arrival rather than clear-as-you-go).** Recommendation: **strongly suggest** updating the plan-agent prompt template to make appending the previous iteration's declarations to `blueprint/lean_decls` an explicit pre-prover-task step, not an afterthought. **This recommendation has now been issued 5 times consecutively without uptake — escalate to a hook or template change rather than yet another recommendation note.** Non-blocking — chapter file complete with all `\leanok` markers verified accurate.

## Reusable proof patterns discovered or re-confirmed this iteration

- **`_curve` form via dot-notation method-call `Scheme.foo k _ ...`** *(iter-039, mirrors iter-030 / iter-035 / iter-036 / iter-037)*: when an abstract declaration `Scheme.foo` lives in `namespace AlgebraicGeometry.Scheme` and takes the sheaf `F` and Grothendieck topology `J` implicitly (or via inferable hypotheses), its curve specialisation to `F := Scheme.toModuleKSheaf C` is a one-line term-mode body `Scheme.foo k _` (or `Scheme.foo k _ X` if there's an extra explicit argument). Topology auto-resolved via iter-005 `instHasSheafify_Opens_ModuleCatK` / `instHasExt_Sheaf_Opens_ModuleCatK`. **Reusable for any future `Module.Finite k (Scheme.HModule k F n)` curve specialisation.**
- **Pattern: pair `_abstract` + `_curve` in adjacent iterations** *(iter-035 → iter-039)*: every project transport that's going to be consumed in the curve setting should land its `_curve` companion within the same iteration window as the abstract form. iter-038 → iter-039 paired the H⁰ ladder cleanly; iter-035 → iter-037 was a three-iteration cohort for the corner-bridge ladder.
- **Pattern: `_curve` body as a wrapper around `_abstract`'s underlying Mathlib API call** *(iter-039, new this iteration)*: the `_curve` body does **not** invoke the underlying Mathlib API directly — it invokes the abstract project declaration, which in turn invokes the Mathlib API. This compositional structure means kernel axioms are inherited from the abstract form (no new dependencies), and the curve form inherits all upstream guarantees automatically. **Forward implication**: future affine-vanishing / cohomology-vanishing curve forms should follow the same wrapper pattern — abstract carries the math, curve form is a one-liner.
- **PROGRESS.md known-dead-end #185 internalised** *(iter-039 zero-corrective-Edit confirmation of iter-038's fix)*: when emitting verbatim bodies for declarations inside `namespace AlgebraicGeometry.Scheme`, write the short name **without** the redundant `Scheme.` prefix. iter-038's prover surfaced this with two corrective Edits; iter-039's plan-agent text already corrected, leading to a zero-corrective-Edit landing. **Plan-agent action: continue this pattern — emit verbatim bodies for declarations inside `namespace AlgebraicGeometry.Scheme` without the redundant `Scheme.` prefix.** This recommendation is now empirically validated.

## Mathlib gating watch

- **Affine-vanishing API**: re-probe done this iter-039 plan-agent pass — confirmed still absent. **Multi-iteration assembly required for Track 1A.** No further re-probe needed until iter-041 (the heavy step).
- **Čech-vs-derived-functor comparison**: re-probe required if the affine-vanishing route doesn't land directly via the carrier-predicate path. Mathlib has both flavors of cohomology and the comparison theorem may be the easier consumer.
- **Off-Archon Mathlib upstream PR for `Abelian.Ext.chgUnivLinearEquiv` (iter-034 deliverable)**: remains a clean candidate. The body uses only Mathlib API and the gap is well-defined.

## Approach-selection guidance for the iter-040 plan-agent

1. **First action**: decide between Track 1A (affine-vanishing carrier predicate, multi-iteration) and Track 1B (sharper LES consumer, single-iteration). Probe-confirm Track 1B first — if it lands cleanly, take it; if not, fall back to Track 1A's iter-040 carrier-predicate step.
2. **Pre-stage `\leanok` markers** in the chapter as has been the standing practice across iter-032 → iter-039 (and was followed correctly this iteration).
3. **Maintain single-Edit cadence**: iter-039 was a zero-corrective-Edit single-Edit landing (5 of 6 iterations zero-corrective-Edit across iter-035 → iter-039 once we count iter-038's two Edits as a single-cause variation).
4. **PROGRESS.md hygiene**: continue emitting verbatim bodies for declarations inside an existing `namespace AlgebraicGeometry.Scheme` without the redundant top-namespace prefix. iter-039's clean landing validated this.
5. **`blueprint/lean_decls` discipline**: append iter-039's two declarations (`module_finite_HModule_zero_curve`, `module_finite_HModule'_zero_curve`) to `blueprint/lean_decls` at the top of the iter-040 plan-agent run — this is the sixth consecutive iteration of this drift, and the iter-040 plan-agent should clear it before introducing iter-040 work.
