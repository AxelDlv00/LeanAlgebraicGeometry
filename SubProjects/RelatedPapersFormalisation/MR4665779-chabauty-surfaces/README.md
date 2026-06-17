# Mr4665779 A Chabauty Coleman Bound For Surfaces

<!-- archon:readme -->

## Project

This project formalizes parts of Jerson Caro and Hector Pasten's paper "A Chabauty-Coleman bound for surfaces". The paper extends explicit Chabauty-Coleman bounds from curves to certain smooth projective surfaces embedded in abelian varieties of Mordell-Weil rank at most one, proving local `Q_p` bounds and global rational-point consequences in terms of the reduction `X'(F_p)` and the Chern number `c_1^2(X)`. The formalization is currently at the scaffold stage: the source paper and TeX are available under `references/`, while Lean declarations and blueprint content still need to be generated.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `MR4665779AChabautyColemanBoundForSurfaces/` - main Lean source
- `blueprint/` - leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` - PDFs, papers, and informal notes backing the formalization
- `archon-protected.yaml` - declarations agents must not modify
- `.archon/` - agent state (not committed)

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
