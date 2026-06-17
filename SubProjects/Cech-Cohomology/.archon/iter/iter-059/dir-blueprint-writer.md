# Blueprint-writer directive — chapter `Cohomology_CechHigherDirectImage.tex` (iter-059)

You are updating ONE chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. All
tasks below are localized edits to existing blocks (plus ONE new small sub-lemma block). Do NOT
restructure the chapter. Do NOT add or remove `\leanok` (the deterministic sync phase owns it). Do
NOT touch `% NOTE:` marker lines (the review agent owns those) EXCEPT where task C explicitly adds a
new block.

Strategy context (the slice that matters): two prover lanes dispatch this iter off this chapter.
Lane A = the Stub-1 inductive assembly `widePullback_coproduct_iso` (= `lem:coproduct_distrib_fibrePower`)
+ consumer `lem:cech_backbone_left_sigma`. Lane B = the 5 Need#1 jShriekOU-transport sub-lemmas in
`OpenImmersionPushforward.lean`. Both must have complete+correct blueprint coverage before dispatch.

---

## Task A — σ-component slice-product bridge note (lvb-csi MAJOR)

In `lem:coproduct_distrib_fibrePower_zero` (label at line ~7595) and `lem:coproduct_distrib_fibrePower`
(label ~7688): the prover's Lean σ-component normal form is the **slice product**
`∏ᶜ fun k => Over.mk (f (σ k))` (a product in `Over S`), NOT the informal `X_{σ(0)} ×_S ⋯ ×_S X_{σ(p)}`
(wide-pullback form) the prose currently writes. The two are canonically isomorphic via
`lem:widePullback_overX_eq_prod` (`CategoryTheory.widePullback_overX_eq_prod`), and the conversion to
the geometric intersection-open form happens at `lem:cech_backbone_left_sigma`. Add a short bridge
sentence to BOTH blocks stating: "In the Lean formalization the σ-component is kept in the
slice-product normal form `∏ᶜ_{k} Over.mk(f∘σ k)` in `Over S` (minimizing wide-pullback instance
bookkeeping); it is identified with the wide fibre power via `lem:widePullback_overX_eq_prod` at the
assembly site `lem:cech_backbone_left_sigma`." Ensure `lem:widePullback_overX_eq_prod` is in the
`\uses{}` of both the statement and proof blocks of `lem:coproduct_distrib_fibrePower` (the proof
block at ~7713 already lists it; add to the statement-block `\uses` at ~7691 if absent, and add to
`lem:coproduct_distrib_fibrePower_zero`).

## Task B — UNIVERSE-REDUCTION note (iter-059 finding — CRITICAL, must reach the prover)

