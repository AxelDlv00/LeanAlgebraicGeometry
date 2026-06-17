# Lean ↔ Blueprint Check Report

## Slug
tos-iter265

## Iteration
265

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`)
- **Lean target exists**: yes (line 2771)
- **Signature matches**: yes — the four-factor equality `pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv ≫ (pullback h).map (pullbackTensorMap f) ≫ pullbackTensorMap h (f^*M) (f^*N) ≫ tensorObjIsoOfIso (pullbackComp h f)_M (pullbackComp h f)_N .hom` in the Lean signature is word-for-word the blueprint display (lines 3912–3919).
- **Proof follows sketch**: partial — proof is sorry'd, but the setup (`simp only [pullbackTensorMap, tensorObjIsoOfIso]; rw [Functor.map_comp×3]; simp only [Category.assoc]; sorry`) faithfully opens the four-square composition-coherence paste described by the blueprint proof. The sorry is explicitly labeled as a known, tracked in-progress obligation ("race-safe: file compiles; `DualInverse.lean` imports it").
- **\leanok marker**: `\leanok` appears in the statement block at line 3897 — correct per blueprint vocabulary (sorry present). No `\leanok` on the proof block — correct (proof not closed).
- **Notes**: No excuse-comments; sorry is properly scoped and the proof comment gives a detailed 4-square roadmap aligned with the blueprint's Sq1/Sq2/Sq3/Sq4 description.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`, line 3730)
- **Lean target exists**: yes (line 1603)
- **Signature matches**: yes — `sheafificationCompPullback f.toRingCatSheafHom = (A.comp B).leftAdjointUniq C`, matching the blueprint statement exactly.
- **Proof follows sketch**: yes — proved by `rfl` as the blueprint predicts ("The equality therefore holds by reflexivity").
- **\leanok marker**: blueprint has `\leanok` in statement block (line 3732) — consistent (sorry-free axiom-clean proof in Lean). Proof block has no `\leanok` — that is a **minor gap** (should receive `\leanok` on the proof block since the proof is closed). This gap is the `sync_leanok` infrastructure's job to fix, not a prover error.
- **Notes**: Axiom-clean, correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app}` (chapter: `lem:leftadjointuniq_app_unit_eta_general`, line 3810)
- **Lean target exists**: yes (line 1668)
- **Signature matches**: yes — `A.homEquiv P _ (sheafCompPb f .hom.app P) = PrPbPushAdj φ'.unit P ≫ pushforward φ'.map (sheafAdj_Y.unit (pullback φ' P))`, matching the blueprint exactly.
- **Proof follows sketch**: yes — proved axiom-clean via `Adjunction.homEquiv_leftAdjointUniq_hom_app` + `Adjunction.comp_unit_app` + `rfl`.
- **\leanok marker**: blueprint has `\leanok` in statement block (line 3810) — consistent (sorry-free in Lean). Same minor proof-block `\leanok` gap as above.
- **Notes**: This is the key R1/R5-recovery brick for `sheafificationCompPullback_comp_tail`; it was the "iter-264 step-1 brick" and is now fully landed and wired in.

---

## Iter-265 specific focus: `forget_map_pushforward_map` bridge and `sheafificationCompPullback_comp_tail` residual

### New bridge `forget_map_pushforward_map` (Lean line 2511)
- **Blueprint reference**: no `\lean{...}` tag (it is `private`, acceptable). The blueprint's binding-obligation paragraph (lines 4143–4157) describes the needed compatibility in prose: `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget`, calling it "the natural unit to isolate as its own named sub-lemma before the assembly."
- **Lean implementation**: proved by `rfl` — it is definitional (`SheafOfModules.pushforward` is built sectionwise from `PresheafOfModules.pushforward`, and `forget` is the `.val` projection).
- **Wiring**: consumed via `erw [forget_map_pushforward_map]` at line 2605 inside `sheafificationCompPullback_comp_tail`. The contamination-free ordering (`conv_rhs` to distribute first, then `rw [Functor.map_comp]` plain to split the first factor, then `erw` for the sheaf↔presheaf bridge) is correctly recorded in the proof comment.
- **Blueprint adequacy**: the binding-obligation paragraph correctly identifies the compatibility but does **not** say it is definitional / provable by `rfl`. A prover reading only the blueprint would not know the easiest route. This is a **minor blueprint adequacy gap** in proof-sketch depth for this sub-obligation.

### `sheafificationCompPullback_comp_tail` (Lean line 2536, still sorry'd)
- **Blueprint reference**: not `\lean{...}`-tagged (private); the 5-step plan (a)–(e) in the blueprint's "Reduced tail goal" section (lines 4106–4168) is the authoritative description.
- **Status**: `forget_map_pushforward_map` (STEP d) is now wired in. Landing this iter: `restrictScalarsId_map` strip (step a), `conv_rhs => rw [Functor.map_comp]` distribution (step b prep), `erw [forget_map_pushforward_map]` (step d crossing), `rw [Functor.map_comp]` split of first factor (step e.0). The sorry now sits at exactly the R1/R5 recovery point.
- **Remaining residual**: recover `forget.map R1` and `forget.map R5` as `B_f.unit.app P` and `B_h.unit.app P` via `leftAdjointUniqUnitEta_app`, then slide `(SheafOfModules.pushforwardComp h f).hom` past them by `.hom.naturality`, and collapse by `Adjunction.comp_unit_app + unit_naturality`. The Lean comment (lines 2628–2637) identifies the precise blocker: building the intermediate `have` that reframes `forget.map ((pullback h).map (sheafCompPb f .app P).hom)` through the f-adjunction `homEquiv` is the genuinely novel step, as the model's `unitToPushforwardObjUnit` was `rfl`-based but the present one is not.
- **Blueprint adequacy for this step**: the blueprint step (c) says "Apply `leftAdjointUniqUnitEta_app` to rewrite R1 as B_f.unit.app P and R5 as B_h.unit.app (PrPb_f P)." This is directionally correct but undersells the difficulty: it doesn't explain that the raw goal carries `forget.map R1` (not `A.homEquiv R1`), so a `have`-reframing step is needed before `leftAdjointUniqUnitEta_app` can fire. This is a **minor blueprint adequacy gap** in the step-(c) proof sketch.

### `sheafificationCompPullback_comp` (Lean line 2651, private, NOT sorry'd in its own body)
- The outer lemma reduces to `exact sheafificationCompPullback_comp_tail h f P` at line 2748 after the R0-peel. The lemma itself has no additional sorry beyond the delegated tail. The proof structure is consistent with the blueprint Sq1 description.

---

## Red flags

### Placeholder / suspect bodies
- `sheafificationCompPullback_comp_tail` at line 2536: body ends with `:= sorry` (line 2638). Per blueprint vocabulary this is a *known tracked sorry* — NOT a placeholder on a claim the blueprint marks as proven. The blueprint's `\leanok` on the Sq1 lemma's statement (line 3897) correctly reflects only that `pullbackTensorMap_restrict` exists with a sorry, not that the proof is closed.
- `pullbackTensorMap_restrict` at line 2771: body ends with `sorry` (line 2866). Same classification: known tracked sorry, correctly reflected by `\leanok` statement-only, no `\leanok` on proof block. **Not a must-fix**.
- `exists_tensorObj_inverse` at line 698: body is `sorry`. Pre-existing tracked sorry, out of scope for this iter.

No surprise sorries, no excuse-comments, no weakened-wrong definitions, no unauthorized axioms found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no corresponding `\lean{...}` blueprint tag but are significant infrastructure:
- `forget_map_pushforward_map` (line 2511) — new iter-265 bridge; private. Blueprint describes its content in prose but does not name it.
- `sheafificationCompPullback_comp` (line 2651) — private Sq1 outer lemma; blueprint describes as a named "project sub-lemma" without a `\lean{...}` pin.
- `sheafificationCompPullback_comp_tail` (line 2536) — private extracted tail; blueprint describes the 5 steps without naming the Lean lemma.

All three are `private` — absence of `\lean{...}` pins is architecturally appropriate.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 public `\lean{...}`-pinned declarations verified present in Lean with matching signatures. Private helpers have no pins (by design).
- **Proof-sketch depth**: **under-specified** in two places:
  1. Binding obligation paragraph (lines 4143–4157): describes `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget` but does not state that it is definitional. A prover encounters an `erw`-required proof step in `sheafificationCompPullback_comp_tail` for this compatibility and needs to know it reduces to `rfl` — the blueprint is silent on proof strategy here.
  2. Step (c) of the tail (lines 4128–4133): says to apply `leftAdjointUniqUnitEta_app` but does not mention that the raw goal has `forget.map R1` (not `A.homEquiv R1`), so a `have`-reframing through the adjunction `homEquiv` is required before the brick fires. The Lean comment (line 2628) identifies this as "the genuinely-novel sheafification-laden mate step with no existing project lemma."
- **Hint precision**: precise — `\lean{...}` tags name exact fully-qualified Lean identifiers.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  - In the binding-obligation paragraph, add a sentence: "This compatibility is definitional — `SheafOfModules.pushforward` is built sectionwise from `PresheafOfModules.pushforward`, so the equality holds by `rfl`. Name this `forget_map_pushforward_map`."
  - In step (c) of the tail, add: "Note that the raw goal has `forget.map R1` rather than `A.homEquiv R1`, so an intermediate `have` reframing through `homEquiv` (using `Adjunction.homEquiv_naturality_left` on the pullback map of `sheafCompPb f .hom.app P`) is needed before `leftAdjointUniqUnitEta_app` can fire."

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor** (2):
  1. Blueprint binding-obligation paragraph lacks `rfl` hint and Lean name for `forget_map_pushforward_map`. A prover reading only the blueprint cannot directly see the route.
  2. Blueprint step (c) of the tail assembly understates the `have`-reframing requirement before `leftAdjointUniqUnitEta_app` fires.

**Overall verdict**: Lean and blueprint are well-aligned for an in-progress iter — the new `forget_map_pushforward_map` bridge is correctly proved (`rfl`) and wired into the tail, the remaining R1/R5 recovery sorry is properly scoped and documented, and all `\leanok` markers are accurate. Two minor blueprint adequacy gaps (missing `rfl` hint for the bridge, underspecified `have`-reframing in step c) are the only findings.
