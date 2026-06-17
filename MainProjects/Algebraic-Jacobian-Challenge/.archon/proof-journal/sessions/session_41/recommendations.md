# Recommendations for the next plan-agent iteration (iter-042)

## Tracks

### Track 1A (recommended primary — iter-042 prover lane): producer instance for `IsAffineHModuleHomFinite` (substantive geometric step, single-iteration plausibly close)

**Target**: a producer instance (or theorem)

```
instance/theorem isAffineHModuleHomFinite_toModuleKSheaf
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k))) :
    IsAffineHModuleHomFinite k C (Scheme.toModuleKSheaf C)
```

(or, if the instance form risks slow synthesis, a `theorem`-flavoured supplier consumed manually at use sites). With iter-041's H⁰ carrier predicate now in scope, this packages the algebraic statement that for affine $U \subseteq C.\mathtt{left}$, the morphism group $((\mathtt{presheafToSheaf}\,J\,(\ModuleCat\,k)).\mathtt{obj}\,((\mathtt{yoneda} \circ \mathtt{free}\,k).\mathtt{obj}\,U) \to \toModuleKSheaf\,C)$ is a finite $k$-module — morally, $\Gamma(\Spec A, \struct C) \simeq A$ on affine corners of a finite-type $k$-scheme.

**Why prefer this over Track 1B (`IsAffineHModuleVanishing` producer)?** The H⁰ side is *structurally simpler*: it only requires the iter-015 LinearEquiv plus the global-sections finite-type bridge, both already substantively in scope (iter-005 / iter-014 / iter-015). The H^>0 side requires either a project-local Čech-vs-derived comparison or a Mathlib advance on Serre vanishing, both heavier. **Plan-agent should prioritise the H⁰ producer in iter-042 to maintain single-iteration close cadence**, with the H^>0 producer queued for iter-043+ as a multi-iteration assembly.

**Mathlib re-probe re-issue (iter-039 + iter-040 + iter-041 plan-agent passes confirm)**: still absent — `Mathlib/AlgebraicGeometry/Cohomology/` does not exist; only `subsingleton_H_of_isZero` (`Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` L74) is available, trivial. **The iter-042 plan-agent should re-probe Mathlib HEAD once more before committing** — Mathlib changes weekly and an affine Hom-finiteness PR could have landed.

**Probe-confirmation gate** (continued cohort discipline): as established across iter-031 → iter-041, do **not** assign the prover lane until the plan-agent's `lean_run_code` probe returns `{success: true, diagnostics: []}` end-to-end on the proposed body. **6 of 7 zero-corrective-Edit landings since iter-035** have followed verbatim probe-confirmed plan-agent prompts. If the producer instance is too heavy to probe end-to-end in a single `lean_run_code` call, **decompose into sub-targets and probe each** before assigning.

**Highest priority — gates Step 4 finalisation** (the H⁰-side input to the cover-evaluation chain on a curve).

### Track 1B (alternative — iter-042 prover lane): producer instance for `IsAffineHModuleVanishing` (substantive geometric step, multi-iteration likely)

**Target**: a producer instance

```
instance/theorem isAffineHModuleVanishing_toModuleKSheaf
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k))) :
    IsAffineHModuleVanishing k C (Scheme.toModuleKSheaf C)
```

**Multi-iteration assembly required** (per iter-040 + iter-041 plan-agent re-probes — Mathlib still absent):

1. **iter-042 step (a)**: introduce a project-local Čech-vs-derived comparison theorem at the level of an arbitrary affine open — likely the heaviest single declaration of the entire Phase A step 6 chain. Probably needs an intermediate scaffold (Čech complex of the structure sheaf restricted to an affine, contracted by a constant section). Plausibly 50–100+ LOC, multi-Edit, multi-iteration if probe-confirmation fails.
2. **iter-043 step (b)** (in the same iteration if scope allows, otherwise iter-044): apply the comparison to derive the producer instance.

**Lower priority than Track 1A** — Track 1A has a tighter probe-confirmation circle (single iteration likely), Track 1B has a heavier substantive geometric step. **Recommendation**: pick Track 1A unless probe-confirmation fails, in which case fall back to Track 1B.

