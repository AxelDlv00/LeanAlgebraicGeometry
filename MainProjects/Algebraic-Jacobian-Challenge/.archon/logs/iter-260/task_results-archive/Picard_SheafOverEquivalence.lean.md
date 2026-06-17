# Picard/SheafOverEquivalence.lean

## Summary
- **Sorry count: 2 → 0.** Both assigned sorries CLOSED, axiom-clean (kernel axioms only:
  `propext`, `Classical.choice`, `Quot.sound`; verified via `lean_verify`).
- Closed: `AlgebraicGeometry.Scheme.Modules.unitOverIso`,
  `AlgebraicGeometry.Scheme.Modules.restrictOverIso`.
- `chartOverIso` (the engine/dual consumer, sorry-transitive through the two above) is now
  FULLY axiom-clean (verified). The whole `SheafOverEquivalence.lean` file is sorry-free.
- My file compiles cleanly in the full `lake build` (NOT in the failure list). The build's only
  failures are in `TensorObjSubstrate.lean` (D3′ lane, another prover's concurrent WIP, lines
  2290/2294) — import-independent of my file (mine imports only `TensorObjSubstrate.Vestigial`).

## unitOverIso (line ~249)
### Attempt 1 — RESOLVED
- **Approach:** The reflection chain (`forget`→`toPresheaf`→`NatTrans.isIso_iff_isIso_app`) and
  the construction `(asIso (unitToPushforwardObjUnit (phiOver U))).symm` were already in place; only
  the sectionwise leaf `IsIso ((toPresheaf.map (forget.map (unitToPushforwardObjUnit (phiOver U)))).app W)`
  remained.
- **Key steps:**
  - `IsIso (phiOver U).hom` is NOT directly `inferInstance`. Proved it app-wise mirroring the
    in-proof `hmap` block: `rw [NatTrans.isIso_iff_isIso_app]; intro V; exact inferInstanceAs (IsIso
    (X.ringCatSheaf.obj.map (eqToHom (image_overEquiv_functor_obj U V.unop)).op))`.
  - Then `haveI happ : IsIso ((phiOver U).hom.app W) := inferInstance` (app of an iso NatTrans).
  - The goal map is **definitionally** `(forget₂ RingCat AddCommGrpCat).map ((phiOver U).hom.app W)`,
    so `change IsIso ((forget₂ RingCat AddCommGrpCat).map ((phiOver U).hom.app W)); infer_instance`
    closes it (functor preserves iso). This is the concrete realization of
    `unitToPushforwardObjUnit_val_app_apply`.
- **Dead end logged:** `IsIso ((phiOver U).hom.app W)` / `IsIso (phiOver U).hom` are NOT
  `inferInstance`-able directly; must be derived app-wise from the `eqToHom`-image structure.

## restrictOverIso (line ~233, full body, ~50 LOC)
### Attempt 1 — RESOLVED (verbatim mirror of `restrictFunctorAdjCounitIso`)
- **Approach:** `M.restrict U.ι = (pushforward (psiRestrict U)).obj M` (psiRestrict reconstructed
  verbatim from `restrictFunctor`'s internals; `restrictFunctor U.ι = pushforward (psiRestrict U)`
  by rfl). The functor of `(overEquivalence U).functor` is `pushforward (phiOver U)` (rfl). The
  three-step composite, applied at `M`:
  1. `(pushforwardComp (phiOver U) (psiRestrict U)).app M` — merges the two pushforwards into
     `pushforward γ` along `e.functor ⋙ U.ι.opensFunctor`.
  2. `(pushforwardNatIso _ (overForgetNatIso U)).app M` — switches the index functor to
     `Over.forget U` via the `eqToIso` natural iso `overForgetNatIso : Over.forget U ≅
     e.functor ⋙ U.ι.opensFunctor` (both send `V ↦ V.left`; built from `image_overEquiv_functor_obj`).
  3. `(pushforwardCongr (γ' = 𝟙 _)).app M` — reconciles the composite ring morphism to `𝟙`, landing
     on `pushforward (𝟙 _) = SheafOfModules.over M U`.
