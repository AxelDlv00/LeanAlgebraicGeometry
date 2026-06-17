# AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

## Summary
- **Declarations added (4, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `PresheafOfModules.stalkTensorDescU_smul` (line ~109) — section-level scalar
    compatibility of the per-neighbourhood descent.
  - `PresheafOfModules.stalkTensorDesc_germ` (line ~177) — element form of
    `germ_stalkTensorDesc` (for a general section, not just a tmul).
  - `PresheafOfModules.stalkTensorLinearMap` (line ~187) — **THE iter-234 convergence
    probe: stage (iii), the `R.stalk x`-linear repackaging of the forward comparison map.**
  - `PresheafOfModules.stalkTensorLinearMap_germ_tmul` (line ~213) — germ-tmul
    characterisation of the linear map (cheap; for stage (v) / downstream).
- **Declarations blocked (0 attempted-and-failed):** none. Stopped at the *next* stage
  (iv, the reverse map), which is a large independent construction — see "Why I stopped".
- **Sorry count:** 0 → 0 (file is fully axiom-clean; `lake env lean` exit 0, no warnings).

## PROBE RESULT: `stalkTensorLinearMap` LANDED ✅ (axiom-clean)
The iter-234 binary convergence probe asked: *does `stalkTensorLinearMap` land this iter?*
**Yes.** Stage (iii) is complete. The carrier-duality obstacle flagged in PROGRESS
(CommRingCat `R(U)` scalar vs the RingCat-carrier module on `A(U) ⊗ B(U)`) was the real
work and is now **resolved** (see below). This distinguishes the d.2 lane decisively from
the old dual-route stall: a concrete, named obstacle was identified and closed, eliminating
the route's stated risk.

## `stalkTensorDescU_smul` (line ~109)
- **Statement:** `stalkTensorDescU A B x U hx (r • z) = germ_R r • stalkTensorDescU A B x U hx z`
  for `r : R(U)`, `z : (A ⊗ᵖ B)(U)`.
- **Approach:** `TensorProduct.induction_on z`.
  - `tmul a b`: `erw [stalkTensorDescU_tmul, stalkTensorDescU_tmul, germ_smul A x U hx]`
    then `exact (TensorProduct.smul_tmul' _ _ _).symm`. **KEY:** the section smul
    `r • (a ⊗ₜ b)` is *defeq* to `(r • a) ⊗ₜ b`, so `erw [stalkTensorDescU_tmul]` matches
    `descU (r • (a⊗b))` directly through reducible defeq — no explicit `smul_tmul'` rewrite
    is needed (and `rw [smul_tmul']` FAILS on instance synthesis — do not use it).
  - `add p q hp hq`: `erw [smul_add]` (pulls the raw-`TensorProduct` smul via defeq), then
    `refine (map_add _ _ _).trans ?_; rw [hp, hq, ← smul_add]; exact congrArg _ (map_add _ p q).symm`.
  - `zero`: `simp only [presheaf_obj_coe, Functor.comp_obj, CommRingCat.forgetToRingCat_obj,
    Monoidal.tensorObj_obj, map_zero, smul_zero]; exact map_zero _` — the residual
    `descU (r • 0) = 0` closes because `r • 0` is **defeq** `0` (so `exact map_zero _` fires).
- **Result:** RESOLVED — axiom-clean.
- **CARRIER-DUALITY GOTCHAS (load-bearing, record for any future stalk-tensor work):**
  1. `stalkTensorDescU_tmul` is stated with `⊗ₜ[R.obj (op U)]` (CommRingCat coe) but the
     actual section tensor is `⊗ₜ[↑((R ⋙ forget₂ _ _).obj (op U))]` (RingCat coe). These are
     defeq but NOT syntactic → use **`erw`**, never `rw`, for `stalkTensorDescU_tmul`.
  2. After `TensorProduct.induction_on`, `z` is re-presented as a raw `TensorProduct ↑S ..`
     (`S = (R ⋙ forget₂).obj (op U)`), whose smul lemmas (`smul_tmul'`, `smul_zero`,
     `smul_add`) want scalar type `↑S`, but the lemma's `r : ↑(R.obj (op U))` (CommRingCat).
     They are defeq but instance synthesis / `rw` keyed-matching FAILS. The working route is
     **defeq via `erw`** (tmul/add) or **defeq via `exact ... map_zero` / `smul_zero`** (zero).
  3. `map_add`/`map_zero` do NOT `rw`-match `ConcreteCategory.hom g (x+y)` / `... 0`, but DO
     work via `refine (map_add _ _ _).trans` / `exact map_zero _` (unification/term mode).
     The cocone proof of `stalkTensorDesc` already used `AddMonoidHom.map_add _ p q` term-form.

## `stalkTensorDesc_germ` (line ~177)
- **Approach:** `rw [← CategoryTheory.comp_apply, germ_stalkTensorDesc]` (mirrors the existing
  `stalkTensorDesc_germ_tmul`, generalised to an arbitrary section `w`).
- **Result:** RESOLVED — axiom-clean.

## `stalkTensorLinearMap` (line ~187)
- **Statement:** `(A ⊗ᵖ B).stalk x →ₗ[R.stalk x] (A.stalk x ⊗_{R.stalk x} B.stalk x)`,
  `toFun := ConcreteCategory.hom (stalkTensorDesc A B x)`.
- **Approach (mirrors d.1 `stalkLinearMap` map_smul', Vestigial.lean ~398–426):**
  `map_smul' r ξ`: `germ_exist` both `r = germ_R r₀` and `ξ = germ_{A⊗B} z`; pass to the
  common neighbourhood `W = U ⊓ V` via `germ_res_apply`; then
  `rw [hr, hz, ← germ_smul (tensorObj A B) x W hxW, stalkTensorDesc_germ,
       stalkTensorDescU_smul, ← stalkTensorDesc_germ]`.
  The chain: combine the two germs into `germ_W (r₀' • z')` (← germ_smul), descend
  (`stalkTensorDesc_germ`), pull the scalar (`stalkTensorDescU_smul`), re-ascend.
- **Result:** RESOLVED — axiom-clean. This is the stage-(iii) deliverable.

## Why I stopped
**Real progress: 4 axiom-clean declarations added** (named above), closing stage (iii) of
`lem:stalk_tensor_commutation` — the iteration's stated convergence probe. The hard part
was the carrier-duality, now fully diagnosed and solved (recipe above).

I stopped at the **stage (iv) reverse map** because it is a large independent construction,
not because a step was hard, and not at a sorry:
- The reverse map `A_x ⊗_{R_x} B_x → (A ⊗ᵖ B).stalk x` is built by `TensorProduct.lift` of an
  `R_x`-bilinear map out of the **two** stalk colimits (`germ a, germ b ↦ germ_{U∩V}(a|⊗b|)`)
  — a *nested* `colimit.desc` with `R_x`-bilinearity and cocone-compatibility obligations
  (~150–250 LOC, blueprint stage (iv)).
- **No Mathlib shortcut exists:** searched `TensorProduct.directLimit` / `Module.DirectLimit`
  tensor-commutation — ABSENT. So there is no "tensor commutes with filtered colimit" lemma to
  cite; the descent must be built from `TopCat.Presheaf.stalk` (categorical colimit in
  `AddCommGrpCat`) by hand.
- Under **mathlib-build (no sorry pins)** a half-built reverse map is not committable, so the
  rational committable stopping point is stage (iii) complete. Stage (iv) is the natural unit
  of the *next* prover dispatch.

## Precise handoff — stages (iv)/(v)
1. **Stage (iv) reverse map** `stalkTensorRev : Tgt →ₗ[R.stalk x] (A ⊗ᵖ B).stalk x`.
   - Build the `R.stalk x`-bilinear `revBilin : A.stalk x →ₗ B.stalk x →ₗ (A⊗ᵖB).stalk x`
     by descending each factor: `revBilin (germ_U a) (germ_V b) := germ_{U⊓V}((a|)⊗(b|))`.
     Mechanise via two nested `colimit.desc`s (or `TopCat.Presheaf.stalk` germ-universal-property);
     well-definedness = filteredness of the neighbourhood system; `R_x`-bilinearity reduces to
     `germ_smul`. Then `stalkTensorRev := TensorProduct.lift revBilin`.
   - **Reuse the carrier-duality recipe above verbatim** — the same CommRingCat/RingCat coe
     and `erw`/defeq tactics will be needed when computing `germ_smul`/`tmul` at section level.
2. **Stage (v) bundle** `stalkTensorIso` (blueprint `\lean{PresheafOfModules.stalkTensorIso}`):
   - Forward = `stalkTensorLinearMap` (DONE), reverse = stage (iv).
   - `stalkTensorLinearMap ∘ rev = id` on `germ a ⊗ germ b` by `stalkTensorLinearMap_germ_tmul`
     (DONE) + `TensorProduct.induction_on`.
   - `rev ∘ stalkTensorLinearMap = id` on `germ_{A⊗B}(a⊗b)` by the same characterisation; extend
     by `stalk_hom_ext` (germ joint-epi) + `TensorProduct.induction_on` on each section.

## Blueprint note (for plan/review — provers don't touch markers)
- `lem:stalk_tensor_commutation` §`sec:tensorobj_stalk_tensor` stage (iii) prose names
  `stalkTensorLinearMap`; it is now FORMALIZED and could carry its own `\lean{}` pin
  (e.g. a `lem:stalk_tensor_linear_map` block) — suggest the plan agent add it. The existing
  forward pin `lem:stalk_tensor_desc_forward` (`\lean{stalkTensorDesc}`) is unchanged.
- `stalkTensorLinearMap`, `stalkTensorDescU_smul`, `stalkTensorDesc_germ`,
  `stalkTensorLinearMap_germ_tmul` are all ready for `\leanok` (handled by `sync_leanok`).

## Structural note (honoured)
Kept `StalkTensor.lean` import-minimal (`import Mathlib` only). Did NOT import `Vestigial`;
mirrored d.1 `stalkLinearMap`'s germ-representative pattern rather than importing it
(preserving the consumer-wiring direction Vestigial → StalkTensor).
