# Iter-238 objectives detail

## Lane 1 (CRITICAL PATH) — `Picard/TensorObjSubstrate.lean` — the by-hand Picard `CommGroup`

**Mode: mathlib-build.** Build the relative Picard group law on the tensor-invertibility carrier,
bottom-up. All ingredients are axiom-clean and in-file: unitors (`tensorObj_left_unitor`,
`tensorObj_right_unitor`, `tensorObj_unit_iso`), braiding (`tensorObj_braiding`), the now-sorry-free
**unconditional** associator (`tensorObj_assoc_iso`), bifunctoriality (`tensorObjIsoOfIso`),
`IsInvertible`, and the unit object `SheafOfModules.unit X.ringCatSheaf`.

Blueprint: `Picard_TensorObjSubstrate.tex`, sections `sec:tensorobj_invertibility` +
`sec:tensorobj_pic_carrier` (~L2280–2932). Reviewer ts238: group-law section complete + correct,
proof sketches adequate for hand formalization, `\uses{}` DAG confirmed. HARD GATE CLEARS.

### Steps (in dependency order)
0. **Drop the vestigial hyps from `tensorObj_assoc_iso`** (L341). The decl is UNPROTECTED and its body
   no longer consumes `hM/hN/hP : IsLocallyTrivial` (review iter-237 confirmed `hM/hN/hP` unused). Change
   the signature to `{M N P : X.Modules}` with no hypotheses, matching the blueprint
   `lem:tensorobj_assoc_iso` (framed unconditional) and enabling the invertible corollary. Fix any
   caller (none currently passes the hyps; `tensorObj_isLocallyTrivial` does not call it).
1. **`tensorObj_assoc_iso_invertible`** (blueprint `lem:tensorobj_assoc_iso_invertible`): for
   `M N P : X.Modules` with `IsInvertible`, `(M⊗N)⊗P ≅ M⊗(N⊗P)`. Immediate from the now-unconditional
   `tensorObj_assoc_iso` (arguments' invertibility unused). Suggested name as pinned.
2. **`PicGroup`** (blueprint `def:pic_carrier`): the quotient type of iso-classes of invertible modules.
   `Invertible X := {M : X.Modules // IsInvertible M}`; setoid `M ∼ M' := Nonempty (M ≅ M')` (refl/symm/
   trans from iso compose/invert); `PicGroup X := Quotient` of that setoid.
3. **`IsInvertible.tensorObj`** (blueprint `lem:isinvertible_tensor`): `IsInvertible M → IsInvertible M'
   → IsInvertible (tensorObj M M')`. Witness `N ⊗ N'` (the two membership witnesses); the contraction
   `(M⊗M')⊗(N⊗N') ≅ (M⊗N)⊗(M'⊗N') ≅ 𝒪⊗𝒪 ≅ 𝒪` via `tensorObj_assoc_iso_invertible` + `tensorObj_braiding`
   + `tensorObjIsoOfIso` (substitute witnesses) + `tensorObj_unit_iso`. All as `Nonempty (… ≅ …)`.
4. **`isInvertible_unit`** (blueprint `lem:isinvertible_unit`): `IsInvertible (SheafOfModules.unit
   X.ringCatSheaf)`. Witness `𝒪_X`; iso = `tensorObj_unit_iso` (`𝒪⊗𝒪 ≅ 𝒪`).
5. **`IsInvertible.inverse_unique`** (blueprint `lem:isinvertible_inverse_welldef`): `M⊗N ≅ 𝒪 → M⊗N' ≅ 𝒪
   → Nonempty (N ≅ N')`, via the inverse-of-inverse chain `N ≅ N⊗𝒪 ≅ N⊗(M⊗N') ≅ (N⊗M)⊗N' ≅ 𝒪⊗N' ≅ N'`
   (unitors + braiding + `tensorObj_assoc_iso_invertible` + `tensorObjIsoOfIso`). Then the inverse class
   `[M] ↦ [witness]` is well-defined on `PicGroup`.
6. **`picCommGroup`** (blueprint `thm:pic_commgroup`, pinned `\lean{...picCommGroup}`):
   `CommGroup (PicGroup X)`. mul `[M]·[M'] := [M⊗M']` (well-defined via `Quotient.lift₂` + bifunctoriality
   `tensorObjIsoOfIso`; lands in `Invertible` by step 3); one `[𝒪_X]` (step 4); inv via the membership
   witness (well-defined by step 5). The four axioms (`mul_assoc`, `one_mul`/`mul_one`, `mul_comm`,
   `mul_left_inv`/`inv` law) each discharged by `Quotient.ind` + a single existence-of-iso
   (`tensorObj_assoc_iso_invertible`, the unitors, `tensorObj_braiding`, the witness iso). No pentagon /
   triangle / hexagon / `MonoidalCategory` is invoked.

### Constraints
- mathlib-build: no sorry pins — each decl fully proved or absent; if step 6 is too large to finish,
  land steps 0–5 axiom-clean and hand off a precise decomposition of the `CommGroup` field proofs.
- Do NOT touch the StalkTensor d.2 build (done) or the deferred dual-bridge sorries (L695/L760).
- Do NOT touch `Cohomology/FlatBaseChange.lean` (a different, deferred lane this iter).
- The whiskering decls in Vestigial.lean are done — do not modify.

## Lane 2 (DEFERRED this iter) — `Cohomology/FlatBaseChange.lean`
progress-critic ts238 = **STUCK** (sorry 2→2→2 across K=4; smul carrier wall at its 3rd location;
iter-237 hard commitment missed). Corrective = blueprint expansion of `lem:pushforward_spec_tilde_iso`
(element-free `D(a)`-level transport recipe + 3 helper `\lean{}` blocks) — dispatched this iter
(blueprint-writer `fbcdax` + blueprint-clean). The prover is DEFERRED to next iter; the mandatory
next-iter blueprint-reviewer green-lights the expanded chapter, then the prover runs on the
fully-specified target (element-free `e_{D(a)}` + `IsLocalizedModule.of_linearEquiv` transport).