- **The `γ' = 𝟙` equation** (the only real content) proved sectionwise: `ext V x;
  simp [phiOver, psiRestrict, overForgetNatIso]` reduces to a composite of two mutually-inverse
  `eqToHom`-image ring maps with a `𝟙` in the middle (the `appIso` round-trip collapses to `𝟙`),
  then `erw [ConcreteCategory.id_apply, ← ConcreteCategory.comp_apply, ← Functor.map_comp]; simp`.

### Key obstacles & fixes (REUSABLE)
- **Continuity discrim-tree wall:** `pushforwardComp`/`pushforwardNatIso`/`isContinuous_comp` need
  `(U.ι.opensFunctor).IsContinuous (gt ↥(↑U:Scheme)) (gt ↥X)` and the composite continuity. Mathlib's
  instance IS findable by *direct* `inferInstance` (it keys the scheme-carrier `↥↑U` form) but NOT by
  *nested* typeclass search (transparency mismatch). A global `instance := inferInstance` registers
  under the reduced `↥U` key and is invisible to nested search; a `by change ↥U; infer_instance`
  global instance fails to compile (the subtype form is NOT the findable one for `opensFunctor`).
  **FIX that worked: `set_option backward.isDefEq.respectTransparency false in` on the def** — this
  lets nested search match the local `haveI hF1/hF2/hcomp` instances. The composite continuity
  `hcomp` is still supplied explicitly via `@Functor.isContinuous_comp _ _ _ _ _ _ … hF1 hF2`
  (passing the instance args by `@` to bypass the broken nested search), with topology K pinned to
  `Opens.grothendieckTopology ↥(↑U : Scheme)`.
- **`pushforwardComp (phiOver U) ?ψ` with a metavariable ψ → `whnf` heartbeat timeout.** Must supply
  `psiRestrict U` explicitly (reconstruct `restrictFunctor`'s internal ring morphism verbatim; the
  `letI α : (↑U).presheaf ⟶ U.ι.opensFunctor.op ⋙ X.presheaf := { app := fun W => (U.ι.appIso
  W.unop).inv }` + `⟨Functor.whiskerRight α (forget₂ CommRingCat RingCat)⟩` shape; `restrictFunctor
  U.ι = pushforward (psiRestrict U)` holds by rfl).
- **`erw` over `ConcreteCategory.id_apply`/`comp_apply`:** the section goal displays morphism
  application as `CommRingCat.Hom.hom f y`, but the apply lemmas are stated with
  `ConcreteCategory.hom`; plain `rw` fails to match, `erw` (defeq) succeeds.

## Blueprint markers ready (for review/sync agent)
- `def:sheafofmodules_over_equivalence` (`overEquivalence`) — already \leanok (iter-258).
- `lem:sheafofmodules_restrict_over_iso` (`restrictOverIso`) — READY for \leanok (proof closed).
- `lem:sheafofmodules_unit_over_iso` (`unitOverIso`) — READY for \leanok (proof closed).
- `lem:chart_over_iso` (`chartOverIso`) — READY for \leanok (now fully axiom-clean).

## New private helpers added (in-file, reusable)
- `psiRestrict` — the `restrictFunctor U.ι` ring morphism, reconstructed (rfl-equal to it).
- `restrictFunctor_eq_pushforward_psiRestrict` — the rfl lemma.
- `overForgetNatIso : Over.forget U ≅ e.functor ⋙ U.ι.opensFunctor` (eqToIso, thin naturality).

## Why I stopped
**Real progress: closed 2 sorries (2 → 0).** `unitOverIso` and `restrictOverIso`, both axiom-clean
and compiling in the full build. `chartOverIso` is now fully axiom-clean as a consequence. This was
the entire assigned objective (Lane 1, the SHARED ROOT). The A.2.c engine
(`LineBundleCoherence.lean`, locally sorry-free) becomes fully axiom-clean with no further edits, and
the dual `sliceDualTransport` is unblocked as a one-liner consumer next iter (DualInverse re-open).
D3′ (`TensorObjSubstrate.lean`) is the *other* prover's file (Lane 2) — not touched; its concurrent
build errors are independent of my file.
