# Effort Breaker Report

## Slug
fbcb

## Target
`thm:flat_base_change_pushforward` (`\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}`)
in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`.

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain of 7 new blocks (1 Mathlib
anchor + 6 to-build sub-lemmas). Build clean: 0 ∞-effort nodes, no broken `\uses`.

## Effort before → after
- target `effort_local`: **5312 → 2489** (target proof body is now a short composite).
- sub-lemmas added: **7** (1 `\mathlibok` anchor, 6 to-build).

## Key finding (de-risks the lane)
The genuinely-missing "H⁰ as a sheaf-condition equalizer" packaging is **directly backed
by Mathlib**: `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts` +
`TopCat.Presheaf.SheafConditionEqualizerProducts.fork` give exactly
`Γ(U) = eq(∏Γ(Uᵢ) ⇉ ∏Γ(Uᵢⱼ))` (Čech degree 0→1) over an arbitrary cover. So the
project work is only (a) specializing to a **finite** affine cover and the
`SheafOfModules`/`X.Modules` value, and (b) the base-change compatibility. Tensor
commuting with the finite products is `TensorProduct.prodRight` (confirmed in Mathlib).
This was the directive's flagged risk ("packaging needs a Mathlib sheaf-condition API
you cannot locate") — it is **located**, so no strategy item is needed there.

## Chain added (target ← … ← anchor)
Bottom-up, inserted between `lem:flat_preserves_equalizer_mathlib` and the target theorem:

- `\label{lem:sheaf_equalizer_products_mathlib}` `\lean{TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts}`
  **`\mathlibok`** — sheaf condition ⇔ the fork `F(U) → ∏F(Uᵢ) ⇉ ∏F(Uᵢⱼ)` is a limit. (effort 0)
- `\label{lem:finite_affine_cover_qcqs}` `\lean{AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact}`
  — QC ⇒ finite affine cover; QS ⇒ overlaps QC; separated ⇒ overlaps affine. `\uses{}` (Mathlib only). (eff ≈ 604)
- `\label{lem:gamma_finite_equalizer}` `\lean{AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork}`
  — `Γ(X,F) = eq(∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F))`, finite products. `\uses{lem:sheaf_equalizer_products_mathlib, lem:finite_affine_cover_qcqs}`. (eff ≈ 815) **[missing infra — H⁰ side]**
- `\label{lem:base_changed_equalizer_diagram}` `\lean{AlgebraicGeometry.baseChange_sheafConditionFork_tensorIso}`
  — base-changed fork = `(−⊗_A B)` applied to the original, term by term via the affine lemma.
  `\uses{lem:gamma_finite_equalizer, lem:affine_base_change_pushforward}`. (eff ≈ 984) **[missing infra — base-change side]**
- `\label{lem:flat_base_change_separated}` `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso_of_isSeparated}`
  — separated case: comparison `Γ(X,F)⊗B → Γ(X_B,F_B)` is iso.
  `\uses{lem:gamma_finite_equalizer, lem:base_changed_equalizer_diagram, lem:flat_preserves_equalizer_mathlib}`. (eff ≈ 840)
- `\label{lem:flat_base_change_mayer_vietoris}` `\lean{AlgebraicGeometry.flatBaseChange_pushforward_mayerVietoris}`
  — QS case by M–V induction on cover size, reducing to the separated case.
  `\uses{lem:flat_base_change_separated, lem:affine_base_change_pushforward, lem:flat_preserves_equalizer_mathlib, lem:finite_affine_cover_qcqs}`. (eff ≈ 1522)
- `\label{lem:flat_base_change_reduce_global_sections}` `\lean{AlgebraicGeometry.flatBaseChange_isIso_iff_gammaTensorComparison}`
  — reduces the sheaf-level base-change map to the module comparison (f_*F quasi-coherent under QCQS; pullback = −⊗B).
  `\uses{def:pushforward_base_change_map}`. (eff ≈ 962)
- **Target `thm:flat_base_change_pushforward`** proof rewritten to a short composite:
  reduction via `lem:flat_base_change_reduce_global_sections`, then conclude via
  `lem:flat_base_change_mayer_vietoris`. Statement+proof `\uses{}` now =
  `{def:pushforward_base_change_map, lem:affine_base_change_pushforward,
  lem:flat_preserves_equalizer_mathlib, lem:flat_base_change_reduce_global_sections,
  lem:flat_base_change_mayer_vietoris}`. All 7 new blocks are ancestors (verified via
  `archon dag-query ancestors`).

## Still hard (re-break candidates)
- `lem:flat_base_change_mayer_vietoris` (eff ≈ 1522) is the largest remaining piece —
  it carries the M–V induction and the left-exact two-member sequence. If a prover
  stalls on it, re-dispatch the breaker at **fine** granularity to split out (i) the
  two-member M–V left-exact equalizer `0→Γ(X)→Γ(W)⊕Γ(V)→Γ(W∩V)` as its own lemma, and
  (ii) the inductive step "FBC for V, W, W∩V ⇒ FBC for X" as a five-lemma/equalizer
  comparison. Both are still standard, so I left them inside one lemma for now.
- `lem:base_changed_equalizer_diagram` (eff ≈ 984): the "intertwines leftRes/rightRes"
  naturality may be fiddly in the `X.Modules` setting; candidate for a fine re-break if
  the prover hits friction wiring `TensorProduct.prodRight` to the fork maps.

## Could not decompose (strategy items)
- None blocking. The one external dependency I could not pin to a concrete Mathlib decl
  is **"f_*F is quasi-coherent for a QCQS morphism"** (Stacks 01XJ), used inside
  `lem:flat_base_change_reduce_global_sections`. I cited it in prose (Stacks 01XJ /
  Mathlib pushforward-quasi-coherence) but did not anchor it `\mathlibok` because I did
  not verify the exact Mathlib name. If the prover cannot find it in Mathlib, this
  becomes a small to-build sub-lemma (or a strategy item) — flagged here, not hidden.

## References consulted
- Mathlib (via lean LSP search), verbatim API confirmed:
  `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts`,
  `TopCat.Presheaf.SheafConditionEqualizerProducts.fork`,
  `TensorProduct.prodRight` (tensor preserves finite products).
- `references/stacks-coherent.md` Tag 02KH — verbatim quotes for the separated /
  quasi-separated / reduction paragraphs were already present in the chapter's existing
  `% SOURCE QUOTE PROOF` block (themselves read from `stacks-coherent.md`); I copied the
  relevant snippets into the per-lemma `% SOURCE QUOTE` headers (citation discipline
  satisfied: `% SOURCE`, `% SOURCE QUOTE`, `\textit{Source:}` on the three
  02KH-derived blocks L3/L4/L5 and on the reduction L0).

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold in the Lean file):
  `AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact`,
  `AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork`,
  `AlgebraicGeometry.baseChange_sheafConditionFork_tensorIso`,
  `AlgebraicGeometry.flatBaseChange_pushforward_isIso_of_isSeparated`,
  `AlgebraicGeometry.flatBaseChange_pushforward_mayerVietoris`,
  `AlgebraicGeometry.flatBaseChange_isIso_iff_gammaTensorComparison`.
- The Mathlib anchor `lem:sheaf_equalizer_products_mathlib` is `\mathlibok` and needs no
  Archon proof; the prover should `open`/cite it directly when building L2.
- This lane is genuinely **independent of the walled FBC-A `_legs` crux**: the only
  FBC-A node it touches is `lem:affine_base_change_pushforward` (already `\leanok`), used
  as a black box per-term. A prover can pick up L1 (pure scheme geometry) and L2 (Mathlib
  sheaf-condition specialization) immediately, bottom-up.
