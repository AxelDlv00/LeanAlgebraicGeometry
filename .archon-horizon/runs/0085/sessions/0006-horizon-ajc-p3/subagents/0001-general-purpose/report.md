You are pricing ONE Lean obligation for prover lane ajc-p3. Read-only: do NOT edit any file. Report findings as text.

Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (Lean 4, mathlib v4.31 at /home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib).

TARGET. `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:~525` holds the project's single seam `sorry`:

theorem fgaPicardRepresentability (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] :
  (∃ X, Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧ LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
  ∧ (HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) := sorry

QUESTION: exactly how expensive is CLAUSE (2) alone — `HasRationalPoint C → IsIso (PicScheme.picEtComparison C)` — given ONLY what is already landed in this project and in mathlib? If it can be split off and PROVED, the seam becomes a one-clause obligation, which is worth a lot. I need a measurement, not an opinion.

Do this:
1. Read `Picard/PicEtSubcanonical.lean` in full. It proves `isIso_picEtComparison_of_isSheaf` (comparison is iso when `relPresheaf C` is an etale sheaf) and `relPresheaf_isSheaf_of_representableBy`. So clause (2) reduces to: under a rational point, `Presheaf.IsSheaf (etaleTopologyOver k) (PicSharp.relPresheaf C)`.
2. Read `Picard/RelPicFunctor.lean` around `relPresheaf`, `relPicSetoid`, `relPicRel` to learn the EXACT Lean encoding of the quotient (what the equivalence relation is, in terms of which objects).
3. Measure whether the rigidification route is available: with a rational point x0 : Spec k -> C we get a section s : T -> C x_k T of the projection, hence a retraction s^* of pullback on Picard groups, hence relPresheaf(T) is isomorphic to ker(s^*). Search (use `"$HORIZON_BIN" search "<words>" --json`, which covers BOTH projects AND mathlib; also grep) for: whether this project already has (a) the splitting/retraction of `pullback` along a section on Picard groups, (b) any rigidified relative Picard functor, (c) effective descent of line bundles / quasi-coherent sheaves along an etale covering in mathlib at the level this file would need, (d) `H^0(C_T, O^*) = Gamma(T,O^*)` type statements for proper geometrically integral fibres.
4. Report the SHORTEST honest chain from landed material to clause (2), naming each missing brick with its exact Lean statement shape, and give a verdict: closable in one session / needs N named bricks / blocked on a genuinely absent theorem.

CRITICAL RULES. Names that appear only in docstrings may not exist: verify each cited declaration with `#check` inside `lean_run_code` (mcp__lean-lsp__lean_run_code) or via `"$HORIZON_BIN" search`, NOT by grep alone — a declaration can exist in source and still be outside a file's import closure. Do not claim absence from a single case-sensitive grep. Report exactly what you verified and how.
