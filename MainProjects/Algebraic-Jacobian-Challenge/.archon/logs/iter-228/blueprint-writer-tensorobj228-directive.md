# blueprint-writer directive — tensorobj228

Chapter to edit: **`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`** (ONLY this chapter).

This chapter blueprints the ⊗-group-law substrate for `Pic_{C/k}`. We are building a
**d.2-FREE descent re-route** to close the project sorry `exists_tensorObj_inverse`. The deep
tensor-stalk-commutation gap ("d.2") is CONFIRMED avoided. Five edits this round, all aligning the
chapter with the current Lean state + giving the prover a precise mirror recipe. Each is precise
and bounded — do NOT speculate beyond what is listed.

## Context: the three descent bridges (for your prose, not to restate verbatim)

`exists_tensorObj_inverse` (every line bundle `L` has `L ⊗ L^{-1} ≅ 𝒪_X`) is discharged by gluing
the **canonical local contraction morphisms** `(L ⊗ L^{-1})|_U → 𝒪_U` (which, being canonical, agree
on overlaps) into a global morphism, then proving that global morphism is an isomorphism because it is
one locally. The three supporting bridges:
- **B-connector** `lem:isiso_of_isiso_restrict` (`isIso_of_isIso_restrict`) — locally-iso ⇒ global
  iso. CLOSED. Already in the chapter (L2776).
- **C-bridge** `lem:dual_isLocallyTrivial` — the dual of a line bundle is a line bundle, via the
  restrict-iso `(dual M).restrict f ≅ dual(M.restrict f)`.
- **A-bridge** `lem:sheafofmodules_hom_of_local_compat` (`homOfLocalCompat`) — compatible local
  module morphisms glue to a unique global one (the gluing engine producing the global contraction).

## Edit 1 — ADD a lemma block `lem:restrictscalars_ringiso_dualequiv` in `sec:tensorobj_dual_infra`

A new lemma block, the **dual analogue** of the existing `lem:restrictscalars_ringiso_tensorequiv`
(see it at ~L750 for the exact style/format to mirror). It pins the Lean declaration
`restrictScalarsRingIsoDualEquiv` (top-level, built axiom-clean iter-227). Mathematical content:

> For a ring isomorphism `e : R ≃+* S` and an `S`-module `M`, restriction of scalars along `e`
> carries the `S`-linear dual `M →ₗ[S] S` to the `R`-linear dual of the restricted module:
> `(M →ₗ[S] S) ≃ₗ[R] (M →ₗ[R] R)`, via `φ ↦ e.symm ∘ φ` (inverse `ψ ↦ e ∘ ψ`). The `R`-module
> structures on both sides are `M`'s `S`-structure pulled back along `e`.

Add `\lean{restrictScalarsRingIsoDualEquiv}`. State it as the **H2′ ingredient** of the C-bridge's
restrict-iso: it is to the dual / internal-hom exactly what `restrictscalars_ringiso_tensorequiv`
is to the tensor product. Give a short proof sketch (the two assignments are mutually inverse;
linearity follows from `e`/`e.symm` being inverse ring homs — the `r • m = e r • m` defeq makes both
linearity checks one rewrite each). No external source is needed (this is pure algebra, project-bespoke);
omit the `% SOURCE` lines.

## Edit 2 — ADD a short helper block for `Scheme.Modules.homMk` near `lem:sheafofmodules_hom_of_local_compat`

A brief lemma/definition block, pinned `\lean{AlgebraicGeometry.Scheme.Modules.homMk}`, describing
it as **A-bridge step (ii)**: the scheme-level thin wrapper that promotes an `𝒪_X`-linear morphism
of the underlying presheaves of abelian groups (`g : M.val.presheaf ⟶ N.val.presheaf` carrying a
sectionwise `𝒪_X`-linearity hypothesis) to a morphism `M ⟶ N` in `Scheme.Modules X`, by packaging
`PresheafOfModules.homMk`. Mention its `@[simp]` companion `toPresheaf_map_homMk`
(`(toPresheaf X).map (homMk g hg) = g`) in one line. Project-bespoke; omit `% SOURCE`.

## Edit 3 — EXPAND the proof sketch of `lem:dual_isLocallyTrivial` (~L2755) with the mirror recipe

This is THIS iter's PRIMARY prover target. The current proof sketch is mathematically fine but does
not name the formalization route. Expand it to state that the restriction-compatibility iso
`(dual M).restrict f ≅ dual(M.restrict f)` (for an open immersion `f`) is built as a **verbatim
mirror of the CLOSED `lem:tensorobj_restrict_iso`**, with `⊗` replaced by the internal-hom/dual:
- Steps reused verbatim from `tensorobj_restrict_iso`'s proof: reduce `restrict`→`pullback`
  (`restrictFunctorIsoPullback`); move the pullback inside sheafification
  (`sheafificationCompPullback`); strip the outer sheafification (`.mapIso`). (Both `dual M` and
  `tensorObj M N` are `sheafification.obj (presheaf-…)`, so these apply identically.)
