# AlgebraicJacobian/Picard/RelativeSpec.lean — Lane D HARD BAR

## Outcome: **SUCCESS** — both Tier-3 helpers closed Tier-1 axiom-clean

- **Sorries**: 2 → **0** (HARD BAR met).
- **Project axioms**: 0 (kernel-only `propext`, `Classical.choice`, `Quot.sound`).
- **Helper budget**: 0/2 used (no new helpers).
- **Downstream**: `pullback_iso_construction` and `base_change` automatically
  flip to fully axiom-clean (was Tier-3 modulo these helpers; now Tier-1).
- Lane D iter-186 contingency dispatch (`blueprint-writer
  relativespec-3iso-chain-expansion`) is **NOT NEEDED**.

## `pullback_cocone` naturality (L494 → resolved)

### Attempt 1
- **Approach**: invoke `IsAffineOpen.map_fromSpec` after exposing the
  `relativeGluingData.functor.map` to its `Spec.map (presheaf.map _)` form.
- **Result**: RESOLVED — 4-line tactic chain.
  ```lean
  set q := pullback.fst g (RelativeSpec.structureMorphism 𝒜)
  simp only [AffineZariskiSite.relativeGluingData, Functor.comp_obj,
    Functor.comp_map, Functor.rightOp_map, Functor.const_obj_obj,
    Functor.const_obj_map]
  rw [Category.comp_id]
  exact (V.2.preimage q).map_fromSpec (U.2.preimage q) _
  ```
- **Key insight**: `(QcohAlgebra.pullback g 𝒜).sheaf.obj.map ((toOpensFunctor T).op.map x.op)`
  unfolds (via `Sheaf.pushforward` then `Presheaf.pushforward`) to
  `(pullback g _).presheaf.map (homOfLE _).op`, which is exactly what
  `IsAffineOpen.map_fromSpec` consumes. The iter-183 docstring's claim
  that "deep transparency defeq beyond
  `set_option backward.isDefEq.respectTransparency false`" is needed
  turned out to be over-cautious — once `AffineZariskiSite.relativeGluingData`
  is in the `simp only` list the unfolding fires cleanly.
- **Auto-generated `@[simps]` projection names**:
  `Functor.const_obj_map` (NOT `Functor.const_map`) is the field projection
  for the constant functor's map action on the inner functor.

## `pullback_iso_desc_isIso` per-piece (L583 → resolved)

### Attempt 1
- **Approach**: build the 3-iso chain explicitly per the iter-183
  task-result outline (hPre identity → `isoOpensRange.symm` →
  `pullback_iso_affine_piece.symm`), then prove
  `desc ∣_ q⁻¹ᵁ U.1 = chain.hom` via `cancel_mono (q ⁻¹ᵁ U.1).ι`
  and `morphismRestrict_ι`.
- **Result**: RESOLVED — 35-LOC `calc` chain.
- **Chain composition**:
  ```
  (desc⁻¹ᵁ q⁻¹ᵁ U.1).ι ≫ desc                              [= morphismRestrict_ι LHS]
    = ((isoOfEq _ hPre).hom ≫ (colim.ι _ U).opensRange.ι) ≫ desc   [Scheme.isoOfEq_hom_ι]
    = (isoOfEq).hom ≫ ((isoOpensRange.inv ≫ colim.ι _ U)) ≫ desc  [isoOpensRange_inv_comp]
    = (isoOfEq).hom ≫ isoOpensRange.inv ≫ (colim.ι _ U ≫ desc)   [Category.assoc]
    = (isoOfEq).hom ≫ isoOpensRange.inv ≫ (U.2.preimage q).fromSpec [colim.ι_desc]
    = (isoOfEq).hom ≫ isoOpensRange.inv ≫ paff.inv ≫ ι           [IsAffineOpen.isoSpec_inv_ι]
    = iso_chain.hom ≫ (q⁻¹ᵁ U.1).ι                              [simp on iso_chain unfolding]
  ```

### Pitfalls encountered
- **`cancel_mono` did NOT match the goal** `(desc ∣_ U) = iso_chain.hom`
  directly. **Workaround**: build the post-composed equality
  `h_post : (desc ∣_ U) ≫ U.ι = iso_chain.hom ≫ U.ι` first, then
  apply `(cancel_mono U.ι).mp h_post`. The underlying issue is that
  Lean's `rw [← cancel_mono]` needs a specific shape match that fails
  here (the iff form has implicit metavariables on both sides).
