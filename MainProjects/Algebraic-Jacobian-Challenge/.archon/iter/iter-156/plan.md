# Iter-156 plan-agent run

## Headline outcome

Iter-156 is the **route-decision + de-risking iter** deferred from iter-155. The
critical path had become the genus-0 rigidity keystone `rigidity_over_kbar`, blocked
on producing `df=0` (refuted iter-155 as irreducibly global-sections). The standing
question was: route (a) {Serre duality + Ω_A globalisation} vs route (b) {dual-AV via
Route A's Pic⁰}. This iter **resolved it — and overturned the framing entirely**:

- The fresh-context **strategy-critic** caught that the genus-0 witness OBJECT is the
  trivial `Spec k` (skeleton already 6/7 closed); genus-0 needs only a **rigidity
  STATEMENT, not Pic⁰ representability**. Coupling it to the FGA engine (route b) was
  an unforced error. It proposed route (c): a targeted char-free "Mor(ℙ¹,A) constant"
  rigidity lemma.
- A **reference-retriever** fetched Milne's *Abelian Varieties* and **CONFIRMED route
  (c) is feasible**: theorem of the cube → Rigidity Theorem 1.1 → Thm 3.2 → Prop 3.10
  (unirational→AV constant). NO Serre duality, NO representability, **char-free**.
  `rigidity_over_kbar` IS "map into an AV is constant" (Prop 3.10) — the `df=0`
  framing was a red herring of the chart route.

**Decision: COMMIT route (c).** Genus-0 rigidity is decoupled from the FGA engine and
closes via the AV rigidity-lemma stack (Milne §I), which is also a prerequisite for
the positive-genus Albanese UP. The FGA representability monster (Route A, A.2)
remains mandatory ONLY for the positive-genus object. The differential/chart-algebra
route is demoted to an off-path fallback (kept in tree, axiom-clean — NOT deleted).

No prover lane (mechanical HARD GATE — Jacobian.tex partial/partial, rigidity-lemma
stack not yet blueprinted). 4 subagents dispatched, all returned + absorbed.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | rigidity-pivot | **STUCK — pivot warranted** | Differential `df=0`/chart route STUCK: `rigidity_over_kbar` never closed (iters 149–155); the 9→3 sorry drops were envelope closures + ChartAlgebraS3 deletion, zero keystone progress. iter-155 proved the blocker irreducible. Endorses the pivot. |
| strategy-critic | route-b-commit | **CHALLENGE ×2 (both Route A) + DRIFTED** | (1) genus-0 amortization argument FLAWED — needs a rigidity STATEMENT, not Pic⁰ representability; proposed route (c). (2) descent cost is route-dependent, not fixed. (3) format: strip iter-NNN refs. ALL addressed in STRATEGY.md this iter. |
| reference-retriever | abelian-varieties | **COMPLETE — route (c) CONFIRMED** | Milne AV downloaded (`references/abelian-varieties.pdf`). Rigidity chain (Thm of Cube → Rigidity 1.1 → Thm 3.2 → Prop 3.10) gives "Mor(ℙ¹,A) constant" without Serre/representability, char-free. Albanese UP (Prop 6.1/6.4) backs Route A positive-genus. Mumford 1970 not openly available (relied on Milne per directive). |
| blueprint-reviewer | iter156 | **RigidityKbar PASS; Jacobian must-fix** | `RigidityKbar.tex` re-scope confirmed complete+correct as disclosed gated gap. `Jacobian.tex` partial/partial: Route A sketch-level (no `\lean{}` targets), genus-0 framing still on the dead `df=0` route → blueprint-writer dispatched. Soon: RigidityKbar/AbelJacobi route prose; Genus.tex dangling NOTE pointers. |
| blueprint-writer | jacobian-genus0-reframe | (in flight) | Re-point Jacobian.tex genus-0 framing to route (c); add the Milne rigidity-lemma block (cited verbatim from the PDF). Report absorbed at iter close. |

## Decision made

**Commit route (c): genus-0 rigidity via the AV rigidity-lemma stack (Milne §I),
decoupled from FGA representability.**

- **Why.** (1) The genus-0 object is trivial (`Spec k`), so genus-0 needs only the
  rigidity statement, not the Pic⁰ engine (strategy-critic). (2) Milne CONFIRMS the
  rigidity-lemma route proves "Mor(ℙ¹,A) constant" char-free, without Serre duality or
  representability (reference-retriever). (3) The rigidity stack is SHARED with the
  positive-genus Albanese UP, so it is not throwaway. This is strictly cheaper and
  lower-risk than both route (a) [standalone Serre duality, ~3000–8000 LOC, char-`p`
  gap] and route (b) [couples genus-0 to the riskiest A.2 representability].
- **Sequencing insight.** The cheapest, highest-value next deliverable is the AV
  rigidity-lemma stack — it closes genus-0 AND feeds the Albanese UP, decoupled from
  the Quot/Hilbert monster. Build it BEFORE representability.
- **LOC/risk.** Genus-0 via (c): ~1500–3500 LOC of AV geometry (absent from Mathlib,
  but the low-risk half). Positive-genus still needs the ~5100 LOC FGA engine.
- **Cheapest reversal signal.** If the theorem-of-the-cube / rigidity-lemma stack
  proves intractable in Lean (e.g. the rational-map-extension Thm 3.2 needs scheme
  infrastructure Mathlib lacks), fall back to route (a) for genus-0 (chart envelope is
  retained, axiom-clean) — but route (a) carries the char-`p` gap and the Serre build.

## Why no prover dispatch (mechanical gate)

blueprint-reviewer confirms there is no prover-ready critical-path target: `Jacobian.tex`
is partial/partial; the AV rigidity-lemma stack (the committed genus-0 path) has NO
blueprint chapter yet; the FGA engine is sketch-level. Dispatching a prover now would
formalize a not-yet-blueprinted route = thrown-away work. The forward Lean work opens
NEXT iter once the rigidity-lemma stack is blueprinted to prover-ready detail and
clears the gate.

## Subagent skips

- mathlib-analogist: NOT re-dispatched. The iter-155 `df-zero-production` analogy file
  already assessed route (a)/(b) feasibility (incl. Q4 "AV rigidity absent"); the
  route-(c) feasibility question was a CLASSICAL-MATH question best answered by the
  source (Milne), so the reference-retriever superseded an analogist re-consult. Not a
  hollow-dispatch avoidance — the right tool was the source fetch.

## Next iter (iter-157) — provisional

1. **Collect the blueprint-writer `jacobian-genus0-reframe` report**; absorb any
   strategy-modifying findings.
2. **Blueprint a dedicated AV rigidity-lemma chapter** (new chapter, or a section)
   to prover-ready detail from Milne §I (theorem of the cube → Rigidity 1.1 → Thm 3.2
   → Prop 3.10), with `\lean{...}` targets — the committed genus-0 deliverable. This is
   a blueprint-writer task; cite Milne verbatim.
3. **Multi-chapter route prose cleanup** (blueprint-reviewer "soon"): RigidityKbar.tex
   "commits to neither route" paragraph → record route (c); AbelJacobi.tex classical
   description.
4. Re-run blueprint-reviewer scoped to the new rigidity-lemma chapter (fast path) to
   clear the gate, then **scaffold the rigidity-lemma stack** in Lean.
5. (Low priority) Genus.tex dangling NOTE pointers; consider splitting the off-path
   GrpObj/chart material out of the large RigidityKbar.tex.
6. The FGA representability engine (A.1–A.4) remains the positive-genus deliverable;
   flesh AFTER the rigidity-lemma stack.
