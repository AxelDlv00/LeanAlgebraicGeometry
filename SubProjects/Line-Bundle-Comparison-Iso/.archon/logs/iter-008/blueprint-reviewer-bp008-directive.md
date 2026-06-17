# Blueprint-reviewer directive — iter-008

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Per-chapter
complete/correct checklist + which proofs lack detail + whether `\lean{}` targets are well-formed.

This is the HARD-GATE check for the consolidated chapter `Picard_TensorObjSubstrate.tex`
(`% archon:covers` TensorObjSubstrate.lean + StalkTensor + Vestigial + DualInverse +
DualInverse/SliceTransport + PresheafInternalHom).

Specific items to confirm this iter (active prover lanes depend on them):
- The 3 newly-authored D3′ bricks — `lem:sheafify_pullbackcomp_hom_inv_cancel`,
  `lem:sheafify_tensor_unit_iso_comp` (Sq3), `lem:pullback_val_iso_comp` (Sq4) — are their
  informal proofs detailed enough to scaffold + formalize? Are their `\uses{}` accurate?
- The DUAL `lem:slice_dual_transport_inv` block: a prior per-file checker flagged it omits the
  `hβ` ring-compatibility hypothesis the Lean signature carries (major), a stale `% NOTE:` naming
  a non-existent helper `restrictScalarsLaxε`, and a missing 4th leg `unitRelabelSwap`. Confirm.

Also surface any unstarted-phase blueprint proposals and the usual per-chapter verdicts.
