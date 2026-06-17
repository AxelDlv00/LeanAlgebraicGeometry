# Recommendations for iter-263 (from review of iter-262)

## HIGH — must-address-this-iter signals

### 1. D3′ Sq1 escalation trigger is LIVE — do NOT re-run the monolith
The iter-262 plan armed: *"if Sq1's unit reassembly returns another PARTIAL with no close, escalate
to a fine-grained decomposition of the mate calculus (the PARTIAL count would reach 5)."* Sq1
returned PARTIAL with no full close (R0 peeled, but the R1/R5 tail sorry remains). **The trigger
fires.** Two acceptable responses for the next plan:
  - (a) One MORE targeted prover round to close ONLY the R1/R5 collapse tail — it is well-scoped
    (~30 lines mirroring `pullbackObjUnitToUnit_comp` L969–996, with the X-side sheafification layer
    already discharged; building blocks named: `homEquiv_leftAdjointUniq_hom_app`,
    `pushforwardComp.hom.naturality`, `comp_unit_app`/`unit_naturality`). This is the cheaper bet
    and is genuinely closer than iter-261's state (R0 is now gone in compiling code).
  - (b) If (a) returns ANOTHER no-close PARTIAL, escalate to fine-grained decomposition of the mate
    calculus (extract the R1/R5 collapse as its own named lemma) and/or a mathlib-analogist
    cross-domain consult on the bicategorical-cocycle shape.
  Whichever is chosen, **do NOT re-dispatch the full Sq1 lemma as a fresh monolithic `prove` round
  with the same recipe** — that is the churning anti-pattern. Frame the round as "close the R1/R5
  tail" specifically.

### 2. DUAL `sliceDualTransport` — build the two named sub-bricks, then invFun
The STUCK watch is dissolved (codomainMap closed, 7→6). To keep the lane converging:
  - Add the small **`internalHomObjModule`-add ↦ `PresheafOfModules.Hom`-add (and -smul) defeq
    bridge** lemma (a `change`/unfold of the `internalHomObjModule` add field), which immediately
    unblocks `map_add'` + `map_smul'` via `Functor.map_add, add_comp`. This is the cheapest
    measurable next reduction (6 → 4).
  - Then **build `invFun`** (the ~150–250 LOC reverse construction: `(f.appIso W').hom` + inverse
    down-set bijection `image_preimage_of_le` + `ε` codomain swap), which unblocks left_inv/right_inv.
  - Naturality needs ε-naturality of `restrictScalars` (an `erw` paste).
  Reusable: phrase any further change-of-rings ε-isos at the **CommRingCat** carrier (where CommRing
  is native), not the `forget₂`'d RingCat carrier — `ma-legb262`'s validated unlock.

### 3. Sequence the engine `CechNerve` build AFTER / sharing the D3′ coherence bricks
The engine's lone remaining nerve hole `CechNerve` is blocked on a push-pull functor `G`'s
`map_id`/`map_comp`, which need the **same** `pushforwardComp`/`pullbackComp` coherence as D3′. The
prover's strong recommendation (echoed by lvb-cech): do NOT re-derive the coherence in the
Cohomology file — depend on / mirror the `TensorObjSubstrate` `pullbackComp_δ` machinery. **Plan
implication**: the engine lane is NOT as import-independent as iter-262 assumed; its hard step is
coupled to the D3′ lane. A cheap, genuinely independent engine step is `Gobj` + `Gmap` (the 3-step
composite + 2 `eqToHom` along `Over.w`, an axiom-clean brick with no functor laws) — that can land
this iter; defer `Gmap_id`/`Gmap_comp` until the shared coherence bricks exist.

## MEDIUM — blueprint-writer tasks (HARD GATE: fix before re-dispatching the affected lane)

### 4. `Picard_TensorObjSubstrate.tex` — add the `internalHomObjModule`-bridge note (lvb-di262 major)
The `lem:slice_dual_transport` proof sketch (map_add'/map_smul' paragraph, ~L5741–5743) is too thin:
it omits that the dual section object's `+`/`•` is the `internalHomObjModule` module action, NOT the
`PresheafOfModules.Hom` action, so a `change`/unfold bridge is required before `Functor.map_add`
fires. A prover following the blueprint alone hits the wall blind. Dispatch a blueprint-writer to
add this note (and optionally inline `\lean{}` tags for `isIso_ε_restrictScalars_appIso` /
`dualUnitRingSwap`, lvb-di262 minor). NOTE: lvb-tos262 cleared the TensorObjSubstrate.lean side of
this consolidated chapter (0 findings) — the writer directive should target ONLY the dual
sub-section, not the D3′/Sq1 prose.

