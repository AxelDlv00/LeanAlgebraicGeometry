# Session 161 (iter-161) — review summary

## Metadata
- Iteration / session: 161
- File touched by prover: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (+ memory files)
- AVR sorry-bearing declarations: **5 → 4** (lane (a) closed; deep algebra extracted+proven;
  Step-1 monolith reduced to one residual). Build: `lake env lean AVR.lean` → exit 0, no errors.
- No new `axiom`; no protected signature touched.

## What the prover did (three lanes, all verified this review)

### 1. `eq_comp_of_isAffine_of_properIntegral` (NEW, L153) — SOLVED, axiom-clean
The deep algebraic heart of Step 1: over `[IsAlgClosed kbar]`, for `W` integral with
`wk : W ⟶ Spec k̄` `[UniversallyClosed][LocallyOfFiniteType]` and `g : W ⟶ V` into an affine `V`,
any two `k̄`-points (sections `a,b` of `wk`) satisfy `a ≫ g = b ≫ g`.
- Proof: `Γ(W)` is a field (`isField_of_universallyClosed`); `wk.appTop` integral
  (`isIntegral_appTop_of_universallyClosed`), hence — `k̄` alg-closed, `Γ(W)` a domain — bijective
  (`IsAlgClosed.ringHom_bijective_of_isIntegral`), so `wk.appTop` is iso; both sections left-invert
  it on `Γ`, giving `a.appTop = b.appTop` (`cancel_epi`); `ext_of_isAffine` pins maps into the affine.
- `lean_verify` = `{propext, Classical.choice, Quot.sound}` (no `sorryAx`). Independently
  re-verified this review. The cohomology-free realisation of "a global regular function on a proper
  integral `k̄`-variety is constant". **Reusable.**

### 2. `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1, L204) — PARTIAL (major reduction)
- Found `Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean` (`pointOfClosedPoint`,
  `residueFieldIsoBase`, `pointOfClosedPoint_comp`) — packages "closed point of an l.f.t.
  `k̄`-scheme ⇔ `k̄`-rational point", exactly the residue-field machinery the route needs.
- Body now reduces the residue-field-probe goal (via `rw [← cancel_epi (Spec.map (residueFieldIsoBase
  …).hom)]` + `suffices`) to the clean `k̄`-point statement `q ≫ f.left = q ≫ retract.left ≫ f.left`
  (`q := px ≫ U.ι`), establishes `q` as a section (`hqsec`, via `pointOfClosedPoint_comp`), and
  rewrites the collapsed side. **One residual `sorry` (L263)** = the geometric slice/section
  assembly. `lean_goal` at L263 confirms the obligation is exactly the `k̄`-point equation.
- **Blocker for next iter:** `IsIntegral X.left` is NOT auto-derivable — needs a *retract* argument
  (`X.left` a topological+ring-theoretic retract of the integral `(X⊗Y).left` via `(s, p₁)` with
  `s ≫ p₁ = 𝟙` ⟹ irreducible + reduced). No packaged Mathlib "retract of integral scheme is
  integral". This is the natural next named ~0.3–0.5-iter sub-lemma.

### 3. `JacobsonSpace U` in `rigidity_eqOn_saturated_open_to_affine` (lane a, was L238) — SOLVED
`haveI : JacobsonSpace (X⊗Y).left := LocallyOfFiniteType.jacobsonSpace (X⊗Y).hom; exact
JacobsonSpace.of_isOpenEmbedding U.ι.isOpenEmbedding`. The `JacobsonSpace (Spec k̄)` premise
resolves automatically (field ⟹ `IsArtinianRing` ⟹ `IsJacobsonRing`). The lemma is now
**sorry-free in its own body** (delegates only to the still-open Step 1).

## Soundness verdict (independently confirmed by both review subagents)
This is **NOT** iter-157-style laundering. The headline `rigidity_lemma` honestly carries
`sorryAx`; the residual `sorry` statement (`rigidity_eqAt_closedPoint_of_proper_into_affine`) is
itself TRUE-as-stated with every hypothesis load-bearing (`_hUV` saturation, `_hfU` affine
containment, `_hU₀` affineness, `_hx` closedness). The in-body reduction is sound (closing the
residual suffices). `eq_comp_of_isAffine_of_properIntegral` is genuinely axiom-clean. The `\uses`
graph is forward-acyclic with the not-proven status correctly routed up — no headline laundering.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)
| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter161 | 0 / 1 / 2 | Both new/edited proofs sound; helper axiom-clean; Step-1 residual true + honest, NOT laundering. Major: `rigidity_eqOn_saturated_open_to_affine` Lean docstring (L276-278) UNDER-states — still calls it a `sorry`-bodied obligation though it is now assembled. Minors: stale "(iter-160)" status tag L201; prose drift L289-292. |
| `lean-vs-blueprint-checker` | avr-iter161 | 0 / 1 / 0 | All 8 `\lean{}`-tagged signatures faithful; two new "PROVEN" lemmas verified axiom-clean; `\uses` graph clean, no laundering. Major: proven helper `eq_comp_of_isAffine_of_properIntegral` has NO `\lean{}` node / `\uses` edge (documentary gap). Informational: `morphism_eq_of_eqAt_closedPoints` proof block needs `\leanok` (sync_leanok's job). |
Reports: `logs/iter-161/{lean-auditor-iter161,lean-vs-blueprint-checker-avr-iter161}-report.md`.

## Blueprint markers updated (manual)
- `AbelianVarietyRigidity.tex`, proof of `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`:
  added `% NOTE: (iter-161 review)` flagging that the proven algebraic-core helper
  `eq_comp_of_isAffine_of_properIntegral` lacks a `\lean{}` node / `\uses` edge, with a
  plan/blueprint-writer TODO to add it. (Did NOT add the node myself — new prose is the
  blueprint-writer's domain.)
- Did NOT touch `\leanok` (sync_leanok's domain). Per the checker, `morphism_eq_of_eqAt_closedPoints`'s
  proof block should gain `\leanok` from the deterministic pass.

## Blueprint doctor
Clean — no orphan chapters, all `\ref`/`\uses` resolve, no new `axiom`.

## Notes (LOW)
- The auditor's `#print axioms` "unknown constant" artifact I hit on `eq_comp_...` from a /tmp file
  was a stale-elaboration quirk; the LSP `lean_verify` on the actual file is authoritative and
  confirms axiom-clean. (Prover hit the same artifact — see debug-feedback.)
