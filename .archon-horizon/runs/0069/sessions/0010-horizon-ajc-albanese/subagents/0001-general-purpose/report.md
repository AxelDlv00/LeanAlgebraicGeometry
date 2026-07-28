You are surveying the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (AJC). READ ONLY — do not edit any file.

GOAL: determine, precisely and with file:line evidence, whether the Abel–Jacobi morphism `C ⟶ Scheme.Pic0Scheme C` can be CONSTRUCTED from what already exists in the tree. I need to know exactly what universal property / moduli interface `Scheme.PicScheme C` and `Scheme.Pic0Scheme C` come with.

Answer these, each with file:line and the exact Lean signature:

1. How is `Scheme.PicScheme C` defined, and what is the representability interface? Look in AlgebraicJacobian/Picard/. Find the class `Scheme.HasPicScheme` and any natural isomorphism / equivalence between the relative-Picard functor (picSharp / PicSharp.relPresheaf / Pic0Et etc.) and `Hom(-, PicScheme C)`. Give me the exact name and statement of the Yoneda-style bridge: i.e. is there something that turns an element of the relative Picard group of C×T/T into a morphism T ⟶ PicScheme C, and vice versa? Is it stated as an iso of functors, an `Equiv`, or only as a `Nonempty`?

2. How is `Scheme.Pic0Scheme C` defined (file:line, definition body)? Is it a subscheme / open subscheme / kernel of a degree map inside `PicScheme C`? What is the inclusion morphism called? What is the interface for producing a morphism `T ⟶ Pic0Scheme C` from a morphism `T ⟶ PicScheme C` plus a "degree zero" condition? Give exact names.

3. `PicScheme.degree` — ajc-pic0av reportedly just closed it (commit 23b263f3c). What exactly exists now: signature, is it sorry-free (check with `#print axioms` via the lean LSP tool `mcp__lean-lsp__lean_verify` if cheap, or just report the sorry state of the file), and does it relate to Pic0Scheme?

4. Does the tree have the line bundle `O(Δ − {P0}×C − C×{P0})` on `C × C`, or ANY construction of a line bundle from a divisor on a product, or the diagonal divisor? Search for: diagonal divisor, `DifferenceMap` (there is AlgebraicJacobian/Albanese/DifferenceMap.lean — report what it contains), Poincaré bundle, `poincare`, rigidified line bundle, `LineBundle` API in the project.

5. Concretely: list every declaration in the project that PRODUCES a morphism into `PicScheme C` or `Pic0Scheme C` from geometric data. Is there any at all?

Use `"$HORIZON_BIN" search "<query>" --json` (HORIZON_BIN=/home/axel/.archon-env/bin/horizon, run from /home/axel/LeanAlgebraicGeometry-Horizon) for declaration search — it indexes the whole workspace and mathlib. Also grep the Picard/ directory directly. Also check the sibling project MainProjects/Algebraic-Jacobian-Challenge-Rebuild for an Abel–Jacobi construction (search "abelJacobi", "AbelJacobi").

Report compactly: numbered answers, exact signatures, file:line. End with a one-paragraph verdict: is constructing `abelJacobi` feasible today from in-tree material, and if not, name the single missing brick.
