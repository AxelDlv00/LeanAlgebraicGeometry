# Mathlib Analogist: grquot-infra
**Mode:** api-alignment | **Iter:** 049

## Headline
Of the 5 blueprint decls, **2 (`universalQuotient`, `tautologicalQuotient`) + the
loc-free condition inside `functor` have NO Mathlib support** → iter-050 needs an
INFRA-BUILD step BEFORE scaffolding those signatures. `chartQuotientMap` and the
`represents` signature can scaffold immediately (primitives exist).

## Verdicts (per piece)

- **`Scheme.Modules` / trivial bundles**: PROCEED. `Scheme.Modules X := SheafOfModules X.ringCatSheaf` (`AlgebraicGeometry/Modules/Sheaf.lean:37`); `O^n = SheafOfModules.free (Fin n)` (`…/Sheaf/Free.lean:40`), `O = SheafOfModules.unit` (`…/Sheaf.lean:160`); surjective = `Epi` (`SheafOfModules` Abelian, `…/Sheaf/Abelian.lean`).
- **Glue `universalQuotient` (sheaf from chart free sheaves + GL_d cocycle)**: **NEEDS_MATHLIB_GAP_FILL.** No turn-key API. Only the abstract pseudofunctor descent `CategoryTheory/Sites/Descent/{DescentData.lean:57, IsStack.lean:49}` exists — NOT instantiated for `Scheme.Modules` (no `IsStack` instance for modules anywhere). `Scheme.GlueData` (used for the scheme) has no module companion. **Must build project-side.**
- **`IsLocallyFreeOfRank` predicate**: **NEEDS_MATHLIB_GAP_FILL.** No `LocallyFree`/`IsLocallyFree` in Mathlib (grep = ∅). Have `Module.Free`, `QuasicoherentData`/`IsQuasicoherent`/`IsFinitePresentation` (`…/Sheaf/Quasicoherent.lean`), `free` — but no "loc free rank d". Build modeled on `QuasicoherentData`'s cover+local-iso shape.
- **Glue `tautologicalQuotient` (morphism u : O^r ↠ U)**: **NEEDS_MATHLIB_GAP_FILL** — rides on the module-gluing primitive (descent of `Hom`).
- **`φ^*` action (φ^*U, φ^*u)**: PROCEED. `Scheme.Modules.pullback (f:X⟶Y) : Y.Modules ⥤ X.Modules` EXISTS (`…/Modules/Sheaf.lean:167`) + `pullbackId/Comp/Congr` (`:199/:219/:235`); pullback of free is free (`…/Sheaf/PullbackFree.lean`, `mapFree`).
- **`represents` target shape**: PROCEED. `CategoryTheory.Functor.RepresentableBy` (`Yoneda.lean:285`) is the canonical data target; `Functor.IsRepresentable` (`:519`) the Prop form. AG precedent: `AlgebraicGeometry/Sites/Representability.lean:187,202`. Use `(functor d r).RepresentableBy (scheme d r)`.
- **`functor` encoding**: PROCEED (encoding) / blocked on loc-free gap. AG uses `Schemeᵒᵖ ⥤ Type u` or `Sheaf zariskiTopology (Type u)`. No bundled quotient-up-to-iso type — build `RankQuotient` structure + setoid. `Sites/Representability.lean` (`LocalRepresentability.isRepresentable`, Stacks 01JJ) proves loc-representable Zariski sheaf ⇒ representable but CONSTRUCTS the scheme by gluing; Grassmannian.scheme already built ⇒ inspiration, not drop-in.

## Proposed scaffold signature shapes
```lean
-- EXISTS-backed, scaffold now:
noncomputable def chartQuotientMap (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    (SheafOfModules.free (Fin r) : (affineChart d r I).Modules) ⟶ SheafOfModules.free (Fin d)

-- GAP-blocked, needs module-gluing primitive first:
noncomputable def universalQuotient (d r : ℕ) : (scheme d r).Modules            -- glue O_{U^I}^d via g_{I,J}
noncomputable def tautologicalQuotient (d r : ℕ) :
    (SheafOfModules.free (Fin r) : (scheme d r).Modules) ⟶ universalQuotient d r

-- GAP: project-side predicate (model on QuasicoherentData cover+local-iso):
structure IsLocallyFreeOfRank {X : Scheme} (M : X.Modules) (d : ℕ) : Prop

-- functor of points (structure+setoid; map on morphisms via Scheme.Modules.pullback):
structure RankQuotient (r d : ℕ) (T : Scheme) where
  F : T.Modules
  q : (SheafOfModules.free (Fin r) : T.Modules) ⟶ F
  epi : Epi q
  locFree : IsLocallyFreeOfRank F d
def functor (d r : ℕ) : Schemeᵒᵖ ⥤ Type _              -- T ↦ Quotient (iso-relation on RankQuotient)

-- EXISTS-backed target, scaffold signature now:
noncomputable def represents (d r : ℕ) : (functor d r).RepresentableBy (scheme d r)
```

## Persistent file
- `analogies/grquot-infra.md` written.

Overall verdict: PROCEED on `chartQuotientMap`/`φ^*`/`represents`-target; **NEEDS_MATHLIB_GAP_FILL on module-gluing-over-GlueData + IsLocallyFreeOfRank** — iter-050 must build that infra before scaffolding `universalQuotient`/`tautologicalQuotient`/`functor`.
