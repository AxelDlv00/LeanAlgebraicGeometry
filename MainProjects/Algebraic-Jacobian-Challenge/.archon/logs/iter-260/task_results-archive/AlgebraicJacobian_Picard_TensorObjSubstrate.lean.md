# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-259 (D3′ Sq2b)

## Objective
D3′ Sq2b → `pullbackTensorMap_restrict`. Per the directive: add the standalone presheaf-level
**Sq2b** lemma (monoidality of `PresheafOfModules.pullbackComp`) by mirroring the compiling
`pullbackObjUnitToUnit_comp` with η→δ; then attempt the full `pullbackTensorMap_restrict`.

## Result: Sq2b mate-calculus REDUCTION COMPLETE; isolated to ONE genuine residual.

Two new declarations added before `pullbackTensorMap_restrict`:

### `pullbackComp_δ` (Sq2b) — **FULLY PROVEN** (axiom-clean modulo the residual below)
The presheaf-level δ-transport across `pullbackComp`:
`δ (pullback (φ ≫ F.op ◁ ψ)) M N = c.inv (M⊗N) ≫ δ(pullback φ ⋙ pullback ψ) M N ≫ (c.hom M ⊗ₘ c.hom N)`.
`lean_verify` → axioms `{propext, sorryAx, Classical.choice, Quot.sound}` (sorryAx ONLY via the
residual `pushforwardComp_lax_μ`; no custom axioms). The complete ~90-line mate-calculus proof
compiles. Every mathematical step fired:
- transpose under `(pullbackPushforwardAdjunction (φ≫F.op◁ψ)).homEquiv.injective`;
- LHS δ via `Adjunction.unit_app_tensor_comp_map_δ` (the mate-of-μ identity);
- (MATE) `hconj`/`hmate`: conjugate of `pullbackComp.inv` is `pushforwardComp.hom = 𝟙`
  (`conjugateEquiv_leftAdjointCompIso_inv`, `unit_conjugateEquiv`; `pushforwardComp = Iso.refl`);
- (U-C) `unit_app_tensor_comp_map_δ` for the composite adjunction `aφ.comp aψ`;
- (μ-COH) rewrite via `pushforwardComp_lax_μ` (← the residual);
- (μ-NAT) `Functor.LaxMonoidal.μ_natural`;
- (TRI) `htri`: `aC.unit P ≫ map(c.hom P) = aχ.unit P` from `hmate` + `inv_hom_id_app`;
- tensorHom merge + `Category.assoc`.

### `pushforwardComp_lax_μ` — **THE GENUINE RESIDUAL** (typed `sorry`, sectionwise-reduced)
`μ(pushforward ψ ⋙ pushforward φ) X Y = μ(pushforward (φ ≫ F.op ◁ ψ)) X Y`.
This is the "pushforwardComp is monoidal" theorem (right-adjoint side of Sq2b). **Empirically NOT
`rfl`** and `simp`-resistant — directly contradicting the `d3sq2b258` recipe's prediction that this
residual would be "rfl/short ext (cf. the rfl-closed `unitToPushforwardObjUnit_comp`)". The η-twin
was rfl because η only touches ε; the μ-version is the full tensorator interchange. Body advances to
the sectionwise `ModuleCat` leaf (`ext W x`); the leaf is a `ModuleCat.extendScalars`/`restrictScalars`
base-change associativity coherence for the composite ring hom (`ModuleCat.restrictScalarsComp`,
`ModuleCat.homEquiv_extendScalarsComp`, `ModuleCat.extendScalarsComp`) — a ~150-LOC ModuleCat
change-of-rings build. This is the REVERSING SIGNAL the directive armed: a step with no analog in the
compiling `pullbackObjUnitToUnit_comp`.

## Summary
- **Sorry count (bare `sorry`): 2 → 3.** Net +1, but this is genuine DECOMPOSITION: the entire Sq2b
  mate calculus is now PROVEN (`pullbackComp_δ`), with the single genuine obstacle isolated and
  precisely stated (`pushforwardComp_lax_μ`).
- Closed: none of the pre-existing sorries; instead `pullbackComp_δ` (Sq2b) added FULLY PROVEN
  modulo the residual.
- Open (mine): `pushforwardComp_lax_μ` (genuine ModuleCat coherence, sectionwise-reduced).
- Untouched: `exists_tensorObj_inverse` (L715, off-limits); `pullbackTensorMap_restrict` (L2392 —
  the 4-square assembly Sq1/Sq3/Sq4 NOT done; `pullbackComp_δ` is the ready Sq2 ingredient).
- D1′/D2′ kept GREEN (not touched).

## Why I stopped
**Real progress (code):** `pullbackComp_δ` is a complete, compiling ~90-line mate-calculus proof
(verified step-by-step via `lean_goal`), reducing Sq2b to exactly one residual. This validates the
analogist's reduction skeleton end-to-end and isolates the true gap. The residual
`pushforwardComp_lax_μ` is the genuine new obstacle: I empirically refuted the recipe's "rfl/short
ext" claim (tested `rfl`, `ext W x; rfl`, `ext W x; simp`, `dsimp [...]; rfl` — all fail; the leaf is
the explicit `extendScalars`/`restrictScalars` base-change expression). Per the armed reversing
signal, I left the typed `sorry` (sectionwise-reduced) + this report rather than stacking a new
abstract layer.