Mathlib's `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst` is stated for `{α : Type}`
(universe 0) ONLY. The cover index `𝒰.I₀ : Type v` is a free universe `v` (a `Finite` type). So the
distributivity leaves `lem:prod_coproduct_distrib` / `lem:coproduct_fibrePower_reindex` and the
inductive assembly `lem:coproduct_distrib_fibrePower` are stated/proved at the index universe
`Type 0`, and the consumer `lem:cech_backbone_left_sigma` performs a **universe reduction**: pick an
equivalence `𝒰.I₀ ≃ Fin n` (from `[Finite 𝒰.I₀]`), reindex the cover family `f` and all
coproduct/wide-pullback indices along it to land at `Fin n : Type 0`, apply the `Type 0` assembly,
and transport back. Add a paragraph to the proof of `lem:cech_backbone_left_sigma` (and a one-line
caveat to `lem:coproduct_distrib_fibrePower`'s statement) documenting this. State explicitly that
naively widening the leaves to `Type*` is NOT possible because it breaks `isIso_sigmaDesc_fst`. Add a
Mathlib dependency anchor block `lem:isIso_sigmaDesc_fst_mathlib` (statement: in a `FinitaryPreExtensive`
category, for `{α : Type} [Finite α]` and a family with `Sigma.desc` of the injections invertible,
the comparison `Sigma.desc` of pullback-fst's is iso), `\lean{CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst}`,
marked `\mathlibok`, and `\uses` it from `lem:prod_coproduct_distrib`.

## Task C — NEW sub-lemma `lem:overProd_coproduct_distrib` (the Over-S binary-product bridge)

The induction consumes the distributivity in `Over S` **binary-product** form, not the C-level
pullback form of `lem:prod_coproduct_distrib`. Add a new `\begin{lemma}…\end{lemma}` block right after
`lem:prod_coproduct_distrib` (i.e. after line ~7650):
- `\label{lem:overProd_coproduct_distrib}`
- `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib}` with a
  `% NOTE: build target.` line (this declaration does NOT exist yet — it is Lane A's prover target).
- `\uses{lem:prod_coproduct_distrib, lem:overProdLeftIsoPullback_mathlib}`
- Statement: for `{ι : Type} [Finite ι]`, objects `A : ι → Over S` and `B : Over S` in a
  `FinitaryPreExtensive` category with pullbacks, `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S`.
- Proof sketch: `Over.forget S` reflects isomorphisms (a slice morphism is iso iff its `.left` is);
  `(∐ᵢ Aᵢ : Over S).left = ∐ᵢ Aᵢ.left` and `(Y ⨯ Z : Over S).left ≅ pullback Y.hom Z.hom` via
  `Over.prodLeftIsoPullback`; reduce to the C-level `lem:prod_coproduct_distrib` and match `.left`.
Also add a small Mathlib anchor block `lem:overProdLeftIsoPullback_mathlib`
(`\lean{CategoryTheory.Over.prodLeftIsoPullback}`, `\mathlibok`, statement: the underlying object of a
binary product in `Over S` is the pullback of the two structure maps). Then add
`lem:overProd_coproduct_distrib` to the `\uses{}` of `lem:coproduct_distrib_fibrePower` (statement and
proof), since the inductive step uses the Over-S form.

## Task D — `\uses{}` on `lem:pushforward_iso_preserves_qcoh` (blueprint-reviewer iter-058 soon-fix)

The block at line ~9363 has `\lean{}` but no `\uses{}`. Add an accurate `\uses{}` to its statement and
proof blocks reflecting what the Lean proof needs: that quasi-coherence is preserved when a sheaf of
modules is transported along the module-category equivalence induced by a scheme isomorphism
(`pushforwardEquivOfIso`). Inspect the surrounding Need#1 blocks (`lem:jshriek_transport_along_iso`,
`lem:pushforward_commutes_free`, `lem:pushforward_commutes_sheafify`, `lem:yoneda_transport_along_homeo`)
to pick the correct dependency labels and a Mathlib anchor for "an equivalence/iso of schemes
preserves `IsQuasicoherent`" if one is referenced there; if the fact is genuinely a Mathlib primitive,
add a `\mathlibok` anchor block and `\uses` it. Keep the `\uses` minimal and truthful.

## Task E — Clear coverage debt by bundling lean_aux helper names into related `\lean{}` blocks

The leandag lists these prover-built helpers as unmatched (no blueprint node). Per project convention,
cover each by appending its fully-qualified Lean name into the `\lean{...}` list of the nearest related
block (do NOT create standalone blocks for these):
- `CategoryTheory.widePullback_overX_isLimit` → into `lem:widePullback_overX_eq_prod`'s `\lean{...}`.
- `CategoryTheory.overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso` → into
  `lem:coverArrow_over_sigma`'s `\lean{...}` (these are the abstract `Over S` generalizations of the
  AlgebraicGeometry-specific versions that block already pins).
- `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso` → into `lem:coproduct_distrib_fibrePower`'s
  `\lean{...}` (the Fin-succ product split used by the induction).
- `AlgebraicGeometry.affine_tildeVanishing_general` → into `lem:affine_cech_vanishing_general_seed`'s
  `\lean{...}` (the general-affine private wrapper, parallel to how `affine_tildeVanishing` is pinned).
- `AlgebraicGeometry.mem_iInf_opens_of_finite` → into `lem:widePullback_openImm_inter`'s `\lean{...}`.
- `AlgebraicGeometry.sectionCechComplexV` → into `lem:cechSection_complex_iso`'s `\lean{...}`.
(Do NOT touch `AlgebraicGeometry.CechAcyclic.affine` — it is dead, scheduled for deletion by a refactor.)

## Out of scope
- Do NOT edit any chapter other than `Cohomology_CechHigherDirectImage.tex`.
- Do NOT add/remove `\leanok`. Do NOT strip the existing `% NOTE: build target` lines on the four
  already-built leaves (review owns that marker cleanup).
- Do NOT alter the protected target `lem:cech_computes_cohomology` or any frozen-signature block.
