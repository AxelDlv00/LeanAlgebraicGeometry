# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (1, axiom-clean):** `AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict`
  (the **B-connector** of the d.2-free descent re-route), lines ~1936–1972.
- **Declarations blocked (0 new sorries):** none added with sorry. The two remaining bridges
  (A-bridge, C) were NOT added — they are genuine multi-iteration builds; handed off precisely
  below rather than pinned as sorries (per plan directive "do NOT pin a sorry into a NEW decl").
- **Sorry count (this file):** before = 3 (L609 vestigial d.2; `exists_tensorObj_inverse`;
  `addCommGroup_via_tensorObj`) → after = 3 (unchanged; B-connector is sorry-free).
- **Ride-along done:** refreshed the stale comment in the `exists_tensorObj_inverse` sorry body
  (now describes the d.2-free descent plan + the landed B-connector, replacing the obsolete
  "dual is absent" text).
- Build is GREEN (no errors); only pre-existing deprecation/long-line/`sorry` warnings remain.

## `isIso_of_isIso_restrict` (B-connector) — RESOLVED, axiom-clean
- **Statement:** for `φ : M ⟶ N` in `X.Modules`, a choice function `U : X → X.Opens` with
  `∀ x, x ∈ U x` and `∀ x, IsIso ((Scheme.Modules.restrictFunctor (U x).ι).map φ)`, then `IsIso φ`.
  (This is exactly the form `LineBundle.IsLocallyTrivial` supplies via choice, so the assembly
  can feed it directly.)
- **Approach (worked first serious try):** stalkwise. For each `x`, pick a preimage point
  `x' : ↥(U x)` of `x` under the open immersion `(U x).ι` (via `Scheme.Hom.mem_opensRange` +
  `Scheme.Opens.opensRange_ι`). The restriction `(restrictFunctor (U x).ι).map φ` is iso (hyp),
  so a functor sends it to an iso; transport across `Scheme.Modules.restrictStalkNatIso (U x).ι x'`
  (restriction commutes with stalks) via `CategoryTheory.NatIso.isIso_map_iff` to deduce that the
  stalk-at-`x` map of `(Scheme.Modules.toPresheaf X).map φ` is iso. Package `M.presheaf`/`N.presheaf`
  as `TopCat.Sheaf Ab.{u} X` (sheaf condition = `M.isSheaf`), apply
  `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`, then reflect back to `X.Modules` via
  `Scheme.Modules.toPresheaf` (`ReflectsIsomorphisms`).
- **Result:** RESOLVED — `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- **Key API gotchas (for reuse):**
  - `Ab` needs explicit universe `Ab.{u}` everywhere (else `stalkFunctor` lands at universe 0 and
    mismatches `toPresheaf X`'s `TopCat.Presheaf Ab.{u} X`).
  - `Functor.map_isIso` is NOT an instance through a triple composite; close `IsIso ((A⋙B⋙C).map φ)`
    with `dsimp only [Functor.comp_map]; exact Functor.map_isIso _ _`.
  - `TopCat.Sheaf` hom is an induced-category hom with field `.hom` (NOT `.val`): use `fS.hom`.
  - `NatIso.isIso_map_iff (e : F₁ ≅ F₂) (f) : IsIso (F₁.map f) ↔ IsIso (F₂.map f)` is the clean
    transport (avoids manual naturality/inv bookkeeping).
- **Blueprint:** new decl, not yet `\lean{}`-pinned. Plan agent: add a `lem:...` block for
  `AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict` (the "locally-iso ⇒ iso" B-bridge) so
  `sync_leanok` can track it.

## `dual_isLocallyTrivial` (bridge C) — NOT ADDED (handoff)
- **Needed:** `IsLocallyTrivial L → IsLocallyTrivial (dual L)`. On a trivialising open `U`
  (`L.restrict U.ι ≅ 𝒪_U`), want `(dual L).restrict U.ι ≅ 𝒪_U`.
- **Crux (C1):** `(dual M).restrict f ≅ dual (M.restrict f)` for an open immersion `f` — the dual
  analogue of the CLOSED `tensorObj_restrict_iso` (L1822). Mirror its 4-step composite
  (`restrictFunctorIsoPullback` → `sheafificationCompPullback` → strip sheafification → presheaf
  residual). **The hard part is the presheaf step:** `(PresheafOfModules.pullback φ).obj
  (PresheafOfModules.dual A) ≅ PresheafOfModules.dual ((pullback φ).obj A)`, i.e. `restrictScalars`
  along the open-immersion ring iso commutes with the **bespoke** presheaf `dual` (= `internalHom(-,R)`,
  built iters 219–224 in this file). This needs lemmas relating `restrictScalars`/`pushforward β`
  to `internalHom`/`restrictionMap` section-by-section, using
  `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (`ChangeOfRings.lean:285`, additive `:325` +
  linear `:335`) to carry `Hom(-,-)` across the ring iso. This is a major mirror build (the bespoke
  dual was assembled over many iters); not attempted this iter.
- **Plus (C2):** `dual (𝒪_U) ≅ 𝒪_U` (dual of the structure sheaf is itself) at the sheaf level.

## A-bridge (SheafOfModules morphism descent) — NOT ADDED (handoff)
- **Needed:** glue compatible local morphisms (here: the canonical local trivialising isos
  `eᵢ : (L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}`) into a global `g : tensorObj L (dual L) ⟶ 𝒪_X` whose
  restriction to each `Uᵢ` is `eᵢ.hom`. Then `isIso_of_isIso_restrict` (landed) finishes `IsIso g`.
- **Route (analogist ts226descent):** forget to the underlying ab-sheaf via `SheafOfModules.toSheaf`,
  glue with `CategoryTheory.Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv`
  (`Sites/SheafHom.lean:207,241`), then promote to `𝒪_X`-linear with `PresheafOfModules.homMk`
  (`Presheaf.lean:200`; R-linearity is a sectionwise equation, holds globally once on the cover).
- **Difficulty:** moderate-to-hard (~30–60 LOC). `sheafHomSectionsEquiv` works over the `Over X`
  category at the level of `Sheaf J (Type _)`; building the compatible family + the **overlap-cocycle
  agreement** of the `eᵢ` is the bounded-but-real content (NOT d.2). Not attempted this iter to avoid
  risking a sorry.

## Why I stopped — `Real progress`
- **1 axiom-clean declaration added:** `AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict`
  (lines ~1936–1972), the cheapest of the three descent bridges (B), verified
  `{propext, Classical.choice, Quot.sound}`. It is the reusable "locally-iso ⇒ iso" supplement the
  assembly's final step consumes, and is directly in the form `IsLocallyTrivial` provides.
- The two remaining bridges (A morphism-descent, C dual-vs-restriction) are each genuine
  multi-iteration builds (C in particular mirrors the hard `tensorObj_restrict_iso` for the bespoke
  presheaf dual). Per the plan's explicit instruction, I handed off their precise next steps rather
  than pin a sorry into a new declaration. The B-connector is permanent forward progress and unblocks
  the final contraction once A + C land. No approach was identified-but-unattempted for B; for A/C the
  routes are scoped above and are the next iter's work.

## Self-review
1. Attempted every approach written in a comment? Yes for B (built it). A/C are scoped handoffs, not
   abandoned in-progress attempts.
2. Adjacent decls attempted with new infra? The adjacent pieces (A, C) are the handoff targets; both
   are large standalone builds, not quick wins reachable from B alone.
3. Informal agent / key: not needed — B was closed directly against Mathlib.
4. Skipped approach? No skipped tractable approach for B.
