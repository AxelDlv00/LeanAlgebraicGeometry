# Directive: mathlib-analogist — keystone span-cover descent non-circularity

## Mode: api-alignment

## Question
Does the Route B keystone close from the DONE pieces, or is a sheaf-gluing / Čech-H⁰
ingredient genuinely missing? Concretely: can

  `qcoh_section_isLocalizedModule (F : (Spec R).Modules) [IsQuasicoherent F] (f : R) :`
  `  IsLocalizedModule (Submonoid.powers f) ρ_f`

where `ρ_f : Γ(Spec R, F) → Γ(D(f), F)` is the section-restriction map, be assembled
*non-circularly* from exactly these DONE declarations, or does it need an extra input?

DONE pieces (the keystone's intended `\uses`):
- `isLocalizedModule_of_span_cover (g : M →ₗ[R] N) (f : R) (s : Fin n → R) (hs : span(range s)=⊤)`
  `(h : ∀ j, IsLocalizedModule (powers f) (IsLocalizedModule.map (powers (s j)) (mkLinearMap (powers (s j)) M) (mkLinearMap (powers (s j)) N) g)) : IsLocalizedModule (powers f) g`
  — the ALGEBRAIC local-global principle. NB its per-`j` hypothesis is about the **abstract**
  `LocalizedModule (powers (s j)) M` / `…N` (Mathlib's localized module), NOT sheaf sections.
- `section_isLocalizedModule_of_presentation (F : (Spec R).Modules) (P : F.Presentation) (f : R) :`
  `  IsLocalizedModule (powers f) (Γ(⊤,F) → Γ(D(f),F))` — for a GLOBALLY presented `F`.
- `qcoh_finite_presentation_cover` (B1): from `IsQuasicoherent F`, a finite `g : Fin n → R`,
  `span(range g)=⊤`, each `D(gⱼ)⊆U_{φⱼ}` carrying a `Presentation (F.over U_{φⱼ})`.
- `presentationModulesRestrictBasicOpen` (B4): yields `(modulesRestrictBasicOpen gⱼ F).Presentation`
  — i.e. the tile `F_{(gⱼ)}` on `Spec R_{gⱼ}` is globally presented.
- `restrict_obj : Γ(M.restrict ι, U) = Γ(M, ι ''ᵁ U)` is `rfl` (Mathlib Sheaf.lean:328).

## The specific worry I (planner) have — please confirm or refute
Apply the span-cover descent with `M = Γ(Spec R, F)`, `N = Γ(D(f), F)`, `g = ρ_f`, `s = {gⱼ}`.
The per-`j` hypothesis `h j` is then `IsLocalizedModule (powers f)` of the induced map
`LocalizedModule (powers gⱼ) Γ(X,F) → LocalizedModule (powers gⱼ) Γ(D(f),F)`.

To discharge `h j` I want to use `section_isLocalizedModule_of_presentation` on the tile
`F_{(gⱼ)}` (globally presented by B4), which gives `IsLocalizedModule (powers f)` of
`Γ(⊤, F_{(gⱼ)}) → Γ(D(f'), F_{(gⱼ)})`. By `restrict_obj`, `Γ(⊤, F_{(gⱼ)}) = Γ(D(gⱼ), F)` and
`Γ(D(f'), F_{(gⱼ)}) = Γ(D(gⱼ f), F)` (both `rfl`). So the tile lemma gives the localization of
`Γ(D(gⱼ),F) → Γ(D(gⱼ f),F)`.

But to feed `isLocalizedModule_of_span_cover` I need the statement about the **abstract**
`LocalizedModule (powers gⱼ) Γ(X,F)`, not about `Γ(D(gⱼ),F)`. Bridging the two requires a linear
equivalence `LocalizedModule (powers gⱼ) Γ(X,F) ≅ Γ(D(gⱼ),F)` compatible with the maps — i.e.
the canonical map `Γ(X,F)_{gⱼ} → Γ(D(gⱼ),F)` (from the universal property, since `gⱼ` acts
invertibly on `Γ(D(gⱼ),F)`) is an **isomorphism**. That isomorphism is exactly
"`ρ_{gⱼ} : Γ(X,F) → Γ(D(gⱼ),F)` is `IsLocalizedModule (powers gⱼ)`" — i.e. **the keystone at the
cover element `gⱼ`**. This looks circular: to prove the keystone at general `f` I seem to need the
keystone at each `gⱼ`.

In Stacks 01HV/01I8 this identification is NOT assumed — it is derived from the **sheaf axiom**
(the gluing exact sequence `0→Γ(X,F)→∏Γ(D(gᵢ),F)→∏Γ(D(gᵢgⱼ),F)`) localized at `gⱼ`, using that
on each piece `F` is tilde-of-a-module (so overlap sections localize). That degree-0/1 Čech
computation is precisely what the project's P3 layer formalized in the tilde case
(`AlgebraicJacobian/Cohomology/CechAcyclic.lean`: `exact_of_isLocalized_span`,
`sectionCech_affine_vanishing`, `sectionCech_homology_exact`).

## What I need from you (ranked)
1. **Confirm or refute the circularity.** Is `h j` genuinely un-dischargeable from the 5 DONE
   pieces alone (because it secretly needs `Γ(D(gⱼ),F)≅Γ(X,F)_{gⱼ}`)? Or is there a Mathlib idiom
   I'm missing that makes `LocalizedModule (powers gⱼ) Γ(X,F) ≅ Γ(D(gⱼ),F)` available WITHOUT the
   keystone — e.g. a general "sections over a basic open of a sheaf-of-modules localize" lemma, or
   a "morphism iso on a cover ⟹ iso" / "IsLocalizedModule from a sheaf cover" result?
2. **If an ingredient IS missing**, name the cleanest Mathlib-aligned way to supply it:
   - Does the project's P3 `exact_of_isLocalized_span` / `sectionCech_*` machinery
     (CechAcyclic.lean) apply to give `Γ(X,F)_{gⱼ} ≅ Γ(D(gⱼ),F)` for a qcoh `F` whose tiles
     `F_{(gⱼ)}` are each tilde (via B4 ⟹ `IsIso (F_{(gⱼ)}).fromTildeΓ`)? What exactly must be wired?
   - OR is there a more direct Mathlib route (`SheafOfModules`/`Sheaf` "iso checked on a cover is an
     iso" + `isIso_fromTildeΓ_iff` essImage) that closes 01I8 without the explicit span-cover
     descent on global sections at all — and would that resurrect the dormant `tilde_restrict_basicOpen`
     base-change wall (Route P) we deliberately avoid?
3. **Verdict** on the keystone route: PROCEED (the 5 pieces suffice — show how `h j` closes), or
   NEEDS_INGREDIENT (name it + the cheapest Mathlib-aligned build), or ALIGN (the whole descent
   shape is wrong; recommend the correct shape).

## Project artifacts to read
- `AlgebraicJacobian/Cohomology/QcohTildeSections.lean:330-557` — `isLocalizedModule_of_span_cover`,
  the LocalModel lemmas (`tilde_section_isLocalizedModule`,
  `section_isLocalizedModule_of_isIso_fromTildeΓ`, `section_isLocalizedModule_of_presentation`),
  `qcoh_finite_presentation_cover`, and the "Handoff" comment (559-604).
- `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` — `modulesRestrictBasicOpen`,
  `presentationModulesRestrictBasicOpen` (B4).
- `AlgebraicJacobian/Cohomology/CechAcyclic.lean` — P3 section-Čech machinery
  (`exact_of_isLocalized_span`, `sectionCech_affine_vanishing`, `sectionCech_homology_exact`,
  `qcohSectionsAwayLocalized`).
- `analogies/bridge.md` — the iter-037 Route B consult (its B6 step claimed "section comparison is
  `restrict_obj`-rfl" — I believe that over-claimed; please assess).
- Mathlib `AlgebraicGeometry/Modules/Tilde.lean` (`fromTildeΓ`, `isIso_fromTildeΓ_iff`,
  `isIso_fromTildeΓ_of_presentation`), `Algebra/Category/ModuleCat/Sheaf/*`, `RingTheory/LocalProperties/*`.

Write your persistent analysis to `analogies/keystone-descent.md` and the report to task_results.
