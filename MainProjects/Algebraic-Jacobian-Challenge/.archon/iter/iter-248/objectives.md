# Iter-248 — prover objectives (full recipes, guardrails, reversing signals)

Two lanes. Lane TS is the STUCK-route corrective (mode switch to fine-grained on the freshly-atomized
telescope); Lane RPF is a small must-fix hygiene pass. Independent files.

---

## Lane TS — `Picard/TensorObjSubstrate.lean` — D2′ η-bridge, ONE ATOMIC STEP AT A TIME

**Mode:** `fine-grained`. **Critical path (A.1.c.sub).** Blueprint:
`chapters/Picard_TensorObjSubstrate.tex` § "The unit square (D2′): a mate-calculus telescope" (just
written + cleaned this iter).

### Why the mode changed (progress-critic ts248 = TS STUCK)
5 consecutive PARTIALs (iter-243…247), 0 critical-path sorry closures, recurring blocker "recipe
complete, cannot encode the full telescope within budget." The residual has shrunk every iter
(`IsIso δ` → `IsIso η` → a single morphism equation, the "unit square") but never CLOSES, because the
prover keeps attempting the whole mate-telescope as one contiguous defeq-laden computation across three
nested adjunction layers. **The corrective (critic-named): the blueprint now atomizes the telescope into
named per-sentence lemmas; prove them ONE AT A TIME.** Do NOT attempt the whole square in one tactic
block again — that is the wall that has been hit 3× running.

### The atomic targets (blueprint blocks → Lean decls to create)
Two already exist axiom-clean (reuse, do not rebuild):
- `presheafUnit_comp_map_eta` (~L1495) = `lem:presheaf_unit_comp_map_eta`.
- `isIso_sheafifyEta_of_unitSquare` (~L1518) = `lem:isiso_sheafifyeta_of_unitsquare`.

Create these (blueprint names → proposed Lean decl names; the prover may rename, just keep `\lean{}`
consistent if it does — but the blueprint pins these proposed names, so prefer them):
1. **`lem:comp_homequiv_factor_sheafify_pullback`** → `compHomEquivFactor` (★ step 3, the prover-flagged
   HARDEST): the composite-adjunction hom-set factorisation
   `(adj₁.comp adj₂).homEquiv g = adj₁.homEquiv (adj₂.homEquiv g)`, specialised to the unit square's
   composite adjunction `A`. **Verify the exact Mathlib form of `Adjunction.comp ... homEquiv` FIRST**
   (`lean_hover_info` on `Adjunction.comp` / search `Adjunction.comp_homEquiv`); this was the prover's
   named uncertainty last iter.
2. **`lem:leftadjointuniq_app_unit_eta`** → `leftAdjointUniqUnitEta` (★ step 4): apply
   `Adjunction.homEquiv_leftAdjointUniq_hom_app A B 𝟙ᵖ` to get `A.homEquiv (scp.hom.app 𝟙ᵖ) = B.unit.app 𝟙ᵖ`,
   then expand `B.unit.app 𝟙ᵖ` via `Adjunction.comp_unit_app`. (`scp = sheafificationCompPullback φ =
   Adjunction.leftAdjointUniq A B`.)
3. **`lem:epsilon_presheaf_to_sheaf_unit`** → `epsilonPresheafToSheafUnit` (★ step 7): reconcile the
   presheaf-level `ε_pre = Functor.LaxMonoidal.ε (pushforward φ')` with the sheaf-level
   `ε_sheaf = unitToPushforwardObjUnit φ` (`Functor.LaxMonoidal.ε (pushforward φ) = unitToPushforwardObjUnit φ`
   by `rfl`, plus the pushforward↔sheafification compatibility).
4. **`lem:eta_bridge_unit_square`** → `pullbackEtaUnitSquare` (the assembly target): the unit square
   `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit φ`.
   Proof = transpose across `(pullbackPushforwardAdjunction φ).homEquiv.injective` to the pushforward-side
   identity (∗∗), then the 7-step telescope: step 1 `Functor.map_comp`, step 2 `Adjunction.unit_naturality`
   (pull `sheafCounit_X.inv` front), step 3 = lemma (1), step 4 = lemma (2), step 5 inline
   `comp_unit_app`, step 6 = `presheafUnit_comp_map_eta`, step 7 = lemma (3).
5. **Close D2′**: feed the unit square into `isIso_sheafifyEta_of_unitSquare` → `IsIso (a_Y.map η)`, then
   into the iter-246 `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` to finish
   `pullbackTensorMap_unit_isIso` (= `lem:pullback_tensor_iso_unit`).

