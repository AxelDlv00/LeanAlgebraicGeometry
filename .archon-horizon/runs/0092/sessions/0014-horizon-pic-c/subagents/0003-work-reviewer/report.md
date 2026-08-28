Fresh-context adversarial audit of ONE lane's work this session. Workspace /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). Lane = pic-c, run 0092 round 6. You are READ-ONLY on source: report findings, do not edit .lean files.

MY FOUR NEW FILES, all at HEAD, all rooted in AlgebraicJacobian.lean, all claimed sorry-free and axiom-clean:
 1. AlgebraicJacobian/Picard/Pic0RingDatumEngine.lean
 2. AlgebraicJacobian/Picard/UnitEquationsTrivialClass.lean
 3. AlgebraicJacobian/Picard/Pic0VanishingRigidityReduction.lean
 4. AlgebraicJacobian/Picard/Pic0RigidityAffineReduction.lean

THE HEADLINE CLAIM I MOST WANT ATTACKED, because if it is wrong everything downstream is worthless: at genus 0, `pic0Vanishing_iff_rigidity` (file 3) says

  (forall T, Subsingleton (pic0Subgroup C T))  <->  (forall T lam, (forall K [Field K] [Algebra k K] (t : overSpec k K -> T), picEtMap C t lam = 1) -> lam = 1)

and I describe this in the header and commit message as "the degree condition is provably idle at genus 0" and "a repricing: what remains has no degree, no chi, no divisor and no chart".

ATTACK IN THIS ORDER:

(A) IS THE RIGHT-HAND SIDE VACUOUS OR TRIVIALLY TRUE? Specifically: is `hrig` perhaps ALREADY PROVABLE from landed material, which would make my "no producer" claim false and the whole file a restatement? Check `PicEtAff.unit_injective` (Picard/CechKernelLemma.lean), `relPicAlgMap_injective_of_etaleCover` (Picard/RelPicCoverInjective.lean), `pic0Subgroup_ext_of_cover`, `Pic0ZariskiSheaf.lean`, and anything about separation/injectivity of picEt or PicEtAff. My header asserts these are separation along ETALE COVERS and that "a field point is not an etale cover of A unless A is already a field" -- is that right, and is there some OTHER landed route to hrig I missed? Try `#check` / small probe files in a scratch dir (use a directory whose name contains "Scratch" so it is gitignored) rather than trusting names.

(B) IS THE RIGHT-HAND SIDE PERHAPS FALSE, making the iff prove something empty? If `hrig` were false at every curve, my equivalence would be a proof that hvan is false at genus 0 -- which would contradict the field-test results. Sanity-check the direction of the claim.

(C) IS THE "no degree remains" CLAIM HONEST? Read `fibre_eq_one_of_mem_pic0Subgroup`'s proof in file 3. Does the degree condition really get consumed there, or does it leak into `hrig` through the definition of `picEtMap`/`picEt`? Also check my converse `rigidity_of_pic0Vanishing`: does it really need no genus hypothesis, and is it actually the converse of what I claim (not a weaker statement)?

(D) FILE 4's non-converse admission. I state that `hrigAff => hrig` is proved but `hrig => hrigAff` is NOT, and that I do not claim interderivability. Verify that admission is in the right direction and that I have not silently strengthened the hypothesis (e.g. is `hrigAff` genuinely weaker or stronger than `hrig`? if it is STRONGER, my reduction is a weakening dressed as a reduction, which is the defect this workspace files most often).

(E) DUPLICATION. pic-g (run 0096) landed Picard/Pic0RingFibrewiseTrivial.lean and Picard/Pic0RingEngineFromPic0.lean in the same hours. Is any of my file 1 or 3 a duplicate of theirs, or vice versa? Also: does `picClass_eq_one_of_isUnit_eqn` (file 2) already exist somewhere in AJCR or AJC under another name? Use `"$HORIZON_BIN" search` (indexes both projects and mathlib), not just grep.

(F) EVERY OTHER FACTUAL CLAIM in the four headers and in the commit messages of the four commits (git log, they are the last several by task=pic-c). In particular: "the only producer of picClass = 1 that establishes rather than transports triviality"; "no evaluation map pi^*pi_*L -> L in AJCR, AJC or mathlib"; "SmoothOfRelativeDimension is unused in rigidity_of_rigidityAff"; the claim that classDeg's five fibre instances cannot be synthesized at a general prime.

Report findings ranked most-severe first, each with file:line, what is claimed, what is true, and how you measured it. Say plainly which claims you verified as CORRECT too -- I need to know what survived. Your final message is the report.
