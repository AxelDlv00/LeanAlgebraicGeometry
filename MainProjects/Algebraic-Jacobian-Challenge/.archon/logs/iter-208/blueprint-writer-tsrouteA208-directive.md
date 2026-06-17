# Blueprint-writer directive — iter-208 — chapter `Picard_TensorObjSubstrate.tex`

## Scope (one chapter only)

Edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Rewrite the
proof (and correct the statement prose + `% NOTE`s) of **`lem:tensorobj_restrict_iso`**
to a new, formalizable route. Touch the neighbouring `lem:restrictscalars_laxmonoidal`
and the `\uses{}` edges only as specified below. Do NOT alter any other lemma's
math content.

## Why this rewrite (context)

The chapter's current proof of `lem:tensorobj_restrict_iso` is the
"abstract-adjoint mate-δ" route: it builds the comparison map as the oplax δ of
`Adjunction.leftAdjointOplaxMonoidal` applied to
`pullbackPushforwardAdjunction φ`, with sole hypothesis
`(pushforward φ).LaxMonoidal` (supplied by `lem:restrictscalars_laxmonoidal`).
**This route is definitively dead.** Over four prover iters it was disproven:
the comparison reduces to `(PresheafOfModules.pullback φ).Monoidal` (strong
monoidal lift of `ModuleCat.extendScalars`), which is **absent from Mathlib**
and is a multi-file build; additionally the scheme ring presheaf is
`RingCat`-valued (no monoidal structure) while `tensorObj` uses the
`CommRingCat`-valued `X.presheaf`, a ring-layer mismatch. The iter-207
`restrictScalarsLaxMonoidal` instance was built axiom-clean but does NOT unblock
the iso. A read-only Mathlib API consult (analogist tsroute208,
`analogies/tsroute208.md`) found the bounded, idiomatic re-route below.

## The new route to write (Route A — open-immersion sectionwise base change)

**Key mathematical fact.** The map `f : U ↪ X` is an **open immersion**. Along an
open immersion, restriction of `𝒪_X`-modules is *definitionally sectionwise*:
`Γ(M.restrict f, V) = Γ(M, f ''ᵁ V)` (the Lean lemmas
`Scheme.Modules.restrict_obj` / `restrict_map` are `rfl`). The comparison of
structure-sheaf rings over the image is the **isomorphism** `f.appIso`
(`Γ(Y, f ''ᵁ V) ≅ Γ(X, V)`, a `CommRingCat` iso,
`AlgebraicGeometry.Scheme.Hom.appIso`). Therefore "extension of scalars" along
the open immersion is **base change along a ring isomorphism**, which is
trivially an isomorphism — and crucially it commutes with tensor products,
because base change along a ring iso is a monoidal equivalence
(`ModuleCat.restrictScalarsEquivalenceOfRingEquiv`). **No `extendScalars`
monoidality, no strong-monoidal pullback instance is needed.** The statement is
in fact true for **arbitrary** `M, N : X.Modules` — local-freeness / line-bundle
hypotheses are NOT required (the δ-route over-paid by routing through flatness).

