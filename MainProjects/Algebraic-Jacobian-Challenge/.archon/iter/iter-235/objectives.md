# Iter-235 objectives detail

## Lane 1 (ACTIVE prover) — `Picard/TensorObjSubstrate/StalkTensor.lean` — d.2 stage (iv)

Mode: mathlib-build. Blueprint: `Picard_TensorObjSubstrate.tex` §`sec:tensorobj_stalk_tensor`,
stages (iv) reverse map + (v) bundle. Stage (iii) `stalkTensorLinearMap` DONE iter-234 (axiom-clean),
now pinned `lem:stalk_tensor_linear_map` (writer `d2-linmap`, blueprint-clean PASS).

Goal: build the reverse map `stalkTensorRev : A_x ⊗_{R_x} B_x →ₗ[R.stalk x] (A⊗ᵖB).stalk x`, then
(if reached) the bundle `stalkTensorIso`. Precise recipe from the iter-234 prover handoff:
- `revBilin : A.stalk x →ₗ B.stalk x →ₗ (A⊗ᵖB).stalk x`, `revBilin (germ_U a) (germ_V b) :=
  germ_{U⊓V}((a|_{U⊓V}) ⊗ (b|_{U⊓V}))`. Two nested `colimit.desc` (or `TopCat.Presheaf.stalk` germ
  universal property); well-definedness = filteredness of the neighbourhood system; `R_x`-bilinearity
  reduces to `germ_smul` + the stage-(iii) `stalkTensorDescU_smul` carrier-duality recipe (REUSE the
  `erw`/defeq tactics verbatim — same CommRingCat/RingCat coe at section level).
- `stalkTensorRev := TensorProduct.lift revBilin`.
- Stage (v) bundle (if reached): forward = `stalkTensorLinearMap`, reverse = `stalkTensorRev`;
  `stalkTensorLinearMap ∘ rev = id` on `germ a ⊗ germ b` via `stalkTensorLinearMap_germ_tmul` (DONE) +
  `TensorProduct.induction_on`; `rev ∘ stalkTensorLinearMap = id` on `germ(a⊗b)` via the same
  characterisation + `stalk_hom_ext` (germ joint-epi) + `TensorProduct.induction_on` per section.

Mathlib note (verified by iter-234 prover): `TensorProduct.directLimit` / `Module.DirectLimit`
tensor-commutation is ABSENT — there is NO "tensor commutes with filtered colimit" lemma to cite; the
descent is built by hand from `TopCat.Presheaf.stalk` (categorical colimit in `AddCommGrpCat`).

Structural note (preserve): keep `StalkTensor.lean` import-minimal (`import Mathlib` only). Do NOT
import `Vestigial`; mirror d.1 `stalkLinearMap`'s germ-representative pattern (the consumer-wiring
direction is Vestigial → StalkTensor; preserve acyclicity).

mathlib-build invariant: no sorry pins — each step fully proved or absent. Go as far as possible; if
stage (iv) does not fully bundle, hand off a precise decomposition (do NOT fragment into more
sub-`stalkTensorDescU`-style helpers — the convergence critic flagged that as the failure mode to avoid;
the unit is the reverse map as a whole).

## Lane 2 — `Cohomology/FlatBaseChange.lean` — NO PROVER THIS ITER (STUCK corrective)

progress-critic ts235 ruled this lane STUCK (4 helpers / 3 iters, 0 sorry eliminated, iter-234
zero-commit on an instance wall the prover called both blocking AND insufficient). Per the must-fix
corrective, the prover slot is replaced by the `mathlib-analogist fbc-dict` consult (element-free
Γ-fragment handle + QC-of-pushforward existence). Next prover round is gated on the consult's findings
(+ a blueprint expansion of the full affine dictionary if the consult confirms the downstream bricks
are genuinely Mathlib-absent).
