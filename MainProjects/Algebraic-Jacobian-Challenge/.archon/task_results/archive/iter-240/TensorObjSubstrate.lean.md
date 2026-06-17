# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (2, both axiom-clean — `{propext, Classical.choice, Quot.sound}`):**
  - `AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp` (~L880) — pushforward-side
    (right-adjoint) composition coherence of the unit comparison.
  - `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` (~L930) — **THE genuinely-new
    ingredient** for Phase 1 (`lem:pullback_unit_iso`): the *pullback-side* composition coherence
    `pbu(h≫f) = (pullbackComp h f).inv ≫ (pullback h).map(pbu f) ≫ pbu h`, obtained by
    adjunction-mate transport. Mathlib-absent at the pinned commit; not a sectionwise statement.
- **Declarations blocked (2):** `isIso_restrict_pullbackObjUnitToUnit` + `pullbackUnitIso`
  (Phase 1 deliverable) — full recipe worked out and correct; blocked on a Lean
  instance-synthesis quirk (NOT math). Recipe + precise blocker recorded in a HANDOFF comment in
  the `.lean` file (just below `pullbackObjUnitToUnit_comp`) and below.
- **Sorry count (this file): 2 → 2** (unchanged). The two remaining sorries are the pre-existing
  DEFERRED dual-bridge sorries `exists_tensorObj_inverse` (L693) and `addCommGroup_via_tensorObj`
  (L1181), both explicitly off-limits this iter. My work ADDS infrastructure (no new sorry).
- Not touched: Phase 2 (`pullbackTensorIso`), Phase 3 (`IsInvertible.pullback`), the group-law
  section, `sheafifyTensorUnitIso`.

## `unitToPushforwardObjUnit_comp` — RESOLVED (axiom-clean)
- **Approach:** sectionwise. `SheafOfModules.Hom.ext` → `PresheafOfModules.hom_ext` →
  `ModuleCat.hom_ext` → `LinearMap.ext` → `rfl`. The pushforward unit comparison is sectionwise
  just the structure-sheaf ring map (`unitToPushforwardObjUnit_val_app_apply`), so composition
  coherence is definitional after the ext chain.
- **Result:** RESOLVED.

## `pullbackObjUnitToUnit_comp` — RESOLVED (axiom-clean) — the hard linchpin
- **Approach (adjunction-mate transport, ~70 lines):**
  1. `apply (pullbackPushforwardAdjunction (h≫f)).homEquiv.injective`; rewrite the LHS adjunct to
     `unitToPushforwardObjUnit (h≫f)` (`pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`)
     then to the composite via `unitToPushforwardObjUnit_comp` (= `key`).
  2. `conj := unit_conjugateEquiv …` + `Scheme.Modules.conjugateEquiv_pullbackComp_inv` packages the
     mate identity relating `(pullbackComp h f).inv` to `(pushforwardComp h f).hom`.
  3. Peel the RHS adjunct with `Adjunction.homEquiv_naturality_right`; rewrite the `homEquiv(i.inv)`
     factor by `hi` (= `homEquiv_unit` ∘ `conj`); collapse the composite-adjunction unit via two
     sub-lemmas `hinner`/`hcomp'` (each proved with `Adjunction.homEquiv_unit` +
     `homEquiv_naturality_left/right` + the per-factor `homEquiv ↦ unitToPushforwardObjUnit` facts
     `hLf`/`hLh` + `Adjunction.comp_unit_app`), then slide `(pushforwardComp h f).hom` past via its
     `NatTrans.naturality`.
- **CRITICAL tactic recipe (reusable):** the `SheafOfModules R` category compositions appear in
  **defeq-but-not-syntactic** forms (`Scheme.Modules.pullback f` vs
  `SheafOfModules.pullback f.toRingCatSheafHom`), so plain `rw [Category.assoc]`,
  `rw [Functor.map_comp]`, `rw [pullbackObjUnitToUnit_comp …]`, `rw [hinner/hcomp']` **silently
  fail to unify** (report "pattern not found" / "no progress" even though the goal visibly matches).
  **Use `erw` for every associativity / functoriality / hinner / hcomp' rewrite.** Bridge the
  `homEquiv_unit` ↔ `G.map` higher-order-matching failure with explicit
  `e := Adjunction.homEquiv_unit (adj := …) (X := …) (Y := …) (f := …)` then `e.symm.trans …`
  (defeq-tolerant `exact`), never `rw [← Adjunction.homEquiv_unit]` (its `?adj`/`G.map` HO pattern
  does not fire). Restate the `…_homEquiv_pullbackObjUnitToUnit`/conjugate facts in
  `Scheme.Modules.pullbackPushforwardAdjunction …` form via `have h : … := by exact <SheafOfModules
  lemma>` so later `rw`s match the goal's namespace-short forms.
