# Directive: lean-vs-blueprint-checker — TensorObjSubstrate, iter-208

## Scope (exactly one file pair)

- Lean file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter

The prover (Lane TS, "Route A") added ONE verified reduction step to
`tensorObj_restrict_iso` (now at L330; sorry body around L399): it strips the
outer sheafification via
`(PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).mapIso ?_`, reducing
the goal to the presheaf-level residual
`(PresheafOfModules.pullback φ.hom).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.
No sorry was closed (3 → 3 in this file).

The prover reported that the blueprint's **Step 3** of the proof of
`lem:tensorobj_restrict_iso` — a "sectionwise unfolding of
`PresheafOfModules.pullback` (~30–60 lines)" — is INCORRECT and not formalizable
as written, because that pullback is the opaque abstract left adjoint of
pushforward (no sectionwise formula). The genuine route needs two Mathlib-absent
ingredients H1 (presheaf-level `pushforward β ≅ pullback φ` via
`leftAdjointUniq`) and H2 (strong-monoidal `restrictScalars` along the ring iso).

A `% NOTE:` was already added by the review agent to the proof block flagging
this.

## Your task

Report bidirectionally:

1. **Lean → blueprint**: Does the Lean (the three formalized reduction steps +
   the named residual sorry + the in-code corrected H1/H2 analysis comment) match
   the chapter? Flag any `\lean{...}` name mismatch, any decl in the chapter not
   present in the Lean, any placeholder/fake statement.

2. **Blueprint → Lean**: Is the chapter now adequate to guide the residual
   formalization, GIVEN the new `% NOTE:`? Specifically: is Step 3 + the closing
   "30–60 line helper" paragraph still asserting the disproven sectionwise route
   in its main prose (i.e. does the chapter need a blueprint-writer rewrite of
   Step 3 to the H1/H2 decomposition)? Treat "blueprint prose still asserts a
   disproven proof route despite the NOTE" as a must-fix.

3. Confirm the statement-block `\leanok` on `lem:tensorobj_restrict_iso` is
   legitimate (the `def` exists with a sorry body — statement-level leanok is
   correct; proof-block has no leanok).

Output your standard per-file checklist + must-fix / major / minor blocks to
`task_results/lean-vs-blueprint-checker-ts-iter208.md`.
