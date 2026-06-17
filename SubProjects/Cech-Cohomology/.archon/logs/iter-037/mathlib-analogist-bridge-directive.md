# mathlib-analogist directive — iter-037

## Mode: api-alignment

## Question
Route B for Stacks 01I8 (`IsQuasicoherent F → IsIso F.fromTildeΓ` on `X = Spec R`) reduces to a
single keystone: for qcoh `F` and `f ∈ R`, the section-restriction `ρ_f : Γ(Spec R, F) →
Γ(D(f), F)` is `IsLocalizedModule (Submonoid.powers f) ρ_f`. The chosen proof refines `F`'s
quasi-coherence cover to a finite standard cover `Spec R = ⋃ⱼ D(gⱼ)`, `span{gⱼ}=R`, shows the
per-`gⱼ` localized restriction is `IsLocalizedModule (powers f)`, and descends via the DONE
pure-algebra primitive `isLocalizedModule_of_span_cover`.

The per-`gⱼ` step needs an affine **base-change bridge**: transport `F` to `D(gⱼ) ≅ Spec R_{gⱼ}`,
give the transported module a global `Presentation`, and identify its section-restrictions with
`R_{gⱼ}`-module localizations, so that the DONE local-model lemma
`section_isLocalizedModule_of_presentation` applies on `Spec R_{gⱼ}`.

The geometric MODULE-transport half is ALREADY built (project-local):
`modulesRestrictBasicOpen f F : (Spec R_f).Modules := (F.restrict (specBasicOpen f).ι).restrict
(basicOpenIsoSpecAway f).inv`, plus a comparison iso `modulesRestrictBasicOpenIso`
(in `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`).

I need the cleanest Mathlib-aligned way to build the REMAINING glue, and a check that Route B
genuinely closes (does NOT hit a third absent-Mathlib wall the way Route P did). Concretely:

1. **Section comparison.** For an `(Spec R).Modules` `F` and open immersion `j : U ⟶ Spec R`,
   is there a Mathlib idiom giving `Γ(Spec R_g, (F.restrict j).restrict e) ≅ Γ(U, F)` (sections
   of a restricted/transported sheaf of modules = sections over the open / along an iso), as a
   *linear* iso compatible with further restriction to `D(f)∩U`? Name the Mathlib lemmas
   (`SheafOfModules.restrict`, `Scheme.Modules.restrict`, presheaf `.map` of an open immersion,
   `Modules.restrictΓ`/`Γ`-naturality, etc.). What is the canonical path?

2. **Presentation restriction.** Restriction of a qcoh module along an open immersion is exact /
   a left adjoint, so it carries a `Presentation O^J → O^I → F → 0` to a presentation of the
   restricted module. Does Mathlib have `SheafOfModules.Presentation.map` / pullback of a
   presentation along a morphism of ringed spaces, or `Scheme.Modules.restrict` preserving
   `Presentation`/`GeneratingSections`? If absent, what is the minimal project-local construction?

3. **Quasicoherence locality.** Does Mathlib already provide *any* of: `IsQuasicoherent` of a
   restriction (`(F.restrict j).IsQuasicoherent` from `F.IsQuasicoherent`); a basic-open cover
   giving each `F|_{D(gⱼ)}` a global presentation; `isIso_fromTildeΓ_iff_isLocalizing` and the
   definition of `IsLocalizing` (is `IsLocalizing F` *definitionally* the keystone — `∀ f,
   IsLocalizedModule (powers f) ρ_f`? if so the keystone is exactly `IsQuasicoherent → IsLocalizing`).
   Cite the Mathlib decls in `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` and
   `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`.

4. **Route-validity verdict.** Given (1)-(3), does Route B close with project-local glue of
   bounded size, or does it require a genuinely-absent multi-hundred-LOC Mathlib construction
   (a THIRD wall)? If a wall, name it precisely and say whether it is the same `lemma-widetilde-pullback`
   that blocked Route P (i.e. whether `modulesRestrictBasicOpenIso` already discharges it).

## Output
Persist `analogies/<slug>.md` with the recommended build decomposition (ordered, with Mathlib
citations per step) plus the route-validity verdict. PROCEED vs ALIGN/REROUTE.
