# Refactor directive — chart-algebra skeleton + bundled-route excise, iter-145

## Iteration

145

## Slug

chart-algebra-skeleton-bundled-excise-iter145

## Scope (TWO-PART REFACTOR)

This refactor combines two coordinated structural edits that **must land same-iter** to keep the project sorry inventory honest:

### Part 1 — Excise the bundled-route sorry-bodied scaffolding from `Cotangent/GrpObj.lean`

The iter-144 chart-algebra pivot DESCOPED three sorry-bodied bundled-route declarations from the critical path. The iter-145 strategy-critic (Q7) concluded that the "auditable record" disposition is the iter-141 sunk-cost pattern recurring at the in-tree-disposition level. **Excise these three declarations** (and any helper that becomes orphan post-excise, **but report orphans rather than deleting them** so iter-146+ can decide):

1. **`AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation`** at `AlgebraicJacobian/Cotangent/GrpObj.lean:573` (~90 LOC inclusive of body). The internal d_app sub-sorry at L663 is removed by removing the declaration.

2. **`AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`** at `AlgebraicJacobian/Cotangent/GrpObj.lean:745` (~10 LOC inclusive of body sorry at L751). The iter-143 Wave 2 refactor extraction.

3. **`AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`** at `AlgebraicJacobian/Cotangent/GrpObj.lean:890` (~12 LOC inclusive of body sorry at L901). The iter-135 piece (i.b) Main scaffold.

**Also excise any declaration in `Cotangent/GrpObj.lean` that becomes unused after the above 3 are removed**, but only as a separate explicit listing in your report. Candidate orphans (to be verified by `lake build` warnings or `Grep` for references):

- `relativeDifferentialsPresheaf_basechange_along_proj_two` — consumer of the descoped `basechange_along_proj_two_inv` chain.
- `basechange_along_proj_two_inv` — the inverse-morphism construction whose `IsIso` was extracted to the descoped `_app_isIso`.
- `shearMulRight` + `shearMulRight_hom_fst` + `shearMulRight_hom_snd` (iter-134 piece (i.b) Step 1) — consumer chain `mulRight_globalises_cotangent`.
- `schemeHomRingCompatibility` (iter-135 packaging helper for the descoped chain).
- `relativeDifferentialsPresheaf_restrict_along_identity_section` (iter-136 piece (i.b) Step 3) — purely consumed by descoped Main.

**Important**: do NOT delete the iter-128/iter-131/iter-132 piece (i.a) trio:
- `cotangentSpaceAtIdentity` (the definition — piece (i.a) DONE iter-128–iter-131)
- `cotangentSpaceAtIdentity_eq_extendScalars` (the structural-shape acceptance lemma — iter-131)
- `cotangentSpaceAtIdentity_finrank_eq` (the rank lemma — iter-132)

These remain in `Cotangent/GrpObj.lean` regardless of the excise; they are sorry-free Lean closure outputs and are independently useful even if the chart-algebra pivot makes downstream piece (i.c) `omega_free` etc. unconsumed.

**Method**: run `lake build` after each chunk excise; if it errors due to a downstream consumer, identify the consumer and either (a) chase it up the dependency tree to the next non-target declaration (and decide whether to excise it too as orphan), or (b) leave the consumer alone and roll back the excise that broke it (rarely needed — the descoped declarations are leaves under the chart-algebra pivot).

