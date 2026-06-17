# blueprint-reviewer — slug `iter202`

Full whole-blueprint audit. Three chapters received plan-agent
edits this iter (WD, AB, COE) on the back of iter-201 lean-vs-
blueprint-checker MAJOR/SOON findings; one chapter
(`Picard_TensorObjSubstrate.tex`) is feeding a new file-skeleton
scaffold lane this iter and needs HARD GATE coverage confirmation.

## Scope

Audit the whole blueprint per the standard descriptor. Pay special
attention to:

### Plan-agent-touched this iter

- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — added new
  `\begin{definition}[Function-field isomorphism along an open
  immersion]\label{def:functionFieldIso}` block (closing wd-iter201
  MAJOR finding); updated Sub-build 2 description to past tense
  (CLOSED iter-201, 6 axiom-clean decls); updated Sub-build 3
  description to reference new pin and the iter-202 prover scout's
  Mathlib API path (`stalkSpecializes_stalkMap_assoc`).
- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` —
  rewrote matrix-collapse paragraph to past-tense (closing ab-iter201
  SOON finding); added new `\paragraph{Iter-201 status update:
  matrix-collapse substrate landed; closure body deferred to iter-202.}`
  block documenting Nat-induction restructuring recipe + iter-202
  AB-promotions commitment.
- `blueprint/src/chapters/Albanese_CodimOneExtension.tex` —
  corrected `IsRegularLocalRing.localization` "EXISTS" → "MISSING"
  (closing coe-iter201 SOON); reframed Step A1 as cross-file import
  of project-local Stacks 00NQ + RLR-preservation witnesses;
  documented iter-201 Step A2 done-vs-open split with 3 substrate
  decls listed; added Step A3 substrate composite reference.

### HARD GATE re-verification for iter-202 prover dispatch (4 lanes)

1. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane
   WD-A4a-Sub-build-3) — chapter `RiemannRoch_WeilDivisor.tex` (just
   edited). HARD GATE: complete + correct for Sub-build 3 +
   `def:functionFieldIso`?
2. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane
   AB-Path-B-Close) — chapter `Albanese_AuslanderBuchsbaum.tex`
   (just edited). HARD GATE: complete + correct for the body-closure
   recipe + 3 promotion commitments?
3. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (Lane
   COE-Step-B-Bridges) — chapter `Albanese_CodimOneExtension.tex`
   (just edited). HARD GATE: complete + correct for the Step B
   scheme-to-algebra bridges (substrate-only this iter)?
4. **`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`** (Lane
   TS-Scaffold) — chapter `Picard_TensorObjSubstrate.tex` (iter-200
   landed, NOT edited this iter). HARD GATE: complete + correct for
   a file-skeleton scaffold of the 4 pinned declarations (`tensorObj`,
   `tensorObj_functoriality`, `monoidalCategory`,
   `addCommGroup_via_tensorObj`)?

### Cross-chapter context

- The iter-201 `ab-iter201` MAJOR finding about `private` +
  `\lean{...}` pin combination on `auslander_buchsbaum_formula_succ_pd`
  is being resolved by iter-202 Lane AB removing the `private`
  modifier as part of body closure. Confirm the chapter's iter-201
  NOTE (option (1)) is still the operative resolution path.
- The Lane COE Step A1 cross-file import dependency on Lane AB
  helper promotions (`isDomain_of_regularLocal`,
  `regularLocal_quotient_isRegularLocal_of_notMemSq`) is a CROSS-
  CHAPTER consistency item: confirm the AB chapter's iter-202 status
  update paragraph and the COE chapter's Step A1 reframe paragraph
  describe the same promotions consistently.

### What to flag

Per the standard descriptor — per-chapter `complete`/`correct`
verdicts, must-fix-this-iter findings, soon/minor findings, and
the `Unstarted-phase blueprint proposals` section if relevant.

For the file-skeleton scaffold lane (Lane TS): the HARD GATE bar
is lower — the chapter must contain enough information for the
prover to produce typed-sorry stubs with correct signatures
(namespaces, parameter types, target types). It does NOT need
proof sketches for the bodies (those land iter-203+ when the
typed sorries are filled).