**Statement block changes.** The Lean signature is unchanged (it already takes
arbitrary `M N : X.Modules` with `[IsOpenImmersion f]` and no `IsLocallyTrivial`
hypothesis — keep `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}`).
Correct the prose: state the result for arbitrary `M, N` (drop "let L, M be line
bundles, hence flat" — replace with "let `M, N : Scheme.Modules X` be arbitrary
`𝒪_X`-modules"). Remove the two stale `% NOTE` blocks (the iter-207 "δ-route /
sole ingredient" notes and the "comparison map is the oplax δ" note); they
describe the dead route. Replace `\uses{def:scheme_modules_tensorobj,
lem:restrictscalars_laxmonoidal}` with `\uses{def:scheme_modules_tensorobj}` —
the new proof does NOT use the lax-monoidal lemma.

**Proof block to write (rigorous, textbook-level, in project notation; NO Lean
tactics):**

- *Step 1 (reduce restriction to the abstract pullback).* Unchanged in spirit:
  restriction `(-)|_f` along the open immersion `f` is naturally isomorphic to
  the presheaf-of-modules pullback `(PresheafOfModules.pullback φ.hom).obj(-)`
  via the present `Scheme.Modules.restrictFunctorIsoPullback`. (Here `φ` is the
  `RingCat`-level structure-sheaf morphism induced by `f`.)

- *Step 2 (move the pullback inside the sheafification).* Unchanged: `⊗_X` is
  sheafification of the presheaf-level tensor product
  (`def:scheme_modules_tensorobj`); pullback commutes with sheafification
  (`SheafOfModules.sheafificationCompPullback`). The question descends to the
  presheaf-level base-change comparison
  `(pullback φ).obj(A ⊗ B) ≅ (pullback φ).obj A ⊗ (pullback φ).obj B`.

- *Step 3 (NEW — sectionwise identification along the open-immersion ring iso).*
  This replaces the dead "mate-δ" Step 3 and Step 4. The presheaf functor
  `PresheafOfModules.pullback φ.hom` is abstractly the left adjoint of pushforward
  and is *opaque* on objects/morphisms in Mathlib. The bounded missing ingredient
  is a **sectionwise unfolding**: for the open-immersion ring morphism `φ`,
  `(pullback φ.hom).obj P` is, section-by-section over an open `V`, the base
  change of `P`'s sections along the *ring isomorphism* induced by `f.appIso`
  (restriction of sections combined with scalar transport along the iso). Granting
  this sectionwise description, the base-change comparison is, on each section,
  the canonical map
  `(S ⊗_{appIso} R) ⊗ ...` — base change of a tensor product along a ring
  isomorphism — which is an isomorphism and commutes with `⊗` by
  `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (base change along a ring iso
  is a monoidal equivalence). Assemble the sectionwise isomorphisms into a
  presheaf isomorphism via `PresheafOfModules.isoMk` (sections agree definitionally
  by `restrict_obj`, scalar rings identified by `f.appIso`). The blueprint should
  state explicitly that the one genuinely-new project-side ingredient is this
  sectionwise unfolding of `pullback φ.hom` along an open immersion (no Mathlib
  presheaf-level analogue of `restrictFunctorIsoPullback` exists; it is a bounded
  ~30–60 LOC helper, with direct precedent in
  `analogies/kaehler-tensorequiv-presheafpullback.md` Decision 5, which closed an
  identical `pullback`-opacity gap).

- *Gluing.* The sectionwise isomorphisms are natural in `V` (compatible with
  restriction maps), so `PresheafOfModules.isoMk` yields the presheaf iso;
  transport back through Steps 1–2 (and the sheafification units) gives the
  global `(M ⊗_X N)|_f ≅ M|_f ⊗_U N|_f`.

State that this route needs no monoidal structure on `SheafOfModules`/pullback,
no flatness, and no line-bundle hypothesis.

## `lem:restrictscalars_laxmonoidal` — demote to off-path supplement

The review added `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` to this
lemma last iter (keep that pin — the Lean instance is real and axiom-clean). But
it is **no longer load-bearing** for `lem:tensorobj_restrict_iso` (the new Route
A does not use it). Update its prose: remove any claim that it is "the sole
remaining ingredient" for the tensor-restriction iso; add one sentence noting it
is a self-contained CommRingCat-level lax-monoidal supplement, retained for
potential reuse but **off the critical path** for the tensor group law. Do NOT
delete the block.

## Out of scope (do NOT touch)

- The downstream lemmas `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`,
  `lem:tensorobj_comm_iso`, `lem:tensorobj_inverse_invertible`,
  `lem:tensorobj_lift_onproduct`, `lem:tensorobj_preserves_locally_trivial` —
  their `\uses{lem:tensorobj_restrict_iso}` edges are correct and stay. Do not
  rewrite their proofs.
- `def:scheme_modules_tensorobj`, `lem:scheme_modules_tensorobj_functoriality`.
- No `\leanok` / `\mathlibok` markers (managed by sync/review).

## References

This is substrate plumbing (tensor commutes with open restriction), an
Archon-bespoke construction built from Mathlib primitives — no external
mathematical source (Kleiman/Milne/etc.) is being cited, so no `% SOURCE` /
`% SOURCE QUOTE` blocks are required for the rewritten proof. If you nonetheless
find you need a textbook reference for "base change along a ring iso commutes
with tensor", you may spawn the reference-retriever (your write-domain includes
`references/**`), but this is not expected.
