# Blueprint Writer Report

## Slug
bw255d1

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** proof of `\lem{lem:pullback_tensor_map_natural}` (D1′) — MUST-FIX.
  - Removed the stale iter-254 `% NOTE` that prescribed a STRUCTURAL spelling-pin
    refactor of `pullbackTensorMap` + its helper isos (that guidance is superseded:
    the verified iter-255 fix is proof-internal, not a refactor).
  - Replaced the vague "the abstract oplax δ is natural — this holds for any oplax
    monoidal functor" Square-2 step with an explicit mathematical description of the
    carrier-spelling subtlety: δ is the oplax comparison of the presheaf pullback
    functor `F = PresheafOfModules.pullback φ'` with `φ' = (toRingCatSheafHom f).hom`;
    the monoidal structure lives on the canonical
    `𝒪_X ∘ forget₂ CommRingCat RingCat` spelling; when the comparison is unfolded the
    domain ring re-presents in a defeq-but-not-syntactic spelling; naturality
    `δ ∘ F(a⊗b) = (Fa⊗Fb) ∘ δ` is applied by re-establishing the canonical domain-ring
    spelling at the functor argument via an explicit type-ascription of `φ'` to the
    canonical composite-functor source, matched up to reducible defeq (zeta gap from
    the unfolded `let`). Stated as a proof-internal device that leaves
    `pullbackTensorMap`, its helper isos, and `pullbackTensorMap_unit_isIso` (D2′)
    untouched.
  - Removed the now-false "fourth square … not closed by the formal monoidal
    interchange (whisker-exchange) law … descend to sections … TensorProduct
    induction" narrative. Squares 1/3/4 are now described as already-closed natural
    transformations (Square 3 = `sheafifyTensorUnitIso`, Square 4 = `pullbackValIso`),
    with the final tensor-of-morphisms factoring via bifunctoriality
    (`tensorHom_comp_tensorHom`).
  - No Lean tactic blocks; mathematical prose only, with short inline notation.

- **Revised** proof of `\lem{lem:sheafify_tensor_unit_iso_natural}` (S3 / Square 3) — MAJOR.
  - Removed the obsolete iter-254 reviewer `% NOTE` (its "replace the induction prose
    with this route" instruction is now carried out).
  - Replaced the 3-step `TensorProduct.induction_on` element descent (sections →
    elements → pure tensors) with the actual categorical (tensor-morphism) route:
    (1) restate the iso's `.hom` as a SINGLE tensor of morphisms
    `a.map(η_P ⊗ η_Q)` kept inside one monoidal instance (the `tensorHom`-pin),
    (2) merge the two functor-image factors by functoriality
    `F(g) ∘ F(h) = F(g∘h)`,
    (3) close by the bifunctoriality/interchange law
    `(f₁⊗f₂)∘(g₁⊗g₂) = (f₁∘g₁)⊗(f₂∘g₂)` applied as a term, together with the two
    single-component naturality squares of the sheafification unit η.
  - Removed the "whisker-exchange law does NOT close it, so we descend to elements
    and induct" framing.

## Cross-references introduced
- None new. The `\uses{}` lists on both proof blocks were left unchanged
  (`lem:pullback_tensor_map`, `lem:presheaf_pullback_oplaxmonoidal`,
  `lem:sheafify_tensor_unit_iso_natural`, `lem:pullback_val_iso_natural`) — all
  referenced labels already exist in this chapter.

## References consulted
- `analogies/mapin255.md` — the verified iter-255 fix (option A, `show … from` type
  ascription re-presenting `φ'` at the canonical `⋙ forget₂` spelling) that the new
  Square-2 prose describes mathematically. (Not a citation source; project-internal.)
- No external `references/` files opened: both lemmas are project-bespoke (sheaf-level
  transport of the presheaf oplax δ), so no `% SOURCE:` / `% SOURCE QUOTE:` blocks were
  written or needed, per directive's source/citation discipline note.

## Macros needed (if any)
- None.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **Stale clause in a STATEMENT block (out of my write-scope).** The statement of
  `lem:sheafify_tensor_unit_iso_natural` (the `\begin{lemma}…\end{lemma}` body, not the
  proof) still ends with: "Equivalently: after descending to sections over each open U
  and passing to the underlying module components, the naturality square is the
  bilinear, sectionwise naturality of the sheafification unit η, verified one pure
  tensor p⊗q at a time by TensorProduct induction." This describes the OLD (now
  replaced) proof route and contradicts the revised proof. I did NOT edit it because
  the directive places statements out of scope. The plan agent (who may edit statement
  prose) should trim that "Equivalently: … by TensorProduct induction" sentence down to
  the bare claim ("… is natural in both module arguments") to keep the statement
  consistent with the categorical proof.

## Strategy-modifying findings
None. Both fixes are presentation-level (Lean-adequacy of the proof sketches); the
mathematical content and the strategy are unchanged.
