Reconnaissance complete; no files changed.

- Parts 03/04/06/07/08 all use the same Part05 scaffold: umbrella module imports `Basic`, identical Lake options/toolchain, and `hgraph/config.yaml` points to `blueprint/src/content.tex`.
- Those siblings contain no real Lean declarations or actual `\lean{...}` mappings. Part01 is the useful Stacks proof precedent: small conceptual modules, narrow Mathlib imports, source-tagged docstrings, and concise `exact`/`simpa` wrappers.
- Milne is the clean mapping precedent: `\lean{Qualified.Name}` creates a formalizes link; adding `\leanok` changes the TeX node from linked to checked. Since Part05’s blueprint is frozen, retain source correspondences as hgraph comments and document the resulting unmapped-declaration sync warnings.
- Reusable APIs include `CategoryTheory.mono_comp`, pullback mono instances, `PrimeSpectrum.basicOpen_*`, `Ideal.IsPrime.mul_mem_iff_mem_or_mem`, compactness closure lemmas, and standard `IsIso` identities.

Canonical commands:

```bash
"$HORIZON_BIN" graph -p StacksPart05_TopicsInGeometry sync
"$HORIZON_BIN" graph -p StacksPart05_TopicsInGeometry stats --json
"$HORIZON_BIN" graph -p StacksPart05_TopicsInGeometry frontier --json
"$HORIZON_BIN" check --lean StacksPart05Lib/Monomorphisms.lean --json
lake build
```

Use explicit-path `$HORIZON_GIT commit ... -- <project-path>` commits because the shared ledger index is heavily polluted and contended.
