# Blueprint-writer directive — `Picard_TensorObjSubstrate.tex`: carrier pivot to tensor-invertibility

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (edit ONLY this chapter).

## Strategy context (the slice that matters)
The relative Picard group law on iso-classes of line bundles has been STUCK for 14 iters
because the group was being carried on the *locally-trivial* predicate, which forces
constructing an inverse object (the internal-hom dual + `dual_restrict_iso`, or cocycle
gluing) — that construction (`exists_tensorObj_inverse`) is the stuck work.

**DECISION (this iter): carry `Pic X` on the tensor-invertibility predicate instead.** The
Lean file already defines (do NOT change it):
`IsInvertible M := ∃ N, Nonempty (tensorObj M N ≅ 𝒪_X)`. On this carrier the inverse is the
membership witness — FREE, no inverse object to manufacture. This dissolves the stall.

## Required new content — the invertibility-carrier group law

Add a NEW named section building the abelian group structure on iso-classes of invertible
`𝒪_X`-modules. Provide rigorous textbook-level prose. Declaration blocks needed (give each a
`\label{}`, a `\lean{...}` pin with the expected Lean name, and a `\uses{}` list; the prover
will create the Lean decls later):

1. `\definition{def:pic_carrier}` — `Pic X` := the type of iso-classes (a `Quotient` by the
   "exists an iso" setoid) of pairs `{M : X.Modules // IsInvertible M}`. Expected Lean name
   e.g. `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (you choose a clean name).
2. `\lemma{lem:isinvertible_tensor}` — `IsInvertible M → IsInvertible M' → IsInvertible (M ⊗ M')`
   (closure; witness `N ⊗ N'` via the associator + braiding). 
3. `\lemma{lem:isinvertible_unit}` — `IsInvertible 𝒪_X` (witness `𝒪_X`, via `tensorObj_unit_iso`).
4. `\lemma{lem:isinvertible_inverse_welldef}` — if `M⊗N≅𝒪` and `M⊗N'≅𝒪` then `N≅N'`
   (the chain `N ≅ N⊗𝒪 ≅ N⊗(M⊗N') ≅ (N⊗M)⊗N' ≅ 𝒪⊗N' ≅ N'`, using unitors/associator/braiding).
   This makes the inverse operation well-defined on iso-classes.
5. `\theorem{thm:pic_commgroup}` — `Pic X` is an abelian group: `mul = ⊗`, `one = [𝒪_X]`,
   `inv [M] = [N]` (the membership witness), with
   - `one_mul`/`mul_one` from the unitors (`tensorObj_left_unitor`/`tensorObj_right_unitor`),
   - `mul_comm` from the braiding (`tensorObj_braiding`),
   - `mul_assoc` from the associator (see block 6),
   - `mul_left_inv` from the witness iso `M⊗N≅𝒪` (no construction).
   Expected Lean name e.g. `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}`.

6. `\lemma{lem:tensorobj_assoc_iso_invertible}` — the associator
   `(M⊗N)⊗P ≅ M⊗(N⊗P)` **restricted to invertible (hence locally-free, hence flat) modules**.
   IMPORTANT mathematical note for the prose: the existing general-`M` associator
   `tensorObj_assoc_iso` is sorry-transitive through the flatness-FREE whiskering lemmas
   (`W_whiskerLeft_of_W` → `isLocallyInjective_whiskerLeft_of_W`, an open project sorry). For
   INVERTIBLE modules, each factor is locally free of rank 1 ⟹ flat, so the **flat**-whiskering
   lemmas (`W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`, which are sorry-clean) apply
   instead, bypassing the open sorry. State the associator for the flat/invertible case and
   note this routing in the proof prose.

## Demote (do NOT delete) the dual / C-bridge blocks
The existing blocks `lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`,
`rem:dual_discharges_inverse`, the `Scheme.Modules.dual` definition, and
`exists_tensorObj_inverse` are now OFF the group's critical path. Add a short prose note at the
top of the dual section stating they constitute the **deferred `IsInvertible ⟺ IsLocallyTrivial`
bridge** (Stacks 0B8M: an invertible module is locally free of rank 1, and conversely), needed
only when a downstream consumer specifically requires the locally-trivial form — NOT for the
group law. Keep the blocks intact for that future use.

## Also fix (reviewer must-fix, light touch)
- In the `lem:sheafofmodules_hom_of_local_compat` proof (≈L3173–3176), REMOVE the false claim
  that the C-bridge (`lem:dual_isLocallyTrivial`) shares `lem:open_immersion_slice_sheaf_equiv`
  as a common root. (iter-230 empirically falsified this; the C-bridge is presheaf-level over
  the varying ring `𝒪(V)`.) Replace with a one-line correct statement that the A-engine uses
  the sheaf-site equivalence while the C-bridge uses the per-open slice comparison.

## Out of scope (do NOT do)
- Do NOT add the `lem:dual_unit_iso` block or the per-`V` slice-equivalence block (the reviewer
  flagged them, but they belong to the now-DEFERRED dual bridge — leave them for the bridge iter).
- Do NOT edit any other chapter.
- Do NOT add `\leanok`/`\mathlibok` markers.

## Sources
- `references/stacks-modules.tex` — invertible modules (search tags 0B8M, 01CX, 0B8K): the
  definition of an invertible `𝒪_X`-module and `Pic(X)`. Add `% SOURCE:`/`% SOURCE QUOTE:`
  verbatim from this file for the carrier definition and the invertible⟺locally-free fact.
- You have `references/**` in your write-domain — if you need a source you lack, a child
  reference-retriever may fetch it; otherwise quote only what is on disk.
