# blueprint-writer report — iter-227 (slug tensorobj227)

Edited ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Three additive edits,
no `\leanok`/`\mathlibok` touched, no existing block modified or re-signed.

## Edit 1 — `archon:covers` annotation
Added at line 3, immediately after `\label{chap:Picard_TensorObjSubstrate}` (mirroring
`Picard_QuotScheme.tex` line 3):

    % archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Edit 2 — B-connector block (locally-iso ⇒ global iso)
New `lemma`+`proof` inserted inside `sec:tensorobj_dual_infra`, immediately BEFORE
`rem:dual_discharges_inverse` (was line ~2775).
- Label: `lem:isiso_of_isiso_restrict`
- Pin: `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (existing/closed Lean decl)
- `\uses{}`: none (standalone locality principle)
- Title: `[Local isomorphisms of O_X-modules glue to a global isomorphism]`
- Sketch names the Mathlib pieces: stalkwise iso-detection
  (`isIso_of_stalkFunctor_map_iso` on `TopCat.Sheaf`), restriction-commutes-with-stalks
  natural iso (`restrictStalkNatIso`), and reflection of isos along the forgetful functor
  `Scheme.Modules.toPresheaf`.

## Edit 3 — A-bridge block (SheafOfModules morphism descent)
Second new `lemma`+`proof`, placed right AFTER the Edit-2 block, still before
`rem:dual_discharges_inverse`.
- Label: `lem:sheafofmodules_hom_of_local_compat`
- Pin: `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (FORWARD pin — Lean decl
  does not yet exist; this is the prover's next target)
- `\uses{}`: none (omitted; cite of `lem:tensorobj_restrict_iso` not needed in the sketch)
- Title: `[Compatible local morphisms of O_X-modules glue to a global morphism]`
- Two-step sketch: (i) glue underlying ab-sheaf morphism via the hom-sheaf/descent
  principle (`Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv` in
  `CategoryTheory.Sites.SheafHom`) using faithful additive `SheafOfModules.toSheaf`;
  (ii) promote to O_X-linear by separatedness, packaged via `PresheafOfModules.homMk`.
  Explicit sentence noting this descent computes NO tensor stalk and so does not re-enter
  the abandoned tensor-stalk commutation.

## Reference-retriever
Not dispatched. The directive marked the Stacks "gluing morphisms of sheaves" citation
optional for these Archon-original infrastructure blocks; both blocks stand on their own
statement + sketch with the Mathlib primitives named in prose, so no `% SOURCE` lines were
added (consistent with their not-yet-/just-formalised infrastructure status).
