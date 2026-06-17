# mathlib-analogist — D3′ base-change-square coherence (proactive arming)

## Mode: api-alignment

## Why you are being called (proactive, not reactive)
D2′ on the Picard pullback–tensor critical path just CLOSED axiom-clean (iter-250) after a
five-iter "reduce-don't-close" wall whose root cause was TACTICAL: `rw [Category.assoc]` / `rw [h]`
**silently failing to match** on `≫`-composites of presheaf-of-modules morphisms whose implicit ring
argument is spelled `X.ringCatSheaf.val` vs the `rfl`-equal `X.presheaf ⋙ forget₂ CommRingCat RingCat`
(defeq-not-syntactic ⇒ `rw`'s motive fails to unify). It was defeated by (a) a propositional strip
lemma `restrictScalarsId_map : (PresheafOfModules.restrictScalars (𝟙 R)).map g = g := rfl` used with a
SYNTACTIC `rw` (the analogist-suggested `show`-into-syntactic-category idiom blew >6.4M heartbeats and
is a DEAD END), and (b) load-bearing `erw` keyed-defeq merges where two `pushforward`/`pullback` images
were defeq-but-differently-spelled.

The next critical-path step **D3′** is in the SAME mate-calculus family but at a harder position, and the
progress-critic flagged a high risk it reproduces the 4-iter PARTIAL cycle if the prover is sent cold.
**Your job: find the exact Mathlib idiom for D3′'s specific goal and hand back named lemmas + the
friction-defeating tactics, so we can embed them in the prover directive BEFORE dispatch.**

## The declaration to align (D3′)
`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict` (to be authored).
Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, `lem:pullback_tensor_map_basechange`
(read it). Informal: for `f : Y ⟶ X`, an open `U ⊆ X` with preimage `f⁻¹U`, `g : f⁻¹U → U` the
restriction, and open immersions `j : U ↪ X`, `j' : f⁻¹U ↪ Y` (so `f ∘ j' = j ∘ g`), the sheaf-level
comparison `δ_sheaf = pullbackTensorMap` for `f`, restricted along `j'`, agrees — through the pullback
pseudofunctoriality iso `pullbackComp` of `f ∘ j' = j ∘ g` — with `δ_sheaf` for `g` on the restricted
modules `(j^*M, j^*N)`. Hence the restriction of `δ^f_sheaf(M,N)` to `f⁻¹U` is an iso iff
`δ^g_sheaf(j^*M, j^*N)` is.

## Proven template to mirror (the CLOSED unit analog)
D3′ is "the tensorator analog of the already-built unit-comparison composition coherence
`pullbackObjUnitToUnit_comp`", proved by the same mate calculus. READ
`AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` (TensorObjSubstrate.lean ~L900) and
`unitToPushforwardObjUnit_comp` — they establish `pbu(h≫f) = (pullbackComp h f).inv ≫
(pullback h).map(pbu f) ≫ pbu h` via adjunction-mate transport. The blueprint names the route as
Mathlib's `Functor.OplaxMonoidal.comp_δ` (δ of a composite oplax functor = whiskered composite of the
factor δ's) + the conjugation `conjugateEquiv_pullbackComp_inv` of the pullback pseudofunctor isos.

## Questions (answer each with named Mathlib decls + file:line where possible, verified)
1. **`Functor.OplaxMonoidal.comp_δ` (or its current Mathlib name/spelling):** confirm it exists, its
   exact signature, and how to apply it to the two factorisations of the square's underlying functor
   (`(j')^* ∘ f^*` vs `g^* ∘ j^*`). Is there a `δ`-naturality lemma `Functor.OplaxMonoidal.δ_natural`
   (D1′ uses it too) — exact name + signature?
2. **Pseudofunctoriality conjugation:** what is the current Mathlib idiom relating `pullbackComp` (left
   adjoints) to `pushforwardComp` (right adjoints) via the adjunction mate? Confirm
   `conjugateEquiv_pullbackComp_inv` (or the right name) and the `mateEquiv`/`conjugateEquiv` API shape.
3. **`.val`-spelling friction at the D3′ position:** D3′ works on arbitrary `M,N` restricted to an
   affine chart (NO unitality shortcut, unlike D2′ which used `left_unitality_hom`). Which of the
   iter-250 idioms transfer: the propositional `restrictScalarsId_map`-style syntactic strip, the `erw`
   keyed-defeq merge, `W_whiskerRight_of_W`/`W_of_isIso_sheafification` family? Name the specific
   reassociation/merge tactic likely needed for the δ-naturality square after folding
   `sheafificationCompPullback` and stripping `restrictScalars` wrappers.
4. **Is there a Mathlib lemma that directly gives "oplax δ commutes with restriction along an open
   immersion / a strong-monoidal functor"** that would shortcut the mate calculus? (The blueprint notes
   restriction along `j'` is the strong-monoidal restriction functor of `lem:tensorobj_restrict_iso`.)
5. **Dead-end guard:** confirm the `show`-into-syntactic-category strip is the wrong tool here (as it
   was for D2′), or identify when it IS safe.

## Output
Persistent `analogies/d3-251.md` (the rationale + named-lemma table with verified signatures) + the
`task_results` report. Be concrete: file:line for each named Mathlib lemma, and the exact tactic idioms
to embed in the D3′ prover directive. Flag any "ALIGN WITH MATHLIB" if the project is about to build a
parallel API instead of using `comp_δ`/`conjugateEquiv`.
