# blueprint-writer — tsfix207

Update ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
The lane (A.1.c.SubT) builds the line-bundle tensor group law; its critical
lemma `lem:tensorobj_restrict_iso` had its proof sketch flagged NOT FORMALIZABLE
as written (lean-vs-blueprint-checker ts-iter206, must-fix F1) plus four scope
mismatches (M2–M4). An iter-207 mathlib-analogist consult (`analogies/mate207.md`)
fully re-derived the correct route. Apply the fixes below. Do NOT touch any
`\leanok`/`\mathlibok` markers (managed elsewhere).

## FIX 1 (must-fix F1) — rewrite the proof of `lem:tensorobj_restrict_iso` (currently chapter L361–395) AND replace the stale `% NOTE` at L334.

The current proof claims the iso follows from "elementary flat-exactness already
in Mathlib" (`Module.Invertible.lTensor_bijective_iff` etc.). This is WRONG as a
route: `PresheafOfModules.pullback φ` is an abstract left adjoint with no
sectionwise formula, so there is no comparison MAP to apply flatness to until the
map is constructed. The corrected, formalizable route is a precise three-step
categorical construction (all citations verified this iter):

- **Step 1.** Reduce restriction-along-the-open-immersion `·|_f` to the abstract
  pullback `(PresheafOfModules.pullback φ.hom).obj ·` via the present lemma
  `Scheme.Modules.restrictFunctorIsoPullback`.
