# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts229glue

## Iteration
229

## Question
(1) Does Mathlib already provide morphism-gluing for `SheafOfModules`/`PresheafOfModules`
(a `homOfLocalCompat`-shaped lemma / hom-sheaf)? (2) Is `presheafHom (…) (…)`-as-`TopCat.Sheaf`
+ `existsUnique_gluing` the right idiom for "global morphism = global section of the
internal-hom sheaf", or is `sheafHomSectionsEquiv`/`Sheaf.homEquiv` preferred? (3) Is the
`localSection` `naturality` (transport along `(Uᵢ).ι ''ᵁ ((Uᵢ).ι ⁻¹ᵁ V) = V`) the
Mathlib-idiomatic way, or another Mathlib-absent coherence gap of the kind that killed
the C-bridge?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1. Module-level morphism-gluing / hom-sheaf exists in Mathlib | NEEDS_MATHLIB_GAP_FILL | informational |
| Q1′. Ab/Type-level gluing engine reusable (`presheafHom`, `sheafHomSectionsEquiv`) | PROCEED (reuse) | informational |
| Q2. `presheafHom` + `existsUnique_gluing` is the right idiom | PROCEED (with `sheafHomSectionsEquiv` finish) | informational |
| Q3. `localSection` naturality (slice ↔ open-immersion) | NEEDS_MATHLIB_GAP_FILL — same gap-class as the dead C-bridge | **high** |

## Headline (the data the ROUTE-C PAUSE decision needs)

**The A-bridge `homOfLocalCompat` and the dead C-bridge `dual_isLocallyTrivial` are blocked
on the SAME root Mathlib-absent infrastructure**, and that infrastructure is a *named,
documented Mathlib TODO*: `Mathlib/Topology/Sheaves/Over.lean:19-22`. Mathlib ships the bare
1-categorical equivalence `TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U`
(`Topology/Sheaves/Over.lean:41`) but explicitly leaves undone the upgrade the project keeps
hitting:

> "show that both functors of the equivalence `overEquivalence U` are continuous and induce
> an equivalence between `Sheaf ((Opens.grothendieckTopology X).over U) A` and
> `Sheaf (Opens.grothendieckTopology U) A` for any category `A`."

This is exactly the "open-immersion slice-site equivalence ~150–300 LOC" the iter-228 prover
hit on the C-bridge ([[ts228-cbridge-slice-blocker]]). The A-bridge's `localSection` is a
*section-direction slice* of the very same comparison.

**Consequence for the dispatch:** `exists_tensorObj_inverse` (L2143) needs BOTH the A-bridge
AND the C-bridge (its own body comment, L2151-2160). They share the same gap. Therefore:

- Dispatching a prover at the A-engine **in isolation closes nothing route-relevant**: even
  a successful `homOfLocalCompat` leaves the C-bridge `dual_isLocallyTrivial` blocked on the
  identical slice gap, so the residual `sorry` does not move. This is precisely the
  "cost estimate by inspection, falsified by prover" trap — the A-bridge looks independent but
  is the same wall wearing a different hat.
- The genuinely route-unblocking move is to **build the shared general bridge once** (the
  Mathlib TODO: `Sheaf (J.over U) A ≌ Sheaf (Opens.grothendieckTopology U) A` + the
  module-pullback/`restrictFunctorIsoPullback` compatibility). That single build unblocks A
  *and* C, and is a clean upstream-PR candidate (completing a documented TODO). Realistic
  size ~200–350 LOC.

So the honest framing for the USER: the A-engine is **not** a fresh, independent ~120-190 LOC
win. It is one face of a ~200–350 LOC shared-infrastructure build that is the real precondition
for the whole `exists_tensorObj_inverse` route.

## Major

### Q1 — Mathlib has NO module-level morphism-gluing or hom-sheaf

