# Iter-160 (Archon canonical) — review

## Outcome at a glance
- **The "Step-2-proven + signature-gap-surfaced" iter.** The prover lane on bridge 2
  (`rigidity_eqOn_saturated_open_to_affine`, route B) **proved Step 2 axiom-clean**
  (`morphism_eq_of_eqAt_closedPoints`, the iter-159-analogist-flagged connective Mathlib doesn't
  package) and **surfaced a genuine chain SIGNATURE GAP**: the route-B globalisation needs `(X⊗Y)`
  locally of finite type over `k̄` (⟹ Jacobson ⟹ dense closed points), a hypothesis the frozen
  chain signature does not carry. The prover isolated the gap honestly (in-body
  `JacobsonSpace U := sorry` at L237 + a Step-1 sorry at L172) and documented the exact fix.
- **Dispatch MATCHED the plan** — lane fired at `rigidity_eqOn_saturated_open_to_affine` as
  prescribed. Third consecutive iter with no plan/dispatch contradiction.
- **Chain bare-sorry count 1 → 2** within AVR (monolith split into Step-1 + Jacobson-instance
  sorries) while Step 2 was newly proven. Authoritative per-file inventory (compiler): AVR L172,
  L237(inline), L554/578/616 (deferred scaffolds); `Jacobian.lean` L265/L303; `RigidityKbar.lean`
  L88. No new `axiom`; no protected signature touched.

## The advance, independently verified this review
1. **`morphism_eq_of_eqAt_closedPoints` — SOLVED, axiom-clean.** `lean_verify` =
   `{propext, Classical.choice, Quot.sound}` (no `sorryAx`). Coproduct-of-residue-field probe
   `∐_{x∈closedPoints W} Spec κ(x) ⟶ W` shown `IsDominant` via `closure_closedPoints`+`Dense.mono`,
   componentwise `Sigma.hom_ext`+`Sigma.ι_desc`, finished by `ext_of_isDominant`. Both auditors
   confirm sound + a standard true fact. Durable reusable infrastructure.
2. **Signature gap surfaced + honestly isolated.** `rigidity_eqOn_saturated_open_to_affine` and
   `rigidity_lemma` both verify with honest transitive `sorryAx` (verified) — no false "clean"
   claim. The fix is `[LocallyOfFiniteType (X⊗Y).hom]` across the chain (free downstream;
   curves/AVs are finite type), a plan-authorized refactor + blueprint edit, NOT a prover task.

## Is this iter-157 laundering again? No.
The iter-157 failure was false-as-stated helpers silently laundering a true headline through an
unsatisfiable sorry. Here the sorries are **visible** (warnings + `#print axioms` propagation),
**loudly documented** with the remediation, and Step 2 is genuinely sorry-free. Both auditors agree
it is not axiom-laundering — but both still land the two sorries **must-fix** because they prop up
statements not provable as literally typed. Honest disclosure to the prover's credit; the resolution
is the signature change, not more proving at the current signature.

## Review-phase subagents (2 dispatched, both COMPLETE)
| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter160 | 2 / 1 / 3 | Step 2 sound + sorry-free; the two new sorries rest on a finite-type hyp the signature lacks → must-fix; stale "lone residual sorry" docstrings (L26/410/434-435/518) → major. |
| `lean-vs-blueprint-checker` | avr-iter160 | 1 / 1 / minor | All 6 tagged signatures faithful (check (c) PASS); chapter under-specifies the finite-type/Jacobson hyp → must-fix; two new sub-lemmas lack `\lean{}`/`\uses` → major. |
Reports: `logs/iter-160/{lean-auditor-iter160,lean-vs-blueprint-checker-avr-iter160}-report.md`.

## Actions taken this review
- Added a `% NOTE: (iter-160 review)` to `lem:rigidity_eqOn_saturated_open_to_affine` in
  `AbelianVarietyRigidity.tex` recording the signature gap + the `[LocallyOfFiniteType]` fix + that
  the "[IsAlgClosed] is the only added instance" prose is now stale. (Within review marker domain.)
- Did NOT touch `\leanok`. Flagged the stale proof-block `\leanok` at AVR.tex:340 (lemma now has a
  direct in-body sorry; `sync_leanok` should strip it; no marker-sync log present this iter).

## For the next plan agent (see recommendations.md)
- **CRITICAL / blocks the chain:** authorize `[LocallyOfFiniteType (X⊗Y).hom]` across
  `rigidity_eqOn_saturated_open_to_affine` / `rigidity_eqAt_closedPoint_of_proper_into_affine` /
  `rigidity_eqOn_dense_open` / `rigidity_core` / `rigidity_lemma` via the `refactor` subagent +
  a `blueprint-writer` hypothesis amendment, BEFORE any prover lane on the chain.
- **HIGH:** blueprint-writer adds `\lean{}` blocks + forward `\uses` edges for the two new
  sub-lemmas (marker-graph coverage), and corrects the stale "[IsAlgClosed] only" prose.
- **HIGH:** after the signature change lands, next prover target is Step 1
  `rigidity_eqAt_closedPoint_of_proper_into_affine` via route B (NOT relative Stein).
- **MEDIUM:** fold a docstring refresh (stale "lone residual sorry") into the next AVR prover lane.

## Subagent skips
- (none — both highly-recommended review subagents dispatched, since AVR was modified this iter.)
