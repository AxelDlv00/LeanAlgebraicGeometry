# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-252 (Lane TS-cmp)

## sheafifyTensorUnitIso_hom_natural (STEP A, the critical-path D1′ helper)

### Attempt 1 — whisker252 `letI instMS` recipe (the directive's de-risk)
- **Approach:** Per `analogies/whisker252.md`: add `letI instMS := inferInstanceAs (…forget₂…)` at the
  top, then run the whisker calculus (`whisker_exchange`/`comp_whiskerRight`/`whiskerLeft_comp`) with
  `erw [Category.assoc]` join-bridges to merge the cross-group crossing.
- **Result:** FAILED — and this is the directive's **REVERSING SIGNAL**, confirmed by direct
  `lean_multi_attempt` testing (not inferred):
  - `← MonoidalCategory.tensorHom_def` does NOT fold the η-whiskers even with `letI instMS` in scope:
    the η-whiskers (from `sheafifyTensorUnitIso_hom_eq`) carry `PresheafOfModules.monoidalCategoryStruct`
    while `tensorHom_def` keys to `monoidalCategory.toMonoidalCategoryStruct` (a defeq-but-non-syntactic
    projection).
  - `← whisker_exchange` fires ONLY within a single-instance group (the `p ⊗ₘ q` group A and the
    pushforward group A′), and **cannot bridge the cross-group crossing** `P'◁q ≫ η_{P'}▷Q'` — NOT
    even via `erw` (keyed-defeq): tested `erw [← whisker_exchange ×3]` fired only once.
  - The `letI instMS` is **inert here** (the η-whiskers come from a separate `:= rfl` lemma whose
    instance is baked in at that lemma's elaboration, so a `letI` in *this* proof does not retype them)
    and is **actively harmful at the section level** (it forces the `Sheaf.val`-carrier `tensorHom` to
    a `_aux` literal). **Removed it.** whisker252's core diagnosis ("letI unifies the instances") is wrong.

### Attempt 2 — section/component route (the structural rethink) — **MAJOR PARTIAL, COMMITTED**
- **Approach:** Drop the presheaf whisker identity (after `rw [sheafifyTensorUnitIso_hom_eq] ; ←map_comp ;
  congr 1`) to the component level via `refine PresheafOfModules.Hom.ext (funext fun U => ?_)`, where the
  whisker/instance abstraction dissolves. Verified sub-steps (all via `lean_multi_attempt`):
  1. `simp only [MonoidalCategory.whiskerLeft, MonoidalCategory.whiskerRight, comp_app,
     Monoidal.tensorHom_app, tensorHom_def, Category.assoc]` — unfolds whiskers to `Monoidal.tensorHom`
     and **fully distributes the `forget₂`-carrier legs** (`p ⊗ₘ q`, pushforward) via `tensorHom_def`.
  2. The η-group legs live over the `Sheaf.val X.ringCatSheaf` carrier (codomain `(aP).val` of η), which
     is defeq-but-not-syntactic to `_ ⋙ forget₂ CommRingCat RingCat`, so `comp_app`/`tensorHom_app` (head-keyed)
     do NOT fire there under `simp` — **but `erw` (keyed-defeq) DOES**. `erw [comp_app ×4, tensorHom_app ×6]`
     distributes every η-group `.app U`, landing a pure ModuleCat interchange.
  3. The ModuleCat `⊗ₘ` from `tensorHom_app` carries `ModuleCat.MonoidalCategoryStruct.tensorHom`, which
     the abstract `tensorHom_comp_tensorHom`/`tensorHom_id` do NOT key to (verified rw/erw both miss).
     So `apply ModuleCat.hom_ext ; ext x` dissolves fully to a linear-map-on-element goal — **no monoidal
     instance remains**.
- **Result:** PARTIAL — the open `sorry` is now a **concrete, instance-free element-level ModuleCat
  tensor identity** (`x : (P ⊗ Q).obj U`), a dramatic reduction from the instance-blocked whisker monster
  (the 5-iter `.val`/forget₂ churn). The committed proof body runs through `Hom.ext → simp → erw → hom_ext
  → ext x → sorry` and **compiles**.
- **Key insight:** the blocker was never "an instance-term split fixable by `letI`"; it is the pervasive
  `Sheaf.val` vs `_ ⋙ forget₂ CommRingCat RingCat` carrier-spelling that (a) splits `monoidalCategoryStruct`
  vs `monoidalCategory.toStruct` at the whisker level AND (b) blocks the section `_app` lemmas. The only
  robust dissolution is to go to **elements** (`ModuleCat.hom_ext ; ext x ; TensorProduct.induction_on`),
  where no instance survives. `erw` is the carrier-spelling bridge throughout.
- **CONCRETE NEXT STEP (mechanical, instance-free):** `induction x using TensorProduct.induction_on`
  (zero/add via `map_zero`/`map_add` on the bundled `ModuleCat.Hom.hom`; tmul `m n` via the
  `ModuleCat.MonoidalCategory` tmul-evaluation lemmas), then close with the sectionwise η-naturality
  `(sheafificationAdjunction (𝟙 …)).unit.naturality p`/`q` read off at `.app U` on `m`/`n` (after a
  `restrictScalarsId_map` strip). NOTE: `simp`/`simp only [map_add]` did NOT auto-fire on the bundled
  `ModuleCat.Hom.hom (…) 0`/`(…) (a+b)` — the next iter must feed the right `ModuleCat.Hom.hom`-application
  / `map_zero`/`map_add` lemmas explicitly.

## pullbackTensorMap_natural (STEP B / D1′)
- NOT attempted this iter (gated on Step A, which still carries the reduced element-level sorry). The
  4-square assembly plan (merge `a_Y.map δ ≫ S3 ≫ S4` into `a_Y.map Ψ`, move S1 by NatTrans naturality,
  discharge via `δ_natural` + `pullbackValIso_hom_natural` (CLOSED) + Step-A output) is unchanged and
  still valid once Step A's element-level residual closes.

## STEP C (D3′) / STEP D (D4′)
- Not reached.

## Required cleanup (done)
- Updated the stale module-docstring "ONE tracked typed-sorry" claim (L43) → "THREE tracked residuals"
  with the real list.
- Removed the duplicate scratch comment block (former L1822-1824, superseded by L1825-1835).

## Summary
- **sorry count: 3 → 3** (unchanged COUNT, but Step A's sorry is now a fully-reduced, instance-free
  element-level residual instead of the instance-blocked whisker identity — substantial code progress).
- Sorries closed: none.
- Sorries still open: `exists_tensorObj_inverse` (~L699, guardrailed — untouched); `sheafifyTensorUnitIso_hom_natural`
  (reduced to element-level ModuleCat tmul residual); `pullbackTensorMap_natural` (D1′, gated on the helper).
- Adjacent sorries: did not touch `exists_tensorObj_inverse` (guardrail). Did not attempt D1′ (gated).

## Why I stopped
**Partial progress (real code).** I did NOT close Step A, but I converted its proof from the documented
5-iter-churn instance-blocked whisker identity into a committed, compiling proof body that mechanically
reduces (via `Hom.ext → simp → erw[comp_app/tensorHom_app] → ModuleCat.hom_ext → ext x`) to a concrete,
**instance-free** element-level ModuleCat tensor identity. Every reduction step was verified live with
`lean_multi_attempt`. This is the directive's requested "structural rethink" — the whisker route is
provably blocked (I disproved the whisker252 `letI` de-risk by direct testing, satisfying the reversing
signal), and the element-level route is the genuine dissolution of the `.val`/forget₂ carrier friction.
The remaining work is mechanical `TensorProduct.induction_on` + η-naturality bookkeeping (no instance war
left), which I ran out of budget to finish — the `map_zero`/`map_add`/tmul-evaluation lemma plumbing on
the bundled `ModuleCat.Hom.hom` is the next concrete task. I stopped here rather than thrash further on
the same goal in one session.

## For the planner / next prover
- Step A is **de-risked and reduced**, not blocked: finish the element-level `TensorProduct.induction_on`
  close (recipe + exact next lemmas documented in the in-proof comment at the `sorry` and above).
- The `erw [comp_app ×4, tensorHom_app ×6]` carrier-bridge idiom and `MonoidalCategory.whiskerLeft/Right`
  whisker-unfold-to-`tensorHom` trick are new, reusable tools for ANY `Sheaf.val`-carrier sectionwise goal
  in this file (D3′ will hit the same friction).
- Do NOT re-try the whisker252 `letI` whisker route — verified dead this iter.