### Track 1C (recommended alternative — iter-042 prover lane): sharper Mayer–Vietoris LES consumer (single-iteration close, recommendation re-issued from iter-039 + iter-040)

**Target**: a single-step LES consumer combining

- iter-029's `HModule'_sequence_curve_exact` (exactness in the LES on `HModule'`),
- iter-035's `HModule'_X₄_linearEquiv_curve` (corner-bridge for `X₄`),
- iter-036's `finrank_HModule_eq_HModule'_X₄_curve` (finrank corollary of the corner-bridge),
- iter-037's `module_finite_HModule_of_HModule'_X₄_curve` (corner-bridge `Module.Finite` transport),
- iter-038's `module_finite_HModule_zero` / `module_finite_HModule'_zero` (abstract H⁰ `Module.Finite` transports),
- iter-039's `module_finite_HModule_zero_curve` / `module_finite_HModule'_zero_curve` (curve-form H⁰ transports),
- iter-040's `IsAffineHModuleVanishing` carrier + `module_finite_HModule'_of_isAffineHModuleVanishing` consumer,
- **iter-041's `IsAffineHModuleHomFinite` carrier + `module_finite_HModule'_zero_of_isAffineHModuleHomFinite` consumer** (newly in scope),

into a four-term LES directly on `HModule k F (n+1)` for the curve case:

```
HModule' k F n X₁ ⊕ HModule' k F n X₂ → HModule' k F n X₃ → HModule k F (n+1)
```

Plausibly a single-iteration ~20–40 LOC declaration (`Scheme.AffineCoverMVSquare.HModule_LES_curve` or similar). With both iter-040's H^>0 carrier and iter-041's H⁰ carrier now available, this consumer can chain directly into `Module.Finite` for **all** corner positions of the LES without waiting on the iter-042+ producer instances.

**Equal priority with Track 1A**: this is forward investment that does NOT require either producer instance to land. **The iter-042 plan-agent should pick Track 1A or Track 1C based on which has a tighter probe-confirmation circle**. Track 1C is plausibly the cleaner single-iteration close (~20–40 LOC, body-trivial chain); Track 1A is more strategically valuable (gates the H⁰ producer for downstream Phase A step 6 finalisation) but requires the algebraic content of $\Gamma(\Spec A, \struct C) \simeq A$.

### Track 1D (low-risk warm-up if Track 1A and Track 1C both probe-fail): `_curve` companion of iter-041's consumer

**Target**: `Scheme.module_finite_HModule'_zero_of_isAffineHModuleHomFinite_curve` specialising to `F := Scheme.toModuleKSheaf C`. Body would be a one-line `Scheme.module_finite_HModule'_zero_of_isAffineHModuleHomFinite k _ F hU` invocation following the iter-039 `_curve` wrapper pattern.

**Caveat**: the iter-041 consumer is already curve-ready by parametrisation (any sheaf `F` is accepted); a `_curve` companion would only fix `F := toModuleKSheaf C` and provide a slightly more ergonomic call site. **Marginal value** — recommended only if Track 1A, Track 1B, and Track 1C all probe-fail. Plausibly ~5–10 LOC, zero-corrective-Edit close.

### Track 2 (parallel low-coupling): none recommended

Polish backlog remains empty. The protected sorries in `Jacobian.lean` and `AbelJacobi.lean` are all blocked on Phase C step 4 / Phase A step 6 chain completion plus a `noncomputable` user-decision; do not attempt them prematurely.

### Hard avoid

- `representable` — closing on the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor.
- The 5 `Jacobian.lean` protected sorries — Phase C step 4 (FGA representability) plus `noncomputable` user-decision.
- The 3 `AbelJacobi.lean` protected sorries — structurally downstream of `Jacobian C` plus `noncomputable` user-decision on `ofCurve`.
- Closed scaffold sites in `Cohomology/MayerVietoris.lean` (iter-016 → iter-026, iter-028 → iter-037) and in `Cohomology/StructureSheafModuleK.lean` (iter-006, iter-009, iter-010, iter-011, iter-012, iter-014, iter-015, iter-026, iter-038, iter-039, iter-040, **iter-041**) — do not retry; they are already closed.
- Re-introducing the `Scheme.` short-name prefix inside `namespace AlgebraicGeometry.Scheme` — known-dead-end #185 (surfaced iter-038, internalised by iter-039 / iter-040 / iter-041).
- Switching iter-040's H^>0 `Subsingleton` formulation to `Limits.IsZero` — the iter-014 typing of `HModule'` returning `Type u` (not a `ModuleCat` object) makes `IsZero` strictly weaker for the chaining into `Module.Finite`. Stick with `Subsingleton`.
- Switching iter-041's H⁰ `Module.Finite k (Hom)` formulation to a `Subsingleton`- or `IsZero`-flavoured field — the H⁰ conclusion is *finiteness*, not *vanishing*; the genuine algebraic content is "Hom is finite", which `Subsingleton` would not capture. Stick with the direct `Module.Finite k _` field.

