# DAG Walker Directive

## Slug
tensorsubstrate-cover54

## Seed
`lem:pullback_compatible_with_tensorobj` (and the sibling public theorems of the
consolidated TensorObjSubstrate chapter: `lem:jw_ismonoidal`,
`lem:pullback0_tensor_iso`, `lem:pullback_tensor_map`,
`lem:pullback_tensor_iso_loctriv`, `lem:isinvertible_implies_locallytrivial`,
`thm:rel_pic_etale_sheaf_unit_canonical`).

These public theorems are the consumers; their Lean proofs invoke the 54 helper
declarations listed under "## Primary task". Walk UP from these seeds, but your
**concrete, exhaustive deliverable** is the explicit 54-helper list below — every
one must get a blueprint entry and be wired into the cone.

## Strategy context
The chapter `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the
consolidated A.1.c.SubT chapter; `% archon:covers` lines 3–7 of that file) is the
group-law substrate for the relative Picard sheaf: it constructs
`Scheme.Modules.tensorObj` (tensor of O-modules), its unit, dual, and the
pullback-monoidality comparisons that make `Pic_{C/k}` abelian-group-valued and
its structure maps group homomorphisms. The 54 helper declarations are the
internal categorical-coherence and adjunction infrastructure (change-of-rings
lax/oplax monoidal structure, sheafification–pullback comparison, dual-unit ring
swap, Picard setoid) that the public theorems rest on. They are currently
**uncovered Lean helpers** — they have NO blueprint entry, so `leandag` reports
them as 54 isolated `lean_aux` nodes that fragment the graph into ~20 components.
The user has explicitly asked (DAG_STATUS.md "USER REMARK") that these be
connected to the graph via correct dependencies, and that the 2 ∞-effort nodes
get informal proofs. Closing this restores 1-to-1 Lean↔blueprint coverage
(completeness criterion 5) and collapses the graph to one cone.

## Primary task — cover ALL 54 uncovered `lean_aux` declarations in ONE chapter
ALL 54 live in the two Lean files
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` and
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`, both already
`% archon:covers`-ed by `Picard_TensorObjSubstrate.tex`. Add every entry to THAT
chapter (do not create new chapter files).

For EACH of the 54:
1. **Read the Lean declaration as ground truth** (signature + proof body — you
   read Lean, never edit it). Render the statement as ordinary mathematical prose
   in the project's notation. These are mostly small coherence / naturality /
   adjunction-unit lemmas and a few structural definitions — keep statements
   precise but terse; a trivial helper gets a trivial one-sentence statement.
2. Give it a `\begin{lemma}` / `\begin{definition}` block with `\label{...}`,
   `\lean{<exact fully-qualified Lean name>}`, and a `\uses{...}` that
   **transcribes the dependencies its Lean proof actually invokes** (other
   helpers in this list, plus existing blueprint labels in the chapter). This
   `\uses{}` wiring is the whole point — it is what connects the node.
3. **Proof:**
   - For the **52 sorry-free helpers** (all except the two flagged ∞ below): a
     one-line `\begin{proof} Proved directly in Lean. \end{proof}` note (their
     `effort_local` is already 0; they need a statement + wiring, not a sketch).
   - For the **2 ∞-effort helpers** (flagged ⚠ below): write a genuine informal
     **mathematical** proof sketch (mate/pentagon coherence — see notes). The
     Lean formalisation is stuck on a kernel transport wall, but the *mathematics*
     is a standard coherence identity and is provable on paper; that paper proof
     is what the blueprint needs, independent of the Lean obstruction.
4. **Wire the consumers.** When an existing public-theorem block in the chapter
   (the seeds above) has a Lean proof that invokes one of these helpers, add the
   helper's new label to that block's `\uses{}`. This is the edge that pulls the
   helpers into the goal cone. Do NOT remove existing `\uses{}` entries.

If a near-matching block already exists with a wrong/stale `\lean{}`, correct the
`\lean{}` rather than creating a duplicate.

### Group A — `TensorObjSubstrate/DualInverse.lean` (14)
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap`
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom`
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv`
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv_comp_dualUnitRingSwap`
- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_comp_dualUnitRingSwapInv`
- `AlgebraicGeometry.Scheme.Modules.image_preimage_of_le`
- `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso`
- `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom`
- `AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso`
- ⚠ `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv` — **∞, needs a real proof sketch**
- `AlgebraicGeometry.Scheme.Modules.topSectionToHom`
- `AlgebraicGeometry.Scheme.Modules.topSectionToHom_app`
- `PresheafOfModules.dualUnitIsoGen`
- `PresheafOfModules.unitDualSectionEquiv`

