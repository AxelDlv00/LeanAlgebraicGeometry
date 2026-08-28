You are giving a fresh-context, read-only strategic review for the AJCR REVIEWER lane in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon (project: MainProjects/Algebraic-Jacobian-Challenge-Rebuild). CLI is `"$HORIZON_BIN"`. DO NOT EDIT ANY FILE; report to me as text.

THE QUESTION. Under roadmap parent `AJCR.w4-rep.datum.dat-d.ddr.certificate` there are FIVE non-advancing leaves: `cert-relocalize`, `joint-cover`, `leak-image`, `tube-fibre`, `twist-atlas` (all status `rejected`) and `away-kerspan` (status `blocked`). Four-plus rejections clustered under one parent is a signal with exactly two readings:
 (i) the PARENT's formulation is wrong and each rejection is a symptom of that; or
 (ii) the rejections are individually correct and the parent should be RESTATED to reflect what survived.
Determine which, with evidence. This is worth more than any single leaf.

WHAT TO READ:
- `"$HORIZON_BIN" roadmap list --focus AJCR.w4-rep.datum.dat-d.ddr.certificate --json` — the parent's own summary and each rejected leaf's summary (the `summary` field carries the reasoning; some are long).
- Binding human decision `"$HORIZON_BIN" inbox show I-0492` (the R2 widening: DivFamZar widens to ARBITRARY AFFINE OPENS; the GL_2/Aut(P1) route is NOT to be built; chart-wise partitions of unity must go). Also `I-0346` if referenced. These are BINDING — a restatement must be consistent with them.
- The Lean: AlgebraicJacobian/Picard/DivSchemeCertZar*.lean (Conn, Confine, Swallow, Leak, Tube, KerSpan, Verdict, Sep, ChartTrace, FibreAvoid, Transport), DivisorFamilyZar.lean (`DivFamZar`, `IsLocallyCertified`, ~:71), and DivisorFamilyAffCert.lean / DivisorFamilyAffGlueZar.lean.
- `informal/` worksheets mentioning dd-r / the certificate (e.g. anything named spec-dd-r*).

THE SPECIFIC THINGS I NEED ANSWERED:
1. Do the five rejected leaves share a common CAUSE? Name it in mathematical terms (not "they were all hard"). If the cause is one false premise the parent still asserts, quote the parent's sentence that asserts it.
2. Was each rejection actually established, or is any of them a rejection-by-assertion? For each, name the declaration or counterexample that establishes it. A leaf marked `rejected` whose refutation is only prose is a defect I need to know about.
3. `away-kerspan` is `blocked`, not rejected — on what, precisely, and is that blocker still real at HEAD?
4. Post-R2-widening: which of the five rejections are ABOUT THE OLD FIXED-PAIR-OF-CHARTS FORMULATION and therefore possibly moot under the widened `DivFamZar`? I-0492 clause 5 says some negative results are field-independent and remain binding (chart-avoid is NO; the fixed-pair no-go; joint-cover refuted, do not retry). Distinguish carefully: a rejection that is binding under I-0492 vs one that was only about the superseded formulation. Getting this backwards in either direction is expensive.
5. Concretely: propose the RESTATED parent summary text (or, if reading (i) wins, say what the parent should instead assert). Give me the text to paste, ≤25 lines, consistent with I-0492, and say which leaves it retires and which it leaves live.

METHOD WARNINGS from this workspace's documented failure modes:
- Read STATEMENTS, not docstrings or board prose; several docstrings on this seam are known false.
- A leaf claiming "X does not exist" is often wrong because the grep was case-sensitive (producers are `..._isFoo`) or because the declaration is `private`. Use `"$HORIZON_BIN" search` (spans both projects + mathlib), not grep alone, for any absence claim.
- Do NOT run `lake build` (ten lanes contend the mutex). `lake env lean <file>` on a narrow file is fine.
- A refutation of a coupled hypothesis at both ends of a parameter licenses "any working value is strictly between", NEVER "an inhabitant exists".
- Distinguish "this leaf's target is unreachable" from "this leaf's target is unnecessary". The second retires the leaf; the first may promote it to a blocker on the parent.

DELIVERABLE: verdict on (i) vs (ii) with reasoning; the per-leaf table for 2 and 4; the answer to 3; and the paste-ready restatement for 5. Flag explicitly anything you could not verify.
