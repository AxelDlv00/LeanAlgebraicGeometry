# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
eps250

## Design question
The whole abstract adjunction mate-calculus for the D2′ unit square is already CLOSED axiom-clean.
What remains is ONE concrete identity living on the **presheaf↔sheaf `.val` boundary**, and five
prover iterations have failed to close it — NOT because a lemma is missing, but because of pervasive
Lean tactic friction manipulating `SheafOfModules`/`PresheafOfModules` `.val` composites. I need the
**Mathlib idiom** for three pieces of `.val`-boundary bookkeeping (below), and above all: **is there
a canonical Mathlib idiom — a monoidal-functor coherence/`app`/`ext` lemma — that discharges this
whole concrete identity sectionwise in one shot, instead of the manual associativity chase that has
cost 5 iters?** "The named lemmas exist, PROCEED" is NOT the answer I need (the prior eta247 consult
already certified the abstract glue and the route still didn't close). I need the *shape of the
proof that avoids the friction*.

Concretely, after the closed telescope, the remaining goal `(∗∗)` is the presheaf-level identity:
```
(presheafAdj.unit.app 𝟙ᵖ ≫ (PresheafOfModules.pushforward φ').map (toSheafify_Y (F 𝟙ᵖ)))
   ≫ R_X.map ((SheafOfModules.pushforward φ).map (a_Y.map (η F) ≫ sheafifyUnitIso.hom))
 = R_X.map (SheafOfModules.unitToPushforwardObjUnit φ)
```
where `R_X = SheafOfModules.forget X ⋙ PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)`,
`φ = f.toRingCatSheafHom`, `φ' = φ.hom`, `F = PresheafOfModules.pullback φ'`, `η F` its
OplaxMonoidal unit, `a_Y = PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.val)`.

The three sub-pieces (documented in-code at the `sorry`):

**(i) `SheafOfModules.pushforward` vs `PresheafOfModules.pushforward` on morphisms, through `.val`.**
Is `R_X.map ((SheafOfModules.pushforward φ).map g) = (PresheafOfModules.pushforward φ').map g.val`
a *named* Mathlib identity, a `simp` normal form, or only a `rfl` defeq one must coax? What is the
canonical Mathlib lemma relating `(SheafOfModules.pushforward φ).map g` to its underlying
presheaf-morphism `((…).map g).val` / `(PresheafOfModules.pushforward …).map g.val`? (Look in
`Mathlib.Algebra.Category.ModuleCat.Sheaf.Pushforward` and the `SheafOfModules`/`PresheafOfModules`
`forget`/`toPresheaf`/`.val` API.)

**(ii) The Y-side sheafification right-triangle in split `.val`/composite-functor form.**
Need `toSheafify_Y (F 𝟙ᵖ) ≫ (a_Y.map (η F)).val ≫ (sheafifyUnitIso.hom).val = η F`, i.e. the
sheafification unit/counit right-triangle on the SHEAF `𝒪_Y` pushed to underlying presheaves. What is
the exact Mathlib lemma (`Adjunction.right_triangle_components` / `PresheafOfModules.sheafification…`
toSheafify naturality) and — crucially — the idiom to state/apply it that does NOT trip the
`Category.assoc` silent-match failure on these composites (see Failed approaches)?

**(iii) STEP 7 — the presheaf lax-monoidal unit `ε` reconciliation (the SOLE genuinely-new math item).**
Need `Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ') = (SheafOfModules.unitToPushforwardObjUnit φ).val`
checked sectionwise (both act on sections as `φ.hom.app X`). What is the canonical Mathlib
characterization of `Functor.LaxMonoidal.ε` for `PresheafOfModules.pushforward`? How is the
lax-monoidal structure on `PresheafOfModules.pushforward` *defined* (so its `ε` has a computable
`app`)? Is there an `ε_app` / `pushforward_ε` lemma, or must it be unfolded through
`restrictScalars`/`Functor.LaxMonoidal` field accessors? NOTE: there is **NO** `Functor.LaxMonoidal`
instance on the *sheaf* `SheafOfModules.pushforward` — step 7 must live at the presheaf level. The
prior eta247 analogy (line 40) wrongly assumed a *sheaf-level* `ε`-by-`rfl`; that is exactly the
hole step 7 fills, so do not reuse that claim.

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:1648–1741 — `pullbackEtaUnitSquare`: the closed
  telescope (steps 1–6, live tactic code) and the open `(∗∗)` `sorry` at L1741 with the in-code
  3-substep recipe (i)/(ii)/(iii) at L1720–1740.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — search for the defs in play:
  `unitToPushforwardObjUnit`, `unitToPushforwardObjUnit_val_app_apply`, `presheafUnit_comp_map_eta`
  (CLOSED, the step-6 lemma reaching `ε(pushforward φ')`), `pullbackValIso`, `sheafifyUnitIso`.
- `analogies/eta247.md` — the PRIOR consult that certified the (now-closed) abstract glue. Read it so
  you do NOT repeat it; your job is the concrete `.val`-boundary layer it explicitly left open.

## Why now
Five prover passes (245–249) reduced D2′ to this one concrete identity but never closed it; the
iter-249 review pinned the obstacle as Lean tactic friction on `.val` composites, not a Mathlib gap,
and armed exactly this consult. I am about to author `epsilonPresheafToSheafUnit` (step 7) and send a
focused concrete prover pass; I need the Mathlib-idiomatic *shape* for (i)/(ii)/(iii) — especially
whether the whole thing collapses to a sectionwise `ext`/`app` computation that sidesteps the assoc
chase — before dispatching, or the 6th pass will hit the same wall.

## Hints (optional)
- Mathlib namespaces: `Mathlib.Algebra.Category.ModuleCat.Sheaf.*` (`Pushforward`,
  `PresheafOfModules.Sheafification`), `Mathlib.Algebra.Category.ModuleCat.Presheaf.*`
  (`Pushforward`, `Monoidal`, `restrictScalars` LaxMonoidal), `Mathlib.CategoryTheory.Monoidal.Functor`
  (`Functor.LaxMonoidal.ε`, `OplaxMonoidal.η`), `Mathlib.CategoryTheory.Adjunction.Basic`
  (`right_triangle_components`, `homEquiv_unit`).
- The project already has the working idiom for the X-side triangle (`hrhs`/`hXtri` at L1704–1714):
  `(Category.assoc _ _ _).symm.trans (hXtri ▸ Category.id_comp _)`, and the split-form rule
  "state helper triangles in the SAME `simp only [Functor.comp_map, Functor.map_comp]`-split form as
  the goal". Confirm whether (ii) can reuse this exact shape, or whether a cleaner Mathlib
  `simp`-normal-form approach exists.
- `restrictScalarsMonoidalOfBijective` and the presheaf `pushforward` LaxMonoidal instance are listed
  in the blueprint frontier as project substrate — check how `ε` flows through them.

## Severity expectation
high-stakes