- **Result:** RESOLVED, axiom-clean.

## `isIso_restrict_pullbackObjUnitToUnit` + `pullbackUnitIso` — NOT ADDED (instance-synthesis blocker)
- **Approach (fully worked out, correct):** see the HANDOFF comment in the `.lean` file. Per-chart:
  `g := f.resLE U V`, `g ≫ U.ι = V.ι ≫ f`; the three `Opens.map _.base` are `Final`
  (`final_of_representablyFlat`) so `pbu g`, `pbu V.ι`, `pbu U.ι` are isos; `pbu(V.ι≫f)` is an iso
  via `rw [← hg, pullbackObjUnitToUnit_comp g U.ι]` (composite of isos); transport across
  `restrictFunctorIsoPullback V.ι` (`NatIso.isIso_map_iff`) and `pullbackObjUnitToUnit_comp V.ι f`
  (`▸`), then `IsIso.of_isIso_comp_left/right` cancel. Globalizer: two
  `exists_isAffineOpen_mem_and_subset` calls per point → `choose` → `isIso_of_isIso_restrict` →
  `asIso`. The math/structure is COMPLETE and the `▸`/`of_isIso_comp_*`/`choose`/globalizer parts
  typecheck.
- **THE BLOCKER (verified):** inside the per-chart lemma's multi-hypothesis context,
  `infer_instance` FAILS to synthesise `IsIso (pbu U.ι)`, `IsIso (pbu g)`, and even
  `IsIso ((pullbackComp g U.ι).inv.app _)` — all of which synthesise FINE STANDALONE (verified via
  `lean_run_code`). Cause: `SheafOfModules.pullbackObjUnitToUnit φ` carries non-canonical implicit
  instance args (`[(pushforward φ).IsRightAdjoint]`, `[F.IsContinuous]`); after
  `rw [pullbackObjUnitToUnit_comp …]` the produced `pbu`/`pullbackComp` subterms bind those
  implicits to forms the in-scope `(Opens.map _).Final` haveIs + the `OfFinal` instance no longer
  match, and a pre-established `haveI` copy matches the head but fails unification (blocking
  backtracking). Confirmed NOT caused by `set`/`let` (inlining `f.resLE U V hVU` does not help);
  tried `clear_value` (breaks the resLE `Final`), `asIso`/`mapIso` explicit construction (same
  failure, under-determined implicits in the compound expr), and
  `refine @IsIso.comp_isIso … ?_ ?_ ?_` (each subgoal's `infer_instance` still fails).
- **NEXT-ITER FIX (recommended, in order):**
  1. Build each component iso as a fully type-ascribed named `Iso` BEFORE the
     `pullbackObjUnitToUnit_comp` rewrite, then `convert`/transport `IsIso` across the coherence
     equation (pins implicits by ascription, no re-synthesis).
  2. Or add a `@[instance] lemma isIso_pullbackObjUnitToUnit_of_final` with the canonical implicit
     shape and apply it `@`-explicitly at each site.
  3. Or `mathlib-analogist` consult on `SheafOfModules.pullbackObjUnitToUnit` instance canonicity.
  This is pure instance plumbing; once cleared, `pullbackUnitIso` lands and Phase 1 closes. Phase 2
  (`pullbackTensorIso`, pointwise) + Phase 3 (`IsInvertible.pullback`, easy composite) remain.

## Blueprint markers (for the review agent)
- `lem:pullback_unit_iso` proof: now has its **hard linchpin** `pullbackObjUnitToUnit_comp` landed
  (the "genuinely-new ingredient" the chapter calls out); the chapter could note the composition
  coherence as an explicit pinned sub-lemma. Two NEW pinnable decls:
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` and
  `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}`. `pullbackUnitIso` itself
  is NOT yet formalized (blocked) — do not mark `\leanok`.

## Why I stopped
Real progress: **2 axiom-clean declarations** — `unitToPushforwardObjUnit_comp` and the hard
linchpin `pullbackObjUnitToUnit_comp` (the blueprint's named "genuinely-new ingredient" for
Phase 1). Partial on `pullbackUnitIso`: full correct recipe + per-chart lemma written, blocked on a
precisely-characterised `pbu` instance-synthesis canonicity issue (works standalone, fails in
context) — NOT a mathematical gap. Removed the blocked decls to keep the file compiling clean
(only the 2 pre-existing deferred sorries remain). The instance fix is a contained next-iter task
(recipe above); Phase 2/3 remain.