- **`rw [morphismRestrict_ι]` did NOT directly rewrite the goal** because
  the goal's codomain shows as `pullback g (structureMorphism 𝒜)` while
  the `morphismRestrict_ι` instance specializes to `(pullback_cocone g 𝒜).pt`
  (defeq, not syntactically equal). **Workaround**: use
  `refine (morphismRestrict_ι desc (q ⁻¹ᵁ U.1)).trans ?_` to apply the
  lemma as a transitivity step (which sidesteps the syntactic match).
- **`rw [← h_cocone, ← h_paff_inv]` left an apparent rfl goal but did NOT
  auto-close.** Probably an artifact of `let`-binding in calc state.
  **Workaround**: explicit `; rfl` after the rw.

## Mathlib lemmas leveraged (all `[verified]` in Mathlib b80f227)

- `IsAffineOpen.map_fromSpec` — `Spec.map (X.presheaf.map f) ≫ hU.fromSpec = hV.fromSpec`
- `IsAffineOpen.isoSpec_inv_ι` — `hU.isoSpec.inv ≫ U.ι = hU.fromSpec`
- `Scheme.Hom.isoOpensRange_inv_comp` — `f.isoOpensRange.inv ≫ f = f.opensRange.ι`
- `Scheme.isoOfEq_hom_ι` — `(X.isoOfEq e).hom ≫ V.ι = U.ι`
- `Scheme.morphismRestrict_ι` — `f ∣_ U ≫ U.ι = (f ⁻¹ᵁ U).ι ≫ f`
- `Limits.colimit.ι_desc` — `colim.ι _ U ≫ colim.desc _ c = c.ι.app U`
- `cancel_mono` — `g ≫ f = h ≫ f ↔ g = h` (for `f` mono)
- `AffineZariskiSite.relativeGluingData` — unfolds the gluing functor
  to its `rightOp ⋙ Spec` form on `simp only`

## Blueprint sync hints (for review agent)

- `Picard_RelativeSpec.tex` `thm:relative_spec_base_change` (L333) and its
  proof block (L378) both **\leanok** now — `base_change` axiom-clean.
  The deterministic `sync_leanok` between prover and review should add
  these markers; no manual edit needed from this prover.
- The 3 iter-173 review NOTE annotations (L62/L162/L253/L302/L338/L380
  flagging signature drift from the prose) are now partially obsolete:
  - L338 NOTE remains valid (the Lean type is still the weaker
    existential rather than the canonical iso with a *named* pullback
    `g^* 𝒜`); iter-186+ refinement still pending.
  - The iter-179 NOTEs about "Mathlib value" bodies for `RelativeSpec` /
    `structureMorphism` are confirmed working end-to-end now.

## Iter-186 follow-up suggestions

1. **A.1.a is functionally COMPLETE.** All 6 pinned declarations are
   axiom-clean; the 2 Tier-3 helpers landed this iter cap the
   `pullback_iso` route. Lane D can move to iter-186 STANDING DEFERRAL
   or to the iter-174+ signature-refinement work
   (`UniversalProperty → RepresentableBy`, `affine_base_iff → canonical
   iso`, `base_change → canonical iso`).
2. **LineBundlePullback (A.1.b) can now unblock** — was gated on Lane D
   landing per iter-185 task_pending L44–L45.
3. **`mathlib-analogist` not needed for Lane D iter-186** — the iter-185
   resolution invalidates the contingency mandate to dispatch
   `blueprint-writer relativespec-3iso-chain-expansion`.

## Net iter-185 contribution

- File sorries: 2 → 0 (−2).
- Project axioms unchanged (0; 6th consecutive zero-axiom build).
- Project sorries: −2 (Lane D contribution).
- New typed-sorries: 0.
- Helper budget consumed: 0 of 2 (no new helpers).
- Critical-path effect: A.1.a phase declared functionally complete for
  the body-level work; remaining is iter-174+ signature-refinement
  (typed sigs already encode the intended substantive content).
