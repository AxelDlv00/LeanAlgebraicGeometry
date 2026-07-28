READ-ONLY measurement task in the Lean 4 / mathlib workspace at /home/axel/LeanAlgebraicGeometry-Horizon. Project: MainProjects/Algebraic-Jacobian-Challenge (Lean toolchain v4.31.0, mathlib pinned in .lake-packages/mathlib). Do NOT edit files.

QUESTION: what does mathlib at this pin give me toward "the quotient of a scheme by a finite group action", and specifically toward proving `HasColimit (permDiagram C n)` (a colimit of a one-object diagram `SingleObj (Equiv.Perm (Fin n)) ⥤ Scheme` whose maps are the factor permutations of `C^n`)?

Measure each of these and report EXACT declaration names + file:line + signature. Say clearly EXISTS / DOES NOT EXIST for each. Use the horizon search CLI:
  cd /home/axel/LeanAlgebraicGeometry-Horizon && /home/axel/.archon-env/bin/horizon search "<query>" --json
and grep inside /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/.lake-packages/mathlib/Mathlib/ (adjust path if the mathlib source lives elsewhere — find it first).

1. RING-THEORETIC INVARIANTS. Does mathlib have `Algebra.IsInvariant` (file Mathlib/RingTheory/Invariant/*.lean)? List its main theorems, especially: transitivity of the G-action on primes lying over a fixed prime of the invariant subring; integrality of S over S^G; surjectivity of Spec S → Spec S^G; anything about `FixedPoints.subalgebra` / `FixedPoints` and `IsIntegral`.

2. SCHEME-LEVEL QUOTIENTS. Search for any scheme quotient by a group action in mathlib: `AlgebraicGeometry` + quotient / `GroupAction` / `Quotient` / orbit. Does anything like `Scheme.quotient`, an action typeclass on schemes, or a quotient of a scheme by a finite group exist? Report DOES NOT EXIST if so.

3. COLIMIT AVAILABILITY IN `Scheme` at this pin. Check by actually elaborating a small Lean file with `mcp__lean-lsp__lean_run_code` (imports Mathlib). Test each of these instance queries and report which synthesize:
   - `HasCoproducts AlgebraicGeometry.Scheme` / `HasCoproduct` for a `Fin n`-family
   - `HasCoequalizers AlgebraicGeometry.Scheme`
   - `HasPushouts AlgebraicGeometry.Scheme`
   - `HasColimitsOfShape (CategoryTheory.SingleObj G) AlgebraicGeometry.Scheme` for `G := Equiv.Perm (Fin 2)`
   - Also: does `Scheme` have coequalizers of *open immersions* or any partial pushout API (e.g. `AlgebraicGeometry.Scheme.Pushout`, pushouts along closed immersions, `Scheme.GlueData`)? Report the exact names of what exists in Mathlib/AlgebraicGeometry/ for gluing (`GlueData`, `Cover`, `OpenCover`, `Scheme.GlueData.glued`, `GlueData.openCover`, `Scheme.Cover` API), with signatures.
   Use a SINGLE lean_run_code call with many `example : ... := inferInstance` lines if possible; if it errors, split. Report verbatim which succeeded/failed.

4. AFFINE SPEC-OF-INVARIANTS. Is there anything in mathlib saying `Spec (A^G)` is a categorical quotient of `Spec A` in the category of schemes, or that `Spec A → Spec A^G` is surjective/closed with fibres the orbits? Also check for `Mathlib/AlgebraicGeometry/Morphisms/Integral` or `IsIntegralHom` and `SpecMap` surjectivity from integrality (`Ideal.exists_ideal_over_prime`...). Report names.

5. THE CURVE INPUT. Does mathlib (or the AJC project) have: "a smooth proper curve minus a nonempty finite set of closed points is affine", or "any finite set of points of a curve is contained in an affine open"? Search both. Also search for `Scheme.IsAffineOpen` + finitely many points, `exists_affine_open_containing`, `separated ... affine open containing two points`. Report EXISTS/DOES NOT EXIST.

6. Finally: in the AJC project itself and its sibling MainProjects/Algebraic-Jacobian-Challenge-Rebuild and SubProjects/, is there ANY existing work on quotients by finite group actions of schemes, `Spec` of invariants, or symmetric powers of schemes beyond AlbaneseUP.lean / SymPowColimit.lean / SymPowInterface.lean? Search "invariant subring", "fixed points", "quotient scheme", "GlueData".

Report as a numbered list, then a final section "FEASIBILITY" of at most 8 sentences: which of the two standard routes (a: affine quotient Spec of invariants + glue via Scheme.GlueData; b: something cheaper) is actually available at this pin, and what the single largest missing input is. Be concrete and do not speculate beyond what you measured.
