# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-053 — existence-bundled affine Čech-acyclic cover carrier + producer for `IsAffineHModuleVanishing`

### Scope
Append two declarations inside `section CoverTotality` (within `namespace AlgebraicGeometry.Scheme`), after iter-052's `subsingleton_HModule'_of_hasCechToHModuleIso_curve` (L1260), before `end CoverTotality` (was L1262).

### Decl 1 — `class HasAffineCechAcyclicCover` (L1262 area, new)
- **Approach:** Verbatim probe-confirmed body from `PROGRESS.md`. Single-field `Prop`-class; field `exists_cover` quantifies over `{U} (hU : IsAffineOpen U)` and asserts existence of `(ι : Type u, 𝒰 : ι → Opens, ⨆𝒰 = U, IsCechAcyclicCover F 𝒰, HasCechToHModuleIso F 𝒰)`.
- **Result:** RESOLVED. Kernel-only axioms `[propext, Classical.choice, Quot.sound]`.

### Decl 2 — `instance instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (new)
- **Approach:** Verbatim probe-confirmed tactic body. `obtain ⟨ι, 𝒰, hcov, hacyc, hcomp⟩ := HasAffineCechAcyclicCover.exists_cover (F := F) hU`, then two `haveI` lines registering `IsCechAcyclicCover F 𝒰` and `HasCechToHModuleIso F 𝒰` as local instances, then `exact subsingleton_HModule'_of_hasCechToHModuleIso hcov i hi` chaining iter-052's generalised rewrite-bridge consumer.
- **Result:** RESOLVED. Marked `instance` so synthesis fires. Kernel-only axioms `[propext, Classical.choice, Quot.sound]`.

### Verification (this prover round)
- `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`: `{success: true, items: [], failed_dependencies: []}`. Zero errors, zero warnings.
- `lean_verify AlgebraicGeometry.Scheme.HasAffineCechAcyclicCover` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only.
- `lean_verify AlgebraicGeometry.Scheme.instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` → kernel-only.
- File LOC: `1264 → 1317` (+53 LOC; slight overage vs +30–50 plan band, from multi-paragraph docstrings; mirrors iter-045/047/048/050/052 pattern).
- Sorry count in `MayerVietoris.lean`: still `0` (project-wide remains `9` per plan-agent baseline; this file contributes none).
- No new imports added (verified by plan-agent probe; all needed names — `IsCechAcyclicCover`, `HasCechToHModuleIso`, `HModule'`, `IsAffineHModuleVanishing`, `IsAffineOpen` — transitively in scope).
- No `axiom` declarations introduced.

### Blueprint marker readiness (for review agent)
Both new declarations should receive `\leanok` in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Existence-bundled affine Čech-acyclic cover carrier + `IsAffineHModuleVanishing` producer (iter-053)*:
- `def:Scheme_HasAffineCechAcyclicCover` → `\leanok`
- `thm:Scheme_instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` → `\leanok`

### Notes
- Bodies are exactly the verbatim probe-confirmed forms from `PROGRESS.md`; no deviations needed.
- The `Scheme.` prefix is dropped on the declared names (inside `namespace AlgebraicGeometry.Scheme`; matches iter-049/050/051/052 pattern).
- The `(F := F)` named-argument is required when calling `HasAffineCechAcyclicCover.exists_cover`, since `F` cannot be inferred from `(hU : IsAffineOpen U)` alone.
- The two `haveI` lines are load-bearing: they convert the `∃`-conjuncts (regular hypotheses) into local class instances so iter-052's consumer (which takes them as `[…]` arguments) fires via instance synthesis.
- Single-universe `[HasExt.{u}]` annotation only — iter-053 does not require the iter-034 universe bridge (mirrors iter-052's single-universe constraint).
