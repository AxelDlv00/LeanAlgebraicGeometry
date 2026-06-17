# Mathlib Analogist Report

## Mode
api-alignment

## Slug
rpf-bridge

## Iteration
245

## Question
What granularity must the `IsInvertible.pullback` bridge expose so that the
relative Picard functor `RelPicFunctor` / `PicSharp` (on the `IsInvertible`
iso-class carrier) has constructible group-hom + functoriality fields?
(A) bare Prop `IsInvertible M → IsInvertible (f^* M)` + Mathlib's existing
pullback pseudofunctor coherence (`pullbackComp`/`pullbackId`); or
(B) the monoidal comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` (and/or `pullbackComp`)
exposed *as data*.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1 (Q1+Q2): bridge primitive = bare Prop vs comparison ISO | ALIGN_WITH_MATHLIB | critical (proposal) |
| 2 (Q3): group-hom from comparison MAP + quotient | ALIGN_WITH_MATHLIB | critical (proposal) |

**Bottom line: option A is provably insufficient. Choose (B), refined: the bridge
primitive is the comparison ISO (existence form); the bare Prop is a derived
corollary, not the bridge.**

## Direct answers to the three directive questions

**Q1 — bare Prop + pseudofunctor coherence, or comparison iso as data?**
**Comparison iso as data.** Mathlib ships the exact analogue of what the project is
building: `CommRing.Pic.mapAlgebra : Pic R →* Pic A`
(`Mathlib/RingTheory/PicardGroup.lean:528`) is the iso-class Picard group-hom
`[M] ↦ [base-change M]`, and `CommRing.Pic.functor : CommSemiRingCat ⥤ CommGrpCat`
(`:580`) is the packaged functor (the `PicSharp.functorial` / `PicSharp.presheaf`
analogues; project uses additive packaging, same content). Its group-hom fields are
built from comparison **isos**, never a bare Prop:
- `map_mul'` (`:531-534`) ← `TensorProduct.AlgebraTensorModule.distribBaseChange R A`,
  a genuine `≃ₗ` (= `f^*(M⊗N) ≅ f^*M ⊗ f^*N`; it is literally the strong-monoidal
  `δ`/`μ` of `extendScalars.Monoidal`), fed to `mk_eq_mk_iff` (`:462`).
- `map_one'` (`:530`) ← the **unit** iso `A ⊗_R R ≅ A` (via freeness).
The bare predicate `Module.Invertible.instLocalizationLocalizedModule` (the
`IsInvertible.pullback` analogue) is used **only** to make `toFun := .mk A (A⊗M)`
typecheck; it is never sufficient for any homomorphism field. The pseudofunctor
coherence `SheafOfModules.pullbackComp`/`pullbackId`
(`…/Sheaf/PullbackContinuous.lean`, present at the pin) is the
`mapAlgebra_comp_mapAlgebra`/`mapAlgebra_self` analogue — it feeds the functor's
`map_comp`/`map_id` (functoriality in `f`), is itself an ISO washed through
`mk_eq_mk_iff`, and is **orthogonal** to the ⊗-comparison `map_add` needs.

**Q2 — recommended shape of the bridge.** NOT bare Prop. Expose the two comparison
isos in existence form (consumer is iso-class-quotiented):
```
pullbackTensorIso (f)(M N) : Nonempty (tensorObj (f^*M) (f^*N) ≅ f^*(tensorObj M N))   -- map_add
pullbackUnitIso   (f)      : Nonempty (f^*(unit) ≅ unit)                                -- map_zero
```
Then **derive** `IsInvertible.pullback : IsInvertible M → IsInvertible (f^*M)` as a
~3-line corollary (`M⊗N≅𝟙 ⟹ f^*M ⊗ f^*N ≅ f^*(M⊗N) ≅ f^*𝟙 ≅ 𝟙`), rather than
sorry-ing it as a peer. Coherence (naturality/pentagon/the strict `pullbackComp`
identities) is **not** load-bearing as bridge data — the iso-class quotient washes it
out, exactly as `map_mul'` hands ONE iso to `mk_eq_mk_iff` and never touches a
coherence square (confirms `[[ts-picard-direct-216]]`). For the functor's
`map_id`/`map_comp` use the existing Mathlib `pullbackId`/`pullbackComp` isos, washed.

**Q3 — does group-hom follow from `pullbackTensorMap` (the MAP) + quotient washing?**
**No.** `mk_eq_mk_iff` requires `Nonempty (M ≃ₗ N)` — an iso. A comparison **map**
not known to be invertible yields no equality of iso-classes; the quotient washes
*coherence*, not *invertibility*. Independently confirmed by the project's own
negative result (`[[pullback-tensor]]`, `[[pullback-monoidal]]`: oplax `δ` is a map,
not iso — Γ(P¹,O(1))=0). The map must be promoted to an iso; for **invertible** `M,N`
this promotion is the cheap chart-chase, not general strong monoidality.

## Major

(ALIGN_WITH_MATHLIB on proposal-stage code — adopt before the blueprint rewrite +
prover round, no shipped-code refactor yet since the current `functorial := 0` is an
acknowledged placeholder.)

- **Do not author `IsInvertible.pullback` as the typed-`sorry` bridge.** The bridge
  this iter should be the comparison isos `pullbackTensorIso` + `pullbackUnitIso`
  (typed-`sorry` if needed). `IsInvertible.pullback` becomes a derived corollary.
  Authoring the bare Prop instead leaves `PicSharp.functorial`'s `map_add` field
  literally unconstructible (no path from "f^*M invertible" + pseudofunctor coherence
  to `f^*(M⊗N) ≅ f^*M ⊗ f^*N`), reproducing the present `functorial := 0` dishonesty
  one layer deeper and sending the prover round after an uncloseable goal.
- **Cheapest honest realization**: restrict the comparison iso to invertible arguments
  (the `Module.Invertible.instLocalizationLocalizedModule` precedent — base-change
  stability, not a general tensorator), provable by reduction to the axiom-clean
  `IsLocallyTrivial.pullback` chart-chase (`LineBundlePullback.lean:156`) on a common
  trivializing cover, where the tensor comparison collapses to the unit comparison.

## Informational

- Mathlib's `CommRing.Pic` (`Shrink (Skeleton (SemimoduleCat R))ˣ`) already provides
  the *complete* iso-class Picard functor stack — `mapAlgebra` (`:528`), `mapRingHom`
  (`:554`), `functor` (`:580`), with `mk_tensor`/`mk_dual`/`mk_eq_mk_iff` as the
  quotient-soundness toolkit. The project's `PicSharp.{functorial,presheaf}` should be
  modeled field-for-field on these. No scheme-level version exists in Mathlib (genuine
  gap), but the ring-level template dictates every field's substrate.

## Persistent file
- `analogies/rpf-pullback-bridge-granularity.md` — full design rationale (Mathlib
  citations, the `mapAlgebra` field breakdown, the derive-don't-sorry recipe).

Overall verdict: option A is insufficient — the `IsInvertible.pullback` bridge must
expose the monoidal comparison **iso** (existence form), exactly as Mathlib's
`CommRing.Pic.mapAlgebra.map_mul'` rests on the `distribBaseChange` iso; the bare Prop
is a derived corollary, and a mere comparison *map* (washed through the quotient) is
provably not enough.