- The presheaf residual closes by **H1** `pushforward β ≅ pullback φ`
  (`pushforwardPushforwardAdj` + `leftAdjointUniq`, reused VERBATIM) composed with **H2′**, the
  ring-iso/dual commutation along the open-immersion ring iso `f.appIso` — which is
  `lem:restrictscalars_ringiso_dualequiv` (Edit 1), the dual analogue of the tensor H2.
- Add one sentence: **no tensor stalk, no `M ◁ η` whiskering of the sheafification unit is ever
  invoked** — the comparison reduces to slice/`Over` reindexing under the open immersion (structural,
  not a stalk) plus the pure-algebra ring-iso/Hom commutation; `restrictScalars` along a ring iso is
  an equivalence, so it commutes with `Hom(-,-)` in both variances despite `dual` being contravariant.
- Keep the existing Stacks 01CR source quote.
Update the block's `\uses{}` to add `lem:restrictscalars_ringiso_dualequiv`.

## Edit 4 — EXPAND the proof sketch of `lem:sheafofmodules_hom_of_local_compat` (~L2823)

This iter's SECONDARY / next iter's primary. The current two-step sketch is correct but
under-specifies the Lean route and understates the size. Expand step (i) to name the recommended
path and the load-bearing sub-piece:
- Step (i) glues via `existsUnique_gluing` on the **hom-presheaf as a `TopCat.Sheaf` of types**:
  `presheafHom (M.val.presheaf) (N.val.presheaf)` is a sheaf via `Presheaf.IsSheaf.hom` (needs `N`'s
  sheaf condition), so a compatible family of local sections amalgamates uniquely. This is preferred
  over the raw `presheafHom_isSheafFor`/`sieve` amalgamation (strictly more bookkeeping).
- Name the load-bearing sub-piece explicitly: constructing, for each `i`, the **local section**
  `localSection i : (presheafHom …).obj (op (U i))` from `f_i`, whose component at `(V, h : V ⟶ U i)`
  is the `eqToHom`-conjugated `f_i` component (using `(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ V) = V` for `V ≤ U i`).
  Its **naturality field** — commuting the `eqToHom`-conjugated `f_i` components across `Over (U i)`
  morphisms — is the **only sub-piece carrying real coherence risk** (the cocycle/compatibility,
  the glue-and-convert to a genuine `F ⟶ G`, and the linearity-promotion via `homMk` follow more
  mechanically). The remaining four mechanical sub-steps: cocycle/`IsCompatible`; glue + convert the
  amalgamated section over `op ⊤` to an `F ⟶ G`; sectionwise linearity check; restriction-recovery.
- State the realistic size: **~120–190 LOC** (the engine is larger than a routine glue; flag this so
  the prover scopes it as a multi-piece build, not a one-shot). Recommend building `localSection`
  (with its naturality) as a standalone axiom-clean lemma FIRST.
Project-bespoke; no external source.

## Edit 5 — CORRECT `rem:dual_discharges_inverse` (~L2856) to the descent re-route

The remark currently describes discharging `exists_tensorObj_inverse` via a **global descended
evaluation `ε_L` taken from `lem:internal_hom_eval`** (the sheafified presheaf eval). That route is a
**confirmed DEAD END** — sheafifying the presheaf eval re-hits the `M ◁ η` whiskering = d.2 (this is
recorded in the Lean docstring of `exists_tensorObj_inverse` and in the project's analogies recipe).
Rewrite the remark so the global contraction `ε_L : L ⊗ L^{-1} → 𝒪_X` is instead built by **gluing
the canonical local contraction morphisms via `lem:sheafofmodules_hom_of_local_compat`** (the A-bridge):
on each trivialising open `U`, `lem:tensorobj_restrict_iso` carries `(L ⊗ L^{-1})|_U` to
`𝒪_U ⊗ 𝒪_U` and the canonical contraction to the left unitor `lem:tensorobj_unit_iso` (an iso);
these local contractions are canonical, hence agree on overlaps and glue (A-bridge) to a global
`ε_L`; being an iso is local, so `ε_L` is a global iso by `lem:isiso_of_isiso_restrict` (B-connector).
- Replace the `\uses{}`: drop `lem:internal_hom_eval`; add `lem:sheafofmodules_hom_of_local_compat`
  and `lem:isiso_of_isiso_restrict`. Keep `lem:dual_isLocallyTrivial`, `lem:tensorobj_restrict_iso`,
  `lem:tensorobj_unit_iso`, `lem:tensorobj_inverse_invertible`.
- Add one sentence noting this descent construction avoids the forbidden sheafify-the-eval route and
  computes no tensor stalk.

## Out of scope (do NOT touch)

- Do NOT add/remove any `\leanok` or `\mathlibok` marker (managed by the deterministic sync / review).
- Do NOT touch the vestigial whiskering/stalk apparatus blocks (`lem:islocallyinjective_whisker_of_W`
  etc.) or any block outside the five edits above.
- Do NOT delete `lem:internal_hom_eval` itself — only re-route the remark away from depending on it
  for the inverse.
