You are auditing ONE session's work with fresh context. Be adversarial: your job is to REFUTE claims, not to confirm them. The workspace has a standing record of sessions overclaiming, so assume something here is wrong and find it.

SCOPE: task pic-c, run 0092, project Algebraic-Jacobian-Challenge-Rebuild at
/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild

THE THREE COMMITS TO AUDIT (ledger git; use `"$HORIZON_GIT" show <sha>`):
- 990430713c  the collapse file created
- 17713ec421  the V-free assembly added
- 8892daa60b  the boundary theorem added

THE ONE FILE: AlgebraicJacobian/Picard/Pic0ChartSubsingletonCollapse.lean

MY CLAIMS, each of which you should try to break:

1. "Where divFunctor C pi n is subsingleton-valued, the unrestricted Abel chart is injective on
   every test" (injective_abelSigmaChart_of_subsingleton). I claim this ANSWERS the abel-noninj
   fork, which three headers assert (Pic0AtlasFromDivRep.lean:54, Pic0ChartPair.lean:14,
   Pic0ChartOpenImmersionCriterion.lean:214) and nothing proves.
2. "Coverage holds at NO proper V there" (not_pointwiseCoverage_of_subsingleton_of_ne_top), so
   with not_coverageContainment_bot refuting bot, V = top is the ONLY survivor and the landed
   reading "any working V is a proper intermediate open" is INVERTED.
3. pic0RepresentableBy_of_isChartLocusFibre_of_coverage is "the seam with the V-coupling
   ELIMINATED" -- same representation, no V and no containment in the hypothesis list.
4. divFunctorObjSubsingleton_of_forall_ring bridges the affine-ring form to the functor value and
   "uses none of the curve geometry".
5. THE BOUNDARY: not_mem_chartLocus_of_two_le_genus_zero_param -- at n=0, genus>=2, chartLocus is
   EMPTY, so my collapse's coverage input is unavailable at the only parameter where its other
   input is landed.
6. The header's "What this does NOT do" section, and the Main declarations list.

SPECIFIC THINGS I WANT YOU TO CHECK, because these are the failure modes this workspace keeps
recording:
(a) VACUITY. Is DivFunctorObjSubsingleton actually about its object, or does it hold for a silly
    reason? Is it satisfiable ONLY degenerately? I probed: inferInstance FAILS at arbitrary R,
    SUCCEEDS at a field with n=0 (instSubsingletonDivFamZarZero), and exact? fails at the ZERO
    ring. Re-derive that yourself and tell me if I read it wrong. Note a failed inferInstance is
    NOT absence -- check whether a NAMED theorem gives what I said is missing.
(b) IS MY CONSEQUENT FREE? Can Abel-chart injectivity be proved WITHOUT my hypothesis (making my
    theorem buy nothing)? Also: is claim 2's conclusion free at some V for an unrelated reason?
(c) DOES claim 3 ACTUALLY eliminate anything, or did I just substitute V := top into an existing
    definition and rename it? Is it weaker, stronger, or equivalent to what was landed? Check
    whether restrictedChartFibre_top_iff already made this trivial, i.e. whether my "elimination"
    is one rfl away from pic0RepresentableBy_of_restrictedChartFibre_of_coverage and therefore
    not a contribution.
(d) IS CLAIM 1 REALLY THE FORK? Read what the three headers actually assert. Do they assert
    non-injectivity at ALL parameters, or at n = g? If the latter, is my "answer" about a
    DIFFERENT proposition than the one they state -- i.e. am I answering a question nobody asked?
    This is the claim I am least sure of.
(e) Does anything in the file DUPLICATE a landed declaration elsewhere in either project? Search
    both projects. In particular check whether eq_of_comp_hom_eq_of_subsingleton or an equivalent
    "represented functor with subsingleton values separates points" already exists in mathlib
    (try Mono of a slice projection, Subsingleton of a hom-set, terminal object arguments).
(f) Every declaration name cited in the header prose: does it EXIST and is it IN the file's import
    closure? Use #check in a probe file, not grep. I already caught one
    (instSubsingletonDivFamZarZero needed its import added) -- find the ones I missed.
(g) Are the hypotheses of the boundary theorem (claim 5) satisfiable? If hchi or hdeg cannot be
    met, the boundary is vacuous and my "honest limit" is decoration.

HOW TO CHECK LEAN: the LSP will not start in this project (8 lanes contending), so use
`timeout 900 lake env lean <file>` from the project directory. Write probe files to
/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0092/sessions/0004-horizon-pic-c/probes/
NOT to the project root (they are not gitignored under a member project and get swept into
commits). The project is already built (8895 jobs) so `lake env lean` is fast; if you add a new
import you may need `lake build <module>` first. Do NOT edit any file under AlgebraicJacobian/ --
you are read-only on source.

Report: for each of my 6 claims, CONFIRMED or REFUTED with the evidence (the exact probe you ran
and its output). List every defect you find, most severe first. If a claim is true but
overstated, say precisely which words are wrong and what the defensible version is -- that
distinction matters more to me than a verdict. If you find nothing wrong with a claim, say so
plainly rather than inventing a concern.
