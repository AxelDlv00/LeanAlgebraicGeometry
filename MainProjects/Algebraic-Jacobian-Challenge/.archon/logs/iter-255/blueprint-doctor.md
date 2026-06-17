# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Picard_LineBundleCoherence.tex` covers `AlgebraicJacobian/Picard/LineBundleCoherence.lean`, which does not exist

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `\uses{\leanok
    thm:relative_pic_quotient_well_defined}` — no matching `\label`

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- `\uses{\leanok
        lem:islocallyinjective_whiskerleft_via_stalk}` — no matching `\label`
- `\uses{\leanok
        lem:leftadjointuniq_app_unit_eta}` — no matching `\label`
- `\uses{\leanok
        lem:sheafify_tensor_unit_iso_natural}` — no matching `\label`
- `\uses{\leanok
        lem:tensorobj_assoc_iso_invertible}` — no matching `\label`
- `\uses{\leanok
        lem:tensorobj_comm_iso}` — no matching `\label`

