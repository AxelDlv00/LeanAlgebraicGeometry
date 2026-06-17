# Effort Breaker Report

## Slug
fbc-mate

## Target
`lem:pushforward_base_change_mate_cancelBaseChange`
(`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`;
Lean pin `AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange`, unchanged)

## Status
COMPLETE — the monolithic 4-step generator trace is re-expressed as a `\uses`-linked
chain of 4 sub-lemmas + 2 Mathlib anchors, with the single hard crux (the
`pullbackSpecIso` cone-leg identification) isolated as its own atomic block.

## Effort before → after
- target `effort_local`: **5160 → 2254** (statement block preserved verbatim; the long
  proof collapsed to a short chaining of named pieces).
- sub-lemmas added: **6** (4 provable + 2 `\mathlibok` anchors).
- crux now isolated at `effort_local` **961** with **only the Mathlib anchor** as a
  dependency — a small, self-contained obligation a prover can attack alone.

## Chain added (target ← L4 ← {L2, L3} ← L1 ← anchors)
Mathlib anchors (verified exact names via loogle; `\mathlibok`):
- `\label{lem:pullbackSpecIso_mathlib}` `\lean{AlgebraicGeometry.pullbackSpecIso}` —
  pullback of two affine `Spec`-maps is `Spec(S ⊗_R T)` with legs = `Spec` of the tensor
  inclusions (companions `pullbackSpecIso_hom_fst/_hom_snd/_inv_fst/_inv_snd`, all
  confirmed present in `Mathlib.AlgebraicGeometry.Pullbacks`).
- `\label{lem:cancelBaseChange_mathlib}`
  `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` — the cancellation
  `LinearEquiv` `M ⊗_A (A ⊗_R N) ≃ M ⊗_R N`, no flatness, with `cancelBaseChange_tmul`
  and `cancelBaseChange_symm_tmul` (all confirmed in
  `Mathlib.LinearAlgebra.TensorProduct.Tower`).

Provable sub-lemmas:
- **L1 (CRUX)** `\label{lem:pullback_fst_snd_specMap_tensor}`
  `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` — over the generic square
  `Limits.pullback (Spec.map φ) (Spec.map ψ)`, the cone legs `pullback.fst`/`pullback.snd`
  are the `Spec`-maps of the tensor inclusions `A → R'⊗_R A`, `R' → R'⊗_R A` via
  `pullbackSpecIso`. `\uses{lem:pullbackSpecIso_mathlib}`. eff 961, deps 1.
  Proof reduces to Mathlib's `pullbackSpecIso_hom_fst/_snd` once `Spec.map φ`/`Spec.map ψ`
  are matched with the `Spec`-maps of the `algebraMap`s for the algebra structures φ, ψ
  define — that `φ ↔ algebraMap` bridging is the only Mathlib-absent content.
- **L2 (domain read Θ_src)** `\label{lem:base_change_mate_domain_read}`
  `\lean{AlgebraicGeometry.base_change_mate_domain_read}` — `Γ(g^*(f_*M̃)) ≅ R'⊗_R M`.
  `\uses{lem:pushforward_spec_tilde_iso, lem:pullback_spec_tilde_iso}`. eff 850.
- **L3 (codomain read Θ_tgt)** `\label{lem:base_change_mate_codomain_read}`
  `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` —
  `Γ(f'_*(g')^*M̃) ≅ (R'⊗_R A)⊗_A M`.
  `\uses{lem:pullback_fst_snd_specMap_tensor, lem:pullback_spec_tilde_iso,
  lem:pushforward_spec_tilde_iso}`. eff 1336. (This is the read that needs L1, because
  `f'`,`g'` are the pullback legs.)
