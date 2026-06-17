# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (3, all axiom-clean):** `PresheafOfModules.restrictScalarsLaxε`,
  `PresheafOfModules.restrictScalarsLaxμ`, and the instance
  `PresheafOfModules.restrictScalarsLaxMonoidal`. All verify with
  `#axioms = {propext, Classical.choice, Quot.sound}` (kernel-only).
  This IS blueprint `lem:restrictscalars_laxmonoidal` — ready for `\leanok` /
  a `\lean{AlgebraicGeometry...}`... actually `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` pin.
- **Declarations blocked (0 new):** none added with sorry. The pre-existing 3 sorries
  (`tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)
  are UNCHANGED. No new sorry pins.
- **Sorry count: 3 → 3** (file remains GREEN, 0 errors, 0 axioms beyond kernel).

## restrictScalarsLaxMonoidal (the PRIMARY mathlib-build target) — RESOLVED
- **Approach:** sectionwise lift of `ModuleCat.instLaxMonoidalRestrictScalars`
  (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`). For
  `α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat`
  (`R S : Cᵒᵖ ⥤ CommRingCat`), ε/μ are assembled from the per-section
  `Functor.LaxMonoidal.ε/μ (ModuleCat.restrictScalars (α.app X).hom)`.
  - ε naturality: `ext r; dsimp; erw [PresheafOfModules.unit_map_one,
    ModuleCat.restrictScalars_η, ModuleCat.restrictScalars_η]; simp only [map_one];
    erw [PresheafOfModules.unit_map_one]`.
  - μ naturality: `refine ModuleCat.MonoidalCategory.tensor_ext (fun m₁ m₂ ↦ ?_); dsimp;
    erw [PresheafOfModules.Monoidal.tensorObj_map_tmul, ModuleCat.restrictScalars_μ_tmul,
    ModuleCat.restrictScalars_μ_tmul, PresheafOfModules.Monoidal.tensorObj_map_tmul]; rfl`.
  - coherence (μ_natural_left/right, associativity, left/right_unitality):
    `intro ...; ext1 Z; exact Functor.LaxMonoidal.<law>
    (F := ModuleCat.restrictScalars (α.app Z).hom) ...` — reduces each presheaf-level
    coherence to the already-proven ModuleCat-level one, sectionwise.
  - `set_option backward.isDefEq.respectTransparency false` needed (matches Mathlib's
    own `PresheafOfModules.Monoidal` setup).
- **Result:** RESOLVED — axiom-clean. Reusable Mathlib supplement.

## tensorObj_restrict_iso — NOT CLOSED (deeper structural blocker found)
- **Approach (blueprint/analogist δ-route):** comparison map = `δ` of
  `(pullbackPushforwardAdjunction φ).leftAdjointOplaxMonoidal`, hypothesis
  `(pushforward φ).LaxMonoidal` from `pushforward₀ Monoidal` + `restrictScalars` lax.
- **BLOCKER 1 (fatal for this route):** the scheme module ring presheaf is
  **`RingCat`-valued**, not `CommRingCat ⋙ forget₂`. Probed:
  `f.toRingCatSheafHom.hom : X.ringCatSheaf.obj ⟶ (...sheafPushforwardContinuous...).obj
  Y.ringCatSheaf.obj` (RingCat). `inferInstance` for
  `MonoidalCategory (PresheafOfModules ((sheafToPresheaf _).obj Y.ringCatSheaf))` **FAILS** —
  there is no monoidal structure on `PresheafOfModules X.ringCatSheaf.obj`, so
  `(pushforward φ.hom).LaxMonoidal` / the `δ` cannot even be stated there. The file's
  Steps 1–2 (`restrictFunctorIsoPullback` + `sheafificationCompPullback`) deposit the
  residual at exactly this RingCat-level `PresheafOfModules.pullback f.toRingCatSheafHom.hom`.
  Meanwhile `tensorObj` itself uses the *CommRingCat* presheaf `X.presheaf` (≠ `X.ringCatSheaf.obj`).
  The δ-route and the `tensorObj` definition live at different ring layers.
- **BLOCKER 2:** even at the CommRingCat level, `pushforward φ` (needs codomain
  `F.op ⋙ ?R`, F.op outermost) and `restrictScalarsLaxMonoidal` (needs `?S ⋙ forget₂`,
  forget₂ outermost) **cannot be composed by instance resolution** — associativity of
  `⋙` vs `forget₂` gives no syntactic match. I built a `pushforwardLaxMonoidal` instance
  attempting this and it would not typecheck (`pushforward φ` application mismatch);
  REMOVED it (no new sorry, no dead code left).
- **Conclusion:** the analogist mate207 "sole project-side gap = one restrictScalars
  lax instance" claim is **incorrect**. The lax instance is built, but it does not
  unblock `tensorObj_restrict_iso` as the proof is currently structured.

## Next step (precise handoff for planner)
The remaining work is multi-step, NOT one instance. Choose one:
- **(a)** Restructure `tensorObj_restrict_iso` so Steps 1–2 stay at the `X.presheaf`
  (CommRingCat) layer where `PresheafOfModules.Monoidal` and the δ machinery live,
  then bridge to sheafification at the end. `restrictScalarsLaxMonoidal` feeds this.
- **(b)** Add line-bundle hypotheses `(hM : LineBundle.IsLocallyTrivial M) (hN : ...)`
  to `tensorObj_restrict_iso` (the consumer `tensorObj_isLocallyTrivial` already has
  `hM hN` in scope and can pass them; `tensorObj_restrict_iso` is NOT in
  `archon-protected.yaml`), then prove the iso directly sectionwise via
  `Scheme.Modules.Hom.isIso_iff_isIso_app` using free-rank-one trivialisations.
- **(c)** Build a CommRingCat-level `(PresheafOfModules.pullback φ).Monoidal` (strong,
  μIso from sectionwise `ModuleCat.extendScalars.Monoidal`), then the comparison is its
  `μ`/`δ` iso directly — but this still needs the RingCat↔CommRingCat bridge of (a).

## Blueprint markers (for review agent)
- `lem:restrictscalars_laxmonoidal`: now formalized as
  `PresheafOfModules.restrictScalarsLaxMonoidal` (axiom-clean). Recommend adding
  `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` and letting `sync_leanok` mark it.
- `lem:tensorobj_restrict_iso`: still sorry; the chapter's claim that the δ-route is
  "one small instance away" should be annotated `% NOTE:` per BLOCKER 1 above
  (RingCat-valued scheme ring presheaf has no monoidal structure).

## Why I stopped
- **Real progress:** 3 axiom-clean declarations added — `restrictScalarsLaxε`,
  `restrictScalarsLaxμ`, `restrictScalarsLaxMonoidal` (the file's new
  `## Project-local Mathlib supplement — restrictScalars is lax monoidal` section,
  ~lines 95–176). This is the blueprint's `lem:restrictscalars_laxmonoidal` and the
  stated PRIMARY mathlib-build target.
- **Blocked — alternatives exhausted** on closing `tensorObj_restrict_iso`: the δ-route
  is structurally blocked by the RingCat-valued scheme ring presheaf (BLOCKER 1, probed)
  and the associativity composition wall (BLOCKER 2, attempted+removed). No informal
  agent available (key returns HTTP 401, per memory). Closing it requires a structural
  re-route (options a/b/c above), which is a planner decision, not a one-instance fill.
- File is GREEN, sorry count unchanged (3→3), no regression, no new sorry pins.
