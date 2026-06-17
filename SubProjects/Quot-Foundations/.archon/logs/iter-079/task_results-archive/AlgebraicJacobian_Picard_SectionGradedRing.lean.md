# AlgebraicJacobian/Picard/SectionGradedRing.lean (iter-078, prover mode: prove)

## tensorObjAssoc (`cor:sheafTensorObjAssoc`, was L1604)

### Attempt 1
- **Approach:** The planner's three-segment composite, exactly as in the blueprint proof
  (chapter L1064–L1121): segment 1 = inverse of `asIso (sheafification.map (η_{a⊗b} ▷ c))`
  (iso by the closed crux `isIso_sheafification_whiskerRight_unit`); segment 2 =
  `sheafification.mapIso` of the presheaf associator; segment 3 = braiding-conjugated
  whiskered unit on the right factor (`β_{a,b⊗c}`-sheafified, then
  `asIso (sheafification.map (η_{b⊗c} ▷ a))`, then `β_{(b⊗c)^#,a}`-sheafified).
  All spelled with the carrier idioms (`MonoidalCategory.tensorObj (C := MonoidalPresheaf X)`,
  explicit unit `(PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app`).
- **Result:** PARTIAL — segment 1's `asIso` synthesized its `IsIso` instance from the `haveI`,
  but segment 3's *identical-shape* `asIso` FAILED instance synthesis
  ("failed to synthesize IsIso (sheafification.map (unit.app (b ⊗ c) ▷ a))") despite the
  `haveI` of exactly that type being in context. Cause appears to be metavariable-laden
  synthesis context inside the long `≪≫` chain, not a missing fact.
- **Dead end warning:** do NOT rely on instance synthesis for `asIso` deep inside a
  multi-segment `≪≫` term in this file — supply the instance explicitly.

### Attempt 2
- **Approach:** Same composite, but segment 3 passes the instance explicitly:
  `@asIso _ _ _ _ (sheafification.map (whiskerRight (unit.app (b⊗c)) a))
  (isIso_sheafification_whiskerRight_unit (b⊗c) a)`.
- **Result:** RESOLVED. Compiles; `lake build` clean; axioms = kernel-only
  (`propext`, `Classical.choice`, `Quot.sound`).
- **Key insight:** all the `restrictScalars (𝟙)`-vs-identity junctions (the unit's codomain
  functor is `forget ⋙ restrictScalars (𝟙 _)`, while `tensorObj` is written with
  `toPresheafOfModules X = forget`) unify definitionally — no `eqToIso` glue was needed
  anywhere in the chain.

## tensorPowAdd (`lem:sheafTensorPow_add`, was L1677)

