You are surveying available infrastructure in a Lean 4 / mathlib workspace. Do NOT edit any file. Report findings concisely with exact declaration names, file paths and line numbers.

Workspace root: /home/axel/LeanAlgebraicGeometry-Horizon
Main project: MainProjects/Algebraic-Jacobian-Challenge (Lean, imports `Mathlib` wholesale)
Sibling trees to search: MainProjects/Algebraic-Jacobian-Challenge-Rebuild, SubProjects/Albanese, SubProjects/* generally.
mathlib checkout: MainProjects/Algebraic-Jacobian-Challenge/.lake-packages/mathlib (or .lake/packages/mathlib — find it).

Use the workspace search CLI where useful: `/home/axel/.archon-env/bin/horizon search "<words>" --json` (spans all projects + mathlib), plus ripgrep on the mathlib checkout.

QUESTIONS — answer each with concrete names or an explicit "absent":

1. In mathlib at this pin, what exists for **the invariant subring / subalgebra of a group action on a commutative ring**, and for **Spec of the invariants as a quotient of a scheme by a finite group action**? Look for: `FixedPoints.subfield`, `FixedPoints.subring`, `Algebra.FixedPoints`, `MulSemiringAction`, `IsInvariant`, `AlgebraicGeometry` quotient by group action, `Scheme.quotient`, geometric quotient, `MulAction` on `Scheme`.

2. Does mathlib have an **n-fold tensor product of commutative algebras** as a commutative ring/algebra, i.e. `⨂[R] i:ι, A i` with a `CommRing`/`Algebra` instance, and a **permutation/reindexing algebra equivalence** on it (not merely a linear equiv)? Look for `PiTensorProduct` algebra instance, `Algebra.PiTensorProduct`, `PiTensorProduct.reindex`, `MvPolynomial`-based alternatives, `FreeCommRing`. Report whether an S_n action on the n-fold tensor power of a commutative ring is available as `MulSemiringAction` or similar.

3. In mathlib, what colimits exist in `CommRingCat`, `Under R` (R : CommRingCat), `CommAlgCat`/`AlgebraCat`, and `AffineScheme`? Specifically: does `HasColimits (Under R)`, `HasLimits (Under R)`, `HasLimits CommRingCat`, `HasColimits AffineScheme`, `HasLimits AffineScheme` synthesize? Also: `AffineScheme.equivCommRingCat`, `Over.opEquivOpUnder`, `CategoryTheory.Over.opEquiv…` — give exact names and statements of the equivalences relating `(Under R)ᵒᵖ` to affine schemes over Spec R.

4. In the two sibling trees (Rebuild, SubProjects/Albanese) is there ANY material on: symmetric powers of schemes / `Sym^n`, quotients by finite group actions, `Scheme.GlueData` assembled from affine pieces, S_n-stable affine open covers, or `permDiagram`-like constructions? List files and the key declarations, and say whether they are sorry-free (grep for `sorry` as a term).

5. Anything in mathlib about **a finite set of points of a quasi-projective / projective scheme lying in a common affine open**, or **intersection of two affine opens in a separated scheme is affine** (`AlgebraicGeometry.IsAffineOpen.inter`?), or `IsAffineOpen` closure properties. Exact names.

Keep the report under ~800 words, organized by question number, names + paths only, no prose padding.
