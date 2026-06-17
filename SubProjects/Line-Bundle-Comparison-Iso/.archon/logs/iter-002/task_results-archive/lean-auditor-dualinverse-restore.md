# Lean Audit Report

## Slug
dualinverse-restore

## Iteration
001

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L38–40 (module-level docstring)**: The file-opening docstring item 1b says "REMAINING (typed sorries, 4 of the `≃ₗ`-packaging fields): `naturality`, the reverse `invFun`, and its `left_inv`/`right_inv` round-trips." Since that was written, `invFun` has been moved out to the top-level `sliceDualTransportInv` and is no longer a sorry field in `sliceDualTransport` — it is concrete at L616. The actual distribution is now: 3 sorry fields inside `sliceDualTransport` (`naturality` L525, `left_inv` L627, `right_inv` L629) plus 1 sorry inside `sliceDualTransportInv` (`naturality` L388). Total count remains 4, matching the Known Issues section, but the *enumeration* in the module header is stale (lists `invFun` instead of the correct distribution). Minor staleness; no code is misdescribed — just the header inventory.
  - **L794 (dual_isLocallyTrivial docstring)**: References "Step-4 `isoMk` naturality sorry at ~L546"; actual line of that sorry is L525. ±21-line drift in an estimated reference. Minor only.
  - **L525 (`sliceDualTransport.toFun.naturality` sorry)**: Comment accurately identifies the obstacle — ε-naturality of `restrictScalars` along the structure ring iso requires an `erw`-level paste not yet assembled, and correctly distinguishes this from the trivial thin-poset `Subsingleton.elim` close. Honest.
  - **L388 (`sliceDualTransportInv.naturality` sorry)**: Comment accurately describes the remaining goal — the thin-poset naturality square for a 4-piece composite (eqToHom / restrictScalarsComp'App / ψ-reindex core / ε-swaps), contrasting it with the trivial base-map `Subsingleton.elim` that doesn't suffice. Explicitly mirrors the still-open forward `sliceDualTransport.naturality`. Honest.
  - **L627 (`sliceDualTransport.left_inv` sorry)**: Comment says "Blocked on (4)", i.e. on `invFun`/`sliceDualTransportInv`. Accurate: `left_inv` requires the round-trip `Iso.inv_hom_id` of `f.appIso` through `sliceDualTransportInv`, which itself still has an open sorry. The blocking chain is real.
  - **L629 (`sliceDualTransport.right_inv` sorry)**: Comment says "Blocked on (4), the `Iso.hom_inv_id` mirror of (5)." Same analysis as L627. Accurate.
  - **§C tail — `homLocalSection` (L861–910)**: Complete, axiom-clean declaration. The `naturality` field has a substantive tactic proof (eqToHom conjugation via `hsubM`/`hsubN`, reassoc, `Subsingleton.elim`). No sorry. Body matches docstring.
  - **§C tail — `topSectionToHom` (L918–926)**: Complete, clean one-liner delegating to `presheafHomSectionsEquiv`. No sorry. Docstring accurate.
  - **§C tail — `topSectionToHom_app` (L931–936)**: Complete, delegates to `presheafHom_map_app_op_mk_id`. No sorry. Docstring accurate.
  - **§C tail — `image_preimage_of_le` (L942–945)**: Clean utility lemma, short proof via `simp`/`inf_eq_right`. No sorry. Docstring accurate.
  - **§C tail — `homOfLocalCompat` (L1019–1188)**: The largest declaration. The in-body comment at L1080 ("no `sorry` remains in this declaration") is accurate — the body contains no sorry. The multi-step proof (step-i gluing, step-ii promotion via `homMk`, sectionwise linearity with the `hbridge`/`hfl_native` construction) is internally consistent. No dangling docstrings, no stand-in content.
  - **Nested comment pattern** (`dual_restrict_iso` L631–727, `dual_isLocallyTrivial` L787–837, `homOfLocalCompat` L947–1018): All three use the project-standard `/-- outer docstring /- planner strategy block -/ -/` nested comment form. Lean 4 supports nested comment delimiters; this is legitimate and intentional.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `DualInverse.lean:38–40` — Module-level docstring lists `invFun` as one of the 4 remaining sorry fields, but `invFun` is now concrete (delegated to `sliceDualTransportInv` at L616). The distribution should be updated to: `sliceDualTransport`: naturality, left_inv, right_inv; `sliceDualTransportInv`: naturality. Total count is unchanged at 4. Low-impact navigation drift.
- `DualInverse.lean:794` — Estimated line reference "~L546" for the `sliceDualTransport` naturality sorry is off by ±21 lines (actual L525). Cosmetic.

---

## Excuse-comments (always called out separately)

None found. All four sorry sites carry substantive descriptive comments that accurately characterize the open mathematical goal and its blocking dependencies. None contains language of the form "temporary", "placeholder", "wrong but works", or "TODO replace".

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The §C tail is internally consistent, axiom-clean, and free of fake or stand-in content; all four sorry sites carry honest goal descriptions that accurately reflect the open mathematical work.
