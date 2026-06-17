# Mathlib Analogist Report

## Mode
api-alignment

## Slug
d3-251

## Iteration
251

## Question
For D3′ (`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict`): find the exact Mathlib
idiom for the open-immersion base-change-square coherence of the sheaf-level pullback–tensor
comparison `δ_sheaf`, with named lemmas + verified signatures + the friction-defeating tactics to
embed in the prover directive, and flag any "ALIGN WITH MATHLIB".

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. δ-composition calculus (use Mathlib `comp_δ`/`leftAdjointOplaxMonoidal_δ`, at PRESHEAF level) | ALIGN_WITH_MATHLIB | major (in-proposal) |
| 2. hand-built sheaf-level `pullbackTensorMap` vs a Mathlib sheaf δ | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. one-shot "δ ∘ restriction along strong-monoidal functor" shortcut (Q4) | PROCEED | informational |
| 4. iter-250 friction kit transfer + `show`-strip dead-end (Q3/Q5) | PROCEED | informational |

## Answers to the directive's 5 questions (all verified via LSP)

**Q1 — `comp_δ` + δ-naturality.** Confirmed, `Mathlib.CategoryTheory.Monoidal.Functor`:
- `CategoryTheory.Functor.OplaxMonoidal.comp_δ (F G) (X Y) : δ (F.comp G) X Y = G.map (δ F X Y) ≫
  δ G (F.obj X) (F.obj Y)`.
- `CategoryTheory.Functor.OplaxMonoidal.δ_natural (F) (f g) : δ F X X' ≫ (F.map f ⊗ F.map g) =
  F.map (f ⊗ g) ≫ δ F Y Y'`; whiskered `δ_natural_left`/`δ_natural_right`; and the **trailing-`≫ h`**
  reassociated forms `δ_natural_assoc`, `δ_natural_left_assoc`, `δ_natural_right_assoc` (use these to
  `rw` inside `≫`-composites).
- Apply `comp_δ` to the two factorisations of the square's underlying **presheaf** functor:
  `(j')^* ∘ f^*` (`PresheafOfModules.pullback φ_{j'} ⋙ PresheafOfModules.pullback φ_f`) and
  `g^* ∘ j^*`, identified via `PresheafOfModules.pullbackComp` and the equality `f∘j' = j∘g`.

**Q2 — pseudofunctoriality conjugation.** Confirmed:
- `AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv {X Y Z} (f g) :
  (conjugateEquiv ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
     (pullbackPushforwardAdjunction (f ≫ g))) (pullbackComp f g).inv = (pushforwardComp f g).hom`
  (`Mathlib.AlgebraicGeometry.Modules.Sheaf`).
- mate/conjugate API in `Mathlib.CategoryTheory.Adjunction.Mates`: `CategoryTheory.conjugateEquiv`,
  `CategoryTheory.mateEquiv`, and the transposed component
  `CategoryTheory.unit_conjugateEquiv (adj₁ adj₂ α c) : adj₁.unit.app c ≫
  ((conjugateEquiv adj₁ adj₂) α).app (L₁.obj c) = adj₂.unit.app c ≫ R₂.map (α.app c)`.
- Pseudofunctor isos: `Scheme.Modules.pullbackComp : pullback g ⋙ pullback f ≅ pullback (f≫g)`,
  `Scheme.Modules.pushforwardComp`, `Scheme.Modules.pullbackCongr (hf : f = g) : pullback f ≅
  pullback g` (the device for `f∘j' = j∘g`; this is exactly how `restrictIsoUnitOfLE` (L396) handles
  the unit base-change square). Presheaf analogs `PresheafOfModules.pullbackComp`
  (`...Presheaf.Pullback`), `PresheafOfModules.pushforwardComp` (`...Presheaf.Pushforward`) exist.
- **NB**: `PresheafOfModules.conjugateEquiv_pullbackComp_inv` does NOT exist (loogle → empty).

