# Recommendations for the next plan iteration (post iter-063)

## Headline: both routes CHURNING — do NOT bare re-dispatch. Effort-break + blueprint-complete FIRST.
Three consecutive flat iters (061/062/063, sorry stuck at 9). Each iter lands real axiom-clean
foundations but converts no sorry. Both lanes now share the same shape: **one large, well-understood,
unbuilt final assembly behind a blueprint that is thin or under-specified.** The HARD GATE applies to
BOTH files this iter — neither chapter block is `complete + correct` for its live frontier. The
corrective for each is structural (effort-break + blueprint-writer), not another prover throw.

## CRITICAL / HIGH (do these before any prover round)

### Lane A — CSI: effort-break `lem:pushPull_coprod_prod` (Stub-2 dependency)
- The `\lean{AlgebraicGeometry.pushPull_coprod_prod}` block targets a **non-existent decl** (LVB
  must-fix). I added a `% NOTE: build target`. Before a prover round, dispatch **effort-breaker** on
  `lem:pushPull_coprod_prod` to author the 6 sub-lemmas the prover already specified precisely:
  1. `pushPullObjCongr (e : Y ≅ Y') : pushPullObj F Y ≅ pushPullObj F Y'` (CONTRAVARIANT, ~6 LOC).
  2. Over-X lift of `sigmaOptionIso` with descent-map compatibility (`Over.isoMk`, ~15 LOC).
  3. `piOptionIso` (product dual of `sigmaOptionIso`: `∏ᶜ W ≅ W none ⨯ ∏ᶜ a, W (some a)`, ~15 LOC).
  4. `induction_empty_option` on `ι`: `h_empty` (initial-scheme terminality — **fiddly**), `of_equiv`
     (canonical-`Pi.lift` reindexing — **tricky**), `h_option` (chain through `pushPull_binary_coprod_prod`
     + IH + `piOptionIso.symm`).
  5. the ~15 LOC specialization to `pushPull_sigma_iso` (Stub 2) via `cechBackbone_left_sigma` (DONE) +
     `overSigmaDescIso` + `pushPullObjCongr`.
- `sigmaOptionIso` (the helper already built) and `pushPull_binary_coprod_prod` (the L2 node) are done
  and feed this directly. After the effort-break + a scoped blueprint-reviewer clear, a prover round on
  CSI is justified.
- **Fix the `private` → `\lean{}` mismatch (blocks `sync_leanok`).** Five decls named in public `\lean{}`
  hints are `private`: `pushPull_binary_leg_coherence`, `coprodDecompMap`, `isIso_coprodDecompMap`,
  `isIso_prodLift_of_isLimit`, `isIso_map_prodLift_of_isLimit`. `sync_leanok` cannot resolve private
  names (this is why iter-063 synced `added=0` despite two newly-proved axiom-clean decls). Have the next
  prover/refactor drop `private` on these (or the planner adjust the `\lean{}` hints). This is the reason
  the green, axiom-clean L2 work is not showing `\leanok`.

### Lane B — OpenImm: rewrite `lem:pushforward_slice_two_adjunction` BEFORE any prover round
- LVB major (2): the blueprint states φ'' as `sliceStructureSheafHom φ.symm Vᵢ` — **wrong codomain**
  (lands in `Over (φ.hom⁻¹ᵁ Vᵢ)`, slot demands `eqv.inverse` into `Over Uᵢ`). Dispatch **blueprint-writer**
  on this block to:
  1. State φ'' as the **over-pullback of `φ.hom.toRingCatSheafHom`** transported by `eqToHom` (the KEY
     INSIGHT: φ'' is object-level correction-FREE; `Over.map (unitIso.inv)` affects only H₁/H₂).
  2. State that BOTH `sliceOversEquiv` continuity instances (forward + inverse, now built) must be
     **explicitly supplied** to `pushforwardPushforwardAdj`.
  3. Then **effort-break** the H₁ (counit-naturality) / H₂ (unit-triangle) squares — the genuine ~150 LOC
     coherence wall — into their own sub-lemmas.
- iter-062's "unit-module-only" concern on `lem:pushforward_slice_pullback_iso` is **resolved** (LVB
  confirmed Step 2 states the section identity correctly) — no action there.
- After the writer + a scoped blueprint-reviewer clear, OpenImm is prover-ready.

## MEDIUM

