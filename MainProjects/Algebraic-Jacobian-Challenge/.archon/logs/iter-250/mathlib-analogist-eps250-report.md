# Mathlib Analogist Report

## Mode
api-alignment

## Slug
eps250

## Iteration
250

## Question
After the closed abstract mate-calculus telescope, one concrete presheaf↔sheaf `.val`-boundary
identity `(∗∗)` remains in `pullbackEtaUnitSquare`. Give the Mathlib idiom for the three sub-pieces
(i) `SheafOfModules.pushforward` vs `PresheafOfModules.pushforward` through `.val`; (ii) the Y-side
sheafification right-triangle in split form; (iii) the presheaf lax-unit `ε` reconciliation — and,
above all, is there a single monoidal-functor coherence/`app`/`ext` lemma that discharges the whole
identity sectionwise in one shot, instead of the assoc chase that cost five iters?

## Headline
**No single sectionwise/one-shot lemma exists, and the project should stop hunting for one — but the
coherence lemma that does the *hard* part already exists and is already closed in the file.** The LHS
of `(∗∗)` contains the sheafification unit `presheafAdj.unit.app 𝟙ᵖ` = `CategoryTheory.toSheafify`,
whose `.app X` is the opaque plus-construction map and does NOT compute on sections; so no `ext X; simp`
can evaluate it. The lemma that folds it away abstractly is
`CategoryTheory.Adjunction.unit_app_unit_comp_map_η` (`Mathlib/CategoryTheory/Monoidal/Functor.lean:969`),
already re-exported as the CLOSED `presheafUnit_comp_map_eta` (TensorObjSubstrate.lean:1502). The
correct proof shape is therefore hybrid and matches the in-code recipe exactly: **abstract reshaping
(i)+(ii) → the existing coherence lemma → a clean sectionwise `ext` for (iii)**. The five failed passes
died on `rw [Category.assoc]` over a defeq-but-not-syntactic category, not on a missing lemma.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (i) pushforward-through-`.val` is a named `@[simp]` lemma | PROCEED | informational |
| (ii) Y-triangle = unit-naturality + `right_triangle_components` | PROCEED | informational |
| (iii) `ε(pushforward φ')` reconciliation via sectionwise `ext` | PROCEED | informational |
| one-shot coherence lemma for the whole identity | PROCEED (none exists; the heavy one is already in hand) | informational |

## Informational

**(i) — named `@[simp]`, not a rfl-coax.** `SheafOfModules.pushforward` is `@[simps map_val]`
(`Sheaf/PushforwardContinuous.lean:43`), giving (loogle-verified, exact signature)
`SheafOfModules.pushforward_map_val : ((pushforward φ).map f).val = (PresheafOfModules.pushforward φ.hom).map f.val`.
Compose with `SheafOfModules.forget_map` (`@[simps]`, `Sheaf.lean:66`, `(forget R).map φ = φ.val`),
`SheafOfModules.comp_val` (`Sheaf.lean:60`, `@[simp,reassoc]`), and the `restrictScalars (𝟙)`-as-identity
defeq (`Presheaf/ChangeOfRings.lean:71`; memory `restrictscalars-id-defeq`). Net:
`R_X.map ((pushforward φ).map g) = (PresheafOfModules.pushforward φ').map g.val` via
`simp only [Functor.comp_map, SheafOfModules.forget_map, SheafOfModules.pushforward_map_val]`.

**(ii) — two standard lemmas + one reassociation.** `toSheafify_Y (F 𝟙ᵖ) ≫ (a_Y.map (η F)).val` is the
unit naturality of the presheaf sheafification adjunction at `η F` (unit's underlying component is
`toSheafify` by `PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app`,
`Presheaf/Sheafification.lean:144`): `(sheafificationAdjunction _).unit.naturality (η F)`. The trailing
`≫ (sheafifyUnitIso.hom).val` is the right triangle on the *sheaf* `𝒪_Y` (since
`sheafifyUnitIso = (asIso counit).app (unit Y)` and `𝟙ᵖ_Y = (unit Y).val`):
`CategoryTheory.Adjunction.right_triangle_components`. The whole composite `= η F`. The only friction is
one `t ≫ (A ≫ B) = (t ≫ A) ≫ B` reassociation — the exact spot where `rw [Category.assoc]` silently
fails because `≫` carries an implicit ring-presheaf arg `X.ringCatSheaf.val` ≠ syntactically
`X.presheaf ⋙ forget₂ …`. **Idiom**: reuse the project's already-working L1714 shape
`(Category.assoc _ _ _).symm.trans (h ▸ Category.id_comp _)`, or use `simp only [Category.assoc]`
(matches up to defeq) instead of `rw`, or open the block with a `show` into the syntactic
`PresheafOfModules (X.presheaf ⋙ forget₂ …)` category so plain `rw` works afterward.

**(iii) — the genuinely-new item is a clean sectionwise `ext`.** `PresheafOfModules.pushforward φ' =
pushforward₀OfCommRingCat F R ⋙ restrictScalars φ'` (`Presheaf/Pushforward.lean:86`). For the composite,
`Functor.LaxMonoidal.comp` sets `ε := ε G ≫ G.map (ε F)` (`Monoidal/Functor.lean:222`); since
`pushforward₀OfCommRingCat`'s monoidal has `εIso := Iso.refl` (`Presheaf/PushforwardZeroMonoidal.lean:35`),
`ε F = 𝟙`, so `ε(pushforward φ') = ε(restrictScalars φ')`. The project's `restrictScalarsLaxε`
(`PresheafInternalHom.lean:290`) gives `ε(restrictScalars φ').app X = ε(ModuleCat.restrictScalars (φ'.app X).hom)`,
and `ModuleCat.restrictScalars_η` (`Monoidal/Adjunction.lean:106`, `@[simp]`) gives
`ε(restrictScalars f) r = f r`. The RHS section value is
`unitToPushforwardObjUnit_val_app_apply` (`Sheaf/PullbackFree.lean:71`, `:= rfl`):
`(unitToPushforwardObjUnit φ).val.app X a = φ.hom.app X a`, and `R_X.map upu` is defeq `upu.val`. So
`apply PresheafOfModules.hom_ext` (`Presheaf.lean:100`) `; intro X` → `ModuleCat.hom_ext`/`LinearMap.ext`
→ both sides `= φ.hom.app X r`. No opaque unit here, so this step is genuinely one-shot.

**Why the one-shot hope fails but the route is still cheap.** The only lemma that could collapse the
opaque sheafification unit — `Adjunction.unit_app_unit_comp_map_η` — is already the closed
`presheafUnit_comp_map_eta`. There is no further single lemma that also subsumes the `.val`/pushforward
reshaping (i) or the sheafification triangle (ii); those are irreducible bookkeeping, each with a
named-lemma idiom above. The blocker was never API absence — it was `rw [Category.assoc]` on a
defeq-not-syntactic category; switch to `simp only [Category.assoc]` / the L1714 term-mode shape /
an opening `show`.

## Persistent file
- `analogies/eps250.md` — full per-decision rationale, citations, and the guard-railed 3-step recipe.

Overall verdict: PROCEED on the documented 3-step recipe with the friction idioms above; no Mathlib
gap, no one-shot coherence lemma beyond the already-closed `presheafUnit_comp_map_eta`, and the sole
new item (step 7 `ε = upu.val`) is a clean sectionwise `ext`.