Confirmed by directory sweep of `Algebra/Category/ModuleCat/{Sheaf,Presheaf}/*`: there is no
`internalHom`, `sheafHom`, or `homOfLocalCompat` for `PresheafOfModules`/`SheafOfModules`
(matches [[ts228-cbridge-slice-blocker]]'s loogle finding). What Mathlib *does* have:

- **Type/Ab-level hom-sheaf** (`CategoryTheory/Sites/SheafHom.lean`, general site `(C,J)`,
  values in any `A`): `presheafHom F G` (L46), `presheafHomSectionsEquiv` (L80),
  `Presheaf.IsSheaf.hom` (L207, needs `G` a sheaf), `sheafHom` (L236), `sheafHomSectionsEquiv`
  (L241). This is the engine the project's route 1–3 names — and it is the right one.
- **SheafOfModules slice machinery** (`Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean`):
  `SheafOfModules.over M X` (L53) = restriction over the **slice** `Over X` (= `pushforward (𝟙)`),
  `Hom.over` (L58), `pushforwardOver`/`overPushforwardOverAdj` (L267/L274),
  `pushforwardPushforwardEquivalence` (L305); and `QuasicoherentData.bind`
  (`Quasicoherent.lean:358`) — **object/descent-data gluing** over a site cover `J.CoversTop X`.

Critically, *every* SheafOfModules-native restriction/gluing in Mathlib is built on the
**slice** restriction `over X` and the site cover `CoversTop`, **never** the open-immersion
topological pullback the project uses (`M.restrict (Uᵢ).ι` via `Scheme.Modules.pullback` /
`restrictFunctorIsoPullback`). The project chose open-immersion restriction (forced by
`IsLocallyTrivial`, `tensorObj_restrict_iso`); Mathlib's gluing world is slice-indexed. The
bridge between them is the absent piece. Verdict: NEEDS_MATHLIB_GAP_FILL for the module layer;
PROCEED-by-reuse on the Ab/Type engine + the existing `Scheme.Modules.homMk` (L2103) to
re-attach `𝒪_X`-linearity.

### Q2 — `presheafHom` + `existsUnique_gluing` is correct; finish with `sheafHomSectionsEquiv`

`presheafHom (M.val.presheaf) (N.val.presheaf)` is a `Cᵒᵖ ⥤ Type`, a sheaf via
`Presheaf.IsSheaf.hom` (needs `N.val` a sheaf — it is). Packaged as `TopCat.Sheaf (Type) X`,
`existsUnique_gluing` (`Topology/Sheaves/SheafCondition/UniqueGluing.lean:180`) applies: its
instance side-conditions (`HasLimitsOfSize Type`, `forget` reflects/preserves limits) are
trivially met for `Type`. So the **cover→⊤** gluing step is `existsUnique_gluing` over the
cover `U` with `⨆ U = ⊤`.

The **⊤→morphism** step is *not* a hand-unfold of the `⊤`-section: use
`presheafHomSectionsEquiv` (L80) / `sheafHomSectionsEquiv` (L241). For `Opens X`, `⊤` is
terminal, so `(presheafHom F G).sections ≅ presheafHom(F,G).obj (op ⊤)` and the equiv lands
the glued section as an honest `F ⟶ G`. This avoids re-deriving the terminal-slice cleanup by
hand. Recommended idiom: `existsUnique_gluing` (cover→⊤) ∘ `presheafHomSectionsEquiv` (⊤→hom)
∘ `Scheme.Modules.homMk` (linearity). All three are Mathlib/already-built; no parallel API.
Verdict: PROCEED.

### Q3 — `localSection` naturality IS the same Mathlib-absent gap that killed the C-bridge

`presheafHom F G` indexes its sections at `Uᵢ` over the **slice** `Over Uᵢ`
(`(Over.forget Uᵢ).op ⋙ F ⟶ (Over.forget Uᵢ).op ⋙ G`, `SheafHom.lean:46`). The project's
local datum `fᵢ : M.restrict (Uᵢ).ι ⟶ N.restrict (Uᵢ).ι` lives over the **open-immersion
pullback** (`Opens ↥Uᵢ`). Converting `fᵢ` into a section of `presheafHom` over `Uᵢ` — the
`localSection` construction, with the `eqToHom`-conjugation along `(Uᵢ).ι ''ᵁ ((Uᵢ).ι ⁻¹ᵁ V) = V`
— is the **section-direction realization of the un-done `Topology/Sheaves/Over.lean` TODO**.
It is the same gap-class as the C-bridge's `(pushforward β)(dual A) ≅ dual(pushforward β A)`
([[ts228-cbridge-slice-blocker]]): both are the open-immersion ↔ slice sheaf comparison Mathlib
leaves unbuilt.

Mathlib supplies the algebraic backbone but **no helper that discharges the naturality
automatically**:
- `overEquivalence : Over U ≌ Opens ↥U` (`Topology/Sheaves/Over.lean:41`) — bare 1-categorical;
- `Opens.isOpenEmbedding_obj_top : U.isOpenEmbedding.functor.obj ⊤ = U` (`TopCat/Opens.lean:391`);
- `U.isOpenEmbedding.functor.obj ((Opens.map U.inclusion').obj V) = V ⊓ U`
  (`TopCat/Opens.lean:433`) and its `≤U` corollary at L444 — the exact `''ᵁ⁻¹ᵁ = V` identity.

The `localSection.naturality` must hand-assemble these into a coherence proof; it is real
`eqToHom`/`Over.map` work, not a discharged idiom. **It is a genuine Mathlib-absent gap.**

**Size, frankly:** the A-bridge instance is *smaller* than the C-bridge's because it needs only
the **section** direction (one section per `i` + its single naturality field + the overlap
`compat` translation + the `⊤`→hom cleanup), not a full natural iso of internal-hom functors in
two arguments with an inverse. Estimate **~80–150 LOC for `homOfLocalCompat` alone**, on top of
the gluing assembly — **not** the 30–60 LOC the plan hopes, and the plan's ~120–190 LOC total is
only achievable if the slice transport goes unusually smoothly (it did not for the C-bridge). And
per the Headline, the C-bridge's ~150–300 LOC slice transport is *still required separately*
unless the shared general bridge is built once.

## Informational

- The project's open-immersion-restriction formulation is the root cost driver. Had the local
  data been stated with Mathlib's native `SheafOfModules.over (Uᵢ)` (slice) + `J.CoversTop`,
  the hom-sheaf `presheafHom` (also slice-indexed) would align directly and much of
  `pushforwardPushforwardEquivalence` / `QuasicoherentData.bind` could be reused. This is a
  DIVERGE_INTENTIONALLY already locked in upstream (`IsLocallyTrivial`/`tensorObj_restrict_iso`
  use open-immersion `restrict`); flagging it only so the planner knows the bridge is the price
  of that earlier choice, not a fresh surprise.
- `existsUnique_gluing`'s side-conditions are free for `Type`; no instance hunting needed.

## Persistent file
Not written — this dispatch granted write access to the report path only ("Your only writable
target is the report path above"). The design rationale is inlined above; if the planner wants
it under `analogies/ts229glue.md`, re-dispatch with `--write-domain 'analogies/**'`.

Overall verdict: PROCEED on the `presheafHom`+`existsUnique_gluing`+`sheafHomSectionsEquiv`+`homMk`
idiom (it is the right and only Mathlib engine), but the `localSection` naturality is a real
Mathlib-absent coherence gap of the SAME class that killed the C-bridge (the documented
`Topology/Sheaves/Over.lean` slice-site TODO); building `homOfLocalCompat` alone (~80–150 LOC)
does NOT close `exists_tensorObj_inverse` because the C-bridge shares the gap — the
route-unblocking move is the single shared general bridge (~200–350 LOC, completes a Mathlib TODO).
