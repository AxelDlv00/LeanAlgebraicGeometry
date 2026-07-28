You are measuring the Lean state of ONE narrow question in the project at
/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild
(Lean 4 + mathlib; source tree under `AlgebraicJacobian/`).

READ-ONLY. Do not edit any file. Do not run `lake build` (another lane may hold a build mutex).
You may use grep/find/read and the horizon declaration search:
  cd /home/axel/LeanAlgebraicGeometry-Horizon && "$HORIZON_BIN" search "<words>" --json

THE QUESTION. I just landed `AlgebraicJacobian/Picard/Pic0ChartCoveragePointwise.lean`, whose
theorem `chartsCoverLocally_of_pointwise` needs, for every scheme T, every section
`s : (pic0SigmaSheaf C).1.obj (op T)`, and every point `t : T`, this four-part datum:

  ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme) ⟶ X i),
      (f i).app (op (W : Scheme)) x = (pic0SigmaSheaf C).1.map (W.ι).op s

I need to know precisely how much of that the tree can already produce when the chart family
is the Abel chart family. Report on FIVE things, each with `file:line` evidence:

1. `abelSigmaChart` — find its definition (likely `Picard/Pic0AtlasFromDivRep.lean` or
   `Picard/DivSchemeAbel.lean`). What is its source scheme, and what does its `.app` do to a
   morphism into that source? I want the exact statement of any `abelSigmaChart_app` /
   simp lemma that computes it, quoted verbatim.

2. Is there ANY lemma in the tree producing a MORPHISM into the divisor scheme
   (i.e. an element of `(W : Scheme) ⟶ D.left` for `rep : (divFunctor C π n).RepresentableBy D`)
   from divisor-family data over W? Search for `RepresentableBy.homEquiv`, `divFunctor`
   sections, `divFamZar` → morphism bridges. Quote the best candidate's full signature.

3. `chartLocusOpens` (`Picard/Pic0ChartUnivReduce.lean:90`) takes a hypothesis `haff`. Is there
   ANY lemma in the tree that DISCHARGES that `haff` (the affine-local openness) for a general
   test — i.e. produces `∀ U : T.left.affineOpens, IsOpen (chartLocus C m Z (picEtMap C
   (Over.fromSpecAffine T U) lam))` — or is it always passed as an argument? Check
   `Pic0ChartLocusOpen.lean`, `Pic0ChartLocusIsOpen.lean`, `Pic0ChartLocusGeneralTest.lean`,
   `Pic0ChartLocusIsoInvariance.lean`. This decides whether `W` is really free.

4. A TYPE-LEVEL mismatch I need measured. `chartLocus` is a set of points of `T.left` where
   `T : Over (Spec (.of k))`, but `chartsCoverLocally_of_pointwise` quantifies over
   `T : Scheme` (a BARE scheme, big site) and `W : T.Opens`. How does the tree bridge a bare
   big-site test scheme to a slice object `Over (Spec (.of k))`? Look at how
   `pic0SigmaFunctor` / `Over.sigmaExtension` works (`Picard/Pic0SigmaSheaf.lean:76`,
   `Picard/OverSigmaExtension.lean`) — a section over a bare `T` is a PAIR
   `⟨a : T ⟶ Spec k, class over Over.mk a⟩`. Confirm or refute: given a bare `T` and a section
   `s`, the slice object one gets is `Over.mk s.1`, and its `.left` is `T` itself. Quote the
   relevant `sigmaExtension` definition/simp lemmas.

5. Count `sorry` as a TERM (not in docstrings) in these files, reporting each file's count:
   Pic0ChartCoveragePointwise.lean, Pic0ChartLocalSurjectivity.lean, Pic0ChartUnivReduce.lean,
   Pic0ChartOpenImmersionCriterion.lean, Pic0ChartPair.lean, Pic0AtlasFromDivRep.lean,
   Pic0ChartLocus.lean, Pic0SigmaSheaf.lean.
   Use: grep -n '\bsorry\b' <file> and then judge for each hit whether it is inside a comment
   or docstring. Report honestly.

Report concisely and factually with file:line for every claim. If something does not exist,
say "does not exist" plainly rather than describing what a substitute does. Do not speculate
about mathematics; I need the measurement.
