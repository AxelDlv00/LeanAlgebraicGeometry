You are a fresh-context adversarial reviewer. Audit TWO Lean files just committed to the project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). READ-ONLY: do not edit, do not commit.

The files (both at git HEAD, both claimed 0 sorries, rooted in AlgebraicJacobian.lean):
 1. AlgebraicJacobian/Picard/Pic0RingFibrewiseTrivial.lean
 2. AlgebraicJacobian/Picard/Pic0RingEngineFromPic0.lean

CONTEXT. The project wants `hvan : ∀ T, Subsingleton (pic0Subgroup C T)`, which is equivalent (landed) to the same at affine tests `overSpec k A`. The FIELD instances are closed at genus 0 (Picard/Pic0VanishingFieldTest.lean). The RING case is open. Another lane landed Picard/Pic0RingDatumEngine.lean, which fires a rigid engine under a fibrewise binder `htriv : ∀ p : PrimeSpectrum B, (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1`. My two files claim to (1) prove the fibrewise triviality from a pic0 membership and (2) discharge the engine's binder, yielding `π_*L` invertible (rankAtStalk H^0 = 1) with no fibrewise hypothesis.

AUDIT THESE SPECIFIC RISKS, and for each give a VERDICT with file:line evidence:

A. **VACUITY / DEGENERACY.** Is any headline statement vacuous or trivially true?
   - `pic0_fibre_eq_one_of_genus_zero` concludes `pic0Map C t lam = 1`. Is the TARGET group `pic0Subgroup C (overSpec k K)` possibly a subsingleton for a trivial reason making the statement content-free? Note the proof IS `Subsingleton.elim` — so ask sharply: is this theorem anything more than a restatement of the landed field-test vanishing? If it is only a specialization, say so plainly.
   - Are the hypotheses of `rigidEngine_of_pic0` / `rankAtStalk_hModule_zero_eq_one_of_pic0` jointly satisfiable at a NON-degenerate value? The presentation hypothesis `h : picEtAffineEquiv C B lam = PicEtAff.unit C B (relPicMk C _ D.cechPicClass)` — is it satisfiable for any lam OTHER than 1? Check whether the only witness is the trivial class. If the statements only ever fire at lam = 1, that is a major finding.

B. **HEADER CLAIMS vs WHAT IS PROVED.** Read both module docstrings and check EVERY factual claim against the actual code. In particular:
   - the claim that `relCurveMap` and `Over.overSpecMap` are "two independent definitions in different namespaces" that "agree by rfl only at the canonical algebra map";
   - the claim that `exists_datum_relPicMk_eq`/`exists_datum_pic0_presentation` make the datum "free"/"produced, not assumed";
   - the claim that `PicEtAff.unit_surjective_of_section` is the "only general producer" of the unit seam and is field-only — verify by searching the whole project for other producers of `∃ z, picEtAffineEquiv _ = PicEtAff.unit _ z` or of surjectivity of `PicEtAff.unit`;
   - the claim that the evaluation map `π^*π_*L → L` is absent from AJCR, the sibling project Algebraic-Jacobian-Challenge, and mathlib;
   - the claim that each statement "spends the degree binder and returns a conclusion with no degree in it".

C. **DUPLICATION.** Does either file re-prove something already in the workspace? Search BOTH projects (AJCR and Algebraic-Jacobian-Challenge) and mathlib. Use `cd /home/axel/LeanAlgebraicGeometry-Horizon && /home/axel/.archon-env/bin/horizon search "<words>" --json` which spans all projects and mathlib. Especially: does anything already prove "a pic0/degree-zero class restricts trivially at every field point", or already bridge the two overSpecMap spellings?

D. **UNUSED BINDERS.** Does either file carry hypotheses that are never used (e.g. `GeometricallyIrreducible`, `IsProper`, `hπ`, `IsNoetherianRing`)? Check the Lean linter output by running: `cd /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild && timeout 2400 lake build AlgebraicJacobian.Picard.Pic0RingEngineFromPic0 2>&1 | grep -iE "Pic0Ring|unused|omit"`. Report any unused-variable warnings on THESE two files.

E. **THE COMPOSITION ACTUALLY COMPOSES.** Verify `htriv_of_pic0` really produces the same binder `rigidEngine_of_genus_zero` consumes (same spelling, same quantifier), and that nothing is being satisfied by a coincidence of definitional unfolding that would break if a definition changed.

Report each finding as: RISK LETTER / verdict (CONFIRMED DEFECT | OVERCLAIM | CLEAN | UNVERIFIABLE) / file:line / one-sentence explanation. Be adversarial and concrete; a finding that the work is a thin specialization of existing results is exactly what I want to hear if true. Do not soften.
