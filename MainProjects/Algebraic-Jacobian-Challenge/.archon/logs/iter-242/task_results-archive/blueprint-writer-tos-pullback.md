# Blueprint Writer Report

## Slug
tos-pullback

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### EDIT A — proof of `lem:pullback_unit_iso` (`pullbackUnitIso`)
- **Revised** the `\begin{proof}` body: replaced the obsolete affine chart-chase
  (premised on the now-retracted false claim that `(Opens.map f.base).Final` "need not
  hold globally for a general morphism") with the correct one-line argument:
  `Opens.map f.base` is a frame homomorphism ⇒ preserves finite limits ⇒ representably
  flat ⇒ `final_of_representablyFlat` gives `.Final` **unconditionally** for every `f`
  ⇒ the Mathlib instance `instIsIsoPullbackObjUnitToUnitOfFinal` fires directly, and
  `pullbackUnitIso f` is the bundled iso of the comparison. No chart-chase.
- **Deleted** the false sentence "For a general morphism `f` the comparison functor need
  not be `Final` globally…" and the whole chart factorization / globalizer narrative.
- **Fixed the proof `\uses{}`**: removed `lem:pullbackObjUnitToUnit_comp` and
  `lem:unitToPushforwardObjUnit_comp` (the one-line proof does not consume them); kept
  `def:scheme_modules_tensorobj`.
- The lemma **statement** block (and its `\lean{...}`/`\label`) is untouched. The two
  standalone composition-coherence blocks `lem:pullbackObjUnitToUnit_comp` /
  `lem:unitToPushforwardObjUnit_comp` are **retained unchanged** (correct standalone).

### EDIT B — §6 narrative + proof of `lem:pullback_tensor_iso` (`pullbackTensorIso`)
- **Revised** the narrative paragraph under `\label{sec:tensorobj_pullback_monoidality}`
  that carried the retracted premise: removed the false claims that the abstract left
  adjoint forces monoidality to be shown "by local-chart finality" and that no
  sectionwise tensorator route exists. New prose: pullback **is** extension of scalars
  and **is** strong monoidal (base-change tensorator is an iso for every ring map, no
  flatness); the only subtlety is that the project's `f^*` is an abstract left adjoint,
  so the strong-monoidal structure is built on a concrete model `P` and transported via
  `leftAdjointUniq`. Folded in the two NEGATIVE results from the analyst: (i) "(op)lax
  monoidal ⇒ preserves invertibles for free" is FALSE (`Γ(P¹,O(1))=0`), so the iso must
  be proved; (ii) the locally-trivial route is rejected (revives the deleted
  `dual`/`exists_tensorObj_inverse` arc). Kept the correct "flatness doesn't help" point.
- **Revised** the `\begin{proof}` of `lem:pullback_tensor_iso` to the new three-step
  route (mirroring Mathlib `ModuleCat/Monoidal/Adjunction.lean`, PR #36599 named in prose
  only, no fabricated `% SOURCE`):
  1. concrete strong-monoidal `P = sheafify ∘ (sectionwise extension of scalars)`,
     tensorator = `AlgebraTensorModule.distribBaseChange` sheafified, unit =
     `sheafifyTensorUnitIso`;
  2. `P ⊣ pushforward f`;
  3. transport to `(pushforward f).leftAdjoint = pullback f` via `leftAdjointUniq`,
     yielding the genuine **isomorphism** natural in `M,N`.
  Removed the old "(a) build map / (b) finality chart-chase / (c) pointwise is enough"
  sketch and the trailing `Functor.CoreMonoidal.ofOplaxMonoidal` paragraph; replaced the
  latter with a one-line note that the full packaging is delivered by `P.Monoidal`.
- **Updated `\uses{}`** on both the statement and proof of `lem:pullback_tensor_iso` to
  `{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}` (the latter for the
  `sheafificationCompPullback` / `leftAdjointUniq` machinery genuinely cited).
- The lemma **statement** of `lem:pullback_tensor_iso`, its `% SOURCE` /
  `% SOURCE QUOTE` block (Stacks `lemma-tensor-product-pullback`), and the
  `\textit{Source: …}` line are **kept verbatim**.

## Cross-references introduced
- `\uses{lem:tensorobj_restrict_iso}` added to `lem:pullback_tensor_iso` (statement +
  proof) — target exists in this same chapter (`\label{lem:tensorobj_restrict_iso}`).
- No new `\uses` targets outside existing labels; removed two `\uses` entries from the
  `pullback_unit_iso` proof (targets still exist as standalone blocks).

## References consulted
- `analogies/pullback-tensor.md` — the read-only Mathlib analogist consult that fixed
  the route; source of the three-step concrete-model-+-`leftAdjointUniq` plan, the
  `distribBaseChange` / `sheafifyTensorUnitIso` ingredients, and both negative results
  (Γ lax-but-not-invertibility-preserving; locally-trivial route rejected).
- No new `% SOURCE QUOTE` blocks written; the only external-source citation in the
  edited region (`lemma-tensor-product-pullback`, already backed by
  `references/stacks-modules.tex`) was kept verbatim and not re-derived. No
  reference-retriever needed.

## Macros needed (if any)
- None.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **Stale `% NOTE:` (review-owned).** The `% NOTE (iter-241 review): …` comment
  immediately above `\begin{lemma} … \label{lem:pullback_unit_iso}` (≈ line 2823) was
  the instruction to perform EDIT A; it is now satisfied and reads as stale history
  ("Blueprint-writer to rewrite the proof to the one-liner"). I left it in place because
  `% NOTE:` annotations are the review agent's domain, not the writer's. The review agent
  should drop it next pass.
- The new tensor-iso proof names project/Mathlib ingredients the prover will rely on:
  `AlgebraTensorModule.distribBaseChange`, `sheafifyTensorUnitIso` (already landed),
  `SheafOfModules.sheafificationCompPullback`, `Adjunction.leftAdjointUniq`,
  `(pushforward f).leftAdjoint`. These are the genuine dependencies; if a prover finds
  the concrete adjunction `P ⊣ pushforward` (Step 2) is Mathlib-absent at the pin, that
  is the single build obligation, not a blueprint gap.

## Strategy-modifying findings
None. The route correction (abstract-left-adjoint pullback IS strong monoidal, built on
a concrete model and transported via `leftAdjointUniq`) is consistent with the existing
strategy; it only retracts a false intermediate premise in two proof sketches and does
not change any consumer-facing statement (`lem:isinvertible_pullback` is unchanged).
