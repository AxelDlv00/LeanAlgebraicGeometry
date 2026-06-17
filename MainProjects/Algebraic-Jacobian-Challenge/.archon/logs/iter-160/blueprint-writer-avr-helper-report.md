# blueprint-writer report — avr-helper (iter-160)

## Summary
Hosted bridge-2 of the Rigidity-Lemma chain in
`blueprint/src/chapters/AbelianVarietyRigidity.tex`, closing the marker-graph laundering vector
flagged by the iter-159 lean-vs-blueprint-checker. The new top-level Lean declaration
`AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine` (the lone residual `sorry` of the whole
chain) now has a dedicated blueprint block with `\label` + `\lean{}` + `\uses`, and the parent
proof carries a `\uses` edge to it — so the dependency graph now records the transitive dependency
on the unproven obligation.

## Edits (only file touched: AbelianVarietyRigidity.tex)

1. **New lemma block** `lem:rigidity_eqOn_saturated_open_to_affine` inserted immediately after the
   proof of `lem:rigidity_eqOn_dense_open` and before `\section{The theorem of the cube ...}`.
   - `\label{lem:rigidity_eqOn_saturated_open_to_affine}`
   - `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}`
   - `\uses{lem:rigidity_eqOn_dense_open}` (it is the bridge-2 obligation OF that lemma).
   - Statement prose matches the Lean signature: saturated open `U = p₂⁻¹(Vset)`, affine `U₀`,
     `f(U) ⊆ U₀` ⟹ `f` and `retract ≫ f` agree on `U` as scheme morphisms.
   - Proof prose is the two-step route-(c) decomposition: Step 1 per-closed-slice constancy
     (`κ(y)=k̄`, saturated `U` ⊇ fibre `X_y`, `isField_of_universallyClosed` +
     `finite_appTop_of_universallyClosed` + alg-closed ⟹ `Γ(X_y)=k̄`, `ext_of_isAffine`); Step 2
     globalisation over dense closed points (`closure_closedPoints`/Jacobson, coproduct
     dense-range probe ⟹ `ext_of_isDominant_of_isSeparated'`). Records explicitly that relative
     Stein-factorisation / `f_*𝒪=𝒪` is a confirmed Mathlib gap, deliberately avoided.

2. **`\uses` edge** added in the proof of `lem:rigidity_eqOn_dense_open`:
   `\uses{thm:rigidity_lemma}` → `\uses{thm:rigidity_lemma, lem:rigidity_eqOn_saturated_open_to_affine}`.
   The parent bridge-2 paragraph was kept (char-free-route rationale preserved) and now ends with a
   one-line cross-reference pointer to the new block.

3. **Refreshed** `rmk:rigidity_lemma_decomposition` "Status (iter-159)": the stale "two residual
   sorries inside rigidity_eqOn_dense_open" wording is replaced — fibre-over-`y₀` fact is now
   **closed** (so `rigidity_eqOn_dense_open` is `sorry`-free in its own body); the **one** remaining
   chain obligation is bridge~2, now isolated as the named helper
   `\cref{lem:rigidity_eqOn_saturated_open_to_affine}`. The `[IsAlgClosed]` and "Stein deliberately
   avoided" sentences were kept.

## Citation provenance
The `% SOURCE QUOTE PROOF` on the new block was **reused (not freshly read)** from the existing
in-chapter Mumford quote (the "for each `y ∈ V` ... single point of `U`" step), as the directive
recommended — it is the same source step. `% SOURCE` line is the same parent citation:
`[Mumford, Abelian Varieties], Rigidity Lemma (Form I.), Ch. II §4, book p. 43 (PDF page 54)`.
No new verbatim quote was read from `references/mumford-abelian-varieties.pdf`; no new citation
invented.

## Out-of-scope confirmation
- No `\leanok`/`\mathlibok` markers added or removed.
- Cube section, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
  `thm:rigidity_genus0_curve_to_AV` untouched.
- Statement/proof prose of `lem:rigidity_eqOn_dense_open` unchanged except the Edit-2 `\uses` edge
  and the trailing one-line pointer.
- The stale `% TODO (plan agent / blueprint-writer)` comment (L101-107) was left in place: it lives
  inside the proof of `thm:rigidity_lemma` and the directive scoped me to the three precise edits
  ("do NOT touch anything else"). It is now satisfied; flagging for a future cleanup pass.

## Verification
- New block has `\label` + `\lean{}` + `\uses{lem:rigidity_eqOn_dense_open}` (grep L309-310, 303).
- Parent proof `\uses` includes the new label (grep L238).
- Decomposition remark no longer says "two residual sorries" (grep L166: "one remaining obligation").