### Attempt 1
- **Approach:** `match m` induction per blueprint (chapter L1182–L1218). Base `m = 0`:
  `tensorObjUnitIso (tensorPow L m') ≪≫ eqToIso (congrArg (tensorPow L) (Nat.zero_add m').symm)`.
  Step `m = k+1`: associator → step-(b) left-whiskered braiding → inverse associator →
  step-(d) right-whiskered IH → `eqToIso (congrArg (tensorPow L) (Nat.succ_add k m').symm)`.
  Whiskering done via two new private helpers (below). First version of
  `tensorObjWhiskerRightIso` used `MonoidalCategory.whiskerRightIso (C := MonoidalPresheaf X)
  ((toPresheafOfModules X).mapIso e) …` — FAILED with
  "failed to synthesize MonoidalCategory (MonoidalPresheaf X)", while the *left* helper with
  `whiskerLeftIso` succeeded. (Asymmetric instance-unification quirk: the iso-valued first
  explicit argument of `whiskerRightIso` carries the `X.PresheafOfModules` category instance,
  which the eager unifier won't reconcile with the `MonoidalPresheaf X` spelling.)
  Second version switched to a `where hom/inv` structure over the KNOWN-working morphism-level
  spelling `MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) ((toPresheafOfModules X).map
  e.hom) …`, with `rw [← Functor.map_comp, ← comp_whiskerRight, …]` for `hom_inv_id` —
  the structure typechecked but the positional `rw` FAILED pattern-matching
  (the documented Scheme-cat-diamond trap, exactly as PROGRESS warned).
- **Result:** FAILED at the two whisker-helper identity proofs.
- **Dead end:** `whiskerRightIso` with an iso argument typed in `X.PresheafOfModules`;
  positional `rw [← Functor.map_comp]` on goals under the diamond.

### Attempt 2
- **Approach:** Same `Iso.mk`-shaped helper, identity proofs rewritten as pure term-mode
  congruence chains (`Functor.map_comp … .symm.trans`, `congrArg`, `comp_whiskerRight`,
  `id_whiskerRight`, `Functor.map_id`) with every `𝟙 (P ⊗ Q)` spelled
  `𝟙 (MonoidalCategory.tensorObj (C := MonoidalPresheaf X) …)` per the carrier idioms.
- **Result:** RESOLVED. Compiles; axioms = kernel-only. Note `Nat.succ_add` (not `omega`)
  closes the step-(e) reindexing cleanly.
- Planner-flagged scaffold-comment corrections were applied: `(toPresheafOfModules X).obj L`
  (not `toPresheaf L`) as the whisker argument; step (b) built like step (d) via the
  braiding (no `isIso_sheafification_whiskerLeft_unit` needed — the `whiskerLeftIso` of the
  *presheaf lift of a sheaf-level iso* suffices, which is weaker than a whiskered-unit iso
  and avoids that gap entirely); `tensorObjAssoc` closed before `tensorPowAdd`.

## Hygiene done while in-file
- `unitModule` made **public** (removed `private`; name, type, body unchanged) — this is the
  PROGRESS "iter-078 ramp" pre-condition for `sectionsMul_assoc_unit`
  (`lem:sectionMul_coherent` is stated against the unit object). The blueprint pin
  `def:unitModule → AlgebraicGeometry.Scheme.Modules.unitModule` already exists, so this
  creates NO new coverage debt and needs no rename to "moduleUnit".
- Fixed the stale "Proof strategy" paragraph in the `ztensor_whisker_localIso` docstring
  (task_pending hygiene item: it described the dead stalk route; now describes the actual
  coequalizer + `W_domWhisker`/`W_tripWhisker` route).
- Updated the section header comment that claimed "Both bodies are `sorry`".

## Needs blueprint entry
- `AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerRightIso` (private, ~L1657) — sheaf-level
  right-whiskering of an iso: `F ≅ F' → F ⊗ G ≅ F' ⊗ G`, built as `Iso.mk` over
  `sheafification.map (whiskerRight ((toPresheafOfModules X).map e.hom/inv) _)` with
  term-mode congruence identity proofs. Uses: `sheafification`, `tensorObj`,
  `MonoidalCategory.comp_whiskerRight`, `MonoidalCategory.id_whiskerRight`.
  NOTE: `private`, so per the standing "do NOT write blocks for private decls" rule this may
  be exempt — but it is load-bearing in the `tensorPowAdd` proof; planner's call whether to
  blueprint it or leave it as the proof-level step (d) of `lem:sheafTensorPow_add`.
- `AlgebraicGeometry.Scheme.Modules.tensorObjWhiskerLeftIso` (private, ~L1695) — sheaf-level
  left-whiskering of an iso: `G ≅ G' → F ⊗ G ≅ F ⊗ G'`, via
  `sheafification.mapIso (whiskerLeftIso _ ((toPresheafOfModules X).mapIso e))`.
  Same private-decl caveat; it is proof-level step (b) of `lem:sheafTensorPow_add`.
- No other new declarations. `tensorObjAssoc` / `tensorPowAdd` already have blueprint blocks
  (`cor:sheafTensorObjAssoc`, `lem:sheafTensorPow_add`); both are now sorry-free, so the
  `sync_leanok` phase should mark their proof blocks automatically (I did not touch the .tex).

## Verification
- `lake build AlgebraicJacobian.Picard.SectionGradedRing`: SUCCESS (real cold-path build, not
  just LSP). `lake build AlgebraicJacobian` (root): SUCCESS.
- `lean_verify` on both new defs: axioms `propext, Classical.choice, Quot.sound` only.
- `grep -n sorry`: 0 code occurrences in the file (remaining hits are prose in comments).

## SNAP chain status / concrete next step
The file is now **sorry-free**. The SNAP chain through `tensorPowAdd` is closed axiom-clean.
Next per the iter-078 ramp: `sectionsMul_assoc_unit` (`lem:sectionMul_coherent`) — its
pre-condition (public `unitModule`) is now satisfied. I did NOT draft it: it is a brand-new
multi-part declaration (associativity of `sectionsMul` transported along `tensorObjAssoc` +
two-sided unitality of `1 ∈ Γ(X,𝒪_X)`), whose Lean statement design (triple-tensor section
carriers at `op ⊤`, transport spelling against the `asIso`-inverse inside `tensorObjAssoc`)
is the scaffolder/planner's next move per PROGRESS; planting a hasty signature would create
exactly the under-delivery debt PROGRESS warns about. Everything it consumes
(`sectionsMul`, `tensorObjAssoc`, `tensorPowAdd`, `tensorObjUnitIso`, public `unitModule`)
is now in place and axiom-clean.

Proof-engineering notes for that next lane (hard-won this session):
1. Instance synthesis inside long `≪≫` chains is flaky — pass `IsIso` facts via `@asIso _ _ _ _ f h`,
   not `haveI` + `asIso`.
2. `whiskerRightIso`/iso-valued arguments typed in `X.PresheafOfModules` break the
   `(C := MonoidalPresheaf X)` instance unification; morphism-level `whiskerRight` + `Iso.mk`
   works. (`whiskerLeftIso` happens to work because its first explicit arg is an object.)
3. The `restrictScalars (𝟙)` junctions in the sheafification-unit codomain are all
   transparent to defeq — compose freely, no `eqToIso` needed.

## Summary
- Sorry count: **2 → 0**.
- Closed: `tensorObjAssoc` (`cor:sheafTensorObjAssoc`), `tensorPowAdd` (`lem:sheafTensorPow_add`).
- Still open: none in this file.
- Adjacent work: no other sorries existed; did the three in-file hygiene items
  (public `unitModule` = the ramp pre-condition, stale docstring, stale section comment)
  instead. Did not pre-draft `sectionsMul_assoc_unit` (statement-design step assigned to the
  scaffolder; rationale above).

## Why I stopped
`Real progress`: closed both assigned sorries — `tensorObjAssoc` and `tensorPowAdd`
(2 → 0; file and full project build clean; both kernel-axiom-only). All approaches I
considered were attempted in code (two failed attempts documented above were each followed
by a working fix). Stopped because the file has zero remaining sorries and the next SNAP
declaration does not exist yet as a proof obligation in this file; its pre-condition
(public `unitModule`) was completed here so the next lane can start immediately.