### Group B — `TensorObjSubstrate.lean` (40)
- `AlgebraicGeometry.Scheme.Modules.W_of_isIso_sheafification`
- `AlgebraicGeometry.Scheme.Modules.extendScalars`
- `AlgebraicGeometry.Scheme.Modules.extendScalarsAdjunction`
- `AlgebraicGeometry.Scheme.Modules.forget_map_pushforward_map`
- `AlgebraicGeometry.Scheme.Modules.forget₂_restrictScalars_μ_hom_tmul`
- `AlgebraicGeometry.Scheme.Modules.isIso_pbu_of_final`
- `AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`
- `AlgebraicGeometry.Scheme.Modules.isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`
- `AlgebraicGeometry.Scheme.Modules.isIso_sheafify_tensorHom_pullbackValIso`
- `AlgebraicGeometry.Scheme.Modules.picInv`
- `AlgebraicGeometry.Scheme.Modules.picMul`
- `AlgebraicGeometry.Scheme.Modules.picSetoid`
- `AlgebraicGeometry.Scheme.Modules.pullback0`
- `AlgebraicGeometry.Scheme.Modules.pullback0Adjunction`
- `AlgebraicGeometry.Scheme.Modules.pullbackComp_δ`
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnitIso`
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnitIso_hom`
- `AlgebraicGeometry.Scheme.Modules.pullbackSheafifyUnitEtaTriangle`
- `AlgebraicGeometry.Scheme.Modules.pullbackValIso`
- `AlgebraicGeometry.Scheme.Modules.pushforwardComp_lax_μ`
- `AlgebraicGeometry.Scheme.Modules.pushforward_map_restrictScalars_μ_app_tmul`
- `AlgebraicGeometry.Scheme.Modules.pushforward_μ_eq`
- `AlgebraicGeometry.Scheme.Modules.pushforward₀IsRightAdjoint`
- `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE`
- `AlgebraicGeometry.Scheme.Modules.restrictScalarsId_map`
- `AlgebraicGeometry.Scheme.Modules.restrictScalarsIsRightAdjoint`
- `AlgebraicGeometry.Scheme.Modules.restrictScalars_μ_app`
- `AlgebraicGeometry.Scheme.Modules.restrictScalars_μ_app_tmul`
- `AlgebraicGeometry.Scheme.Modules.sheaf_unit_comp_pushforward_pullbackComp_inv`
- `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp`
- ⚠ `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail` — **∞, needs a real proof sketch**
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso`
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_eq`
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_eq'`
- `AlgebraicGeometry.Scheme.Modules.sheafifyUnitIso`
- `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso`
- `AlgebraicGeometry.Scheme.Modules.tensorObj_middleFour`
- `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso`
- `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk`
- `AlgebraicGeometry.Scheme.Modules.toRingCatSheafHom_comp_hom_reconcile`

## Notes on the two ∞ helpers (write real sketches)
- `sheafificationCompPullback_comp_tail`: the residual "tail" identity in the
  proof that the sheafification–pullback comparison iso
  `sheafificationCompPullback` respects composition `h ≫ f`. Mathematically it is
  the naturality/coherence of the comparison 2-cell against the pseudofunctor
  associator (a pentagon for `pullback (h ≫ f) ≅ pullback h ∘ pullback f` composed
  with the sheafification unit). Read the Lean to see exactly which leg is the
  "tail", and sketch it as: distribute the comparison over the composite, apply
  the adjunction-unit naturality and the `pullbackComp` associator coherence, and
  cancel the matching mate cells. Cite the chapter's own
  `lem:pullback_tensor_map` / pullback-comp coherence blocks via `\uses{}`; this is
  internal categorical coherence (no external reference required — mark
  `\textit{Source: internal categorical coherence (no external reference).}`).
- `sliceDualTransportInv`: the inverse of the slice/dual transport equivalence
  `sliceDualTransport` (which moves the dual of an O-module across the
  slice-reindexing `restrictScalars`/`over` equivalence). Mathematically its
  inverse is built by conjugating the forward transport's restrict-scalars and
  dual-unit ring-swap isos in the opposite direction; sketch it as: invert each
  leg (the Beck–Chevalley reindex along `f.opensFunctor` and the
  `restrictScalarsRingIsoDualEquiv` leg) and compose in reverse order, using the
  `dualUnitRingSwap`/`dualUnitRingSwapInv` cancel pair (also in this list) as the
  unit/counit. Wire `\uses{}` to the forward `sliceDualTransport` block (if it
  exists in the chapter) and to the `dualUnitRingSwap*` helpers. Internal
  coherence, no external reference.

## Depth / scope
- **In scope:** the 54 helpers above + wiring their consumers, ALL inside
  `Picard_TensorObjSubstrate.tex`. Stay in that one chapter for new blocks.
- **Out of scope / do NOT touch:** any other chapter; any `.lean` file; the
  `% SOURCE QUOTE` comment blocks (leave verbatim); the chapter's existing
  protected-content prose. Do NOT add `\leanok` (the deterministic sync_leanok
  phase owns it). Do NOT spawn children that also write
  `Picard_TensorObjSubstrate.tex` (they would clobber each other) — do all the
  chapter edits yourself, sequentially. A `reference-retriever` child is allowed
  only if some helper genuinely needs an external source (none is expected — these
  are internal categorical-coherence facts).

## References
- The chapter already carries its external citations (Kleiman §2 for the
  group-law motivation). The 54 helpers are **internal categorical coherence /
  change-of-rings monoidal structure / adjunction infrastructure** — they are
  "proved directly in Lean" facts or internal coherence sketches, so they need NO
  new external `references/` source. Use
  `\textit{Source: internal categorical coherence (no external reference).}` where
  a Source line is wanted. Do not fabricate citations.

## Verification before reporting
Re-run `archon dag-query unmatched --json` (or `leandag focus`) and confirm the 54
TensorObjSubstrate-family `lean_aux` nodes are gone (every one now matched by a
blueprint `\lean{}`), and `leandag show isolated` no longer lists them. Report the
before→after isolated/lean-aux counts and the ∞-node count (should drop 2→0 once
the two sketches land).
