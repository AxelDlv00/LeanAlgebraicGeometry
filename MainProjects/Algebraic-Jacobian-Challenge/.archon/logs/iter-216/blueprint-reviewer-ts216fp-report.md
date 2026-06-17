# Blueprint Review Report

## Slug
ts216fp

## Iteration
216

## Scope
Fast-path scoped re-review: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(gate decision for `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`).

---

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_compatible_with_tensorobj`: no `\lean{...}` hint.
  The lemma is on the critical path (`thm:rel_pic_addcommgroup_via_tensorobj` uses it) and the
  prover needs a Lean target name.

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_restrict_iso` proof block: `\uses{}`
  omits `lem:restrictscalars_ringiso_tensorequiv`, which the proof body explicitly uses as its
  H2-closed ingredient (Step 3, line ~603).

### Citation discipline

- `Picard_TensorObjSubstrate.tex` / `lem:restrictscalars_ringiso_tensorequiv`:
  `\uses{lem:tensorobj_restrict_iso}` is **backwards / circular**. This is a purely algebraic
  lemma (ring isomorphism `e: R ≅ S`, modules over fixed rings — no schemes, no open immersions).
  It does **not** logically depend on the sheaf-level `lem:tensorobj_restrict_iso`. The correct
  relationship is the reverse: `lem:tensorobj_restrict_iso` uses
  `lem:restrictscalars_ringiso_tensorequiv` as an ingredient, not the other way around. The
  circular `\uses{}` creates a formal dependency loop in the blueprint graph and is a hard error.

---

## Directive checklist (five specific checks)

**Check 1 — Direct-gluing associator proof adequacy.**
The proof of `lem:tensorobj_assoc_iso` (lines 1263–1349) is mathematically adequate for
formalization. Key elements are all present:

- Local composites on each cover member `{U}` are defined: two applications of
  `lem:tensorobj_restrict_iso` at front and back, with the presheaf-level associator
  `PresheafOfModules.monoidalCategoryStruct.associator` in the middle.
- Overlap compatibility: argued by naturality of the restriction-compatibility comparison and
  of the presheaf associator; the local composites on `U` and `U'` agree on `U ∩ U'`.