### 5. `Cohomology_CechHigherDirectImage.tex` — promote the G-decomposition + flag Mathlib gaps (lvb-cech major)
The chapter is **inadequate** for the `CechNerve` build: it has zero coverage of the
backbone/push-pull-functor decomposition, the `eqToHom`+`pushforwardComp`/`pullbackComp` coherence
wall, and the project-local helper strategy (`coverArrow`/`coverCechNerve`/`relativeCechComplexOfNerve`).
Promote the Lean file's "Project-local Mathlib supplement" section (L99–157) into a blueprint
section. Also fix: the "simplicial"→"cosimplicial" terminology error in the `def:cech_nerve` body;
document the `Nonempty(≅)` weakening + the `[HasInjectiveResolutions X.Modules]` hypothesis on
`cech_computes_higherDirectImage`; add explicit Mathlib-gap flags on the 3 downstream sorry'd
theorems (`CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`). Per the
HARD GATE, this chapter must clear a (scoped) re-review before a prover is dispatched to close
`CechNerve` from the blueprint — though the cheap `Gobj`/`Gmap` brick (rec #3) can proceed from the
Lean file's existing in-code guidance.

## LOW — code hygiene (next prover to touch `DualInverse.lean`, fold into the lane directive)
- **aud262 major**: remove/reconcile the stale iter-261 STATUS NOTE in `sliceDualTransport`'s body
  (~L289–292) that still calls codomainMap "blocked on CommRing recovery + 𝟙_/restr bridge" — it is
  closed (iter-262 update at L324–327 is the accurate one; the iter-261 block contradicts it).
- **aud262 major**: move the multi-paragraph `/- Planner strategy -/` blocks OUT of the `/-- … -/`
  docstrings of `dual_restrict_iso`, `dual_isLocallyTrivial`, `homOfLocalCompat` into separate
  `/- … -/` block comments before the decls (they currently render as the public docstring).
- **aud262 minor**: simplify the TensorObjSubstrate header's "iter-247 import-cycle" aside.

## Blocked — do NOT re-assign as standalone targets
- `dual_restrict_iso` (DualInverse L487): assembly residual, transitively blocked on the open
  `sliceDualTransport` fields. Unblocks automatically once `sliceDualTransport` closes.
- `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`: each needs
  substantial Mathlib-absent infrastructure (module-level contracting homotopy; Čech-to-cohomology +
  Leray spectral sequences for `Scheme.Modules`; term-wise affine base change of the Čech complex).
  Out of scope until `CechNerve`/`CechComplex` close and the spectral-sequence scaffolding exists.
- `exists_tensorObj_inverse` (TensorObjSubstrate L720): cross-file gated on the dual chain
  (`dual_restrict_iso` C-bridge + `homOfLocalCompat` A-bridge); closes downstream of the DUAL lane.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **CommRingCat-carrier ε-iso phrasing**: change-of-rings lax-monoidal unit `ε (restrictScalars g)`
  is an iso for a ring iso `g`; phrase at the CommRingCat carrier (`(f.appIso W').inv.hom`) where
  `CommRing` is native — `restrictScalars` of the `forget₂`'d hom is `rfl`-equal so downstream
  domains still match. Endpoints reconcile by pure defeq, no `eqToHom`/`change` bridge.
- **`erw`-splice past glued factors**: to splice a proven `key : A ≫ B' = …` into a goal where
  `A ≫ B'` is not a syntactic subterm (factors glued by `comp_unit_app`, objects at
  defeq-but-not-syntactic `Functor.obj`): `simp only [Functor.comp_map] at key ⊢` to align spellings,
  then `erw [Category.assoc]; erw [reassoc_of% key]` (`erw`, NOT `rw`/`simp`).
- **`Scheme.Modules.pushforward = SheafOfModules.pushforward ∘ toRingCatSheafHom` is `rfl`** — a
  building block just needs the `SheafOfModules` spelling in its STATEMENT to match by `rw`/`congrArg`;
  the prior "whnf timeout" belief was a namespace typo (`Scheme.Hom.toRingCatSheafHom`).
- **Čech nerve→complex is coherence-free**: split into geometric backbone
  (`Arrow.augmentedCechNerve`, unconditional) + plumbing (`alternatingCofaceMapComplex` +
  `CosimplicialObject.whiskering (pushforward f)` + `Augmented.drop`, preadditivity only). The
  coherence cost is isolated to the push-pull functor `G` alone.
