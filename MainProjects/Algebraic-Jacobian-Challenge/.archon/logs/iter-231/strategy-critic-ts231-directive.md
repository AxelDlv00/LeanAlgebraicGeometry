# strategy-critic directive — ts231

Fresh-eyes critique of the project strategy. Read ONLY the inputs named below; do not read any
iteration narrative, task results, or prover reports.

## Inputs to read
- `.archon/STRATEGY.md` (verbatim — the current strategy).
- `references/summary.md` (the reference index).
- Blueprint chapter titles + one-line topics: list `blueprint/src/chapters/*.tex` and read the
  first lemma/section title of each (do not read full chapters).

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only; no `C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}`. End-state: zero inline `sorry`
in the protected dependency cone, 0 project axioms.

## What changed this iter (assess these specifically)
1. The ⊗-group-law substrate (A.1.c.SubT) C-bridge was RE-SCOPED: iter-230 empirically falsified
   the prior plan to discharge it via the sheaf-site root `overSliceSheafEquiv`; the new target is
   a minimal objectwise `dual (M.restrict j) ≅ (dual M).restrict j` on opens `V⊆U`, claimed
   near-definitional. Is this re-scope sound, or is it the same route relabeled?
2. Escalation-to-user is now DISABLED by a USER standing directive (autonomous operation). The
   strategy resolves the long-running "RR-fork escalation" into an FYI and pre-commits autonomous
   FAIL correctives (pivot the inverse OFF the dual via object-gluing; file-split). Is the
   pre-committed fallback chain sound?
3. The divisor/`Pic⁰` arm remains gated by the permanent ROUTE C PAUSE (not autonomously
   reachable). Given that, is continuing the RR-free substrate the right sole-lane choice?

## Your question
Is the strategy sound as written? Challenge any sunk-cost continuation, mis-estimation, or
structurally-doomed route. Verdict: SOUND / CHALLENGE / REJECT with specifics.
