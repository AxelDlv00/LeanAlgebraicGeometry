# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ma-d3264

## Iteration
264

## Question
Does the Mathlib `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` coherence (the engine's
`conjugateEquiv_*` / `pseudofunctor_*` lemmas) apply to the D3′ Sq1 tail
(`sheafificationCompPullback_comp_tail`), whose units are units of the COMPOSITE adjunction
`B_φ := (PresheafOfModules.pullbackPushforwardAdjunction φ').comp sheafificationAdjunction` —
absorbing the extra sheafification layer automatically, so the tail closes the SAME way as the
engine's functor laws rather than via a bespoke project mate calculus? If not, is the project
carrying a parallel API, and what is the concrete next-step lemma set?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Engine pseudofunctor route absorbs the sheafification layer of the D3′ tail | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. Project carries a parallel API (`PrPbPushAdj`/`sheafAdj`/`sheafificationCompPullback`) | PROCEED (no parallel API) | informational |

## Informational

**Q1 — NO, the engine route does NOT transfer.** `Scheme.Modules.pullback`/`pushforward`/`pullbackComp`/
`pushforwardComp` ARE the pseudofunctor's 1-/2-cells (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:300`),
and the engine's `pushPullMap` (`CechHigherDirectImage.lean:175`) lives entirely at that sheaf level —
so its deferred functor laws genuinely fall to `pseudofunctor_associativity`/`_left_unitality`/
`_right_unitality` (`Sheaf.lean:246,263,277`); at the sheaf level the coherence is even sectionwise
trivial (`pushforwardComp_hom_app_app = 𝟙`, `Sheaf.lean:214`, `rfl`). **But the D3′ tail's subject is
`SheafOfModules.sheafificationCompPullback`** (`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:117`),
the comparison `sheafification ⋙ SheafOfModules.pullback ≅ PresheafOfModules.pullback ⋙ sheafification`
— it IS the sheafification layer, the bridge between the sheaf pseudofunctor and the
presheaf-pullback-then-sheafify pseudofunctor. The pseudofunctor coherences live one level ABOVE it and
never mention it. A global grep confirms Mathlib has only the `def` of `sheafificationCompPullback` and
**no composition / naturality / coherence lemma** for it. So the sheaf-level coherences cannot absorb the
layer; `sheafificationCompPullback_comp` is genuinely Mathlib-absent.

**Q2 — NO parallel API; do not re-express `B_φ` in pseudofunctor 1-cells.** `sheafificationCompPullback`
is Mathlib's own `Adjunction.leftAdjointUniq` of two `Adjunction.comp` composite adjunctions
(`PullbackContinuous.lean:117–125`); `PrPbPushAdj`/`sheafAdj` are comment mnemonics for the Mathlib
adjunctions; `sheafificationCompPullback_eq_leftAdjointUniq` (`TensorObjSubstrate.lean:1603`) is a
`rfl`-bridge; the caller's transpose (`homEquiv.injective` + `homEquiv_leftAdjointUniq_hom_app`) is the
correct Mathlib idiom for a `leftAdjointUniq` identity. There is nothing to re-express in pseudofunctor
1-cells — those are a strictly higher layer that cannot reach this comparison. `Adjunction.leftAdjointUniq_trans`
(`Unique.lean:79`) does NOT shortcut it: it needs the SAME right adjoint, whereas here the right adjoint
(pushforward) varies with `f`/`h`/`h≫f` and the comparison is conjugated by `pullbackComp`/`pushforwardComp`.

**Q3 — concrete next-step lemma set** (mirror `pullbackObjUnitToUnit_comp` L952–1001 one composite-adjunction
level up; R0-peel already done by `sheaf_unit_comp_pushforward_pullbackComp_inv`):
1. `Adjunction.homEquiv_leftAdjointUniq_hom_app` (`Unique.lean:39`) on `(sheafificationCompPullback f/h).app _ .hom`
   to recover the R1/R5 factors as the composite units `B_f.unit`/`B_h.unit` (replaces the model's `hLf`/`hLh`).
2. `Adjunction.comp_unit_app` (the composite-adjunction unit expansion; this is the composite analog of the
   model's `rfl`-linchpin `unitToPushforwardObjUnit_comp` — at composite level it is NOT `rfl`).
3. `Adjunction.homEquiv_unit` + `Adjunction.homEquiv_naturality_left`/`_right` (the `hinner`/`hcomp'`/`key2` chain).
4. `(Scheme.Modules.pushforwardComp h f).hom.naturality` (slide the sheaf `pushforwardComp.hom`, model L997).
5. `Adjunction.unit_naturality` + `Functor.comp_map` + `← Functor.map_comp` + `erw [Category.assoc]` (final collapse).
6. For the presheaf δ_pre (`PresheafOfModules.pullbackComp` = `leftAdjointCompIso`):
   `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (`CompositionIso.lean:82`) — no project-named
   presheaf `conjugateEquiv_pullbackComp_inv` exists; use the abstract lemma.
Use `erw` (not `rw`) for assoc/`Functor.map_comp`/coherence steps — `SheafOfModules` compositions are
defeq-but-not-syntactic (model docstring L911–914).

## Persistent file
- `analogies/ma-d3264.md` — design-rationale captured for future iters.

Overall verdict: the engine's Mathlib-pseudofunctor route does NOT close the D3′ Sq1 tail (it operates one
layer above the sheafification bridge `sheafificationCompPullback`, for which Mathlib has no composition
coherence) — the project is not carrying a parallel API, so the documented ~50–80 LOC project-local mate
calculus mirroring `pullbackObjUnitToUnit_comp` is the correct and necessary route.