## `blueprint/lean_decls` maintenance — second consecutive clear-as-you-go iteration

For the **second iteration in a row** (iter-040 + iter-041), the iter-041 plan-agent appended **the iter-041 declarations themselves** to `blueprint/lean_decls` in the same pass that introduced them. New entries at L29–30:

- `AlgebraicGeometry.Scheme.IsAffineHModuleHomFinite`
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero_of_isAffineHModuleHomFinite`

Combined with the pre-existing entries through iter-040, `blueprint/lean_decls` is now **fully current through iter-041**.

**Recommendation**: the **iter-042 plan-agent should maintain this clear-as-you-go discipline**. The discipline is now load-bearing on the plan-agent prompt structure (two iterations in a row); the manual escalation to a hook or template change recommended in earlier iterations (iter-033 → iter-039) is no longer needed.

## Reusable proof patterns (collected this iteration)

- **Verbatim probe-confirmed body, single combined Edit**: when the plan-agent's `lean_run_code` probe returns `{success: true, diagnostics: []}` end-to-end, the prover lands the body verbatim in a single Edit with zero corrective rounds. **6 of 7 iterations zero-corrective-Edit, 1 of 7 with two corrective Edits sharing one root cause (iter-038 / known-dead-end #185).**
- **H⁰ vs H^>0 carrier predicate field type asymmetry**: H⁰ side uses `Module.Finite k (Hom)` directly on the morphism group (the H⁰ algebraic bridge target via iter-015), H^>0 side uses `Subsingleton` on `HModule' k F i U`. Reusable for any future "$H^?(U,F)$ has property $P$" carrier pair: split by whether $P$ is a vanishing assertion or a structural-finite assertion.
- **Three-line consumer body `have ... := class_field hU; abstract_transport k F U`** for "already-structural-on-bridge" carriers: when the carrier class field already produces the structural property on the bridge object, the consumer chains through the abstract project transport rather than `inferInstance`. Distinct from iter-040's `have ... ; inferInstance` recipe for "structurally-implied" carriers (Subsingleton ⇒ Module.Finite via Mathlib auto-derivation).
- **`class` + `theorem` over `class` + `instance`** when explicit hypothesis args block typeclass resolution: the consumer's explicit witness arguments cannot be instance-synthesised, so the consumer is a `theorem` (not an `instance`).
- **Carrier-predicate + immediate consumer paired-cohort packaging**: the carrier `class` and its immediate consumer paired in a single iteration (now iter-040 + iter-041, applied symmetrically to H^>0 and H⁰). With both pairs in scope, iter-042+ can focus exclusively on the producer instances without further consumer scaffolding.

## Net iteration progress

- **Sorry trajectory**: `9 → 9 → 9` (no transient).
- **Seventh consecutive substantive single-Edit closure** (Edit-count 1 substantive); 24 consecutive single-Edit closures since iter-018.
- **Two new declarations** added to `Cohomology/StructureSheafModuleK.lean` (L395–403 and L413–424 in the post-Edit file). LOC: 420 → 461 (+41).
- **`blueprint/lean_decls` second-consecutive clear-as-you-go iteration**.
- **All four blueprint markers verified accurate** post-prover.
- **Phase A step 6 / Step 4 H⁰-side and H^>0-side carrier predicates both now in scope**; the only remaining Step 4 algebraic obstructions are the two producer instances (`IsAffineHModuleHomFinite k C (toModuleKSheaf C)` queued iter-042 primary, `IsAffineHModuleVanishing k C (toModuleKSheaf C)` queued iter-042 alternative).
