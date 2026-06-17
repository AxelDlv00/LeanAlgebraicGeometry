# Refactor Directive — scaffold the AV-rigidity upstream file

## Goal
Create a NEW Lean file `AlgebraicJacobian/AbelianVarietyRigidity.lean`, UPSTREAM of
`AlgebraicJacobian/Jacobian.lean`, scaffolding the committed route-(c) AV-rigidity stack as
`sorry`-bodied declarations. This breaks the import cycle (`RigidityKbar → Rigidity →
Jacobian`) that currently prevents `genusZeroWitness` (in `Jacobian.lean`) from consuming the
genus-0 rigidity keystone. **You insert signatures + `sorry` bodies only — do NOT prove
anything.** A prover fills the bodies next iteration.

## Blueprint (source of truth for the statements)
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (`% archon:covers
AlgebraicJacobian/AbelianVarietyRigidity.lean`). Read it. It defines four `\lean{}` targets:

1. `AlgebraicGeometry.rigidity_lemma` (`thm:rigidity_lemma`) — the Rigidity Lemma (Mumford
   Form I): `X` a complete (proper) variety, `Y`, `Z` any varieties over `k̄`, `f : X × Y → Z`
   a morphism with `f(X × {y₀})` a single point; then `f` factors through the projection
   `p₂ : X × Y → Y` (i.e. `∃ g : Y → Z, f = p₂ ≫ g`). The cube-free prover-ready entry.
2. `AlgebraicGeometry.morphism_P1_to_grpScheme_const` (`prop:morphism_P1_to_AV_constant`) —
   every morphism `ℙ¹_{k̄} → A` (A an abelian variety / smooth proper geom-irred group scheme)
   is constant. (Blocked downstream on the theorem of the cube — sorry.)
3. `AlgebraicGeometry.genusZero_curve_iso_P1` (`prop:genusZero_curve_iso_P1`) — a smooth proper
   geom-irred genus-0 curve over `k̄` is isomorphic to `ℙ¹_{k̄}`. (Blocked on Riemann–Roch —
   sorry.)
4. `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` (`thm:rigidity_genus0_curve_to_AV`)
   — THE HEADLINE that `genusZeroWitness` will consume: a pointed `f : C → A` from a genus-0
   curve `C` over `k̄` killing a `k̄`-point equals the constant morphism `toUnit C ≫ η[A]`.

## Signature guidance — IMPORTANT

### Declaration 4 (the headline) — pin it to the existing template
`rigidity_genus0_curve_to_grpScheme` must mirror `AlgebraicGeometry.rigidity_over_kbar`
(in `AlgebraicJacobian/RigidityKbar.lean`, lines 75–88) **VERBATIM EXCEPT dropping the
`[CharZero kbar]` instance**. Copy that signature exactly (same `variable {kbar} [Field kbar]
[IsAlgClosed kbar]`, same `{C : Over (Spec (.of kbar))}` with `[SmoothOfRelativeDimension 1
C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, the `(_hgenus : genus C = 0)`, the
`{A : Over (Spec (.of kbar))} [GrpObj A] [IsProper A.hom] [Smooth A.hom]
[GeometricallyIrreducible A.hom]`, `(f : C ⟶ A)`, `(p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)`,
`(_hf : p ≫ f = η[A])`, conclusion `f = (toUnit C ≫ η[A])`), only WITHOUT `[CharZero kbar]`.
Body `:= sorry`. This is the signature the consumer (`genusZeroWitness.key`) needs, so getting
it right matters most.

### Declarations 1–3 — best-effort signatures from the chapter
Encode these from the chapter prose. For `rigidity_lemma`, use the project's existing idiom
for the ambient category — work in `Over (Spec (.of kbar))` (or `Scheme`) with categorical
products `X ⨯ Y` (`CategoryTheory.Limits.prod`) and the projection `prod.snd`. State the
hypothesis "`f(X × {y₀})` is a single point" and the conclusion "`∃ g, f = prod.snd ≫ g`" in
whatever well-typed form compiles; the prover will refine the encoding next iter. Use
`[IsProper X.hom]` for "complete". Bodies `:= sorry`. If a faithful Lean statement of any of
1–3 is genuinely not expressible against Mathlib `b80f227` without new infrastructure, encode
the closest well-typed approximation, mark it with a `/- SCAFFOLD: signature provisional,
prover to refine; see blueprint thm:... -/` comment, and note it in your report — do NOT
omit the declaration (the chapter's `\lean{}` target must resolve).

## Imports / topology
- The new file: `import AlgebraicJacobian.Genus` (provides `genus` + the Mathlib opens). Add
  any additional Mathlib import needed for `GrpObj`/`MonObj`/`toUnit`/`η[]`/products/`Proj` —
  determine by what makes it compile; mirror the `open` lines from `RigidityKbar.lean`
  (`open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj`).
- **Do NOT import** `AlgebraicJacobian.Rigidity`, `AlgebraicJacobian.Jacobian`, or
  `AlgebraicJacobian.RigidityKbar` (that would re-create / not break the cycle). The file must
  sit upstream of `Jacobian`.
- Add `import AlgebraicJacobian.AbelianVarietyRigidity` to the root file
  `AlgebraicJacobian.lean` (place it after `Genus`, before `Jacobian`).
- You do NOT need to wire `Jacobian.lean` to import the new file this round — that happens when
  a prover wires `genusZeroWitness.key`. Leave `Jacobian.lean`, `RigidityKbar.lean`, and
  `genusZeroWitness` UNTOUCHED.
- Header: copy the Apache license header block from `RigidityKbar.lean`; add a module docstring
  pointing at `blueprint/src/chapters/AbelianVarietyRigidity.tex`; `set_option autoImplicit
  false`; `universe u`; `namespace AlgebraicGeometry`.

## Acceptance
- `lake build` is GREEN (the new file compiles; `sorry`s are the only gaps; new file appears in
  the build).
- No new `axiom` declarations. No protected signature modified. No proof filled.
- Each of the four `\lean{}` targets exists as a declaration in the new file.

## Out of scope
- Proving any body. Touching any other `.lean` file except the new file + the root
  `AlgebraicJacobian.lean` import line.
- Editing blueprint chapters.
