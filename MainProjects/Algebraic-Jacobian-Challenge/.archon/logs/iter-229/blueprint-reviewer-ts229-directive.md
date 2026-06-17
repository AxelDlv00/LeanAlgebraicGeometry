# blueprint-reviewer directive — ts229

Perform your standard WHOLE-blueprint audit (all chapters under
`blueprint/src/chapters/`). Per-chapter completeness + correctness checklist, plus the
unstarted-phase proposals section. Do NOT scope-limit — the cross-chapter view is the point.

## This iter's focus for the HARD GATE (one chapter needs a fresh verdict)

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` received writer edits this iter and is
the sole active prover lane. Confirm specifically whether the following are **complete + correct
enough to formalize**, since a prover (mode `mathlib-build`) will be dispatched at the new
shared-bridge block THIS iter if you clear it:

- **NEW** `lem:open_immersion_slice_sheaf_equiv` (`\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}`)
  — the shared open-immersion↔slice **sheaf-site equivalence** (completion of the Mathlib TODO
  `Topology/Sheaves/Over.lean:19-22`). This is the iter-229 prover target. Is its statement
  well-formed and its proof sketch (dense-subsite transfer via `IsDenseSubsite.sheafEquiv` /
  `Equivalence.sheafCongr`; `Opens X` thinness trivialising `Over.map` coherence; down-set
  identity `ι₊(ι⁻¹ V)=V`) detailed enough to formalize? Flag if the sketch is too thin.
- **CORRECTED** `lem:dual_isLocallyTrivial` proof body — the old "verbatim mirror closes via
  `restrictScalarsRingIsoDualEquiv`" claim was empirically false; the body should now route the
  post-H1 residual through `lem:open_immersion_slice_sheaf_equiv`. Confirm the corrected sketch is
  mathematically sound and no longer asserts the falsified discharge.
- **3 NEW helper blocks** (`def:presheaf_dual_precomp_equiv`, `def:presheaf_dual_iso_of_iso`,
  `def:scheme_modules_dual_iso_of_iso`) for the already-landed axiom-clean dual-iso helpers.
- **REFINED** `lem:sheafofmodules_hom_of_local_compat` proof sketch (A-engine) — now references the
  shared bridge + the `presheafHom`/`existsUnique_gluing`/`presheafHomSectionsEquiv`/`homMk` idiom.

## Note for your verdict

Several of these blocks carry forward `\lean{}` pins to not-yet-formalized declarations
(`overSliceSheafEquiv`, the three dual-iso helpers were landed but not yet pinned-then-synced).
A forward pin on an unbuilt target is acceptable for a prover-target block; flag only if a block
*claims* something formalized that is not, or if a proof sketch is too thin to guide formalization.

Report per your standard format (per-chapter checklist + must-fix-this-iter + unstarted-phase
proposals). Your `complete: true / correct: true` verdict on `Picard_TensorObjSubstrate.tex` with no
must-fix is what clears the gate for this iter's prover dispatch (same-iter fast path).
