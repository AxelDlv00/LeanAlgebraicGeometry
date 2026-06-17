# Session 160 — review of iter-160

## Metadata
- Iteration / session: 160
- Prover lane: 1 DEEP lane on `AlgebraicJacobian/AbelianVarietyRigidity.lean`, target
  `rigidity_eqOn_saturated_open_to_affine` (bridge 2 of the Rigidity Lemma, route B). `meta.json`:
  `prover.status: done`, 963s. Dispatch MATCHED the plan (third consecutive iter with no
  plan/dispatch contradiction).
- Activity (`attempts_raw.jsonl`): 3 edits, 1 goal check, 4 diagnostic checks, 6 lemma searches,
  0 `lake build`. No protected signature touched; no new `axiom` declarations project-wide.
- Bare-`sorry` sites in the chain region: **AVR chain went 1 → 2** (the monolithic
  `saturated_open` sorry split into a Step-1 sorry + an in-body Jacobson-instance sorry), while a
  third piece (Step 2) was **newly PROVEN axiom-clean**. Per-file authoritative sorry inventory
  (compiler, not docstrings): AVR L172, L237(inline), L554/578/616 scaffolds; `Jacobian.lean`
  L265/L303; `RigidityKbar.lean` L88.

## The headline: a genuine win + a surfaced signature gap

### Win — `morphism_eq_of_eqAt_closedPoints` (Step 2) PROVEN, axiom-clean
The iter-159 `mathlib-analogist` flagged that the "agree at every closed point ⟹ equal" connective
is the one piece Mathlib does **not** package (it supplies only the single-morphism
`ext_of_isDominant`). This iter the prover built it (≈25 lines): assemble all closed points into one
dominant probe — the coproduct `∐_{x∈closedPoints W} Spec κ(x) ⟶ W` (`Sigma.desc fromSpecResidueField`),
show `IsDominant` (range ⊇ closed points, dense by `closure_closedPoints` via `Dense.mono`),
discharge componentwise with `Sigma.hom_ext`+`Sigma.ι_desc`, finish with `ext_of_isDominant`.
**Independently verified this review:** `lean_verify` axioms = `{propext, Classical.choice, Quot.sound}`
(no `sorryAx`). Both review subagents confirm it is sound and a standard true fact. Durable,
context-independent infrastructure.

### Surfaced — the chain SIGNATURE GAP (the unit of this iter)
Wiring Step 2 over Step 1 forced `morphism_eq_of_eqAt_closedPoints`'s `[JacobsonSpace W]` instance
on `W = U`. The chain signature provides **no** such instance — and it is NOT derivable, because
route B's globalisation needs the closed points of `U` dense, i.e. `U` Jacobson, i.e. `(X⊗Y)`
locally of finite type over `k̄`. The current chain carries only `[IsAlgClosed]`,
`[IsProper X.hom]`, `[GeometricallyIrreducible (X⊗Y).hom]`, `[IsReduced (X⊗Y).left]`,
`[IsSeparated Z.hom]` — no finite type, and `Y` is an arbitrary `Over (Spec k̄)` so it cannot be
recovered. The prover isolated the gap honestly:
- in-body `haveI : JacobsonSpace U := sorry` (L237), with a 10-line `SIGNATURE GAP` comment
  (L227-236) stating plainly "this is the one place the present statement is not provable as
  literally typed";
- Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`, L172) extracted as a named top-level
  `sorry`, whose own sketch needs `κ(y)=k̄` from finite type — the **same** missing hypothesis.

**The fix is a signature change, not a proof:** add `[LocallyOfFiniteType (X⊗Y).hom]` (or directly
`[JacobsonSpace (X⊗Y).left]`) to `rigidity_eqOn_saturated_open_to_affine`,
`rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`. It is **free downstream** (genus-0
curves and abelian varieties are finite type over `k̄`). These are off-limits-to-prover chain
lemmas, so this is a **plan-agent-authorized refactor + blueprint hypothesis edit**, not a prover
task. Once it lands, the L237 sorry vanishes and Step 1 becomes attackable.

## Is this laundering? No (but it is must-fix)
This is **not** the iter-157 failure mode (false-as-stated helpers silently laundering a true
headline). Both auditors agree:
- the two new sorries are **visible** (warning at L203/L172) and propagate via `#print axioms` to
  every consumer (`rigidity_lemma` etc. carry honest transitive `sorryAx`; verified this review);
