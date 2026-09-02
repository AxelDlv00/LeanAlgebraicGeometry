# Related algebraic-geometry papers

This directory is the staging area for algebraic-geometry papers found outside
the two main Jacobian projects and the source-faithful textbook formalizations.
The machine-readable inventory is [`paper-catalog.yaml`](paper-catalog.yaml).
It records the exact MathSciNet identifier as a cross-reference, but all
workspace-facing names are descriptive titles/slugs.

## Categories

The list is grouped by the mathematical substrate that a future formalization
would most naturally share:

- **Abelian varieties and motives** — standard conjectures and cycle classes on
  abelian varieties.
- **Curves, Brill--Noether theory, and linear series** — secant bundles,
  syzygies, Hurwitz spaces, and Abel--Jacobi formulas.
- **Sheaves, cohomology, and intersection theory** — perverse/intersection
  complexes and purity statements.
- **Arithmetic geometry and number theory** — Mordell--Lang, Iwasawa and
  Gross--Zagier formulas, Bogomolov, Chabauty, birational sections, and
  automorphic formulas.
- **Moduli, Higgs bundles, and character varieties** — Higgs, Hitchin, local
  systems, surface-group representations, and P=W/Virasoro questions.
- **Surfaces, birational geometry, and hyper-Kähler varieties** — Enriques,
  birational/motivic invariants, and hyper-Kähler Riemann--Roch theory.

## Retrieval and project policy

Original sources are stored in the workspace-root [`references/`](../../references/)
library and registered in [`references/manifest.yaml`](../../references/manifest.yaml).
The catalog's `slug` is the intended reference directory name; MR numbers are
never used as the primary name of a new source or project.

Each entry is initially marked `project: candidate`.  A Lean package should be
created only once a source-backed theorem slice, dependencies, and an honest
formalization boundary have been selected.  At that point use the category as
the package section, for example:

```text
SubProjects/RelatedPapersFormalisation/
  CurvesAndLinearSeries/UniversalSecantBundlesSyzygiesCanonicalCurves/
```

This keeps the workspace navigable and avoids registering empty packages merely
because a paper is relevant.  The existing compactified-Picard extraction is a
legacy package; its display name is **Compactifying the Picard Scheme**, while
its old MR-based path and Lean namespace remain compatibility details until a
dedicated migration is scheduled.

## Source status

Retrieval status is authoritative in the manifest.  An entry with no verified
source is retained in the catalog as a candidate, but must not be cited from a
blueprint or used to justify a formalization claim until the source is obtained.
