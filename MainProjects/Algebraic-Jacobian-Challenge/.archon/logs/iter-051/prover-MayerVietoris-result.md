# AlgebraicJacobian/Cohomology/MayerVietoris.lean — iter-051 (prover round)

## Summary

Iter-051 task: append two instance-driven supremum HModule' consumer
declarations inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`,
after iter-050's `subsingleton_HModule_of_hasCechToHModuleIso_top_curve`,
before `end CoverTotality`.

**Result: RESOLVED.** Both declarations land verbatim from the probe-confirmed
bodies in PROGRESS.md; file compiles cleanly; both new theorems verify
kernel-only.

## subsingleton_HModule'_supr_of_hasCechToHModuleIso

### Attempt 1
- **Approach:** Insert the verbatim probe-confirmed body from PROGRESS.md (single Edit, appended just before `end CoverTotality` at L1163). Body delegates to iter-048's `subsingleton_HModule'_supr_of_isCechAcyclicCover`, with iter-050's `cechToHModuleIso` extractor firing automatically on the `[HasCechToHModuleIso F 𝒰]` instance argument to recover the explicit `compIso` that iter-048's consumer expects.
- **Result:** RESOLVED.
- **Verification:**
  - `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean` → `{success: true, items: [], failed_dependencies: []}` (zero errors, zero warnings at the diagnostic level).
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_hasCechToHModuleIso` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 259, pattern: 'local instance'}]}` — kernel-only; the `local instance` warning at L259 is pre-existing.

## subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve

### Attempt 1
- **Approach:** Insert the verbatim probe-confirmed body from PROGRESS.md as the second declaration in the same Edit. The body delegates to the abstract form (declaration 1) with the `(𝒰 := 𝒰)` named-argument syntax, since positional inference is ambiguous via implicit arguments alone.
- **Result:** RESOLVED.
- **Verification:**
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 259, pattern: 'local instance'}]}` — kernel-only.

## Notes / Outcome

- **No new sorry introduced; no sorry removed** (this iteration adds two
  fully-proved consumer theorems, no `sorry` placeholder is touched). Sorry
  count `9 → 9` as predicted in PROGRESS.md.
- **No new axioms introduced.** `Classical.choice` was already in scope since
  iter-048 / iter-050.
- **No new imports added.** All required names
  (`subsingleton_HModule'_supr_of_isCechAcyclicCover`, `cechToHModuleIso`,
  `IsCechAcyclicCover`, `HasCechToHModuleIso`, `HModule'`, `toModuleKSheaf`)
  were already in scope, as predicted.
- **Single Edit form** used: one append before `end CoverTotality`, exactly as
  specified.
- **`Scheme.` prefix dropped** on declared names per the namespace placement
  rule (mirrors iter-035-037/049/050 pattern).
- **`theorem` not `instance`**: per the rigid declaration shape requirement.
- **Single-universe `[HasExt.{u}]` only**: no `[HasExt.{u+1}]` annotation, in
  contrast to iter-049/050's `_top` form.

## Blueprint markers ready

The two iter-051 declarations are formalized with no `sorry`. The review agent
should mark `\leanok` on both:

- `thm:Scheme_subsingleton_HModule_prime_supr_of_hasCechToHModuleIso`
- `thm:Scheme_subsingleton_HModule_prime_supr_of_hasCechToHModuleIso_curve`

in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Instance-driven
supremum HModule' consumer (iter-051)*.

## Placement (final)

- File: `AlgebraicJacobian/Cohomology/MayerVietoris.lean`.
- New declarations land at L1163 (`subsingleton_HModule'_supr_of_hasCechToHModuleIso`)
  and L1192 (`subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve`),
  inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`.
- File LOC after iter-051: 1216 (= 1165 + 51 added; within the +30-50 plan
  band).
- `end CoverTotality` and `end AlgebraicGeometry.Scheme` re-anchored at the
  new corresponding line offsets after the append.

## Next steps (for plan agent)

Iter-052+ substantive Čech-vs-derived comparison theorem + basic-open
acyclicity producer cohort, as scoped in PROGRESS.md. The iter-051 typeclass
infrastructure is now complete (universe-`u` intermediate-supremum on
`HModule'`, plus iter-049/050 universe-`u+1` top-supremum on `HModule`); the
substantive next step is to *prove* `HasCechToHModuleIso` + `IsCechAcyclicCover`
instances for basic-open covers of affine opens.
