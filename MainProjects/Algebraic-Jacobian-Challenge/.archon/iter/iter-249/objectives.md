# Iter-249 — prover objectives (full recipe, guardrails, armed escalation)

ONE lane this iter. Lane TS is the D2′ CLOSE — a single `prove` pass on the one concrete (∗∗) residual that
remains after iter-248 discharged all the abstract mate-calculus. No second lane exists (linear dependency
chain; RPF gated cross-file on D4′).

---

## Lane TS — `Picard/TensorObjSubstrate.lean` — CLOSE D2′ (the single (∗∗) residual)

**Mode:** `prove`. **Critical path (A.1.c.sub).** Blueprint:
`chapters/Picard_TensorObjSubstrate.tex` § "The unit square (D2′): a mate-calculus telescope" (step-7 retyped
+ linchpin block added + HARD GATE re-cleared THIS iter, ts-fastpath249).

### State going in (what iter-248 + this plan-phase already did)
- **All abstract adjunction mate-lemmas are CLOSED axiom-clean:** `compHomEquivFactor` (step 3),
  `leftAdjointUniqUnitEta` (step 4), `presheafUnit_comp_map_eta` (step 6), `isIso_sheafifyEta_of_unitSquare`
  (IsIso plumbing). The `rfl` linchpin `sheafificationCompPullback_eq_leftAdjointUniq` is CLOSED (it holds
  definitionally — the long-suspected "3-layer defeq wall" was a non-issue).
- **The D2′ closer `pullbackTensorMap_unit_isIso` is FULLY WIRED** — it depends only on `pullbackEtaUnitSquare`.
- **`pullbackEtaUnitSquare` (L1641–1672)** has already, in its body: (1) transposed via
  `(pullbackPushforwardAdjunction φ).homEquiv.injective`; (2) rewritten the RHS via
  `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`; (3) rewritten via `Adjunction.homEquiv_unit`.
  The single open `sorry` is at **L1672**, the canonical (∗∗) goal (in-code ~L1656):
  ```
  sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map (pullbackValIso.inv ≫ a_Y.map (η F) ≫ sheafifyUnitIso.hom)
    = unitToPushforwardObjUnit φ
  ```

### The remaining proof (the whole iter goal)
Drive (∗∗) through the telescope using the now-closed lemmas:
1. **Distribute** `(pushforward φ).map` over the composite (`Functor.map_comp`).
2. **Pull `pullbackValIso.inv` past the unit** via `Adjunction.unit_naturality` (step 2 of the telescope).
3. **Apply `compHomEquivFactor`** (step 3, CLOSED) to factor the composite-adjunction hom-set map.
4. **Apply `leftAdjointUniqUnitEta`** (step 4, CLOSED) — first rewrite `sheafificationCompPullback φ` to
   `A.leftAdjointUniq B` using the **now-pinned linchpin** `sheafificationCompPullback_eq_leftAdjointUniq`.
5. **Expand** `B.unit.app` inline via `Adjunction.comp_unit_app` (step 5).
6. **Reach the presheaf head** `presheafAdj.unit.app 𝟙ᵖ ≫ (pushforward φ').map (η F)` and rewrite to the
   presheaf-level `ε(pushforward φ')` via `presheafUnit_comp_map_eta` (step 6, CLOSED).
7. **CREATE + PROVE `epsilonPresheafToSheafUnit`** (step 7 = `lem:epsilon_presheaf_to_sheaf_unit`) — the
   `.val`-level reconciliation the blueprint now describes. **Pin its exact Lean type FROM THE LIVE (∗∗)
   SUBGOAL** (do not guess it abstractly): it is an equality of underlying-presheaf morphisms — the presheaf
   `ε(pushforward φ')` and `(unitToPushforwardObjUnit φ).val` — checked sectionwise, both acting as
   `φ.hom.app X` (use `unitToPushforwardObjUnit_val_app_apply : (unitToPushforwardObjUnit φ).val.app X a =
   φ.hom.app X a`). There is **NO** `Functor.LaxMonoidal` instance on the sheaf pushforward — do not write a
   sheaf-level `ε`. The presheaf lax unit that exists is `Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ')`.
8. Close `pullbackEtaUnitSquare`; the already-wired `pullbackTensorMap_unit_isIso` then closes automatically.

### HARD closure bar (the STUCK-corrective test, progress-critic ts249)
**Close the (∗∗) `sorry` at L1672 axiom-clean** ⟹ D2′ (`pullbackTensorMap_unit_isIso`) closes — the FIRST
canonical critical-path sorry-elimination in 10+ iters. Every abstract lemma the telescope needs is already
closed; the residual is bookkeeping in ONE proof + the one new step-7 `.val` lemma. "Reduced to a smaller
residual, nothing closed" is NOT acceptable this iter. If genuinely blocked after a real attempt, leave
concrete partial tactic state + a one-line handoff naming the EXACT remaining subgoal — never an opaque sorry,
never a re-reduction with zero closures.

### Secondary (bounded doc fix — lean-auditor aud248)
- **L43–44** module-status block: "the remaining typed-`sorry` residual" (singular) is stale — there are now
  TWO tracked sorries: L692 (`exists_tensorObj_inverse`) + L1672 (`pullbackEtaUnitSquare` (∗∗)). If L1672
  closes this iter, update it to read ONE residual (L692); if not, list both.
- **L51** "Once the inverse lands, the consumer `PicSharp.addCommGroup` … can be rewired" — stale; RPF was
  rewired iter-247. Drop or past-tense it.
- Comment-only; do not touch proof bodies for the doc fix.

### Glue lemmas — verified to exist (analogist eta247, carried forward)
`Adjunction.unit_naturality`, `Adjunction.comp_unit_app`, `Adjunction.homEquiv_unit`, `Functor.map_comp`,
`unitToPushforwardObjUnit_val_app_apply`, `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`,
plus the closed step-lemmas `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `presheafUnit_comp_map_eta`,
`sheafificationCompPullback_eq_leftAdjointUniq`. Expect the known `erw` defeq friction
(`Scheme.Modules.pullback f` vs `SheafOfModules.pullback f.toRingCatSheafHom`) — elaboration nuisance, NOT an
API gap.

### Guardrails
Do NOT touch `exists_tensorObj_inverse` (~L692). Do NOT revive the abandoned general Lan build (D1, off path).
Do NOT attempt D3′/D4′ until D2′ closes. No opaque sorry pins; no typed-sorry bridges.

### ARMED escalation (critic-named — replaces the iter-248 fine-grained reversing signal)
If this `prove` pass does NOT close L1672, iter-250 runs a **mathlib-analogist** consult (api-alignment) on
`SheafOfModules.pushforward` unit/counit naturality / the presheaf↔sheaf `ε` reconciliation — NOT another
helper round, NOT a third fine-grained decomposition. The abstract calculus is done; if (∗∗) resists, the
obstacle is an idiom for the sheafification↔pushforward `.val` bookkeeping, which the analogist is the right
tool for.
