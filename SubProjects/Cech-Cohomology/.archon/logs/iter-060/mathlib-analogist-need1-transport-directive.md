# Mathlib-analogist directive — Need#1 geometric transport (hjt / hqc)

## Mode: api-alignment

## Context
We have a scheme isomorphism `φ : U ≅ Spec Γ(U)` (`U.isoSpec`) inducing an equivalence of module
categories `Φ = Scheme.Modules.pushforwardEquivOfIso φ : U.Modules ≌ (Spec Γ(U)).Modules`
(already built, axiom-clean). We need TWO transport facts to discharge two `sorry` holes in
`AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` (the open-immersion acyclicity leaf):

- **`hqc`**: `(Φ.functor.obj H).IsQuasicoherent`, where `H : U.Modules` is quasi-coherent. I.e.
  pushforward of a quasi-coherent module along a scheme iso is quasi-coherent.
- **`hjt`**: `Φ.functor.obj (jShriekOU V) ≅ jShriekOU V'`, where
  `jShriekOU V := sheafify(free(yoneda V))` is the corepresenting object of `F ↦ Γ(V, F)` (the
  `j_!𝒪` of an open `V`), and `V' = φ.inv ⁻¹ᵁ V` is the image open. I.e. pushforward along the iso
  sends the corepresenting object of `V` to the corepresenting object of the image open `V'`.

These are the dominant wall of this route — flagged STUCK by the progress-critic across ~6 iters
because the blueprint describes them as "hard" without naming the Mathlib API. Your job is to find
the exact Mathlib idiom/API so the blueprint can give a construction-level recipe.

## Specific questions

### Q1 (hqc — qcoh preserved under pushforward along iso / qcqs morphism)
The prover noted "`Scheme.Modules.pushforward` preserves qcoh only along iso/qcqs, not in general"
but found "NO qcoh-preservation lemma." An iso IS qcqs. Does Mathlib have:
- a lemma that pushforward of a quasi-coherent sheaf along a quasi-compact-quasi-separated (or just
  iso / affine) morphism is quasi-coherent? (Search `IsQuasicoherent`, `pushforward`, qcqs,
  `Scheme.Hom.pushforward`, `QuasicoherentData`.)
- failing that: is `IsQuasicoherent` transported by an equivalence of module categories induced by a
  scheme iso? Name the predicate `IsQuasicoherent`/`Quasicoherent` actually used in this project's
  `U.Modules` setting (check `AlgebraicJacobian/Cohomology/*.lean` for the qcoh predicate in use) and
  whether Mathlib has a transport-along-iso lemma for it.
If neither exists: give the explicit local-section construction recipe — what `QuasicoherentData`
field must be transported, via which homeomorphism-relabeling, and the Mathlib API for each step.

### Q2 (hjt — pushforward along iso commutes with sheafify ∘ free ∘ yoneda)
`jShriekOU = sheafify ∘ free ∘ (yoneda of the open)`. We need the pushforward equivalence `Φ` to
commute with each layer, landing on `jShriekOU` of the image open:
- **sheafification**: does Mathlib have "an equivalence / left-adjoint commutes with sheafification"
  (`presheafToSheaf`, `sheafificationAdjunction`, `Sheaf.pushforward`/`Presheaf.pushforward` along a
  homeomorphism, adjoint-mate/`conjugateEquiv`)? Name the lemma.
- **free functor** (`free : PresheafOfModules → ...` or the project's `free`): does pushforward
  commute with the free-module functor (both left adjoints)?
- **yoneda relabel**: the presheaf pushforward `Φ_pre` relabels opens by the homeomorphism
  `φ`; the corepresenting `yoneda V` should map to `yoneda V'`. Name the API
  (`TopCat.Presheaf.pushforward`, `Opens.map`, `Homeomorph`, `Opens.comap`).
Identify whether the cleanest route is (a) a layer-by-layer natural-iso chain, or (b) a uniqueness
argument: `Φ.functor.obj (jShriekOU V)` corepresents `G ↦ Γ(V', Φ⁻¹ G)` which by the iso equals
`Γ(V', G')`... i.e. exploit that BOTH sides corepresent the same functor (via
`freeYonedaHomEquiv` + `sheafificationAdjunction`, already shipped in this project) and conclude by
uniqueness of corepresenting objects (`Iso` from a natural iso of corepresented functors). Compare
the two routes and recommend the lower-LOC one with the Mathlib API for each step.

## What to read
- `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` (the leaf + `pushforwardEquivOfIso`,
  `pushforwardExtAddEquiv`, `sectionsFunctorCorepIso`).
- `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` (`jShriekOU`, `freeYonedaHomEquiv`,
  corepresentability) — the corepresenting-object machinery already shipped.
- Mathlib: `Mathlib/AlgebraicGeometry/Modules/*`, `Mathlib/CategoryTheory/Sites/*`, adjoint-mate API.

## Output
Per question: the exact Mathlib lemma name(s) if they exist (api-alignment "PROCEED" with the idiom),
or — if Mathlib lacks it — a construction-level recipe naming the Mathlib primitives for each step,
LOC estimate, and which of the two hjt routes (chain vs uniqueness) is cheaper. Persist the recipe to
`analogies/need1-transport.md` so the blueprint-writer and prover can consume it.