- **Step 2.** Move the pullback inside the sheafification via the present lemma
  `SheafOfModules.sheafificationCompPullback`
  (`sheafification ⋙ pullback φ ≅ PresheafOfModules.pullback φ.hom ⋙ sheafification`).
  (This corrects an older false claim that "sheafification does not commute with
  pullback" — it does, and the lemma is in Mathlib.)
- **Step 3 (the comparison map).** The base-change map
  `(pullback φ).obj (A ⊗ B) → (pullback φ).obj A ⊗ (pullback φ).obj B`
  is the oplax-monoidal comparison `δ` of the LEFT ADJOINT, obtained from the
  mate construction `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` — which
  ALREADY EXISTS in Mathlib (`Mathlib/CategoryTheory/Monoidal/Functor.lean`),
  applied to the present adjunction `PresheafOfModules.pullbackPushforwardAdjunction φ`
  (`pullback φ ⊣ pushforward φ`). Its hypothesis is `[(pushforward φ).LaxMonoidal]`.
- **Step 4 (iso for line bundles).** For line bundles (locally free rank one,
  hence flat) the oplax comparison `δ` is an isomorphism by ordinary tensor
  exactness (`Module.Flat.lTensor_preserves_injective_linearMap` + right-exactness;
  packaged as `Module.Invertible.lTensor_bijective_iff`). Note clearly that
  flatness enters HERE — upgrading the already-constructed `δ` to an iso — and is
  NOT a substitute for constructing the map (the iter-206 framing's error).
- Gluing: the affine/sectionwise isos are compatible and glue (`hom_ext`).

Then DELETE the stale `% NOTE (iter-206 review)` block at L334 and replace it
with a short, accurate `% NOTE` recording: the comparison map comes from the
already-present `leftAdjointOplaxMonoidal`; the SOLE remaining project-side
ingredient is the sectionwise lax instance of FIX 2 below; this is a bounded
`mathlib-build` target, not a multi-file wall.

## FIX 2 (must-fix F1, cont.) — add a new ingredient lemma block: the sectionwise lax-monoidal restrictScalars instance.

Insert a new `\begin{lemma} … \end{lemma}` (label `lem:restrictscalars_laxmonoidal`)
just before `lem:tensorobj_restrict_iso`, stating the SOLE genuine project-side
gap that Step 3 depends on, with this content:

- Statement: the presheaf-of-modules restriction-of-scalars functor
  `PresheafOfModules.restrictScalars φ` is lax monoidal, for `φ` a morphism of
  presheaves of commutative rings (CommRingCat-factored). Consequently, composing
  with the already-monoidal `pushforward₀OfCommRingCat` (Mathlib) via
  `Functor.LaxMonoidal.comp`, the full `pushforward φ := pushforward₀ F R ⋙
  restrictScalars φ` is lax monoidal — supplying the hypothesis
  `[(pushforward φ).LaxMonoidal]` that `leftAdjointOplaxMonoidal` needs.
- Proof sketch: this is a SECTIONWISE lift of the EXISTING Mathlib lemma that
  `ModuleCat.restrictScalars f` is lax monoidal
  (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`, itself the
  `rightAdjointLaxMonoidal` of `extendRestrictScalarsAdj`). The presheaf tensor
  product is sectionwise (`(M₁ ⊗ M₂).obj X = M₁.obj X ⊗ M₂.obj X`) and presheaf
  `restrictScalars φ` is sectionwise `ModuleCat.restrictScalars (φ.app X)`; so the
  lax structure maps `μ`, `ε` glue from the per-section ModuleCat ones together
  with naturality, assembled as a `Functor.CoreLaxMonoidal`. Estimated ~40–90 LOC.
  Setup constraint: state over CommRingCat-factored presheaves of rings; the
  project's `φ = (Scheme.Hom.toRingCatSheafHom f).hom` is commutative-ring-valued,
  so this holds.
- Do NOT add a `\lean{...}` pin (the Lean declaration does not exist yet — the
  prover will create it this iter; sync will add the pin/marker afterward).
- Add `\uses{def:scheme_modules_tensorobj}` and have `lem:tensorobj_restrict_iso`'s
  proof `\uses{lem:restrictscalars_laxmonoidal}`.

If you wish to cite the underlying classical fact (inverse image commutes with
tensor product, e.g. Hartshorne II.5 / Stacks 01CP-ish), you may dispatch a
reference-retriever (your write-domain authorizes `references/**`) and add a
`% SOURCE`/`% SOURCE QUOTE` per citation discipline — but this lemma is primarily
a Mathlib-formalization-route statement, so a source citation is optional.

## FIX 3 (major M2) — narrow `lem:scheme_modules_tensorobj_functoriality` (L207+).

The Lean target provides only the bifunctor morphism action `f ⊗ g`. The statement
currently also claims four natural isos λ, ρ, α, β are outputs of this lemma — they
have no Lean declarations and are off the critical path. Narrow the STATEMENT to the
bifunctor action only, and move the λ/ρ/α/β claims into a sentence pointing to
`rem:scheme_modules_monoidal_off_path` (off-critical-path, no current Lean decl).

## FIX 4 (major M3) — annotate `lem:tensorobj_lift_onproduct` (L536+).

The Lean target `tensorObjOnProduct` provides ONLY the operation-closure on the
subtype. Annotate the lemma that the unit-membership, dual/inverse, and group-law
existence-of-iso data are SEPARATE items, each blocked on `lem:tensorobj_restrict_iso`
(do not claim they are delivered by `tensorObjOnProduct`).

## FIX 5 (major M4) — blocking annotations on the four deferred blocks.

On each of `lem:tensorobj_assoc_iso` (L424), `lem:tensorobj_unit_iso` (L459),
`lem:tensorobj_comm_iso` (L480), `lem:pullback_compatible_with_tensorobj` (L587),
add a short `% NOTE: no Lean declaration yet; blocked on lem:tensorobj_restrict_iso
(which is blocked on lem:restrictscalars_laxmonoidal).` so the sequencing is explicit.

## Out of scope
- Do NOT rewrite unaffected sections (motivation, API survey, LOC estimates,
  consistency-check) beyond what the fixes above require.
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT touch other chapters.

If anything you write surfaces a strategy-level issue (e.g. the route is wrong),
put it under a "Strategy-modifying findings" section in your report and STOP.
