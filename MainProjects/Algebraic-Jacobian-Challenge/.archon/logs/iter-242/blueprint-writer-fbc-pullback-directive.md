# Blueprint-writer directive — slug `fbc-pullback`

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — ONLY this chapter.

## Strategy context (the slice that matters)
Engine lane A.2.c (flat base change, Stacks 02KH, `i=0`). The affine case
`lem:affine_base_change_pushforward` (`g^*(f_*F) ≅ f'_*((g')^*F)` for affine `f`, quasi-coherent `F`)
reduces — by full-faithfulness of `tilde` and the locality criterion — to a concrete `R'`-linear map,
which closes via the cancellation isomorphism `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`
(`TensorProduct.AlgebraTensorModule.cancelBaseChange`, in Mathlib, no flatness).

The pushforward half of the affine dictionary, `lem:pushforward_spec_tilde_iso`
(`(Spec φ)_* M̃ ≅ (restr_φ M)~`), is now CLOSED (iter-241, axiom-clean). The remaining gaps for
`affineBaseChange_pushforward_iso` (per `informal/affineBaseChange_pushforward_iso.md` and the
lean-vs-blueprint checker) are exactly two, and the affine-base-change proof sketch is currently
under-specified for them. Three edits.

## EDIT A — add the pullback-of-tilde dictionary lemma

Add a new `\begin{lemma} ... \end{lemma}` block, the PULLBACK companion of `lem:pushforward_spec_tilde_iso`:

- `\label{lem:pullback_spec_tilde_iso}`
- `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}`
- Statement: for a ring homomorphism `φ : R → R'` and an `R`-module `M`, the pullback of the
  quasi-coherent sheaf `M̃` along `Spec φ : Spec R' → Spec R` is canonically isomorphic, as a
  `(Spec R')`-module, to the tilde of the base-changed module:
  `(Spec φ)^* (M̃) ≅ (R' ⊗_R M)~`. Natural in `M`.
- Source: this is the affine pullback case of "tilde commutes with pullback" — Stacks Project,
  Schemes, the lemma computing `f^*` of a quasi-coherent sheaf on affines as base change of modules
  (the pullback companion of the pushforward formula; Stacks tag for `widetilde` + pullback,
  `schemes-lemma-widetilde-pullback`). Provide the `% SOURCE` + verbatim `% SOURCE QUOTE` from the
  Stacks Schemes source. If that source file is not yet under `references/`, dispatch a child
  reference-retriever (authorized via your `references/**` write-domain) to fetch the Stacks Schemes
  chapter, then quote it verbatim. Do NOT write a `% SOURCE QUOTE` from memory.
- Proof sketch: mirror the construction of `lem:pushforward_spec_tilde_iso` / the global-sections
  dictionary — pullback along `Spec φ` is extension of scalars `— ⊗_R R'` on modules, transported
  through the `tilde` / `moduleSpecΓ` equivalence; the base-changed module `R'⊗_R M` is the global
  sections of the pulled-back sheaf, and the comparison is the universal property of base change.

## EDIT B — expand the proof of `lem:affine_base_change_pushforward`

The current proof sketch (under `\begin{proof}` with the "First reduction (locality) / reduction to a
concrete module map via full-faithfulness / identification of the concrete map" structure) correctly
names the strategy but is UNDER-SPECIFIED for the two open obligations. Expand the "Identification of the
concrete map" part to make explicit:

1. **The pullback-of-tilde dictionary** (`lem:pullback_spec_tilde_iso`, EDIT A) is what identifies
   `(g')^* F = (g')^*(M̃)` over the affine chart as `((R'⊗_R A) ⊗_A M)~`, i.e. the tilde of the
   `(R'⊗_R A)`-module `(R'⊗_R A) ⊗_A M` — and dually `g^*(f_* F)` via the pushforward dictionary
   `lem:pushforward_spec_tilde_iso`.
2. **The identification of `pushforwardBaseChangeMap.app U` with `cancelBaseChange`.** The base-change map
   `pushforwardBaseChangeMap` is constructed abstractly as an adjoint mate (transpose under the
   `pullback ⊣ pushforward` adjunctions); on sections over the affine chart, under the two dictionaries
   above, it is identified with the canonical `R'`-linear comparison between the two iterated tensor
   products, i.e. `TensorProduct.AlgebraTensorModule.cancelBaseChange : (R'⊗_R A)⊗_A M ≅ R'⊗_R M`. State
   that this identification (matching an abstract adjoint-mate with the concrete `cancelBaseChange`) is the
   crux of the remaining Lean work, and that once made the affine case closes with no flatness.

Add `lem:pullback_spec_tilde_iso` (and `lem:pushforward_spec_tilde_iso` if not already) to this proof
block's `\uses{...}`.

## EDIT C — clear the dangling `lem:gammaPushforwardIsoAt_naturality`

The block `\label{lem:gammaPushforwardIsoAt_naturality}` (the "Naturality in the open of the
affine-pushforward section comparison") has no `\lean{}` pin; its content was proved INLINE inside
`pushforward_spec_tilde_iso` (the `hsq` step, `ext x; rfl`). To stop it dangling: demote it to an
unlabelled prose remark inside the proof of `lem:gammaPushforwardIsoAt` (stating that the family `{e_U}`
is natural in the open, each `e_U` being a composite of structure-sheaf-restriction and identity-on-carrier
`restrictScalars` repackagings), and REMOVE `lem:gammaPushforwardIsoAt_naturality` from the `\uses{...}`
of `lem:pushforward_spec_tilde_iso`'s proof block. (The pre-existing `% NOTE:` comment about this block
may be removed once the block is demoted.)

## Out of scope
- Do NOT touch `thm:flat_base_change_pushforward` / `flatBaseChange_pushforward_isIso` (deep Čech, deferred).
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT alter the already-closed `lem:pushforward_spec_tilde_iso` statement or its (now single-line)
  `\uses{}` other than removing the `lem:gammaPushforwardIsoAt_naturality` entry per EDIT C.
