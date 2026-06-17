# Blueprint-clean Report — iter-246 (ts246)

**File:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`  
**Section:** `sec:tensorobj_pullback_monoidality`

## Blocks reviewed

### `lem:isiso_pullbacktensormap_of_sheafifydelta` (NEW block)

**Lemma statement:** Clean. `\label{}`, `\lean{}`, `\uses{lem:pullback_tensor_map}` all correctly formatted. No `% SOURCE` placeholder — correctly absent (Archon-original categorical bookkeeping, no external source required; confirmed).

**Proof:** One issue found and fixed. The proof's final paragraph read:

> "This lemma is the shared entry point for the whole loc-triv route: every downstream target D2$'$–D4$'$, and the invertible-pair conclusion `\(\mathtt{IsInvertible.pullback}\)`, reduces through it to the single goal `\(\mathtt{IsIso}\,(a_Y.\mathrm{map}\,\delta\,\dots)\)` on the sheafified presheaf comparison. It is project-bespoke categorical bookkeeping over the already-established sheafification devices, so it carries no external source quote."

This is entirely project-history meta-commentary ("the loc-triv route", D2$'$–D4$'$ internal labels, "project-bespoke") and a self-referential citation disclaimer. **Removed in full.** The proof closes correctly after the preceding mathematical sentence ("A composite of isomorphisms is an isomorphism, so `\(\mathtt{pullbackTensorMap}\,f\,M\,N\)` is an isomorphism.").

### `lem:pullback_tensor_iso_unit` (D2$'$, refined proof sketch)

**Lemma statement:** Clean. `\label{}`, `\lean{}`, `\uses{}` all correctly formatted.

**Proof:** Two Lean-tactic leakages found and fixed.

1. **"definitionally"** (Lean elaboration jargon):
   > "…using that the structure-sheaf unit values…are *definitionally* the presheaf monoidal unit \(\mathbf{1}\)."

   Replaced with:
   > "…noting that the structure-sheaf unit values…*coincide with* the presheaf monoidal unit \(\mathbf{1}\)."

2. **"rewrites"** (tactic verb):
   > "\(\mathtt{Functor.OplaxMonoidal.left\_unitality\_hom}\) *rewrites* \(\delta\,...\) as a composite of…"

   Replaced with:
   > "\(\mathtt{Functor.OplaxMonoidal.left\_unitality\_hom}\) *expresses* \(\delta\,...\) as a composite of…"

   The Lean identifier is retained (appropriate in a formalization blueprint); only the tactic-flavored verb is changed.

The opening sentence was also rephrased from tactic-flavored "reduces the goal from iso-ness of X to iso-ness of Y" to standard mathematical phrasing "it suffices to verify that…".

## Untouched items (as instructed)

- All `\leanok` and `\mathlibok` markers: not modified.
- `% NOTE:` record-only blocks (D3$'$ abandoned-route note at lines 3355–3359, etc.): not modified.

## Summary

Three targeted edits applied. The section now reads as timeless mathematical prose with no project history, tactic language, or citation disclaimers. Citation discipline confirmed: the new block carries no `% SOURCE` placeholder, which is correct.
