# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ana-pclm260

## Iteration
260

## Question
For `pushforwardComp_lax_μ` (TensorObjSubstrate.lean:2143): does Mathlib have this coherence; what is
the canonical PROOF SHAPE; is `pushforwardComp = Iso.refl` enough to reduce it to `μ_natural`/`map_comp`;
and if not, what is the most economical project-local construction (≤~150 LOC, no circular import)?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Mathlib has "pushforward monoidal across composition" | NEEDS_MATHLIB_GAP_FILL | informational |
| Proof is a 150-LOC `extendScalarsComp` build vs a short sectionwise reduction | ALIGN_WITH_MATHLIB | major |
| `pushforwardComp = Iso.refl` ⇒ reduce via `μ_natural`/`map_comp` (Q3) | PROCEED (answer: NO) | informational |

## Major

**The docstring's route estimate is wrong — drop the `extendScalarsComp`/`homEquiv_extendScalarsComp`
plan.** The residual is NOT a ~150-LOC change-of-rings associativity build. It is a SHORT sectionwise
tensor-induction whose only real lemma is Mathlib's `ModuleCat.restrictScalars_μ_tmul`. The directive's
Q1/Q2 candidates `ModuleCat.extendScalarsComp` / `ModuleCat.homEquiv_extendScalarsComp` exist
(`ChangeOfRings.lean:996,1003`) but solve the *change-of-rings functor* associativity, NOT the lax
tensorator μ — they are a red herring here. Following the docstring would waste a dispatch building
machinery that is never used.

## Informational

**Q1 — does Mathlib have it?** No. `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean` has
zero monoidal content; `pushforwardComp φ ψ := Iso.refl` (line 135) and `pushforward_assoc` (line 142)
are coherences of the **underlying functors only**. The lax-monoidal structure on
`PresheafOfModules.pushforward` is project-built (`presheafPushforwardLaxMonoidal`, L1124). So the
*coherence* is a (small) project gap, but every *ingredient* is in Mathlib.

**Q2 — canonical proof shape: route (b), sectionwise, but SHORT.** The three Mathlib facts that make
both μ's collapse to the identity on a pure tensor:
- `ModuleCat.restrictScalars_μ_tmul` (`Monoidal/Adjunction.lean:116`): `μ (restrictScalars f) (m₁⊗ₜm₂) = m₁⊗ₜm₂`. **The workhorse.**
- `pushforward₀OfCommRingCat F R`.Monoidal with `μIso := Iso.refl` (`Presheaf/PushforwardZeroMonoidal.lean:33`) ⇒ its μ is `𝟙`.
- `Functor.LaxMonoidal.comp` is `@[simps]` (`CategoryTheory/Monoidal/Functor.lean:221`) ⇒
  `comp_μ : μ (F⋙G) X Y = μ G _ _ ≫ G.map (μ F X Y)`.
Since `pushforward φ = pushforward₀ ⋙ restrictScalars φ'` with `μ(pushforward₀) = 𝟙`, sectionwise
`μ(pushforward φ).app W` is just the ModuleCat `μ(restrictScalars (φ.app W).hom)`, which is identity on
`m⊗ₜn`. Same for the RHS composite ring map. Hence both sides send `m⊗ₜn ↦ m⊗ₜn`.

