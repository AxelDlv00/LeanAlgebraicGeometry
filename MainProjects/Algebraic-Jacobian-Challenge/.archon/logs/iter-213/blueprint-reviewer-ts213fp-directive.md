# Blueprint Reviewer Directive (fast-path, HARD-GATE re-review)

## Slug
ts213fp

## Why this dispatch
This is the same-iter fast-path re-review authorized by the HARD GATE. The chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` was rewritten THIS iter to correct a
confirmed must-fix: the proof of `lem:tensorobj_assoc_iso` previously used a mathematically FALSE
"Flatness is free" step (sectionwise flatness of invertible sheaves over all opens, false for
non-affine opens — confirmed iter-212 by the prover + lean-vs-blueprint-checker). It has been
rewritten to "route (c)" (vetted by mathlib-analogist ts-monoidal213 + strategy-critic ts213
this iter). I need a fresh complete+correct verdict to decide whether
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` may enter this iter's prover objectives.

## Do your normal whole-blueprint pass
Per your descriptor you always read the whole blueprint; do so. But the gate decision this iter
turns on ONE chapter — `Picard_TensorObjSubstrate.tex` — and specifically these points:

1. **`lem:tensorobj_assoc_iso` (route (c)) — is the proof now complete + correct?**
   The argument: the associator is the 3-step composite (absorb inner sheafification left,
   `a.mapIso α`, absorb right); each absorption iso reduces via the bridge
   `lem:isiso_sheafification_map_of_W` to "the whiskered sheafification unit `η ▷ P` (resp
   `M ◁ η`) lies in `J.W`". Surjectivity free (`isLocallySurjective_whiskerLeft`); injectivity
   local-on-target via a trivializing cover where `P|_V ≅ 𝒪_V` (from `IsLocallyTrivial`,
   `restrictIsoUnitOfLE`), presheaf tensor sectionwise so the right unitor carries `η ▷ P|_V`
   onto `η|_V` (locally injective: `isLocallyInjective_toSheafify`); glue. Hypotheses re-scoped to
   `LineBundle.IsLocallyTrivial M N P`. Verify: no residual reliance on the dead flat step; the
   local-on-cover injectivity argument is mathematically sound and detailed enough to formalize;
   the `\uses{}` is consistent (drops `lem:flat_whisker_localizer`, `def:scheme_modules_isinvertible`;
   adds `def:IsLocallyTrivial`, `lem:isiso_sheafification_map_of_W`).

2. **New bridge lemma `lem:isiso_sheafification_map_of_W`** — is its statement well-formed and is
   the cited justification (Mathlib `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` read
   at one morphism) adequate? (It is already proven sorry-free in Lean iter-212.)

3. **`lem:flat_whisker_localizer`** — now annotated off-critical-path with both halves pinned
   (`W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`). Confirm the annotation is accurate and the
   block is internally consistent (it is a valid standalone lemma, just not used by the associator).

4. **Carrier forward note on `lem:tensorobj_isoclass_commgroup`** — the associator is now
   `IsLocallyTrivial`-scoped while the group carrier text references `IsInvertible`. Confirm the
   forward note (the bridge `IsInvertible ⇒ IsLocallyTrivial` is the only added obligation, off the
   associator critical path) is coherent and does not leave the chapter self-contradictory. Note:
   strategy-critic ts213 observed inverses exist *within* `IsLocallyTrivial` directly
   (`L^∨ = Hom(L,𝒪)`), so the group may not need the bridge at all — flag if the chapter should say so.

## Gate question (answer explicitly)
Is `Picard_TensorObjSubstrate.tex` now `complete: true` AND `correct: true` with NO
must-fix-this-iter finding touching it? If yes, the gate clears and the TS file may be dispatched.
If a must-fix remains, name it precisely.
