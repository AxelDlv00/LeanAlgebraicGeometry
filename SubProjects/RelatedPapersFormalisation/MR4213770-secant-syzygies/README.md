# Mr4213770 Universal Secant Bundles And Syzygies Of Canonical Curves

<!-- archon:readme -->
<!-- Claude fills in the prose sections below. Keep the section headers. -->

## Project

This project formalizes the main algebraic-geometric architecture of Michael Kemeny's paper "Universal Secant Bundles and Syzygies of Canonical Curves." The target mathematics is the construction of universal secant bundles and their use in proving syzygy results for canonical curves: Voisin's theorem for general canonical curves, the even-genus structure theorem for the last nonzero syzygy space of K3 sections, and the resulting geometric syzygy conjecture in even genus.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `MR4213770UniversalSecantBundlesAndSyzygiesOfCanonicalCurves/` — main Lean source
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` — PDFs, papers, and informal notes backing the formalization
- `archon-protected.yaml` — declarations agents must not modify
- `.archon/` — agent state (not committed)

## How to build

```bash
lake exe cache get   # download Mathlib olean cache
lake build           # compile the project
```

## How to run the formalization loop

```bash
archon loop .
```

This launches the plan → prove → review loop and opens a dashboard.
