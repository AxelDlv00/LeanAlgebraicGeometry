# Iter-250 — prover objectives (the analogist-armed concrete close of D2′)

ONE lane. Lane TS = close the single concrete `(∗∗)` residual that is ALL that remains of D2′. This is
NOT a verbatim re-dispatch of iter-249: the iter-249 armed corrective fired (L1741 did not close), so
this iter carries the **mathlib-analogist eps250** idiom findings that diagnose and defeat the exact
Lean friction that killed the prior five passes. Read `analogies/eps250.md` IN FULL before starting —
it cites every named lemma with file:line and gives the friction-defeating idioms.

---

## Lane TS — `Picard/TensorObjSubstrate.lean` — CLOSE D2′ (the `(∗∗)` residual at L1741)

**Mode:** `prove`. **Critical path (A.1.c.sub).** Blueprint:
`chapters/Picard_TensorObjSubstrate.tex` § "The unit square (D2′): a mate-calculus telescope"
(step-7 `lem:epsilon_presheaf_to_sheaf_unit` retyped to `.val`-level iter-249; gate cleared).

### State going in
The ENTIRE abstract mate-calculus telescope is CLOSED axiom-clean and assembled as live tactic code
inside `pullbackEtaUnitSquare` (L1648–1740): steps 1–6 (the `homEquiv.injective` transposition, the
`compHomEquivFactor`/`leftAdjointUniqUnitEta` plug-in via local `hkey`, the `rfl` linchpin
`sheafificationCompPullback_eq_leftAdjointUniq`, both `homEquiv_naturality` folds, the X-triangle
`hXtri`, the X-side `homEquiv` collapse `hrhs`). After `refine Eq.trans ?_ hrhs.symm` (L1719), the
SOLE open goal is the concrete PRESHEAF identity `(∗∗)` (sorry L1741):
```
(presheafAdj.unit.app 𝟙ᵖ ≫ (PresheafOfModules.pushforward φ').map (toSheafify_Y (F 𝟙ᵖ)))
   ≫ R_X.map ((SheafOfModules.pushforward φ).map (a_Y.map (η F) ≫ sheafifyUnitIso.hom))
 = R_X.map (SheafOfModules.unitToPushforwardObjUnit φ)
```
`R_X = SheafOfModules.forget X ⋙ PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)`,
`φ = f.toRingCatSheafHom`, `φ' = φ.hom`, `F = PresheafOfModules.pullback φ'`, `a_Y = sheafification(𝟙)`.

### Why the prior 5 passes failed — and the fix (analogist eps250, READ `analogies/eps250.md`)
The obstacle was NEVER a missing lemma. It was `rw [Category.assoc]` / `rw [h]` **silently failing to
match** because these `≫` composites carry an implicit ring-presheaf argument that is `X.ringCatSheaf.val`
vs `X.presheaf ⋙ forget₂ CommRingCat RingCat` — **defeq but not syntactic**, so `rw`'s motive fails to
unify. Three robust idioms defeat it (use whichever fits each spot):
1. **Best structural fix:** open the residual with a single `show <goal restated> = …` that writes the
   goal in the **syntactic** `PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)` category
   (legal because `X.ringCatSheaf.val` is `rfl`-equal to it). After the `show`, **plain `rw
   [Category.assoc]` works** for the rest of the block.
2. `simp only [Category.assoc]` instead of `rw` — simp matches up to reducible defeq and reassociates
   where `rw` cannot.
3. The proven L1714 shape `(Category.assoc _ _ _).symm.trans (h ▸ Category.id_comp _)` (reuse it; do
   NOT re-derive a new assoc path).
**There is NO single coherence lemma that closes `(∗∗)` in one shot** — the LHS contains the opaque
sheafification unit `toSheafify` (does not compute on sections), so `ext X; simp` cannot evaluate it.
The lemma that folds the opaque unit away is `Adjunction.unit_app_unit_comp_map_η`, ALREADY the closed
`presheafUnit_comp_map_eta` (L1502). The remainder is irreducible `.val` bookkeeping — cheap with the
idioms above. Do NOT hunt for a one-shot lemma; execute the hybrid 3-step recipe.

### The 3 substeps — each with its named Mathlib lemma (all verified, analogist eps250 + planner loogle)

**(i) pushforward-through-`.val`** — `R_X.map ((SheafOfModules.pushforward φ).map g) =
(PresheafOfModules.pushforward φ').map g.val`. NAMED simp lemmas (not a rfl chase):
- `SheafOfModules.pushforward_map_val` [verified, loogle eps250]: `((pushforward φ).map f).val =
  (PresheafOfModules.pushforward φ.hom).map f.val` (`@[simps map_val]`, Mathlib
  `…Sheaf.PushforwardContinuous`).
- `SheafOfModules.forget_map` (`(forget R).map φ = φ.val`), `SheafOfModules.comp_val`
  (`@[simp, reassoc]`, `(f ≫ g).val = f.val ≫ g.val`), and the `restrictScalars(𝟙)`-is-identity defeq
  (`restrictScalarsCompToPresheaf (𝟙) = Iso.refl`; project memory `restrictscalars-id-defeq`).
