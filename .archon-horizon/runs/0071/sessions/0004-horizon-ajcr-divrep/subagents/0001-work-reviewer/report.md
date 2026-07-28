VERDICT: **converging.** All five soundness claims hold. One real finding, and it cuts in your favor rather than against you: the residual debt is smaller than your own interface says.

## The finding: IsChartClause reduces to its `omega = id` instance

`IsChartClause` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepAffPullClause.lean:119`) quantifies over every `S` and every `omega`. The worksheet U2 (`informal/w4-ddr9-worksheet.md:309-322`) is stated only at the identity point. Your header calls IsChartClause "the DDR9-U interface, named" — they are not the same statement syntactically, but they are **equivalent**, and I proved the hard direction:

```
theorem chartClause_of_id (U : ...)
    (hid : ∀ i j, IsDivRepClassify hpi g r1 r2 b1 b2 (U i j)
             (divCarveChartToDivScheme ... i j)) :
    DivRepChartFamily.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U
```

Typechecks at HEAD, sorry-free, axioms `[propext, Classical.choice, Quot.sound]`. Because `IsDivRepClassify` already quantifies over *all* k/S-tower tests, the `omega` quantifier adds no strength: a tower test `T` over `S` plus `omega : R → S` *is* a tower test over `R` via `((IsScalarTower.toAlgHom k S T).comp omega).toRingHom.toAlgebra`; `divRepPullAt` is `mapAlgHom omega`, so `mapAlgHom_comp` collapses the two restrictions and the framing is untouched; the conclusion transports because `algebraMap R T = (algebraMap S T).comp omega`. Filed as I-0561; the general lesson as I-0562.

Consequence: a U2 producer reading your interface prices an all-base-change clause, when what is actually owed is the identity-point statement `divUniversalFamily` was built for (`DivSchemeFamilyUniv.lean:72-79`). That is a landed lemma of distance, not a research step.

## (1) pull_naturality — CONFIRMED

Field at `DivRepAffKit.lean:184-186`. I built `DivRepAffinePullback` by filling fields directly (no `ofPull`) with `pull_naturality := divRepPullValue_naturality hpi g r1 r2 b1 b2 U (...isCompatible...)` — a bare `:=`, no eta-wrapper, no `fun`-adapter. Typechecks. Same shape, same binders, no weakening.

## (2) NOT VACUOUS — CONFIRMED, two independent ways

The hypothesis conjunction (certified representative **and** pair-chart framing) is satisfiable for *every* class: `DivFamZar.exists_certChartCover` (`DivRepClassifyZarKit.lean:433`) produces exactly that conjunction on each piece of a span-⊤ family. I re-derived its full statement as a standalone theorem to be sure.

Stronger, and this is what actually kills the vacuity worry: `IsDivRepClassify F₀ ·` is a **∃!** predicate on morphisms. I proved

```
∃! v, IsDivRepClassify hpi g r1 r2 b1 b2 F0 v
```

from `exists_isDivRepClassify` + `isDivRepClassify_unique`. A predicate satisfied by exactly one morphism cannot be trivially true of every morphism. It also separates classes (`eq_of_isDivRepClassify`).

## (3) Full binder list — CONFIRMED, no hidden IsCompatible

`#check @divRepAffinePullback_ofChartClause`: after the instance block and `hpi g hO hchi r1 r2 b1 b2`, the explicit hypotheses are exactly `U` and `IsChartClause hpi g r1 r2 b1 b2 U`. Nothing else. `IsCompatible` is genuinely derived, inside the def, by `IsChartClause.isCompatible` (`:132`). Same for `divFunctor_representableBy_of_chartClause` — and its `hO`/`hchi` even print un-named, i.e. used only positionally. `ofPull`'s three fields are all discharged.

## (4) IsChartClause vs the old hypothesis — SAME STATEMENT, rfl in both directions

Not merely "equivalent": I checked