- the gap is **loudly documented** in-code with the exact remediation;
- `morphism_eq_of_eqAt_closedPoints` is genuinely sorry-free.
But both classify the two sorries as **must-fix** because they prop up statements not provable as
literally typed. The honest disclosure is to its credit; the resolution is the signature change.

## Review-phase subagents (2 dispatched, both COMPLETE)

| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter160 | 2 / 1 / 3 | Step 2 sound + sorry-free (verified). The two new sorries (L172, L237) rest on a finite-type hypothesis the frozen signature lacks → must-fix. Stale "lone residual sorry" docstrings (L26/410/434-435/518) now wrong (two chain sorries) → major. |
| `lean-vs-blueprint-checker` | avr-iter160 | 1 / 1 / minor | Signatures of all 6 tagged blocks faithful (check (c) PASS). Chapter under-specifies the finite-type/Jacobson hypothesis the Lean now needs → must-fix (blueprint adequacy). Two new sub-lemmas lack `\lean{}`/`\uses` → major (marker-graph coverage). |
Reports archived to `logs/iter-160/`.

## Blueprint markers updated (manual)
- `AbelianVarietyRigidity.tex`, `lem:rigidity_eqOn_saturated_open_to_affine`: added a `% NOTE:
  (iter-160 review)` recording the signature gap — the lemma + the rest of the chain are not
  provable as literally typed, the fix is `[LocallyOfFiniteType (X⊗Y).hom]` across the chain (a
  plan/blueprint+signature edit, not a prover task), and the prose's "[IsAlgClosed] is the only
  added instance" claim is now stale.
- No `\mathlibok` added (no Mathlib re-export this iter). No `\lean{}` corrections (signatures
  unchanged, no renames). No stale `\notready` to strip.

## Marker / sync note (NOT touched — flagged for plan agent)
- `AbelianVarietyRigidity.tex:340` carries proof-block `\leanok` on
  `lem:rigidity_eqOn_saturated_open_to_affine`, but that lemma now has a **direct in-body `sorry`**
  (L237) and verifies with transitive `sorryAx`. The proof-block `\leanok` is therefore stale; the
  deterministic `sync_leanok` phase should strip it. No marker-sync log is present under
  `logs/iter-160/`. Per the review role I do **not** touch `\leanok` — flagging so the next sync /
  plan agent resolves it. The `lean-vs-blueprint-checker` independently flagged the same.

## Key findings / reusable patterns
- **Dense-closed-points hom-extensionality** (`morphism_eq_of_eqAt_closedPoints`): coproduct-of-
  residue-field-Specs probe + `ext_of_isDominant`. Needs `[IsReduced W]`, `[JacobsonSpace W]`,
  `[Z.IsSeparated]`. Reusable across the project.
- **Absolute separatedness from a relative separated map over an affine base**:
  `rw [Scheme.isSeparated_iff]; rw [show terminal.from Z.left = Z.hom ≫ terminal.from (Spec k̄) …];
  infer_instance`.
- **Lesson**: a clean chain signature can hide a missing hypothesis that only a specific proof route
  (here route B's globalisation) demands. When a route forces an instance the signature can't
  provide, that is a signature gap to escalate, not a sorry to leave — both auditors land it
  must-fix even when honestly documented.

## Recommendations
See `recommendations.md`. Top: authorize the `[LocallyOfFiniteType (X⊗Y).hom]` chain signature
change (refactor + blueprint hypothesis amendment) BEFORE any further prover lane on this chain.
