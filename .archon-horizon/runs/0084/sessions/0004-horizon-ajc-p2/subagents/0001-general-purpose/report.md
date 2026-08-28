You are auditing Lean 4 code in the project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (module root `AlgebraicJacobian`). READ ONLY — do not edit any file.

QUESTION. `AlgebraicJacobian/Jacobian.lean:424` has a bare `sorry` for
  `smoothOfRelativeDimension_genus_pic0Et (C) : SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom`
Its docstring (Jacobian.lean:406-423) claims that the landed dimension chain
`Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` "is stated for `Pic0Scheme`, so transporting it to `Pic0SchemeEt` needs the comparison of the two Picard schemes, which is available only under a section."

I need to know whether that claim is TRUE, i.e. whether the tangent-space/cotangent chain is genuinely picSharp-specific, or whether its proof only consumes a generic `RepresentableBy` datum plus facts that hold for `picEt` too.

WHAT TO DO, by reading declarations (use grep to locate, then read the actual statements and proof bodies):
1. Find `Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` in `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`. Report its exact statement (all binders) and its proof body.
2. Walk its proof chain UPWARD one or two levels: for each lemma it invokes (e.g. `finrank_cotangentSpaceDual_eq_finrank_h1Cok`, `tangentSpaceIso`, `semilinearComparison_cotangentSpaceDual_h1Cok`, `pointedDualNumberPoints_equiv_*`, and anything else its body names), report (a) the exact statement, (b) whether it is `sorry`-bodied, (c) precisely WHICH picSharp-specific objects it mentions — `Scheme.PicScheme C`, `Scheme.HasPicScheme C`, `PicScheme.picSharp`, `PicScheme.representable`, `Pic0Scheme` — versus which are generic (a `RepresentableBy` datum, `GroupScheme.IdentityComponent`, `Sheaf.HModule`, `genus`).
3. Answer precisely: is the dependence on picSharp (i) only through the name of the representing scheme (so a `Pic0SchemeEt`-shaped restatement would go through verbatim by substituting `representableEt` for `representable`), or (ii) genuinely through a computation of the functor `picSharp` at dual numbers / on a specific test object that would have to be redone for `picEt`? Quote the lines that decide it.
4. Separately: locate the declaration that computes the functor's value on dual numbers (search for "DualNumber", "dualNumber", "pointedDualNumberPoints"). Report whether that computation is stated for `picSharp` specifically, and whether the analogous statement for `PicScheme.picEt` exists anywhere in the project.
5. Also report: does `Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` currently report `sorryAx`? (Look at whether anything in its chain is `sorry`-bodied — do not run a build, just read.)

Report concisely and factually with `file:line` citations for every claim. Do NOT speculate about cost; report what the code says. If a declaration a docstring names does not exist, say so explicitly.
