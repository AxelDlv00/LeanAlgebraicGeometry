# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-058: `basicOpenCover_finset_inf'_le` (appended before `end CoverTotality` at L1546)

### Attempt 1
- **Approach:** Append verbatim probe-confirmed declaration from PROGRESS.md inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, immediately after iter-057's `basicOpenCover_finset_inf'_isAffineOpen` (L1544), before `end CoverTotality`. Body: term-mode `▸` chain of `basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸ C.left.basicOpen_le _`.
- **Result:** RESOLVED.
- **Key details:**
  - Used the verbatim probe-confirmed body from PROGRESS.md. No deviation.
  - `Scheme.` prefix dropped on the declared name (we're already inside `namespace AlgebraicGeometry.Scheme`).
  - `basicOpenCover_finset_inf'_eq_basicOpen_prod` referenced unqualified (same namespace, same section); `C.left.basicOpen_le` keeps dotted form (method call on `C.left : Scheme`).
  - `(C := C) (U := U)` implicit annotation on `basicOpenCover` reference — matches iter-054/056/057.
  - No new imports required; `Scheme.basicOpen_le` already transitively in scope.
  - Term-mode `▸` (NOT tactic-mode `rw`) — implicit `Subtype.val` coercions on `Finset s` elements cause motive-occurrence issues with `rw`, identical to iter-057's `_isAffineOpen` case.
  - No `IsAffineOpen U` hypothesis required (`basicOpen_le` is purely topological).
- **Verification:**
  - `lean_diagnostic_messages` on the full file: `{success: true, items: [], failed_dependencies: []}` — zero errors, zero warnings at the file level.
  - `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 259, pattern: "local instance"}]}` — kernel-only axioms only. The `local instance` warning at L259 is the pre-existing iter-020 scaffolding, not new.
  - Sorry count unchanged: file had 0 sorries, still 0 sorries.
  - File LOC: 1548 → 1587 (+39, within the +30-50 plan band; declaration body is 1 LOC of actual proof + verbatim long docstring).

### Blueprint markers
- The declaration `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` is ready for `\leanok` on its statement-and-proof block in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *N-ary basic-open intersection inclusion (iter-058)*.

### Notes for next iteration
- Iter-059+ should invoke the `analogy` subagent for Mathlib precedent on `cechComplexFunctor` evaluation patterns, Koszul exactness in algebraic geometry, and `IsLocalizedModule.map_exact`-style chain-level constructions (5th-iter repeat recommendation per plan-agent).
- The `IsLocalization.Away f Γ(C.left, t.inf' h (basicOpenCover s))` conclusion type is gated on the algebra instance from `(i : V ⟶ U)` morphism; iter-059+ Koszul argument should call `hU.isLocalization_of_eq_basicOpen f (homOfLE (basicOpenCover_finset_inf'_le ...)) (basicOpenCover_finset_inf'_eq_basicOpen_prod ...)` at the call site (per PROGRESS.md guidance).
- Mathlib name correction: use `exact_of_isLocalized_span` (NOT `exact_of_localized_span`).
