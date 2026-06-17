# Blueprint Writer Report

## Slug
tos-pivot

## Status
COMPLETE — all six required edits applied to `sec:tensorobj_pullback_monoidality`; Lane A
re-routed from the descoped general `pullbackTensorIso` to the local-trivialisation route.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
- **Rewrote the section intro** (`sec:tensorobj_pullback_monoidality`, formerly L2566–2618).
  Replaced the concrete-strong-monoidal-`P` "primary route" framing with four paragraphs:
  (i) descopes the general comparison (Mathlib-scale — absent
  `PresheafOfModules.extendScalars` + absent topological inverse-image left Kan extension;
  Stacks proof "Omitted"; unneeded since every consumer pulls back only invertibles);
  (ii) states the local-trivialisation route over `δ_sheaf`; (iii) the two negative results
  — the oplax-doesn't-preserve-invertibles `Γ(ℙ¹,𝒪(1))=0` counterexample AND the careful
  distinction that this is the FORWARD bridge `IsInvertible ⟹ IsLocallyTrivial` (available),
  not the shelved REVERSE bridge (off-path); (iv) the guardrail: check `δ_sheaf` iso ON A
  COVER via `lem:isiso_of_isiso_restrict`, NEVER stalkwise (would revive the d.2 stalk-tensor
  sink).
- **Added lemma** `\label{lem:presheaf_pushforward_laxmonoidal}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` — pins the iter-242
  landed instance: presheaf pushforward is lax monoidal (the `μ` comparison) as
  `pushforward₀OfCommRingCat ∘ restrictScalars φ`. Proof sketch added. Archon-local, no source.
- **Added lemma** `\label{lem:presheaf_pullback_oplaxmonoidal}` /
  `\lean{...presheafPullbackOplaxMonoidal}` `\uses{lem:presheaf_pushforward_laxmonoidal}` —
  pins the other iter-242 instance: presheaf pullback is oplax monoidal, carrying the
  comparison MAP `δ` via `Adjunction.leftAdjointOplaxMonoidal`; explicitly flagged that `δ`
  is only a map and upgrading to iso is the open content. Proof sketch added. Archon-local.
- **Revised** `lem:pullback_tensor_iso` (general iso) → DESCOPED remark. Retitled
  "[…— descoped]"; **dropped the `\lean{}` pin** (decl does not exist / not being built;
  added an explicit "no Lean declaration is associated with this statement" note). Added a
  prominent descope paragraph in the statement (Mathlib-scale + off-path). Statement math and
  the `lemma-tensor-product-pullback` SOURCE QUOTE kept intact. Rewrote the "Two shortcuts"
  proof paragraph: removed the STALE "no `pushforward.LaxMonoidal`" claim and replaced it with
  the corrected account — the presheaf-level lax/oplax structure now EXISTS
  (`lem:presheaf_pushforward_laxmonoidal`, `lem:presheaf_pullback_oplaxmonoidal`) and yields
  the comparison MAP `δ` for free; the residual difficulty is upgrading `δ` to an iso, which
  the concrete model needs the absent inverse image for. Added a proof preface stating the
  argument is documentary (not formalised). Updated proof `\uses` to add
  `lem:presheaf_pullback_oplaxmonoidal`.
- **Added lemma** `\label{lem:pullback_tensor_map}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}`
  `\uses{lem:presheaf_pullback_oplaxmonoidal, def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}`
  — the sheaf-level comparison MAP `δ_sheaf : f^*(M⊗N) ⟶ f^*M ⊗ f^*N` for GENERAL M,N, built
  by transporting the presheaf `δ` through `sheafificationCompPullback` + `sheafifyTensorUnitIso`.
  Map only; no iso claim. Proof sketch added. Archon-original, no source.
- **Added lemma** `\label{lem:isinvertible_implies_locallytrivial}` /
  `\lean{...IsInvertible.isLocallyTrivial}`
  `\uses{def:scheme_modules_isinvertible, def:IsLocallyTrivial}` — the FORWARD bridge:
  on a scheme, `IsInvertible M ⟹ IsLocallyTrivial M`. Statement carries TWO source quotes
  (`lemma-invertible-is-locally-free-rank-1` statement + `lemma-invertible` statement), and a
  `% SOURCE QUOTE PROOF:` for the converse direction. Proof sketch added (stalk is invertible
  over local ring ⟹ free rank 1 via `stalkTensorIso`; finite presentation ⟹ free stalk
  spreads to a free neighbourhood). Flagged as the route's genuine new cost.
