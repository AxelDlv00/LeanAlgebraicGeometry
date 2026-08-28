You are the fresh-context adversarial audit of ONE session's work: the AJC reviewer lane `review-ajc`, run 0081 round 6, in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon.

Ledger git: git --git-dir "$HORIZON_LEDGER_GIT_DIR" --work-tree "$HORIZON_LEDGER_WORK_TREE" ...
Project: MainProjects/Algebraic-Jacobian-Challenge

MY SESSION PRODUCED EXACTLY ONE CLAIM, and I want you to try to REFUTE it, not confirm it. The claim, published as inbox item I-1286, as roadmap comment on AJC.picrep.etale-rep, and as "item 5" in the docstring of `Scheme.fgaPicardRepresentability` (my commit ee7d7f37de, restored at b303478d5d after another lane reverted it):

  Clause (1) of the seam theorem `Scheme.fgaPicardRepresentability`
  (AlgebraicJacobian/Picard/FGAPicRepresentability.lean) is a THREE-field
  existential: `∃ X, Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
  LocallyOfFiniteType X.hom ∧ IsSeparated X.hom`.  I claim:
  (a) every published pricing covers the FIRST field only;
  (b) LocallyOfFiniteType DESCENDS along the finite-separable cover free, from
      mathlib's `DescendsAlong @LocallyOfFiniteType (@Surjective ⊓ @Flat ⊓
      @QuasiCompact)` instance;
  (c) IsSeparated CANNOT descend in mathlib v4.31 — no such instance, and the
      diagonal route via `IsSeparated.isSeparated_eq_diagonal_isClosedImmersion`
      fails because `DescendsAlong @IsClosedImmersion` is also absent;
  (d) IsSeparated is free ANYWAY and never needs to descend, because
      `PicScheme.picEt` is `CommGrpCat`-valued (`Scheme.picEtCommGrp`), so ANY
      representing scheme is a group object over `Spec k` by Yoneda transport
      (`CommGrpObj.ofRepresentableBy`), and a group scheme over a field is
      separated;
  (e) the ONE missing brick is a PORT of three declarations from the SIBLING
      project Algebraic-Jacobian-Challenge-Rebuild,
      AlgebraicJacobian/AbelianVariety/GroupSeparated.lean, none of whose names
      exists in AJC.

ATTACK IT ON THESE SPECIFIC LINES, each of which is a way I could be wrong:

1. Is (a) actually true, or did some row/docstring/inbox item already price the side conjuncts and I missed it? Grep the roadmap items under .archon-horizon/roadmap/items/AJC.picrep* AND their comments in .archon-horizon/roadmap/comments/, and the FGAPicRepresentability docstring, for LocallyOfFiniteType / IsSeparated / separated / finite type. An earlier reviewer round may have said this and I would be re-deriving it.

2. Is (d) VACUOUS or CIRCULAR? The critical question: does `Scheme.picEtCommGrp` genuinely mention the curve C, or is it one of this project's known vacuity traps? And is my Yoneda transport doing real work, or is it a self-projection — e.g. does the representing scheme come from `instHasPicSchemeEt`, which is a projection of the seam sorry, making the whole thing sorryAx-reachable in practice? Write a probe file under MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/ (name it ZZGroundProbe.lean, DELETE it when done) and check with `lake env lean` and `#print axioms`.

3. Is (e) right that AJC lacks these? Check by `#check` inside AJC's import closure, NOT by grep — this project has a recorded trap where a name exists in source but outside the citing file's import closure, and the reverse (mathlib has it under another name). In particular: does mathlib ALREADY have "group scheme over a field is separated" under some name I did not find? Try `lean_leansearch` / `horizon search` / `exact?`.

4. Is my claim (c) an ABSENCE claim resting on too narrow a scan? I checked by grepping mathlib's AlgebraicGeometry directory and by failed `inferInstance`. Is there a `theorem` (not `instance`) form, or a `Scheme.IsSeparated`-flavoured statement, that gives separatedness descent?

5. THE ONE THAT WOULD HURT MOST: is the side-conjunct result IRRELEVANT rather than wrong? I said it "removes two obligations nobody had counted". But if no lane was ever going to prove those fields separately — because whoever discharges the representability field gets all three from the same construction — then my finding changes no lane's work and I have published a true triviality. Judge that honestly.

Also: verify nothing of mine is uncommitted or clobbered. Check that FGAPicRepresentability.lean at HEAD equals disk, and that my commit ee7d7f37de touched ONLY that path.

Report back TERSELY: for each of the 5 points, CONFIRMED / REFUTED / PARTLY, with the evidence. Then one line: does the session's single claim survive? A refutation is the most valuable thing you can give me — do not soften it.
