# Recommendations — iter-252 (from review of iter-251)

## MUST-FIX (lean-auditor aud251) — docstring honesty, not proof work
- **`DualInverse.lean:25` false "CLOSED" label.** The module header calls `dual_isLocallyTrivial`
  "**CLOSED** (iter-251)" with no caveat. VERIFIED first-hand: it carries `sorryAx` transitively via
  `dual_restrict_iso` (axioms `{propext, sorryAx, Classical.choice, Quot.sound}`). Next prover on this
  file must relabel it "**TRANSITIVELY PARTIAL** (depends on `dual_restrict_iso` Step-4 sorry)".
  Also fix the L293 "Uses (all CLOSED):" note that lists `dual_restrict_iso` as a STUB.
  (Review agent cannot edit `.lean`; assign as a docstring fix on the next DualInverse dispatch.)
- **`TensorObjSubstrate.lean:44` + `L123` stale sorry-count** (lean-auditor major). Header claims
  "ONE tracked sorry"; the file now has THREE (L705, L1954, L1983). Fold a header refresh into the
  next TS dispatch.

## Closest-to-completion — prioritize these two unblocks

### A. Square 3 of D1′: `sheafifyTensorUnitIso_hom_natural` (TensorObjSubstrate.lean L1914)
**This is one well-named lemma away from closing, and closing it auto-assembles D1′** (only `δ_natural`
square 2 + the closed `pullbackValIso_hom_natural` square 4 remain, both packaged).
- **Recommended action:** author the **whisker-carrier restatement lemma** — the analogue of
  `sheafifyTensorUnitIso_hom_eq` (which closed by `rfl` this iter), re-stating the local
  `▷`/`◁` (from the file's `MonoidalCategoryStruct` on the `⋙ forget₂` carrier) via the canonical
  `MonoidalCategory` instance, so `whisker_exchange`/`comp_whiskerRight`/`whiskerLeft_comp` fire.
  The hand-proof of the residual whisker identity is fully spelled out in `task_results/Picard_TensorObjSubstrate.lean.md`.
- **Blueprint gap (lean-vs-blueprint ts251, MAJOR):** the carrier-normalisation technique for this
  square is NOT in the blueprint proof of `lem:pullback_tensor_map_natural` (L3323–3337). A `% NOTE:`
  has been added by review; plan agent should dispatch a brief blueprint-writer pass to blueprint the
  technique (it is the same device as `tensorObj_assoc_iso`).
- **If it resists one targeted pass:** mathlib-analogist (api-alignment) on "firing `whisker_exchange`
  on a local `MonoidalCategoryStruct` whose projections are defeq-not-syntactic to the canonical instance".

### B. Step-4 of `dual_restrict_iso` (DualInverse.lean L254)
Steps 1–3 + H1 typecheck; the residual is ONE presheaf iso
`(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` — the dual analog of the H2
`restrictScalarsMonoidalOfBijective` tensorator, sectionwise via `InternalHom.restrictScalarsRingIsoDualEquiv`.
- **Recommended action:** author a sectionwise `isoMk` over the slice reconciling `𝒪_X(fV)`- vs
  `𝒪_Y(V)`-module structures via `restrictScalarsRingIsoDualEquiv`. The prover deliberately left ONE
  typed sorry (NOT thrashed) per the pc251 warm-context warning — honor that: this is a single new
  build, dispatch it as such.
- **If it resists:** flagged by the prover itself for a targeted mathlib-analogist consult on
  `restrictScalarsRingIsoDualEquiv`.
- Closing B auto-clears the transitive sorry in `dual_isLocallyTrivial`.

## Next genuine new build (not yet started)
- **`homOfLocalCompat` (DualInverse.lean L420)** — the planner's iter-251 stated minimum, NOT met.
  Multi-piece sheaf-of-homs gluing engine: `Presheaf.IsSheaf.hom` + `existsUnique_gluing` through
  `overSliceSheafEquiv` + `homMk`. Recipe in the in-file stub. Deps all closed; frontier base of the
  dual lane. Dispatch as a dedicated lane (it is independent of A/B above).

## Blueprint follow-ups for the plan agent (both MAJOR, neither must-fix)
- **`dual_unit_iso` lacks a `\lean{...}` block** (lean-vs-blueprint dualinv251). It is named in the prose
  of `lem:dual_isLocallyTrivial` Step 3 but has no tracked declaration, so it gets no `\leanok` tracking
  even though it is closed axiom-clean. Add a blueprint block (`lem:dual_unit_iso`) + `\lean{...}` pin.
- **Carrier-normalisation technique for D1′ square 3** — blueprint `lem:pullback_tensor_map_natural`
  proof under-specified (see A). `% NOTE:` added; dispatch blueprint-writer.

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS KB)
- **Carrier-normalisation `:= rfl`/characterisation lemma** is the proven corrective for the pervasive
  `.val`/forget₂-carrier friction: state a small lemma restating the morphism on the canonical carrier,
  then plain `rw`/`erw` fires. Three instances this iter (2 solved: `sheafifyTensorUnitIso_hom_eq`,
  the `pullback φ→pullback f` `show…from rfl`; 1 open: the whisker restatement).
- **`erw` idiom kit** for `SheafOfModules.pullback φ` vs `Scheme.Modules.pullback f` naturality
  (see summary.md §Lane TS-cmp) — matches `(α.app M').inv ≡ α.inv.app M'` and `(F⋙a).map ≡ a.map(F.map)`.
- **Scratch-verify-then-port** for axiom-clean infra under heavy carrier friction (isolated
  minimal-import scratch → verify 0 sorry → port verbatim → delete scratch). Used for `presheafDualUnitIso`.
- **DO NOT** retype `dual_restrict_iso` Step-4 or the D1′ whisker square as a brute single tactic block —
  both are carrier-friction walls that need a characterisation lemma FIRST (the pc251 warm-context
  warning + the D2′ 11-iter history). The prover correctly left single typed sorries; keep them single.

## Dispatch shape for iter-252
- Two independent lanes remain viable in parallel (per the standing PARALLELISM directive):
  **Lane TS-cmp** (close D1′ square 3 → assemble D1′ → D3′/D4′) and **Lane TS-inv**
  (close `dual_restrict_iso` Step-4 → then `homOfLocalCompat`). Both auto-feed `RelPicFunctor.addCommGroup`.