### HARD closure bar (this is the STUCK-corrective test)
Close AT LEAST ONE of the three ★ atomic step-lemmas (1)/(2)/(3) **axiom-clean** this iter — ideally all
three + the assembled unit square + D2′. Closing one or more ★ steps is the genuine sorry-elimination the
route has not produced in 5 iters; it converts STUCK→progress. **"Reduced to a smaller residual, nothing
closed" is NOT acceptable again.** Work each step as its own lemma; if one ★ step is genuinely blocked,
CLOSE THE OTHER TWO and leave the blocked one with real partial tactic state + a precise one-line handoff
(its exact remaining goal) — never an opaque sorry, never a re-reduction with zero closures.

### Glue lemmas — verified to exist (analogist eta247, carried forward)
`Adjunction.homEquiv_leftAdjointUniq_hom_app`, `unit_leftAdjointUniq_hom_app` (+`_assoc`),
`leftAdjointUniq_hom_app_counit` (+`_assoc`), `leftAdjointUniq_trans_app_assoc`, `leftAdjointOplaxMonoidal_η`,
`homEquiv_unit`, `homEquiv_counit`, `Adjunction.comp_unit_app`, `Adjunction.unit_naturality`,
`Adjunction.unit_app_unit_comp_map_η` (already used in `presheafUnit_comp_map_eta`). Expect the known `erw`
defeq friction (`Scheme.Modules.pullback f` vs `SheafOfModules.pullback f.toRingCatSheafHom`;
`sheafificationCompPullback` unfolding to `leftAdjointUniq`) — elaboration nuisance, NOT an API gap.

### Guardrails
Do NOT touch `exists_tensorObj_inverse` (~L670). Do NOT revive the abandoned general Lan build (D1, off
path). Do NOT attempt D3′/D4′ until D2′ closes. No opaque sorry pins.

---

## Lane RPF — `Picard/RelPicFunctor.lean` — fix the 2 lean-auditor must-fix items (honest hygiene)

**Mode:** `prove` (the file already compiles 0 local sorry; this is doc/comment correctness + an honest
status rewrite, no proof obligations). Blueprint: `chapters/Picard_RelPicFunctor.tex` (unchanged; gate
cleared rpf-fastpath247).

The iter-247 rewire left the file's HEADER and `PicSharp` docstring describing a stale/false project
state. lean-auditor iter247 flagged 2 must-fix + 3 major:

### Must-fix (do both)
1. **`RelPicFunctor.lean:32–34`** — module-status docstring falsely claims "the single remaining
   file-local sorry is the `addCommGroup` instance body in §1, gated on the Mathlib `Scheme.Modules`
   monoidal-structure upgrade." FALSE: `addCommGroup` has a real body; the only cone sorry is the
   UPSTREAM `Modules.exists_tensorObj_inverse` (TensorObjSubstrate.lean:670). Rewrite to state the true
   state accurately.
2. **`RelPicFunctor.lean:477`** — `PicSharp` docstring contains the excuse-comment "**sorry-free
   placeholder** used while the file-local `addCommGroup` sorry in §1 is open" on a load-bearing
   definition (base of `presheaf`/`etSheaf`/`etSheaf_group_structure`), AND the body is a weakened-wrong
   PUnit constant functor. Replace the excuse-comment with an HONEST tracked-gap note: `PicSharp` is
   currently a `PUnit` stub because the real functor `T ↦ AddCommGrpCat.of (Quotient …)` needs
   `functorial`'s `map_add`, which needs the loc-triv comparison iso `pullback_tensor_iso_loctriv`
   (Lane TS D4′, `TensorObjSubstrate.lean`, not yet landed). State that gate precisely; do NOT call it a
   "placeholder" with a false gate. The real upgrade is genuinely cross-file-blocked on D4′ — that is a
   legitimate tracked gap, not a dodge.

### Major (fix while in the file)
- `L30, L44–49` — header mischaracterizes the `sorryAx` source (it's upstream `exists_tensorObj_inverse`,
  not file-local) and gives an incomplete upgrade condition. Correct it.
- `L524–535` — `functorial` docstring cites a stale "same upstream Mathlib upgrade" gate. The real gate is
  proving `map_zero`/`map_add` for the pullback-induced hom on the concrete quotient (map_add ← D4′).

### Guardrails
Do NOT build a real `PicSharp`/`functorial` (genuinely gated on D4′ — not this iter). Do NOT add typed-sorry
bridges or re-introduce local substrate duplications. Keep the file compiling with 0 local sorries (only the
upstream cone sorry remains). Cite, don't copy, upstream decls. This lane is bounded — comment/docstring
correctness only; if everything is fixed quickly, stop (do not invent new work).
