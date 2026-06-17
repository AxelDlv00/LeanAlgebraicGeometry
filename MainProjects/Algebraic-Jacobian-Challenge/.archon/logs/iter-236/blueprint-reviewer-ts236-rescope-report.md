# Blueprint Review Report

## Slug
ts236-rescope

## Iteration
236

## Scope
Scoped re-review of exactly two chapters patched by writers this iter: `Picard_TensorObjSubstrate.tex` (d2-balancing expansion of stage (iv)) and `Cohomology_FlatBaseChange.tex` (fbc-brick addition of `\lean{}` hint + proof body to `lem:pushforward_spec_tilde_iso`).

---

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Stage (iv) of `lem:stalk_tensor_commutation` proof (lines ~1964–2023) now contains all three elements the prior must-fix demanded:

    1. **`germ_smul`/stalk-level balancing route** — present and explicit. The prose establishes balancing at the stalk level with every scalar living in `R_x = R.stalk x` throughout, citing `germ_smul` by name: "the germ–scalar compatibility `germ_x(r · s) = (germ_x r)·(germ_x s)` of the germ map `R(W) → R_x` (the Lean lemma `germ_smul`)". The argument is: `revBihom((germ_x r)·(germ_x a), germ_x b) = (germ_x r)·revBihom(germ_x a, germ_x b)` because the scalar stays inside the stalk ring and the balancing over `R_x` is built into `A_x ⊗_{R_x} B_x`.

    2. **Section-level carrier-duality warning** — present and detailed. The paragraph "One must *not* instead reduce this balancing to a section-level identity" (lines ~2003–2014) explains precisely why: at the section level the scalar action lives over the `RingCat` carrier `(R ∘ forget₂)(W)`, not the `CommRingCat` carrier `R(W)` that annotates the section tensor, so `TensorProduct.smul_tmul'` does not apply without the carrier bridge. The warning names the exact failure mode (the restriction-of-scalars wrapper compounded with the CommRingCat/RingCat carrier mismatch) so the prover will not attempt the section-level route.

    3. **Stage-(iii) recipe cross-reference** — present. Lines ~2016–2023 explicitly say the stage-(iv) balancing reuses "the *same* canonical bridge already invoked for the stage-(iii) `R_x`-linearity packaging (the `stalkTensorDescU_smul`/`stalkTensorLinearMap` step, `\cref{lem:stalk_tensor_linear_map}`)". The same `RingEquiv` bridge resolves the carrier obstruction; the prover is pointed at the already-landed tactic pattern rather than asked to re-derive it.

  - All three elements together give the prover a complete recipe to close `revBihom_balanced`: prove balancing in the stalk ring `R_x` using `germ_smul` (not at the section level), and reuse the `stalkTensorDescU_smul` / `RingEquiv` bridge from stage (iii) if a carrier identity is unavoidable.

  - The deferred superseded apparatus (off-path route-(e) lemmas, the flat-whisker standalone, the duplicate `lem:islocallyinjective_whisker_of_W` historical block) is correctly flagged as informational / off-path and does not affect the hard gate.

  **Hard gate: CLEARS.**

---

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pushforward_spec_tilde_iso` (lines ~165–268) now has both elements the prior must-fix demanded:

    1. **`\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}`** — present. The declaration name is specific, in the project namespace, and matches the Lean target the prover is expected to produce.

    2. **Four-movement proof body in `\begin{proof}...\end{proof}`** — present:
       - Movement 1 (*Sections agree on the top open with no transport*): The preimage of `⊤` under `Spec φ` is `⊤` definitionally, so global sections of `(Spec φ)_* M̃` are the underlying abelian group of `M`, agreeing with those of `restr_φ M̃`. No transport needed.
       - Movement 2 (*The comparison ring map is `φ` itself*): The structure-sheaf comparison at `⊤` is conjugate to `φ : R → R'` by the naturality of the `Γ–Spec` unit; hence the `R`-module structure on the pushforward sections is exactly restriction of scalars along `φ`.
       - Movement 3 (*Assemble via full-faithfulness of tilde*): Both sides are quasi-coherent; the counit comparison `Γ(Ñ) → N` is an isomorphism on quasi-coherent objects. Applying `~` to the section-level identification and composing with the counit isomorphisms on each side yields the asserted object isomorphism.
       - Movement 4 (*Scalar compatibility*): The `R`-module structure on both sides agrees via the scalar-tower identity along `φ`.

    3. **Corollary remark** — present (lines ~247–268): explains that the single isomorphism discharges both inputs the affine reduction requires (the Γ-fragment comparison and quasi-coherence of the pushforward), so no separate "pushforward preserves quasi-coherent" theorem is needed in the affine lane.

  - The proof sketch is adequately detailed for a mathlib-build prover: the four movements correspond to four Lean goals the prover can tackle in sequence. The key Mathlib ingredients are identifiable (full-faithfulness of the tilde functor, counit comparison, quasi-coherence closed under isomorphism, `Γ–Spec` naturality), and the scalar-compatibility step is explicitly named. No step requires information the prover would need to guess.

  **Hard gate: CLEARS.**

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings. Both chapters are `complete: true`, `correct: true`, with no must-fix-this-iter items remaining. The prover for `lem:stalk_tensor_commutation` stage (iv) (`revBihom_balanced`) and the prover for `lem:pushforward_spec_tilde_iso` (`AlgebraicGeometry.pushforward_spec_tilde_iso`) may both be dispatched this iter.

Overall verdict: both writer patches (d2-balancing, fbc-brick) resolve their respective must-fix findings; the hard gate is satisfied for `Picard/TensorObjSubstrate.lean` (stage iv / `revBihom_balanced`) and `Cohomology/FlatBaseChange.lean` (`pushforward_spec_tilde_iso`).
