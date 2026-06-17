# Blueprint Writer Directive — Picard_TensorObjSubstrate.tex (flat/line-bundle pivot)

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (ONLY this file).

## Strategy context (the slice that matters)
A mathlib-analogist api-alignment audit (iter-206, persistent rationale at
`analogies/ts-design206.md` — READ IT FIRST, in full) found that this
chapter's current substrate is **over-built**. The chapter currently routes
the relative Picard group law through a FULL symmetric
`MonoidalCategory (Scheme.Modules X)` instance on ALL quasi-coherent
modules (`thm:scheme_modules_monoidal`), whose only remaining gap is a
verified-absent Mathlib instance `MonoidalClosed (PresheafOfModules R₀)`
(needed for `whiskerLeft` stability of the sheafification-localizing
morphism property, for an ARBITRARY module `F`). That is a multi-file
Mathlib-PR-scale dead-end and must NOT be the chapter's route.

**The corrected mathematics**: the relative Picard group law is the group
of isomorphism classes of LINE BUNDLES under tensor. The group axioms on
iso-classes are *propositions* (`Nonempty (… ≅ …)`): they need NO monoidal
coherence (pentagon/triangle/hexagon) and NO closed structure. They need
exactly four existence-of-iso facts on line bundles — associativity
`(L⊗M)⊗N ≅ L⊗(M⊗N)`, unit `O_X⊗L ≅ L`, commutativity `L⊗M ≅ M⊗L`, and
inverse `L⊗L⁻¹ ≅ O_X` — plus well-definedness on iso-classes. The single
genuinely-hard ingredient is the *global* compatibility iso
`tensorObj_restrict_iso` (local triviality alone does NOT give a global
associator — two sheaves locally `≅ O` need not be globally iso, cf.
`O(1)` vs `O`); but for LINE BUNDLES, which are flat, this reduces to
**elementary flat-exactness**, NOT internal-hom machinery.

This mirrors Mathlib's own Picard group `CommRing.Pic R` (in
`Mathlib.RingTheory.PicardGroup`): `CommGroup` transported from
`Units (Skeleton (ModuleCat R))` over a *fixed* ring, with the Prop
invertibility carrier `Module.Invertible R M` — which this project's
`IsLocallyTrivial` already mirrors verbatim (see
`LineBundlePullback.lean:106`). Mathlib's `CommRing.Pic` uses
`ModuleCat.monoidalCategory`/`SymmetricCategory` and needs NO
sheafification, NO localization, NO `MonoidalClosed`.

## Required edits (rewrite, do not just append)

1. **Demote/replace `thm:scheme_modules_monoidal`** (the global
   `MonoidalCategory (Scheme.Modules X)` instance, L271–335). The global
   monoidal-category instance on all modules is NO LONGER on the critical
   path and must not be presented as the substrate the group law rests on.
   Replace its body (especially the "Concrete Mathlib realisation"
   paragraph L310–335 that invokes `MorphismProperty.IsMonoidal W` /
   `CategoryTheory.Localization.Monoidal` / the implicit
   `MonoidalClosed`) with the flat-scoped account. Either (preferred)
   convert it into a remark that the full all-modules monoidal category is
   NOT required and is explicitly off the critical path (with one sentence
   on why: coherence is never consumed by a group law on iso-classes), OR
   restate the theorem so its content is only "the line-bundle subcategory
   carries the iso-level operations" — your call, but the chapter must no
   longer claim the group law DEPENDS on a global `MonoidalCategory`/
   `MonoidalClosed`.

2. **Introduce the key ingredient `tensorObj_restrict_iso`, flat-scoped.**
   Add a lemma block (give it a `\label` like
   `lem:tensorobj_restrict_iso`, no `\lean{}` pin unless you are certain of
   the final Lean name — leave it unpinned and note the target name
   `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` in prose):
   for line bundles (equivalently flat modules) `L, M` and an open
   immersion / restriction `f`, the canonical map
   `(L ⊗_X M)|_f ≅ L|_f ⊗ M|_f` is an isomorphism, BECAUSE flat ⇒ `lTensor`
   preserves injectivity (`Module.Flat.lTensor_preserves_injective_linearMap`,
   packaged in Mathlib as `Module.Invertible.lTensor_bijective_iff`,
   `Mathlib.RingTheory.PicardGroup`) and `⊗` is always right-exact (preserves
   surjectivity). State explicitly that this is the elementary flat-exactness
   replacement for the deleted `MonoidalClosed`/`IsMonoidal W` route, and that
   `Module.Invertible R M ⇒ Module.Projective ⇒ flat` (PicardGroup.lean
   `instProjectiveOfInvertible`) makes the flatness automatic for line
   bundles.