**Q3 — `.val`-spelling friction.** All iter-250 idioms transfer (the same
`a_Y = sheafification (𝟙 Y.ringCatSheaf.val)` recurs at L1209): `restrictScalarsId_map` (L1650,
`:= rfl`) stripped by **syntactic `rw`** (L1833); `erw [Category.assoc, ← Functor.map_comp, …]`
keyed-defeq merges (L1837); the `W_of_isIso_sheafification`/`W_whiskerRight_of_W`/
`W_whiskerLeft_of_W`/`isIso_sheafification_map_of_W` family. For the δ-naturality square after
folding `sheafificationCompPullback` and stripping `restrictScalars`, the reassociation tactic is
**`rw [δ_natural_*_assoc]`** (or `erw` if the connecting object is defeq-spelled differently); when
plain `Category.assoc`/`rw [h]` silently fail on `PresheafOfModules`-over-`Sheaf.val` composites,
hand-reassociate with `(Category.assoc _ _ _).symm.trans (h ▸ Category.id_comp _)` (iter-249/250).

**Q4 — one-shot "δ commutes with restriction along a strong-monoidal functor"?** No. The mechanism
is `comp_δ` itself: a strong-monoidal `G` has `δ G` iso (`Functor.CoreMonoidal.toOplaxMonoidal_δ :
δ = (μIso _ _).inv`; `Functor.Monoidal.ofOplaxMonoidal`), so `δ (F⋙G) = G.map (δ F) ≫ δ G` is iso
iff `G.map (δ F)` is. The strong-monoidal restriction of `tensorobj_restrict_iso` is consumed
THROUGH `comp_δ`, not via a dedicated lemma. PROCEED, no shortcut.

**Q5 — `show`-into-syntactic-category dead-end.** Confirmed WRONG here. Stripping `restrictScalars
(𝟙)` over sheafification via `show`/`whnf` is catastrophic (>6.4M heartbeats, iter-249/250). Use the
propositional `restrictScalarsId_map` + syntactic `rw` instead. `show`/`whnf` is safe only on goals
with no sheafification under the `restrictScalars` — not D3′'s δ-transport goals.

## Major

- **Decision 1 (in-proposal, not yet shipped):** author `pullbackTensorMap_restrict` by mirroring the
  PROVEN `pullbackObjUnitToUnit_comp` (L900) with `Adjunction.leftAdjointOplaxMonoidal_δ` in place of
  the `_η` transposition — `δ F X Y = (adj.homEquiv _ _).symm ((adj.unit.app X ⊗ adj.unit.app Y) ≫
  μ G (F.obj X) (F.obj Y))` — plus `comp_δ`/`comp_μ`/`δ_natural_*` and the mate API. Do this at the
  **PRESHEAF** level (where the genuine Mathlib oplax δ lives, L1212), then transport through the
  three sheafification bridges of `pullbackTensorMap`. Do NOT build a parallel δ-composition API and
  do NOT try to apply `comp_δ` to the sheaf-level `pullbackTensorMap` directly.

## Informational

- **Decision 2 — no parallel-API risk.** Mathlib has NO monoidal structure on
  `SheafOfModules.pullback`/`Scheme.Modules.pullback` (loogle `"SheafOfModules.pullback" "Monoidal"`
  → empty; iter-248 "no sheaf LaxMonoidal"). So the hand-built `pullbackTensorMap` is a legitimate
  sheaf-level gap-fill, not a copy of an existing Mathlib δ. The genuinely-new D3′ work is the
  base-change compatibility of its three transport factors (`sheafificationCompPullback`,
  `sheafifyTensorUnitIso`, `pullbackValIso`) — where the iter-250-class friction recurs.
- **Asymmetry to budget**: Mathlib gives the SHEAF unit comparison (`SheafOfModules.pullbackObjUnitToUnit`)
  and SHEAF `conjugateEquiv_pullbackComp_inv`, but only PRESHEAF δ and NO presheaf conjugate identity.
  So D3′ must re-derive the conjugate-pullbackComp identity at the presheaf level (small supplement
  from `unit_conjugateEquiv` + `conjugateEquiv`); it cannot reuse the sheaf-level one for the δ part.
- **Decisions 3 & 4** as above (PROCEED).

## Persistent file
- `analogies/d3-251.md` — full named-lemma table with verified signatures + the prover-directive
  tactic kit and the level-mismatch rationale.

Overall verdict: ALIGN_WITH_MATHLIB on the δ-composition calculus — use `comp_δ` /
`leftAdjointOplaxMonoidal_δ` / `δ_natural_*` / `comp_μ` / the mate API at the PRESHEAF level
(mirroring `pullbackObjUnitToUnit_comp`, swapping `_η`→`_δ`), then thread through the three
sheafification bridges with the iter-250 friction kit; the sheaf-level `pullbackTensorMap` is a
sound gap-fill, not a parallel API, since Mathlib has no sheaf-level monoidal pullback.
