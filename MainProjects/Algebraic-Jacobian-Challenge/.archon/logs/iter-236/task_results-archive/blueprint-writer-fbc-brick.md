# blueprint-writer — fbc-brick report (iter-236)

## Scope
Edited ONLY `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, the
`\label{lem:pushforward_spec_tilde_iso}` brick block. No other lemma, theorem, or
chapter touched.

## Changes made
1. **`\lean{...}` hint added.** `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}`
   placed on the lemma block (after the `\label`), giving the next prover a concrete
   target name.

2. **`\begin{proof}` sketch added** (textbook prose, no Lean tactic strings). Four
   movements, matching the directive:
   - Sections agree on `⊤` with no transport (`(Spec.map φ)⁻¹ ⊤ = ⊤` definitional;
     pushforward-on-`⊤` = module on preimage; same underlying abelian group `M`
     vs `restrictScalars φ M`).
   - The comparison ring map is `φ` itself, via naturality of the
     `Γ ⊣ Spec` adjunction iso (`Scheme.ΓSpecIso`) ⇒ the section `R`-action is
     restriction of scalars along `φ`.
   - Assemble the object iso via tilde full-faithfulness + counit (`fromTildeΓ`)
     isomorphisms on both (quasi-coherent) sides.
   - Residual `map_smul`-shaped scalar-compatibility = restriction-of-scalars
     commutes with `tilde` on global sections via the `algebraMap` scalar tower
     (named as the math fact, the idiom Mathlib's `Tilde` uses).
   Lean identifier names appear only as names of cited facts, never as tactic blocks.

3. **Corollary note added** to the existing remark: a closing sentence stating that,
   because both inputs the affine reduction needs (the Γ-fragment comparison feeding
   `affineBaseChange_pushforward_iso`, and quasi-coherence of the pushforward) are
   corollaries of this one object iso, the lemma is the sole remaining Mathlib-absent
   gap for the whole affine lane. (The remark already enumerated (a) and (b); this
   ties them off.)

## Constraints honored
- No `\leanok`/`\mathlibok` markers added or removed (the brick remains unproven —
  no `\leanok` on lemma or proof).
- Tilde-full-faithfulness reframe and the `[IsQuasicoherent F]`-based theorem
  statements left intact.
- Mathematical prose only.

## Note for the next prover
The expected target namespace is `AlgebraicGeometry.pushforward_spec_tilde_iso`; the
prover may adjust the exact namespace. The closing algebra for the consuming affine
theorem (`TensorProduct.AlgebraTensorModule.cancelBaseChange`) is already present in
Mathlib with no flatness — this brick is the last gap.
