# mathlib-analogist whisker252 — directive

## Mode: api-alignment

## Question
In `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, the proof of
`sheafifyTensorUnitIso_hom_natural` (the 4th naturality square of D1′ `pullbackTensorMap_natural`,
~L1914) reduces — after a closed `:= rfl` carrier-normalisation brick `sheafifyTensorUnitIso_hom_eq`
(L1853) and `simp only [MonoidalCategory.tensorHom_def]` — to a pure whisker identity of the shape:

```
(p ▷ Q ≫ P' ◁ q) ≫ (η_{P'} ▷ Q') ≫ ((aP').val ◁ η_{Q'})
  = (η_P ▷ Q) ≫ ((aP).val ◁ η_Q) ≫ ((a.map p).val ▷ (aQ).val) ≫ ((aP').val ◁ (a.map q).val)
```

The hand-proof is known (whisker_exchange on the middle crossings, comp_whiskerRight / whiskerLeft_comp
to merge, then sheafification-unit η-naturality `p ≫ η_{P'} = η_P ≫ (a.map p).val`). **BLOCKER:**
`whisker_exchange`, `whisker_exchange_assoc`, `comp_whiskerRight`, `whiskerLeft_comp` ALL fail to fire
(rw reports "motive not type-correct" / simp reports "unused"). Root cause: the `▷`/`◁` in the goal come
from a FILE-LOCAL `MonoidalCategoryStruct` instance on the `... ⋙ forget₂ CommRingCat RingCat` /
`Sheaf.val` carrier of the scheme-module-sheaf category, which is defeq-but-not-syntactic to the carrier
on which Mathlib's `MonoidalCategory.toMonoidalCategoryStruct` is stated — so the whisker lemmas don't
unify.

This is the THIRD instance this session of the same `.val`/forget₂-carrier friction (it gated D2′ for
11 iters; defeated there by a propositional `:= rfl` strip + `erw` keyed-defeq merge — the
`restrictScalarsId_map`/`sheafifyTensorUnitIso_hom_eq` kit). That kit normalises *composites and
restrictScalars casts* but does NOT cover *whisker-notation unification*.

**Tell me:**
1. Does Mathlib have a canonical idiom for normalising `whiskerLeft`/`whiskerRight` (`◁`/`▷`) notation
   across two defeq-but-not-syntactic `MonoidalCategoryStruct` instances so that `whisker_exchange`,
   `comp_whiskerRight`, `whiskerLeft_comp` fire? (e.g. `MonoidalCategory.whiskerLeft_def` /
   `whiskerRight_def` unfolding to `tensorHom`, a `@[simp]` set, or a `tensorHom`-only restatement that
   sidesteps `◁`/`▷` entirely.)
2. What is the precise FORM of the second carrier-normalisation brick the prover should author — the
   analogue of `sheafifyTensorUnitIso_hom_eq := rfl` but for the whisker projections? Should it restate
   each `f ▷ X` / `X ◁ f` via `MonoidalCategory.whiskerRight`/`whiskerLeft` on the canonical instance,
   or convert the whole goal to `tensorHom` form (`f ⊗ g`) where the canonical lemmas live?
3. Is there a Mathlib precedent where the same situation arises (a sheafification/forget₂ carrier whose
   monoidal struct is defeq to the canonical one) and how is the whisker calculus made to fire there?

The fix must be a project-side brick + named Mathlib lemmas — NOT an upstream PR. Write the persistent
rationale to `analogies/whisker252.md` with the concrete brick statement and the exact lemma names
(verified by loogle/local search) the prover should `rw`/`simp` with after the brick.