- **Rewrote** `lem:isinvertible_pullback` statement `\uses` and proof to the local-trivialisation
  route. New `\uses`: `{def:scheme_modules_isinvertible, lem:pullback_tensor_map,
  lem:isinvertible_implies_locallytrivial, lem:pullback_unit_iso, lem:isiso_of_isiso_restrict,
  lem:tensorobj_preserves_locally_trivial}` (DROPPED `lem:pullback_tensor_iso`). New proof:
  witness `f^*N`; required iso = `δ_sheaf⁻¹ ≫ f^*e ≫ pullbackUnitIso`; `δ_sheaf` shown iso on
  the invertible pair via common affine trivialising cover + preimage cover +
  `lem:isiso_of_isiso_restrict`, with the "restricts to the canonical `𝒪⊗𝒪≅𝒪`" compatibility
  flagged as the crux for the prover. Kept the `lemma-pullback-invertible` SOURCE QUOTE +
  SOURCE QUOTE PROOF intact.

## Cross-references introduced
- `\uses{lem:presheaf_pushforward_laxmonoidal}` in `lem:presheaf_pullback_oplaxmonoidal` — defined in this chapter.
- `\uses{lem:presheaf_pullback_oplaxmonoidal}` in `lem:pullback_tensor_map` and in the `lem:pullback_tensor_iso` proof — defined in this chapter.
- `lem:pullback_tensor_map`, `lem:isinvertible_implies_locallytrivial` — defined in this chapter; consumed by `lem:isinvertible_pullback`.
- `def:IsLocallyTrivial`, `lem:IsLocallyTrivial_pullback` — verified present in `Picard_LineBundlePullback.tex`.
- `lem:isiso_of_isiso_restrict`, `lem:tensorobj_preserves_locally_trivial`, `lem:pullback_unit_iso`, `def:scheme_modules_tensorobj`, `def:scheme_modules_isinvertible`, `lem:tensorobj_restrict_iso`, `sec:tensorobj_pic_carrier` — all verified present in this chapter.
- NOTE: the directive's suggested label `lem:isIso_of_isIso_restrict` (camelCase) and
  `def:line_bundle_islocally_trivial` do NOT exist; the real labels are
  `lem:isiso_of_isiso_restrict` (lowercase) and `def:IsLocallyTrivial`. I used the real labels.

## References consulted
- `references/stacks-modules.tex` (L4066–4079) — verbatim statement quote of
  `lemma-invertible` (invertible ⟺ ∃N M⊗N≅𝒪; locally a direct summand of finite free; N ≅ SheafHom).
- `references/stacks-modules.tex` (L4159–4165) — verbatim statement quote of
  `lemma-invertible-is-locally-free-rank-1`.
- `references/stacks-modules.tex` (L4186–4198) — verbatim `% SOURCE QUOTE PROOF:` for the
  converse (invertible ⟹ locally free rank 1) direction.
- `references/stacks-modules.tex` (L4142–4157) — re-read to keep the existing
  `lemma-pullback-invertible` statement + proof quotes intact.

## Macros needed (if any)
- None. `\SheafHom` appears only inside `% SOURCE QUOTE` comments (verbatim Stacks text), not
  in rendered prose, so no macro is required for compilation.

## Reference-retriever dispatches (if any)
- None. All required source text was present in `references/stacks-modules.tex`.

## Notes for Plan Agent
- **Lean-vs-blueprint sync (MAJOR, now resolved in prose):** the two iter-242 presheaf
  instances (`presheafPushforwardLaxMonoidal`, `presheafPullbackOplaxMonoidal`) are now pinned
  via `\lean{}` blocks. `sync_leanok` should pick up `\leanok` on these two statement blocks
  if the decls are axiom-clean.
- **New prover target order:** `lem:pullback_tensor_map` (the `δ_sheaf` map) and
  `lem:isinvertible_implies_locallytrivial` (the forward bridge) are the two NEW bricks the
  `lem:isinvertible_pullback` proof depends on; both should be dispatched before
  `IsInvertible.pullback`. `lem:isinvertible_implies_locallytrivial` is flagged in-prose as the
  route's genuine new cost (stalk-local-ring + finite-presentation over `SheafOfModules`); its
  d.2 stalk-tensor input (`stalkTensorIso`) is already in-tree.
- The crux the prover must discharge in `lem:isinvertible_pullback` is the "`δ_sheaf` restricts
  to the canonical `𝒪⊗𝒪≅𝒪`" compatibility on each trivialising preimage open — flagged
  explicitly in the proof body.
- `lem:pullback_tensor_iso` is retained as a documentary descoped remark with NO `\lean{}` pin;
  the blueprint-doctor should no longer flag a missing `pullbackTensorIso` decl.

## Strategy-modifying findings
None. The route change (general `pullbackTensorIso` → invertible-case local trivialisation) was
already decided at the strategy level (strategy-critic ts243 SOUND, progress-critic ts243
corrective); this writer only encoded it into the blueprint. No new strategy-level issue
surfaced while drafting.
