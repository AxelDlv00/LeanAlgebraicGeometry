# Mathlib Analogist: snap-assoc
**Mode:** cross-domain | **Iter:** 048

## Analogues Found
- **`CategoryTheory/Sites/Monoidal.lean:165` (`Sheaf.monoidalCategory`) + `Localization/Monoidal/Basic.lean:86` (`LocalizedMonoidal`)**: Mathlib builds `MonoidalCategory (Sheaf J A)` as `LocalizedMonoidal (presheafToSheaf J A) J.W (Iso.refl)`; associator/unitors/braiding free. Sole obligation `J.W.IsMonoidal`, proven (`:149`) via internal-hom-preserves-sheaves (`isSheaf_functorEnrichedHom:102`) + tensor-hom adjunction (NOT stalks). Port: instantiate with `L = PresheafOfModules.sheafification α`, `W = J.W.inverseImage (toPresheaf R₀)`.
- **`Monoidal/Braided/Reflection.lean:92` (Day's `isIso_tfae`)**: TFAE (3) `IsIso(L.map(η_d ▷ d'))` ⟺ (4) `IsIso(L.map(η_d ⊗ₘ η_d'))` (= the exact comparison) ⟺ (1) `IsIso(η.app((ihom d).obj(R.obj c)))` (= "internal hom into a sheaf is a sheaf"). `:242` gives `monoidalClosed` of the reflective subcategory free. The robust engine for `W.IsMonoidal`.
- **`Adjunction.rightAdjointLaxMonoidal` + `ModuleCat/Monoidal/Adjunction.lean:42` (`extendScalars.Monoidal`)**: base-change left adjoint strong monoidal (μ = projection-formula iso, via `CoreMonoidal`); right adjoint lax monoidal free. Pattern for lax-monoidal **Γ** and for building the bespoke μ.
- **Bespoke (Analogue 4)**: `tensorPowAdd : L^{⊗m}⊗L^{⊗m'}≅L^{⊗(m+m')}` on *line bundles* — comparison is a local iso because factors are locally free (`O⊗O=O`), right-exactness never invoked. Avoids full `MonoidalCategory`/`MonoidalClosed`.

## Directive Q&A
- **Q1 — is `Localization.Monoidal` instantiable? what obligation?** YES. `PresheafOfModules.sheafification α` is ALREADY a localization functor: `(sheafification α).IsLocalization (J.W.inverseImage (toPresheaf R₀))` (`ModuleCat/Sheaf/Localization.lean:48`). `LocalizedMonoidal` then needs the SOLE obligation `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal`. **NOT** dischargeable by: (a) the generic monoidal-functor-inverse-image instance (`Localization/Monoidal/Basic.lean:71`) — `toPresheaf` is not strong monoidal (`⊗_{R₀}≠⊗_ℤ`), so it cannot inherit the (proven) abelian `J.W.IsMonoidal`; (b) objectwise local-bijectivity — tensor only right-exact (= failed-approach #1). **IS** dischargeable by stalks (`g∈W ⟺ stalkwise iso`; `(F◁g)_x=id⊗g_x` iso since `F_x⊗-` preserves the iso `g_x` — no exactness) but module-sheaf stalk infra is ABSENT; or by the closed lever (Q below). So "tensor commutes with sheafification stalks" does discharge it, only via the stalk route, only on spaces, and Mathlib lacks the supporting lemmas.
- **Q2 — does Mathlib prove sheafification monoidality by a mimicable route?** YES — `Sheaf.monoidalCategory`/`GrothendieckTopology.W.monoidal` (above). Cannot be applied as-is: it requires a FIXED monoidal target `A`, not modules over a sheaf of rings. Mimicable IF `MonoidalClosed (PresheafOfModules R)` is built.
- **Q3 — cheaper path without full instance?** YES — Analogue 4. The real `snap-assoc` need (associativity of `⊕_m Γ(X,L^{⊗m})`) only needs the associator on tensor powers of a line bundle; build `μ_{m,m'}` by induction + pentagon cocycle, using locally-free-ness so the comparison is a genuine local iso.

## Top Suggestion
NOW: Analogue 4 — add `μ_{m,m'}` + pentagon to `AlgebraicJacobian/Picard/SectionGradedRing.lean` (locally-free factors ⟹ comparison is a local iso, sidesteps right-exactness). PRINCIPLED: Analogue 1 — `LocalizedMonoidal (L := PresheafOfModules.sheafification α) (W := J.W.inverseImage (toPresheaf R₀)) ε`; discharge `W.IsMonoidal` via Analogue 2 (Day `isIso_tfae` cond (1)), which also yields `MonoidalClosed (SheafOfModules R)`. The one missing Mathlib brick for the principled route: `MonoidalClosed (PresheafOfModules R)` + internal-hom-preserves-sheaf (NEEDS_MATHLIB_GAP_FILL).

## Analogues (summary)
| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Sites/Monoidal.lean:165` + `LocalizedMonoidal` | sheaf/cat theory | medium-high | ANALOGUE_FOUND |
| `Monoidal/Braided/Reflection.lean:92` (Day) | reflective cat theory | high (needs MonoidalClosed presheaves) | ANALOGUE_FOUND |
| `extendScalars.Monoidal` + `rightAdjointLaxMonoidal` | comm. algebra | low-medium | PARTIAL_ANALOGUE |
| bespoke line-bundle `μ_{m,m'}` | locally-free + CoreMonoidal | low | ANALOGUE_FOUND |

## Discarded
- `Localization/Monoidal/Basic.lean:71` (monoidal-functor inverse image): `toPresheaf` not strong monoidal.
- Objectwise locally-bijective `W.IsMonoidal`: = failed-approach #1 (tensor right-exact only).
- Pure stalk route (`Topology/Sheaves/Stalks.lean:652`): works on a space but module-sheaf stalk + stalk-of-tensor infra ABSENT in Mathlib.

Overall verdict: `Localization.Monoidal` IS instantiable for module sheafification (`IsLocalization` already proven); the single crux is `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal`, best discharged via Day's reflection theorem (needs the absent `MonoidalClosed (PresheafOfModules R)`), while `snap-assoc` itself is unblockable cheaply by a bespoke line-bundle tensor-power comparison.

## Persistent file
- `analogies/snap-assoc.md` written.
