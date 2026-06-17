# blueprint-writer directive — slug d2-sketch

## Chapter (the ONLY file you edit)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Strategy context (the slice that matters)
The relative-Picard group law is carried on tensor-invertibility (`IsInvertible`, inverse free).
Its sole remaining bottleneck is **d.2**, the varying-ring stalk–tensor commutation
`(A ⊗ᵖ B).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`, lemma `lem:stalk_tensor_commutation` in
§`sec:tensorobj_stalk_tensor`, formalized in `StalkTensor.lean`. iter-233 built the FORWARD
comparison map `PresheafOfModules.stalkTensorDesc` (axiom-clean) but NOT the full iso
`stalkTensorIso`. A per-file Lean↔blueprint check found the d.2 proof sketch is correct at the
math level but **under-specified for the remaining engineering steps** — a prover continuing the
d.2 build cannot read the staged construction off the current sketch.

## Required edits (all additive — do NOT alter any existing statement or `% SOURCE`/`% SOURCE QUOTE` block)

1. **Expand the proof sketch of `lem:stalk_tensor_commutation`** into explicitly NAMED sub-steps,
   in this order, matching the Lean construction direction:
   (i) per-neighbourhood `R(U)`-balanced bilinear map `A(U) × B(U) → A_x ⊗_{R_x} B_x` and its
       descent to the section-level map `(A ⊗ᵖ B)(U) → A_x ⊗_{R_x} B_x` (DONE — `stalkTensorBilin`,
       `stalkTensorDescU`);
   (ii) the colimit descent to the FORWARD additive comparison map
        `stalkTensorDesc : (A ⊗ᵖ B).stalk x → A_x ⊗_{R_x} B_x` (DONE — `stalkTensorDesc`,
        characterised on germs of simple tensors by `stalkTensorDesc_germ_tmul`);
   (iii) `R_x`-LINEARITY packaging: upgrade the additive map to an `R.stalk x`-linear map
         `stalkTensorLinearMap`; note the **CommRingCat/RingCat carrier-duality obstacle** — the
         section tensor is a module over the `RingCat` carrier `(R ⋙ forget₂)(U)` while the natural
         scalar `r : R(U)` is the `CommRingCat` carrier, so `TensorProduct.smul_tmul'` only fires
         after a small `RingEquiv`/`eqToHom` bridge between the two carriers; once bridged it
         mirrors the existing d.1 `stalkLinearMap` germ-representative pattern;
   (iv) the REVERSE map `A_x ⊗_{R_x} B_x → (A ⊗ᵖ B).stalk x` built by the universal property of the
        tensor product out of the two stalks (an `R_x`-bilinear map `germ a, germ b ↦ germ_{U∩V}(a|⊗b|)`,
        a nested colimit descent out of two filtered colimits over the varying ring);
   (v) mutual inversion checked on germ generators: one composite is identity on `germ a ⊗ germ b`
       (via `stalkTensorDesc_germ_tmul`), the other on `germ_U(a⊗b)` via germ-jointly-epi
       (`stalk_hom_ext`) + `TensorProduct.induction_on`. Bundle as `stalkTensorIso`.
   Keep this prose mathematical (no Lean tactic strings; lemma/concept names as identifiers are fine,
   as the chapter already does).

2. **Add an intermediate `\lean{}` pin for the forward map** so the in-progress partial formalization
   is machine-readable. Add a short lemma/definition block titled "Forward stalk–tensor comparison
   map (d.2, partial)" with `\lean{PresheafOfModules.stalkTensorDesc}` and
   `\uses{def:scheme_modules_tensorobj}`, stating that there is a natural additive comparison map
   `(A ⊗ᵖ B).stalk x → A_x ⊗_{R_x} B_x` sending `germ_U(a ⊗ b) ↦ germ a ⊗ germ b`, and noting it is the
   forward half of `lem:stalk_tensor_commutation`. (Do NOT add any `\leanok`/`\mathlibok` marker — markers
   are managed by the deterministic sync, not by you.) Leave the existing `\lean{PresheafOfModules.stalkTensorIso}`
   pin on `lem:stalk_tensor_commutation` as-is; update its `% NOTE (iter-233)` to `% NOTE (iter-234)` only
   if you also refresh its text to match the expanded sub-step list (optional).

3. **Fix the associator-narration contradictions** flagged earlier (blueprint-clean iter-233, "Flags
   A/C/D"): consolidate the associator proof's description so it gives ONE coherent account that
   `tensorObj_assoc_iso`'s single open obligation `isLocallyInjective_whiskerLeft_of_W` closes via d.2
   (a `J.W`-morphism is a stalkwise iso, so `(F ◁ g)_x = id ⊗ g_x` is an iso); remove/repair any
   residual passage still calling the stalk apparatus "vestigial" or "not to be formalized" or
   describing the FALSE flat-restriction route as live; ensure `lem:stalk_linear_map` (d.1) is
   described as an ON-PATH ingredient of d.2, not as belonging to a "superseded route".

## Out of scope
- Do NOT touch the deferred dual-bridge blocks (`lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`,
  `lem:dual_unit_iso`, `exists_tensorObj_inverse`) — they stay as-is (off critical path).
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT edit any other chapter.

If you find you need a source you don't have, you are authorized to spawn a reference-retriever
(write-domain `references/**`); but the Stacks citation for `lem:stalk_tensor_commutation` is already
present and verbatim — no new source should be needed.
