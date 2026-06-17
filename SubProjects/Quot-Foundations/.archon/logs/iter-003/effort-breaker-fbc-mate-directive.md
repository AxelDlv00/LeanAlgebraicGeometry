# Effort Breaker Directive

## Slug
fbc-mate

## Target
lem:pushforward_base_change_mate_cancelBaseChange
(in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, label at line ~975;
Lean pin `AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange`)

## Granularity
one level — split the existing 4-step generator-trace proof into a `\uses`-linked
chain of sub-lemmas, isolating the single genuinely-hard crux as its own atomic block.

## Proof structure (cut along these seams — the proof body is already written in the chapter)

The lemma computes the global-sections incarnation `Γ(α)` of `pushforwardBaseChangeMap`
in the affine–affine model (`ψ : R → R'`, `φ : R → A`, `M` an `A`-module,
`X' = Spec(R' ⊗_R A)`, `F = M̃`) and identifies it with Mathlib's
`TensorProduct.AlgebraTensorModule.cancelBaseChange⁻¹`. The existing proof has four
steps (chapter lines ~1061–1151). Cut into these sub-lemmas:

- **L1 — the `pullbackSpecIso` identification (THE CRUX; make it its own atomic block).**
  Over the generic pullback square `Limits.pullback (Spec.map φ) (Spec.map ψ)`, identify
  the cone legs `pullback.fst` / `pullback.snd` with the `Spec`-maps of the canonical
  tensor-inclusions `R' → R' ⊗_R A` and `A → R' ⊗_R A`, via
  `AlgebraicGeometry.pullbackSpecIso` (and its `_hom_fst` / `_hom_snd` / `_inv_fst`
  companion lemmas). This is the one Mathlib-absent piece that blocks the whole proof —
  every prior prover report and the lean-vs-blueprint checker flagged exactly this
  identification as the wall. State it as a standalone lemma so a prover can attack it in
  isolation. Assign a `\lean{}` name by convention, e.g.
  `AlgebraicGeometry.pullback_fst_snd_specMap_tensor` (note it for the dispatcher).
- **L2 — domain dictionary read `Θ_src`.** Using L1 plus the two proved dictionaries
  (`lem:pushforward_spec_tilde_iso` then `lem:pullback_spec_tilde_iso`), the global
  sections `Γ(g^*(f_* M̃))` are identified with `R' ⊗_R M` as an `R'`-module.
- **L3 — codomain dictionary read `Θ_tgt`.** Symmetrically (`lem:pullback_spec_tilde_iso`
  then `lem:pushforward_spec_tilde_iso`, plus L1), `Γ(f'_*(g')^* M̃)` is identified with
  `(R' ⊗_R A) ⊗_A M` as an `R'`-module.
- **L4 — generator trace.** With domain/codomain pinned by L2/L3, `Γ(α)` sends
  `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m` (Steps 1–3 of the existing proof: the (g')*-unit `m ↦ 1⊗m`,
  `f_*`/pseudofunctor reindexing, and the `(g^*⊣g_*)`-transpose `r'⊗m ↦ r'·u(m)`).
- **L5 / conclusion (may fold into the target's rewritten proof).** This map is exactly
  `cancelBaseChange⁻¹` (`cancelBaseChange_symm_tmul`); since `cancelBaseChange` is a
  Mathlib `LinearEquiv` with no flatness hypothesis, `Γ(α)` is an iso.

Then rewrite the target's proof to `by L1, L2, L3, L4` with the appropriate `\uses{}`.
Preserve the target's statement and `\lean{}` pin unchanged. Note in the report: the
Lean decl currently formalizes the `IsIso (Γ(α))` corollary (see the existing
`% NOTE (iter-002)`); keep that note consistent — the chain should make the `IsIso`
conclusion follow from L1–L4, and L1 is what unblocks upgrading to the full equality
later if desired.

If `cancelBaseChange` / `cancelBaseChange_symm_tmul` or `pullbackSpecIso` companion
lemmas are best stated as `\mathlibok` Mathlib anchors, do so (verify the exact Mathlib
name before marking `\mathlibok`).

## Strategy context
FBC route (Čech-free, direct-on-sections). This mate lemma is the single
highest-leverage sorry: it feeds `lem:affine_base_change_pushforward` and the whole
affine close. The blueprint sketch is already adequate; the issue is that it is ONE
monolithic goal whose hard kernel (the `pullbackSpecIso` identification) is buried.
Decomposing exposes that kernel as a small ready piece. Do not weaken the statement.

## References
- `references/nitsure-hilbert-quot.md` → not the primary here.
- The mate computation follows Stacks Project, Cohomology of Schemes, Lemma "Affine base
  change" (`references/stacks-coherent.tex`, the "boils down to the equality
  (R'⊗_R A)⊗_A M = R'⊗_R M" step, ~L927–938) — already quoted verbatim in the target
  block's `% SOURCE QUOTE`. Reuse those quotes; if you author a sub-block that needs a
  fresh verbatim quote you do not have locally, spawn a reference-retriever (your
  write-domain includes `references/**`), wait, read, then write.
