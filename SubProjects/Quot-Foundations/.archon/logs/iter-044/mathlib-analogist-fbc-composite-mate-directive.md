# Mathlib-analogist directive

## Mode: api-alignment

## Question
The FBC keystone `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj`
(FlatBaseChange.lean ~1848) has resisted 7 iters. All per-layer legs are axiom-clean
(`base_change_mate_reindex_conj_pullbackLeg`, `_pushforwardCollapse`, `_crossLayer`); the SOLE remaining
gap is ASSEMBLING the recognition: building the two COMPOSITE adjunctions `adjL`, `adjR` (each a stack of
the project's `Scheme.Modules`-level adjunctions: tilde⊣Γ, pullback(g')⊣push(g'), the Spec φ layer,
extend⊣restrict_ψ, tilde⊣Γ_{R'} — ~5 layers) plus a comparison `β`, then
`(conjugateEquiv adjL adjR).injective` discharged by the legs.

Is there a Mathlib idiom that produces the composite-adjunction mate/conjugate recognition WITHOUT manually
assembling `adjL`/`adjR`/`β` layer-by-layer? Specifically inspect:
- `CategoryTheory.Adjunction.comp` + how `mateEquiv` / `conjugateEquiv` interact with composed adjunctions;
- `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` and the surrounding `CompositionIso.lean` /
  `Mates.lean` API — is there a ready lemma `conjugateEquiv (adj₁.comp adj₂) … = …` that telescopes a
  composite into single-pair factors automatically?
- whether `mateEquiv` naturality/`whiskerLeft`/`whiskerRight` lemmas let the recognition be done by
  `simp`-with-the-conjugate-set rather than an explicit `β` construction.

## Deliverable
Either (a) a concrete Mathlib-aligned shape for `adjL`/`adjR`/`β` + the recognition lemma to apply
(name the exact Mathlib decls), giving a future dedicated mathlib-build lane a precise target; or
(b) a verdict that no composite-mate API exists and the explicit β-assembly is genuinely required
(multi-hundred-LOC bespoke). Persist findings to `analogies/fbc-composite-mate-recognition.md`.

## Out of scope
Do NOT re-examine the σ-rebasing question (settled iter-040, `analogies/quot-sigma-rebasing.md`).
Read-only; no Lean edits.
