Work in /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (Lean 4 + mathlib project, "AJCR"). READ ONLY — do not edit any file, do not commit.

I need a precise inventory of the machinery available for computing the Picard group of P^1 over a base, in this project's own vocabulary. Answer these questions with exact declaration names, file:line, and full statements (copy the signature text):

1. `AlgebraicJacobian/Picard/Pic.lean`: what exactly is `Scheme.CechPic X`? Give the definition chain (PointedCover, unitsH1, CechPic, mk, map). Is it a colimit/quotient over all pointed covers, or fixed to one cover? What is `Pic.lean:258`'s Subsingleton lemma and its hypotheses?

2. Is there any lemma anywhere in the project saying that every `CechPic` class is `mk` of a *given/specified* cover (a cofinality or refinement statement), or that a two-element cover computes `CechPic` (e.g. in `AlgebraicJacobian/Cohomology/TwoCover.lean` or `Picard/AffineTwoCover.lean`, `Picard/CechH1.lean`)? Give exact names and statements.

3. What does `AlgebraicJacobian/Curve/P1Charts.lean` provide (the "Laurent span" result), and what does `AlgebraicJacobian/Curve/P1H1Vanishing.lean` prove and how? Copy the main statements.

4. Does anything in the project compute `CechPic` or `relPic` or `picEt` or `pic0Subgroup` of P^1 (or of any explicit scheme) — trivially or otherwise? Search for statements of the form `Subsingleton (CechPic ...)`, `Subsingleton (relPic ...)`, `relPic ... ≃* ℤ`, degree isomorphisms, `Pic ... ≅ ℤ`. Report every hit with statement and hypotheses.

5. Anything about units of Laurent polynomial rings / `B[x,x⁻¹]ˣ`, or `Pic(B[x])`, in the project or in mathlib (use `"$HORIZON_BIN" search "<query>" --json` which indexes mathlib too, and the lean-lsp MCP tools lean_leansearch / lean_loogle). Specifically: does mathlib know Pic of a polynomial ring, units of Laurent polynomials over a commutative ring, `Polynomial.isUnit_iff`, `LaurentPolynomial` unit classification?

6. `AlgebraicJacobian/Picard/PicEt.lean:105` `picEt` definition and `picEt.ext`; and `AlgebraicJacobian/Picard/PicEtAff.lean` `descentClasses`, `PicEtAff`, plus `picEtAffineEquiv`. Copy the signatures so I know exactly what a `picEt C T` element IS.

Report as a compact structured inventory. Be exact about names and hypotheses; do not speculate about what "should" exist — say "not found" and say which query you ran.
