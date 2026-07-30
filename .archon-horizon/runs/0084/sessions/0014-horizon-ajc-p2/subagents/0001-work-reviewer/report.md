Fresh-context audit of ONE file, produced this session by lane ajc-p2 in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon.

TARGET: MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean (24 declarations, claimed 0 code sorries, claimed all axiom-clean).

Audit it at the PINNED sha, not on disk — the file may change while you work (other lanes are live). Get it with:
  cd /home/axel/LeanAlgebraicGeometry-Horizon
  .archon-horizon/bin/hgit log --oneline -8 -- MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean
and read via `hgit show <sha>:<path>`. Record the sha you audited.

WHAT THE FILE CLAIMS. Read its module docstring, then check each claim BY STATEMENT, not by name:

1. `representableBy_of_coverCompatibleEquiv` is claimed to be "the theorem the other lanes' items are antecedents OF", crossing the descent step, and specifically NOT a P -> P implication (i.e. its hypotheses must not already contain a representation of `picEt C`). Read the actual binders. Is the hypothesis `(T ⟶ Y) ≃ CoverCompatible C T` for all T, plus its naturality, genuinely weaker than / different from the conclusion `(picEt C).RepresentableBy Y`? The file itself proves a converse (`coverCompatibleEquiv_of_representableBy`) and CONCLUDES from it that the two are inter-derivable, i.e. that the theorem is a change of coordinates. Check whether that self-assessment is correct, and whether it is stated strongly enough — in particular, is the "assembly" doing any work at all beyond `Equiv.trans`, and if not, does the file say so plainly enough for a reader deciding whether to build on it?

2. Three "measurements" are claimed. Verify each independently:
   (a) `coverMap_eq_counit` — that PicEtDescentAssembly.lean's `coverMap` IS the counit of `Over.map ⊣ Over.pullback`.
   (b) that BOTH directions of coverCompatible <-> galInvariant are free of `[Module.Finite k k']` and `[Algebra.IsSeparable k k']`, and the stronger inherited claim that in this whole cluster those binders are consumed at EXACTLY ONE place (covering-sieve membership). That "exactly one place" is a census claim — check it or say it is unchecked.
   (c) `etaleTopology_generate_of_openCover` and `isOpenImmersion_sigmaι`, and the file's inference that therefore `hcov` "carries NO etale-site obligation". Is that inference right, or does it skip something?

3. The file WITHDRAWS an earlier non-vacuity claim about `hcov` (citing I-1454) and replaces it with "satisfiable, but no exhibited model separates the two projections". Check the replacement wording is now correct and not itself overstated or understated.

4. VACUITY AND CARRIER checks, per the workspace bar: does every new definition/predicate mention the object it is about? `IsCoverCompatible`, `CoverCompatible`, `IsGalInvariant`, `GalInvariant` — does the curve `C` genuinely occur, and is each predicate about the object its name suggests? Is `coverFunctor` the object the docstrings say it is?

5. Are any of these declarations DUPLICATES of something already in the project or in mathlib? Use `.archon-env/bin/horizon search "<words>" --json` (spans both projects AND mathlib) and check the neighbouring files PicEtDescentAssembly.lean, PicEtDescentExistence.lean, PicEtQuotientHom.lean, GaloisDescent/PicEtGaloisBridge.lean. The file's own history includes one case (`generate_singleton_coverMap_eq`) where a 26-line proof was a mathlib one-liner, so this is a live risk.

METHOD REQUIREMENTS, non-negotiable:
- Before believing ANY Lean probe, rebuild oleans or confirm they are current, and put `#print axioms AlgebraicGeometry.Scheme.fgaPicardRepresentability` in every probe file as a live control: it MUST report `sorryAx`. If it does not, your imports are stale and every probe result is void.
- Build first if needed: `cd MainProjects/Algebraic-Jacobian-Challenge && lake build AlgebraicJacobian.Picard.PicEtDescentRepresentability` (may take minutes; wait for it). Then `lake env lean <probefile>` for probes. Another lane may hold the build lock — if so, wait and retry rather than reporting an unmeasured verdict.
- Delete your probe files when done; scratch dirs in this project are NOT gitignored.
- Do not edit the audited file. Report only.

DELIVER: for each numbered item, CONFIRMED / REFUTED / UNCHECKED with the evidence that decided it. Rank findings most severe first. Prefer refuting a claim the file makes over listing things it could also have done. If you find nothing wrong, say so plainly rather than manufacturing a finding — but check items 1 and 2(b) hardest, since those are where an over-claim would be most consequential and least visible.
