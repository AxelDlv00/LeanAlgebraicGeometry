You are inspecting the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (call it AJCR). READ-ONLY: do not edit any file, do not run `lake build` (a sibling lane holds the build mutex). You may run `grep`, read files, and use `/home/axel/.archon-env/bin/horizon search "<query>" --json`.

I need an exact, verified inventory of the API for one proof obligation. The obligation, clause (iii-c2) of a Čech/Picard argument:

  Let X be a scheme with two opens V : Bool → X.Opens, V false ⊔ V true = ⊤, both AFFINE.
  Let L : X.CechPic be a class such that L restricted to each chart V s is trivial,
  i.e. `Scheme.CechPic.map (V s).ι L = 1` for s : Bool.
  GOAL: L = Scheme.CechPic.mk (twoChartCover V sel hmem) a for some `a : X.unitsH1 _`,
  i.e. L is REPRESENTABLE ON THE TWO-CHART COVER.

Report, for each item, the FULLY QUALIFIED NAME, the EXACT signature (copy it), and file:line. Say plainly "NOT FOUND" when you cannot find something — do not guess a plausible name, and do not report a name you have not seen in a file. Distinguish carefully between a lemma about `CommRing.Pic` of a ring and a lemma about `X.CechPic` of a scheme.

1. `AlgebraicJacobian/Picard/EffectivityMoving.lean`: report every declaration in the file with signature, especially anything named like `Opens.cechPicClass`, `cechPicMap_ι_eq_one_of_cechPicClass_eq_one`, `Opens.cechPicClass_of_le`. What EXACTLY do they say? Is there anything that goes from "trivial on each member of a cover" to "representable on that cover"?

2. Is there ANY lemma in the tree of the shape "a CechPic class trivial on every member of a pointed cover is `CechPic.mk` of a class on that cover" (or: is in the image of `CechPic.mk 𝒰`)? Search hard — this is the crux. Try horizon search with several phrasings ("locally trivial class is represented on the cover", "trivialization of a Picard class on a cover", "cechPicEquivPic", "TrivializingFamily"). Look at `Picard/CechPicSurjective.lean` in particular and report what `Scheme.TrivializingFamily` is (full structure fields) and what the surjectivity theorem there actually states with all its hypotheses.

3. What is `Scheme.cechPicEquivPic`? Exact statement, hypotheses (does it need `IsAffine`?), file:line.

4. What is the API for restricting a `CechPic` class to an open? Is it `CechPic.map (V s).ι`? Report the exact spelling used in the tree for "the restriction of a Picard class to an open subscheme", with an example call site. Is there an `X.Opens` → scheme coercion, and what is `.ι`?

5. Report anything about `AffineTwoCover` (search for it): the structure, its fields, and `AffineTwoCover.nonempty_of_curve` if it exists.

Be terse and factual. Signatures and file:line, minimal prose. Your final message is the report.
