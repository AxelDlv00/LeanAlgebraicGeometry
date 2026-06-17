# AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

## Iter-022 — `HModule'_sequence` (new declaration after `HModule'_δ`)

### Attempt 1
- **Approach:** Collapsed refactor + prover sub-phases (matches the iter-015
  through iter-021 streak): single `Edit` appending the new
  `noncomputable abbrev HModule'_sequence` directly with the probe-confirmed
  term-mode body, rather than going through the transient `:= by sorry`
  state.
- **Result:** RESOLVED on first edit.
- **Body adopted:** verbatim probe-confirmed Mathlib L120–122 mirror —
  ```lean
  ComposableArrows.mk₅ (HModule'_toBiprod k S F n₀) (HModule'_fromBiprod k S F n₀)
    (HModule'_δ k S F n₀ n₁ h)
    (HModule'_toBiprod k S F n₁) (HModule'_fromBiprod k S F n₁)
  ```
- **Form:** `noncomputable abbrev` (load-bearing per the directive — switching
  to `def` would block downstream `dsimp` access to `mk₅`'s field-projection
  simp lemmas in iter-023+).
- **Typeclass list:** `[HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
  [HasExt (Sheaf J (ModuleCat.{u} k))]` — all three present per directive;
  `HasExt` is load-bearing (consumed by `HModule'_δ` in the body).
- **Namespace:** inside `namespace AlgebraicGeometry.Scheme`, immediately
  after `noncomputable def HModule'_δ` and before `end AlgebraicGeometry.Scheme`.
- **Qualification choice:** `ComposableArrows.mk₅` (qualified, no
  `open ComposableArrows`) — matches directive guidance to keep the file's
  existing `open` directive untouched.

### Verification (run by this prover before reporting)

1. `lean_diagnostic_messages` on the full file → `{success: true, items: [],
   failed_dependencies: []}` (after one tweak: an initial 101-column
   docstring line at L607 was shortened by breaking the long Mathlib path
   reference onto a new line — a docstring-only change, no semantic effect
   on the closure).
2. `lean_verify AlgebraicGeometry.Scheme.HModule'_sequence` →
   `{axioms: [propext, Classical.choice, Quot.sound],
     warnings: [(line: 397, pattern: "local instance")]}`. Kernel-only.
   The L397 warning is the harmless source-scan heuristic match on the
   docstring text "project-local instance" inside the iter-019
   `ModuleCat_free_isLeftAdjoint` instance docstring (pre-existing, not
   from iter-022).
3. `sorry_analyzer.py AlgebraicJacobian/ --format=summary` →
   `9 total across 3 file(s)` (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1
   `Picard/Functor.lean`). `Cohomology/StructureSheafModuleK.lean` is not
   in the list — has 0 sorries.

### Notes for the next agent

- Ready for `\leanok` marker on the iter-022 statement block in
  `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`
  (the `def:Scheme_HModule_prime_sequence` block under the section
  "Mayer-Vietoris LES sequence (iter-022)"). The review agent should set
  this marker.
- Iter-023+ scope (queued, do not address now): the iso
  `HModule'_sequenceIso` to `Ext.contravariantSequence` (Mathlib L124–138)
  with its four auxiliary lemmas (Mathlib L48–106).
- Iter-024+ scope (queued): the exactness theorem `HModule'_sequence_exact`
  (Mathlib L140–141) plus the `δ_toBiprod` / `fromBiprod_δ` `simp`
  companions (Mathlib L143–149).
