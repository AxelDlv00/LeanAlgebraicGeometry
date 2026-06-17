# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-050 result: RESOLVED

Appended four declarations inside `section CoverTotality` (which sits inside
`namespace AlgebraicGeometry.Scheme`) immediately after iter-049's
`subsingleton_HModule_of_isCechAcyclicCover_top_curve`, and before
`end CoverTotality`. Bodies copied verbatim from the plan-agent's
probe-confirmed PROGRESS.md template.

### Declarations added

1. `class HasCechToHModuleIso F 𝒰 : Prop` — single `Nonempty`-wrapped field
   `nonempty_compIso` capturing the existence of the comparison iso
   `∀ n, cechCohomology n ≃ₗ[k] HModule' n (⨆ 𝒰)`.
2. `noncomputable def cechToHModuleIso` — `Classical.choice`-based extractor
   on the class field. Fires automatically on the
   `[HasCechToHModuleIso F 𝒰]` instance.
3. `theorem subsingleton_HModule_of_hasCechToHModuleIso_top` —
   instance-driven consumer chaining iter-049's
   `subsingleton_HModule_of_isCechAcyclicCover_top` with the iter-050 extractor.
4. `theorem subsingleton_HModule_of_hasCechToHModuleIso_top_curve` —
   curve specialisation at `F := toModuleKSheaf C` via dot-notation reuse with
   the named-argument `(𝒰 := 𝒰)` lock-in.

### Verification

- `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`:
  `{success: true, items: [], failed_dependencies: []}` — zero errors,
  zero warnings.
- `lean_verify AlgebraicGeometry.Scheme.cechToHModuleIso`:
  `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only.
- `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top`:
  `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only.
- `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top_curve`:
  `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only.
- `Classical.choice` was already in the project's kernel-only axiom set since
  iter-048; **no new axiom introduced** by iter-050.
- Sorry trajectory: `9 → 9` (no transient sorries; bodies are direct-term).
- File LOC delta: matches the +50-70 plan-agent estimate.

### Notes

- All four declarations reside inside the `namespace AlgebraicGeometry.Scheme`
  block; declared names drop the `Scheme.` prefix. References inside the bodies
  (`cechCohomology`, `HModule'`, `IsCechAcyclicCover`, `cechToHModuleIso`,
  `subsingleton_HModule_of_isCechAcyclicCover_top`, `toModuleKSheaf`,
  `HasCechToHModuleIso`) likewise use unqualified short names — namespace
  resolution recovers the fully-qualified form.
- The `Nonempty` wrapper on the class field is mandatory: a `Prop`-valued class
  cannot have a `Type`-valued field (the comparison iso is data via
  `LinearEquiv`).
- Consumers (3) and (4) are `theorem`s, not `instance`s: instance synthesis
  cannot supply the explicit `h`/`hn` arguments at call sites.
- The `(𝒰 := 𝒰)` named-argument pin in declaration (4)'s body is required
  because positional unification through the implicit `𝒰` of the abstract
  consumer is otherwise ambiguous.

### Blueprint markers ready

The following declarations are formalised end-to-end with no `sorry` and
kernel-only axioms; the review agent may add `\leanok` to the matching blocks
in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Comparison-iso
typeclass carrier (iter-050)*:

- `def:Scheme_HasCechToHModuleIso` →
  `AlgebraicGeometry.Scheme.HasCechToHModuleIso`
- `def:Scheme_cechToHModuleIso` →
  `AlgebraicGeometry.Scheme.cechToHModuleIso`
- `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top` →
  `AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top`
- `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top_curve` →
  `AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top_curve`

### No sorries left

This file contains 0 `sorry` placeholders (matches pre- and post-iter-050
project-wide count of 9, distributed across `Jacobian.lean`,
`AbelJacobi.lean`, `Picard/Functor.lean`).