- **L4 (generator trace)** `\label{lem:base_change_mate_generator_trace}`
  `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` — the conjugated map
  `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹` sends `r'⊗m ↦ (r'⊗1)⊗m` (Steps 1–3 of the old proof: the
  (g')*-unit, `f_*`/pseudofunctor reindexing, the `(g^*⊣g_*)`-transpose).
  `\uses{def:pushforward_base_change_map, lem:base_change_mate_domain_read,
  lem:base_change_mate_codomain_read}`. eff 2011.
- **L5 / conclusion** folded into the target's rewritten proof: `r'⊗m ↦ (r'⊗1)⊗m` is
  `cancelBaseChange⁻¹` by `cancelBaseChange_symm_tmul`; `cancelBaseChange` is a flatness-free
  `LinearEquiv`, so `Γ(α)` is an iso.

Target proof rewritten to chain L2/L3/L4 + the cancelBaseChange anchor; **both** the
target's statement-block and proof-block `\uses` updated to
`{def:pushforward_base_change_map, lem:base_change_mate_domain_read,
lem:base_change_mate_codomain_read, lem:base_change_mate_generator_trace,
lem:cancelBaseChange_mathlib}`. (The leandag graph builds dependency edges from the
**statement-block** `\uses` — updating only the proof-block does not link the chain;
both were updated.) Target statement, `\leanok`, `\lean{}`, and the existing iter-002
`IsIso`-corollary note are all preserved; a short iter-003 `% NOTE` records the split.

## Verification
- `archon blueprint-doctor`: **clean — no structural or rendering findings** (no broken
  `\uses`/`\ref`).
- `archon dag-query node`: target 5160 → 2254; all 6 new nodes present.
- `archon dag-query ancestors --node <target>`: lists all six new nodes (chain linked;
  `pullbackSpecIso_mathlib` and `cancelBaseChange_mathlib` marked `[mathlib]`).
- `begin`/`end` balanced (lemma 23/23, proof 21/21); all referenced labels defined
  exactly once.

## IsIso-vs-equality note (kept consistent with iter-002)
The Lean decl still formalizes the `IsIso (Γ(α))` corollary, not the literal equality
`Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹`. The chain makes `IsIso` follow from
L2+L3+L4+`cancelBaseChange_mathlib` directly. L1
(`lem:pullback_fst_snd_specMap_tensor`) is precisely what unblocks upgrading to the full
equality later, since it is the cone-leg identification needed to *form*
`Θ_tgt` over the generic square. The iter-002 `% NOTE` and the new iter-003 `% NOTE` say
this; no statement was weakened.

## Still hard (re-break candidates)
- `lem:base_change_mate_generator_trace` (eff 2011) is the largest remaining piece — it
  still bundles the three trace steps (unit / `f_*`-reindex / transpose). If a prover
  stalls, re-dispatch the breaker at **fine** granularity to split it into one lemma per
  step (unit `m↦1⊗m`; pseudofunctor reindex; `(g^*⊣g_*)`-transpose `r'⊗m↦r'·u(m)`).
  Left as one block for now per the "one level" directive.
- `lem:pullback_fst_snd_specMap_tensor` (eff 961) is the genuine crux but is now atomic
  and depends only on the Mathlib anchor; its only content is the `φ ↔ algebraMap`
  structure bridging. Not a re-break candidate — it is already a single move modulo that
  bridging.

## Could not decompose (strategy items)
- None. The conserved cut covers every gap the original proof crossed: L1 = the
  Mathlib-absent cone-leg identification; L2/L3 = the two dictionary reads; L4 = the
  generator trace; L5 = the cancelBaseChange identification (anchor).

## Divergence from directive (deliberate, mathematically forced)
- The directive listed L1 among L2's (domain read) dependencies. The domain
  `g^*(f_*M̃)` involves only the genuine cospan `Spec`-maps `g = Spec ψ`, `f = Spec φ`
  — **not** the pullback legs — so the dictionaries apply with no `pullbackSpecIso` step.
  L1 is therefore used by **L3 only** (codomain, where `f'`,`g'` are the legs). L2's
  `\uses` omits L1 accordingly. Net dependency cone is unchanged.

## References consulted
- `references/stacks-coherent.tex` L920–938 — verbatim quotes reused (confirmed against
  the source file, not memory): "We use Schemes, Lemma … to describe pullbacks and
  pushforwards of $\mathcal{F}$." (→ L2), "Namely, $X' = \Spec(R' \otimes_R A)$ and
  $\mathcal{F}'$ is the quasi-coherent sheaf associated to $(R' \otimes_R A) \otimes_A M$."
  (→ L3), and the "boils down to the equality $(R' \otimes_R A) \otimes_A M = R' \otimes_R M$
  as $R'$-modules" block (→ L4). Each new derived block carries `% SOURCE`,
  `% SOURCE QUOTE`, and a visible `\textit{Source: …}` line.

## Notes for dispatcher
- `\lean{}` names assigned by convention (need Lean scaffolds — sorry-bodied decls in
  `AlgebraicGeometry` namespace, alongside the target in
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`):
  - `AlgebraicGeometry.pullback_fst_snd_specMap_tensor` (L1)
  - `AlgebraicGeometry.base_change_mate_domain_read` (L2)
  - `AlgebraicGeometry.base_change_mate_codomain_read` (L3)
  - `AlgebraicGeometry.base_change_mate_generator_trace` (L4)
- The two anchors point at existing Mathlib decls — no scaffold:
  `AlgebraicGeometry.pullbackSpecIso`,
  `TensorProduct.AlgebraTensorModule.cancelBaseChange` (+ its `_symm_tmul`).
- Suggested prover order: **L1 first** (the wall; unblocks L3), then L2/L3 (each a
  two-dictionary composite), then L4, then the target (a 4-line chaining).
- No new macros needed; LaTeX validates and blueprint-doctor is clean.