- old hypothesis shape written out verbatim → `IsChartClause` by bare `hcl`;
- `IsChartClause` → old slot of `isCompatible_of_isDivRepClassify_divRepPullAt` by bare `hU`;
- and `IsChartClause U = (∀ {S} [CommRing S] [Algebra k S] i j omega, IsDivRepClassify ...) := rfl`.

All three elaborate. No extra `S`, no extra chart quantifier, no implicit-to-explicit shuffle. Your claim "the two obligations are one" is correct as stated.

## (5) Hygiene — CLEAN

Zero sorries in both files and in all twelve modules of the import closure. `lake build AlgebraicJacobian.Picard.DivRepAffPullClause` → **Build completed successfully (8870 jobs)**, 118s.

```
divFunctor_representableBy_of_chartClause : [propext, Classical.choice, Quot.sound]
isDivRepClassify_of_forall_away           : [propext, Classical.choice, Quot.sound]
pullback_isDivRepClassify_compat          : [propext, Classical.choice, Quot.sound]
isDivRepClassify_divRepPullValue          : [propext, Classical.choice, Quot.sound]
divRepAffinePullback_ofChartClause        : [propext, Classical.choice, Quot.sound]
divRepPullValue_naturality                : [propext, Classical.choice, Quot.sound]
specMap_awayMapₐ_comp                     : [propext, Classical.choice, Quot.sound]
```

One warning you own: `DivRepAffPullClause.lean:306` — `maxHeartbeats` without the mandated explanatory comment. The other three `set_option maxHeartbeats` sites in the file have theirs; `:306` (on `isDivRepClassify_of_forall_away`) does not. Two-line fix.

## (6) Duplication — no duplicates, but one near-clone worth naming

`specMap_awayMapₐ_comp` is **not** a re-derivation. `horizon search` over both projects and mathlib returns no Spec-level away-push square; mathlib has `Localization.awayMap`/`awayMapₐ` and surjectivity lemmas only, and the tree's only `Spec`+`awayMap` hits are `Proj.SpecMap_awayMap_awayι` (graded, unrelated) and your own lines. Genuinely new, and it is 5 lines.

`pullback_isDivRepClassify_compat` (`:165`) and `pullback_chart_divClassifyClause_compat` (`DivRepClassifyZarCompat.lean:292`) are **not the same lemma** — the hypothesis differs where it matters. The old one takes a `DivClassifyClause` for a `DivFam` representative `F₂` over `A`; yours takes an `IsDivRepClassify` for the *restricted class* over `A`. Different inputs, so neither subsumes the other. But the proofs are near-clones: normalizing subscripts and whitespace, **41 of ~100 body lines are identical** — the same six `IsScalarTower.of_algebraMap_eq'` instances, the same `hβ` identity-tower trick, the same `hy₁/hy₂ → hωB₁/hωB₂ → hcomp → hext` ladder, the same `pullbackSpecIso_inv_fst_assoc` finish. That instance block plus the framing pushforward is a shared lemma waiting to be extracted; it is now written twice and will be written a third time by the next overlap comparison. Not a duplicate to retract, a factoring debt to record. (Your own commit message anticipates the *statement* split as necessary — the cover index is not `Fin m` on the nose — which I confirmed; it does not explain the duplicated instance scaffolding.)

## Throughput

Not churning. Three lane commits today move real fields: `994e0d5ea` defines `pull`, `5fcbe39a4` proves `pull_naturality`, `0b67179bb` proves the third field and produces the package. No helper accretion, no sorry-stall, no route in circles. `IsDivRepClassify` being local on the base (`isDivRepClassify_of_forall_away`, `:317`) is the load-bearing new tool and it mentions no chart family, which is the right shape.

The honest-accounting in the commit message ("U2 itself is NOT proved: nothing here produces an `IsChartClause`") matches the tree: I found no producer, and roadmap leaf `AJCR.w4-rep.datum.dat-d.ddr.divrep.u2` is still `pending`. No axioms, no placeholders, no artificial disjunctions. The one thing to correct is in the *other* direction from the usual failure mode — you understated your own progress by leaving the interface stated more strongly than it needs to be.
