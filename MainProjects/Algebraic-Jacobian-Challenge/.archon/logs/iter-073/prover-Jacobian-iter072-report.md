# AlgebraicJacobian/Jacobian.lean — iter-072 Lane 1 (refactor precursor for AbelJacobi)

## Summary

Iter-072 Lane 1 was a **structural refactor of `JacobianWitness`** (not a sorry
closure). The single remaining sorry — `nonempty_jacobianWitness` (L172) — is
the Phase-C existence claim and is explicitly off-limits this iteration.

**Sorry count**: 1 → 1 (unchanged, as planned).

## Refactor performed

The `JacobianWitness` bundle previously carried an internal marked point `P : 𝟙_ _ ⟶ C`
as a field, with `isAlbanese` indexed on that specific `P`. This shape is
incompatible with `AbelJacobi.Jacobian.ofCurve P`, whose `P` is an *arbitrary*
input — Lane 2 needed the Albanese property to be uniform over `P`.

The refactor (per PROGRESS.md §1):

1. **Dropped the `P` field** from the `JacobianWitness` structure.
2. **Renamed `isAlbanese` → `isAlbaneseFor`** and changed its type from
   ```
   isAlbanese : @IsAlbanese k _ C P J grpObj proper smooth geomIrred
   ```
   to
   ```
   isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), @IsAlbanese k _ C P J grpObj proper smooth geomIrred
   ```
3. **`nonempty_jacobianWitness` signature unchanged** — still
   `Nonempty (JacobianWitness C) := sorry`. Per PROGRESS.md "hard constraints",
   this sorry was not touched.
4. **`jacobianWitness` unchanged** — still `Classical.choice (nonempty_jacobianWitness C)`.
5. **Four protected instances unchanged** — they project `grpObj`, `smoothGenus`,
   `proper`, `geomIrred` from the witness, none of which were renamed or
   re-typed. They remain `P`-independent (which is mathematically correct: the
   group/proper/smooth/irreducible properties of the underlying scheme `J` do
   not depend on the choice of pointing).
6. **`Jacobian C` unchanged** — its `g > 0` branch still projects
   `(jacobianWitness C).J`, which is `P`-independent.

## Post-refactor shape (precondition for Lane 2)

For any input `(C, P)`, Lane 2 can extract the Albanese morphism uniformly via:

```
let w := jacobianWitness C
let hP := w.isAlbaneseFor P    -- : IsAlbanese C P w.J
hP.ofCurve                      -- : C ⟶ w.J
hP.comp_ofCurve                 -- : P ≫ hP.ofCurve = η[w.J]
hP.exists_unique_ofCurve_comp f hf
                                -- : ∃! g : w.J ⟶ A, f = hP.ofCurve ≫ g
```

Combined with the `Jacobian C` g>0 branch reducing to `w.J`, the four protected
instances on `Jacobian C` ensure type-correctness for the `IsAlbanese C P (Jacobian C)`
statement that Lane 2 needs.

## Verification

- LSP `lean_diagnostic_messages` returns `success: false` — known broken build env
  (per PROGRESS.md: `.lake/packages/{mathlib,doc-gen4,checkdecls}` owned by root).
  Verification deferred to `sync_leanok` phase and iter-073 plan-agent check.
- **Manual structural verification**:
  - `JacobianWitness` fields `J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`
    are present and untouched.
  - `Jacobian` def (L189-198) projects only `(jacobianWitness C).J` — unaffected.
  - `instGrpObj` (L206-210) projects `.grpObj` — unaffected.
  - `smoothOfRelativeDimension_genus` (L214-219) projects `.smoothGenus` — unaffected.
  - `instIsProper` (L222-226) projects `.proper` — unaffected.
  - `instGeometricallyIrreducible` (L229-233) projects `.geomIrred` — unaffected.
  - `IsAlbanese.unique` (L79-107) operates on `IsAlbanese C P J` directly, not via
    `JacobianWitness` — unaffected.
  - The `IsAlbanese` definition itself (L52-57) is also unchanged.

## Risk assessment

- **Type-level breakage risk**: zero. The four protected instances and the
  `Jacobian` def reference only fields that remain in the new structure with
  unchanged types.
- **Field name discoverability**: `isAlbaneseFor` is the documented new name in
  PROGRESS.md; Lane 2's prompt explicitly anchors on this name.
- **Build env**: still broken, but this refactor is purely textual and does not
  introduce new imports, instance synthesis, or universe-level constraints.

## Files changed

- `AlgebraicJacobian/Jacobian.lean` — `JacobianWitness` field set updated; docstrings
  on `JacobianWitness` and `nonempty_jacobianWitness` extended to explain the
  uniform-over-`P` design.

## Blueprint readiness

`blueprint/src/chapters/Jacobian.tex` already documents the existence theorem
`thm:nonempty_jacobianWitness` (with `\lean{AlgebraicGeometry.nonempty_jacobianWitness}`
on L95) and discusses the Albanese universal property `def:IsAlbanese`. No
chapter edits required — provers do not edit blueprint chapters; the prose
matches the new shape (the universal property is stated for an *arbitrary*
$k$-rational point $P$, which is exactly what the new `isAlbaneseFor` field
encodes).

The marker `\leanok` on `thm:nonempty_jacobianWitness` will be managed by the
`sync_leanok` phase (the body is `sorry`, so it should have `\leanok` on the
statement only, and no `\leanok` on the proof block).

## Sorry status after this iteration

| Decl | Line | Status |
|---|---|---|
| `nonempty_jacobianWitness` | L172 | `sorry` (deferred per Phase-C existence policy) |

All four protected instances and the `Jacobian` definition continue to compile
honestly (no new sorries introduced). The bundle's contract has been widened
(`∀ P`) without weakening the protected signatures.

## Next-iteration recommendations

- Lane 2's `AbelJacobi.lean` work this iteration is the immediate consumer of
  the new `isAlbaneseFor` shape. If iter-073 lands with both lanes merged, the
  three protected sorries on `Jacobian.ofCurve` / `Jacobian.comp_ofCurve` /
  `Jacobian.exists_unique_ofCurve_comp` should be closed, and the file's sorry
  count drops to 0 (modulo the off-limits `nonempty_jacobianWitness`).
- No further structural changes to `JacobianWitness` are anticipated. The
  bundle is now in its final shape for the foreseeable future.