3. **State the four existence-of-iso group-law lemmas on line bundles**
   (associativity, unit `O_X⊗L≅L`, commutativity, inverse — the inverse is
   already `lem:tensorobj_inverse_invertible`, keep it). Each is a
   `Nonempty (… ≅ …)`-style existence statement assembled from
   `tensorObj_restrict_iso` on a common trivialising cover. Make explicit
   that these four facts (not a `MonoidalCategory` instance) are what the
   group structure consumes.

4. **Rewrite the proof of `thm:rel_pic_addcommgroup_via_tensorobj`**
   (L562–602) so the group axioms are derived from the four
   existence-of-iso lemmas (propositions on iso-classes), NOT from
   "the monoidal-category axioms of `thm:scheme_modules_monoidal`
   (pentagon, triangle, hexagon coherence)". Keep the `QuotientAddGroup`
   assembly. Cite the Mathlib idiom alignment: the construction mirrors
   `CommRing.Pic = Units (Skeleton …)` / `instCommGroupPic`, transported to
   the scheme-level line-bundle subcategory (scheme Pic is genuinely absent
   from Mathlib — PicardGroup.lean TODO lists "connect to invertible
   sheaves" as unbuilt — so the project supplies it lightly).

5. **Update the Mathlib API survey (§`sec:tensorobj_api_survey`) and
   motivation** so the recorded "gap" is the flat-scoped
   `tensorObj_restrict_iso` (elementary, Mathlib-backed) rather than a
   global monoidal-category lift. Remove the framing that a global
   `MonoidalCategory`/`MonoidalClosed` on all modules is the missing piece.

6. **Update the LOC/sequencing section (§`sec:tensorobj_loc_estimates`)**:
   Piece 2 is no longer "discharge pentagon/triangle/hexagon"; it is
   "flat-scoped `tensorObj_restrict_iso` + the four iso lemmas". Re-estimate
   honestly (this is LIGHTER than the deleted route — likely ~80–150 LOC for
   the whole substrate, not 200–320).

## Keep unchanged
- The existing Kleiman §2 `% SOURCE:`/`% SOURCE QUOTE:` blocks (df:aPf,
  df:Pfs) — they remain the correct math source for the group-valued
  relative Picard functor. Preserve them verbatim.
- `lem:tensorobj_preserves_locally_trivial`, `lem:tensorobj_inverse_invertible`,
  `lem:tensorobj_lift_onproduct`, `lem:pullback_compatible_with_tensorobj`,
  `def:scheme_modules_tensorobj`, `lem:scheme_modules_tensorobj_functoriality`
  — these are already line-bundle-correct; adjust their proof prose only
  where it appeals to the deleted global coherence.
- `IsLocallyTrivial` as the `Module.Invertible`-shaped Prop predicate.

## Out of scope (do NOT touch)
- Any other chapter. Representability (A.2.c), identity component (A.3),
  Albanese (A.4) framing stays as-is.
- Do NOT add or remove `\leanok` or `\mathlibok` markers anywhere — markers
  are managed by the deterministic `sync_leanok` phase and the review
  agent, not by you.
- Do NOT introduce a `MonoidalClosed`/`IsMonoidal W` discharge plan; that
  route is explicitly rejected.

## References
- `analogies/ts-design206.md` (the design rationale — primary input).
- Mathlib: `Mathlib.RingTheory.PicardGroup` (`CommRing.Pic`,
  `instCommGroupPic`, `Module.Invertible`,
  `Module.Invertible.lTensor_bijective_iff`, the Projective/flat instances);
  `Mathlib.Algebra.Category.ModuleCat.Monoidal.{Basic,Symmetric}`;
  `Module.Flat.lTensor_preserves_injective_linearMap`. You may verify these
  via the Lean LSP. If you need a math source not already in `references/`,
  a child reference-retriever is authorized (Stacks 01CR is the Picard-group
  reference and is already cited in the chapter).