### Resolve the duplicated `isZero_of_faithful_preservesZeroMorphisms` (auditor major #2)
- The same fully-qualified `isZero_of_faithful_preservesZeroMorphisms` is declared in BOTH
  `OpenImmersionPushforward.lean:40–50` and `CechAugmentedResolution.lean`. Harmless today (the files
  don't import each other) but a **redeclaration error the moment anything imports both**. Dispatch a
  **refactor** to hoist it to a shared upstream module (or `private` one copy). Do this before the P5b
  assembly that may pull both into scope.

### Prune the stale CSI planning comment (auditor major #1)
- `CechSectionIdentification.lean:695–729` still says `pushPull_binary_coprod_prod` is "remaining" — it is
  proved. Have the next prover/refactor prune it (cosmetic, but it misleads the next prover's planning).

## Coverage debt — `archon dag-query unmatched` (9 nodes; planner must blueprint these)
All are `lean_aux` with no blueprint block. New this iter unless noted:
- `CategoryTheory.sigmaOptionIso` (CSI) — `Iso`, `∐ Z ≅ Z none ⨿ ∐ a, Z (some a)`; deps:
  `Sigma.desc`/`coprod.desc` universal properties. Intended leaf of future `lem:pushPull_coprod_prod`.
- `AlgebraicGeometry.opensMapHomBase_isEquivalence` (OpenImm) — deps: `Opens.mapMapIso`,
  `Scheme.forgetToTop.mapIso`.
- `AlgebraicGeometry.opensEquivOfIso` (OpenImm) — deps: `Opens.mapMapIso (forgetToTop.mapIso φ).symm`.
- `AlgebraicGeometry.sliceOversEquiv` (OpenImm) — deps: `Over.postEquiv`, `opensEquivOfIso`.
- `AlgebraicGeometry.sliceOversEquiv_functor_isContinuous` (OpenImm) — deps: `overPost_slice_isContinuous`.
- `AlgebraicGeometry.overPost_slice_inverse_isContinuous` (OpenImm) — deps:
  `Functor.isContinuous_of_coverPreserving`, `compatiblePreservingOfFlat`, `CoverPreserving.overPost`,
  `coverPreserving_opens_map φ.hom.base`.
- `AlgebraicGeometry.sliceOversEquiv_inverse_isContinuous` (OpenImm) — deps: `Functor.isContinuous_comp`,
  `GrothendieckTopology.instIsContinuousOverMapOver`, `Over.postEquiv_inverse`,
  `overPost_slice_inverse_isContinuous`.
- `AlgebraicGeometry.pushPullCoprodLegIso` (CSI, pre-existing aux) — bundle into
  `lem:pushPull_binary_coprod_prod` or `lem:pushPull_binary_leg_coherence`.
- `AlgebraicGeometry.CechAcyclic.affine` (dead, pre-existing) — the `sorry`-bodied dead leaf; either
  blueprint-or-delete (it is off all live `\uses` chains).
- Suggest bundling the 6 OpenImm helpers under a new `lem:slice_overs_equiv_continuity` anchor (they are
  the continuity prerequisites of `lem:pushforward_slice_two_adjunction`).

## Do NOT re-assign without a structural change first
- **CSI `pushPull_sigma_iso` (Stub 2)** — blocked on the un-decomposed `pushPull_coprod_prod`. Do not send
  a prover until the effort-break above lands in the blueprint. The binary node + `sigmaOptionIso` are
  done; the gap is the induction assembly, not a missing lemma.
- **OpenImm `hqc` / `pushforward_iso_preserves_qcoh`** — blocked on φ''/H₁/H₂. Do not send a prover until
  `lem:pushforward_slice_two_adjunction` is rewritten with the correct φ'' construction + H₁/H₂ broken out.
  The metavar wall is gone; what remains is genuinely the coherence assembly.

## Reusable patterns discovered this iter
- **prod-lift leg-matching over pushforward objects:** to prove `prod.lift (f) (g)` is iso where the
  factors live under a pushforward, match it against a reference chain through `prod.lift_map` +
  `prod.comp_lift` + `prodComparison = prod.lift (q_* fst) (q_* snd)` (defeq via `PreservesLimitPair.iso_hom`)
  + `← Functor.map_comp_assoc`, then a trailing `rfl`. `Category.assoc`/`simp` will NOT reassociate
  `(A≫B≫C)≫prod.fst` here; `prod.hom_ext` + projection rewrites are a dead end.
- **defeq-not-syntactic instance ascription:** when an instance argument's base object has multiple
  defeq-but-not-syntactic spellings, instance *search* (reducible transparency) fails but *ascription*
  (`exact`, default transparency) succeeds. Build the instance in a `have key` with all args/instances via
  `@`, then `exact key` to close the differently-spelled outer goal.
- **type-ascribe iso codomains** that come out only defeq (e.g. `pushPullCoprodLegIso` lands in
  `pushPullObj F (Over.mk Y₀.hom)`, pin to `pushPullObj F Y₀`) or downstream `prod.fst`/`prod.map`
  rewrites silently no-op.
