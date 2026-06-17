# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (3, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv` (the PRIMARY target — the
    shared open-immersion↔slice sheaf-site equivalence; completes the Mathlib TODO at
    `Topology/Sheaves/Over.lean:19-22`)
  - `AlgebraicGeometry.Scheme.Modules.overEquivInverseIsDenseSubsite` (instance; the
    dense-subsite datum `sheafCongr` consumes)
  - `AlgebraicGeometry.Scheme.Modules.overEquiv_image_cover_iff` (private; the sole
    non-formal content — the pointwise cover-correspondence)
- **Blocked: 0.** The PRIMARY landed in full (not just the obligation).
- **Sorry count in file: 3 → 3** (pre-existing 691/2165/2211 untouched; NO new sorry).
- **Build: GREEN** (`lake env lean` exit 0; only the 3 pre-existing sorry warnings).
- File location: appended as a new `section OverSliceSheafEquiv` inside
  `namespace AlgebraicGeometry.Scheme.Modules`, after `end AlgebraicGeometry`
  (lines ~2219–2330).

## overSliceSheafEquiv (PRIMARY) — RESOLVED, axiom-clean
- **Approach:** Route (a) from the directive — `CategoryTheory.Equivalence.sheafCongr`
  applied to `TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U`. This was
  STRICTLY cheaper than route (b) `Functor.IsDenseSubsite.sheafEquiv`, which additionally
  demands an `IsEquivalence (sheafPushforwardContinuous …)` instance; `sheafCongr` needs
  only `e.inverse.IsDenseSubsite K J`. Route (b) was therefore not pursued (dominated).
- **The one real obligation** was the dense-subsite instance. For an equivalence functor
  the three auto fields (`isCoverDense'`, `isLocallyFull'`, `isLocallyFaithful'`) infer
  for free; only `functorPushforward_mem_iff` has content. I discharged it by:
  1. `GrothendieckTopology.mem_over_iff` to drop the slice topology to `(gt X)` membership;
  2. `Sieve.functorPushforward_comp` (+ `rfl` unfolding `Sieve.overEquiv`) to identify
     `overEquiv (e.inverse.obj W) (S.functorPushforward e.inverse)` with
     `S.functorPushforward (e.inverse ⋙ Over.forget U)` — i.e. pushforward along the
     **open-embedding image functor** `↥U ↪ X`;
  3. the pointwise lemma `overEquiv_image_cover_iff`: both sides are the pointwise
     neighbourhood-cover condition that DEFINES `Opens.grothendieckTopology`, matched
     across the injection `Subtype.val` (forward: `y∈W ⇒ ↑y∈image`, pull a cover back;
     backward: `↑y∈image ⇒ y∈W`, push the subspace cover forward with `h = 𝟙`).
- **Thinness confirmed decisive** (analogist ts229slice was right): NO `Over.map`
  pseudofunctor coherence appears anywhere; the only content is point-chasing through
  `Subtype.val`. The iter-228 "~150–300 LOC slice-site build" fear was pessimistic — the
  whole thing is ~110 LOC including docstrings.
- **Naming gotcha (recorded for reuse):** the decls must live in
  `namespace AlgebraicGeometry.Scheme.Modules` (blueprint pin), but inside that namespace
  the unqualified `Opens` resolves to the **scheme** `Scheme.Opens` (expects a `Scheme`),
  shadowing `TopologicalSpace.Opens`. Fix: fully qualify the TYPE as
  `TopologicalSpace.Opens X` and the equivalence as `TopologicalSpace.Opens.overEquivalence`,
  but `grothendieckTopology` is `_root_.Opens.grothendieckTopology` (root `Opens` namespace,
  NOT `TopologicalSpace.Opens.grothendieckTopology` — that constant does not exist).
  Writing the qualified name *into the `def`/`instance` declaration header* (`def Foo.bar`)
  re-opens the namespace for the body and re-triggers the shadow — so use a `namespace …`
  block, not a dotted declaration name.

## Blueprint
- `lem:open_immersion_slice_sheaf_equiv` (`Picard_TensorObjSubstrate.tex:2839`) is pinned
  `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` — name matches exactly;
  `sync_leanok` should now add `\leanok` (statement + proof, compiles sorry-free).

## Why I stopped — Real progress (PRIMARY fully closed)
The shared root — the single Mathlib-absent ingredient both ⊗-inverse bridges reduce to —
is **closed axiom-clean**, exceeding the directive's success bar (which only asked for
"maximal axiom-clean progress + a precise decomposition if the dense-subsite obligation is
large"; the obligation was NOT large — I closed it entirely). The expected `80→79` was
explicitly NOT targeted this iter.

## Next step (the per-bridge composition — NOT attempted; genuine new design, not a blocker)
`dual_isLocallyTrivial` and `homOfLocalCompat` are **not yet declarations** in the file —
they are referenced only in comments as the two bridges `exists_tensorObj_inverse` (sorry,
L2143) still needs. Wiring `overSliceSheafEquiv` into them is the next step, deferred here
deliberately (it is substantial new infrastructure design, and attempting it risks a NEW
sorry, which was FORBIDDEN this iter):
- **C-bridge `dual_isLocallyTrivial`** wants, contravariantly,
  `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)` for the open immersion
  `f : U ↪ X`. Under `overSliceSheafEquiv U` (value cat `A := ModuleCat _` / `AddCommGrp`),
  restricting the slice internal-hom `dual = internalHom(−, 𝟙_)` along `f` is transport
  across the sheaf-site equivalence; the residual reduces to the poset slice identity
  "`Over V` in `Opens ↥U` = `Over V` in `Opens X` for `V ≤ U`", naturality by
  `Subsingleton.elim`. Compose with the already-built module shadow
  `restrictScalarsRingIsoDualEquiv` (H2′).
- **A-bridge `homOfLocalCompat`** is the same transport at value cat `A := Type`, composed
  with the built `homMk` shadow.
- **Sizing flag (strategy-critic ts229 WATCH):** when composing, watch for
  `restrictScalars`/CommRingCat friction between the FIXED-value-category site equivalence
  and the per-bridge module transport — that is the 4th-growth signal to report. To
  formalize, the next prover must first read the dual/internalHom block (file L1602–2050)
  to fix the EXACT type `dual_isLocallyTrivial` should carry against `Scheme.Modules.dual`.

## Dead-end warnings (do NOT retry)
- Do NOT write the decls with a dotted declaration name (`def AlgebraicGeometry.Scheme.Modules.foo …`)
  — it re-opens the namespace for the body and the scheme-`Opens` shadow returns. Use a
  `namespace` block + `TopologicalSpace.Opens` type qualification.
- Do NOT reach for route (b) `IsDenseSubsite.sheafEquiv` — it is dominated by `sheafCongr`
  (needs an extra `IsEquivalence (sheafPushforwardContinuous)` instance for no benefit).
- Do NOT try to infer `IsCocontinuous`/`IsContinuous`/`IsDenseSubsite` for the
  `overEquivalence` functors directly — none of those instances fire; the content must be
  supplied by the pointwise `functorPushforward_mem_iff` (done).
