# iter-077 plan — frozen target is FALSE; pivot to correct `…_of_affineCover`; 2 parallel capstone lanes

## Situation
- iter-076 closed `cechAugmented_exact` (P5a-resolution DONE). The ONLY remaining target was the frozen
  protected `cech_computes_higherDirectImage` (CHDI:780).
- **strategy-critic `capstone-iter077` = CHALLENGE (→REJECT):** the frozen signature is mathematically
  FALSE — general `𝒰 : X.OpenCover`, only `[IsSeparated f]`, no `IsAffine (𝒰.X i)`, no `[X.IsSeparated]`.
  Counterexample: single-element cover `{𝟙 X}` on ℙ¹, `F=O(-2)` ⇒ `Hⁱ(Čech)=0` but `R¹f_*F≠0`. Verified
  the actual `.lean` signature: critic is correct.

## Actions (some by the prior incarnation of this session; reused per user hint)
- Prior incarnation: created `CechToHigherDirectImage.lean` (correct sibling
  `cech_computes_higherDirectImage_of_affineCover` + 5-sorry decomposition); blueprint-writer/clean
  authored+purified the 5 blocks + `% archon:covers`.
- This phase: added `% archon:covers CechTermAcyclic.lean`; blueprint-reviewer `fastpath-iter077` =
  **HARD GATE SATISFIED** (0 must-fix, both leaves cleared); progress-critic `capstone-iter077b` =
  **CONVERGING** (2-file dispatch OK); refactor `split-capstone` = split the deep acyclicity chain into
  `CechTermAcyclic.lean` (correct-by-construction superset imports) ⇒ 2 parallel lanes.
- Verified the flagged `isZero_of_faithful_preservesZeroMorphisms` "duplicate" is a NON-issue (different
  FQ namespaces `CategoryTheory.Functor.*` vs `AlgebraicGeometry.*`) — corrected the stale note.
- Updated STRATEGY (§P5b: split + escalation-handled), PROGRESS (2 lanes), task_pending/done, TO_USER.

## Decision made
- **Frozen-false target → prove the correct sibling; don't block.** Standing autonomy directive forbids
  escalation-as-blocking; agents cannot edit a protected signature. So: prove `…_of_affineCover`
  (adds `h𝒰`/`[X.IsSeparated]`), leave the frozen decl a documented `sorry`, post ONE non-blocking
  TO_USER notice. Reversal: if the mathematician relaxes the signature, frozen body = one-line `exact`.
- **Split into 2 lanes (standing parallelism directive)** despite the build-wall: used
  correct-by-construction imports so the split needs NO green build to be sound (full verification is
  impossible this turn for ANY layout — cold build >25 min / exit-137). Lighter lane note dropped in
  favour of the correctness guarantee. Reversal: if a lane's build genuinely clashes, single-lane fallback.
- **No prover dispatch at CHDI:780** — unprovable as signed; a prover would thrash.

## Subagent skips
- strategy-critic: already dispatched this iter (`capstone-iter077`, CHALLENGE) by the prior incarnation;
  its challenge is ADDRESSED (we pivot to the correct sibling, not the false frozen decl) — recorded above,
  not silently overridden. No re-dispatch needed (STRATEGY changed only to record the already-audited pivot).