**Surface in your report**: the full list of declarations deleted, and the list of declarations identified as orphans-not-yet-deleted (with `Grep`-cross-reference verification that they have zero remaining consumers in the project's Lean tree).

### Part 2 — Create the chart-algebra skeleton file `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Create a NEW file `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (and add the corresponding `import` to `AlgebraicJacobian.lean`) containing FIVE top-level named sorry-bodied declarations matching the iter-145 blueprint-writer's `\lean{...}` hints. Use the following pre-committed names (the blueprint-writer-rigiditykbar-iter145 dispatch is committing identical names this iter; if there's any name mismatch when you can read the writer's report, surface it but commit YOUR names — iter-146 fix-up is trivial).

```lean
/- AlgebraicJacobian/Cotangent/ChartAlgebra.lean — iter-145 chart-algebra skeleton.

This file scaffolds the five sub-pieces of the iter-144 chart-algebra
pivot route for piece (ii) of the M2.body-pile (per STRATEGY.md
§ "Iter-144 chart-algebra pivot — COMMITTED" + RigidityKbar.tex
§ "Iter-144 chart-algebra envelope for piece (ii)"). Each declaration
is sorry-bodied; the iter-146+ prover lane closes them in turn.

Skeleton authoring is intentionally minimal:
- Signature shape per blueprint sketch (will be refined by the prover).
- Universe parameters as needed (use `Type _` placeholders where appropriate;
  the prover concretises).
- DO NOT attempt body closure here.
- Each declaration must have a `theorem` / `lemma` head matching its role.

For the informal mathematical content + closure-path documentation, see
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition" (or however the iter-145 writer titles it).
-/

import AlgebraicJacobian.Cotangent.GrpObj
import Mathlib.RingTheory.IsPushout
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.Algebra.CharP.Frobenius

-- The 5 sub-pieces. Signatures are placeholder-shaped; the iter-146+
-- prover refines them against the blueprint sketches.

namespace AlgebraicGeometry

namespace GrpObj

/-- Chart-algebra (α): the affine pullback `Spec R ×_k Spec S = Spec (R ⊗_k S)`
    is the canonical `Algebra.IsPushout` square at the ring level. Iter-145
    chart-algebra skeleton; body iter-146+. -/
theorem algebra_isPushout_of_affine_product : True := sorry

/-- Chart-algebra (β-core): per-chart translation-invariance Kähler-derivation.
    If `f^# : Γ(W, O_A) → Γ(V, O_C)` is the chart-affine ring map and the
    chart-Kähler-derivation difference `d(f^# φ) - f^# d(φ)` vanishes as a
    derivation, then `f^# φ ∈ range (algebraMap k Γ(V, O_C))`. Iter-145
    chart-algebra skeleton; body iter-146+. -/
theorem df_zero_factors_through_constant_on_chart : True := sorry

end GrpObj

/-- Algebra-level core: for a base field `A`, if `b : B` satisfies `D b = 0`
    in `Ω_{B/A}`, then `b ∈ range (algebraMap A B)` — constants are exactly
    the kernel of the universal derivation. Iter-145 chart-algebra skeleton;
    body iter-146+. Project-namespaced until upstreamed. -/
theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry

/-- Integrally-closed-constants helper: in a smooth proper geometrically
    irreducible scheme `X` over a base field `k`, the global sections
    `Γ(X, O_X) = k` (i.e. constants are exactly the base field). Iter-145
    chart-algebra skeleton; body iter-146+. -/
theorem constants_integral_over_base_field : True := sorry

namespace Scheme

namespace Over

/-- Scheme-level lift: if `f, g : C → A` over `Spec k` satisfy `df = dg`
    and agree on a chart, then `f = g`. Packages the chart-algebra chain
    in `Scheme.Over.ext_of_eqOnOpen`-shape. Iter-145 chart-algebra skeleton;
    body iter-146+. -/
theorem ext_of_diff_zero : True := sorry

end Over

end Scheme

end AlgebraicGeometry
```

**Signature shape NOTE**: the `: True := sorry` placeholders are intentional. Real signatures will need universe parameters, instance arguments (`[Field k]`, `[SmoothOfRelativeDimension n C.hom]`, etc.), and the actual proposition statements. The iter-146+ prover lane refines these against the blueprint sketches. The iter-145 skeleton's purpose is to provide named declarations to anchor the iter-146+ work; signature placeholder is **safer than committing wrong signatures** (the iter-128–iter-131 cotangent body-shape refactors are the cautionary tale).

If you find a clean way to write the actual sketched signatures, prefer that; otherwise keep the `: True := sorry` placeholder and let the prover land the real signature. Add a `/- TODO iter-146: real signature; placeholder is `: True` -/` comment on each.

Also add the import `import AlgebraicJacobian.Cotangent.ChartAlgebra` to `AlgebraicJacobian.lean` (the umbrella module file at the repo root).

## Boundaries

- Excise only the THREE explicitly-named sorry-bodied declarations from `Cotangent/GrpObj.lean`. Helpers that become orphan are **reported, not auto-deleted**.
- Do NOT touch piece (i.a) trio (`cotangentSpaceAtIdentity*`).
- Do NOT touch other `.lean` files except for the `import` addition to `AlgebraicJacobian.lean`.
- Do NOT touch any blueprint chapter (blueprint-writer's domain).
- Do NOT touch `STRATEGY.md` (planner's domain).
- Do NOT touch `archon-protected.yaml` (no signature renames; the excised declarations are NOT protected).
- Do NOT close any sorry yourself; the new file is sorry-bodied by design.
- Build the project with `lake build` after the edits and report the build status.

## Output

Refactor's report at `task_results/refactor-chart-algebra-skeleton-bundled-excise-iter145.md`. Include:
- The list of declarations deleted from `Cotangent/GrpObj.lean` (3 named + any helpers if helped along).
- The list of orphan helpers identified but **not** deleted (with one-line "consumed by [none] post-excise" rationale).
- The new file's content as authored.
- `lake build` final status (clean / warnings / errors).
- Sorry count delta: before vs after (per file + project total).
- Any compile-error or warning that the iter-145 planner should know about.

## Why this dispatch fires iter-145

- Per the iter-145 progress-critic: iter-145 (or iter-146) MUST produce at minimum a skeleton of the chart-algebra file to avoid a 2-consecutive-plan-only-iter signature on Route 2 (which would start the meta-pattern clock).
- Per the iter-145 strategy-critic Q7: ~600 LOC of bundled-route sorry-bodied scaffolding kept as "auditable record" is the iter-141 sunk-cost pattern recurring; deletion is the disciplined call.
- The two parts (excise + scaffold) must land same-iter to keep project sorry inventory honest: excise alone would drop sorry count to 3 (under target); scaffold alone would inflate sorry count to 11 without the bundled descope materially landing.

After this refactor lands, project sorry inventory becomes: 5 (new ChartAlgebra.lean) + 2 (Jacobian.lean genus-arm scaffolds) + 1 (RigidityKbar.lean rigidity_over_kbar) = **8 declarations using sorry / 8 inline sorries**. This is up from iter-144 close 6/6 by net +2; the +2 reflects the chart-algebra DECOMPOSITION cost (the iter-144 commitment factored a bundled 3-sorry chain into 5 narrower sub-piece sorries). The 5 new sorries are iter-146+ prover targets (live sorries); the 3 deleted were DESCOPED dead-load.
