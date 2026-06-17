# Picard/TensorObjSubstrate/DualInverse.lean — iter-254 (Lane TS-inv)

Sorry count: **2 → 2** (declaration-level), but the structure is materially advanced:
`homOfLocalCompat` went from **2 internal sorries → 1**, with sub-step (a) fully closed and
sub-step (c) ~90% built. File compiles green (verified `lake build AlgebraicJacobian`, 8367 jobs).

## STEP A — `homOfLocalCompat` (re-sign `hf` + close)

### Re-sign `hf` (DONE)
Per objectives + memory [[ts254-homoflocalcompat-not-protected]]: `homOfLocalCompat` is NOT in
`archon-protected.yaml` and has no compiling caller, so I re-signed its `hf` hypothesis from the
unsatisfiable `HEq` form to the **sectionwise** form:
```
hf : ∀ (i j : ι) (V : X.Opens) (hVi : V ≤ U i) (hVj : V ≤ U j),
    M.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi).symm)) ≫
      ((PresheafOfModules.toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ V)) ≫
        N.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi)))
      = … (same with j) …
```
i.e. the two `f i`/`f j` section maps agree, conjugated into the fixed group `M(V) ⟶ N(V)`.
Added a small helper `image_preimage_of_le` (the down-set identity `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`).
Updated the docstring (was contradicting the body, aud253 major #3).

### Sub-step (a) `IsCompatible` — **CLOSED**
After the iter-253 reduction (`presheafHom_map_app` ×2 + `simp only [homLocalSection]`), the goal is
exactly the sectionwise equation; closes by
`exact hf i j W.left (W.hom.le.trans inf_le_left) (W.hom.le.trans inf_le_right)`
(the `eqToHom`-conjugations and `(Over.mk (W.hom ≫ infLE_)).left ≡ W.left` match by **definitional
proof irrelevance** / defeq — no `Subsingleton.elim` needed for the section maps).

### Sub-step (c) `𝒪_X`-linearity `hg` — **reduced to one isolated ring-bridge sorry**
Built and verified (all compiling):
1. **Separatedness reduction** via `TopCat.Presheaf.IsSheaf.section_ext` (point-based): pick the cover
   member `U i ∋ x`, neighbourhood `W := V.unop ⊓ U i`.
2. **Naturality + `map_smul` reduction**: `erw [← NatTrans.naturality_apply g …, map_smul M.val …,
   map_smul N.val …, ← NatTrans.naturality_apply g …]` reduces the global linearity at `V` to local
   linearity of `g.app (op W)` at `W ≤ U i`.
3. **Connection lemma `hconn`** (the hard transport + gluing piece — fully proved): for `W' ≤ U i`,
   `g.app (op W') = (homLocalSection U f i).app (op (Over.mk (homOfLE _)))`. Proof: unfold `g` via
   `topSectionToHom_app`; transport `hsup ▸ s₀` to `H.obj.map (eqToHom …)` via a generic `subst`
   helper `htr`; rewrite `eqToHom (congrArg op hsup) = (eqToHom hsup.symm).op` by `Subsingleton.elim`
   (thin poset `(Opens X)ᵒᵖ`); apply `presheafHom_map_app` twice (once for the `hsup`-transport, once
   for the `IsGluing` datum `_hs`); identify the two `W' ⟶ iSup U` slice morphisms by
   `Subsingleton.elim`.
4. **Composite decomposition + M-leg `map_smul`**: `erw [ConcreteCategory.comp_apply ×4,
   PresheafOfModules.map_smul]` decomposes the triple composite
   `M.map (eqToHom e₁) ≫ (f i).val.app P ≫ N.map (eqToHom e₂)` and pushes the scalar through the M-leg.
   (Note: `rw`/`simp` with `comp_apply` do NOT fire — must use **`erw`** for the wrapped
   `AddCommGrpCat.Hom.hom`.)

**Remaining (the single sorry at ~L636 inside `homOfLocalCompat`):** the genuine open-immersion
**ring-bridge**. The inner leg `((toPresheaf _).map (f i).val).app (op P)` is, at the `Ab` level,
only additive; its linearity over `(U i).ringCatSheaf(P)` must be reinterpreted at the `(U i)`
`ModuleCat` level. The open immersion identifies `(U i).ringCatSheaf(P) ≅ X.ringCatSheaf((U i).ι ''ᵁ P)`
via the structure-ring iso `((U i).ι.appIso P)`, through which `restrictFunctor (U i).ι` defines the
`(U i)`-module structure on `M.restrict (U i).ι` as `restrictScalars` along `((U i).ι.appIso P).inv`
(`Mathlib.AlgebraicGeometry.Modules.Sheaf.restrictFunctor`). The route (each ingredient confirmed to
exist):
- `((pushforward φ).obj X).obj X₁ = (restrictScalars (φ.app X₁)).obj …` (`PresheafOfModules.pushforward_obj_obj`),
  and `restrictScalars` smul is **`rfl`** (`r •_restrict x = (g r) •_orig x`, verified in scratch).
- So `r₂ •_X z₂ = (appIso.hom r₂) •_{Ui} z₂` (via `appIso.inv_hom` + the `rfl`).
- `(f i).val.app (op P)` is `(U i)`-linear (`map_smul` of the `ModuleCat` morphism), giving
  `(f i).app (s •_{Ui} z) = s •_{Ui} (f i).app z`.
- Transport back + the N-leg `map_smul` + scalar reconciliation (`X.ring.map (eqToHom e₁)`,
  `X.ring.map (eqToHom e₂)` compose back to `id` on `W` since `e₂ = e₁.symm`).

This is the historically-hard **carrier-duality** wall (RingCat `(U i)` vs `X` action on the same
defeq carrier; see the d.2/restrictScalars memories). It is now maximally isolated: everything around
it (separatedness, naturality, gluing transport, decomposition, M-leg) is proved.

## STEP B — `dual_restrict_iso` Step-4 (~L256)
**NOT entered.** Per the Route-2 reversing signal ("only if STEP A closes … if a NEW obstacle appears
→ STOP, do not proceed to STEP B"): STEP A did not fully close — the `(c)` ring-bridge is a genuine
new obstacle (the planner labelled `(c)` "mechanical"; it is not). Correct call to not split focus
onto the equally-hard dual-pushforward build. `dual_restrict_iso` left at its pre-existing Step-4 sorry.

## Dead ends / notes for next iter
- `rw`/`simp only [ConcreteCategory.comp_apply]` do NOT decompose the `homLocalSection` composite —
  use `erw [ConcreteCategory.comp_apply]` (×4 for the triple composite, both sides).
- A standalone `homLocalSection_app_smul` helper lemma **fails instance synthesis** on its `r • m` in
  the abstract context (the `Module (↑(X.ringCatSheaf.obj.obj (op W))) (↑(M.val.obj (op W)))` instance
  is not found standalone) — keep the linearity proof **inline** inside `homOfLocalCompat (c)` where
  the instance resolves.
- The next prover should: at the L636 sorry, prove `r₂ •_X z₂ = (appIso.hom r₂) •_{Ui} z₂` (likely
  `rfl` modulo `appIso.inv_hom_apply`), then `erw [map_smul / LinearMap.map_smul]` on
  `(f i).val.app (op P)` at the `(U i)` level, then the N-leg `map_smul`, then reconcile the
  `eqToHom`-transported scalars. The hard part is the instance/defeq plumbing of the two actions on
  the defeq carrier `(M.restrict (U i).ι).val.obj (op P) = M.val.obj (op ((U i).ι ''ᵁ P))`.

## Blueprint
`lem:sheafofmodules_hom_of_local_compat` sub-step (a) is now FORMALIZED (sectionwise `hf` matches the
bw254-corrected blueprint). Sub-step (c) is formalized modulo the ring-bridge. Ready for `\leanok` on
the statement only once (c) closes (still has a sorry, so sync will not mark it).

## Build status
`lake build AlgebraicJacobian` → **success (8367 jobs)**. 2 declaration-sorries in this file:
`dual_restrict_iso` (L230, untouched), `homOfLocalCompat` (L512, isolated ring-bridge).
No new axioms. (Transient mid-session: the parallel-lane `TensorObjSubstrate.lean` was briefly broken,
which blocked LSP; resolved — full build green.)
