# Recommendations for the iter-161 plan agent

## CRITICAL — authorize the chain signature change BEFORE any prover lane on this chain
Both review subagents independently land a **must-fix**: the route-B proof of
`rigidity_eqOn_saturated_open_to_affine` is **not completable as the chain is currently typed**. It
needs the ambient `(X⊗Y)` locally of finite type over `k̄` (⟹ `JacobsonSpace`, ⟹ dense closed
points). The prover honestly isolated the gap as an in-body `JacobsonSpace U := sorry` (AVR L237)
and a Step-1 sorry (L172) — but neither is dischargeable without the hypothesis.

**Action (this is a refactor + blueprint edit, NOT a prover task — these are off-limits-to-prover
chain lemmas):**
1. Dispatch the `refactor` subagent to add `[LocallyOfFiniteType (X ⊗ Y).hom]` (or directly
   `[JacobsonSpace (X ⊗ Y).left]`) to: `rigidity_eqOn_saturated_open_to_affine`,
   `rigidity_eqAt_closedPoint_of_proper_into_affine`, `rigidity_eqOn_dense_open`, `rigidity_core`,
   `rigidity_lemma`. Confirm `archon-protected.yaml` does not freeze these (iters 157-159 confirmed
   they are not protected). It is **free downstream** — the genus-0 curve / AV consumers are finite
   type over `k̄`. After the refactor, the L237 `JacobsonSpace U` sorry should discharge
   (open subscheme of a finite-type/Jacobson `k̄`-scheme inherits the property).
2. Dispatch a `blueprint-writer` for `AbelianVarietyRigidity.tex` to (a) state the
   finite-type/Jacobson hypothesis as a required antecedent on the chain lemmas, and (b) **correct
   the now-stale prose** in `lem:rigidity_eqOn_saturated_open_to_affine` and
   `lem:rigidity_eqOn_dense_open` that claims `[IsAlgClosed]` is the *only* added instance.
3. Re-run the HARD-GATE blueprint-reviewer (scoped, fast path) on the amended chapter before any
   prover lane.

## HIGH — blueprint coverage for the two new sub-lemmas (marker-graph laundering vector)
`lean-vs-blueprint-checker` major: `morphism_eq_of_eqAt_closedPoints` (PROVEN, axiom-clean) and
`rigidity_eqAt_closedPoint_of_proper_into_affine` (Step-1 deep residual) are now first-class
top-level declarations with **no `\lean{}` blocks / `\uses` edges**. This is the same marker-graph
laundering vector caught in iter-159: without the edges, the `\leanok`-tagged chain renders more
complete than it is. Fold into the same `blueprint-writer` dispatch above: add `\lean{}` blocks +
forward `\uses` edges from `lem:rigidity_eqOn_saturated_open_to_affine`'s proof to both Step 1 and
Step 2.

## HIGH — next prover target (AFTER the signature change lands)
`rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1, the per-closed-slice constancy) via
route B (`analogies/rigidity-affineconst.md`): slice fibre `X_y` over `y = p₂(x)` (closed ⟹
`κ(y)=k̄`), `X_y` proper integral mapping to affine `U₀`, `Γ(X_y)=k̄` via
`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + `IsAlgClosed`, then
`ext_of_isAffine` to pin `f|X_y` to a single point, transported through the residue-field probe.
Reuse the `IsPullback`-pasting idiom from `hfib`. **Do NOT** attempt the relative Stein /
`f_*𝒪=𝒪` framing — confirmed Mathlib gap. **Do NOT** assign this until the `[LocallyOfFiniteType]`
signature change lands — it has the same gap as L237 and would be unprovable.

## MEDIUM — stale "lone residual sorry" docstrings (lean-auditor major)
AVR `.lean` docstrings at L26, L410, L434-435, L518 all assert
`rigidity_eqOn_saturated_open_to_affine` is *the lone* residual sorry of the chain. The chain now
holds **two** sorries (L172 + L237). Actively misleading about proof completeness. Fold a docstring
refresh into the next prover lane that touches the file (provers can edit `.lean`; review/plan
cannot). Not worth a standalone lane.

## MEDIUM — stale proof-block `\leanok` (sync discrepancy)
`AbelianVarietyRigidity.tex:340` carries proof-block `\leanok` on
`lem:rigidity_eqOn_saturated_open_to_affine`, but the lemma has a direct in-body sorry (L237) and
verifies with transitive `sorryAx`. No marker-sync log under `logs/iter-160/`. The review agent
does not touch `\leanok`; the next `sync_leanok` run should strip it. If it persists into iter-161,
investigate whether sync is running.

## Do NOT
- Do NOT re-assign `rigidity_eqOn_saturated_open_to_affine` or Step 1 to a prover at the **current**
  signature — both are unprovable as literally typed (missing finite-type). The signature change is
  the precondition.
- Do NOT open a theorem-of-the-cube / Riemann-Roch lane yet (the deferred scaffolds
  `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`)
  — finish the Rigidity-Lemma chain first; the progress-critic's OVER_BUDGET forward-watch on that
  heaviest segment remains a watch, not yet actionable.
- Do NOT pivot the route. The route-(c) commitment is unchanged; this iter produced a genuine
  axiom-clean connective and a precise, cheap (signature-only) corrective.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- Dense-closed-points hom-extensionality via coproduct-of-residue-field probe + `ext_of_isDominant`
  (`morphism_eq_of_eqAt_closedPoints`).
- Absolute separatedness of `Z.left` from `[IsSeparated Z.hom]` over affine base `Spec k̄`:
  `Scheme.isSeparated_iff` + `terminal.hom_ext` rewrite of `terminal.from Z.left` as
  `Z.hom ≫ terminal.from (Spec k̄)` + `infer_instance`.
