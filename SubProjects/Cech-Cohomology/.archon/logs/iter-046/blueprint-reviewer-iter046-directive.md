# blueprint-reviewer directive — iter-046 (HARD GATE re-clear of the active prover chapter)

You always read the WHOLE blueprint — do that. This directive only tells you which chapter gates this
iter's prover dispatch, so your per-chapter verdict on it is the one I act on.

## Active prover chapter (the HARD GATE target)

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — backs the only prover lane this iter,
`AlgebraicJacobian/Cohomology/QcohTildeSections.lean`, whose target is `lem:tile_section_localization`
(the final keystone-feeding leaf of Route B).

## What changed this iter (so you can re-confirm, not re-derive)

1. **Coverage-debt blocks added** — three general-open companions of existing `V=⊤` lemmas:
   `lem:modulesRestrictBasicOpen_smul_eq_genV`, `lem:tile_section_ring_identity_genV` (its `\lean{}`
   bundles the two private wrappers `appIso_inv_res`/`appIso_inv_res_assoc`), and
   `lem:tile_scalar_compat_genV` (the `V=D(\bar f)` scalar-tower compat, the keystone sub-need).
2. **`lem:tile_section_localization` Step 4/5 rewritten** — the previous prose prescribed installing a
   module structure + scalar tower on a common underlying section type (an instance-installation recipe
   that proved to be a dead Lean-engineering approach, W1–W3). The rewrite frames Step 4 as the
   restriction of scalars along \(R\to R_g\) of the Step-2 \(R_g\)-localisation, citing
   `lem:tile_scalar_compat` (\(V=\top\)) and `lem:tile_scalar_compat_genV` (\(V=D(\bar f)\)); Step 5 is
   the base-ring descent `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`.

## The question to answer (HARD GATE)

For `Cohomology_CechHigherDirectImage.tex`, is `lem:tile_section_localization` (and the supporting
companions it now cites) **complete** and **correct** — a well-formed, formalisable target whose proof
sketch does NOT misdirect the prover into a wrong construction? Specifically:
- Do the new companion blocks have accurate statements, `\lean{}` pins, `\uses{}`, and one-line proofs?
- Is the rewritten Step 4/5 mathematically sound and free of the removed dead-approach recipe?
- Any broken `\ref{}`/`\uses{}` among the new labels (`*_genV`)?
Report your per-chapter checklist; flag any must-fix-this-iter finding on this chapter explicitly.
