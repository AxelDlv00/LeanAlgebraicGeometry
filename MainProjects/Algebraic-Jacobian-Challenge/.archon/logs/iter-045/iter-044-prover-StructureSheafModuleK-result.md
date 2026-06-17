# AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

## module_finite_globalSections_of_isProper (iter-044, new at L542)

### Attempt 1
- **Approach:** Append the plan-agent's probe-confirmed body verbatim inside
  `namespace AlgebraicGeometry.Scheme`, after iter-043's
  `module_finite_HModule_zero_of_isHModuleHomFinite_curve` (originally L511) and
  before `end AlgebraicGeometry.Scheme` (originally L513). The body extracts
  `(C.hom.appTop.hom).Finite` via `AlgebraicGeometry.finite_appTop_of_universallyClosed`,
  registers an intermediate `Algebra` via `letI` + `RingHom.toAlgebra`, derives
  intermediate `Module.Finite` via `← RingHom.finite_algebraMap`, and transports
  the base ring from `Γ(Spec k, ⊤)` to `k` via `Module.Finite.of_equiv_equiv`
  using `(Scheme.ΓSpecIso (CommRingCat.of k)).commRingCatIsoToRingEquiv`. The
  algebra-map compatibility obligation collapses the trivial restriction
  `presheaf.map (homOfLE le_top : ⊤ ⟶ ⊤).op` via
  `congrFun (congrArg (·.hom) (presheaf.map_id _)) _` (Subsingleton.elim on the
  `⊤ ⟶ ⊤` hom-set + `Functor.map_id`).
- **Adjustment from probe:** The plan-agent's body used the bare identifier
  `op ⊤`, but the file's `open` line at L38 (`open CategoryTheory Limits
  TopologicalSpace AlgebraicGeometry`) does NOT include `Opposite`, and there is
  no other open (this file or its imports) bringing `Opposite.op` into the bare
  short name. All bare `op` references therefore needed to be qualified to
  `Opposite.op`. Six occurrences in the body and one inside the inner `congrArg`
  call were changed; no other modifications.
- **Result:** RESOLVED. `lean_diagnostic_messages` returns
  `{success: true, items: [], failed_dependencies: []}`.
  `lean_verify AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper`
  returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` —
  kernel-only.
- **Key insight:** The plan-agent's `lean_run_code` probe was self-contained
  (full preamble) and likely ran with a default `open Opposite` baseline; the
  file context here lacks that, so all `op` literals need explicit
  `Opposite.op`. No semantic change.

### File state after iter-044
- LOC: `548 → 615` (+67; planner expected +30..+45 — actual is slightly higher
  because the docstring is ~30 lines and the body ~37 lines after the explicit
  `Opposite.op` qualifications; still well within iteration budget).
- Sorry count: `0 → 0` for this file (the lone `grep` hit at L30 is inside a
  docstring referencing the iter-006 historical scaffolding).
- New imports: none required (probe-confirmed).
- New axioms: none.

### Blueprint marker readiness
The new theorem `AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper`
is fully proved with kernel-only axioms. Its blueprint environment
`thm:Scheme_module_finite_globalSections_of_isProper` (in
`blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` § *Stein finiteness
of global sections (iter-044)*) is ready for `\leanok` on both the statement and
proof blocks. Review agent should add the markers.

### Notes for downstream iterations (iter-045+)
- This theorem is the geometric Stein input. Iter-045+ will assemble the
  producer instance `IsHModuleHomFinite k C (Scheme.toModuleKSheaf C)` by
  lifting `constantSheafΓAdj.homEquiv` to a `LinearEquiv`, identifying
  `Sheaf.Γ.obj (toModuleKSheaf C)` with the underlying global sections, and
  transporting `Module.Finite` via `Module.Finite.equiv` from this iter-044
  theorem.
- The hypotheses `[IsIntegral C.left]` and `[IsProper C.hom]` were chosen as
  the cleanest direct interface; the consumer derives `IsIntegral` from its own
  context (e.g. via `GeometricallyIrreducible` + smoothness on a $k$-curve).