- Recipe: `simp only [Functor.comp_map, SheafOfModules.forget_map, SheafOfModules.pushforward_map_val,
  SheafOfModules.comp_val, ← Functor.map_comp]` (the `restrictScalars(𝟙)` step is absorbed defeq).

**(ii) Y-side sheafification right-triangle** — `toSheafify_Y (F 𝟙ᵖ) ≫ (a_Y.map (η F)).val ≫
(sheafifyUnitIso.hom).val = η F`. Two standard lemmas:
- Unit naturality: `(PresheafOfModules.sheafificationAdjunction _).unit.naturality (η F)` together with
  `PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app` (unit's underlying-presheaf
  component is `toSheafify`) gives `toSheafify (F 𝟙ᵖ) ≫ (a_Y.map (η F)).val = η F ≫ toSheafify 𝟙ᵖ_Y`.
- Right triangle on the SHEAF `𝒪_Y`: `sheafifyUnitIso = (asIso counit).app (unit Y)`, `𝟙ᵖ_Y =
  (unit Y).val`, so `toSheafify 𝟙ᵖ_Y ≫ (sheafifyUnitIso.hom).val = 𝟙` by
  `CategoryTheory.Adjunction.right_triangle_components`. Net composite `= η F`.
- The single reassociation here is the `rw [Category.assoc]` failure point — use idiom (1)/(2)/(3) above.
- Then the CLOSED `presheafUnit_comp_map_eta f` rewrites `unit.app 𝟙ᵖ ≫ (pushforward φ').map (η F)`
  to `ε(pushforward φ')`.

**(iii) STEP 7 — author + prove `epsilonPresheafToSheafUnit`** (the SOLE genuinely-new decl):
`Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ') = (SheafOfModules.unitToPushforwardObjUnit φ).val`,
sectionwise (both act as `φ.hom.app X`). Characterization chain (analogist eps250):
- `PresheafOfModules.pushforward φ' = pushforward₀OfCommRingCat F R ⋙ restrictScalars φ'`. For the
  composite, `Functor.LaxMonoidal.comp` sets `ε := ε G ≫ G.map (ε F)`; `pushforward₀`'s `εIso := Iso.refl`
  ⇒ `ε F = 𝟙` ⇒ `ε(pushforward φ') = ε(restrictScalars φ')`.
- `ε(restrictScalars φ').app X = Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (φ'.app X).hom)`
  (project `restrictScalarsLaxε`, `…/PresheafInternalHom.lean:290`).
- `ModuleCat.restrictScalars_η` [verified, loogle eps250]: `ε(restrictScalars f) r = f r` (`@[simp]`).
- RHS: `unitToPushforwardObjUnit_val_app_apply` (`:= rfl`): `(unitToPushforwardObjUnit φ).val.app X a =
  φ.hom.app X a`; and `R_X.map upu` is DEFEQ `upu.val`.
- Author idiom: `apply PresheafOfModules.hom_ext; intro X` then `ModuleCat.hom_ext` / `LinearMap.ext`
  to an element `r`, then `simp [ModuleCat.restrictScalars_η, unitToPushforwardObjUnit_val_app_apply,
  Functor.LaxMonoidal.comp]` (or unfold `restrictScalarsLaxε`). Both sides → `φ.hom.app X r`. NO opaque
  unit here ⇒ genuinely one-shot.

### Assembly
Combine (i) (reshape the trailing pushforward factor), (ii) (collapse the big `homEquiv` argument to
`ε(pushforward φ')` via `presheafUnit_comp_map_eta`), (iii) (`epsilonPresheafToSheafUnit` to land on
`(unitToPushforwardObjUnit φ).val = R_X.map upu`). Closes `pullbackEtaUnitSquare` ⟹ the already-wired
`pullbackTensorMap_unit_isIso` (`lem:pullback_tensor_iso_unit`) closes automatically ⟹ **D2′ closes —
the FIRST canonical critical-path sorry-elimination of the route.**

### HARD binary closure bar (progress-critic ts250, STUCK; armed signal)
**Close the `(∗∗)` `sorry` at L1741 axiom-clean.** Every lemma is named, verified, and in hand; the
friction has a documented fix. "Reduced to a smaller residual / nothing closed" is NOT acceptable —
there is no abstract content left, only the 3 concrete substeps. If, after a genuine attempt with the
idioms above, a micro-step still resists, leave **real compiling partial tactic state** + a one-line
handoff naming the EXACT residual subgoal and which idiom you tried — NEVER an opaque re-reduction.

### Secondary (bounded doc fix, only if (∗∗) closes)
If `(∗∗)` closes, update the module-status docstring (L41–51) to read ONE remaining tracked sorry
(L699 `exists_tensorObj_inverse`) — D2′ is then done. Comment-only.

### Guardrails
Do NOT touch `exists_tensorObj_inverse` (~L699). Do NOT revive the abandoned general Lan build (D1,
off path). Do NOT attempt D3′/D4′ until D2′ closes. No opaque sorry pins; no typed-sorry bridges.

### ARMED escalation (binary — progress-critic ts250)
This is the LAST targeted concrete pass. If `(∗∗)`/L1741 does NOT close after this analogist-armed
pass, iter-251 does NOT run a 7th targeted pass — it escalates to a **structural rethink / route
pivot** of the D2′ proof shape (per progress-critic ts250 armed secondary).
