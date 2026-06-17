# AlgebraicJacobian — Flat base change ($i=0$) & the section graded ring

<!-- archon:readme -->

## Project

A formalization in Lean 4 + Mathlib of two Čech-independent foundations of the FGA
representability of the Picard scheme:

- **FBC-B** — *flat base change for the pushforward of a quasi-coherent sheaf in degree
  $0$*: the base-change map `g* f_* F ⟶ f'_* g'* F` is an isomorphism (Stacks 02KH(2),
  the $H^0$-with-base-change case), via the global-sections / finite-equalizer route.
- **SNAP** — *the section graded ring* `Γ_*(X,L) = ⊕_{n≥0} Γ(X, L^{⊗n})` assembled as a
  graded commutative semiring and graded module (Stacks 01CV).

This project was **extracted** from the parent *Quot-Foundations* project (itself a leg of
Christian Merten's Algebraic-Jacobian-Challenge). It bundles the FBC-B and SNAP work
packages; all Lean names, file paths and blueprint `\label{}`/`\lean{}` names are unchanged
from the parent, so proved results merge back as a three-way merge.

**Targets (the extraction seeds):**

| Blueprint node | Lean declaration |
|---|---|
| `thm:flat_base_change_pushforward` | `AlgebraicGeometry.flatBaseChange_pushforward_isIso` |
| `thm:fbcb_global_direct` | `AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv` |
| `lem:affine_base_change_pushforward` | `AlgebraicGeometry.affineBaseChange_pushforward_iso` |
| `lem:sectionGradedRing_gcommSemiring` | `AlgebraicGeometry.sectionGradedRing_gcommSemiring` |
| `lem:sectionGradedModule_gmodule` | `AlgebraicGeometry.sectionGradedModule_gmodule` |

The graded-ring seeds are wired but unproved; their closure pulls in the still-sorried
cast/coherence chain (`def:sectionsCast`, `lem:sectionsCast_refl`,
`lem:gradedMonoid_eq_of_cast`, `lem:sectionMul_coherent`) and the FBC reduction lemmas
(`lem:flat_base_change_reduce_global_sections`, `lem:base_changed_equalizer_diagram`, …).

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — flat base change for `f₊` (i = 0): the
  base-change map, tilde-transport, the affine case, Mayer–Vietoris/separated reductions
- `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean` — the direct global-sections capstone
  (`thm:fbcb_global_direct`)
- `AlgebraicJacobian/Cohomology/RegroupHelper.lean` — a linear-algebra regrouping helper imported
  by `FlatBaseChange.lean`
- `AlgebraicJacobian/Picard/SectionGradedRing.lean` — `Γ_*(X,L)` graded comm-semiring & module
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` — informal sources backing the formalization
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
