You are auditing three Lean files just landed by lane ajcr-p1 in the project at
/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild

Files (all rooted at AlgebraicJacobian.lean, all reported sorry-free and axiom-clean):
1. AlgebraicJacobian/Picard/Pic0ChartFieldTestSurjective.lean
2. AlgebraicJacobian/Picard/JacobianDataQcFiniteFamily.lean
3. AlgebraicJacobian/Picard/Pic0ChartFieldPointClass.lean

Context: the target was roadmap row AJCR.w4-rep.datum.dat-j.qcfield -- the `hcl` hypothesis that is
the fourth field (quasiCompact) of JacobianData. Two existing files (Picard/JacobianDataQcFromRep.lean,
Picard/Pic0AtlasCompactFromClass.lean) reduce that field to `hcl` and say it has NO PRODUCER of any
shape. My claim is NOT that hcl is discharged; it is that the PER-POINT half of hcl is free given
DAT-B coverage, plus a repricing of the qc field to a finite family of carriers.

This workspace's 2026-07-29 audit refuted 99 of 101 sampled representability claims: 67 sorry-reachable,
17 VACUOUS, 12 proved something adjacent to what was claimed. Assume I have made one of those errors and
find it. Specifically please check, IN LEAN where possible (use `lake env lean` on scratch files under
ScratchP1/ which is gitignored via the *probe*.lean pattern -- name any file you create
probe_<something>.lean; ALWAYS include a `sorry`-carrying control theorem in each probe and confirm it
reports sorryAx, because stale oleans otherwise make probes falsely succeed):

(a) VACUITY. For each theorem, is the conclusion actually about the object the name and docstring
    claim? In particular: does `exists_chart_field_point_of_chartsCoverLocally` say anything that is
    not already true for a trivial/degenerate configuration? Is `quasiCompact_of_finite_family_pic0_class`
    vacuous at an EMPTY index (ι := PEmpty)? If it IS vacuous there, is that a defect of the statement,
    given that the hypothesis `hcl` would then be false for any nonempty J? Check whether the statement
    or docstring overclaims on that point.

(b) UNUSED HYPOTHESES, especially INSTANCE binders (per inbox I-1401, the lean_minimal_hypotheses tool
    skips instance binders by design, so check them by hand: delete a binder, re-elaborate, see if it
    still compiles). Candidates: the [SmoothOfRelativeDimension 1 C.hom] / [IsProper C.hom] /
    [GeometricallyIrreducible C.hom] on the general site-level theorems in file 1; the
    [IsIntegral], [SmoothOfRelativeDimension] families in file 2; whether
    `compactSpace_of_finite_family_surjective` uses anything scheme-specific at all.

(c) DUPLICATION. Does the tree ALREADY have any of these? Use
    `"$HORIZON_BIN" search "<natural language>" --json` (spans both projects AND mathlib), not grep,
    and also check mathlib directly for: "a covering sieve on a subsingleton-space object contains the
    identity", "local surjectivity implies surjectivity at a point with no proper covers",
    "compact space from finitely many compact images". Note Pic0ChartBotRefute.lean is the mirror
    statement about EMPTY spaces -- check I did not restate something there. Also check
    Pic0ChartCoverageAffineTest.lean / Pic0ChartCoveragePointwise.lean for an existing field-test
    reduction.

(d) THE HEADLINE CLAIM. File 3's docstring says the per-point half of hcl is free given coverage, and
    lists three surviving gaps (carrier is the open V i not divSchemeOver; index varies with the point;
    compactness of chart sources not free). Is that list COMPLETE and are the three gaps stated
    accurately? Is there a fourth gap? Conversely: is the claim UNDERSTATED -- i.e. could the gaps be
    closed cheaply, making this actually a discharge of hcl that I failed to claim?

(e) DID I DISCHARGE AN OBLIGATION BY PROJECTING MY OWN HYPOTHESIS? Check `finite_family_pic0_class_of_single`
    and `sectionOfRepAtFieldPoint` are not P -> P restatements.

Report concrete, reproducible findings with file:line, and say plainly which of my claims survive and
which do not. Do NOT edit my files. If a claim is fine, say so briefly rather than padding.
