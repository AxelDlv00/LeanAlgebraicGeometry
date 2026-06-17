# Blueprint Writer Directive — rewrite `sec:tensorobj_pullback_monoidality`

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope (ONLY this section)
Section `sec:tensorobj_pullback_monoidality` (currently ~L2564–L2786), comprising:
- the section intro paragraph (L2567–2589),
- `lem:pullback_tensor_iso` statement + proof (L2591–2680),
- `lem:pullback_unit_iso` statement + proof (L2682–2722),
- `lem:isinvertible_pullback` statement + proof (L2724–2786).

Do NOT touch any other section of the chapter.

## Why this rewrite (the route pivoted)
The current proof sketches for `lem:pullback_tensor_iso` and `lem:pullback_unit_iso`
describe a **route that cannot be formalized** and must be replaced. The iter-239
prover and two iter-240 audits (lean-vs-blueprint-checker-tensorobjsubstrate;
mathlib-analogist `pullback-monoidal`, persistent file `analogies/pullback-monoidal.md`)
established, with live LSP verification:

1. **`(Presheaf|Sheaf)OfModules.pullback` is an ABSTRACT left adjoint**
   (`(pushforward _).leftAdjoint`) with **no sectionwise and no stalkwise value
   formula** in Mathlib at the pinned commit. So the current Step 2 ("the presheaf
   pullback is, sectionwise, extension of scalars; assemble the sectionwise
   `extendScalars` tensorators") **cannot typecheck** — there is no sectionwise
   `(pullback φ).obj` to attach an `extendScalars` tensorator to.
2. **`Adjunction.leftAdjointOplaxMonoidal` does NOT exist.** Mathlib has only
   `Adjunction.rightAdjointLaxMonoidal` (the opposite direction). So the oplax
   comparison maps on the left-adjoint pullback are **not free**; an
   `OplaxMonoidal` structure on `pullback` must be constructed.
3. There is **no Mathlib pullback tensorator** (`pullbackObjTensorToTensor` does
   not exist) and **no `MonoidalCategory (SheafOfModules R)`** (the abstract
   `Sheaf.monoidalCategory` is only for a fixed value category, not modules over a
   varying ring).

The **Stacks statements remain the correct targets** — keep the `% SOURCE` /
`% SOURCE QUOTE` / `\textit{Source: …}` blocks verbatim for all three lemmas
(`lemma-tensor-product-pullback`, `lemma-pullback-invertible`). Only the PROOF
METHOD prose changes.

## The new route to write — Route Z (local-chart finality), TWO phases

Rewrite the section intro and the two sub-lemma proofs to describe **Route Z**.
The mathematical content (read `analogies/pullback-monoidal.md` for the exact
Mathlib citations the writer should weave in as `\texttt{…}` names):

**Phase 1 — `lem:pullback_unit_iso` (`f^*𝒪_X ≅ 𝒪_Y`), the cheap half.**
This is reachable directly. The canonical Mathlib map
`SheafOfModules.pullbackObjUnitToUnit f` (the `f^*𝒪_X → 𝒪_Y` comparison) is an
isomorphism whenever the comparison functor is `Final` — Mathlib instance
`SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal`. This is exactly the `i7`
step already used inside the project's axiom-clean `IsLocallyTrivial.pullback`
(`AlgebraicJacobian/Picard/LineBundlePullback.lean:156-193`). For a GENERAL `f`,
`pullbackObjUnitToUnit f` is checked to be an iso by reduction to local charts:
on an affine chart `V ⊆ Y`, factor `V.ι ≫ f` through `g = f.resLE U V` (whose
`Opens.map g.base` is `Final` via `final_of_representablyFlat`), so the restricted
comparison matches `pullbackObjUnitToUnit g` which IS an iso by the Final instance;
globalize "iso on every chart ⇒ global iso" via the project's axiom-clean
`isIso_of_isIso_restrict` (`Picard/TensorObjSubstrate.lean:567`). The naturality
glue (`pullbackComp`, `pullbackId`, `restrictFunctorIsoPullback`, `pullbackCongr`)
is the same chain already wired in `IsLocallyTrivial.pullback`. State this as the
proof; note the small remaining work is the naturality lemma tying the
restricted global `pullbackObjUnitToUnit` to the local one.

**Phase 2 — `lem:pullback_tensor_iso` (`f^*(M⊗N) ≅ f^*M ⊗ f^*N`), the real gap.**
There is no Mathlib tensorator on `pullback`, so the comparison map must be built.
Describe the route: (a) construct a `pullbackObjTensorToTensor` comparison
`f^*(A⊗B) → f^*A ⊗ f^*B` (the analogue of `pullbackObjUnitToUnit`); (b) prove it
is an isomorphism by the SAME finality chart-chase as Phase 1 — on a Final local
chart the pullback is locally extension-of-scalars, which IS strong monoidal in
`ModuleCat`, so the local comparison is the `extendScalars` tensorator (an iso),
and `isIso_of_isIso_restrict` globalizes; (c) package strong monoidality via the
Mathlib oplax⇒strong wrapper `Functor.CoreMonoidal.ofOplaxMonoidal` (which takes
`[IsIso η]` and `[∀ X Y, IsIso (δ X Y)]` and yields `Monoidal`, with `μIso`/`εIso`
delivering the comparison isos). Note that producing the `OplaxMonoidal` structure
on `pullback` is itself non-free (no `leftAdjointOplaxMonoidal`) — it is built as
the mate of `pushforward`'s lax structure, or directly from the presheaf
pullback's concrete extension-of-scalars description on charts. Record that the
already-landed private brick `sheafifyTensorUnitIso`
(`Picard/TensorObjSubstrate.lean ~L884`, "sheafification is monoidal up to the
unit") is the RHS reconciliation the eventual `pullbackTensorIso` consumes after
moving the pullback inside sheafification via `SheafOfModules.sheafificationCompPullback`.

**`lem:isinvertible_pullback` (the Stacks composite) — KEEP essentially as is.**
Its proof composes `pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso` on the existing
witness — that is correct and matches the verbatim Stacks proof quote already in
the file. Leave the statement, `\uses`, SOURCE blocks, and the composite proof
intact. (Only adjust surrounding prose if it references the dead "extendScalars
sectionwise" framing.)

## Also note in the intro
- The section intro currently argues "the general case uses the LEFT adjoint
  extendScalars which is strong monoidal sectionwise for any ring map." Replace
  this framing: the left-adjoint pullback has no sectionwise formula, so the
  monoidality is proven by **local-chart finality** (charts where the pullback IS
  locally extension-of-scalars), not by a global sectionwise tensorator. Keep the
  correct high-level point that this is a genuinely separate fact from the
  open-immersion `lem:tensorobj_restrict_iso`.
- Add a short note that a **FLAT-restricted** `IsInvertible.pullback` is an
  available fallback if the general Phase-2 build proves intractable: the RPF
  structure maps (projection `π_T`, base changes) are all flat. (One sentence;
  this is a recorded reversing-signal fallback, not the primary route.)

## Hard constraints
- This is an Archon-original proof METHOD (the Stacks proof is by abstract
  pullback-monoidality; our formalization route is local-chart finality). Keep the
  Stacks `% SOURCE`/`% SOURCE QUOTE` blocks (they cite the STATEMENTS, which are
  unchanged); the proof prose is the project's restatement of the formalization
  route and needs no new external source.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed by sync_leanok /
  review). Keep the existing `\lean{}` pins on all three lemmas.
- Prose must be mathematical, not Lean tactics. Mathlib names may appear as
  `\texttt{…}` identifiers (e.g. `\texttt{CoreMonoidal.ofOplaxMonoidal}`), as the
  existing blueprint does.
- Read `analogies/pullback-monoidal.md` first for the precise Mathlib citations.
