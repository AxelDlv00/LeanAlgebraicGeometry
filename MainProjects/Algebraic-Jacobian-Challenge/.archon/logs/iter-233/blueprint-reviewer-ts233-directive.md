# Blueprint-reviewer directive — iter-233 (whole-blueprint audit)

Audit the WHOLE blueprint as usual (per-chapter checklist + completeness/correctness).

Two chapters feed LIVE prover lanes this iter and are the HARD-GATE priorities — give
them your most careful per-chapter verdict:

1. **`Picard_TensorObjSubstrate.tex`** — rewritten last iter around the carrier pivot
   to tensor-invertibility. The prover lane will SCAFFOLD + PROVE the new group-law
   declarations on the `IsInvertible` carrier:
   - `def:scheme_modules_isinvertible` (`IsInvertible`, already in Lean),
   - `def:pic_carrier` (`PicGroup`),
   - `lem:isinvertible_tensor` (`IsInvertible.tensorObj`),
   - `lem:isinvertible_unit` (`isInvertible_unit`),
   - `lem:isinvertible_inverse_welldef` (`IsInvertible.inverse_unique`),
   - `lem:tensorobj_assoc_iso_invertible` (`tensorObj_assoc_iso_invertible`),
   - `thm:pic_commgroup` (`picCommGroup`).
   Verify: are these blocks complete + correct, with rigorous proof sketches a prover
   can formalize? Is the associator-on-invertible-modules argument (invertible ⟹
   locally free rank 1 ⟹ flat, so the clean flat-whiskering lemmas apply, bypassing
   the flatness-free whiskering sorry) spelled out and sound? Is the demotion of the
   dual / `dual_restrict_iso` / `exists_tensorObj_inverse` apparatus to a deferred
   bridge consistent (no live group-law block still \uses the dual)?

2. **`Cohomology_HigherDirectImage.tex`** — written last iter as the next engine seed.
   The prover lane will SCAFFOLD the matching new Lean file `Cohomology/HigherDirectImage.lean`
   (currently the blueprint-doctor flags this chapter as covering a non-existent file).
   Verify completeness + correctness so it can back a scaffolding+prove lane.

For both: report complete (true/false) + correct (true/false) + any must-fix-this-iter
findings. Also report your usual whole-blueprint findings and any unstarted-phase proposals.
