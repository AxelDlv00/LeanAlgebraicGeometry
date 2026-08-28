READ-ONLY vacuity audit for the AJCR reviewer lane. Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (Archon Horizon workspace, root /home/axel/LeanAlgebraicGeometry-Horizon, CLI "$HORIZON_BIN"). DO NOT EDIT ANY FILE. Report to me as text.

THE TASK. For every GATE CLASS, STRUCTURE, and Prop-valued DEFINITION on the chart/certificate seam, read the STATEMENT (not the docstring, not any board summary — several are known false) and answer one question: WHAT WOULD FALSIFY IT?

THE CAUTIONARY CASE, which is what I am hunting for: a sibling project's `HasDivFunctor` had a field asserting only that a presheaf category is NONEMPTY — the curve `C` did not occur in the statement at all — while the blueprint advertised it as the existence of the relative divisor functor. That is a vacuity, and it survived because nobody read the statement. A gate whose statement does not mention the object it is supposedly about is the defect.

SCOPE, in priority order (the deep certificate tail first — that is where a quietly-vacuous side condition survives longest):
1. `AlgebraicJacobian/Picard/DivisorFamilyAff*.lean` — especially `AffCoverData`, `AffAdaptation`, `AffAdaptation.IsCertified`, `IsLocallyCertifiedAff`, `DivFamZarAff`, `SwallowedBy`, `ChartTyping`, `ThetaTrivData`, and every clause of the certificate (c1..c4 and any `hfin`/`hproj`/`hrank`).
2. `Picard/DivisorFamilyZar.lean` — `DivFamZar`, `IsLocallyCertified`.
3. The chart seam: `IsChartUniv`, `RestrictedChartFibre`, `IsChartLocusFibre`, `ChartFibrePresented` (all fields), `IsChartDatumPresentation`, `IsChartDatumPlusFibre`, `IsPlusHonest`, `ChartLocusAffineLocal`, `PointwiseCoverage`.
4. `JacobianData` (Picard/JacobianData.lean) and its four fields.

FOR EACH, report a row: name, file:line, VERDICT in {NON-VACUOUS / VACUOUS / SUSPICIOUS}, the concrete falsifier (inputs/state making it FALSE), and whether the curve `C` (or the relevant divisor/chart datum) actually OCCURS in the statement. Flag specially:
 (a) any field or clause satisfiable by a degenerate witness unrelated to the geometry (empty index, empty support, `m = 0`, `PEmpty`, bot/top opens, a nonemptiness assertion);
 (b) any structure with MANY CONSUMERS and ZERO PRODUCERS — a plain structure with no inhabitant passes every emptiness sweep and still makes its whole cluster about nothing. Count producers and consumers for each structure you examine. A documented instance in this workspace: `DivFamily` had 135 consumers and zero producers.
 (c) any class with an UNCONDITIONAL global instance — that is not a gate at all, and anything priced off it is double-counted.

METHOD REQUIREMENTS (this seam has a documented history of mismeasurement):
- Census predicates CASE-INSENSITIVELY: Lean puts predicates in suffix position, so producers are named `..._isFoo` and a case-sensitive grep misses exactly the producers. A prior sweep here reported 6 declarations where there were 11, and the 5 missed were all producers.
- `private` declarations are invisible to name search — use `"$HORIZON_BIN" search` (spans both projects + mathlib) and grep, not one alone.
- A declaration in a file is still ABSENT from a consumer outside its import closure. If you claim something is available, check the closure.
- `infer_instance` failing does NOT prove absence — the thing may be a theorem rather than an instance.
- A structure being inhabited at a DEGENERATE parameter (empty scheme, bot open) is not evidence its intended use is inhabited. Say which.
- Do NOT run `lake build` on the whole tree (ten lanes contend the mutex). `lake build <single.Module>` or `lake env lean <file>` is fine. Before believing any probe success, confirm the relevant oleans are newer than sources — a stale olean set makes every snippet appear to succeed.

DELIVERABLE: the table, then a short list of the findings you would actually file, hardest evidence first. State explicitly what you could NOT verify and where your coverage stops — I will report your coverage limit rather than implying an exhaustive sweep.
