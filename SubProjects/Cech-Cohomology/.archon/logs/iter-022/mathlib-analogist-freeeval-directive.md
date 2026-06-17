# Mathlib-analogist directive — free-complex differential match + Homotopy packaging

## Mode: api-alignment

## Context

Route P3b builds a free-presheaf complex `cechFreePresheafComplex 𝒰` (a **chain** complex whose
degree-`p` term is a **coproduct** `⊕_{σ : Fin(p+1)→I} free(yoneda U_σ)` in
`PresheafOfModules (Spec R)`) and must prove it is a quasi-iso resolution of `O_𝒰`
(`cechFreeComplex_quasiIso`). The route is CHURNING: the named target has not landed in 3 prover
iters; the single concrete bottleneck — `cechFreeEvalEngineIso` — has never been attempted. We need
the Mathlib-aligned idiom for the two operations below BEFORE we dispatch a prover, so the prover does
not burn another setup round.

The combinatorial homotopy engine already exists and is axiom-clean: `FreeCechEngine.combDifferential`
(the model differential on `C•` with `C•_p = ⊕_{σ:Fin(p+1)→I₁(V)} O_X(V)`),
`FreeCechEngine.combHomotopy` + `FreeCechEngine.combHomotopy_spec` (the `dh+hd=id` contracting
homotopy on the nonempty `C•`). The objectwise reduction `quasiIso_of_evaluation` (reduce the
presheaf quasi-iso to a per-`V` evaluated quasi-iso) and the per-summand evaluation bridges
(`freeYonedaEval_iso_of_le`, `cechFreeEval_X`) also exist.

## The bottleneck node: `cechFreeEvalEngineIso`

A **degreewise iso of homological complexes**
`((evaluation (Spec R) V).mapHomologicalComplex _).obj (cechFreePresheafComplex 𝒰) ≅ C•`
where `C•` is the combinatorial complex `C•_p = ⊕_{σ:Fin(p+1)→I₁(V)} O_X(V)` with differential
`FreeCechEngine.combDifferential`. The hard part is the **differential match**: showing the
evaluated alternating-face differential equals `combDifferential` on each coproduct injection
`Sigma.ι`, where the faces reindex `σ ↦ σ ∘ Fin.succAbove i` with sign `(-1)ⁱ`.

## Questions (give VERIFIED Mathlib lemma names + the idiomatic skeleton, not tactics)

1. **Degreewise iso of a `HomologicalComplex` whose terms are coproducts.** What is the canonical
   Mathlib idiom for building `K ≅ L` in `HomologicalComplex` when each `K.X p`, `L.X p` is a
   coproduct `∐ f` and the differential is pinned by its action on injections? Is it
   `HomologicalComplex.Hom.isoOfComponents` / `HomologicalComplex.mkIso` with per-degree
   `Limits.Sigma.mapIso` (or `Limits.coproduct.mapIso`) and a `comm` proved by `Limits.Sigma.hom_ext`
   on injections? Name the exact lemmas (`HomologicalComplex.Hom.isoOfComponents`,
   `Limits.Sigma.hom_ext`, `Limits.colimit.hom_ext`, `Limits.ι_colimMap`, etc.) and the recommended
   `comm` skeleton.

2. **`evaluation`/`mapHomologicalComplex` vs coproducts.** Does `PresheafOfModules.evaluation
   (Spec R) V` preserve coproducts, and what is the canonical naturality iso to push `evaluation`
   through `∐`? Name `PreservesCoproduct.iso` / `Limits.preservesColimitIso` /
   `Limits.ι_preservesColimitsIso_hom` (whatever the current name is) and how it composes with
   `Functor.mapHomologicalComplex` degreewise. Is there a cleaner route than threading
   `PreservesCoproduct.iso` by hand?

3. **Contracting homotopy ⟹ QuasiIso packaging.** Given `combHomotopy_spec : dh + hd = id` on the
   nonempty `C•` (a contraction onto `O_𝒰(V)[0]` in degree 0), what is the Mathlib-canonical route
   from this `HomologicalComplex.Homotopy` to `QuasiIso (the augmentation C• ⟶ O_𝒰(V)[0])`? Confirm
   the chain `HomologicalComplex.Homotopy` → `HomotopyEquiv` → `HomotopyEquiv.toQuasiIso` /
   `QuasiIso.ofHomotopyEquiv`, OR the more direct `Homotopy` → `homologyMap` iso. Name the verified
   lemmas and the `ChainComplex.toSingle₀Equiv` interaction for reading off degree-0 homology.

4. **Is the hand-rolled `FreeCechEngine` the wrong shape?** (Escalation question, answer briefly.) Does
   Mathlib have an "augmented (co)simplicial object with an extra degeneracy ⟹ homotopy equivalence to
   the constant complex" idiom — `AlgebraicTopology.ExtraDegeneracy`,
   `SimplicialObject.Augmented`, `Rep.standardComplex` / bar-resolution precedent — that the free
   complex SHOULD be built on, instead of deriving the contraction from a bespoke combinatorial
   engine? If such an idiom exists and would replace `cechFreeEvalEngineIso` + the engine entirely,
   say so with citations (this is the structural-refactor fallback the progress-critic named). If it
   does NOT cleanly apply (e.g. the per-`V` evaluated complex is not literally a Mathlib (co)simplicial
   object), say that too, so we commit to the engine route.

Produce a persistent `analogies/free-eval-engine-iso.md` with: the verified lemma names, the
recommended `cechFreeEvalEngineIso` construction skeleton (degreewise iso + injection-wise `comm`),
the Homotopy→QuasiIso packaging chain, and a clear verdict on Q4 (engine route vs. ExtraDegeneracy
refactor) with cost analysis.
