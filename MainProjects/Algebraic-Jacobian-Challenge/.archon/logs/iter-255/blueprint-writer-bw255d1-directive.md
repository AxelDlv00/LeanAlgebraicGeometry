# Blueprint-writer directive — bw255-d1 (D1′ proof fix in Picard_TensorObjSubstrate.tex)

## Scope
Edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Two proof-sketch fixes (one
must-fix, one major) flagged by the iter-254 lean-vs-blueprint check. Do NOT touch statements,
`\lean{}` pins, or markers. Do NOT add `\leanok`/`\mathlibok`.

## Fix 1 — MUST-FIX: `lem:pullback_tensor_map_natural` proof (the D1′ sorry)

The current proof sketch says of "Square 2" only that "the abstract oplax δ is natural in both
arguments — this holds for any oplax monoidal functor." That is mathematically true but
Lean-inadequate: a prover following it hits `failed to synthesize MonoidalCategory (PresheafOfModules
X.ringCatSheaf.obj)` when applying `δ_natural`, because after unfolding `pullbackTensorMap` the
domain ring is spelled `X.ringCatSheaf.obj` while the monoidal instance is registered only on the
canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling (defeq, not syntactic).

REWRITE the Square-2 step of the proof to describe the verified fix (mathlib-analogist mapin255,
iter-255 — read `analogies/mapin255.md`). In prose (NO Lean tactic blocks — describe mathematically
with at most a short inline notation), convey:
- The comparison `δ` is the oplax-monoidal comparison of the presheaf-level pullback functor
  `F = PresheafOfModules.pullback φ'`, whose defining ring map `φ' = (toRingCatSheafHom f).hom` must
  be presented with its DOMAIN ring in the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat`
  spelling. When the comparison map's definition is unfolded the domain ring re-presents as the defeq
  `X.ringCatSheaf.obj` spelling, on which the monoidal structure is not syntactically available.
- The naturality of `δ` (`δ ∘ F(a⊗b) = (Fa ⊗ Fb) ∘ δ`) is applied by re-establishing the canonical
  domain-ring spelling at the functor argument itself (an explicit type-ascription of the defining
  ring map to the canonical composite-functor source), which makes the domain monoidal instance
  resolve; the rewrite is by reducible-defeq matching (zeta gap from the unfolded `let`). This is a
  proof-internal device — NO restatement of `pullbackTensorMap` or its helper isos is needed, and the
  unit-case lemma `pullbackTensorMap_unit_isIso` (D2′) is unaffected.
- After this Square-2 step the comparison commutes past `F(a⊗b)`, leaving Squares 3
  (`sheafifyTensorUnitIso_hom_natural`, now CLOSED) and 4 (`pullbackValIso_hom_natural`, CLOSED) plus
  the bifunctoriality of `⊗` (`tensorHom_comp_tensorHom`).
Keep it a mathematical description of the four-square paste with the carrier-spelling subtlety made
explicit; the prover supplies the exact tactics.

## Fix 2 — MAJOR: update the stale proof of `lem:sheafify_tensor_unit_iso_natural`

This lemma was CLOSED iter-254 by a DIFFERENT route than the chapter prescribes. The current sketch
describes a 3-step `TensorProduct.induction_on` element descent (sections → elements → pure tensors).
The actual proof works at the categorical (tensor-morphism) level: it restates the iso's `.hom` as a
SINGLE tensor-product-of-morphisms (`a.map (η_P ⊗ η_Q)`) keeping every term in one monoidal instance
(a `tensorHom`-pin), merges the two functor-image factors, and closes by the bifunctoriality law
`(f₁⊗f₂) ∘ (g₁⊗g₂) = (f₁∘g₁) ⊗ (f₂∘g₂)` applied as a term, together with the two single-component
naturality squares of the sheafification unit `η`. REPLACE the TensorProduct-induction description
with this shorter categorical description. Remove the now-false "the whisker-exchange law does NOT
close it, so we descend to elements and induct" narrative.

## Source / citation discipline
Both lemmas are project-bespoke (the sheaf-level transport of the presheaf oplax `δ`); no external
verbatim quote is required beyond what the chapter already cites for `lem:pullback_tensor_map` /
`sec:tensorobj_pullback_monoidality`. Do NOT invent a citation.

## Out of scope
- Do NOT edit any other chapter.
- Do NOT modify `lem:pullback_tensor_map_natural` / `lem:sheafify_tensor_unit_iso_natural` STATEMENTS
  or their `\lean{}`/`\uses{}`.
- If you find a strategy-level issue, report it under "Strategy-modifying findings"; do not paper it.
