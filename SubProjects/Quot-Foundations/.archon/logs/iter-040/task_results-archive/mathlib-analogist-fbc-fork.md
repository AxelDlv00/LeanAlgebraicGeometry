# Mathlib Analogist Report

## Mode
api-alignment

## Slug
fbc-fork

## Iteration
040

## Question
For the `_legs_conj` mate/conjugate coherence, which Mathlib idiom should we align to —
**Fallback A** (element/component `ext` + a change-of-rings dictionary) or **Fallback B**
(restructure so the composite IS a `conjugateEquiv`/`leftAdjointCompIso` value so `.injective`
applies without a reframing step)? Is there a third idiom?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Composite mate coherence: `.injective`+conjugate-dictionary vs element-`ext` | ALIGN_WITH_MATHLIB (Fallback B) | critical |
| Fallback A (element-`ext` on the composite) | DIVERGENT-AND-WRONG (drop it) | critical |
| Third idiom: functor-layer-at-a-time conjugate transport | ALIGN_WITH_MATHLIB | critical |

## Ranked recommendation

**1 (adopt) — Fallback B, executed as the Mathlib "third idiom".** Mathlib proves every
multi-functor coherence between *left-adjoint* composites by staying inside the conjugate calculus:
build the comparison as a conjugate value, then close with
`obtain …surjective; apply conjugateEquiv.injective; simp/rw [conjugate push-through dictionary]`.

- **Citations.** The route exemplars are in
  `Mathlib/CategoryTheory/Adjunction/CompositionIso.lean`:
  `leftAdjointCompNatTrans₀₁₃_eq_conjugateEquiv_symm` (line 130),
  `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` (line 140),
  `leftAdjointCompNatTrans_assoc` (line 155), `leftAdjointCompIso_assoc` (line 168). The push-through
  dictionary is in `Mathlib/CategoryTheory/Adjunction/Mates.lean`: `conjugateEquiv_comp` (337,
  `@[reassoc (attr := simp)]`), `conjugateEquiv_symm_comp` (354), `conjugateEquiv_whiskerLeft` (525),
  `conjugateEquiv_whiskerRight` (536), `conjugateEquiv_associator_hom` (501),
  `unit_conjugateEquiv_symm` (305), plus `conjugateEquiv_leftAdjointCompIso_inv`
  (`CompositionIso.lean:82`). The directly-analogous precedent for the project's OBJECTS is
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean`, which *defines*
  `pullbackComp := leftAdjointCompIso … (pushforwardComp)` (line 131) and proves `pullback_assoc`
  (142), `pullback_id_comp` (151), `pullback_comp_id` (156) by handing the obvious pushforward law to
  the matching `leftAdjointCompIso_*` — zero element-`ext`, zero hand normalisation. conj-0′
  (`pullbackComp_eq_leftAdjointCompIso`, `FlatBaseChange.lean:1198`) is the project's already-proved
  copy of that very definitional bridge.
- **Concrete first proof step.** After `subst hfst; subst hsnd; rw
  [base_change_mate_codomain_read_legs_conj]`, do NOT `ext`. Introduce `adjL`/`adjR` as conj-2d does
  (`FlatBaseChange.lean:1667-1670`) and rewrite the LHS toward `(conjugateEquiv adjL adjR).symm …`
  by splitting it with `conjugateEquiv_symm_comp` — generalising conj-2d's `huce :=
  unit_conjugateEquiv_symm adjL adjR β.hom N` from the bare cross-layer factor to the full
  four-factor inner composite, inserting the pullback leg (conj-2b) and the Γ-collapses (conj-2c) as
  the additional conjugate factors. Then `apply (conjugateEquiv adjL adjR).injective` (or
  `Equiv.apply_eq_iff_eq`) and close with `simp [conjugateEquiv_comp, conjugateEquiv_symm_comp,
  conjugateEquiv_whiskerLeft, conjugateEquiv_whiskerRight, conjugateEquiv_leftAdjointCompIso_inv,
  unit_conjugateEquiv_symm]` plus the three legs. The mistake of the last 3 iters was trying to
  recognise the WHOLE composite as one conjugate value in one shot; Mathlib never does that — it
  peels one functor layer / one adjunction pair at a time with the `whisker`/`comp` push-through
  lemmas (note `leftAdjointCompNatTrans₀₁₃_…`'s closing line is literally
  `simp […, ← conjugateEquiv_whiskerLeft _ _ adj₀₁]`).

**2 (reject) — Fallback A, element-`ext` on the composite + change-of-rings dictionary.** This is the
iter-035 dead end, not a Mathlib idiom. Mathlib uses element-`ext` ONLY to prove the *atomic*
dictionary leaves (`conjugateEquiv_comp`, `conjugateEquiv_whiskerLeft/Right`, `unit_conjugateEquiv`,
`conjugateEquiv_associator_hom` — each `ext X; simp` over a SINGLE adjunction pair where unit/counit
naturality + triangle identities give a normal form). On the project's three-pair section composite
there is no such normal form (iter-035, `FlatBaseChange.lean:2097`), because element-`ext` bottoms
out at the cross-layer naturality of `gammaPushforwardIso` under the `X.Modules` instance diamond.

## Must-fix-this-iter

- **Composite mate coherence**: `_legs_conj` (`FlatBaseChange.lean:1757-1822`) must be closed by the
  conjugate-`.injective`/push-through-dictionary route (Fallback B + third idiom), NOT by element-`ext`.
  Cost of staying on Fallback A: a bespoke per-component change-of-rings simp set that re-derives, by
  hand and under the instance diamond, the `gammaPushforwardIso`-naturality that
  `unit_conjugateEquiv_symm` already gives conj-2d for free — re-proving conj-2d's content at the
  element level while discarding the three axiom-clean legs (conj-2b/2c/2d), which are already stated
  in conjugate (not component) form. Unbounded bridge-lemma sprawl with no Mathlib backing.

## Persistent file
- `analogies/fbc-legs-conj-injective-route.md` — design rationale + concrete first step for iter-041.

Overall verdict: ALIGN_WITH_MATHLIB on Fallback B executed as functor-layer-at-a-time conjugate
transport (`apply conjugateEquiv.injective` + the `conjugateEquiv_comp`/`_whiskerLeft`/`_whiskerRight`
push-through dictionary, per `CompositionIso.lean:130-180`); Fallback A (element-`ext` on the
composite) is the iter-035 dead end and must be dropped.