- Hom-sheaf gluing: explicitly invoked ("the internal hom of sheaves of O_X-modules is itself
  a sheaf…"), both for the morphism and its local inverses, to obtain the global isomorphism.
- The locally-trivial hypotheses in the pinned Lean statement are flagged as vestigial.

Minor presentation issue: the two applications constituting the "first arrow" are listed in
the reverse order of their logical composition (the text says "first (M⊗N)|_U ≅ M|_U⊗N|_U
tensored with P|_U, then ((M⊗N)⊗P)|_U ≅ (M⊗N)|_U ⊗ P|_U" — the second bullet is actually
applied before the first in the chain). This is a writing ambiguity, **not** a mathematical
error, and a prover familiar with the notation will resolve it. No must-fix.

**Check 2 — Free-cover make-or-break coherence and H1 flagging.**
The make-or-break framing in the proof of `lem:tensorobj_restrict_iso` (lines 640–661) is
coherent:

- The general case (arbitrary M, N) requires the presheaf-level pushforward adjunction H1
  (`pushforward β ≅ pullback φ`), and H1 is **honestly flagged Mathlib-absent** (only the
  sheaf-level `SheafOfModules.pushforwardPushforwardAdj` exists; the presheaf-level
  `pushforwardNatTrans` and `pushforwardCongr` are absent at the pinned commit).
- The free-cover specialisation (where M, N restrict to free O_U-modules on the trivialising
  cover the associator uses) is claimed to avoid H1: on free pieces, sheaf-⊗ = presheaf-⊗
  (sheafification is the identity on already-sheafy free modules), so the comparison reduces
  to base change along the ring isomorphism `f.appIso`, handled by
  `lem:restrictscalars_ringiso_tensorequiv` alone.

This argument is *plausible* and *directionally correct*, though slightly implicit about
the precise Mathlib API for "sheafification is identity on free sheaves." A prover will
likely need to supply this step via `SheafOfModules.ext` or a similar completeness criterion,
but the sketch is adequate for dispatch.

The fallback (revert to route-(e) if the free case also needs H1) is honestly named.

**Check 3 — CommGroup by-hand framing.**
`lem:tensorobj_isoclass_commgroup` is correctly reframed as a by-hand `CommGroup` (lines
1710–1789):

- Four axioms, each discharged by a single `Nonempty(⋯ ≅ ⋯)` proposition.
- **Explicitly states it does NOT go through `monoidOfSkeletalMonoidal` or `Skeleton`** (line
  1743): "those constructions require a coherent [MonoidalCategory]… precisely the coherent
  monoidal category on Scheme.Modules X… that this construction explicitly avoids."
- `CommRing.Pic` is cited only as an analogous design template, not as a route.
- The fallback via `lem:jw_ismonoidal` / `LocalizedMonoidal` is mentioned as an alternative,
  clearly subordinate.

No leftover claim that reuses Skeleton over X.Modules. ✓

**Check 4 — No internal contradiction between superseded and live route.**
The seven superseded route-(e)/whiskering/stalk blocks are all preceded by a visible
"Superseded route — off path, not to be formalized" banner, and the live direct route never
invokes them. No mathematical contradiction exists.

Two minor observations (non-blocking):
- `lem:islocallyinjective_whisker_of_W` and `lem:isiso_sheafification_map_of_W` carry
  `\leanok` markers despite being marked superseded. These markers are managed by
  `sync_leanok` and reflect the current Lean state; they will be cleaned up when the
  declarations are removed. Not a blueprint error.
- `rem:scheme_modules_monoidal_off_path` declares `\uses{…, lem:whisker_of_W}` (a superseded
  lemma). This is intentional informational context describing what route-(e) would require;
  it does not represent a proof dependency of any live lemma.

**Check 5 — Four open sorries have adequate proof sketches.**

| Sorry | Blueprint block | Verdict |
|---|---|---|
| `tensorObj_restrict_iso` | `lem:tensorobj_restrict_iso` Steps 1–3 + make-or-break | Adequate — H1 residual correctly scoped, free-cover case sketched |
| `exists_tensorObj_inverse` | `lem:tensorobj_inverse_invertible` lines 1461–1474 | Adequate — dual of rank-1 is rank-1 affine-locally; contraction iso concrete |
| `addCommGroup_via_tensorObj` | `thm:rel_pic_addcommgroup_via_tensorobj` lines 1909–1969 | Adequate — QuotientAddGroup construction detailed, sub-lemmas named |
| To-be-deleted whiskering sorry | `lem:islocallyinjective_whisker_of_W` (superseded) | Adequate — blueprint labels block for deletion, not proof |

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:restrictscalars_ringiso_tensorequiv` declares `\uses{lem:tensorobj_restrict_iso}` —
    **circular / backwards**. This algebraic lemma (ring isomorphism, fixed-ring modules) has
    zero logical dependence on the sheaf-level `lem:tensorobj_restrict_iso`. The dependency
    arrow must be reversed: remove the `\uses{}` here, and add
    `lem:restrictscalars_ringiso_tensorequiv` to the proof-block `\uses{}` of
    `lem:tensorobj_restrict_iso`. Until fixed, the blueprint-doctor's graph contains a formal
    cycle on the critical path. **must-fix-this-iter**
  - `lem:pullback_compatible_with_tensorobj` has no `\lean{...}` hint. This lemma is used by
    `thm:rel_pic_addcommgroup_via_tensorobj` (one of the four active sorries) and is therefore
    on the prover's critical path. Without a Lean target name, the prover cannot discharge the
    obligation. Expected hint: something like
    `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorFunctor}` (or whatever the prover
    coins). **must-fix-this-iter**
  - `lem:tensorobj_restrict_iso` proof-block `\uses{}` lists only
    `\uses{def:scheme_modules_tensorobj}` but the proof explicitly cites
    `lem:restrictscalars_ringiso_tensorequiv` as its H2-closed ingredient (Step 3). Missing
    reference in the proof-block `\uses{}`. Fix: add
    `lem:restrictscalars_ringiso_tensorequiv` to that proof block. **must-fix-this-iter**
  - (informational) `lem:tensorobj_assoc_iso` prose lists the two applications of the
    restriction-compatibility iso in the first arrow in reverse logical order. A prover will
    resolve the ambiguity, but a writer pass could clarify.

---

## Severity summary

**must-fix-this-iter (3 findings):**

1. **Circular `\uses{}` dependency**: `lem:restrictscalars_ringiso_tensorequiv` \→
   `lem:tensorobj_restrict_iso` is logically backwards. Remove the `\uses{lem:tensorobj_restrict_iso}`
   from `lem:restrictscalars_ringiso_tensorequiv`; add `lem:restrictscalars_ringiso_tensorequiv` to
   `lem:tensorobj_restrict_iso`'s proof-block `\uses{}`.

2. **Missing proof-block `\uses{}` reference**: `lem:tensorobj_restrict_iso` proof block omits
   `lem:restrictscalars_ringiso_tensorequiv` from `\uses{}` despite naming it as a load-bearing
   ingredient in the proof body.

3. **Missing `\lean{...}` hint**: `lem:pullback_compatible_with_tensorobj` has no Lean target
   specified; the lemma is on the critical path of `thm:rel_pic_addcommgroup_via_tensorobj`.

**Overall verdict**: `Picard_TensorObjSubstrate.tex` is `complete: partial / correct: true`.
The chapter's mathematics is sound and the five directive checks pass on content, but three
blueprint-metadata errors (one circular `\uses{}` graph cycle, one missing `\uses{}` in a
proof block, one missing `\lean{}` hint) block the hard gate. These are all one-line writer
fixes; a same-iter re-review after correction should clear the gate.