Not attempted: closing `pushforwardComp_lax_μ` (the ~150-LOC ModuleCat coherence — out of budget, and
the informal agent is UNAVAILABLE: the only key set, MOONSHOT, returns 401 invalid-auth); the 4-square
assembly of `pullbackTensorMap_restrict` (gated on Sq1/Sq3/Sq4 + this residual).

## Reusable tactic recipes discovered (for next iter / memory)
- **Statement shape**: state Sq2b's LHS pullback as `pullback (F := F⋙G) (R := T₀⋙forget₂) (φ ≫
  F.op.whiskerLeft ψ)` — pinning BOTH `F` and `R` is required so (a) the morphism's
  `F.op⋙G.op⋙(T₀⋙forget₂)` codomain defeq-elaborates against `(F⋙G).op⋙?R`, and (b) the
  `presheafPullbackOplaxMonoidal` instance resolves (its pattern is `?F.op ⋙ (?R₀ ⋙ forget₂)`, which
  the un-pinned composite morphism does NOT match).
- **δ/μ adjunction rewrites need `erw`, not `rw`**: `presheafPullbackOplaxMonoidal χ` (the registered
  instance) is defeq-but-not-syntactic to `aχ.leftAdjointOplaxMonoidal` (what the Mathlib lemmas use)
  → `rw [Adjunction.unit_app_tensor_comp_map_δ (adj := …)]` fails "pattern not found"; `erw` fires.
- **Namespaces**: `Adjunction.unit_app_tensor_comp_map_δ`, `Adjunction.conjugateEquiv_leftAdjointCompIso_inv`
  are under `CategoryTheory.Adjunction`; **`conjugateEquiv` and `unit_conjugateEquiv` are BARE**
  (`CategoryTheory`, no `Adjunction.`).
- **`pushforwardComp = Iso.refl`** ⇒ `conjugateEquiv aC aχ (pullbackComp φ ψ).inv = 𝟙` (prove by
  `simp only [PresheafOfModules.pullbackComp, conjugateEquiv_leftAdjointCompIso_inv,
  PresheafOfModules.pushforwardComp, Iso.refl_hom]`). The MATE step then drops the `pc.hom` factor.
- **Duplicate Category/MonoidalCategory instance wall**: generic `rw [Iso.inv_hom_id_app]`,
  `rw [NatTrans.comp_app]`, `rw [MonoidalCategory.tensorHom_comp_tensorHom]`, `rw [Category.assoc]`
  ALL fail "pattern not found" on the goal's `≫`/`⊗ₘ` (the goal uses `monoidalCategory`'s Category
  vs the base `instCategory`). FIXES that worked: `erw [(iso).inv_hom_id_app P]` (explicit dot-notation
  term); pin `tensorHom_comp_tensorHom (C := _root_.PresheafOfModules (..⋙forget₂))` + `erw`;
  `erw [← reassoc_of% (hmate P)]` for unit/map reassociation; `conv_lhs => rw [← htri M, ← htri N]`
  (project-stated lemmas DO `rw`-match); the trailing `(f≫g)≫h = f≫(g≫h)` closed by
  `exact Category.assoc _ _ _`.
- **NAME TRAP**: `Functor.map_id` resolves to the monad/`<$>` lemma; use `CategoryTheory.Functor.map_id`
  for `F.map (𝟙 X) = 𝟙 (F.obj X)`.
- **`reassoc_of% h` blows heartbeats** when wrapped in `erw` over `tensorHom_comp_tensorHom`; prefer
  plain `erw [← tensorHom_comp_tensorHom (C := …)]` then `exact Category.assoc _ _ _`.

## Next step
Close `pushforwardComp_lax_μ` in `mathlib-build`/fine-grained mode (the ModuleCat base-change
coherence, ~150 LOC; the `ext W x` leaf is in place). The moment it lands, `pullbackComp_δ` is fully
axiom-clean and Sq2 of `pullbackTensorMap_restrict` is discharged; then the 4-square assembly
(Sq1 `sheafificationCompPullback`-comp, Sq3 `sheafifyTensorUnitIso`, Sq4 `pullbackValIso`-comp +
`toRingCatSheafHom_comp_hom_reconcile`) closes `pullbackTensorMap_restrict`.

## Blueprint markers
- `lem:pullback_tensor_map_basechange` (= `pullbackTensorMap_restrict`): still has a `sorry`; do NOT
  `\leanok`. The Sq2b sub-result is now formalized as `pullbackComp_δ` (proven modulo
  `pushforwardComp_lax_μ`). The plan agent may wish to add a `\lean{…}` hint for `pullbackComp_δ` /
  `pushforwardComp_lax_μ` in the Sq2/Sq2b paragraph and note that the residual is the
  "pushforwardComp-is-monoidal" ModuleCat coherence (NOT rfl, correcting the bw258-d3 sketch).
