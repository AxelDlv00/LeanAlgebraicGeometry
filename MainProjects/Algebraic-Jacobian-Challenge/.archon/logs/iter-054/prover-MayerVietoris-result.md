# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-054 — Foundational basic-open cover infrastructure

### Result: RESOLVED

Appended three declarations inside `section CoverTotality` (within
`namespace AlgebraicGeometry.Scheme`), after iter-053's
`instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` and before
`end CoverTotality`. Verbatim probe-confirmed bodies from PROGRESS.md
were used; no deviations.

1. `noncomputable def basicOpenCover` — basic-open cover constructor from a
   spanning subset `s ⊆ Γ(C.left, U)`, returning `s → Opens` mapping
   `f ↦ C.left.basicOpen f`.
2. `theorem basicOpenCover_supr_of_span_eq_top` — supremum equality on affine
   `U` from `Ideal.span s = ⊤` via Mathlib's
   `IsAffineOpen.iSup_basicOpen_eq_self_iff`.
3. `theorem basicOpenCover_isAffineOpen` — each cover member is itself affine
   via Mathlib's `IsAffineOpen.basicOpen`.

### Verification

- `lean_diagnostic_messages` on the file returns
  `{success: true, items: [], failed_dependencies: []}`. Clean compile,
  zero new warnings.
- `lean_verify AlgebraicGeometry.Scheme.basicOpenCover` →
  `{axioms: [propext, Classical.choice, Quot.sound], warnings: [pre-existing L259 local instance]}`.
- `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top` →
  kernel-only.
- `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_isAffineOpen` →
  kernel-only.
- The L259 `local instance` warning is pre-existing (iter-046-era), not
  introduced by iter-054.
- Sorry count unchanged: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` +
  1 `Picard/Functor.lean`).
- File LOC: 1317 → 1380 (+63; small overage from multi-paragraph docstrings,
  consistent with iter-045/047/048/050/052/053 pattern).

### Blueprint markers (for review agent)

The three declarations are formalized with full proofs (no sorries) and
should receive `\leanok` in the statement and proof blocks of
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Foundational
basic-open cover infrastructure (iter-054)*:

- `def:Scheme_basicOpenCover` — statement + proof both `\leanok`.
- `thm:Scheme_basicOpenCover_supr_of_span_eq_top` — statement + proof both `\leanok`.
- `thm:Scheme_basicOpenCover_isAffineOpen` — statement + proof both `\leanok`.

### Notes for next iteration (iter-055)

- Iter-054 is purely scaffolding. No new axiom; no protected signatures
  touched; no sorries opened or closed.
- Iter-055+ now has the basic-open cover constructor + supremum + affine-membership
  in scope for the substantive Koszul-acyclicity / Čech-vs-derived comparison
  branch leading to `HasAffineCechAcyclicCover (toModuleKSheaf C)`.