**Q3 — is `pushforwardComp = Iso.refl` enough? NO.** It equates the underlying *functors*; the two μ's
are two distinct `LaxMonoidal` *instances* on that functor (LHS = synthesized `Functor.LaxMonoidal.comp`,
RHS = `presheafPushforwardLaxMonoidal`). Their agreement is genuine content. EMPIRICALLY: `rfl` fails
even on one pure tensor (restrictScalars's μ is an adjunction transpose, equal-but-not-defeq to id).

## Concrete recipe for the next D3′ prover

**Step A — build ONE helper right after `presheafPushforwardLaxMonoidal` (TensorObjSubstrate.lean ~L1135;
no circular import — `restrictScalarsLaxμ`, `pushforward₀` Monoidal, `restrictScalars_μ_tmul` are all
already imported).** This is the brick that unfolds the opaque `presheafPushforwardLaxMonoidal` μ once,
in a *small* goal (avoiding the whnf explosion that kills a direct `erw` in the big goal):

```lean
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
/-- Sectionwise value of the pushforward lax tensorator on a pure tensor: the identity. -/
lemma pushforward_μ_app_tmul
    {C D : Type u} [Category.{u} C] [Category.{u} D] {F : C ⥤ D}
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶ F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (M N : _root_.PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : ((PresheafOfModules.pushforward φ).obj M).obj W)
    (n : ((PresheafOfModules.pushforward φ).obj N).obj W) :
    (Functor.LaxMonoidal.μ (PresheafOfModules.pushforward φ) M N).app W (m ⊗ₜ n) = m ⊗ₜ n := by
  -- `μ(pushforward φ) = μ(pushforward₀ ⋙ restrictScalars φ')`; `comp_μ` exposes the composite,
  -- the `pushforward₀` factor's μ is `𝟙` (Iso.refl), leaving `restrictScalars`'s μ, which is
  -- identity on pure tensors by `restrictScalars_μ_tmul`.  Mirror `restrictScalarsLaxμ.naturality`
  -- (PresheafInternalHom.lean:313) which already closes with this exact `erw`.
  erw [ModuleCat.restrictScalars_μ_tmul]   -- small goal ⇒ no whnf explosion
```
If the bare `erw` still struggles, first expose the composite explicitly:
`simp only [Functor.LaxMonoidal.comp_μ]` is NOT expected to fire (instance is `exact h`-cast), so use a
`show` to the comp form, or `change`, guarded by the two `set_option`s, then `erw [restrictScalars_μ_tmul]`.
A robust fallback proof body, mirroring `epsilonPresheafToSheafUnit` (L1674) which proves the ε-twin:
add `letI : CommRing ↑(((R₀ ⋙ forget₂ _ _).obj (op (F.obj W.unop))))` to feed instance synthesis,
then `erw [ModuleCat.restrictScalars_μ_tmul]`.

**Step B — `pushforwardComp_lax_μ` main proof** (replaces the `sorry` at L2169; the lemma already has
`maxHeartbeats 3200000` budget upstream — keep/raise it):
```lean
  ext W x
  induction x using TensorProduct.induction_on with
  | zero => simp only [map_zero]          -- if "no progress": use `rw [map_zero, map_zero]`
                                          --   or `exact (map_zero _).trans (map_zero _).symm`
  | add a b ha hb => simp only [map_add]; rw [ha, hb]   -- distribute the ModuleCat hom over +
  | tmul m n =>
      -- RHS: single pushforward along the composite ring map.
      rw [pushforward_μ_app_tmul (φ ≫ F.op.whiskerLeft ψ) X Y W]
      -- LHS: expose the outer composite, push the `(pushforward φ).map _` application down a section,
      -- then apply the helper to each single pushforward.
      simp only [Functor.LaxMonoidal.comp_μ]
      rw [ModuleCat.comp_apply]                        -- (p ≫ q) x = q (p x); name may be `ModuleCat.hom_comp`/`comp_apply`
      rw [pushforward_μ_app_tmul φ (Pψ X) (Pψ Y) W]    -- inner factor → m ⊗ₜ n
      erw [PresheafOfModules.pushforward_map_app_apply] -- (pushforward φ).map(μ ψ).app W (m⊗ₜn) = (μ ψ).app (op (F.obj W.unop)) (m⊗ₜn)
      rw [pushforward_μ_app_tmul ψ X Y (op (F.obj W.unop))]   -- → m ⊗ₜ n
```
Notes / fragility:
- `comp_μ` DOES fire on the LHS (the outer `Functor.LaxMonoidal.comp` is Lean-synthesized — CONFIRMED).
- The element-distribution lemmas (`map_zero`/`map_add`/`comp_apply`) may need the ModuleCat-specific
  spellings; the prover should `lean_hover_info` the coercion. The zero/add cases are pure linearity.
- `pushforward_map_app_apply` is `rfl` (`Pushforward.lean:108`) — use `erw` if the `restrictScalars`
  wrapper on `m` blocks a plain `rw`.

**Do NOT**: `erw [restrictScalars_μ_tmul]` directly in the big `pushforwardComp_lax_μ` goal (whnf
timeout, confirmed >200000 even with `respectTransparency false`); build any `extendScalarsComp` /
`homEquiv_extendScalarsComp` machinery (unused).

## Persistent file
- `analogies/pushforwardcomp-lax-mu260.md` — full rationale, citations, and empirical findings captured for future iters.

Overall verdict: Mathlib lacks the pushforward-monoidality coherence but has every ingredient; the
canonical proof is a SHORT sectionwise tensor-induction via `ModuleCat.restrictScalars_μ_tmul` funnelled
through one whnf-safe helper (`pushforward_μ_app_tmul`) — NOT the ~150-LOC `extendScalarsComp` build the
docstring fears.
