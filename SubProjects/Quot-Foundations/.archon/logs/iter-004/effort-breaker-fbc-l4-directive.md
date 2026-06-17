# Effort-breaker directive — FBC L4 generator trace

## Target

`lem:base_change_mate_generator_trace`
(`\lean{AlgebraicGeometry.base_change_mate_generator_trace}`) in
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (the block currently
around the "Generator trace of the section-level base-change map" lemma, in the
subsection "The section-level mate computation, decomposed").

## Granularity

**Fine — one mathematical claim per lemma.** This is the single live crux for
the entire FBC-A mate close (the parent
`lem:pushforward_base_change_mate_cancelBaseChange` is already a proved
assembly modulo this one leaf). A prior coarse decomposition reduced it from an
abstract sheaf-map statement to a concrete tensor-module statement; we now need
the final split so the prover can close each piece in isolation.

## Context (what the leaf currently asserts, and what is already proved)

- The two reads are DONE (proved, axiom-clean): `lem:base_change_mate_domain_read`
  identifies the domain `Γ(g^*(f_*M̃)) ≅ R'⊗_R M`, and
  `lem:base_change_mate_codomain_read` identifies the codomain
  `Γ(f'_*(g')^*M̃) ≅ (R'⊗_R A)⊗_A M` (Lean tensor order `(A⊗[R]R')⊗_A M`).
- The Lean decl `base_change_mate_generator_trace` records the **`IsIso`** form
  `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)` of the conjugated section map
  `R'⊗_R M ⟶ (A⊗_R R')⊗_A M` — see the existing `% NOTE (iter-003)` in the
  block (keep that note). The body is `sorry`.
- `lem:cancelBaseChange_mathlib` (Mathlib
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`, `\mathlibok`) is available.

## Proof structure to cut along

The iter-003 prover analysis (verified) reduces the obstacle to **constructing
one bundled `R'`-linear regrouping isomorphism and identifying the conjugate
with it on a generator**. Split the leaf into these sub-lemmas, each with its
own `\label`, `\lean{}` pin naming the to-be-created Lean decl, `\uses{}`,
statement, and informal proof:

1. **Regroup equiv (pure tensor algebra, Mathlib-backed).** A bundled
   `R'`-linear isomorphism
   `(A ⊗_R R') ⊗_A M  ≅[R']  R' ⊗_R M`
   (Lean/Mathlib `pullbackSpecIso` tensor order `A ⊗[R] R'`). Built as the
   composite of the heterobasic `AlgebraTensorModule.comm` (×2, the `R'`-linear
   versions, since the `R'`-action enters through the `A ⊗_R R'` factor) and
   `TensorProduct.AlgebraTensorModule.cancelBaseChange`. State the route
   explicitly: `(A⊗_R R')⊗_A M ≃ M⊗_A(A⊗_R R') ≃[cancelBaseChange] M⊗_R R' ≃ R'⊗_R M`.
   On the generator it sends `(r'⊗1)⊗m ↦ r'⊗m` (equivalently its inverse sends
   `r'⊗m ↦ (r'⊗1)⊗m`). `\uses{lem:cancelBaseChange_mathlib}`. This is the
   buildable, no-geometry sub-lemma — the prover should close it outright.

2. **Generator identification.** The conjugated section-level map
   `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ : R'⊗_R M ⟶ (A⊗_R R')⊗_A M` equals the **inverse** of
   the regroup equiv of (1) — i.e. it sends `r'⊗m ↦ (r'⊗1)⊗m`. This is the
   adjoint-mate generator trace already written in the current proof body (the
   three-step itemized trace through the unit / restriction / transpose). Keep
   that trace as this sub-lemma's informal proof. `\uses` sub-lemma (1), the two
   reads, and `def:pushforward_base_change_map`.

3. **`IsIso` corollary (the leaf as currently pinned).** From (2) the conjugate
   equals a `LinearEquiv` (`regroupEquiv.symm`), which is an iso; hence
   `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`. This keeps the existing
   `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` pin and its
   `IsIso`-form `% NOTE`. `\uses` sub-lemmas (1) and (2).

## Out of scope

- Do NOT touch `lem:pushforward_base_change_mate_cancelBaseChange` (the parent
  assembly — already proved modulo this leaf) beyond, if necessary, extending
  its `\uses{}` to include the new sub-lemma labels.
- Do NOT touch the affine reduction (`lem:affine_base_change_pushforward`) or the
  flat lane (`thm:flat_base_change_pushforward`).
- Do NOT add `\leanok` anywhere (the deterministic sync owns it). You MAY mark
  `\mathlibok` ONLY on a genuine Mathlib anchor if you introduce a new one
  (`cancelBaseChange` already has `lem:cancelBaseChange_mathlib`; reuse it —
  likely no new anchor needed).
- Preserve every existing `% SOURCE` / `% SOURCE QUOTE` / `% NOTE` comment in the
  block; carry them onto the appropriate sub-lemma.

## Deliverable

The `base_change_mate_generator_trace` block replaced by the 3-sub-lemma
`\uses`-linked chain above, each formalizable as one small Lean target, so the
prover can close sub-lemma (1) immediately and reduce (3) to a one-line
`rw` + `infer_instance` once (2) lands.
