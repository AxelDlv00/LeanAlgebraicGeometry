# Refactor — root imports + import narrowing

Two small, safe structural edits. No proof changes; do NOT insert sorry anywhere.

## Task 1 — add both new files to the build root
The build root is `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian.lean`. It currently
imports the Cohomology files but is missing the two new ones. Add these two lines after the
existing `import AlgebraicJacobian.Cohomology.CechToCohomology` line:

```
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohTildeSections
```

## Task 2 — narrow the whole-library import in QcohTildeSections.lean
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
currently has `import Mathlib` (line ~6), a full-library import. Narrow it to exactly what the
4 declarations need. The file's only Mathlib dependency is the tilde construction
`AlgebraicGeometry.Modules.Tilde` plus `asIso`/`IsIso` basics. Replace `import Mathlib` with:

```
import Mathlib.AlgebraicGeometry.Modules.Tilde
```

If after this change `lake env lean AlgebraicJacobian/Cohomology/QcohTildeSections.lean` reports
a missing identifier (e.g. `asIso`, `IsIso`, `ConcreteCategory`), ADD the minimal extra
`import Mathlib.<...>` line(s) needed to restore a clean build — do not revert to `import Mathlib`.
The file must build clean (EXIT 0) after narrowing.

## Verification
After both tasks, run `lake env lean` on each changed file (root + QcohTildeSections) and confirm
EXIT 0 (a full `lake build` may be slow; per-file `lake env lean` is enough to confirm the imports
resolve). Report the final import block of QcohTildeSections.lean and confirm both new files are in
the root. Do NOT touch any other file, do NOT modify any declaration body.
